import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/constants/enum.dart';
import 'package:kang_galon_depot/constants/value.dart';
import 'package:kang_galon_depot/event_states/depot_event.dart';
import 'package:kang_galon_depot/helpers/map.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';
import 'package:location/location.dart';

class RegisterMapScreen extends StatefulWidget {
  @override
  _RegisterMapScreenState createState() => _RegisterMapScreenState();
}

class _RegisterMapScreenState extends State<RegisterMapScreen> {
  late DepotBloc _depotBloc;
  late Completer<GoogleMapController> _controller;
  late TextEditingController _addressController;
  late GlobalKey<FormState> _formKey;
  late Location _location;
  late double _latitude;
  late double _longitude;
  late bool _isCameraMove;
  late double _cameraZoom;
  late MapRegisterSection _section;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // init controller
    _controller = Completer();
    _addressController = TextEditingController();

    // init
    _formKey = GlobalKey();
    _location = Location();

    // set
    _cameraZoom = 20.0;
    _isCameraMove = false;
    _section = MapRegisterSection.map;

    // init lat long
    _latitude = Value.defaultLatitude;
    _longitude = Value.defaultLongitude;

    // get current location
    _getLocation();

    super.initState();
  }

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    _addressController.dispose();

    super.dispose();
  }

  void _getLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted != PermissionStatus.granted) {
      permissionGranted = await _location.requestPermission();
    }

    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      LocationData locationData = await _location.getLocation();
      _latitude = locationData.latitude!;
      _longitude = locationData.longitude!;

      await (await _controller.future)
          .animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_latitude, _longitude),
          zoom: _cameraZoom,
        ),
      ));
    }
  }

  String? _addressValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }
    return null;
  }

  void _chooseLocationAction() {
    // get address use background process
    MapHelper.getAddressLocation(_latitude, _longitude).then((value) {
      _addressController.text = value;
    });

    setState(() => _section = MapRegisterSection.address);
  }

  void _backToMapAction() {
    setState(() {
      _section = MapRegisterSection.map;
    });
  }

  void _continueAction() {
    if (_formKey.currentState!.validate()) {
      String address = _addressController.text.trim();

      // set location latitude longitude
      _depotBloc.add(DepotRegisterProcessed(
        depotRegister: DepotRegister(
          latitude: _latitude,
          longitude: _longitude,
          address: address,
        ),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen(isSignIn: false)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Offstage(
              offstage: _section != MapRegisterSection.map,
              child: _buildMapSection(),
            ),
            Offstage(
              offstage: _section != MapRegisterSection.address,
              child: _buildAddressSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(_latitude, _longitude),
            zoom: _cameraZoom,
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
          top: 10.0,
          left: 0,
          right: 0,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 40.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      )
                    ]),
                child: Text(
                  'Lokasi depot anda',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          right: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButton(
                label: 'Lokasi saya',
                onPressed: _getLocation,
              ),
              RoundedButton(
                label: 'Pilih lokasi',
                onPressed: _chooseLocationAction,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
          child: Text(
            'Lokasi depot anda',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                )
              ]),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Alamat',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: 3,
                  validator: _addressValidator,
                  controller: _addressController,
                  decoration: Pallette.inputDecoration,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: _backToMapAction,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              child: Text('Kembali ke map'),
            ),
            MaterialButton(
              onPressed: _continueAction,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.blue.shade400,
              child: Text(
                'Lanjutkan...',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
