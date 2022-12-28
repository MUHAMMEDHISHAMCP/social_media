import 'package:flutter/material.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_size.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Center(
              child: ListView(
                physics:const NeverScrollableScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kHeight20,
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                      border:  Border.all(color: Colors.black45,style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                           Icon(Icons.add_box_rounded),
                           TextWidget(text: "Add Image", fontSize: 20,weight: FontWeight.w400,)
                        ],
                      ),
                    ),
                  ),
                  kHeight5,
 ElevatedButton(
                          onPressed: () {
 
                        
                          },
                          style: ElevatedButton.styleFrom(
                          
                              backgroundColor:Colors.grey.withOpacity(0.5)),
                          child: const TextWidget(text: "Add Image", fontSize: 16,weight:FontWeight.bold ,)
                        ),                  kheight10,
                      TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Description',
                                counterText: '',
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                         kheight10,
                                         ElevatedButton(onPressed: (){}, child: const TextWidget(text: "Add Your Post", fontSize: 16,weight:FontWeight.bold ,)),

                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}