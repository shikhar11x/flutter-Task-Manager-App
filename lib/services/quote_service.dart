import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<Map<String, String>> fetchQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/quotes/random'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'quote': data['quote'],
          'author': data['author'],
        };
      } else {
        return _fallback();
      }
    } catch (e) {
      return _fallback();
    }
  }

  Map<String, String> _fallback() {
    return {
      'quote': 'Stay focused and never give up!',
      'author': 'Unknown',
    };
  }
}