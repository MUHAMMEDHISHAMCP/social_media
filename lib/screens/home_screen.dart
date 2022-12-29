import 'package:flutter/material.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:jsc_task2/utils/const_size.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Home Screen'),
          centerTitle: true,
          backgroundColor: mainColor,
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDeco.containerBoxDecoration(),
              height: MediaQuery.of(context).size.height / 2.2,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        CircleAvatar(
                          radius: 20,
                        ),
                        kwidth5,
                        TextWidget(
                          text: 'UserName',
                          fontSize: 16,
                          weight: FontWeight.bold,
                          color: subColor,
                          spacing: 1,
                        )
                      ],
                    ),
                  ),
                  kHeight5,
                  Container(
                    height: MediaQuery.of(context).size.height / 3.7,
                    width: double.infinity,
                    color: mainColor,
                  ),
                  kHeight5,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          size: 30,
                          color: subColor,
                        ),
                        kwidth10,
                        const Icon(
                          Icons.comment,
                          size: 30,
                          color: subColor,
                        ),
                        kwidth10,
                        const Icon(
                          Icons.send_rounded,
                          size: 30,
                          color: subColor,
                        ),
                        const Spacer(),
                        Row(
                          children: const [
                            Icon(
                              Icons.comment,
                              color: Colors.white54,
                            ),
                            kwidth5,
                            TextWidget(
                              text: "10 Comments",
                              fontSize: 18,
                              weight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextWidget(
                        text: "1,245 likes",
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
          ),
          itemCount: 10,
        ),
      ),
    );
  }
}
