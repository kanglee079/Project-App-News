import 'package:app_news/model/info_user.dart';
import 'package:get/get.dart';

class PersonalState {
  Rx<UserModel> userInfo = UserModel().obs;
}
