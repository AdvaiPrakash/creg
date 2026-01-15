import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadPlayerImage(XFile imageFile) async {
    try {
      final String fileName = 'player_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final Reference ref = _storage.ref().child(fileName);
      
      // Determine content type if possible, though usually not strictly required for basic upload
      // For web, we might need bytes, for mobile File. 
      // XFile abstraction handles this well usually, but let's check platform.
      
      // UploadTask supports putFile (mobile) or putData (web/bytes)
      // XFile has readAsBytes which works everywhere.
      
      final Uint8List data = await imageFile.readAsBytes();
      final UploadTask uploadTask = ref.putData(
        data, 
        SettableMetadata(contentType: 'image/jpeg') // Assuming jpeg/png, better to detect or leave valid
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
}
