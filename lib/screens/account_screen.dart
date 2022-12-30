import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/auth_provider.dart';
import 'package:jsc_task2/providers/post_provider.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/edit_screen.dart';
import 'package:jsc_task2/screens/widgets/pop_up_widget.dart';
import 'package:jsc_task2/screens/widgets/rich_text.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:jsc_task2/screens/widgets/user_posts.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:jsc_task2/utils/const_size.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<void> getUserDetails() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUserDetails();
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final prov = Provider.of<PostProvider>(context);

    UserData? userDetails = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: Scaffold(
        appBar: AppBar(
          title: const TextWidget(
            text: 'Account Info',
            fontSize: 20,
            color: subColor,
            weight: FontWeight.bold,
          ),
          centerTitle: true,
          backgroundColor: mainColor,
          actions: [
            IconButton(
                onPressed: () {
                  authProv.signOut(context);
                },
                icon: const Icon(
                  Icons.exit_to_app_rounded,
                  color: subColor,
                ))
          ],
        ),
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userDetails!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: subColor,
                    strokeWidth: 2,
                  ),
                );
              }
              final snap = (snapshot.data! as dynamic);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kHeight15,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          //color: subColor,
                          width: MediaQuery.of(context).size.width / 3.7,
                          child: Column(
                            children: [
                              userDetails.imageUrl.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AddPopup(
                                                imageUrl: userDetails.imageUrl,
                                              );
                                            });
                                      },
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.height /
                                                16,
                                        backgroundColor: Colors.grey.shade400,
                                        backgroundImage:
                                            NetworkImage(userDetails.imageUrl),
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/dummy_profile.png'),
                                    ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        kHeight30,
                        SizedBox(
                          width: 200,
                          // color: kBlack,
                          child: Column(
                            children: [
                              kHeight15,
                              Row(
                                children: [
                                  RichTextWidget(
                                    title:'0\n',
                                    subtitle: 'Posts',
                                  ),
                                  kwidth10,
                                  RichTextWidget(
                                    title: "0\n",
                                    subtitle: 'Followers',
                                  ),
                                  kwidth10,
                                  RichTextWidget(
                                    title: "0\n",
                                    subtitle: 'Following',
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              kHeight5,
                              SizedBox(
                                width: 150,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                          profileImage: userDetails.imageUrl,
                                          userName: userDetails.userName,
                                          userDatas: userDetails,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kBlack.withOpacity(0.5)),
                                  child: const Text('Edit Profile'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  kheight10,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: snap['userName'],
                          fontSize: 22,
                          weight: FontWeight.w400,
                          align: TextAlign.start,
                          color: subColor,
                        ),
                        kHeight5,
                        Visibility(
                          visible: snap['about'].isNotEmpty,
                          child: TextWidget(
                            text: snap['about'],
                            fontSize: 18,
                            weight: FontWeight.w300,
                            align: TextAlign.start,
                            lines: 5,
                            color: subColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  kheight10,
                  Divider(
                    color: subColor.withOpacity(0.3),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: const [
                          UserPosts(),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
