import 'package:get_it/get_it.dart';
import 'package:tesandroid/api.dart';
import 'package:flutter/foundation.dart';

class ProductPrice {
  String? productId;
  String? price;
  String? branchId;

  ProductPrice({this.productId, this.price, this.branchId});

  ProductPrice.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    price = json['price'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['price'] = price;
    data['branch_id'] = branchId;
    return data;
  }

  ProductPrice.fromMap(Map<String, dynamic> res) {
    productId = res['product_id'].toString();
    price = res['price'];
    branchId = res['branch_id'];
  }

  Map<String, Object?> toMap() {
    final Map<String, Object?> data = <String, Object?>{};
    data['product_id'] = productId;
    data['price'] = price;
    data['branch_id'] = branchId;
    return data;
  }
}

class ProductsPriceList {
  ApisService get service => GetIt.I<ApisService>();

  Future<List<ProductPrice>> getProductsModel() async {
    List<ProductPrice> listProduct = <ProductPrice>[];

    if (kDebugMode) {
      print('Processing Product List');
    }

    dynamic res = await service.getProductsPrices();
    if (kDebugMode) {
      print(res['status_code'].toString());
    }

    if (res['status_message_eng'].toString() == 'Success') {
      res['value'].forEach((value) {
        ProductPrice p = ProductPrice();
        p.productId = value['product_id'];

        p.price = value['price'];
        p.branchId = value['branch_id'];
        if (kDebugMode) {
          print(p.branchId);
        }

        listProduct.add(p);
      });
    }

    return listProduct;
  }
}
