import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/constants/enum.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final bool isSignIn;

  const ProfileScreen({Key? key, required this.isSignIn}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DepotBloc _depotBloc;
  late Depot _depot;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // set data
    DepotState state = _depotBloc.state;
    if (widget.isSignIn) {
      if (state is DepotGetProfileSuccess) _depot = state.depot;
    } else {
      if (state is DepotRegisterInProcess) _depot = state.depotRegister;
    }

    super.initState();
  }

  ImageProvider get _depotImage {
    if (_depot.image!.contains('http') || _depot.image!.contains('https')) {
      return CachedNetworkImageProvider(_depot.image!);
    }

    bool isExist = File(_depot.image!).existsSync();
    if (isExist) {
      return FileImage(File(_depot.image!));
    }

    return AssetImage('assets/images/shop.png');
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

      if (croppedImage != null) {
        // set image
        if (widget.isSignIn) {
        } else {
          _depot.image = croppedImage.path;
          _depotBloc.add(
              DepotRegisterProcessed(depotRegister: (_depot as DepotRegister)));
        }
      }
    }
  }

  void _editNameAction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProfileEditScreen(
        section: ProfileEditSection.name,
        depot: _depot,
        isSignIn: widget.isSignIn,
      ),
    ));
  }

  void _editPriceAction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProfileEditScreen(
        section: ProfileEditSection.price,
        depot: _depot,
        isSignIn: widget.isSignIn,
      ),
    ));
  }

  void _editAddressAction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProfileEditScreen(
        section: ProfileEditSection.locationMap,
        depot: _depot,
        isSignIn: widget.isSignIn,
      ),
    ));
  }

  void _toDashboardAction() {
    if (widget.isSignIn) {
      _depotBloc.add(DepotUpdateProfile(depot: _depot));
    } else {
      // check if null
      if ((_depot as DepotRegister).isContainNull()) {
        showSnackbar(context, 'Semua data harus diisi');
      } else {
        _depotBloc
            .add(DepotRegistered(depotRegister: (_depot as DepotRegister)));
      }
    }
  }

  void _profileBlocListener(BuildContext context, DepotState state) {
    if (widget.isSignIn) {
      if (state is DepotUpdateProfileInProcess) _depot = state.depot;
    } else {
      if (state is DepotRegisterInProcess) _depot = state.depotRegister;
    }

    if (state is DepotRegisteredSuccess) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }

    if (state is DepotGetProfileSuccess) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<DepotBloc, DepotState>(
          listener: _profileBlocListener,
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: Pallette.contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        widget.isSignIn
                            ? MaterialButton(
                                onPressed: () => Navigator.pop(context),
                                padding: const EdgeInsets.all(10.0),
                                minWidth: 0.0,
                                elevation: 8.0,
                                shape: CircleBorder(),
                                color: Colors.white,
                                child: Icon(Icons.arrow_back),
                              )
                            : const SizedBox.shrink(),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 40.0),
                            alignment: widget.isSignIn
                                ? Alignment.topLeft
                                : Alignment.center,
                            child: Text(
                              'Data depot anda',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ],
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
                            foregroundImage: _depotImage,
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
                    widget.isSignIn
                        ? const SizedBox.shrink()
                        : Text(
                            'Pilih foto profil depot',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                    const SizedBox(height: 30.0),
                    _buildInfo(
                      icon: Icons.person,
                      title: 'Nama',
                      value: _depot.name!,
                      onTap: _editNameAction,
                    ),
                    const SizedBox(height: 25.0),
                    _buildInfo(
                      icon: Icons.location_on,
                      title: 'Alamat',
                      value: _depot.address!,
                      onTap: _editAddressAction,
                    ),
                    const SizedBox(height: 25.0),
                    _buildInfo(
                      icon: Icons.price_change,
                      title: 'Harga per galon isi ulang',
                      value: 'Rp. ' + _depot.price.toString(),
                      onTap: _editPriceAction,
                    ),
                    const SizedBox(height: 30.0),
                    BlocBuilder<DepotBloc, DepotState>(
                      builder: (context, state) {
                        if (state is DepotLoading) {
                          return RoundedButton.loading();
                        }

                        return RoundedButton(
                          label: 'Selesai',
                          onPressed: _toDashboardAction,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfo(
      {required IconData icon,
      required String title,
      required String value,
      required VoidCallback onTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 30.0,
          color: Colors.blue.shade400,
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 5.0),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.edit,
            size: 25.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
