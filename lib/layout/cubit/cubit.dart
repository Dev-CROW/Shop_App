
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/shop_categories_model.dart';
import 'package:shop_app/models/shop_favorites_model.dart';
import 'package:shop_app/models/shop_login.dart';
import 'package:shop_app/modules/categories_screen/categories_screen.dart';
import 'package:shop_app/modules/favorites_screen/favorites_screen.dart';
import 'package:shop_app/modules/home_screen/products_screen.dart';
import 'package:shop_app/modules/settings_screen/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context)=> BlocProvider.of(context);
  List<Widget> screens= [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];
  List<String> titles= [
    'Home',
    'Categories',
    'Favorites',
    'Settings',

  ];
  Map<int , bool> favorites = {};
  int currentIndex = 0;
  void changeBottomNav(int index){
    currentIndex = index;
    emit(ShopChangeBottomNavigationState());
  }
  HomeModel homeModel;
  void getHomeData(){
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id : element.inFavorites,
        });
      });
      emit(ShopSuccessGetHomeDataState());
    }).catchError((error){emit(ShopErrorGetHomeDataState());});
  }
  CategoriesModel categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }
  ChangeFavoritesModel changeFavoritesModel;
  void changeFavorites(int productId){
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavoritesState());
    DioHelper.postData(url: FAVORITES, token: token,data: {
      'product_id': productId,
    }).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if(!changeFavoritesModel.status){
        favorites[productId] = !favorites[productId];
      }else{
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));

    }).catchError((error){
      favorites[productId] = !favorites[productId];
      emit(ShopErrorChangeFavoritesState());
    });
  }
  FavoritesGetModel favoritesModel;

  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(url: FAVORITES, token: token).then((value)
    {
      favoritesModel = FavoritesGetModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel userModel;

  void getUserData()
  {

    DioHelper.getData(url: PROFILE, token: token).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessGetUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserDataState());
    });
  }


  ShopLoginModel updateModel;

  void userUpdate({
    @required String email,
    @required String phone,
    @required String name,
  }){
    emit(ShopLoadingUpdateDataState());
    DioHelper.putData(url: UPDATE, token: token, data: {
      'email': email,
      'phone': phone,
      'name': name,
    },

    ).then((value) {
      print(value.data);
      updateModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateProfileState(updateModel));
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUpdateProfileState());
    });
  }
}