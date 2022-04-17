import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/shared/componnetns/components.dart';
import 'package:flutter_projects/shared/cubit/cubit.dart';
import 'package:flutter_projects/shared/cubit/state.dart';

class SettingScreen extends StatelessWidget {
var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit,MainState>(
      listener: (context,state)
      {
        if(state is UserLoginSuccessState) {}
      },
      builder: (context,state)
      {
        var model = MainCubit.get(context).UserData;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;
        nameController.text = model.data.name;
        return ConditionalBuilder(
          condition:MainCubit.get(context).UserData!=null,
          builder:(context)=> Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                      children:
                      [
                        if(state is UserUpdateLoadingState)
                          LinearProgressIndicator(),
                        SizedBox(height: 20,),
                        defaultTextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validate: (String value)
                          {
                            if(value.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                          label: 'Name',
                          hint: 'Enter your name',
                        ),
                        SizedBox(height: 10,),
                        defaultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String value)
                          {
                            if(value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          label: 'Email',
                          hint: 'Enter your Email',
                        ),
                        SizedBox(height: 10,),
                        defaultTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validate: (String value)
                          {
                            if(value.isEmpty) {
                              return "Phone is required";
                            }
                            return null;
                          },
                          label: 'Phone',
                          hint: 'Enter your Phone',
                        ),
                        SizedBox(height: 10,),
                        defaultMaterialButton(
                            function: ()
                            {
                              if(formKey.currentState.validate())
                              {
                                MainCubit.get(context).UpdateUserData(
                                  name:nameController.text,
                                  email:emailController.text,
                                  phone:phoneController.text,
                                );
                              }
                              return null;
                            },
                            text: 'Update',
                        )

                      ]

                  ),
                ),
              ),
            ),

          fallback: (context)=>Center(child: CircularProgressIndicator()),

        );
      },


    );
  }
}