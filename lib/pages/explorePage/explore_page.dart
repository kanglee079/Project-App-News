import 'package:app_news/manage/controller/favorite_news_video_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../manage/controller/explore_controller.dart';
import '../../model/news_video.dart';
import '../categoryPage/category_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  String? dropdownValue = 'Tin Tức';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: 160,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).indicatorColor,
              ),
              elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.black,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).indicatorColor,
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: ['Tin Tức', 'Videos']
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        constraints: const BoxConstraints(
                          minHeight: 40,
                        ),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: buildSelectedWidget(dropdownValue!, context),
      ),
    );
  }
}

Widget buildSelectedWidget(String choice, BuildContext context) {
  switch (choice) {
    case 'Tin Tức':
      return buildArticleView(context);
    case 'Videos':
      return const VideoListView();
    default:
      return const Center(child: Text('Select an option'));
  }
}

class VideoListView extends StatelessWidget {
  const VideoListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final ExploreController controller = Get.find<ExploreController>();
    final controller = Get.put(ExploreController());
    Get.put(ExploreController());

    return Obx(() {
      if (controller.videos.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          return VideoItem(video: video);
        },
      );
    });
  }
}

class VideoItem extends StatefulWidget {
  final NewsVideo video;

  const VideoItem({Key? key, required this.video}) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool _loadingFailed = false;
  // final controllerFavorite = Get.find<FavoriteNewsVideoController>();
  final controllerFavorite = Get.put(FavoriteNewsVideoController());

  void _toggleVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0) {
      _controller.pause();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          }).catchError((e) {
            print('Lỗi khi khởi tạo VideoPlayer: $e');
            setState(() {
              _loadingFailed = true;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingFailed) {
      return const Center(child: Text('Không thể tải video'));
    }

    return VisibilityDetector(
      key: Key('video-${widget.video.id}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: _toggleVideo,
        child: _controller.value.isInitialized
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        Positioned(
                          bottom: 20,
                          left: 15,
                          right: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(128, 91, 143, 228),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                widget.video.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 15,
                          child: Obx(
                            () {
                              bool isLiked = controllerFavorite
                                  .isNewsVideoFavorite(widget.video.id);
                              return LikeButton(
                                size: 30,
                                isLiked: isLiked,
                                onTap: (isLiked) async {
                                  NewsVideo likeArticle = NewsVideo(
                                    id: widget.video.id,
                                    title: widget.video.title,
                                    likes: widget.video.likes,
                                    videoUrl: widget.video.videoUrl,
                                  );
                                  controllerFavorite
                                      .toggleFavoriteBook(likeArticle);
                                  return !isLiked;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

Widget buildArticleView(BuildContext context) {
  // final ExploreController exploreController = Get.put(ExploreController());
  Get.put(ExploreController());
  final exploreController = Get.put(ExploreController());

  return const Column(
    children: [
      SizedBox(height: 15),
      Expanded(child: CategoryPage()),
      // Expanded(
      //   child: DefaultTabController(
      //     length: 3,
      //     child: Column(
      //       children: [
      //         const TabBar(
      //           tabs: [
      //             Tab(
      //               text: "Thời sự",
      //             ),
      //             Tab(
      //               text: "Kinh Doanh",
      //             ),
      //             Tab(
      //               text: "Khoa Học",
      //             ),
      //           ],
      //         ),
      //         const SizedBox(height: 8),
      //         Expanded(
      //           child: TabBarView(
      //             children: [
      //               buildArticleListView(exploreController.articlesThoiSu),
      //               buildArticleListView(exploreController.articlesKinhDoanh),
      //               buildArticleListView(exploreController.articlesKhoaHoc),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    ],
  );
}

// Widget buildArticleListView(RxList<NewsArticle> articles) {
//   return ListView.separated(
//     itemCount: articles.length,
//     separatorBuilder: (BuildContext context, int index) {
//       return const Divider(height: 15);
//     },
//     itemBuilder: (BuildContext context, int index) {
//       NewsArticle article = articles[index];
//       return InkWell(
//         onTap: () {
//           Get.toNamed(RouterName.detailNewsPage, arguments: article.id);
//         },
//         child: CustomCardSecond(
//           idCategory: article.idCategory,
//           title: article.title,
//           photoUrl: article.photoUrl,
//           date: article.dateTime,
//         ),
//       );
//     },
//   );
// }
