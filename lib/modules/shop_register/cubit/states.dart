

import 'package:shop_app/models/shop_login.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates{}


class ShopRegisterLoadingState extends ShopRegisterStates{}
class ShopRegisterSuccessState extends ShopRegisterStates{
 final ShopLoginModel registerModel;

  ShopRegisterSuccessState(this.registerModel);
}
class ShopRegisterErrorState extends ShopRegisterStates{
  final String error;
  ShopRegisterErrorState(this.error);
}


class ShopRegisterVisibilityState extends ShopRegisterStates{}