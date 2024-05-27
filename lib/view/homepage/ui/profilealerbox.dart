import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/homepage/homepagemodel.dart';

class ProfileAlertbox extends StatelessWidget {
  Chatusers user;
  ProfileAlertbox({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircleAvatar(
                maxRadius: 80,
                minRadius: 20,
                child: CachedNetworkImage(
                  imageUrl: user.image ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
