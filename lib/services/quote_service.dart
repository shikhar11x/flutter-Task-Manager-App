import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<Map<String, String>> fetchQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'quote': data['content'],
          'author': data['author'],
        };
      } else {
        return {
          'quote': 'Stay focused and never give up!',
          'author': 'Unknown',
        };
      }
    } catch (e) {
      return {
        'quote': 'Stay focused and never give up!',
        'author': 'Unknown',
      };
    }
  }
}