import 'package:app_news/apps/const/key.dart';
import 'package:app_news/apps/helper/show_toast.dart';
import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/manage/service/store_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/info_user.dart';
import '../store/user_store.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Lấy thông tin người dùng từ Firestore
        UserModel? userModel = await _firebaseService.getUser(user.uid);

        if (userModel != null) {
          // Lưu ID người dùng vào SharedPreferences
          await StoreService.to.setString(MyKey.TOKEN_USER, user.uid);
          // Cập nhật trạng thái đăng nhập trong UserStore
          UserStore.to.login(userModel);
        }
      }

      return user;
    } catch (error) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmailPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(displayName);

        UserModel newUser = UserModel(
          id: user.uid,
          email: user.email,
          displayName: displayName,
          photoUrl: user.photoURL,
        );

        // Thêm người dùng vào Firestore
        await _firebaseService.addUser(newUser);

        // Lưu ID người dùng vào SharedPreferences
        await StoreService.to.setString(MyKey.TOKEN_USER, user.uid);
        // Cập nhật trạng thái đăng nhập trong UserStore
        UserStore.to.login(newUser);

        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          UserModel? userModel = await FirebaseService().getUser(user.uid);
          if (userModel != null) {
            // await _firebaseService.updateUser(userModel);
          } else {
            await _firebaseService.updateUser(
              UserModel(
                id: user.uid,
                email: user.email,
                displayName: user.displayName,
                photoUrl: user.photoURL,
              ),
            );
          }
          return user;
        }
      }
    } catch (error) {
      rethrow;
    }
    return null;
  }

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("Không tìm thấy người dùng");
    }

    try {
      await user.updatePassword(newPassword);
      showToastSuccess("Đổi mật khẩu thành công");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception("Yêu cầu đăng nhập lại để đổi mật khẩu");
      }
      rethrow;
    }
  }
}
