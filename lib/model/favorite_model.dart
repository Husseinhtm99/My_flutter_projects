class FavoritesModel {
  bool status;
  Null message;
  Data data;

  FavoritesModel({this.status, this.message, this.data});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


}

class Data {
  int currentPage;
  List<FavoritesData> favoritesData;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String path;
  int perPage;
  int to;
  int total;



  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      favoritesData = <FavoritesData>[];
      json['data'].forEach((v) {
        favoritesData.add(new FavoritesData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }


}

class FavoritesData {
  int id;
  Product product;


  FavoritesData .fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }


}

class Product {
  int id;
  int price;
  int oldPrice;
  int discount;
  String image;
  String name;
  String description;



  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

}
class ChangeFavoritesModel
{
  bool status;
  String message;

  ChangeFavoritesModel.fromJson(Map<String,dynamic>json)
  {
    status = json['status'];
    message = json['message'];
  }
}