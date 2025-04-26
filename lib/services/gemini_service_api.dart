import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String? apiKey = dotenv.env['GEMINI_API_KEY'];

  final List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

  Future<String> getResponse(String userInput) async {
    _history.add({
      'role': 'user',
      'parts': [
        {'text': userInput}
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'contents': _history}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botText = data['candidates']?[0]['content']['parts'][0]['text'] ??
          'No response from bot.';

        _history.add({
          'role': 'model',
          'parts': [
            {'text': botText}
          ]
        });

        return botText;
      } else {
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }

  void resetConversation() {
    _history.clear();
  }
}
