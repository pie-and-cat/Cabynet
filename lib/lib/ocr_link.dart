import 'dart:convert';
import 'dart:io' as io;
import 'package:http/http.dart' as http;

//  HOW TO IMPLEMENT
//    Instantiate an OcrLink, o and call o.ocrQuery with the file path
//      to an image in PNG format, and a functioning API key.

class OcrLink {
  static OcrLink? uplink;
  static OcrLink? getInstance() {
    if (uplink == null) {
      OcrLink();
    }
    return uplink;
  }

  OcrLink() {
    if (uplink == null) {
      uplink = this;
    } else {
      throw Exception("OcrLink is a singleton");
    }
  }

  ocrQuery(String path, String apiKey) async {
    //  Connects to Free OCR API
    //  File passed as base64 string

    final String bytes = "data:image/png;base64," +
        base64.encode(io.File(path).readAsBytesSync());
    var res = await _sendQuery(apiKey, bytes);
    Map<String, dynamic> resBody =
        json.decode(res.body) as Map<String, dynamic>;
    return resBody['ParsedResults'][0]['ParsedText'];
  }

  _sendQuery(String key, String b64) {
    return http.post(Uri.parse('https://api.ocr.space/parse/image'),
        headers: <String, String>{
          'apikey': key
        },
        body: <String, String>{
          'base64Image': b64,
          'language': 'eng',
          'OCREngine': '2'
        });
  }
}
