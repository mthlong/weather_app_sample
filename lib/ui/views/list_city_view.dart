import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/fonts.dart';


class ListCity extends StatefulWidget {
  const ListCity({super.key});

  @override
  State<ListCity> createState() => _ListCityState();
}

TextEditingController _textEditingController = TextEditingController();

class _ListCityState extends State<ListCity> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    AppBar appBar = _buildAppBar();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.only(top: appBar.preferredSize.height + 30),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background_image.png'),
                fit: BoxFit.fill)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: AnimSearchBar(
                    color: const Color(0xff48319D),
                    searchIconColor: Colors.white,
                    textFieldColor: const Color(0xffDDAEF2),
                    textFieldIconColor: Colors.white,
                    width: width,
                    helpText: "Find a city...",
                    textController: _textEditingController,
                    animationDurationInMilli: 700,
                    rtl: true,
                    onSuffixTap: () {},
                    onSubmitted: (s) {},
                  )),
              Expanded(
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: _buildListCity(height)))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCity(double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, selectedIndex) {
          return _buildItemCity(height);
        },
      ),
    );
  }

  Widget _buildItemCity(double height) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: height / 5,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background_item_city.png'),
              fit: BoxFit.fill)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildText(
                  text: '29°',
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
                ),
                Image.asset(
                  'assets/images/heavyrain.png',
                  width: 110,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(
                    text: "H:26°  L:18°",
                    fontSize: 11,
                    color: const Color(0xffC0C0C0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildText(text: 'Da Nang, Viet Nam', fontSize: 16),
                    _buildText(text: 'Heavy Rain', fontSize: 14),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),),
            const SizedBox(width: 10,),
            _buildText(
                text: "Weather", fontSize: 30, fontWeight: FontWeight.w300),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildText(
      {required String text,
      double? fontSize,
      FontWeight? fontWeight,
      TextAlign? textAlign,
      Color? color}) {
    return Text(text,
        textAlign: textAlign ?? TextAlign.start,
        style: safeGoogleFont(
          'SF Pro Text',
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? Colors.white,
        ));
  }
}
