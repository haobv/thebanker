/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/Player.dart';

class DataRepository {
  // 1
  final CollectionReference collection =
      Firestore.instance.collection('players');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  // 3
  Future<DocumentReference> addPlayer(Player palyer) {
    return collection.add(palyer.toJson());
  }

  // 4
  updatePlayer(Player player) async {
    await collection
        .document(player.reference.documentID)
        .updateData(player.toJson());
  }
}
*/
