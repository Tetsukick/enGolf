import 'package:engolf/model/floor/entity/player.dart';
import 'package:flutter/material.dart';

import '../../../common/size_config.dart';

class AddEditPlayerDialog extends StatefulWidget {
  final Player? player;
  final void Function({required String playerName, required bool isMainUser, Player? player}) onEdit;

  AddEditPlayerDialog({this.player, required this.onEdit});

  @override
  _AddEditPlayerDialogState createState() => _AddEditPlayerDialogState();
}

class _AddEditPlayerDialogState extends State<AddEditPlayerDialog> {
  late TextEditingController _playerNameTextEditingController;
  bool isEdit = false;
  bool isMainUser = false;

  @override
  void initState() {
    setState(() {
      isEdit = widget.player != null;
      isMainUser = isEdit ? widget.player!.isMainUser : false;
      _playerNameTextEditingController =
          TextEditingController(text: isEdit ? widget.player!.name : '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? '${widget.player?.name ?? ""} を編集' : '新規Playerの追加'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _playerNameTextEditingController,
            decoration: const InputDecoration(hintText: "Input Player Name"),
          ),
          const SizedBox(height: SizeConfig.smallestMargin,),
          CheckboxListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: SizeConfig.smallestMargin),
            activeColor: Colors.blue,
            title: Transform.translate(
              offset: const Offset(-20, 0),
              child: Text(
                'メインユーザーとして設定する',
                style: TextStyle(
                    fontSize: 11
                ),
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: isMainUser,
            onChanged: (isOn) {
              setState(() {
                isMainUser = !isMainUser;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(isEdit ? 'Edit' : 'Add'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              if (_playerNameTextEditingController.text.isNotEmpty) {
                widget.onEdit(
                  playerName: _playerNameTextEditingController.text,
                  isMainUser: isMainUser,
                  player: widget.player
                );
              }
            });
          },
        ),
      ],
    );
  }
}
