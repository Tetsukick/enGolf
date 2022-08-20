import 'package:flutter/material.dart';

import '../../../common/color_config.dart';
import '../../../common/size_config.dart';
import '../../../model/floor/entity/player.dart';

class PlayerCard extends StatefulWidget {
  final Player player;
  final void Function() onTap;

  PlayerCard({required this.player, required this.onTap});

  @override
  _PlayerCardState createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
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
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(left: 8)),
              Image.asset('assets/player_128.png',
                width: 24,
              ),
              const SizedBox(width: SizeConfig.smallMargin,),
              Visibility(
                visible: widget.player.isMainUser,
                child: Image.asset('assets/king_128.png',
                  width: 20,
                ),
              ),
              Visibility(
                visible: widget.player.isMainUser,
                child: const SizedBox(width: SizeConfig.smallMargin,),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.player.name ?? '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                  size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
