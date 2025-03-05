import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';

// 📌 내부 저장소 경로 가져오기v
Future<String> getLocalStoragePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// 📌 이미지 저장 (갤러리에서 선택한 이미지를 내부 저장소로 복사)
Future<String> saveImageToLocalDirectory(File imageFile) async {
  final String directoryPath = await getLocalStoragePath();
  final String filePath = '$directoryPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

  final File newImage = await imageFile.copy(filePath);
  return newImage.path; // 저장된 이미지 경로 반환
}




// 📌 저장된 이미지 불러오기
Future<List<String>> loadImagesFromLocalStorage() async {
  final String directoryPath = await getLocalStoragePath();
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    return []; // 폴더가 없으면 빈 리스트 반환
  }

  final List<FileSystemEntity> files = directory.listSync();

  return files
      .whereType<File>() // 파일만 필터링
      .where((file) => file.lengthSync() > 0) // 🔥 빈 파일 제거
      .map((file) => file.path) // 파일 경로 리스트로 변환
      .toList();
}

class ApiService {
  static const String baseUrl = "https://saekdam.kro.kr/api";

  // 📌 여러 개의 썸네일 ID를 한 번에 URL로 변환 (POST 요청)
  static Future<List<String>?> getThumbnailUrls(List<String> thumbnailIds) async {
    final String url = "$baseUrl/storage/accessUrls";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',  // JSON 요청
        },
        body: jsonEncode(thumbnailIds),  // 📌 리스트 형태로 변환하여 전송
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse.cast<String>(); // 🔹 JSON 리스트를 String 리스트로 변환
      } else {
        print("❌ 업로드 pre-url 요청 실패: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ 업로드 pre-url 요청 중 오류: $e");
      return null;
    }
  }


  static Future<String> GET_imgurl(String thumbnailId) async {
    final String url = "$baseUrl/storage/accessUrls";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        // 서버가 리스트 형태를 기대하는 경우 단일 값도 리스트에 넣어 전송
        body: jsonEncode([thumbnailId]),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse.isNotEmpty) {
          // 리스트의 첫 번째 URL 반환
          return jsonResponse.first as String;
        } else {
          throw Exception("반환된 URL이 없습니다.");
        }
      } else {
        throw Exception("썸네일 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("썸네일 요청 중 오류: $e");
    }
  }



  static Future<String> POST_imgurl(String thumbnailId) async {
    final String url = "$baseUrl/storage/uploadUrls";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        // 서버가 리스트 형태를 기대하는 경우 단일 값도 리스트에 넣어 전송
        body: jsonEncode([thumbnailId]),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse.isNotEmpty) {
          // 리스트의 첫 번째 URL 반환
          return jsonResponse.first as String;
        } else {
          throw Exception("반환된 URL이 없습니다.");
        }
      } else {
        throw Exception("썸네일 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("썸네일 요청 중 오류: $e");
    }
  }
  static Future<File?> downloadImageFromPresignedUrl(String presignedUrl, {String? filename}) async {
    try {
      final response = await http.get(Uri.parse(presignedUrl));
      if (response.statusCode == 200) {
        // 내부 저장소 경로 가져오기
        final String directoryPath = await getLocalStoragePath();
        // 파일 이름 설정: 인자로 전달되거나, 현재 시간 기반으로 생성
        final String fileName = filename ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = '$directoryPath/$fileName';

        // 파일 생성 후 이미지 데이터를 기록
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("다운로드 성공: $filePath");
        return file;
      } else {
        print("다운로드 실패: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("다운로드 중 오류: $e");
      return null;
    }
  }



  static Future<http.Response> postTask(Map<String, dynamic> data) async {
    final String url = '$baseUrl/tasks/new-task';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }

  static Future<String> fetchTaskId() async {
    final url = Uri.parse('https://saekdam.kro.kr/api/tasks/task-id'); // 엔드포인트 A
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // 응답 JSON에서 'taskId' 필드를 추출 (서버 응답 형식에 따라 변경)
      return data['taskId'];
    } else {
      throw Exception('Task ID를 받아오는데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  static Future<bool> uploadImageToPresignedUrl(String presignedUrl, File imageFile) async {
    try {
      // 이미지 파일의 바이트 읽어오기
      final bytes = await imageFile.readAsBytes();

      // presigned URL로 PUT 요청 보내기
      final response = await http.put(
        Uri.parse(presignedUrl),
        body: bytes,
        headers: {
          // 서버의 요구에 맞는 Content-Type 설정 (예: image/jpeg, image/png 등)
          'Content-Type': 'image/jpeg',
        },
      );

      // 상태코드 200 또는 201이면 업로드 성공으로 간주
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("업로드 성공 ㅋㅋㅋㅋ ㅈ밥");
        return true;
      } else {
        print("❌ 업로드 실패: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ 업로드 중 오류: $e");
      return false;
    }
  }







  // 📌 게시글 목록 불러오기 (썸네일 URL 포함)
  static Future<List<Post>> fetchPosts() async {
    final String url = "$baseUrl/posts";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        final List<dynamic> postsJson = jsonResponse['content'];

        // 모든 게시글의 썸네일 ID 리스트 추출
        List<String> thumbnailIds = postsJson
            .map((json) => json['thumbnail'] as String? ?? "") // ❗ null이면 빈 문자열("")로 유지
            .toList();

        // 📌 서버에서 썸네일 URL 리스트 가져오기 (POST 요청)
        List<String>? thumbnailUrls = await getThumbnailUrls(thumbnailIds);

        // 📌 Post 객체 생성 (썸네일 URL 추가)
        List<Post> posts = [];
        for (int i = 0; i < postsJson.length; i++) {
          posts.add(Post.fromJson(postsJson[i],
              thumbnailUrl: thumbnailUrls != null && i < thumbnailUrls.length
                  ? thumbnailUrls[i]
                  : null));
        }

        return posts;
      } else {
        throw Exception("게시글 데이터를 불러오는데 실패했습니다.");
      }
    } catch (e) {
      throw Exception("API 요청 실패: $e");
    }
  }
}
