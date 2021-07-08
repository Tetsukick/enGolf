import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key key,
    this.color,
    this.player,
  }) : super(key: key);

  final Color color;
  final Player player;

  static final List<int> _scoreItems = List.generate(201, (i) => i - 100);

  Widget _pickerItem(int str) {
    return Center(
      child: Text(
        str.toString(),
        style: const TextStyle(fontSize: 20, color: ColorConfig.textGreenLight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    return Card(
      color: ColorConfig.bgDarkGreen,
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(
          vertical: SizeConfig.mediumSmallMargin,
          horizontal: SizeConfig.smallestMargin),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.smallestMargin),
      ),
      child: InkWell(
        onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConfig.smallMargin,
            vertical: SizeConfig.mediumSmallMargin
          ),
          child: Container(
            width: 62,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  child: Text(
                    player.rank.toString(),
                    style: const TextStyle(
                      color: ColorConfig.textGreenLight,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: SizeConfig.smallMargin),
                Text(
                  player.result.toString(),
                  style: const TextStyle(
                    color: ColorConfig.textGreenLight,
                    fontSize: SizeConfig.mediumLargeMargin,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SizeConfig.smallMargin),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(text: player.name),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 0.0),
                    ),
                  ),
                  style: TextStyle(
                    color: ColorConfig.textGreenLight,
                    fontSize: 16,
                  ),
                  onFieldSubmitted: (text) {
                    final tempPlayer = player
                      ..name = text;
                    olympicBloc.changePlayerAction.add(tempPlayer);
                  },
                ),
                const SizedBox(height: SizeConfig.smallMargin),
                Expanded(
                  child: Container(
                    width: 50,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: _scoreItems.indexOf(player.score)),
                      itemExtent: 26,
                      children: _scoreItems.map(_pickerItem).toList(),
                      onSelectedItemChanged: (pickerIndex) {
                        player.score = _scoreItems[pickerIndex];
                        olympicBloc.changePlayerAction.add(player);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
