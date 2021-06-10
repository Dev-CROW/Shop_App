import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/shop_categories_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/style/color.dart';


class ProductsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
    if (state is ShopSuccessChangeFavoritesState) {
    if (!state.model.status) {
    showToast(
    text: state.model.message,
    state: ToastStates.ERROR,
    );}
    }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null,
          builder: (context) => buildProductScreen(cubit.homeModel,cubit.categoriesModel, context),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }

  Widget buildProductScreen(HomeModel model,CategoriesModel categoriesModel, context) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
         physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              CarouselSlider(
                items: model.data.banners
                    .map(
                      (e) =>
                      Image(
                        image: NetworkImage(e.image),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                )
                    .toList(),
                options: CarouselOptions(
                  height: 180,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 100.0,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            buildCategoryItem(categoriesModel.data.data[index]),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 10.0,
                        ),
                        itemCount: categoriesModel.data.data.length,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'New Products',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              GridView.count(crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 1 / 1.38,

                children: List.generate( model.data.products.length,
                        (index) => buildProductItem(model.data.products[index], context)),
              )
            ],
          ),
        ),
      );

  Widget buildProductItem(Products model, context) => Container(
    height: 100.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 100.0,
              width: double.infinity,
            ),
            if(model.discount != 0)
              Container(
                  width: 70.0,
                  color: Colors.red,
                  child: Text("DISCOUNT", style: TextStyle(color: Colors.white),))
          ],
        ),
        Text(model.name, maxLines: 2, overflow: TextOverflow.ellipsis,),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 10.0, start: 10.0),
          child: Row(
            children: [
              Text('${model.price.round()}'),
              SizedBox(width: 10.0,),
              if(model.discount != 0)
              Text('${model.oldPrice.round()}', style: TextStyle(decoration: TextDecoration.lineThrough),),
              Spacer(),
              IconButton(icon: CircleAvatar(
                radius: 15.0,
                backgroundColor: ShopCubit.get(context).favorites[model.id] ?defaultColor : Colors.black26,
                child: Icon(Icons.favorite_border, size: 14.0,color: Colors.white,),
              ), onPressed: (){
                ShopCubit.get(context).changeFavorites(model.id);
              })
            ],
          ),
        )
      ],
    ),
  );
  Widget buildCategoryItem(CategoryItemModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(model.image),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(
          .8,
        ),
        width: 100.0,
        child: Text(
          model.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );

}
