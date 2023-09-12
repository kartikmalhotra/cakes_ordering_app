class AddOnsList {
  List<AddonsModel>? addonsList;

  AddOnsList({this.addonsList});

  AddOnsList.fromJson(Map<String, dynamic> json) {
    if (json['addons_list'] != null) {
      addonsList = <AddonsModel>[];
      json['addons_list'].forEach((v) {
        addonsList!.add(new AddonsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addonsList != null) {
      data['addons_list'] = this.addonsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonsModel {
  String? id;
  String? name;
  String? price;
  List<dynamic>? images;
  String? colour;
  String? photoOnCake;

  AddonsModel({this.id, this.name, this.price, this.images, this.colour});

  AddonsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    price = json['price'];
    images = json["images"];
    colour = json["colour"];
    photoOnCake = json["photoOnCake"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['images'] = this.images;
    data["colour"] = this.colour;
    data["photoOnCake"] = this.photoOnCake;
    return data;
  }
}
