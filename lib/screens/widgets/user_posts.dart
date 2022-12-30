import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/providers/post_provider.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:provider/provider.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PostProvider>(context, listen: false);
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.4,
              child: const Center(
                child: CircularProgressIndicator(
                  color: subColor,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          return (snapshot.data! as dynamic).docs.length == 0
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 2.4,
                  child: Center(
                    child: TextWidget(
                      text: 'No posts yet !!',
                      fontSize: 18,
                      weight: FontWeight.bold,
                      color: subColor.withOpacity(0.6),
                    ),
                  ),
                )
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.3),
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        image: DecorationImage(
                            image: NetworkImage(snap['postImageUrl']),
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                  itemCount: (snapshot.data! as dynamic).docs.length,
                );
        });
  }
}
