import 'package:chat_app_minimal/components/chat_bubble.dart';
import 'package:chat_app_minimal/components/my_textfield.dart';
import 'package:chat_app_minimal/services/auth/auth_service.dart';
import 'package:chat_app_minimal/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail; // to know whom we are talking to
  final String recieverId;
  ChatPage({super.key, required this.receiverEmail, required this.recieverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // auth and chat service
  final AuthService _auth = AuthService();

  final ChatService _chatService = ChatService();

  // for textfield focus node

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //  casue a delay so that keyboard has time to show up
        // then the amount of remaining space will be calculated
        // then scroll down

        scrollDown();
        // Future.delayed(const Duration(milliseconds: 200), () => scrollDown());
      }
    });
    // scrollDown();

    // Future.delayed(Duration(milliseconds: 200), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // message controller
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      print(_messageController.text);
      print('Inside sendMessage method of chatpage');
      await _chatService.sendMessage(
        widget.recieverId,
        _messageController.text,
      );

      // after sending the message clear the controller

      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),

      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildUserInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _auth.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverId, senderId),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading ...');
        }

        // Debugging: Print the retrieved documents
        snapshot.data!.docs.forEach((doc) {
          print(doc.data());
        });

        // list view
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Add null safety checks
    // final String message = data['message'] ?? 'No message';
    // final String senderEmail = data['senderEmail'] ?? 'Unknown sender';

    print('In buildMessageItem in chatpage');

    // is current user
    bool isCurrentUser = data['senderId'] == _auth.getCurrentUser()!.uid;

    // if is current user align msgs to right else to the left

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(isCurrentUser: isCurrentUser, message: data['message']),
        ],
      ),
      // , subtitle: Text(senderEmail)
    );
  }

  // Widget _buildMessageItem(DocumentSnapshot doc) {
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              focusNode: myFocusNode,
              hintText: 'Type a message',
              obscure: false,
              controller: _messageController,
            ),
          ),

          // send button
          Container(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
