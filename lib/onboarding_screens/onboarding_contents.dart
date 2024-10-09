class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Join the Green Revolution!",
    image: "assets/images/image1.jpg",
    desc: "Be part of the solution! Track waste, learn recycling tips, and connect for a cleaner environment",
  ),
  OnboardingContents(
    title: "Smart Sorting Made Easy",
    image: "assets/images/image2.jpg",
    desc:
    "Confused about waste sorting? Our app offers clear guidelines and an easy sorting feature for correct disposal.",
  ),
  OnboardingContents(
    title: "Get Real-Time Waste Notifications",
    image: "assets/images/image3.jpg",
    desc:
    "Get real-time alerts! Never miss a waste collection or recycling event again.",
  ),
];