import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/Screens/Categories/category.dart';
import 'package:flutter_projects/Screens/Favorites/favorite.dart';
import 'package:flutter_projects/Screens/Products/product.dart';
import 'package:flutter_projects/Screens/home/cubit/state.dart';
import 'package:flutter_projects/Screens/setting/setting.dart';
import 'package:flutter_projects/model/add_cart_model.dart';
import 'package:flutter_projects/model/cart_model.dart';
import 'package:flutter_projects/model/category_details_model.dart';
import 'package:flutter_projects/model/category_model.dart';
import 'package:flutter_projects/model/favorite_model.dart';
import 'package:flutter_projects/model/home_model.dart';
import 'package:flutter_projects/model/login_model.dart';
import 'package:flutter_projects/model/product_model.dart';
import 'package:flutter_projects/model/update_cart_model.dart';
import 'package:flutter_projects/shared/componnetns/components.dart';
import 'package:flutter_projects/shared/componnetns/constants.dart';
import 'package:flutter_projects/shared/network/End_Points.dart';
import 'package:flutter_projects/shared/network/remote/dio_helper.dart';
import 'package:image_picker/image_picker.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialState());
  static MainCubit get(context) => BlocProvider.of(context);

  Map <dynamic ,dynamic> favorites = {};
  Map <dynamic ,dynamic> cart = {};


  int currentIndex = 0;

  List<Widget> pages = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  void ChangeNavBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarItem());
  }

  LoginModel UserData;

  void getUserData() {
    emit(UserLoginLoadingState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      UserData = LoginModel.fromJson(value.data);
      emit(UserLoginSuccessState(UserData));
    }).catchError((error) {
      print(error.toString());
      emit(UserLoginErrorState(error.toString()));
    });
  }

  void UpdateUserData({
    @required String email,
    @required String name,
    @required String phone,
    String image,
  }) {
    emit(UserUpdateLoadingState());

    DioHelper.putData(
      url: UPDATE,
      token: token,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      UserData = LoginModel.fromJson(value.data);
      emit(UserUpdateSuccessState(UserData));
    }).catchError((error) {
      print(error.toString());
      emit(UserUpdateErrorState(error.toString()));
    });
  }



  HomeModel homeModel;


  void getHomeData() {
    emit(HomeLoadingState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel.data.banners.toString());
      print(homeModel.status);
      print(token);


      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      homeModel.data.products.forEach((element) {
        cart.addAll({
          element.id: element.inCart,
        });
      });

      emit(HomeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(CategoriesSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(CategoriesErrorStates());
    });
  }

  ChangeFavoritesModel changeFavoritesModel;

  void ChangeFavorites(int productID) {
    favorites[productID] = !favorites[productID];
    emit(ChangeFavoritesStates());

    DioHelper.postData(url: FAVORITES, token: token, data: {
      'product_id': productID,
    }).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel.status) {
        favorites[productID] = !favorites[productID];
      } else {
        getFavoritesData();
      }
      emit(ChangeFavoritesSuccessStates(changeFavoritesModel));
    }).catchError((error) {
      favorites[productID] = !favorites[productID];
      emit(ChangeFavoritesErrorStates());
    });
  }

  FavoritesModel favoritesModel;

  void getFavoritesData() {
    emit(FavoritesLoadingStates());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(GetFavoritesSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavoritesErrorStates());
    });
  }

  File profileImage;
  var picker = ImagePicker();
  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
    }
  }



  AddCartModel addCartModel;

  void ChangeCart(int productID) {

    emit(AddCartLoadingState());

    DioHelper.postData(url: CARTS, token: token, data: {
      'product_id': productID,
    }).then((value) {
      addCartModel = AddCartModel.fromJson(value.data);

      if (addCartModel.status) {
      getCartData();
      getHomeData();
      } else {
        ShowToast(
            text: addCartModel.message,
              state: ToastStates.ERROR,
        );
      }
      emit(AddCartSuccessState(addCartModel));
    }).catchError((error) {
      emit(AddCartErrorState());
      print(error.toString());
    });
  }

  CartModel cartModel;

  void getCartData() {
    emit(CartLoadingStates());

    DioHelper.getData(
      url: CARTS,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);

      emit(GetCartSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetCartErrorStates());
    });
  }

  UpdateCartModel updateCartModel;

  void updateCart(int cartId, int quantity) {
    emit(UpdateCartLoadingState());

    DioHelper.postData(url: 'carts/$cartId', token: token, data: {

      'quantity': '$quantity',
    }).then((value) {
      updateCartModel = UpdateCartModel.fromJson(value.data);

      if (updateCartModel.status) {
        getCartData();
      } else {
        ShowToast(
          text: updateCartModel.message,
          state: ToastStates.ERROR,
        );
      }
      emit(UpdateCartSuccessState());
    }).catchError((error) {
     print(error.toString());
      emit(UpdateCartErrorState());
    });
  }





  ProductDetailsModel productDetailsModel;
  void getProductData( productId ) {
    productDetailsModel = null;
    emit(ProductLoadingState());
    DioHelper.getData(
        url: 'products/$productId',
        token: token
    ).then((value){
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      print('Product Detail '+productDetailsModel.status.toString());
      emit(ProductSuccessState());
    }).catchError((error){
      emit(ProductErrorState());
      print(error.toString());
    });
  }
  CategoryDetailModel categoriesDetailModel;
  void getCategoriesDetailData( int categoryID ) {
    emit(CategoryDetailsLoadingState());
    DioHelper.getData(
        url: CATEGORIES_DETAILS,
        query: {
          'category_id':'$categoryID',
        }
    ).then((value){
      categoriesDetailModel = CategoryDetailModel.fromJson(value.data);
      print('categories Detail '+categoriesDetailModel.status.toString());
      emit(CategoryDetailsSuccessState());
    }).catchError((error){
      emit(CategoryDetailsErrorState());
      print(error.toString());
    });
  }


  int value = 0;
  void changeVal(val){
    value = val;
    emit(ChangeIndicatorState());
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void ChangePassword() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(UserChangePasswordState());
  }
}
