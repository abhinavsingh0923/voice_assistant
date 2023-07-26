import 'dart:convert';

import 'package:http/http.dart'as http;

import '../private_files/key.dart';
// ignore: camel_case_types
class openai{
  final List<Map<String, String>> messages = [];

  Future<String>isnotgpt(String prompt) async{
    try {
     final response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
     headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $privatekey',
     },
     body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages":[{
        'role': 'user',
        'content':'Does thismessage want to genearte an AI picture, image, art or anything similar? $prompt . simpily answer with yes or no.',
      }]
     })
     );
     print(response);
     print(response.statusCode);
    if (response.statusCode == 200) {
      String content =  jsonDecode(response.body)['choices'][0]['message']['content'];
      content = content.trim();
      print(content);
      switch (content) {
        case 'yes':
        case 'Yes':
        case "yes.":
        case "Yes.":
          final response =  await dalle(prompt);
          return response;
        default:
        final response = await   chatgpt(prompt);
        return response;
      }
    }
    return "error occured";
    } catch (e) {
      return e.toString();
    }
  }
  Future<String> chatgpt(String prompt) async{
    messages.add({
      'role':'user',
      'content':prompt,
    });
        try {
     final response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
     headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $privatekey',
     },
     body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages":messages
     })
     );
    if (response.statusCode == 200) {
      String content =  jsonDecode(response.body)['choices'][0]['message']['content'];
      content = content.trim();

     messages.add({
      'role':"assistant",
      'content':content,
     });
     return content;
    }
    return "error occured";
    } catch (e) {
      return e.toString();
    }
  }
  Future<String> dalle(String prompt) async{
   messages.add({
      'role':'user',
      'content':prompt,
    });
        try {
     final response = await http.post(Uri.parse("https://api.openai.com/v1/images/generations"),
     headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $privatekey',
     },
     body: jsonEncode({
      "prompt":prompt,
      "n":1
     })
     );
    if (response.statusCode == 200) {
      String imageurl =  jsonDecode(response.body)['data'][0]['url'];
      imageurl = imageurl.trim();

     messages.add({
      'role':"assistant",
      'content':imageurl,
     });
     return imageurl;
    }
    return "error occured";
    } catch (e) {
      return e.toString();
    }
  }
}