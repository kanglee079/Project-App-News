import 'package:app_news/manage/service/store_service.dart';
import 'package:get/get.dart';

import '../../apps/const/key.dart';
import '../../apps/route/route_name.dart';
import '../../model/info_user.dart';
import '../controller/explore_controller.dart';
import '../service/firebase_service.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  final RxBool _isLogin = false.obs;
  final RxString _token = "".obs;
  final Rx<UserModel> _info = UserModel().obs;

  bool get isLogin => _isLogin.value;
  String get token => _token.value;
  UserModel get userInfo => _info.value;

  String get userName => _info.value.displayName ?? 'Không rõ';
  String get userEmail => _info.value.email ?? 'Không có email';
  String get photoUrl =>
      _info.value.photoUrl ??
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png';

  @override
  Future<void> onInit() async {
    String key = await StoreService.to.getString(MyKey.TOKEN_USER);
    if (key.isNotEmpty) {
      UserModel? user = await FirebaseService().getUser(key);
      if (user != null) {
        _isLogin.value = true;
        _info.value = user;
      }
    }
    super.onInit();
  }

  void updateUserPhotoUrl(String newPhotoUrl) {
    _info.update((user) {
      user?.photoUrl = newPhotoUrl;
    });
  }

  Future<void> login(UserModel user) async {
    _info.value = user;
    _isLogin.value = true;
    StoreService.to.setString(MyKey.TOKEN_USER, user.id.toString());
    Get.offAndToNamed(RouterName.navigatorPage);
    Get.put(ExploreController());
  }

  Future<void> logout() async {
    _isLogin.value = false;
    _token.value = "";
    _info.value = UserModel(id: '', displayName: '', email: '', photoUrl: '');
    StoreService.to.clean(MyKey.TOKEN_USER);
  }
}
