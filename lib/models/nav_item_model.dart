import 'package:euphor/models/rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<NavItemModel> botttomNavItems = [
  NavItemModel(
    title: "Home",
    rive: RiveModel(
      src: "assets/rive/animated_icon_set.riv",
      artBoard: "HOME",
      stateMachineName: "HOME_interactivity", // lowercase i
    ),
  ),
  NavItemModel(
    title: "Friends",
    rive: RiveModel(
      src: "assets/rive/animated_icon_set.riv",
      artBoard: "CHAT",
      stateMachineName: "CHAT_Interactivity", // uppercase i
    ),
  ),
  NavItemModel(
    title: "Profile",
    rive: RiveModel(
      src: "assets/rive/animated_icon_set.riv",
      artBoard: "USER",
      stateMachineName: "USER_Interactivity",
    ),
  ),
];
