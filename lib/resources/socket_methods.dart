import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/utils/utils.dart';

import 'game_methods.dart';
import 'socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createroom', {
        "nickname": nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit('joinroom', {
        'nickname': nickname,
        'roomid': roomId,
      });
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomid': roomId,
      });
    }
  }

  // LISTENERS

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createroomsuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);

      log(room.toString());
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinroomsuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context) {
    _socketClient.on('erroroccured', (data) {
      showSnackBar(context, data);
    });
  }

  //Function
  void updatePlayerState(BuildContext context) {
    _socketClient.on('updateplayers', (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer1(playerData[0]);
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer2(playerData[1]);
    });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.on('updateroom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tapListener(BuildContext context) {
    _socketClient.on('tapped', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateDisplayElement(data['index'], data['choice']);
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data['room']);
      GameMethods().checkWinner(context, socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointincrease', (playerdata) {
      var roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerdata['socketid'] == roomDataProvider.player1.socketid) {
        roomDataProvider.updatePlayer1(playerdata);
      } else {
        roomDataProvider.updatePlayer2(playerdata);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endgame', (playerdata) {
      showGameDialog(context, '${playerdata['nickname']} won the game!');
      Navigator.of(context).popUntil((route) => false);
    });
  }
}
