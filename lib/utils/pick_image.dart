

import 'package:image_picker/image_picker.dart';

class PickImage{

static pickImage(ImageSource imageSource)async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);

  if (file != null) {
    return await file.readAsBytes();
  }


}

}