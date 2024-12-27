import 'dart:io';

import 'package:assignment/app/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MobileHomeViewWidget extends GetView<HomeController> {
  const MobileHomeViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'iGuru Assignment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.yellow.shade100),
            child: Obx(
              () {
                if (controller.address.value.isEmpty) {
                  return const Center(
                    child: Text(
                      'Fetching....',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Latitude:${controller.latitude.value}'),
                      Text('Longitude:${controller.longitude.value}'),
                      Text('Address:${controller.address.value}'),
                    ],
                  );
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              'User Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.users.isEmpty) {
              return const Center(child: Text("No users found"));
            }
            return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                            child: kIsWeb
                                ? CachedNetworkImage(
                                    imageUrl: user.avatar ?? "",
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : user.avatar != null &&
                                        File(user.avatar!).existsSync()
                                    ? Image.file(
                                        File(user.avatar ?? ""),
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: user.avatar ?? "",
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )),
                      ),
                      title: Text('${user.firstName ?? ""} ${user.lastName}'),
                      subtitle: Text(user.email ?? ""),
                      trailing: IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () {
                          _showImagePicker(context, index);
                        },
                      ),
                    ),
                  );
                });
          })),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context, int index) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  controller.pickImage(index, ImageSource.camera);
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  controller.pickImage(index, ImageSource.gallery);
                  Get.back();
                },
              ),
            ],
          );
        });
  }
}
