import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/enums/product_status.dart';
import 'package:foodie_merchant/src/data/enums/shop_status.dart';
import 'package:foodie_merchant/src/data/model/product.dart';
import 'package:foodie_merchant/src/data/model/product_type.dart';
import 'package:foodie_merchant/src/services/product/product_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

class ProductCatalog extends StatefulWidget {
  ProductCatalog({Key key, this.productType}) : super(key: key);

  final ProductType productType;

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalog> {
  bool enableProgress = false;
  List<Product> _productList = [];
  List<Product> _filteredProductList = [];
  ProductService _productService = locator<ProductService>();
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    fetchProductTypes();
  }

  fetchProductTypes() async {
    enableProgress = true;
    List<Product> _productList = await _productService
        .findShopProductsByProductTypeId(this.widget.productType.id);
    setState(() {
      this._productList = _productList;
      this._filteredProductList = _productList;
      enableProgress = false;
    });
  }

  _onSearchChanged() async {
    if (searchController.text.isNotEmpty) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 800), () async {
        List<Product> _filteredProductList = _productList
            .where((i) => i.title.contains(searchController.text))
            .toList();
        setState(() {
          this._filteredProductList = _filteredProductList;
        });
      });
    } else {
      setState(() {
        _filteredProductList = _productList;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: _search(),
                ),
                Expanded(
                    flex: 6,
                    child: enableProgress
                        ? ProductsSkeletonListView()
                        : _products()),
                SizedBox(height: 50)
              ],
            ),
          )
        ],
      ),
    )));
  }

  Widget _products() {
    if (_filteredProductList.length != 0) {
      return ListView.builder(
          itemCount: _filteredProductList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              width: double.maxFinite,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CachedNetworkImage(
                            imageUrl: "${Constant.filePath}${_filteredProductList[index].imageUrl}",
                            fit: BoxFit.fill,
                            height: 80.0,
                            width: 100.0,
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 500,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_filteredProductList[index].title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    (_filteredProductList[index].productType.name),
                                    style: TextStyle(fontSize: 16))
                              ],
                            )),
                      ],
                    ),
                    Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          _filteredProductList[index]
                              .unitPrice
                              .toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800]),
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ToggleSwitch(
                        minWidth: 100.0,
                        activeBgColor: _productList[index].status ==
                                ShopStatus.active.index
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey[400],
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: _productList[index].status ==
                                ShopStatus.active.index
                            ? 0
                            : 1,
                        labels: ['Active', 'Inactive'],
                        icons: [Icons.check, Icons.close],
                        onToggle: (toggleIndex) {
                          updateShopStatus(toggleIndex, _productList[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return Center(
        child: Text("No Products Available"),
      );
    }
  }

  Widget _search() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 50,
          child: TextField(
              enabled: true,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              controller: searchController,
              focusNode: focusNode,
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                hintText: widget.productType.name,
                hintStyle: TextStyle(color: Colors.grey[800], fontSize: 25),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                prefixIcon: Icon(Icons.search, color: Colors.black54, size: 30),
                labelStyle: TextStyle(color: Colors.black87),
                focusedBorder: InputBorder.none,
              )),
        )
      ],
    );
  }

  updateShopStatus(int index, Product product) async {
    ProductStatus productStatus;
    if (index == 0) {
      productStatus = ProductStatus.active;
    } else {
      productStatus = ProductStatus.inactive;
    }
    final http.Response response = await _productService.updateProductStatus(
        product.id, productStatus.index);
    if (response.statusCode == 200) {
      setState(() {
        _productList.where((element) => element.id == product.id).first.status =
            productStatus.index;
      });
    }
  }
}

class ProductsSkeletonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 8),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white70),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SkeletonAnimation(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[100],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
