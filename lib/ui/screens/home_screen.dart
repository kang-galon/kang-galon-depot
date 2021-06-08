import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/depot_event.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DepotBloc _depotBloc;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // get profile
    _depotBloc.add(DepotGetProfile());

    super.initState();
  }

  void _profileAction() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileScreen(isSignIn: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: Pallette.contentPadding2,
              sliver: _buildHeader(),
            ),
          ],
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
}
