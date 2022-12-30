
import 'package:flutter/cupertino.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/auth_provider.dart';

class UserProvider extends ChangeNotifier{
UserData? _user;
UserData? user;

final AuthProvider authProvider = AuthProvider();

UserData?  get  getUser => _user;

Future<void> refreshUserDetails()async{

  UserData user = await authProvider.getUserDetails();
  _user = user;
  notifyListeners();
}

}