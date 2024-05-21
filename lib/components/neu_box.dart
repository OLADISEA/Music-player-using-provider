import 'package:flutter/material.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  const NeuBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //is dark mode
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode?Colors.black:Colors.grey.shade500,
            blurRadius: 15,
            offset: Offset(4,4)
          ),
          BoxShadow(
              color: Colors.white,
              blurRadius: 15,
              offset: Offset(-4,-4)
          )
        ]
      ),
      padding: EdgeInsets.all(12),
      child: child,
    );
  }
}
