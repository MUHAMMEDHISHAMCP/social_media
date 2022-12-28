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
    backgroundColor:  const Color(0xff134CB5),
   ),
   body: ListView.builder(itemBuilder: (context, index) => Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
      decoration: BoxDeco.containerBoxDecoration(),
      height: MediaQuery.of(context).size.height/2.2,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const[
                 CircleAvatar(
                  radius: 20,
                ),
                kwidth5,
                 TextWidget(text: 'UserName', fontSize: 16,weight: FontWeight.bold,color: subColor,spacing: 1,)




              ],
            ),
          ),
          kHeight5,
          Container(
            height:MediaQuery.of(context).size.height/3.2 ,
            width: double.infinity,
            color: mainColor,
          ),
          kHeight5,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                 Icon(Icons.favorite_border,size: 30,color: subColor,),
                kwidth10,
                 Icon(Icons.comment,size: 30,color: subColor,),
                kwidth10,
                 Icon(Icons.share_outlined,size: 30,color: subColor,)
              ],
            ),
          )
        ],
      ),
      
     ),
   ),
   itemCount: 10,),
   ),
    );
  }
}