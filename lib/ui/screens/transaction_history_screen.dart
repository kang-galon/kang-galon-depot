import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _buildHeader(),
            _buildTransaction(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPadding(
      padding: Pallette.contentPadding2,
      sliver: SliverToBoxAdapter(
        child: HeaderBar(title: 'Riwayat Transaksi'),
      ),
    );
  }

  Widget _buildTransaction() {
    return SliverPadding(
      padding: Pallette.contentPadding2,
      sliver: BlocBuilder<TransactionHistoryBloc, TransactionState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (state is TransactionHistoryFetchSuccess) {
                  Transaction transaction = state.transactions[index];
                  return TransactionItem(transaction: transaction);
                }

                return TransactionItem.loading();
              },
              childCount: (state is TransactionHistoryFetchSuccess)
                  ? state.transactions.length
                  : 1,
            ),
          );
        },
      ),
    );
  }
}
