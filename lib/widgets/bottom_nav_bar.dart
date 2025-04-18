import 'package:euphor/core/theme/app_theme.dart';
import 'package:euphor/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];
  int selectedNavIndex = 0;
  void animateIcon(int index) {
    riveIconInputs[index].change(true);
    print("changed to true");
    Future.delayed(
      const Duration(seconds: 1),
      () {
        riveIconInputs[index].change(false);
      },
    );
  }

  void riveOnInit(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    controllers.add(controller);
    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in controllers) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 28),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.secondaryColor,
              offset: Offset(0, 20),
              blurRadius: 25,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(botttomNavItems.length, (index) {
            final currItem = botttomNavItems[index].rive;
            return GestureDetector(
              onTap: () {
                if (riveIconInputs.length > index) {
                  animateIcon(index);
                }
                // animateIcon(index);
                setState(() {
                  selectedNavIndex = index;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(
                    isActive: index == selectedNavIndex,
                  ),
                  SizedBox(
                    height: 42,
                    width: 42,
                    child: Opacity(
                      opacity: index == selectedNavIndex ? 1 : 0.5,
                      child: RiveAnimation.asset(currItem.src,
                          artboard: currItem.artBoard, onInit: (artboard) {
                        riveOnInit(artboard,
                            stateMachineName: currItem.stateMachineName);
                        if (selectedNavIndex == index) {
                          animateIcon(index);
                        }
                      }),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
