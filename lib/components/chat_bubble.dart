import 'package:chat_app_minimal/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color:
            isCurrentUser
                ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),

      child: Text(
        message,
        style: TextStyle(color: isCurrentUser? Colors.white:
        
        (isDarkMode ? Colors.white : Colors.black)),
      ),
    );
  }
}
