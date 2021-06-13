import 'package:flutter/material.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:shimmer/shimmer.dart';

class TransactionItem extends StatelessWidget {
  final Transaction? transaction;
  final bool isLoading;

  const TransactionItem({
    Key? key,
    required this.transaction,
  })  : this.isLoading = false,
        super(key: key);

  const TransactionItem.loading()
      : this.transaction = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Pallette.containerBoxDecoration,
      padding: Pallette.contentPadding2,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading
              ? Shimmer.fromColors(
                  baseColor: Pallette.shimmerBaseColor,
                  highlightColor: Pallette.shimmerHighlightColor,
                  child: Container(
                    decoration: Pallette.shimmerContainerDecoration,
                    height: 15.0,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction!.clientName,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
          const SizedBox(height: 10.0),
          isLoading
              ? Shimmer.fromColors(
                  baseColor: Pallette.shimmerBaseColor,
                  highlightColor: Pallette.shimmerHighlightColor,
                  child: Container(
                    decoration: Pallette.shimmerContainerDecoration,
                    height: 25.0,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${transaction!.gallon} Gallon',
                            style: Theme.of(context).textTheme.bodyText1),
                        Text(transaction!.totalPriceDescription,
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction!.statusDescription,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                        Text(
                          transaction!.createdAt,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
