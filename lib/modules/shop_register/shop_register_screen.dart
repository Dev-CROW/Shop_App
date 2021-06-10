import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_home_layout.dart';
import 'package:shop_app/modules/shop_login/shoplogin_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var pwController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.registerModel.status) {
              CacheHelper.saveData(
                  key: 'token', value: state.registerModel.data.token)
                  .then((value) {
                if (value) navigateAndFinish(context, ShopLayout());
              });
            } else
              showToast(
                  text: state.registerModel.message,
                  state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var cubit = ShopRegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Register Now",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        defaultFormfield(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty)
                                return 'Please Fill this Field';
                              return null;
                            },
                            textlabel: 'Email Address',
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultFormfield(
                          controller: pwController,
                          type: TextInputType.visiblePassword,
                          validate: (String value) {
                            if (value.isEmpty)
                              return 'Please Fill this Field';
                            return null;
                          },
                          textlabel: 'Password',
                          prefix: Icons.lock_outline,
                          isPassword: cubit.isPassword,
                          suffix: cubit.suffix,
                          suffixpress: () {
                            cubit.changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: defaultFormfield(
                                stylelabel: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                                controller: nameController,
                                type: TextInputType.name,
                                validate: (String value) {
                                  if (value.isEmpty)
                                    return 'Please Fill this Field';
                                  return null;
                                },
                                textlabel: 'Name',
                                prefix: Icons.person_outline,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: defaultFormfield(
                                  stylelabel: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold),
                                  controller: phoneController,
                                  type: TextInputType.phone,
                                  validate: (String value) {
                                    if (value.isEmpty)
                                      return 'Please Fill this Field';
                                    return null;
                                  },
                                  textlabel: 'Phone Number',
                                  prefix: Icons.phone),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) =>
                              defaultButton(
                                  text: 'Register',
                                  function: () {
                                    if (formKey.currentState.validate()) {
                                      cubit.userRegister(
                                          email: emailController.text,
                                          password: pwController.text,
                                          phone: phoneController.text,
                                          name: nameController.text);
                                    }
                                  },
                                  background: Colors.deepOrange),
                          fallback: (context) =>
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already Have Account?"),
                            defaultTextButton(
                                text: "Login Now",
                                function: () {
                                  navigateAndFinish(
                                      context, ShopLoginScreen());
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
