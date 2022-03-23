import 'dart:convert';
// import 'package:ecommerce_app_ui_kit/src/models/contact.dart';
// import 'package:ecommerce_app_ui_kit/src/models/post.dart';
// import 'package:ecommerce_app_ui_kit/src/models/user.dart';
// import 'package:ecommerce_app_ui_kit/src/models/user_update.dart';
// import 'package:ecommerce_app_ui_kit/src/models/verifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'global.dart' as globals;

class ApisService {
  //masterUrl
  final String dest = 'https://invent-integrasi.com/test_core/v1/';

  Future getProducts() async {
    String apiUrl = dest + "get_m_product";

    Response response;
    Dio dio = Dio();

    if (kDebugMode) {
      print("API Get Products");
    }

    response = await dio.get(apiUrl,
        options: Options(headers: {"Accept": "Application/json"}));

    // var items = json.decode(response.data);

    if (kDebugMode) {
      print(response);
    }
    return response.data;
  }

  Future getProductsPrices() async {
    String apiUrl = dest + "get_product_price";

    Response response;
    Dio dio = Dio();

    if (kDebugMode) {
      print("API Get Products Prices");
    }

    response = await dio.get(apiUrl,
        options: Options(headers: {"Accept": "Application/json"}));

    // var items = json.decode(response.data);

    if (kDebugMode) {
      print(response);
    }
    return response.data;
  }
}
