// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/post_provider.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentController = TextEditingController();

  UserData? datas;

  Future<void> getUserDetails() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUserDetails();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  @override
  Widget build(BuildContext context) {
    UserData? userDetails = Provider.of<UserProvider>(context).getUser;

    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'All Comments',
            style: TextStyle(color: subColor),
          ),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.snap['postId'])
                      .collection('comments')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: subColor,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    return snapshot.data!.docs.isEmpty
                        ? Center(
                            child: TextWidget(
                              text: 'No comments yet !!',
                              fontSize: 18,
                              weight: FontWeight.bold,
                              color: subColor.withOpacity(0.6),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              final snap = snapshot.data!.docs[index].data();
                              String imageUrl = snap['profile'];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(imageUrl),
                                ),
                                title: TextWidget(
                                  text: snap['userName'],
                                  fontSize: 15,
                                  align: TextAlign.start,
                                  color: subColor,
                                  weight: FontWeight.w400,
                                ),
                                subtitle: TextWidget(
                                  text: snap['comment'],
                                  fontSize: 15,
                                  align: TextAlign.start,
                                  color: subColor,
                                  weight: FontWeight.w300,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                                  thickness: 1,
                                ),
                            itemCount: snapshot.data!.docs.length);
                  }))
          //  Expanded(
          //   child: TodoList(),
          // ),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDeco.containerBoxDecoration(),
                  child: TextField(
                    style: const TextStyle(color: subColor),
                    controller: commentController,
                    decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your Comment',
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Consumer<PostProvider>(
                builder: (context, value, child) => GestureDetector(
                  onTap: () {
                    // commentController.clear();
                    value.postComment(
                        commentController.text,
                        userDetails!.userName,
                        userDetails.uid,
                        widget.snap['postId'],
                        userDetails.imageUrl);
                    FocusScope.of(context).requestFocus(FocusNode());
                    commentController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(),
                    child: const Icon(
                      Icons.send_outlined,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
