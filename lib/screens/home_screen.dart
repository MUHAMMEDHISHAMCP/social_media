import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/post_provider.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/comment_scree.dart';
import 'package:jsc_task2/screens/profile_screen.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:jsc_task2/utils/const_size.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  Widget build(BuildContext context) {
    UserData? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Home Screen'),
          centerTitle: true,
          backgroundColor: mainColor,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final snap = snapshot.data!.docs[index].data();
                  String imageUrl = snap['postImageUrl'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(snap: snap),
                                ));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(snap['pofileUrl']),
                                  ),
                                  kwidth5,
                                  TextWidget(
                                    text: snap['userName'],
                                    fontSize: 16,
                                    weight: FontWeight.bold,
                                    color: subColor,
                                    spacing: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                          kHeight5,
                          imageUrl.isEmpty
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.7,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: const Center(
                                      child: TextWidget(
                                    text: "Couldn't load image",
                                    fontSize: 16,
                                    color: subColor,
                                    weight: FontWeight.w300,
                                  )),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.4,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.fill)),
                                ),
                          kHeight5,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Consumer<PostProvider>(
                              builder: (context, value, child) => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        value.likePost(
                                          context,
                                          snap['likes'],
                                          snap['postId'],
                                        );
                                      },
                                      icon: !snap['likes'].contains(user?.uid)
                                          ? const Icon(
                                              Icons.favorite_border,
                                              size: 30,
                                              color: subColor,
                                            )
                                          : const Icon(
                                              Icons.favorite_outlined,
                                              size: 30,
                                              color: Colors.red,
                                            )),
                                  kwidth10,
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => CommentScreen(
                                          snap: snap,
                                        ),
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.comment,
                                      size: 30,
                                      color: subColor,
                                    ),
                                  ),
                                  kwidth10,
                                  const Icon(
                                    Icons.send_rounded,
                                    size: 30,
                                    color: subColor,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: TextWidget(
                                text: '${snap['likes'].length} likes',
                                fontSize: 18,
                                weight: FontWeight.bold,
                                color: subColor,
                              ),
                            ),
                          ),
                          kHeight5
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }),
      ),
    );
  }
}
