import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.png';
    final storageRef = _supabase.storage.from('profile-images');

    try {
      final bytes = await imageFile.readAsBytes();

      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        print('No user logged in.');
        return null;
      }

      // 🔍 Ver metadata actual
      print('User metadata: ${currentUser.userMetadata}');

      // 🔄 Eliminar imagen anterior si existe
      final oldPath = currentUser.userMetadata?['avatar_path'] as String?;
      if (oldPath != null && oldPath.isNotEmpty) {
        print('Avatar path guardado en metadata: $oldPath');

        // (Opcional) lista todos los archivos en el bucket
        final listResult = await storageRef.list();
        final existingFiles = listResult.map((f) => f.name).toList();
        print('Archivos en el bucket: $existingFiles');

        // Eliminar si existe
        if (existingFiles.contains(oldPath)) {
          final deleteResult = await storageRef.remove([oldPath]);
          print('Delete result: $deleteResult');
        } else {
          print('Archivo anterior no encontrado: $oldPath');
        }
      }

      // 🚀 Subir nueva imagen
      await storageRef.uploadBinary(fileName, bytes);
      final publicUrl = storageRef.getPublicUrl(fileName);
      print('New image uploaded: $fileName -> $publicUrl');

      // 🧠 Actualizar metadata del usuario
      await _supabase.auth.updateUser(
        UserAttributes(data: {
          'avatar_url': publicUrl,
          'avatar_path': fileName,
        }),
      );

      return publicUrl;
    } catch (e, stack) {
      print('Error uploading image: $e');
      print(stack);
      return null;
    }
  }
}
