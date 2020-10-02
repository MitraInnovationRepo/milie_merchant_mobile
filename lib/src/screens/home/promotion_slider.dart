import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class PromotionSlider extends StatelessWidget {
  final List<String> imgList = [
    'https://i.imgur.com/SBPqQvF.png',
    'https://i.imgur.com/RGb19eN.jpg',
    'https://i.imgur.com/vFq13J8.jpg',
    'https://i.imgur.com/BZOLRhW.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(autoPlay: true, viewportFraction: 1,
          height: MediaQuery.of(context).size.height * 0.5,),
      items: imgList
          .map((item) => Container(
                child: Center(
                    child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) {
                          return SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                              ),
                            ),
                          );
                        },
                        imageUrl: item,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width )),
              ))
          .toList(),
    ));
  }
}
