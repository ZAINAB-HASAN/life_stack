import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteflow/core/constants/app_strings.dart';
import 'package:noteflow/core/routes/routes_name.dart';
import 'package:noteflow/core/widgets/app_bar/custom_app_bar_widget.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }
    final currentUid = user!.uid;
    return Scaffold(
      appBar: CustomAppBarWidget(
        screenTitle: AppStrings.chat,
        isDrawerOpen: false,
        onMenuTap: () {},
        onBackTap: () {},
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              // Skip Current Logged-in User
              if (user['uid'] == currentUid) return const SizedBox();
              return ListTile(
                title: Text(user['email']),
                onTap: () {
                  Get.toNamed(
                    RoutesName.chatScreen,
                    arguments: {
                      'receiverId': user['uid'],
                      'receiverEmail': user['email'],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
