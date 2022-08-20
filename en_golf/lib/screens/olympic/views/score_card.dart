import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/model/floor/entity/player.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:engolf/screens/player_search/player_select_screen.dart';
import 'package:engolf/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key? key,
    this.color,
    required this.player,
  }) : super(key: key);

  final Color? color;
  final PlayerResult player;

  static final List<int?> _scoreItems = List.generate(201, (i) => i - 100);

  Widget _pickerItem(int? str) {
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
    final size = MediaQuery.of(context).size;
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
            width: 60,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _rankWidget(),
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
                _playerNameTextField(context),
                const SizedBox(height: SizeConfig.smallMargin),
                Expanded(
                  child: Container(
                    width: 50,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: _scoreItems.indexOf(player.score)),
                      itemExtent: 26,
                      children: _scoreItems.map(_pickerItem).toList(),
                      onSelectedItemChanged: (pickerIndex) {
                        player.score = _scoreItems[pickerIndex]!;
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

  Widget _rankWidget() {

    const rankIconSize = 40.0;
    if (player.rank == 1) {
      return Image.asset('assets/gold-cup_128.png', width: rankIconSize,);
    } else if (player.rank == 2) {
      return Image.asset('assets/silver-cup_128.png', width: rankIconSize,);
    } else if (player.rank == 3) {
      return Image.asset('assets/bronze-cup_128.png', width: rankIconSize,);
    }

    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        player.rank.toString(),
        style: const TextStyle(
          color: ColorConfig.textGreenLight,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _playerNameTextField(BuildContext context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    final _textEditingController = TextEditingController(text: player.name);
    return GestureDetector(
      onTap: () async {
        final tempPlayerName = await Navigator.push(
            context,
            MaterialPageRoute<Player>(
                builder: (BuildContext context) {
                  return PlayerSelectScreen();
                },
                fullscreenDialog: true,),);
        final tempPlayer = player
          ..name = tempPlayerName?.name ?? player.name;
        olympicBloc.changePlayerAction.add(tempPlayer);
      },
      child: TextFormField(
        enabled: false,
        textAlign: TextAlign.center,
        controller: _textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
        ),
        style: TextStyle(
          color: ColorConfig.textGreenLight,
          fontSize: 16,
        ),
      ),
    );
  }
}
