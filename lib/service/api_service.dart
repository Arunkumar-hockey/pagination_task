import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:pagination_task/model/pagination_model.dart';

class APIService {

  Future <List<Products>> fetchProducts(int pageNo, int pageSize) async{
    String completeUrl = "https://jsonplaceholder.typicode.com/todos?_page=$pageNo&_limit=$pageSize";
    var url = Uri.parse(completeUrl);
    List<Products> res = [];
    try {
      var response = await http.get(url);
      print("====Map====${response.body.toString()}");
      if(response.statusCode == 200) {
        var result = json.decode(response.body);
        var jsonList = result as List;
        res = jsonList.map((json) => Products.fromJson(json)).toList();

        return res;
      }else{
        return res;
      }
    } catch (e) {
      print(e.toString());
      return res;
    }
  }

}