import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:skeleton_text/skeleton_text.dart';

class PromotionSlider extends StatelessWidget {
  final List<String> imgList = [
    '${Constant.contentEndpoint}/uploads/merchant_slider1_c9d149cee0.jpg',
    '${Constant.contentEndpoint}/uploads/merchant_slider2_8b50f986b6.jpg',
    '${Constant.contentEndpoint}/uploads/merchant_slider3_332308dca8.jpg',
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
                    child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width )),
              ))
          .toList(),
    ));
  }
}
