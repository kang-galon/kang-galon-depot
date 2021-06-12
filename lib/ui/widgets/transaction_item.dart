import 'package:flutter/material.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:shimmer/shimmer.dart';

class TransactionItem extends StatelessWidget {
  final Transaction? transaction;
  final Function(Transaction)? onConfirmPressed;
  final Function(Transaction)? onDenyPressed;
  final bool isLoading;

  const TransactionItem(
      {Key? key,
      required this.transaction,
      required this.onConfirmPressed,
      required this.onDenyPressed})
      : this.isLoading = false,
        super(key: key);

  const TransactionItem.loading()
      : this.onConfirmPressed = null,
        this.onDenyPressed = null,
        this.transaction = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              : Text(
                  transaction!.clientName,
                  style: Theme.of(context).textTheme.bodyText1,
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
              : Row(
                  children: [
                    transaction!.status == 1 || // menunggu konfirmasi
                            transaction!.status == 2 || // mengambil galon
                            transaction!.status == 3 // mengantar galon
                        ? MaterialButton(
                            onPressed: () => onConfirmPressed!(transaction!),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 3.0,
                            child: (transaction!.status == 1)
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : (transaction!.status == 2)
                                    ? Icon(
                                        Icons.two_wheeler,
                                        color: Colors.green,
                                      )
                                    : (transaction!.status == 3)
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.two_wheeler,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 5.0),
                                              Icon(
                                                Icons.my_location,
                                                color: Colors.green,
                                              )
                                            ],
                                          )
                                        : null,
                          )
                        : const MaterialButton(onPressed: null),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          child: Icon(
                            Icons.phone,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MaterialButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          child: Icon(
                            Icons.chat,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                    transaction!.status == 1
                        ? MaterialButton(
                            onPressed: () => onDenyPressed!(transaction!),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 3.0,
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        : const MaterialButton(onPressed: null),
                  ],
                ),
          const Divider(),
        ],
      ),
    );
  }
}
