import 'package:flutter/material.dart';

class AndroidNavBar extends StatelessWidget {
  const AndroidNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 20),
            onPressed: () {
              // Open drawer or menu
              Scaffold.of(context).openDrawer();
            },
          ),
          IconButton(
            icon: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              // Home button functionality
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () {
              // Back button functionality
              Navigator.maybePop(context);
            },
          ),
        ],
      ),
    );
  }
}