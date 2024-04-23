import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/database/db_helper.dart';
import 'package:news_app/utility/color_code.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/utilities.dart';
import 'package:permission_handler/permission_handler.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  DBHelper userDBHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    getAndroidVersion();
  }

  Future<int> getAndroidVersion() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return int.parse(androidInfo.version.release);
  }

  Future<void> _checkPermissionStatus() async {
    var permission = await getAndroidVersion() <= 13
        ? Permission.storage
        : Permission.photos;

    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus == PermissionStatus.denied) {
      await permission.request();
      _checkPermissionStatus();
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      _checkPermissionStatus();
    } else if (permissionStatus == PermissionStatus.granted) {
      getImage();
    }
  }

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      int id = Utilities.userModel!.id!;
      var result =
          await userDBHelper.updateUserProfileImagePath(pickedFile.path, id);
      if (result != 0) {
        userDBHelper
            .getUserDetails(Utilities.userModel!.mobileNumber)
            .then((value) => setState(() {}));
      } else {
        Utilities.showSnackBarMessage(context, AppStrings.errorSomethingWrong);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: ColorCode.colorPrimary),
            accountName: Text(Utilities.userModel!.userName),
            accountEmail: Text(Utilities.userModel!.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: ColorCode.colorWhite,
              child: InkWell(
                onTap: () {
                  _checkPermissionStatus();
                },
                child: ClipOval(
                  child: Utilities.userModel?.profileImage == null ||
                          Utilities.userModel!.profileImage.isEmpty
                      ? Image.asset(
                          'assets/profile.png',
                        )
                      : Image.file(File(Utilities.userModel!.profileImage)),
                ),
              ),
            ),
            currentAccountPictureSize:
                Size(size.width * 0.18, size.width * 0.18),
          )
        ],
      ),
    );
  }
}
