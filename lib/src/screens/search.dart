import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesandroid/api.dart';
import 'package:tesandroid/services/database_handler.dart';
import 'package:tesandroid/src/models/product.dart';
import 'package:tesandroid/src/models/product_price.dart';
import 'package:flutter/foundation.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  //Database Variable
  late DatabaseHandler handler;
  bool? _isLoading;
  ProductsList _productsList = new ProductsList();
  List<Product> listProducts = <Product>[];

  ProductsPriceList _productsPricesList = new ProductsPriceList();
  List<ProductPrice> listProductsPrices = <ProductPrice>[];

  //Sort Variable
  String table = 'product_name';
  String order = 'ASC';

  //Search Variable
  final _searchController = TextEditingController();
  late String searchValue = "#";

  void initState() {
    _fetchProductsList();
    super.initState();
    handler = DatabaseHandler();
  }

  _fetchProductsList() async {
    setState(() {
      _isLoading = true;
    });

    if (kDebugMode) {
      print("start");
    }

    listProducts = await _productsList.getProductsModel();
    listProductsPrices = await _productsPricesList.getProductsModel();

    handler.initializeDB().whenComplete(() async {
      await addProducts();
      await addProductsPrices();
      setState(() {});
    });

    if (kDebugMode) {
      print("end");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchValue = "#";
                        });
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
                onChanged: (newValue) {
                  setState(() {
                    searchValue = newValue;
                  });
                }),
          ),
        ),
      ),
      body: FutureBuilder(
        future: handler.retrieveProductWithSearch(searchValue),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (_isLoading == true) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<String>(snapshot.data![index].productId!),
                  onDismissed: (DismissDirection direction) async {
                    await handler
                        .deleteProducts(snapshot.data![index].productId!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    leading: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                        maxWidth: 64,
                        maxHeight: 64,
                      ),
                      child:
                          Image.asset("img/placeholder.png", fit: BoxFit.cover),
                    ),
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].productName.toString()),
                    subtitle: Text('Harga: ' +
                        snapshot.data![index].price.toString() +
                        "\n" +
                        'Cabang: ' +
                        snapshot.data![index].branchId.toString()),
                  )),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<int> addProducts() async {
    if (kDebugMode) {
      print('start of inserting products');
    }
    List<Product> listOfProducts = listProducts;
    if (kDebugMode) {
      print(listOfProducts);
    }
    return await handler.insertProduct(listOfProducts);
  }

  Future<int> addProductsPrices() async {
    if (kDebugMode) {
      print('start of inserting products');
    }
    List<ProductPrice> listOfProducts = listProductsPrices;
    if (kDebugMode) {
      print(listOfProducts);
    }
    return await handler.insertProductPrice(listOfProducts);
  }
}
