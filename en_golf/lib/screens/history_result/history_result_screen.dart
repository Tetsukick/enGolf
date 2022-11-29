import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collection/collection.dart';
import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/utils.dart';
import 'package:engolf/model/floor/entity/player.dart';
import 'package:engolf/utils/logger.dart';

import '../../config/config.dart';
import '../../flutter_flow/flutter_flow_charts.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '../../model/floor/db/database.dart';
import '../../model/floor/entity/game_result_object.dart';
import '../../model/floor/migrations/migration_v2_to_v3_add_game_result_table.dart';

class HistoryResultScreen extends StatefulWidget {
  const HistoryResultScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HistoryResultScreenState createState() => _HistoryResultScreenState();
}

class _HistoryResultScreenState extends State<HistoryResultScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AppDatabase? database;
  List<GameResultObject>? gameResultList;
  List<GameResultObject>? filteredGameResultList;
  Player? mainPlayer;

  @override
  void initState() {
    initializeDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorConfig.bgGreenPrimary,
      body: SingleChildScrollView(
        child: body(),
      ),
    );
  }

  Widget body() {
    if (gameResultList == null || gameResultList!.isEmpty) {
      return error('保存されたデータがありません。\nホーム画面の結果を保存・表示からゲームの結果を保存してください。');
    } else if (mainPlayer == null) {
      return error('メインユーザーが設定されていません。\n設定>プレイヤー管理からメインユーザーを設定してください。');
    } else if (filteredGameResultList == null || filteredGameResultList!.isEmpty) {
      return error('メインユーザーの履歴データがありません。');
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        headerTotalProfit(),
        chart(),
        resultTable(),
      ],
    );
  }

  Widget headerTotalProfit() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x3F14181B),
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Text(
                formatNumber(
                  totalProfit(),
                  formatType: FormatType.decimal,
                  decimalType: DecimalType.automatic,
                  currency: '¥',
                ),
                style: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Lexend',
                      color: FlutterFlowTheme.of(context).textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 4),
              child: Text(
                '合計収支',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Lexend',
                      color: Color(0xB3FFFFFF),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chart() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryColor,
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 150,
          child: FlutterFlowLineChart(
            data: [
              FFLineChartData(
                xData: List<int>.generate(filteredGameResultList!.length, (index) => index + 1),
                yData: sumProfitList(),
                settings: LineChartBarData(
                  color: Color(0xFF39D2C0),
                  barWidth: 2,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Color(0x6639D2C0),
                  ),
                ),
              )
            ],
            chartStylingInfo: ChartStylingInfo(
              enableTooltip: true,
              tooltipBackgroundColor: FlutterFlowTheme.of(context).alternate,
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              showBorder: false,
              showGrid: true
            ),
            axisBounds: AxisBounds(),
            xAxisLabelInfo: AxisLabelInfo(
              showLabels: false,
              labelTextStyle: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Lexend',
                    fontSize: 12,
                  ),
              labelInterval: 10,
            ),
            yAxisLabelInfo: AxisLabelInfo(
              showLabels: false,
              labelTextStyle: FlutterFlowTheme.of(context).bodyText1,
              labelInterval: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget resultTable() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
      child: Column(
        children: List.generate(filteredGameResultList?.length ?? 0, (index) {
          return resultTableItem(index: index);
        }),
      ),
    );
  }

  Widget resultTableItem({required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        height: 70,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x3F14181B),
              offset: Offset(0, 3),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: ColorConfig.bgDarkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.monetization_on_rounded,
                    color: filteredGameResultList!.reversed.toList()[index].playerResultList!.firstWhere((element) => element.playerID == mainPlayer!.id).result < 0 ?
                    FlutterFlowTheme.of(context).errorRed
                        : FlutterFlowTheme.of(context)
                        .tertiaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        filteredGameResultList!.reversed.toList()[index].name
                            ?? dateTimeToString(filteredGameResultList![index]
                            .gameDate!),
                        style: FlutterFlowTheme.of(context).title3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    filteredGameResultList!.reversed.toList()[index].playerResultList!.firstWhere((element) => element.playerID == mainPlayer!.id).result.toString(),
                    textAlign: TextAlign.end,
                    style: FlutterFlowTheme.of(context).subtitle2.override(
                      fontFamily: 'Lexend',
                      color: filteredGameResultList!.reversed.toList()[index].playerResultList!.firstWhere((element) => element.playerID == mainPlayer!.id).result < 0 ?
                      FlutterFlowTheme.of(context).errorRed
                          : FlutterFlowTheme.of(context).tertiaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      dateTimeFormat(
                          'MMMEd',
                          filteredGameResultList!.reversed.toList()[index]
                              .gameDate),
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () async {
                  await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'ゲームデータを削除しますか？',
                      desc: 'この作業は取り消しできません',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        database?.gameResultDao.deleteGameResult(
                          filteredGameResultList!.reversed.toList()[index]
                              .toGameResult()
                        );
                      },
                  ).show();
                  await initializeDB();
                },
                child: const Icon(
                  Icons.delete_forever_outlined
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initializeDB() async {
    final _database = await $FloorAppDatabase
        .databaseBuilder(Config.dbName)
        .addMigrations([migration2to3]).build();
    setState(() => database = _database);
    final tmpGameResultList =
        await _database.gameResultDao.findAllGameResults();
    final gameResultObjectList = tmpGameResultList
        ?.map((e) => GameResultObject().fromGameResult(e))
        .toList();
    setState(() => gameResultList = gameResultObjectList);
    await getMainPlayer();
    await setFilteredGameResultList();
  }

  Future<void> getMainPlayer() async {
    final tmpMainPlayer = await database?.playerDao.findMainPlayers();
    setState(() => mainPlayer = tmpMainPlayer);
  }

  Future<void> setFilteredGameResultList() async {
    if (mainPlayer == null || gameResultList == null) {
      return;
    }
    final tmpFilteredGameResultList = gameResultList!.where((gameResult) =>
        gameResult.playerResultList!.any((playerResult) =>
        playerResult.playerID == mainPlayer!.id),).toList();
    setState(() => filteredGameResultList = tmpFilteredGameResultList);
    logger.d(filteredGameResultList!.map((e) => e.gameDate).toList());
    logger.d(filteredGameResultList!.map((e) => e.playerResultList!.firstWhere((element) => element.playerID == mainPlayer!.id).result).toList());
  }

  int totalProfit() {
    if (mainPlayer == null || gameResultList == null) {
      return 0;
    }
    return gameResultList!.fold(0, (previousValue, gameResult) {
      final tmpMainUserResult = gameResult.playerResultList!.firstWhereOrNull((playerResult) => playerResult.playerID == mainPlayer!.id);
      if (tmpMainUserResult != null) {
        return previousValue + tmpMainUserResult.result;
      } else {
        return previousValue;
      }
    });
  }

  List<int> sumProfitList() {
    if (filteredGameResultList == null || filteredGameResultList!.length <= 0) {
      return [0];
    }
    final tmpSumProfitList = <int>[];
    filteredGameResultList!.forEach((element) {
      final int currentSumProfit = tmpSumProfitList
          .fold(0, (previousValue, element) => previousValue + element);
      var tmpProfit = element.playerResultList!.firstWhere((e) => e.playerID == mainPlayer!.id).result;
      tmpSumProfitList.add(currentSumProfit + tmpProfit);
    });
    return tmpSumProfitList;
  }

  Widget error(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 64),
          Image.asset('assets/setting-error_512.png',
            width: 128,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: FlutterFlowTheme.of(context).title1.override(
              fontFamily: 'Lexend',
              color: FlutterFlowTheme.of(context).textColor,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
