

// class AnimatedContainerExample extends StatefulWidget {
//   const AnimatedContainerExample({super.key});

//   @override
//   _AnimatedContainerExampleState createState() =>
//       _AnimatedContainerExampleState();
// }

// class _AnimatedContainerExampleState extends State<AnimatedContainerExample>
//     with SingleTickerProviderStateMixin {
//   bool isVisible = false;
//   late AnimationController _controller;
//   late Animation<Offset> _jumpAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize AnimationController
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2), // Slow animation
//       vsync: this,
//     );

//     // Define the jumping animation
//     _jumpAnimation = Tween<Offset>(
//       begin: Offset.zero, // Start at the original position
//       end: const Offset(0, -0.1), // Move slightly upward
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut, // Smooth easing curve
//     ));

//     // Add a repeating animation loop
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed && isVisible) {
//         _controller.reverse(); // Reverse the animation
//       } else if (status == AnimationStatus.dismissed && isVisible) {
//         _controller.forward(); // Restart the animation
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
   


//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 10), // Responsive spacing
//             Center(
//               child: VisibilityDetector(
//                 key: const Key('animated-container'),
//                 onVisibilityChanged: (visibilityInfo) {
//                   if (visibilityInfo.visibleFraction > 0.3 && !isVisible) {
//                     setState(() => isVisible = true);
//                     _controller.forward(); // Start the animation
//                   } else if (visibilityInfo.visibleFraction < 0.1 && isVisible) {
//                     setState(() => isVisible = false);
//                     _controller.reset(); // Reset the animation
//                   }
//                 },
//                 child: AnimatedOpacity(
//                   duration: const Duration(milliseconds: 800),
//                   opacity: isVisible ? 1 : 0,
//                   child: SlideTransition(
//                     position: _jumpAnimation, // Apply the jumping animation
//                     child: Container(
//                       width: containerWidth,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.white, // White color
//                             Color.fromARGB(255, 173, 216, 230), // Light blue color
//                           ],
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 15,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(16),
//                               topRight: Radius.circular(16),
//                             ),
//                             child: AspectRatio(
//                               aspectRatio: 16 / 9,
                             
//                                 const SizedBox(height: 20),
//                                 TextButton(
//                                   onPressed: (
//                                    page+  ProjectDetailPage(),
//                                   ) {},
//                                   style: TextButton.styleFrom(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 24,
//                                       vertical: 12,
//                                     ),
//                                     backgroundColor: Colors.black,
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Text("View Project"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenSize.height * 0.5), // Responsive spacing
//           ],
//         ),
//       ),
//     );
//   }
// }