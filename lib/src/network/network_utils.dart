import 'dart:convert';

import 'package:chat_gpt_demo/src/network/api.dart';
import 'package:http/http.dart';

class Network {

  static sendMessage(String? message) async {
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Api.apiKey}'
    };

    var result = await post(
      Uri.parse(Api.baseUrl),
      headers: header,
      body: jsonEncode(
        {
          "model": "text-davinci-003",
          "prompt": "$message",
          "max_tokens": 100,
          "temperature": 0,
          "top_p": 1,
          "frequency_penalty" : 0.0,
          "presence_penalty" : 0.0,
          "stop": [" Human:", " AI:"]
        },
      ),
    );

    print('ResponseCode: ${result.statusCode}');
    print('ResponseBody: ${result.body}');

    if(result.statusCode == 200){
      var data = jsonDecode(result.body.toString());
      var msg = data['choices'][0]['text'];
      print('Result: $msg');
      return msg;
    } else{
      print('Failed to fetch data!');
    }
  }
}
