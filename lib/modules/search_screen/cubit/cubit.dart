

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search_screen/cubit/states.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context)=> BlocProvider.of(context);

  SearchGetModel searchGetModel;
  void getSearch(String text){
    emit(SearchLoadingState());
    DioHelper.postData(url: SEARCH, token: token, data:
    {
      'text': text,
    }
    ).then((value) {
      searchGetModel = SearchGetModel.fromJson(value.data);
      emit(SearchSuccessState());

    }).catchError((error){ emit(SearchErrorState());});
  }

}