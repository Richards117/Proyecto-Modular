import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        //contenedor superior-----------------------
        _TopBox(),
      ],
    );
  }
}

//Icono superior de Person-----------------------------------------
/*class _IconHeard extends StatelessWidget {k
  const _IconHeard();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          size: 160,
          color: Colors.white,
          shadows: [
            BoxShadow(color: Colors.white, blurRadius: 40),
          ],
        ),
      ),
    );
  }
}*/

//Contenedor parte superior estructura-----------------------
class _TopBox extends StatelessWidget {
  const _TopBox();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: authBoxDecoration(),
      child: const PosisionetBooble(),
    );
  }

  BoxDecoration authBoxDecoration() => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.shade200,
            Colors.indigo.shade400,
          ],
        ),
      );
}

//Burbujas in Background
class Bubble extends StatelessWidget {
  const Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}

//Posiciones de las Burbujas de fondo en el contendor morado---------------
class PosisionetBooble extends StatelessWidget {
  const PosisionetBooble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(left: -10, top: 0, child: Bubble()),
        Positioned(left: -35, top: 250, child: Bubble()),
        Positioned(left: 330, top: -10, child: Bubble()),
        Positioned(left: 330, top: 190, child: Bubble()),
        Positioned(left: 200, top: 260, child: Bubble()),
        Positioned(left: 60, top: 168, child: Bubble()),
        Positioned(left: 200, top: 40, child: Bubble()),
        Positioned(left: 150, top: -80, child: Bubble()),
      ],
    );
  }
}
