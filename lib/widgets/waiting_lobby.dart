import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';

class WaitingLobby extends StatelessWidget {
  const WaitingLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Waiting for a player to join...'),
        const SizedBox(height: 20),
        SelectableText(Provider.of<RoomDataProvider>(context).roomData["_id"]),
      ],
    );
  }
}
