
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/shop_login.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavigationState extends ShopStates {}


class ShopLoadingGetDataState extends ShopStates {}
class ShopSuccessGetHomeDataState extends ShopStates {}
class ShopErrorGetHomeDataState extends ShopStates {}


class ShopChangeFavoritesState extends ShopStates {}
class ShopSuccessChangeFavoritesState extends ShopStates {
  ChangeFavoritesModel model;
  ShopSuccessChangeFavoritesState(this.model);
}
class ShopErrorChangeFavoritesState extends ShopStates {}
class ShopLoadingGetFavoritesState extends ShopStates {}
class ShopSuccessGetFavoritesState extends ShopStates {}
class ShopErrorGetFavoritesState extends ShopStates {}

class ShopSuccessGetUserDataState extends ShopStates {}
class ShopErrorGetUserDataState extends ShopStates {}
class ShopLoadingUpdateDataState extends ShopStates {}
class ShopSuccessUpdateProfileState extends ShopStates {
  final ShopLoginModel updateModel;

  ShopSuccessUpdateProfileState(this.updateModel);
}
class ShopErrorUpdateProfileState extends ShopStates {}
class ShopSuccessCategoriesState extends ShopStates {}
class ShopErrorCategoriesState extends ShopStates {}