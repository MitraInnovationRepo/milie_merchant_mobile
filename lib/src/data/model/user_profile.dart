import 'package:flutter/cupertino.dart';
import 'package:milie_merchant_mobile/src/data/model/shop.dart';
import 'package:milie_merchant_mobile/src/data/model/user_address.dart';

class UserProfile extends ChangeNotifier{
  String name;
  String countryCode;
  String phoneNumberWithCountryCode;
  String phoneNumber;
  String email;
  String currency;
  Shop shop;
  List<String> roles;

  double longitude;
  double latitude;
  Map<String, UserAddress> userAddressMap = new Map();

  UserProfile.empty();

  UserProfile(this.name, this.countryCode,
      this.phoneNumberWithCountryCode, this.phoneNumber,
      this.email, this.currency, this.roles, this.userAddressMap);

  notifyCreation(){
    notifyListeners();
  }

  clearAll(){
    this.name = null;
    this.countryCode = null;
    this.phoneNumberWithCountryCode = null;
    this.phoneNumber = null;
    this.email = null;
    this.currency = null;
    this.shop = null;
    this.roles = [];
    this.longitude = null;
    this.latitude = null;
    this.userAddressMap = new Map();
  }
}