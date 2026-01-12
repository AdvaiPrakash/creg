
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';

class FirebaseService {
  // Using a getter or initializing inside the method is safer if the service is created early.
  CollectionReference get _playersCollection =>
      FirebaseFirestore.instance.collection('players');

  Future<void> addPlayer(Player player) async {
    try {
      final data = player.toMap();
      print("Attempting to add player data: $data"); // Debug log
      
      // Ensure no strictly required fields are null if Firestore complains (though it shouldn't for general docs)
      // But verify 'name', 'phone', 'email' are definitely there.
      
      await _playersCollection.add(data);
      print("Player added successfully");
    } catch (e, stackTrace) {
      print("Error adding player: $e");
      print(stackTrace);
      throw Exception('Failed to add player: $e');
    }
  }
}
