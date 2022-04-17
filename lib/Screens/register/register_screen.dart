import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/Screens/home/home_screen.dart';
import 'package:flutter_projects/Screens/register/cubit/cubit.dart';
import 'package:flutter_projects/Screens/register/cubit/state.dart';
import 'package:flutter_projects/shared/componnetns/components.dart';
import 'package:flutter_projects/shared/componnetns/constants.dart';
import 'package:flutter_projects/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterState>(
        listener:(context,state)
        {
          if(state is RegisterSuccessState)
          {
            if(state.loginModel.status)
            {
              ShowToast(
                text: state.loginModel.message,
                state: ToastStates.SUCCESS,
              );
              print(state.loginModel.message);
              print(state.loginModel.data.token);

              CacheHelper.saveData(key: "token", value: state.loginModel.data.token).then((value)
              {
                token = state.loginModel.data.token;
                navigateAndFinish(context, HomeScreen());
              });
            }
            else
            {
              ShowToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
              print(state.loginModel.message);
            }
          }
        } ,
        builder:(context,state)
        {
          return Scaffold(
            appBar: AppBar(
              title: Text('Register'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                        children:
                        [
                          defaultTextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            prefix: Icons.person,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                            label: 'Name',
                            hint: 'Enter your name',
                          ),
                          SizedBox(height: 20,),
                          defaultTextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icons.email,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            label: 'Email',
                            hint: 'Enter your email',
                          ),
                          SizedBox(height: 20,),
                          defaultTextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            prefix: Icons.phone,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter phone';
                              }
                              return null;
                            },
                            label: 'Phone',
                            hint: 'Enter your phone',
                          ),
                          SizedBox(height: 20,),
                          defaultTextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefix: Icons.key,
                            suffix: RegisterCubit.get(context).suffix,
                             isPassword: RegisterCubit.get(context).isPassword,
                              suffixPressed: () {
                                RegisterCubit.get(context).ChangePassword();
                              },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            label: 'Password',
                            hint: 'Enter your password',
                          ),
                          SizedBox(height: 20,),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder:(context)=> Center(
                              child: defaultMaterialButton(
                                function: ()
                                {
                                  if (formKey.currentState.validate())
                                  {
                                    RegisterCubit.get(context).UserRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                } ,
                                text: 'Register',
                                radius: 20,
                              ),
                            ),

                            fallback: (context)=> Center(
                                child: CircularProgressIndicator()
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }
}