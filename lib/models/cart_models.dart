import 'package:foodeasecakes/models/cakes_model.dart';

class CartDataModel {
  List<CartData>? cartList;

  CartDataModel({this.cartList});

  CartDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cart_data'] != null) {
      cartList = <CartData>[];
      json['cart_data'].forEach((v) {
        cartList!.add(new CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartList != null) {
      data['cakes_data'] = this.cartList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  String? id;
  String? title;
  String? description;
  String? flavour;
  int quantity = 1;
  List<dynamic>? images;
  List<Variants>? variants;
  String? messageOnCake;
  String? dateTime;
  List<dynamic>? addOns;
  String? name;
  String? phoneNumber;
  bool paid = false;

  CartData({
    this.id,
    this.title,
    this.description,
    this.quantity = 1,
    this.flavour,
    this.images,
    this.variants,
    this.messageOnCake,
    this.dateTime,
    this.addOns,
    this.name,
    this.paid = false,
  });

  CartData.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    images = json['images'];
    flavour = json["flavour"];
    messageOnCake = json['messageOnCake'];
    quantity = json["quantity"] ?? 1;
    if (json['variants'] != null) {
      variants = <Variants>[];
      if (json["variants"] is List) {
        json['variants'].forEach((v) {
          variants!.add(new Variants.fromJson(v));
        });
      } else {
        variants!.add(Variants.fromJson(json['variants']));
      }
    }
    if (json["dateTime"] != null) {
      dateTime = DateTime.parse(json["dateTime"]).toString();
    }
    if (json["addOns"] != null) {
      addOns = json["addOns"];
    }
    name = json["name"] ?? "";
    phoneNumber = json["phoneNumber"]?.toString() ?? "";
    paid = json["paid"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data["messageOnCake"] = this.messageOnCake;
    data["quantity"] = this.quantity;
    data["dateTime"] = this.dateTime.toString();

    data['images'] = this.images;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    data["addOns"] = this.addOns;
    data["name"] = this.name;
    data["phoneNumber"] = this.phoneNumber;
    data["paid"] = this.paid;
    return data;
  }
}
