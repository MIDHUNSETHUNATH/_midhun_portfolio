
import 'package:flutter/material.dart';
import 'package:porfolio/main.dart';
import 'package:url_launcher/url_launcher.dart';


class ProjectDetailPage extends StatelessWidget {
  final ProjectData project;

  const ProjectDetailPage({super.key, required this.project});

  Future<void> _downloadApk(String apkUrl) async {
    final Uri url = Uri.parse(apkUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $apkUrl';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              project.imageUrls.first, // Display the first image as main image
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.description,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: project.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(project.productUrl))) {
                          await launchUrl(Uri.parse(project.productUrl), mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch ${project.productUrl}';
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button background color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding for better spacing
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners for a modern look
                        ),
                        elevation: 5, // Adds a subtle shadow effect
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.open_in_browser, color: Colors.black), // Browser icon
                          SizedBox(width: 8),
                          Text(
                            "Visit Product Page",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20,),
                         ElevatedButton(
  onPressed: () => _downloadApk(project.apkDownloadUrl),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.lightBlueAccent, // Button background color
    foregroundColor: Colors.white, // Text color
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    elevation: 8, // Shadow effect
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.download, color: Colors.black), // Download icon
      SizedBox(width: 8),
      Text(
        "Download APK",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  ),
),
                  ],
                ),

                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: project.pageimages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        project.pageimages[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}







