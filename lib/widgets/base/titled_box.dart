//import 'package:finale/widgets/base/header_list_tile.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class ButtonAction {
  final String name;
  final IconData icon;
  final VoidCallback onPressed;

  const ButtonAction(this.name, this.icon, this.onPressed);
}

class TitledBox extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<ButtonAction> actions;

  const TitledBox({required this.title, this.trailing, required this.actions});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 80),
          Text(
            'Tap to Identify the song',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          //HeaderListTile(title, trailing: trailing),
          const SizedBox(height: 140),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final action in actions)
                AvatarGlow(
                  showTwoGlows: true,
                  endRadius: 140,
                  child: RawMaterialButton(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    onPressed: action.onPressed,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange[700],
                      child: Image.asset(
                        'assets/images/tuneit.jpg',
                        height: 150,
                      ),
                      radius: 100.0,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 80,
          ),
          Text(
            'LUMOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
