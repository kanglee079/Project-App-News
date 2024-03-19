import 'dart:async';

import 'package:app_news/apps/helper/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../store/user_store.dart';

class DonateController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  var products = <ProductDetails>[].obs;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = UserStore.to.userInfo.id!;

  @override
  void onInit() {
    super.onInit();
    _initializePurchase();
    _subscription =
        _inAppPurchase.purchaseStream.listen(_listenToPurchaseUpdated);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _initializePurchase() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // Xử lý trường hợp cửa hàng không sẵn có
      return;
    }
    const Set<String> kIds = {
      'inapp_news_pack01',
      'inapp_news_pack02',
      'inapp_news_pack03',
      'inapp_news_pack04',
      'inapp_news_pack05'
    }; // IDs của các sản phẩm
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Xử lý các ID không tìm thấy
    }
    products.value =
        response.productDetails; // Lưu trữ thông tin sản phẩm để hiển thị
  }

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }

        // Xác định số coin dựa vào ID sản phẩm
        int coinsToAdd = _getCoinsForProduct(purchaseDetails.productID);
        _updateUserCoins(coinsToAdd);
      }
    }
  }

  int _getCoinsForProduct(String productId) {
    switch (productId) {
      case 'inapp_news_pack01':
        return 10;
      case 'inapp_news_pack02':
        return 20;
      case 'inapp_news_pack03':
        return 30;
      case 'inapp_news_pack04':
        return 40;
      case 'inapp_news_pack05':
        return 50;
      default:
        return 0;
    }
  }

  Future<void> _updateUserCoins(int coinsToAdd) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      // Ép kiểu dữ liệu
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      int currentCoins = userData['coins'] ?? 0;
      int newCoins = currentCoins + coinsToAdd;
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'coins': newCoins});

      // Hiển thị thông báo thành công
      showToastSuccess(
          "Bạn đã nạp thành công $coinsToAdd coins. Tổng số coins của bạn là $newCoins.");
    } catch (e) {
      showToastError("Lỗi khi cập nhật coins: $e");
    }
  }
}
