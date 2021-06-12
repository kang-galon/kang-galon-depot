import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeader extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? onTap;
  final bool isLoading;

  const ProfileHeader({
    required this.name,
    required this.image,
    required this.onTap,
  }) : this.isLoading = false;

  const ProfileHeader.loading()
      : this.name = null,
        this.image = null,
        this.onTap = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      child: Row(
        children: [
          Container(
            decoration: Pallette.containerBoxDecoration,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? () {} : onTap!,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 2.0),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: isLoading
                        ? AssetImage('assets/images/profile.png')
                        : CachedNetworkImageProvider(image!) as ImageProvider,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: Pallette.containerBoxDecoration,
              alignment: Alignment.centerLeft,
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Pallette.shimmerBaseColor,
                      highlightColor: Pallette.shimmerHighlightColor,
                      child: Container(
                        decoration: Pallette.shimmerContainerDecoration,
                      ),
                    )
                  : Text(
                      'Hai, $name',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
