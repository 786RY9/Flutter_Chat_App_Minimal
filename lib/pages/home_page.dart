import 'package:chat_app_minimal/components/my_drawer.dart';
import 'package:chat_app_minimal/components/user_tile.dart';
import 'package:chat_app_minimal/pages/chat_page.dart';
import 'package:chat_app_minimal/services/auth/auth_service.dart';
import 'package:chat_app_minimal/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Home'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.grey,
      ),
      body: _buildUserList(),
      drawer: MyDrawer(),
      
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        } else {
          return ListView(
            children:
                snapshot.data!.map<Widget>((userdata) {
                  return _buildUserListItem(userdata, context);
                }).toList(),
          );
        }
      },
    );
  }

  // display all users except current user

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // on tapping a user go to chat page for that user

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatPage(
                  receiverEmail:
                      userData['email'], // this is recievers email as we donot show current user email
                  recieverId: userData['uid'],
                );
              },
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  
}
