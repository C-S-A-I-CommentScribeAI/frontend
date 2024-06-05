import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:frontend/user/models/selectCategory_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCategoryService {
  late String serverAddress;

  // 카테고리 가져오기 API
  Future<List<SelectCategoryModel>> getCategory(
      int selectedCategoryIndex) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 카테고리 인스턴스를 저장할 리스트를 생성
    List<SelectCategoryModel> categoryInstance = [];

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/store/category';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/store/category';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {'Authorization': 'Bearer $accessToken'};

      // GET 요청
      final response = await http.get(url, headers: headers);

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        // 서버 응답을 UTF-8로 디코딩
        final utf8Response = utf8.decode(response.bodyBytes);
        // 디코딩된 응답을 JSON 형태로 변환
        final dynamic jsonResponse = jsonDecode(utf8Response);

        // jsonResponse가 Map이고 data 필드가 List일 경우
        if (jsonResponse is Map && jsonResponse['data'] is List) {
          final List<dynamic> categories = jsonResponse['data'];
          print('JSON 데이터: $categories');

          // 각 카테고리를 SelectCategoryModel 인스턴스로 변환하여 리스트에 추가
          for (var category in categories) {
            categoryInstance.add(SelectCategoryModel.fromJson(category));
          }

          print('조회 성공 $categoryInstance');
          return categoryInstance;
        } else {
          // 응답이 예상과 다를 경우
          print('응답이 예상과 다름: $jsonResponse');
          return [];
        }
      } else {
        // 요청 실패 시
        print('조회 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        return [];
      }
    } catch (e) {
      // 예외 발생 시
      print('예외 발생: $e');
      return [];
    }
  }

  // 카테고리별 가게 조회 API
  Future<List<SelectCategoryModel>> getSelectCategory(String category) async {
    // 가게 인스턴스를 저장할 리스트 생성
    List<SelectCategoryModel> categorySelectInstance = [];

    // 현재 플랫폼에 따라 서버 주소 설정.
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/store/category/stores';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/store/category/stores';
    }

    try {
      // 서버에 요청을 보냄
      final url = Uri.parse('$serverAddress?category=$category');

      // 헤더 설정
      final headers = {
        'Content-Type': 'application/json',
      };

      // GET 요청을 보냄
      final response = await http.get(url, headers: headers);

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        // 서버 응답을 UTF-8로 디코딩
        final utf8Response = utf8.decode(response.bodyBytes);
        // 디코딩된 응답을 JSON 형태로 변환
        final dynamic jsonResponse = jsonDecode(utf8Response);

        // jsonResponse가 Map이고 data 필드가 List일 경우
        if (jsonResponse is Map && jsonResponse['data'] is List) {
          final List<dynamic> stores = jsonResponse['data'];
          print('JSON 데이터: $stores');

          // 각 가게를 SelectCategoryModel 인스턴스로 변환하여 리스트에 추가
          for (var store in stores) {
            categorySelectInstance.add(SelectCategoryModel.fromJson(store));
          }

          print('조회 성공 $categorySelectInstance');
          return categorySelectInstance;
        } else if (jsonResponse is List) {
          // jsonResponse가 List일 경우
          final List<dynamic> stores = jsonResponse;
          print('JSON 데이터: $stores');

          // 각 가게를 SelectCategoryModel 인스턴스로 변환하여 리스트에 추가
          for (var store in stores) {
            categorySelectInstance.add(SelectCategoryModel.fromJson(store));
          }

          print('조회 성공 $categorySelectInstance');
          return categorySelectInstance;
        } else {
          // 응답이 예상과 다를 경우
          print('응답이 예상과 다름: $jsonResponse');
          return [];
        }
      } else {
        // 요청 실패 시
        print('조회 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        return [];
      }
    } catch (e) {
      // 예외 발생 시
      print('예외 발생: $e');
      return [];
    }
  }
}
