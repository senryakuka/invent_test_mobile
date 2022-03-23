import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesandroid/api.dart';
import 'package:tesandroid/services/database_handler.dart';
import 'package:tesandroid/src/models/product.dart';
import 'package:tesandroid/src/models/product_price.dart';
import 'package:flutter/foundation.dart';

class ProductListWidget extends StatefulWidget {
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  late DatabaseHandler handler;
  bool? _isLoading;
  ProductsList _productsList = new ProductsList();
  ProductsPriceList _productsPricesList = new ProductsPriceList();
  List<Product> listProducts = <Product>[];
  List<ProductPrice> listProductsPrices = <ProductPrice>[];

  late List<DropdownMenuItem<SortOption>> _sortItems;
  late SortOption _selectedSort;
  String table = 'product_name';
  String order = 'ASC';

  void initState() {
    _fetchProductsList();

    List<SortOption> sorts = SortOption.allOptions;
    _sortItems = sorts.map<DropdownMenuItem<SortOption>>(
      (SortOption sortOption) {
        return DropdownMenuItem<SortOption>(
          value: sortOption,
          child: Text(sortOption.fullName),
        );
      },
    ).toList();
    _selectedSort = sorts[2];
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: Row(
          children: <Widget>[
            Text('Product List'),
            SizedBox(
              width: 60,
            ),
            DropdownButton<SortOption>(
                underline: Container(),
                icon: Icon(Icons.sort, color: Colors.black),
                value: _selectedSort,
                style: TextStyle(color: Colors.black, fontSize: 18),
                items: _sortItems,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSort = newValue!;
                    List<String> splitedSelected = _selectedSort.key.split("|");
                    if (kDebugMode) {
                      print(splitedSelected);
                    }
                    table = splitedSelected[0];
                    order = splitedSelected[1];
                  });
                })
          ],
        ),
      ),
      body: FutureBuilder(
        future: handler.retrieveProducts(table, order),
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).pushNamed('/Search');
        },
      ),
    );
  }

  Future<int> addProducts() async {
    // Product firstProduct = Product(
    //     productId: "000000",
    //     productName: "Test Product Postman",
    //     productType: "",
    //     productGroup: "",
    //     productWeight: "17.00",
    //     uom: "pcs",
    //     dnrCode: "-",
    //     sapCode: "-",
    //     price: "150000",
    //     isPpnInclude: "false",
    //     productWeightUom: "gram");
    // Product secondProduct = Product(
    //     productId: "20200731232944872",
    //     productName: "nanda 1210",
    //     productType: "PTY/20200130/0001",
    //     productGroup: "PGR/20200130/0001",
    //     productWeight: "20.00",
    //     uom: "BTL",
    //     dnrCode: "123",
    //     sapCode: "123",
    //     price: "12000",
    //     isPpnInclude: "false",
    //     productWeightUom: "gram");
    // List<Product> listOfProducts = [firstProduct, secondProduct];
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

class SortOption {
  final String key;
  final String fullName;

  SortOption(this.key, this.fullName);

  static List<SortOption> get allOptions => [
        SortOption('price|ASC', 'Harga Termurah'),
        SortOption('price|DESC', 'Harga Termahal'),
        SortOption('product_name|ASC', 'Nama ASC'),
        SortOption('product_name|DESC', 'Nama DESC'),
      ];
}
