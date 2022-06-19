// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:my_app/models/player.dart';
//
// class Game {
//   // 1
//   String name;
//   // 2
//   List<Player> players = [];
//   // 3
//   DocumentReference reference;
//   // 4
//   Game(this.name, this.players, this.reference);
//   // 5
//   factory Game.fromSnapshot(DocumentSnapshot snapshot) {
//     Game newGame = Game.fromJson(snapshot.data);
//     newGame.reference = snapshot.reference;
//     return newGame;
//   }
//   // 6
//   factory Game.fromJson(Map<String, dynamic> json) => _GameFromJson(json);
//   // 7
//   Map<String, dynamic> toJson() => _GameToJson(this);
//   @override
//   String toString() => "Game<$name>";
// }
//
// // 1
// Game _GameFromJson(Map<String, dynamic> json) {
//   return Game(
//     json['name'] as String,
//     _convertPlayers(json['players'] as List),
//     json['type'] as DocumentReference,
//   );
// }
//
// // 2
// List<Player> _convertPlayers(List playerMap) {
//   // if (playerMap == null) {
//   //   return null;
//   // }
//   List<Player> players = [];
//   playerMap.forEach((value) {
//     players.add(Player.fromJson(value));
//   });
//   return players;
// }
//
// // 3
// Map<String, dynamic> _GameToJson(Game instance) => <String, dynamic>{
//       'name': instance.name,
//       'players': _PlayerList(instance.players),
//     };
// // 4
// List<Map<String, dynamic>>? _PlayerList(List<Player> players) {
//   if (players == null) {
//     return null;
//   }
//   List<Map<String, dynamic>> playerMap = [];
//   players.forEach((player) {
//     playerMap.add(player.toJson());
//   });
//   return playerMap;
// }
