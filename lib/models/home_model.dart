class HomeModel {
  bool status;
  Null message;
  Data data;


  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


}

class Data {
  List<Banners> banners;
  List<Products> products;
  String ad;


  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = new List<Banners>();
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    ad = json['ad'];
  }


}

class Banners {
  int id;
  String image;
  Category category;
  Null product;



  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    product = json['product'];
  }


}

class Category {
  int id;
  String image;
  String name;



  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
  }


}

class Products {
  int id;
  dynamic price;
  dynamic oldPrice;
  int discount;
  String image;
  String name;
  String description;
  List<String> images;
  bool inFavorites;
  bool inCart;

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }


}