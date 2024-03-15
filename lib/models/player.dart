import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Player {
  final String nickname;
  final String socketid;
  final num points;
  final String playertype;

  Player({
    required this.nickname,
    required this.socketid,
    required this.points,
    required this.playertype,
  });

  Player copyWith({
    String? nickname,
    String? socketid,
    num? points,
    String? playertype,
  }) {
    return Player(
      nickname: nickname ?? this.nickname,
      socketid: socketid ?? this.socketid,
      points: points ?? this.points,
      playertype: playertype ?? this.playertype,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nickname': nickname,
      'socketid': socketid,
      'points': points,
      'playertype': playertype,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      nickname: map['nickname'] as String,
      socketid: map['socketid'] as String,
      points: map['points'] as num,
      playertype: map['playertype'] as String,
    );
  }

  @override
  bool operator ==(covariant Player other) {
    if (identical(this, other)) return true;
  
    return 
      other.nickname == nickname &&
      other.socketid == socketid &&
      other.points == points &&
      other.playertype == playertype;
  }

  @override
  int get hashCode {
    return nickname.hashCode ^
      socketid.hashCode ^
      points.hashCode ^
      playertype.hashCode;
  }

  factory Player.emptyPlayer() => Player(
        nickname: "",
        socketid: "",
        points: 0,
        playertype: "",
      );

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Player(nickname: $nickname, socketid: $socketid, points: $points, playertype: $playertype)';
  }
}
