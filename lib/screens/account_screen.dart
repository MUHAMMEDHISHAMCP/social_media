import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/edit_screen.dart';
import 'package:jsc_task2/screens/widgets/pop_up_widget.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
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
  String userName = '';

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
    UserData userDetails = Provider.of<UserProvider>(context).getUser;
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
        body:   Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                  ),
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
                            radius: MediaQuery.of(context).size.height / 12,
                            backgroundColor: Colors.grey.shade400,
                            backgroundImage: NetworkImage(userDetails.imageUrl),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              AssetImage('assets/dummy_profile.png'),
                        ),
                  kwidth20,
                  TextWidget(
                    text: userDetails.userName,
                    fontSize: 19,
                    color: subColor,
                    align: TextAlign.center,
                    lines: 2,
                    weight: FontWeight.bold,
                  )
                ],
              ),
              kHeight15,
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditScreen(
                          profileImage: userDetails.imageUrl,
                          userName: userDetails.userName,
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kBlack.withOpacity(0.5)),
                    child: TextWidget(
                      text: 'Edit Profle',
                      fontSize: 16,
                      weight: FontWeight.bold,
                      color: subColor.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
