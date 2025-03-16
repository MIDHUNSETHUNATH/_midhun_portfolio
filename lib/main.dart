

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:porfolio/ui/open_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'My Portfolio',
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black,
            surface: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.black,
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.black,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.grey[900]!,
            surface: Colors.black,
          ),
        ),
        themeMode: ThemeMode.system,
        home:
        const HomePage(),
      );
    
    

  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());
  int _currentSection = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentSection);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCurrentSection);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateCurrentSection() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    int newSection = 0;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero).dy;
        if (position - 100 <= offset) {
          newSection = i;
        }
      }
    }
    if (newSection != _currentSection) {
      setState(() {
        _currentSection = newSection;
      });
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent, // Set background to transparent
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, // Start from top-left corner
          end: Alignment.bottomRight, // End at bottom-right corner
          colors: [
            Colors.white, // White color
            Color.fromARGB(255, 169, 213, 221), // Light blue color
          ],
          stops: [0.0, 1.0], // Define the color stops
        ),
      ),
      child: ScreenTypeLayout.builder(
        mobile: (context) => MobileView(
          scrollController: _scrollController,
          sectionKeys: _sectionKeys,
          currentSection: _currentSection,
          onSectionTap: _scrollToSection,
        ),
        tablet: (context) => TabletView(
          scrollController: _scrollController,
          sectionKeys: _sectionKeys,
          currentSection: _currentSection,
          onSectionTap: _scrollToSection,
        ),
        desktop: (context) => DesktopView(
          scrollController: _scrollController,
          sectionKeys: _sectionKeys,
          currentSection: _currentSection,
          onSectionTap: _scrollToSection,
        ),
      ),
    ),
  );
}
}


// Navigation Bar
class NavBar extends StatelessWidget {
  final int currentSection;
  final Function(int) onSectionTap;
  final bool isMobile;

  const NavBar({
    super.key,
    required this.currentSection,
    required this.onSectionTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _NavItemData(title: "Home", icon: Icons.home),
      _NavItemData(title: "About", icon: Icons.person),
      _NavItemData(title: "Skills", icon: Icons.code),
      _NavItemData(title: "Projects", icon: Icons.work),
      _NavItemData(title: "Contact", icon: Icons.mail),
    ];

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              "MS",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: navItems.length,
                      itemBuilder: (context, index) {
                        final item = navItems[index];
                        final bool isSelected = currentSection == index;
                        return ListTile(
                          leading: isMobile
                              ? null
                              : Icon(
                                  item.icon,
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.greenAccent,
                                ),
                          trailing: isMobile
                              ? Icon(
                                  item.icon,
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.green,
                                )
                              : null,
                          title: Text(
                            item.title,
                            textAlign:
                                isMobile ? TextAlign.right : TextAlign.left,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          tileColor: isSelected
                              ? Colors.red.withOpacity(0.5)
                              : Colors.transparent,
                          selected: isSelected,
                          onTap: () {
                            Navigator.pop(context);
                            onSectionTap(index);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            "MS",
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              return NavItem(
                title: item.title,
                isActive: currentSection == index,
                onTap: () => onSectionTap(index),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  final String title;
  final IconData icon;
  _NavItemData({required this.title, required this.icon});
}

class NavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.red : Colors.grey,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// Mobile View
class MobileView extends StatelessWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;
  final int currentSection;
  final Function(int) onSectionTap;

  const MobileView({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          NavBar(
            currentSection: currentSection,
            onSectionTap: onSectionTap,
            isMobile: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  HeroSection(key: sectionKeys[0]),
                  AboutSection(key: sectionKeys[1]),
                  SkillsSection(key: sectionKeys[2]),
                  ProjectsSection(key: sectionKeys[3]),
                  ContactSection(key: sectionKeys[4]),
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tablet View
class TabletView extends StatelessWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;
  final int currentSection;
  final Function(int) onSectionTap;

  const TabletView({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavBar(currentSection: currentSection, onSectionTap: onSectionTap),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                HeroSection(key: sectionKeys[0]),
                AboutSection(key: sectionKeys[1]),
                SkillsSection(key: sectionKeys[2]),
                ProjectsSection(key: sectionKeys[3]),
                ContactSection(key: sectionKeys[4]),
                const FooterSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Desktop View
class DesktopView extends StatelessWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;
  final int currentSection;
  final Function(int) onSectionTap;

  const DesktopView({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavBar(currentSection: currentSection, onSectionTap: onSectionTap),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                HeroSection(key: sectionKeys[0]),
                AboutSection(key: sectionKeys[1]),
                SkillsSection(key: sectionKeys[2]),
                ProjectsSection(key: sectionKeys[3]),
                ContactSection(key: sectionKeys[4]),
                const FooterSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          AutoSizeText(
            title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            maxLines: 1,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 4,
            width: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}



class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  _HeroSectionState createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  double opacity = 0.0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => opacity = 1.0);
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;
        final width = sizingInformation.screenSize.width;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: isDesktop ? 600 : 500,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 70, 169, 215), Color.fromARGB(255, 195, 140, 140)], // Green & Black Gradient
            ),
          ),
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(child: _buildHeroContent(context)),
                    Expanded(child: _buildHeroImage()),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (width > 400) _buildHeroImage(isSmall: true),
                    Expanded(child: _buildHeroContent(context, isSmall: true)),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeroContent(BuildContext context, {bool isSmall = false}) {
    return Padding(
      padding: EdgeInsets.all(isSmall ? 20 : 40),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(seconds: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isSmall ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              "Hello, I'm",
              style: GoogleFonts.poppins(fontSize: isSmall ? 16 : 20, color: Colors.white70),
              textAlign: isSmall ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              "MIDHUN SETHUNATH",
              style: GoogleFonts.poppins(fontSize: isSmall ? 38 : 48, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
              textAlign: isSmall ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 15),
            AutoSizeText(
              "Flutter Developer",
              style: GoogleFonts.poppins(fontSize: isSmall ? 20 : 24, color: Colors.white),
              maxLines: 2,
              textAlign: isSmall ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: isSmall ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                _animatedButton(
                  text: "Hire Me",
                  color: Colors.white,
                  textColor: Colors.black, borderColor: Colors.greenAccent,
                  onPressed: () {
                    _sendEmail();
                  },
                ),
                const SizedBox(width: 20),
                _animatedButton(
                  text: "Download CV",
                  color: Colors.transparent,
                  textColor: Colors.white,
                  borderColor: Colors.greenAccent,
                  onPressed: () async {
                    await downloadAndOpenCV(context);
                  },
                ),
               

              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: isSmall ? MainAxisAlignment.center : MainAxisAlignment.start,
  children: [
    _animatedButton(
      
      text: "LinkedIn",
      color: Colors.transparent,
      textColor: Colors.white,
      borderColor: Colors.greenAccent,
      icon: Icons.linked_camera,
      iconColor: Colors.black,

      onPressed: () async {
        const String linkedInUrl = "https://www.linkedin.com/in/midhun-sethunath-272339194/";
        
        if (await canLaunchUrl(Uri.parse(linkedInUrl))) {
          await launchUrl(Uri.parse(linkedInUrl));
        } else {
          throw "Could not launch $linkedInUrl";
        }
      },
    ),
    SizedBox(width: 20),
     _animatedButton(
      
      text: "git",
      color: Colors.white,
      textColor: Colors.black,
      borderColor: Colors.black,
      icon: Icons.gite,
      iconColor: Colors.black,

      onPressed: () async {
        const String githubUrl = "https://github.com/MIDHUNSETHUNATH";
        
        if (await canLaunchUrl(Uri.parse(githubUrl))) {
          await launchUrl(Uri.parse(githubUrl));
        } else {
          throw "Could not launch $githubUrl";
        }
      },
    ),
  ],
)
          ],
        ),
      ),
    );
  }

  // Animated Button Function
  Widget _animatedButton({
    required String text,
    required Color color,
    required Color textColor,

    Color? borderColor,
    IconData?icon,
    Color? iconColor,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text(text),
        ),
      ),
    );
  }

  // Hero Image
  Widget _buildHeroImage({bool isSmall = false}) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          width: isSmall ? 150 : 300,
          height: isSmall ? 150 : 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 5),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/profile_pic.jpeg", // Ensure this image is in the assets folder
              fit: BoxFit.scaleDown,
              width: isSmall ? 150 : 300,
              height: isSmall ? 150 : 300,
            ),
          ),
        ),
      ),
    );
  }

  // Function to Open Mail App
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'midhuns576@gmail.com',
      queryParameters: {
        'subject': 'Job Opportunity',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print("Could not open email client");
    }
  }



 Future<void> downloadAndOpenCV(BuildContext context) async {
    // Define the path to your local CV asset
    final String cvAssetPath = 'assets/Midhun FlutterDev.pdf';

    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();

    // Define the path to save the downloaded file
    final String tempFilePath = '${tempDir.path}/Midhun_FlutterDev.pdf';

    // Copy the asset to the temporary directory
    final ByteData data = await rootBundle.load(cvAssetPath);
    final List<int> bytes = data.buffer.asUint8List();
    await File(tempFilePath).writeAsBytes(bytes);

    // Open the file
    final Uri uri = Uri.file(tempFilePath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the CV')),
      );
    }
  }

}







// About Section
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 100 : 20,
            vertical: 60,
          ),
          child: Column(
            children: [
              const SectionTitle(title: "About Me"),
              const SizedBox(height: 20),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAboutImage()),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 2,
                          child: _buildAboutContent(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildAboutImage(isSmall: true),
                        const SizedBox(height: 30),
                        _buildAboutContent(),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
Widget _buildAboutImage({bool isSmall = false}) {
  return Container(
    width: isSmall ? 200 : double.infinity,
    height: isSmall ? 200 : 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey[300],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10), // Apply rounded corners
      child: Image.asset(
        "assets/about_pic.jpeg", // Ensure this file exists in the assets folder
        width: isSmall ? 100 : 150, // Adjust the width
        height: isSmall ? 100 : 150, // Adjust the height
        fit: BoxFit.fill, // Ensure the image scales properly
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              "Image Not Found",
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    ),
  );
}



  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          "Who am I?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 20),
        const AutoSizeText(
          "I am a passionate Flutter developer with 1+ years of experience in building cross-platform applications. I specialize in creating beautiful, responsive, and user-friendly applications that run smoothly on multiple platforms, RestApi intergration, json datas dynamic fetch ,.env files , language localization, Pushnotification,firebase intergration, well aboot the customize ui widget tree , flutter keys use for widget idenfication , and multiple platform in a single code base that was best advantages, apk bilde and sdk knowlwdge, git repository flow ,like push pull merge amd orgin push. have git conflits solving  skill, agile methedology , jira following for projrct update and cycle. apk and deployment to Appstore and Play store ",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 15),
        const AutoSizeText(
          "My journey in  started with  Account exicutive , that job was i feel very boring, so i quited, but I quickly fell in love with Flutter for market value and its flexibility and performance. I enjoy solving complex problems and turning ideas into reality through clean and efficient code.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.teal
          ),
        ),
         const SizedBox(height: 15),
       AutoSizeText(
  "✅ iOS Apps & API Integration\n✅ Flutter & Cross-Platform Apps\n✅ UI/UX Design Projects.",
  style: TextStyle(
    fontSize: 16,
    height: 1.6,
  ),
),

        const SizedBox(height: 30),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildInfoItem("Name", "Midhun Sethunath"),
            _buildInfoItem("Email", "midhuns576@gmail.com"),
            _buildInfoItem("Location", "chalakudy, thrissur"),
            _buildInfoItem("Experience", "1+ Years"),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}



class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;
        final isTablet = sizingInformation.isTablet;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 100 : 20,
            vertical: 60,
          ),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              const Text(
                "My Skills",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Skill Cards Grid
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildSkillCard("Flutter", 95, context,
                      width: isDesktop ? 300 : (isTablet ? 250 : null)),
                  _buildSkillCard("Dart", 90, context,
                      width: isDesktop ? 300 : (isTablet ? 250 : null)),
                  _buildSkillCard("Firebase", 85, context,
                      width: isDesktop ? 300 : (isTablet ? 250 : null)),
                  _buildSkillCard("UI/UX Design", 80, context,
                      width: isDesktop ? 300 : (isTablet ? 250 : null)),
                  _buildSkillCard("iOS Swift", 75, context,
                      width: isDesktop ? 300 : (isTablet ? 250 : null)),
                  _buildSkillCard("Xcode", 70, context,
                      width: isDesktop ? 300 : (isTablet ? 250 : null)),
                ],
              ),

              const SizedBox(height: 50),

              // Tools & Technologies Section
              const Text(
                "Tools & Technologies",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Tool Chips with Animated Borders
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(toolNames.length,
                    (index) => AnimatedToolChip(toolNames[index], index)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Skill Card UI
  Widget _buildSkillCard(String name, int percentage, BuildContext context,
      {double? width}) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 350,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, // Skill Card Background
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Progress Bar
            Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 10,
                  width: (percentage / 100) * (width ?? 300),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Percentage Text
            Text(
              "$percentage%",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tools List
final List<String> toolNames = [
  "Git",
  "GitHub",
  "Jira",
  "Figma",
  "Adobe XD",
  "VS Code",
  "Android Studio",
  "Xcode",
  "Canva Design"
];

// Animated Tool Chip with Gradient Border


class AnimatedToolChip extends StatefulWidget {
  final String toolName;
  final int index;

  const AnimatedToolChip(this.toolName, this.index, {super.key});

  @override
  _AnimatedToolChipState createState() => _AnimatedToolChipState();
}

class _AnimatedToolChipState extends State<AnimatedToolChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Color> borderColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();

    // Animation Controller for continuous looping every 1 second
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // 1 Second Speed
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(2), // Border Padding
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: SweepGradient(
                colors: _animatedBorderColors(),
                stops: _generateStops(),
              ),
            ),
            child: Chip(
              label: Text(
                widget.toolName,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        );
      },
    );
  }

  // Generate a Running Gradient with 7 Colors Animation
  List<Color> _animatedBorderColors() {
    final int colorIndex = (widget.index + (_animation.value * borderColors.length).toInt()) % borderColors.length;
    return [
      borderColors[(colorIndex + 0) % borderColors.length],
      borderColors[(colorIndex + 1) % borderColors.length],
      borderColors[(colorIndex + 2) % borderColors.length],
      borderColors[(colorIndex + 3) % borderColors.length],
      borderColors[(colorIndex + 4) % borderColors.length],
      borderColors[(colorIndex + 5) % borderColors.length],
      borderColors[(colorIndex + 6) % borderColors.length],
    ];
  }

  // Generate Stops for Smooth Animation
  List<double> _generateStops() {
    return List.generate(7, (index) => index / 7);
  }
}




class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  _ProjectsSectionState createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {

  bool _showAllProjects = false;
    bool isVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _jumpAnimation;
  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Slow animation
      vsync: this,
    );

    // Define the jumping animation
    _jumpAnimation = Tween<Offset>(
      begin: Offset.zero, // Start at the original position
      end: const Offset(0, -0.1), // Move slightly upward
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth easing curve
    ));

    // Add a repeating animation loop
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && isVisible) {
        _controller.reverse(); // Reverse the animation
      } else if (status == AnimationStatus.dismissed && isVisible) {
        _controller.forward(); // Restart the animation
      }
    });
  }

  final List<ProjectData> projects = [
    ProjectData(
      title: "Pokak Even Managent",
      description: "A full-featured slote booking and catering with music show.. business logic for bloc and cubit,application built with Flutter and Python .",
      imageUrls: ["assets/project/project event.jpeg"],
     pageimages:["assets/project/singup_event.jpeg","assets/project/event_otp.jpeg","assets/project/event_home.jpeg",
     "assets/project/home_2.jpeg",
     "assets/project/lun.jpeg","assets/project/lun_2.jpeg","assets/project/event_profile.jpeg",],

      tags: ["Flutter ","mvvm Architecture", "RestApi integration","pushnotification"],
       productUrl: "https://midhunsethunath.com", 
      apkDownloadUrl: "https://drive.google.com/uc?id=181PIjrvHNoSh79tybSLDARp_HeXvn2-S&export=download",
    ),
    ProjectData(
      title: "Pokak billing App",
      description: "A beautiful billing and quatation for customer app with animations and real-time updates.its collabration project with team",
      imageUrls: ["assets/billing/four_b.jpeg"],
       pageimages: [" assets/billing/splash.jpeg",
    "assets/billing/four_b.jpeg",
    "assets/billing/three_b.jpeg",
    "assets/billing/four_b.jpeg"],

      tags: ["Flutter", "REST API_http", "Animations"],
      productUrl: "https://www.figma.com/design/BFoIBEBnc5UgyEyHO4IUWI/Pokak-Event-Management-app-01?node-id=0-1&node-type=canvas&t=b6LAC9odNVW0c8t4-0",
      apkDownloadUrl: "https://example.com/weather-app.apk",
    ),
    ProjectData(
      title: "yalfish",
      description: "A productivity app to help users manage daily tasks and goals and collabration.",
      imageUrls: ["assets/project_two/splash.jpeg"],
      pageimages:["assets/project_two/splash.jpeg","assets/project_two/screen_two.jpeg",
      "assets/project_two/keybord_k.jpeg","assets/project_two/home_screen.jpeg",
      "assets/project_two/home_two.jpeg","assets/project_two/discrip_edit.jpeg",
      "assets/project_two/descri.jpeg",
      "assets/project_two/order.jpeg",
      "assets/project_two/home_shop.jpeg",],
      tags: ["Flutter", "RestApi_ dio", "State Management_provider","api nodejs"],
      productUrl: "https://example.com/task-manager",
      apkDownloadUrl: "https://example.com/task-manager.apk",
    ),
    // ProjectData(
    //   title: "TN Poster",
    //   description: "A social networking application with its my first freelance  real-time runing  poster customing and edit ,ready to download and updates  for adminpanel, chat and pushnotifications.well responsive ui and widget tree and keys idetifiction and widget reusable widgets",
    //   imageUrls: ["assets/images/social1.png", "assets/images/social2.png"],
    //   pageimages:[],
    //   tags: ["Flutter", "Firebase", "mvvm","Getx"],
    //   productUrl: "https://example.com/social-app",
    //   apkDownloadUrl: "https://example.com/social-app.apk",
    // ),
    // ProjectData(
    //   title: "api fetcth",
    //   description: "Login Screen with User Name and Password and Login button, when the button,Login Screen with User Name and Password and Login button, when the button, if the response is Success then go to the Home screen and display user details, if it is false then toast the response error message,",
    //   imageUrls: ["assets/images/fitness1.png", "assets/images/fitness2.png"],
    //   pageimages:[],
    //   tags: ["Flutter", "Health API", "Charts"],
    //   productUrl: "https://example.com/fitness-tracker",
    //   apkDownloadUrl: "https://example.com/fitness-tracker.apk",
    // ),
    // ProjectData(
    //   title: "plungs",
    //   description: "Flutter Plugin for Accelerometer Sensor Data.Displays real-time x, y, z sensor values in the UI.Includes a start/stop functionality for fetching sensor data.",
    //   imageUrls: ["assets/plugns/first.jpeg",],
    //   pageimages:["assets/plugns/first.jpeg","assets/plugns/second.jpeg"],
    //   tags: ["Flutter", "java native", " GetX ",],
    //   productUrl: "https://www.figma.com/design/BFoIBEBnc5UgyEyHO4IUWI/Pokak-Event-Management-app-01?node-id=0-1&node-type=canvas&t=b6LAC9odNVW0c8t4-0",
    //   apkDownloadUrl: "https://example.com/expense-tracker.apk",
    // ),
  ];

  @override
    void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show only 4 projects initially
    final displayedProjects = _showAllProjects ? projects : projects.take(4).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          const Text(
            "My Projects",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: displayedProjects.map((project) {
              return _buildProjectCard(project, context);
            }).toList(),
          ),
          const SizedBox(height: 40),

          // "View All Projects" button
          if (!_showAllProjects)
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _showAllProjects = true;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text("View All Projects"),
            ),
        ],
      ),
    );
  }

Widget _buildProjectCard(ProjectData project, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Show loading before navigation
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        },
      );

      // Delay navigation to show loading effect
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context); // Close loading dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailPage(project: project),
          ),
        );
      });
    },
    child: VisibilityDetector(
      key: Key(project.title), // Unique key for each project
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.3 && !isVisible) {
          setState(() => isVisible = true);
          _controller.forward(); // Start the animation
        } else if (visibilityInfo.visibleFraction < 0.1 && isVisible) {
          setState(() => isVisible = false);
          _controller.reset(); // Reset the animation
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: isVisible ? 1 : 0,
        child: SlideTransition(
          position: _jumpAnimation, // Apply the jumping animation
          child: Container(
            width: 300, // Responsive width
            padding: EdgeInsets.all(16), // Responsive padding
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18), // Responsive radius
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white, // White color
                  Color.fromARGB(255, 173, 216, 230), // Light blue color
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      project.imageUrls[0], // First image in the list
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Project Title
                SizedBox(height: 10),
                Text(
                  project.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Project Description
                SizedBox(height: 10),
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Tags
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: project.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.blue[50],
                    );
                  }).toList(),
                ),

                // View Project Button
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailPage(project: project),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "View Project",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}

// Project Data Model
class ProjectData {
  final String title;
  final String description;
  final List<String> imageUrls;
  final List<String> tags;
  final String productUrl;
  final String apkDownloadUrl;
 final List<String>pageimages;

  ProjectData({
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.tags,
    required this.productUrl,
    required this.apkDownloadUrl,
    required this.pageimages ,
  });
}



// Contact Section
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 100 : 20,
            vertical: 60,
          ),
          child: Column(
            children: [
              const SectionTitle(title: "Contact Me"),
              const SizedBox(height: 40),
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildContactForm(context),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: _buildContactDetails(context),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildContactForm(context),
                        const SizedBox(height: 40),
                        _buildContactDetails(context),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Send me a message",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Your Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Your Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Your Message",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 130, 36, 99),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              
            ),
            child: const Text("Send Message",style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildContactDetailItem(context,Icons.email, "midhuns576@gmail.com", () {
          _launchURL("midhuns576@gmail.com");
        }),
        const SizedBox(height: 15),
        _buildContactDetailItem(context,Icons.phone, "+917907777032", () {
          _launchURL("tel:+917907777032");
        }),
        const SizedBox(height: 15),
        _buildContactDetailItem(context,Icons.location_on, "Kelara, india", () {}),
      ],
    );
  }

  Widget _buildContactDetailItem(
      BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Footer Section
// // Footer Section
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: AutoSizeText(
          "© 2025 My Portfolio. All rights reserved.",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
