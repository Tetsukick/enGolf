import '../../../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PaymentDetailsWidget extends StatefulWidget {
  const PaymentDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentDetailsWidgetState createState() => _PaymentDetailsWidgetState();
}

class _PaymentDetailsWidgetState extends State<PaymentDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: SpinKitPumpingHeart(
          color: FlutterFlowTheme.of(context).primaryColor,
          size: 40,
        ),
      ),
    );
  }
}
