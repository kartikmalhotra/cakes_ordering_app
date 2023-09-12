import 'package:foodeasecakes/models/cakes_model.dart';

class CakesDataModel {
  List<CakeData>? cakesData;

  CakesDataModel({this.cakesData});

  CakesDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cakes_data'] != null) {
      cakesData = <CakeData>[];
      json['cakes_data'].forEach((v) {
        cakesData!.add(new CakeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cakesData != null) {
      data['cakes_data'] = this.cakesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CakeData {
  String? id;
  String? title;
  String? ingredient;
  String? description;
  List<String>? flavour;
  List<dynamic>? images;
  List<Variants>? variants;
  String? cakeType;

  CakeData({
    this.id,
    this.title,
    this.ingredient,
    this.description,
    this.flavour,
    this.images,
    this.variants,
    this.cakeType,
  });

  CakeData.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['_id'];
    title = json['title'];
    ingredient = json['ingredient'];
    cakeType = json["cakeType"];
    description = json['description'];
    images = json['images'];
    flavour = json["flavours"].cast<String>() ?? [];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
    cakeType = json['cakeType'];
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
    return data;
  }
}

class Flavour {
  String? id;
  String? name;

  Flavour({required this.id, required this.name});

  Flavour.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Variants {
  String? price;
  String? weight;

  Variants({this.price, this.weight});

  Variants.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['weight'] = this.weight;
    return data;
  }
}
