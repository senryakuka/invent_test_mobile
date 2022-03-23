import 'package:get_it/get_it.dart';
import 'package:tesandroid/api.dart';
import 'package:flutter/foundation.dart';

class Product {
  String? productId;
  String? productName;
  String? productType;
  String? productGroup;
  String? productWeight;
  String? uom;
  String? dnrCode;
  String? sapCode;
  String? price;
  String? isPpnInclude;
  String? productWeightUom;
  String? branchId;

  Product(
      {this.productId,
      this.productName,
      this.productType,
      this.productGroup,
      this.productWeight,
      this.uom,
      this.dnrCode,
      this.sapCode,
      this.price,
      this.isPpnInclude,
      this.productWeightUom});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productType = json['product_type'];
    productGroup = json['product_group'];
    productWeight = json['product_weight'];
    uom = json['uom'];
    dnrCode = json['dnr_code'];
    sapCode = json['sap_code'];
    price = json['price'];
    isPpnInclude = json['is_ppn_include'];
    productWeightUom = json['product_weight_uom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['product_group'] = productGroup;
    data['product_weight'] = productWeight;
    data['uom'] = uom;
    data['dnr_code'] = dnrCode;
    data['sap_code'] = sapCode;
    data['price'] = price;
    data['is_ppn_include'] = isPpnInclude;
    data['product_weight_uom'] = productWeightUom;
    return data;
  }

  Product.fromMap(Map<String, dynamic> res) {
    productId = res['product_id'].toString();
    productName = res['product_name'];
    productType = res['product_type'];
    productGroup = res['product_group'];
    productWeight = res['product_weight'].toString();
    uom = res['uom'];
    dnrCode = res['dnr_code'];
    sapCode = res['sap_code'];
    price = res['price'].toString();
    isPpnInclude = res['is_ppn_include'];
    productWeightUom = res['product_weight_uom'];
    branchId = res['branch_id'];
  }

  Map<String, Object?> toMap() {
    final Map<String, Object?> data = <String, Object?>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['product_group'] = productGroup;
    data['product_weight'] = productWeight;
    data['uom'] = uom;
    data['dnr_code'] = dnrCode;
    data['sap_code'] = sapCode;
    data['price'] = price;
    data['is_ppn_include'] = isPpnInclude;
    data['product_weight_uom'] = productWeightUom;
    return data;
  }
}

class ProductsList {
  ApisService get service => GetIt.I<ApisService>();

  Future<List<Product>> getProductsModel() async {
    List<Product> listProduct = <Product>[];

    if (kDebugMode) {
      print('Processing Product List');
    }

    dynamic res = await service.getProducts();
    if (kDebugMode) {
      print(res['status_code'].toString());
    }

    if (res['status_message_eng'].toString() == 'Success') {
      res['value'].forEach((value) {
        Product p = Product();
        p.productId = value['product_id'];
        if (kDebugMode) {
          print(p.productId);
        }
        p.productName = value['product_name'];
        p.productType = value['product_type'];
        p.productGroup = value['product_group'];
        p.productWeight = value['product_weight'];
        p.uom = value['uom'];
        p.dnrCode = value['dnr_code'];
        p.sapCode = value['sap_code'];
        p.price = value['price'];
        p.isPpnInclude = value['is_ppn_include'];
        p.productWeightUom = value['product_weight_uom'];

        listProduct.add(p);
      });
    }

    return listProduct;
  }
}
