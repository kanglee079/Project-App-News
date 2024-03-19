import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/model/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomCard extends StatelessWidget {
  final String idCategory;
  final String title;
  final String photoUrl;
  final DateTime date;

  const CustomCard({
    Key? key,
    required this.idCategory,
    required this.title,
    required this.photoUrl,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return FutureBuilder<Category?>(
      future: FirebaseService().getCategoryById(idCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: const Color(0xFF1A1A3F),
              rightDotColor: const Color(0xFFEA3799),
              size: 100,
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Không thể tải danh mục');
        }

        Category category = snapshot.data!;

        return Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(photoUrl ??
                  "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(128, 91, 143, 228),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      child: Text(category.name,
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                  ),
                  const Expanded(child: SizedBox(height: 6)),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 91, 143, 228),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
