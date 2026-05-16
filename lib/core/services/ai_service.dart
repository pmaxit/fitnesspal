import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // Use 10.0.2.2 to access localhost from Android Emulator
  static const String _baseUrl = 'https://habit-analyzer-1078980357394.us-central1.run.app';

  Future<Map<String, dynamic>> analyzeHabit(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/analyze-habit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'goal': 'Failed to analyze habit',
          'difficulty': 1,
        };
      }
    } catch (e) {
      return {
        'goal': 'Error connecting to AI service',
        'difficulty': 1,
      };
    }
  }
}
