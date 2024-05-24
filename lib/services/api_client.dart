
import 'package:http/http.dart' as http;

class ApiClient{


  static Future<dynamic> getMethod() async {
    http.Response response =
    await http.get(Uri.parse("https://api.coincap.io/v2/markets"));
    return response.body;
  }
}