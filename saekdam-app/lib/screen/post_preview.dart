import 'package:flutter/material.dart';
import 'package:fly_ai_1/api.dart';
import 'package:fly_ai_1/post.dart';
import 'package:fly_ai_1/screen/community.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: ApiService.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("데이터를 불러오는 데 실패했습니다."));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("게시글이 없습니다."));
        }

        final posts = snapshot.data!;
        final latestTwoPosts = posts.length >= 2 ? posts.take(2).toList() : posts;

        return Column(
          children: latestTwoPosts.map((post) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Community()),
                );
              },
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 🔹 썸네일을 서버에서 불러오는 이미지
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: post.thumbnailUrl != null
                          ? (post.thumbnailUrl!.endsWith('.svg') // 🔹 SVG 여부 확인
                          ? SvgPicture.network(
                        post.thumbnailUrl!,
                        width: 120,
                        height: 120,
                        placeholderBuilder: (context) => const SizedBox(
                          width: 120,
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      )
                          : Image.network(
                        post.thumbnailUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'asset/img/색담이_rm.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      ))
                          : Image.asset(
                        'asset/img/색담이_rm.png', // 기본 이미지
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.content,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // 🔹 좋아요 & 댓글 수 추가 (조회수 → 댓글 수 변경됨)
                            Row(
                              children: [
                                const Icon(
                                  Icons.thumb_up_off_alt,
                                  color: Colors.pinkAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text('${post.likes}'),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.comment_outlined,
                                  color: Color(0xFF6799FF), // 💬 댓글 아이콘 색상
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text('${post.numOfComments}'), // 🔹 댓글 개수 표시
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
