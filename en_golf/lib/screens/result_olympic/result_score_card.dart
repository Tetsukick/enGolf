import 'package:engolf/common/color_config.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScoreCard extends StatelessWidget {
  const ResultScoreCard({
    Key key,
    this.color,
    this.player,
  }) : super(key: key);

  final Color color;
  final Player player;

  Widget _pickerItem(int str) {
    return Text(
      str.toString(),
      style: const TextStyle(fontSize: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConfig.bgDarkGreen,
      elevation: 1.5,
      margin: const EdgeInsets.fromLTRB(6, 12, 6, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        // Make it splash on Android. It would happen automatically if this
        // was a real card but this is just a demo. Skip the splash on iOS.
        onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Text(
                  player.rank.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 16)),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        player.name,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      child: Center(
                        child: Text(
                          player.score.toString(),
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
                          player.result.toString(),
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
            ],
          ),
        ),
      ),
    );
  }
}
