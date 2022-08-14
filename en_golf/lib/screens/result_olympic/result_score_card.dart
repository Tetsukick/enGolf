import 'package:engolf/common/color_config.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScoreCard extends StatelessWidget {
  const ResultScoreCard({
    Key? key,
    this.color,
    this.player,
  }) : super(key: key);

  final Color? color;
  final PlayerResult? player;

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
      margin: const EdgeInsets.fromLTRB(6, 8, 6, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _rankWidget(),
              Padding(padding: EdgeInsets.only(left: 16)),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        player!.name!,
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
                          player!.score.toString(),
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
                          player!.result.toString(),
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

  Widget _rankWidget() {

    const rankIconSize = 40.0;
    if (player?.rank == 1) {
      return Image.asset('assets/gold-cup_128.png', width: rankIconSize,);
    } else if (player?.rank == 2) {
      return Image.asset('assets/silver-cup_128.png', width: rankIconSize,);
    } else if (player?.rank == 3) {
      return Image.asset('assets/bronze-cup_128.png', width: rankIconSize,);
    }

    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        player?.rank.toString() ?? '',
        style: const TextStyle(
          color: ColorConfig.textGreenLight,
          fontSize: 16,
        ),
      ),
    );
  }
}
