import 'dart:io';
import 'package:get/get.dart';
import 'package:mobile/controller/authController.dart';
import 'package:mobile/model/attachmentsModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/view/widgets/navigationBar.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

class AttachmentsController extends GetxController {
  final AuthController auth = Get.find();
  final attachments = <Attachments>[].obs;
  final attachment = Rx<Attachments>(Attachments());
  final url = ''.obs;
  final loading = true.obs;

  Future download(String filepath) async {
    try {
      final response = await http.get(
        Uri.parse('${Url.baseUrl}/api/download/$filepath'),
        headers: <String, String>{
          'Authorization': 'Bearer ${auth.box.read('token')}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Directory? appDocumentsDirectory = await getExternalStorageDirectory();
        String filePath = '${appDocumentsDirectory!.path}/${filepath}';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print(file);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future fetchById(String class_id, int attachment_id) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Url.baseUrl}/api/classes/$class_id/attachments/$attachment_id'),
        headers: <String, String>{
          'Authorization': 'Bearer ${auth.box.read('token')}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)['data'];
        attachment.value = Attachments.fromJson(responseData);
        loading.value = false;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future fetch(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${Url.baseUrl}/api/classes/$id/attachments'),
        headers: <String, String>{
          'Authorization': 'Bearer ${auth.box.read('token')}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        attachments.value = responseData.map((data) {
          return Attachments.fromJson(data as Map<String, dynamic>);
        }).toList();
        loading.value = false;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future send(String title, String description, String type, DateTime deadline,
      File file, String id) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Url.baseUrl}/api/classes/$id/attachments'),
      );
      request.headers['Authorization'] = 'Bearer ${auth.box.read('token')}';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['type'] = type;
      request.fields['deadline'] = deadline.toIso8601String();
      request.fields['user_id'] = auth.user['uid'].toString();
      request.fields['class_id'] = id;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));
      var response = await request.send();
      print(response.request);
      if (response.statusCode == 201) {
        print('File uploaded successfully');
        Get.to(() => const NavigationBarWidget());
        return fetch(id);
      } else {
        throw Exception('Failed to send attachment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send attachment: ${e}');
    }
  }
}
