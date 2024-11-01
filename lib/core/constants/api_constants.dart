import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.api-ninjas.com/v1';
  static String apiKey = dotenv.env['API_KEY'] ?? '';
}
