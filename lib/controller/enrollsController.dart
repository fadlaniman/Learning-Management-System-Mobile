import 'package:get/get.dart';
import 'package:mobile/controller/authController.dart';
import 'package:mobile/model/classModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class EnrollsController extends GetxController {
  final AuthController auth = Get.find();
  final enrolls = <Class>[].obs;
  final users = <Class>[].obs;
  final loading = true.obs;

  Future fetchUsers(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${Url.baseUrl}/api/classes/$id/enroll/users'),
        headers: <String, String>{
          'Authorization': 'Bearer ${auth.box.read('token')}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        users.value = responseData.map((data) {
          return Class.fromJson(data as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future fetch() async {
    try {
      final response = await http.get(
        Uri.parse('${Url.baseUrl}/api/classes/enroll'),
        headers: <String, String>{
          'Authorization': 'Bearer ${auth.box.read('token')}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        enrolls.value = responseData.map((data) {
          return Class.fromJson(data as Map<String, dynamic>);
        }).toList();
        loading.value = false;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
