import 'package:assignment/app/modules/home/bindings/user_data.dart';
import 'package:assignment/app/services/api_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;
  var users = <Datum>[].obs;
  var isLoading = true.obs;
  var pickedImage = Rxn<String>();
  final ImagePicker _picker = ImagePicker();
  final _box = Hive.box('user_data');

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchUsers().then((_) {
      loadLocalAvatars();
    });
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final userData =
          await ApiService.fetchUser('https://reqres.in/api/users?page=2');
      users.value = userData.data ?? [];
      loadLocalAvatars();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadLocalAvatars() {
    for (int i = 0; i < users.length; i++) {
      final localAvatarPath = _box.get('avatar_$i');
      if (localAvatarPath != null) {
        users[i].avatar = localAvatarPath;
      }
    }
    users.refresh();
  }

  Future<void> pickImage(int index, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final path = pickedFile.path;
      _box.put('avatar_$index', path);
      users[index].avatar = path;
      users.refresh();
    }
  }

  void getCurrentLocation() async {
    try {
      // Request permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied.');
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        address.value =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
      print('@@@@@@${e.toString()}');
    }
  }
}
