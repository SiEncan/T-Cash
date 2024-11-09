import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int activeIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayAnimationDuration: const Duration(milliseconds: 2000),
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          items: [
            CarouselBanner(
              imageLocation: 'img/banners/gojek.jpg',
              onPressed: () {
                null;
              },
            ),
            const CarouselBanner(
              imageLocation: 'img/banners/tokped.jpg',
            ),
            const CarouselBanner(
              imageLocation: 'img/banners/shopee.jpg',
            ),
            const CarouselBanner(
              imageLocation: 'img/banners/hns.jpg',
            ),
          ],
        ),
        // Strip penunjuk di bawah carousel
        Container(
          margin: const EdgeInsets.only(top: 220),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                  color: activeIndex == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CarouselBanner extends StatelessWidget {
  const CarouselBanner({
    super.key,
    required this.imageLocation,
    this.onPressed,
  });

  final String imageLocation;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: 390,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image(
              image: AssetImage(imageLocation),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
