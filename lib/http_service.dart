import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';


class HttpService{

  Future<String> GetReply(String userMessage) async{
    final String url = "http://api.brainshop.ai/get?bid=167524&key=ikLnjKuYbmCnFrdh&uid=Hetang&msg=${userMessage}";
    var response = await get(Uri.parse(url));
    var data = jsonDecode(response.body);
    // API will give data in json format, in this the reply will be in "cnt" variable
    // String str = data["cnt"];
    // print("returning $str");
    return data["cnt"];
  }
}