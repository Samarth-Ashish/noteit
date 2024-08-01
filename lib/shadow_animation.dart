import 'package:flutter/material.dart';

class ShadowAnimationScreen extends StatefulWidget {
  const ShadowAnimationScreen({super.key});

  @override
  State<ShadowAnimationScreen> createState() => _ShadowAnimationScreenState();
}

class _ShadowAnimationScreenState extends State<ShadowAnimationScreen> {
  bool _isElevated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animate Shadow Example'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isElevated = !_isElevated;
            });
          },
          child: TweenAnimationBuilder<BoxShadow>(
            duration: const Duration(seconds: 1),
            tween: BoxShadowTween(
              begin: _isElevated
                  ? BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
              end: _isElevated
                  ? BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
            ),
            builder: (context, boxShadow, child) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [boxShadow],
                ),
                child: const Center(
                  child: Text(
                    'Tap me',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BoxShadowTween extends Tween<BoxShadow> {
  BoxShadowTween({BoxShadow? begin, BoxShadow? end}) : super(begin: begin, end: end);

  @override
  BoxShadow lerp(double t) {
    return BoxShadow(
      color: Color.lerp(begin!.color, end!.color, t)!,
      blurRadius: lerpDouble(begin!.blurRadius, end!.blurRadius, t)!,
      spreadRadius: lerpDouble(begin!.spreadRadius, end!.spreadRadius, t)!,
      offset: Offset.lerp(begin!.offset, end!.offset, t)!,
    );
  }
}

double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
