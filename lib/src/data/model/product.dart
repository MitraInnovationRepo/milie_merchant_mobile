import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/product_additional.dart';
import 'package:milie_merchant_mobile/src/data/model/product_addon.dart';
import 'package:milie_merchant_mobile/src/data/model/product_type.dart';
import 'package:milie_merchant_mobile/src/data/model/product_unit.dart';
import 'package:milie_merchant_mobile/src/data/model/shop.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int id;
  String title;
  ProductType productType;
  double unitPrice;
  Shop shop;
  String description;
  int status;
  double maxOrderQuantity;
  double minOrderQuantity;
  String imageUrl;
  ProductUnit productUnit;
  double unitSize;
  List<ProductAddon> productAddonList;
  List<ProductAdditional> productAdditionalList;

  Product.empty();

  Product(
      this.id,
      this.title,
      this.productType,
      this.shop,
      this.description,
      this.imageUrl,
      this.minOrderQuantity,
      this.maxOrderQuantity,
      this.unitPrice,
      this.status,
      this.productUnit,
      this.unitSize,
      this.productAddonList,
      this.productAdditionalList);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
