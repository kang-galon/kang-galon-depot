import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class PhotoRegisterScreen extends StatefulWidget {
  @override
  _PhotoRegisterScreenState createState() => _PhotoRegisterScreenState();
}

class _PhotoRegisterScreenState extends State<PhotoRegisterScreen> {
  late File? _imageFile;

  @override
  void initState() {
    // init
    _imageFile = null;

    super.initState();
  }

  void _changeImageAction() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
    );

    if (image != null) {
      String path = image.path;
      File? croppedImage = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Foto profil',
          hideBottomControls: true,
        ),
      );

      setState(() => _imageFile = croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 40.0),
                  child: Text(
                    'Data depot anda',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                const SizedBox(height: 20.0),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.transparent,
                        foregroundImage: _imageFile == null
                            ? AssetImage('assets/images/shop.png')
                            : FileImage(_imageFile!) as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: -10,
                      child: MaterialButton(
                        onPressed: _changeImageAction,
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.blue.shade400,
                        elevation: 5.0,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Pilih foto profil depot',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 25.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 30.0,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'asdasd',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.map,
                      size: 30.0,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alamat',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'asdasd',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                MaterialButton(
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  color: Colors.blue.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'Selesai...',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
