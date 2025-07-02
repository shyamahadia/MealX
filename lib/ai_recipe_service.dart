import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_recepi_app/secrets.dart';

class AIRecipeService {
  static const String _apiKey = Secrets.openAiApiKey;
     
  static Future<String> generateRecipe(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {
      'Content-Type': 'application/json',

      'Authorization': 'Bearer $_apiKey',
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini", // or "gpt-4o" or "gpt-3.5-turbo"
      "messages": [
        {
          "role": "system",
          "content":
              "You are a helpful assistant who writes detailed cooking recipes.",
        },
        {
          "role": "user",
          "content": "Create a detailed cooking recipe based on: $prompt",
        },
      ],
      "temperature": 0.7,
      "max_tokens": 1500,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final recipe = data['choices'][0]['message']['content'];
      return recipe;
    } else {
      return 'Failed to generate recipe: ${response.statusCode} ${response.reasonPhrase}';
    }
  }
}
