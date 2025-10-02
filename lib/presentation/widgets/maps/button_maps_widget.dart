// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ButtonMapsWidget extends StatefulWidget {
  final MapController mapController;

  const ButtonMapsWidget({super.key, required this.mapController});

  @override
  State<ButtonMapsWidget> createState() => _ButtonMapsWidgetState();
}

class _ButtonMapsWidgetState extends State<ButtonMapsWidget> {
  double zoom = 5.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Column(
        children: [
          // Botón de Zoom +
          _BuildZoomButton(
            icon: Icons.add,
            backgroundColor: Colors.blueAccent.shade700,
            onPressed: () {
              setState(() {
                zoom += 0.3;
                widget.mapController
                    .move(widget.mapController.camera.center, zoom);
              });
            },
          ),
          const SizedBox(height: 15),
          // Botón de Zoom -
          _BuildZoomButton(
            icon: Icons.remove,
            backgroundColor: Colors.redAccent.shade700,
            onPressed: () {
              setState(() {
                zoom -= 0.3;
                widget.mapController
                    .move(widget.mapController.camera.center, zoom);
              });
            },
          ),
        ],
      ),
    );
  }
}

class _BuildZoomButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _BuildZoomButton(
      {required this.icon,
      required this.backgroundColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor.withOpacity(0.8), backgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
