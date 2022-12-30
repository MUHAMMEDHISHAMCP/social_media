import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/auth_provider.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.snap});
  final snap;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeight15,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //color: subColor,
                    width: MediaQuery.of(context).size.width / 3.7,
                    child: Column(
                      children: [
                        widget.snap['pofileUrl'] != null
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AddPopup(
                                          imageUrl: widget.snap['pofileUrl'],
                                        );
                                      });
                                },
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.height / 16,
                                  backgroundColor: Colors.grey.shade400,
                                  backgroundImage:
                                      NetworkImage(widget.snap['pofileUrl']),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/dummy_profile.png'),
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
                              title: "0\n",
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
                          child: Consumer<AuthProvider>(
                            builder: (context, value, child) => ElevatedButton(
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kBlack.withOpacity(0.5)),
                              child: value.isLoading == true
                                  ? const CircularProgressIndicator(
                                      color: subColor,
                                      strokeWidth: 2,
                                    )
                                  : const Text('Edit Profile'),
                            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: widget.snap['userName'],
                    fontSize: 18,
                    weight: FontWeight.bold,
                    align: TextAlign.start,
                    color: subColor,
                  ),
                  // TextWidget(
                  //   text:
                  //       widget.snap['about'],
                  //   fontSize: 18,
                  //   weight: FontWeight.bold,
                  //   align: TextAlign.start,
                  //   lines: 5,
                  // ),
                ],
              ),
            ),
            kheight10,
            Divider(
              color: subColor.withOpacity(0.3),
            ),
   
          ],
        ),
      ),
    );
  }
}
