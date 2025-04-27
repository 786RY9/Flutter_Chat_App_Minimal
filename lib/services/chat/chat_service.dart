import 'package:chat_app_minimal/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
   List<Map<String,dynamic>> =
   
   [
    {
   email: ....,
   id: ....
   }
,
 {
   email: ....,
   id: ....
   }

   ]
  
    
   */

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // send message

  Future<void> sendMessage(String recieverId, String message) async {
    if (message.isEmpty) {
      throw Exception('Message cannot be empty');
    }

    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      recieverId: recieverId,
      senderEmail: currentUserEmail,
      senderId: currentUserId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }
  // Future<void> sendMessage(String recieverId, message) async {
  //   // get current user Info
  //   final String currentUserId = _auth.currentUser!.uid;
  //   final String currentUseremail = _auth.currentUser!.email!;
  //   final Timestamp timestamp = Timestamp.now();

  //   // create a message
  //   Message newMessage = Message(
  //     recieverId: recieverId,
  //     senderEmail: currentUseremail,
  //     senderId: currentUserId,
  //     timestamp: timestamp,
  //     message: message

  //   );

  //   // create chat room Id for these 2 users (sorted for uniqueness)
  //   List<String> ids = [currentUserId, recieverId];
  //   ids.sort(); // to make sure unique rooms for chats for 2 users
  //   String chatRoomId = ids.join('_');

  //   // add new message to database
  //   await _firestore
  //       .collection('chat_rooms')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .add(newMessage.toMap());
  // }

  // get message

  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();

    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
