import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/utils.dart';
import 'package:engolf/screens/history_result/views/widgets/payment_details_widget.dart';

import '../../flutter_flow/flutter_flow_charts.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HistoryResultScreen extends StatefulWidget {
  const HistoryResultScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HistoryResultScreenState createState() => _HistoryResultScreenState();
}

class _HistoryResultScreenState extends State<HistoryResultScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorConfig.bgGreenPrimary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
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
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 0, 0),
                              child: Text(
                                'TEST TITLE',
                                style: FlutterFlowTheme.of(context)
                                    .title1
                                    .override(
                                  fontFamily: 'Lexend',
                                  color: FlutterFlowTheme.of(context)
                                      .textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                            child: Text(
                              formatNumber(
                                1000,
                                formatType: FormatType.decimal,
                                decimalType: DecimalType.automatic,
                                currency: '\$',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .title1
                                  .override(
                                fontFamily: 'Lexend',
                                color: FlutterFlowTheme.of(context)
                                    .textColor,
                                fontSize: 36,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(8, 0, 0, 4),
                            child: Text(
                              'TEST',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                fontFamily: 'Lexend',
                                color: Color(0xB3FFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              dateTimeToString(DateTime.now()),
                              '4 Days Left',
                            ),
                            style: FlutterFlowTheme.of(context).subtitle2,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 4, 0),
                                child: Text(
                                  'TEST',
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText2
                                      .override(
                                    fontFamily: 'Lexend',
                                    color: Color(0xB3FFFFFF),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  formatNumber(
                                    300,
                                    formatType: FormatType.decimal,
                                    decimalType: DecimalType.automatic,
                                    currency: '\$',
                                  ),
                                  '2,502',
                                ),
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context)
                                    .title3
                                    .override(
                                  fontFamily: 'Lexend',
                                  color: FlutterFlowTheme.of(context)
                                      .textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 250,
                  child: FlutterFlowLineChart(
                    data: [
                      FFLineChartData(
                        xData: <int>[0,1,2,3,4,5],
                        yData: <int>[0,1,2,3,4,5],
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
                      tooltipBackgroundColor:
                      FlutterFlowTheme.of(context).alternate,
                      backgroundColor:
                      FlutterFlowTheme.of(context).primaryColor,
                      showBorder: false,
                    ),
                    axisBounds: AxisBounds(),
                    xAxisLabelInfo: AxisLabelInfo(
                      showLabels: true,
                      labelTextStyle:
                      FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                      ),
                      labelInterval: 10,
                    ),
                    yAxisLabelInfo: AxisLabelInfo(
                      showLabels: true,
                      labelTextStyle:
                      FlutterFlowTheme.of(context).bodyText1,
                      labelInterval: 10,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Text(
                            'TEST',
                            style: FlutterFlowTheme.of(context).bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                        5,
                            (transactionListIndex) {
                          return Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    0.92,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x3F14181B),
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 0, 0),
                                      child: Card(
                                        clipBehavior:
                                        Clip.antiAliasWithSaveLayer,
                                        color: Color(0x6639D2C0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(8, 8, 8, 8),
                                          child: Icon(
                                            Icons.monetization_on_rounded,
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .tertiaryColor,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'TEST TITLE',
                                                style: FlutterFlowTheme.of(
                                                    context)
                                                    .title3,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 0, 0),
                                              child: Text(
                                                'TEST',
                                                style: FlutterFlowTheme.of(
                                                    context)
                                                    .bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 12, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'TEST',
                                            textAlign: TextAlign.end,
                                            style:
                                            FlutterFlowTheme.of(context)
                                                .subtitle2
                                                .override(
                                              fontFamily: 'Lexend',
                                              color: FlutterFlowTheme
                                                  .of(context)
                                                  .tertiaryColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(0, 4, 0, 0),
                                            child: Text(
                                              dateTimeFormat(
                                                  'MMMEd', DateTime.now()),
                                              textAlign: TextAlign.end,
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyText1
                                                  .override(
                                                fontFamily: 'Lexend',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
