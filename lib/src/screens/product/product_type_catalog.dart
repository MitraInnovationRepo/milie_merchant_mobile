
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:milie_merchant_mobile/src/data/model/product_type.dart';
import 'package:milie_merchant_mobile/src/route/scale_route.dart';
import 'package:milie_merchant_mobile/src/screens/product/product_catalog.dart';
import 'package:milie_merchant_mobile/src/services/product/product_type_service.dart';
import 'package:milie_merchant_mobile/src/services/service_locator.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ProductTypeCatalog extends StatefulWidget {
  ProductTypeCatalog({Key key}) : super(key: key);

  @override
  _ProductTypeCatalogPageState createState() => _ProductTypeCatalogPageState();
}

class _ProductTypeCatalogPageState extends State<ProductTypeCatalog> {
  List<ProductType> _productTypeList;
  ProductTypeService _productTypeService = locator<ProductTypeService>();
  bool enableProgress = false;


  @override
  void initState() {
    super.initState();
    this.fetchProductTypes();
  }

  fetchProductTypes() async {
    enableProgress = true;
    List<ProductType> _productTypeList = await _productTypeService.findAllShopProducts();
    if(mounted) {
      setState(() {
        this._productTypeList = _productTypeList;
        enableProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
          enableProgress
              ? ProductTypeSkeletonListView()
              : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          ScaleRoute(
                              page:
                              ProductCatalog(productType: _productTypeList[index])));
                    },
                    child: Container(
                        child: Stack(children: [
                          ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                        imageUrl: _productTypeList[index].image,
                                        fit: BoxFit.fitWidth,
                                        height: MediaQuery.of(context).size.height * 0.4,
                                        width: MediaQuery.of(context).size.width * 0.5),
                                  ))),
                          Center(
                              child: Text(_productTypeList[index].name,
                                  style: TextStyle(color: Colors.white, fontSize: 30)))
                        ])));
              },
              childCount: _productTypeList.length,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 80.0),
          )
        ]));
  }
}

class ProductTypeSkeletonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return SkeletonAnimation(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
            ),
          );
        },
        childCount: 10,
      ),
    );
  }
}
