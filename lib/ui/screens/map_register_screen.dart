import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon_depot/constans/enum.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

class MapRegisterScreen extends StatefulWidget {
  @override
  _MapRegisterScreenState createState() => _MapRegisterScreenState();
}

class _MapRegisterScreenState extends State<MapRegisterScreen> {
  late Completer<GoogleMapController> _controller;
  late double _latitude;
  late double _longitude;
  late bool _isCameraMove;
  late MapRegisterSection _section;

  @override
  void initState() {
    // init
    _controller = Completer();

    // init section
    _section = MapRegisterSection.map;

    // set
    _isCameraMove = false;

    // init lat long
    _latitude = 37.43296265331129;
    _longitude = -122.08832357078792;

    super.initState();
  }

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  void _chooseLocationAction() {
    setState(() {
      _section = MapRegisterSection.address;
    });
  }

  void _backToMapAction() {
    setState(() {
      _section = MapRegisterSection.map;
    });
  }

  void _continueAction() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PhotoRegisterScreen()),
    );
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
          right: 10.0,
          child: MaterialButton(
            onPressed: _chooseLocationAction,
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            color: Colors.blue.shade400,
            child: Text(
              'Pilih lokasi',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white),
            ),
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
              TextFormField(
                maxLines: 3,
                decoration: Pallette.inputDecoration,
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
