import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_home_layout.dart';
import 'package:shop_app/modules/shop_register/shop_register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

// ignore: must_be_immutable
class ShopLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var pwController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ShopLoginCubit(),
        child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
          listener: (context, state) {
            if(state is ShopLoginSuccessState) {
              if (state.loginModel.status) {
                CacheHelper.saveData(
                        key: 'token', value: state.loginModel.data.token)
                    .then((value) {
                  if (value) navigateAndFinish(context, ShopLayout());
                });
              } else {
                showToast(
                    text: state.loginModel.message, state: ToastStates.ERROR);
              }
            }
          },
          builder: (context, state) {
            var cubit = ShopLoginCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LOGIN",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Login To Get Our Hot Offers!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      defaultFormfield(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Please Enter Your Email Address";
                            }
                            return null;
                          },
                          textlabel: "Email Address",
                          prefix: Icons.email_outlined),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormfield(
                        controller: pwController,
                        type: TextInputType.number,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                        textlabel: "Email Address",
                        prefix: Icons.lock_outline,
                        suffix: cubit.suffix,
                        suffixpress: () {
                          cubit.changeVisibility();
                        },
                        isPassword: cubit.isPassword,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
                        builder: (context) => defaultButton(
                            text: "Login",
                            function: () {
                              if(formKey.currentState.validate())
                              cubit.getUserLoginData(email: emailController.text, password: pwController.text);
                            },
                            background: Colors.deepOrange),
                        fallback: (context)=> Center(child: CircularProgressIndicator(),),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don\'t Have An Account?"),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, ShopRegisterScreen());
                            },
                            text: "Register",
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
