
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';

class FirebaseService {
  // Using a getter or initializing inside the method is safer if the service is created early.
  CollectionReference get _playersCollection =>
      FirebaseFirestore.instance.collection('players');

  Future<void> addPlayer(Player player) async {
    try {
      final data = player.toMap();
      // Remove null values to ensure cleaner Firestore documents and avoid 'null value' errors if any strict checks exist
      data.removeWhere((key, value) => value == null);
      
      print("Attempting to add player data: $data"); // Debug log
      
      await _playersCollection.add(data);
      print("Player added successfully");
    } catch (e, stackTrace) {
      print("Error adding player: $e");
      print(stackTrace);
      throw Exception('Failed to add player: $e');
    }
  }
  Stream<List<Player>> getPlayers() {
    return _playersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Player.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updatePlayer(Player player) async {
    try {
      final data = player.toMap();
      data.removeWhere((key, value) => value == null);
      if (player.id == null) throw Exception('Player ID is required for update');
      await _playersCollection.doc(player.id).update(data);
    } catch (e) {
      print("Error updating player: $e");
      throw Exception('Failed to update player: $e');
    }
  }

  Future<void> deletePlayer(String id) async {
    try {
      await _playersCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting player: $e");
      throw Exception('Failed to delete player: $e');
    }
  }
}
