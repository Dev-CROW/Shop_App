import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';


class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      defaultFormfield(
                          controller: searchController,
                          type: TextInputType.text,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Must Be Value';
                            }
                            return null;
                          },
                          textlabel: 'Search',
                          prefix: Icons.search,
                          submit: (String text) {
                            SearchCubit.get(context).getSearch(text);
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      if (state is SearchLoadingState)
                        LinearProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      if(state is SearchSuccessState)
                        ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(SearchCubit.get(context).searchGetModel.data.data[index], context),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context).searchGetModel.data.data.length,
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
