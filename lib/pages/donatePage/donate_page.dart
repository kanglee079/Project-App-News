import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../manage/controller/donate_controller.dart';
import '../../manage/store/user_store.dart';

class DonatePage extends StatelessWidget {
  DonatePage({Key? key}) : super(key: key);

  final DonateController controller = Get.put(DonateController());
  Stream<int> getUserCoinsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['coins'] ?? 0);
  }

  final String userId = UserStore.to.userInfo.id!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ủng hộ chúng tôi",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              "Cảm ơn bạn đã ủng hộ ứng dụng",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              StreamBuilder<int>(
                stream: getUserCoinsStream(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Số Coins: ${snapshot.data}',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              Obx(
                () {
                  return Column(
                    children: controller.products
                        .map((ProductDetails productDetails) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber.shade300),
                        ),
                        onPressed: () => controller.buyProduct(productDetails),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              productDetails.title,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
