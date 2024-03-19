import 'package:app_news/apps/helper/show_toast.dart';
import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/model/news_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../apps/route/route_name.dart';
import '../../manage/controller/favorite_news_video_controller.dart';
import '../../manage/controller/saved_controller.dart';
import '../../model/news_article.dart';
import '../../widgets/card_custom_2.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SavedPageController _savedPageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _savedPageController =
        Get.put(SavedPageController(firebaseService: FirebaseService()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tin tức đã thích",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              "Thư viện cá nhân của bạn",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        bottom: TabBar(
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tin tức'),
            Tab(text: 'Videos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(
            () => ListView.builder(
              itemCount: _savedPageController.favoriteNews.length,
              itemBuilder: (context, index) {
                NewsArticle article = _savedPageController.favoriteNews[index];
                return Dismissible(
                  key: Key(article.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _savedPageController.removeFavoriteNews(article.id);
                    showToastError("Đã xoá yêu thích");
                  },
                  background: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(RouterName.detailNewsPage,
                            arguments: article.id);
                      },
                      child: CustomCardSecond(
                        idCategory: article.idCategory,
                        title: article.title,
                        photoUrl: article.photoUrl,
                        date: article.dateTime,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: VideoListViewFavorite()),
        ],
      ),
    );
  }
}

class VideoListViewFavorite extends StatelessWidget {
  const VideoListViewFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final SavedPageController controller = Get.find<SavedPageController>();

    return Obx(() {
      if (controller.favoriteNewsVideo.isEmpty) {
        return const Center(child: Text("Chưa có video yêu thích"));
      }

      return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.favoriteNewsVideo.length,
        itemBuilder: (context, index) {
          final video = controller.favoriteNewsVideo[index];
          print(controller.favoriteNewsVideo.length);
          return VideoItemFavortie(video: video);
        },
      );
    });
  }
}

class VideoItemFavortie extends StatefulWidget {
  final NewsVideo video;

  const VideoItemFavortie({Key? key, required this.video}) : super(key: key);

  @override
  _VideoItemFavortieState createState() => _VideoItemFavortieState();
}

class _VideoItemFavortieState extends State<VideoItemFavortie> {
  late VideoPlayerController _controller;
  bool _loadingFailed = false;
  final controllerFavorite = Get.find<FavoriteNewsVideoController>();

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
