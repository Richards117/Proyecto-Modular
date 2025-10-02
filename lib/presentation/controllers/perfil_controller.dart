import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/widgets/alerts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/screens/services/camera_gallery_service.dart';
import 'package:flutter_application_votacion/presentation/screens/services/profileimage_service.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilController {
  final WidgetRef ref;
  final BuildContext context;

  PerfilController({required this.ref, required this.context});

  /// Carga datos del usuario
  Map<String, dynamic> loadUserData() {
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) return {};

    return {
      'displayName': user.userMetadata?['display_name'] ?? 'Usuario',
      'email': user.email ?? 'Sin correo',
      'role': user.userMetadata?['role'] ?? 'Usuario',
      'profileImageUrl': user.userMetadata?['avatar_url'] ?? '',
    };
  }

  /// Cambiar foto de perfil
  Future<String?> changeProfilePhoto() async {
    int? option = await alertfoto(context);
    if (option == null) return null;

    CameraGalleryService service = CameraGalleryService();
    String? path;

    if (option == 1) path = await service.takePhoto();
    if (option == 2) path = await service.selectPhoto();

    if (path == null) return null;

    final File imageFile = File(path);
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) return null;

    final imageService = ProfileImageService();
    final imageUrl = await imageService.uploadProfileImage(imageFile, user.id);

    if (imageUrl != null) {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'avatar_url': imageUrl}),
      );
      await Supabase.instance.client.auth.refreshSession();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil actualizada')),
      );

      return imageUrl;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir la foto')),
      );
      return null;
    }
  }
}
