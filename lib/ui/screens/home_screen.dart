import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/depot_event.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/chats_screen.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DepotBloc _depotBloc;
  late TransactionBloc _transactionBloc;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _gallonController;
  late RefreshController _refreshController;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);

    // init form
    _formKey = GlobalKey();

    // init controller
    _gallonController = TextEditingController();
    _refreshController = RefreshController(initialRefresh: false);

    // get profile
    _depotBloc.add(DepotGetProfile());

    // get current transaction
    _transactionBloc.add(TransactionCurrentFetch());

    super.initState();
  }

  @override
  void dispose() {
    _gallonController.dispose();

    super.dispose();
  }

  String? _formValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }

    return null;
  }

  void _onRefresh() {
    _transactionBloc.add(TransactionCurrentFetch());
  }

  void _transactionListener(BuildContext context, TransactionState state) {
    if (state is TransactionCurrentFetchSuccess) {
      _refreshController.refreshCompleted();
    }
  }

  void _profileAction() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileScreen(isSignIn: true)),
    );
  }

  void _statusDepotAction(bool value) {
    String status = value ? 'buka' : 'tutup';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Status depot'),
          content: Text('Apakah yakin ingin $status depot ?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _depotBloc.add(DepotUpdateStatus(status: value));

                Navigator.pop(context);
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

  void _historyAction() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<TransactionHistoryBloc>(
            create: (_) => TransactionHistoryBloc(),
            child: TransactionHistoryScreen()),
      ),
    );
  }

  void _detailAction(Transaction transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<TransactionDetailBloc>(
            create: (_) => TransactionDetailBloc(transaction, _transactionBloc),
            child: TransactionDetailScreen()),
      ),
    );
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
                  _transactionBloc.add(
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
                  _transactionBloc
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
                  _transactionBloc
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
                  _transactionBloc
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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPadding(
                padding: Pallette.contentPadding2,
                sliver: _buildHeader(),
              ),
              SliverPadding(
                padding: Pallette.contentPadding2,
                sliver: _buildStatus(),
              ),
            ];
          },
          body: Padding(
            padding: Pallette.contentPadding2,
            child: _buildTransaction(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: BlocBuilder<DepotBloc, DepotState>(
        builder: (context, state) {
          if (state is DepotGetProfileSuccess) {
            return ProfileHeader(
              name: state.depot.name,
              image: state.depot.image,
              onTap: _profileAction,
            );
          }
          return ProfileHeader.loading();
        },
      ),
    );
  }

  Widget _buildStatus() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: Pallette.containerBoxDecoration,
        padding: Pallette.contentPadding2,
        height: 65.0,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Status depot',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Text(
              'Tutup',
              style: Theme.of(context).textTheme.caption,
            ),
            BlocBuilder<DepotBloc, DepotState>(
              builder: (context, state) {
                if (state is DepotGetProfileSuccess) {
                  return Switch(
                    value: state.depot.isOpen,
                    onChanged: _statusDepotAction,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            Text(
              'Buka',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransaction() {
    return Container(
      padding: Pallette.contentPadding2,
      decoration: Pallette.containerBoxDecoration,
      child: Column(
        children: [
          LongButton(
            text: 'Riwayat transaksi',
            icon: Icons.history,
            onPressed: _historyAction,
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: _transactionListener,
              builder: (context, state) {
                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (state is TransactionCurrentFetchSuccess) {
                        if (index == 0) {
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Jumlah transaksi saat ini ${state.transactions.length}',
                            ),
                          );
                        } else {
                          Transaction transaction =
                              state.transactions[index - 1];
                          return TransactionItemCurrent(
                            transaction: transaction,
                            onDetailPressed: _detailAction,
                            onChatAction: _chatAction,
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
                      }
                      return TransactionItemCurrent.loading();
                    },
                    itemCount: (state is TransactionCurrentFetchSuccess)
                        ? state.transactions.length + 1
                        : 1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
