import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/constants/enum.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/helpers/map.dart';
import 'package:kang_galon_depot/models/depot.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class ProfileEditScreen extends StatefulWidget {
  final ProfileEditSection section;
  final Depot depot;
  final bool isSignIn;

  const ProfileEditScreen({
    Key? key,
    required this.section,
    required this.depot,
    required this.isSignIn,
  }) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late GlobalKey<FormState> _formKey;
  late DepotBloc _depotBloc;
  late Completer<GoogleMapController> _controller;
  late TextEditingController _textEditingController;
  late Depot _depot;
  late double _latitude;
  late double _longitude;
  late bool _isCameraMove;
  late ProfileEditSection _section;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // init
    _formKey = GlobalKey();
    _textEditingController = TextEditingController();

    // set depot
    _depot = widget.depot;

    // set section state
    _section = widget.section;

    if (_section == ProfileEditSection.name) {
      // set text controller
      _textEditingController.text = _depot.name!;
    }

    if (_section == ProfileEditSection.price) {
      // set text controller
      _textEditingController.text = _depot.price.toString();
    }

    if (_section == ProfileEditSection.locationMap) {
      // init
      _controller = Completer();
      _isCameraMove = false;

      // set latitude longitude
      _latitude = _depot.latitude!;
      _longitude = _depot.longitude!;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (_section == ProfileEditSection.locationMap ||
        _section == ProfileEditSection.locationAddress) {
      _controller.future.then((value) => value.dispose());
    }

    _textEditingController.dispose();

    super.dispose();
  }

  String? _textFormFieldValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }

    return null;
  }

  void _okAction() {
    if (_formKey.currentState!.validate()) {
      if (_section == ProfileEditSection.name) {
        _depot.name = _textEditingController.text;

        if (widget.isSignIn) {
          // set bloc
          _depotBloc.add(DepotUpdateProfileProcessed(depot: _depot));
        } else {
          // set bloc
          _depotBloc.add(
              DepotRegisterProcessed(depotRegister: _depot as DepotRegister));
        }
      }

      if (_section == ProfileEditSection.price) {
        _depot.price = int.parse(_textEditingController.text);

        if (widget.isSignIn) {
          // set bloc
          _depotBloc.add(DepotUpdateProfileProcessed(depot: _depot));
        } else {
          // set bloc
          _depotBloc.add(
              DepotRegisterProcessed(depotRegister: _depot as DepotRegister));
        }
      }

      if (_section == ProfileEditSection.locationMap ||
          _section == ProfileEditSection.locationAddress) {
        _depot.address = _textEditingController.text;
        _depot.latitude = _latitude;
        _depot.longitude = _longitude;

        if (widget.isSignIn) {
          // set bloc
          _depotBloc.add(DepotUpdateProfileProcessed(depot: _depot));
        } else {
          // set bloc
          _depotBloc.add(
              DepotRegisterProcessed(depotRegister: _depot as DepotRegister));
        }
      }

      Navigator.of(context).pop();
    }
  }

  void _toLocationAddressSection() {
    // get address use background process
    MapHelper.getAddressLocation(_latitude, _longitude).then((value) {
      _textEditingController.text = value;
    });

    setState(() => _section = ProfileEditSection.locationAddress);
  }

  @override
  Widget build(BuildContext context) {
    switch (_section) {
      case ProfileEditSection.name:
        return _buildNameSection();
      case ProfileEditSection.price:
        return _buildPriceSection();
      case ProfileEditSection.locationMap:
        return _buildLocationMapSection();
      case ProfileEditSection.locationAddress:
        return _buildLocationAddressSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNameSection() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nama depot'),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Padding(
          padding: Pallette.contentPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _textEditingController,
                  validator: _textFormFieldValidator,
                  decoration: Pallette.inputDecoration,
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: RoundedButton(
                    label: 'Ok',
                    onPressed: _okAction,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Harga per galon'),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Padding(
          padding: Pallette.contentPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _textEditingController,
                  validator: _textFormFieldValidator,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: Pallette.inputDecoration.copyWith(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
                      child: Text(
                        'Rp. ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: RoundedButton(
                    label: 'Ok',
                    onPressed: _okAction,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationMapSection() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Alamat depot'),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude, _longitude),
                zoom: 20.0,
              ),
              onCameraMove: (cameraPosition) {
                _latitude = cameraPosition.target.latitude;
                _longitude = cameraPosition.target.longitude;
              },
              onCameraMoveStarted: () {
                setState(() => _isCameraMove = true);
              },
              onCameraIdle: () {
                setState(() => _isCameraMove = false);
              },
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.location_on,
                size: _isCameraMove ? 60.0 : 40.0,
                color: Colors.blue.shade400,
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: RoundedButton(
                label: 'Pilih lokasi',
                onPressed: _toLocationAddressSection,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationAddressSection() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Alamat depot'),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Padding(
          padding: Pallette.contentPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _textEditingController,
                  validator: _textFormFieldValidator,
                  maxLines: 3,
                  decoration: Pallette.inputDecoration,
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: RoundedButton(
                    label: 'Ok',
                    onPressed: _okAction,
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
