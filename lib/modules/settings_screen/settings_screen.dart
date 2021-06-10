import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/style/color.dart';


class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessUpdateProfileState){
          if(!state.updateModel.status)
            showToast(text: state.updateModel.message, state: ToastStates.WARNING);

        }
      },
      builder: (context, state) {
        var model = ShopCubit
            .get(context)
            .userModel;
        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;
        return ConditionalBuilder(
          condition: ShopCubit
              .get(context)
              .userModel != null,
          builder: (context) =>
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is ShopLoadingUpdateDataState)
                        LinearProgressIndicator(),
                      SizedBox(height: 20.0,),
                      defaultFormfield(controller: nameController,
                          type: TextInputType.name,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Input Must Be Valued';
                            }
                            return null;
                          },
                          textlabel: 'Name',
                          prefix: Icons.person),
                      SizedBox(height: 15.0),
                      defaultFormfield(controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Input Must Be Valued';
                            }
                            return null;
                          },
                          textlabel: 'Email',
                          prefix: Icons.email),
                      SizedBox(height: 15.0),
                      defaultFormfield(controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Input Must Be Valued';
                            }
                            return null;
                          },
                          textlabel: 'Phone',
                          prefix: Icons.lock),
                      SizedBox(height: 15.0),
                      defaultButton(text: 'Logout', function: () {
                        signOut(context);
                      }, background: defaultColor),
                      SizedBox(height: 15.0),
                      defaultButton(text: 'Update', function: () {
                        if(formKey.currentState.validate()){
                          ShopCubit.get(context).userUpdate(
                              email: emailController.text,
                              phone: phoneController.text,
                              name: nameController.text);}

                      }, background: defaultColor)
                    ],
                  ),
                ),
              ),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}
