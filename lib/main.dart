import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shaders_flutter/shader_draw.dart';

class ShaderHomePage extends StatefulWidget {
  const ShaderHomePage({super.key});

  @override
  State<ShaderHomePage> createState() => _ShaderHomePageState();
}

class _ShaderHomePageState extends State<ShaderHomePage> {
  late Timer timer;
  double delta = 0;
  FragmentShader? shader;

  void loadMyShader() async {
    var program = await FragmentProgram.fromAsset('shaders/planetary.frag');
    setState(() {
      shader = program.fragmentShader();
    });

    timer = Timer.periodic(const Duration(milliseconds: 11), (timer) {
      setState(() {
        delta += 1 / 90;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyShader();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    shader?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ShaderSplashScreen(
        backgroundWidget: PlanetaryShader(delta: delta, shader: shader),
        foregroundWidget: const CenterContent(),
      );
    }
  }
}

class ShaderSplashScreen extends StatelessWidget {
  const ShaderSplashScreen({
    super.key,
    required this.backgroundWidget,
    required this.foregroundWidget,
  });

  final Widget backgroundWidget;
  final Widget foregroundWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(225, 61, 118, 228),
                    Color.fromARGB(225, 43, 90, 194)
                  ],
                ),
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    backgroundWidget,
                    foregroundWidget,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlanetaryShader extends StatelessWidget {
  const PlanetaryShader({
    super.key,
    required this.shader,
    required this.delta,
  });

  final FragmentShader? shader;
  final double delta;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width - 50,
      width: MediaQuery.of(context).size.width - 50,
      child: Opacity(
        opacity: 0.2,
        child: Transform.scale(
          scale: 2.5,
          child: CustomPaint(
            painter: ShaderPainter(shader!, delta),
          ),
        ),
      ),
    );
  }
}

class CenterContent extends StatelessWidget {
  const CenterContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // Add a border radius to this container of 50
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                blurRadius: 20,
                color: Color.fromARGB(50, 0, 0, 0),
              )
            ],
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: const Image(
            image: AssetImage('assets/image.png'),
            height: 150,
            width: 150,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 32.0, bottom: 12),
          child: Text(
            'Bottle Rocket',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          'Flutter Rulez',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha(175),
          ),
        )
      ],
    );
  }
}

void main() {
  runApp(const ShaderHomePage());
}
