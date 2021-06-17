import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class TransactionDetailScreen extends StatefulWidget {
  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionDetailBloc _transactionDetailBloc;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _gallonController;
  late Transaction _transaction;
  late Set<Marker> _markers;
  late double _cameraZoom;
  late Completer<GoogleMapController> _completerController;

  @override
  void initState() {
    // init bloc
    _transactionDetailBloc = BlocProvider.of<TransactionDetailBloc>(context);

    // init form
    _formKey = GlobalKey();
    _gallonController = TextEditingController();

    // set transaction data
    TransactionState state = _transactionDetailBloc.state;
    if (state is TransactionDetailFetchSuccess) {
      _transaction = state.transaction;
    }

    // set
    _completerController = Completer();
    _cameraZoom = 20.0;
    _markers = {};
    _markers.add(
      Marker(
        markerId: MarkerId('client_location'),
        position:
            LatLng(_transaction.clientLatitude, _transaction.clientLongitude),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _gallonController.dispose();
    _completerController.future.then((value) => value.dispose());

    super.dispose();
  }

  String? _formValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }

    return null;
  }

  void _confirmAction(Transaction transaction) {
    // set text gallon
    _gallonController.text = transaction.gallon.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi pesanan'),
          content: Wrap(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Jumlah galon yang dikonfirmasi'),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _gallonController,
                      validator: _formValidator,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),
                      ],
                      decoration: Pallette.inputDecoration,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _transactionDetailBloc.add(
                    TransactionTake(
                      transaction: transaction,
                      gallon: int.parse(_gallonController.text),
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: Text('Ok'),
            ),
            const SizedBox(width: 20.0),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmTakeAction(Transaction transaction) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Konfirmasi ambil galon'),
            content: Text('Apakah galon sudah diambil dari pelanggan ?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _transactionDetailBloc
                      .add(TransactionSend(transaction: transaction));

                  Navigator.pop(context);
                },
                child: Text('Sudah'),
              ),
              const SizedBox(width: 20.0),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Belum',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  void _confirmSendAction(Transaction transaction) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Konfirmasi antar galon'),
            content: Text('Apakah galon sudah diantar ke pelanggan ?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _transactionDetailBloc
                      .add(TransactionComplete(transaction: transaction));

                  Navigator.pop(context);
                },
                child: Text('Sudah'),
              ),
              const SizedBox(width: 20.0),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Belum',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  void _denyAction(Transaction transaction) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Konfirmasi tolak pesanan'),
            content: Text('Yakin pesanan dibatalkan ?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _transactionDetailBloc
                      .add(TransactionDeny(transaction: transaction));

                  Navigator.pop(context);
                },
                child: Text('Ya'),
              ),
              const SizedBox(width: 20.0),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tidak',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  void _clientLocationAction() {
    if (_completerController.isCompleted) {
      _completerController.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                _transaction.clientLatitude, _transaction.clientLongitude),
            zoom: _cameraZoom,
          ),
        ));
      });
    }
  }

  void _chatAction(Transaction transaction) {
    // FirebaseAuth.instance.currentUser!
    //     .getIdToken()
    //     .then((value) => print(value));

    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ChatsPage(transaction: transaction)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: Pallette.contentPadding2,
          physics: BouncingScrollPhysics(),
          children: [
            HeaderBar(title: 'Detail Transaksi'),
            const SizedBox(height: 20.0),
            BlocBuilder<TransactionDetailBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionDetailFetchSuccess) {
                  Transaction transaction = state.transaction;
                  return TransactionItemDetail(
                    transaction: transaction,
                    onChatPressed: _chatAction,
                    onConfirmPressed: (transaction.status == 1)
                        ? _confirmAction
                        : (transaction.status == 2)
                            ? _confirmTakeAction
                            : (transaction.status == 3)
                                ? _confirmSendAction
                                : null,
                    onDenyPressed:
                        (transaction.status == 1) ? _denyAction : null,
                  );
                }

                return TransactionItemDetail.loading();
              },
            ),
            const SizedBox(height: 20.0),
            _buildMap(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      decoration: Pallette.containerBoxDecoration,
      height: 400.0,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            onMapCreated: (controller) {
              _completerController.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  _transaction.clientLatitude, _transaction.clientLongitude),
              zoom: _cameraZoom,
            ),
          ),
          Positioned(
            top: 5,
            right: -10,
            child: MaterialButton(
              onPressed: _clientLocationAction,
              padding: const EdgeInsets.all(10.0),
              shape: CircleBorder(),
              color: Colors.white,
              child: Icon(
                Icons.location_searching,
                size: 20.0,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
