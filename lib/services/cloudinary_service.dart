import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/dd4brgzrs/image/upload",
    );

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'flutter_unsigned'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseBody);
      return jsonResponse["secure_url"];
    } else {
      print("Upload failed: $responseBody");
      return null;
    }
  }
}
