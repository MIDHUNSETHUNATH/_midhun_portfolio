// import 'dart:math' as math;
// import 'package:flutter/material.dart';

// class RotatingHeroImage extends StatefulWidget {
//   final bool isSmall;
//   const RotatingHeroImage({Key? key, this.isSmall = false}) : super(key: key);

//   @override
//   _RotatingHeroImageState createState() => _RotatingHeroImageState();
// }

// class _RotatingHeroImageState extends State<RotatingHeroImage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat(); // Infinite rotation
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Properly dispose of the controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Transform.rotate(
//           angle: _controller.value * 2 * math.pi, // 360-degree rotation
//           child: child,
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(30),
//         child: Center(
//           child: Container(
//             width: widget.isSmall ? 150 : 300,
//             height: widget.isSmall ? 150 : 300,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withOpacity(0.1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: ClipOval(
//             child: Image.asset(
//               "assets/profile_pic.jpeg", // Ensure this image is in the assets folder
//               fit: BoxFit.scaleDown,
//               width: isSmall ? 150 : 300,
//               height: isSmall ? 150 : 300,
//             ),
//           ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontWeight; // Keep it as double for better control
  final double fontSize; // Added missing fontSize
  final List<Color> gradientColors;

  const GradientText({
    super.key,
    required this.text,
    required this.fontWeight,
    required this.fontSize, // Required fontSize
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
          stops: const [0.0, 0.3, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize, // Apply font size
          fontWeight: FontWeight.values[fontWeight.toInt().clamp(0, 8)], // Convert double to valid weight
          height: 1.2, // Adjust line height
          letterSpacing: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
