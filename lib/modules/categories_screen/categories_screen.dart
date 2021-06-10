import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/shop_categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).categoriesModel != null,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildCategoriesScreen(ShopCubit.get(context).categoriesModel.data.data[index]),
            separatorBuilder: (context, index) => Container(
              margin: EdgeInsetsDirectional.only(start:10.0 ),
              height: 1.0,
              color: Colors.grey,
            ),
            itemCount: ShopCubit.get(context).categoriesModel.data.data.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }

  Widget buildCategoriesScreen(CategoryItemModel model) => Container(
    padding: EdgeInsets.all( 10.0),
    child: Row(
      children: [
        CircleAvatar(backgroundColor: Colors.white,radius: 40, backgroundImage: NetworkImage(model.image),),
        SizedBox(width: 20.0,),
        Text(
          model.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
          TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){})
      ],
    ),
  );
}
