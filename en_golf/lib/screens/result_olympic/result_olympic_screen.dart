import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/shared_preference.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/common/utils.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:engolf/screens/result_olympic/result_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import '../../common/constants.dart' as Constants;

class ResultOlympicScreen extends StatefulWidget {

  @override
  _ResultOlympicScreenState createState() => new _ResultOlympicScreenState();
}


class _ResultOlympicScreenState extends State<ResultOlympicScreen> {

  GlobalKey _globalKey = GlobalKey();
  List<Player> _players;
  String _gameName;
  DateTime _gameDate;

  @override
  void initState() {
    getPlayers();
    getGameName();
    getDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: ColorConfig.bgGreenPrimary,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              titleWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: SizeConfig.smallestMargin, horizontal: SizeConfig.mediumMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 64,
                      child: Center(
                        child: Text(
                          'score',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      child: Center(
                        child: Text(
                          'result',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: Padding(
                    padding:
                      const EdgeInsets.only(bottom: SizeConfig.smallestMargin),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _players?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: ResultScoreCard(
                                  color: Constants.colors[_players[index].rank],
                                  player: _players[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 40),
              child: FloatingActionButton(
                heroTag: 'closeBtn',
                backgroundColor: ColorConfig.bgDarkGreen,
                child: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 'shareBtn',
              child: const Icon(Icons.ios_share),
              onPressed: () {
                shareImageAndText();
              },
            ),
          ),
        ],
      )
    );
  }

  Widget titleWidget() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/ranking_title_bg.svg')),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      _gameName == null || _gameName.isEmpty ? 'engolf' : _gameName,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      maxLines: 2,
                      minFontSize: 16,
                    ),
                    AutoSizeText(
                      dateTimeToString(_gameDate ?? DateTime.now()),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      minFontSize: 11,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlayers() async {
    _players = await SharedPreferenceManager().getPlayers();
    _players.sort((a,b) => a.rank.compareTo(b.rank));
    setState(() {});
  }

  Future<void> getDate() async {
    _gameDate = await SharedPreferenceManager().getGameDate();
    setState(() {});
  }

  Future<void> getGameName() async {
    _gameName = await SharedPreferenceManager().getGameName();
    setState(() {});
  }

  Future<File> getApplicationDocumentsFile(List<int> imageData) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/engolf_result.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  Future<ByteData> exportToImage() async {
    final boundary =
      _globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData;
  }

  void shareImageAndText() async {
    try {
      final bytes = await exportToImage();
      final widgetImageBytes =
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      final applicationDocumentsFile =
      await getApplicationDocumentsFile(widgetImageBytes);

      final path = applicationDocumentsFile.path;
      await ShareExtend.share(path, "image");
      applicationDocumentsFile.delete();
    } catch (error) {
      print(error);
    }
  }
}