import 'package:app_news/apps/route/route_name.dart';
import 'package:app_news/model/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../manage/service/firebase_service.dart';
import '../../widgets/item_category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Danh mục",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              "Tổng hợp danh mục tin tức",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Category>>(
        stream: FirebaseService().streamCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có danh mục nào'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var data = {
                'categoryId': snapshot.data![index].id,
                'categoryName': snapshot.data![index].name
              };
              return AspectRatio(
                aspectRatio: 1 / 0.2,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(RouterName.newsWithCategoryPage,
                        arguments: data);
                  },
                  child: ItemCategory(
                    nameCategory: snapshot.data![index].name,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
