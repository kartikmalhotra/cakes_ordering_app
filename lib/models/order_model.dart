import 'package:foodeasecakes/models/cakes_model.dart';

class OrderDataModel {
  List<OrderData>? orderList;

  OrderDataModel({this.orderList});

  OrderDataModel.fromJson(Map<String, dynamic> json) {
    if (json['order_data'] != null) {
      orderList = <OrderData>[];
      json['order_data'].forEach((v) {
        orderList!.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['order_data'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderData {
  String? id;
  String? title;
  String? ingredient;
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

  OrderData({
    this.id,
    this.title,
    this.ingredient,
    this.description,
    this.quantity = 1,
    this.flavour,
    this.images,
    this.variants,
    this.messageOnCake,
    this.dateTime,
    this.addOns,
    this.name,
    this.phoneNumber,
    this.paid = false,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['_id'];
    title = json['title'];
    ingredient = json['ingredient'];
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
    phoneNumber = json["phoneNumber"] ?? "";
    paid = json["paid"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['ingredient'] = this.ingredient;
    data['description'] = this.description;
    data['images'] = this.images;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    data["name"] = this.name;
    data["phoneNumber"] = this.phoneNumber;
    data["paid"] = this.paid;
    return data;
  }
}
