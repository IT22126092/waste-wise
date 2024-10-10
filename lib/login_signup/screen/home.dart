import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import '../../buy_sell/screen/buy_sell_screen.dart';
import '../../campaigns/campaigns_screen.dart';
import '../../reminders/reminders_screen.dart';
import 'package:waste_management/profile.dart';
import 'package:waste_management/recycling_tips/waste_categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    "Home",
    "Reminders",
    "Campaigns",
    "Buy & Sell",
    "Waste Categories",
    "Profile",
  ];

  final List<Widget> _children = [
    const HomePage(),
    const RemindersScreen(), // Reminders screen
    const CampaignsScreen(), // Campaigns screen
    Home_Screen(), // Buy & Sell screen
    const WasteCategoriesScreen(),
    const ProfileScreen(),
  ];

  // Function to check if the current index has an AppBar already
  bool _hasAppBar() {
    // Only show AppBar for the home and profile pages
    return _currentIndex == 0 || _currentIndex == 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _hasAppBar()
          ? AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C04B),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
        ],
      )
          : null, // Remove AppBar for pages like Reminders, Campaigns, etc.
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _currentIndex == 0 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: _currentIndex == 1 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign, color: _currentIndex == 2 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Campaigns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: _currentIndex == 3 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Buy & Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _currentIndex == 4 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Lookup',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 5 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.grey[200],
        selectedItemColor: const Color(0xFF00C04B),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/why_waste_management.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true; // Mark video as initialized
        });
      }).catchError((error) {
        setState(() {
          _hasError = true; // Mark error state
        });
        print("Error initializing video: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          return const Center(child: Text("Not logged in"));
        }

        return StreamBuilder<PrivacySettings>(
          stream: getPrivacySettingsStream(user.uid), // Stream for privacy settings
          builder: (context, privacySnapshot) {
            final privacySettings = privacySnapshot.data;

            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User profile image, name, and email under the top bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: (privacySettings?.allowProfilePic == true && user.photoURL != null && user.photoURL!.isNotEmpty)
                                ? NetworkImage(user.photoURL!)
                                : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome, ${user.displayName ?? 'User'}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.email ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Image slider below profile section
                    _buildImageSlider(),
                    const SizedBox(height: 20),

                    // App explanation before video section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "This app helps you manage waste effectively by providing tips on recycling, reminders for waste collection, and resources for buying and selling recycled materials. Let's work together to create a cleaner environment!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Grid view of components
                    _buildGridView(),

                    const SizedBox(height: 20),

                    // Video section
                    if (_hasError)
                      const Text(
                        "Error loading video. Please try again later.",
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      _buildVideoSection(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoSection() {
    return AnimatedOpacity(
      opacity: _isVideoInitialized ? 1.0 : 0.0,
      duration: const Duration(seconds: 1),
      child: Column(
        children: [
          const Text(
            "Why Waste Management is Really Important",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (_isVideoInitialized)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Text(
              _controller.value.isPlaying ? 'Pause Video' : 'Play Video',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: [
        'assets/images/home1.jpg',
        'assets/images/home2.jpg',
        'assets/images/home3.jpg',
        'assets/images/home4.png',
        'assets/images/home5.jpg',
      ].map((item) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(item, fit: BoxFit.cover, width: 1000),
        ),
      )).toList(),
    );
  }

  Widget _buildGridView() {
    final List<Map<String, dynamic>> components = [
      {
        'title': 'Reminders',
        'description': 'Set reminders for waste collection and recycling days.',
        'icon': Icons.alarm,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RemindersScreen()));
        },

      },
      {
        'title': 'Campaigns',
        'description': 'Join campaigns to promote waste management in your community.',
        'icon': Icons.campaign,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CampaignsScreen()));
        },
      },
      {
        'title': 'Buy & Sell',
        'description': 'Buy and sell recycled materials easily.',
        'icon': Icons.shopping_cart,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home_Screen()));
        },

      },
      {
        'title': 'Waste Categories',
        'description': 'Learn about different waste categories and their management.',
        'icon': Icons.category,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WasteCategoriesScreen()));
        },
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: components.length,
      itemBuilder: (context, index) {
        final component = components[index];
        return GestureDetector(
          onTap: component['onTap'],
          child: Card(
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(component['icon'], size: 40, color: const Color(0xFF00C04B)),
                const SizedBox(height: 10),
                Text(
                  component['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(component['description'], textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }

  Stream<PrivacySettings> getPrivacySettingsStream(String userId) {
    // Replace this with your logic to get the user's privacy settings from your backend
    return Stream.value(PrivacySettings(allowProfilePic: true)); // Example data
  }
}

class PrivacySettings {
  final bool allowProfilePic;

  PrivacySettings({required this.allowProfilePic});
}
