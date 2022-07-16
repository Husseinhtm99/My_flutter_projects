// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/home/cubit/cubit.dart';
import 'package:flutter_projects/home/cubit/state.dart';
import 'package:flutter_projects/models/user_model.dart';
import 'package:flutter_projects/modules/chat_details/chat_details_screen.dart';
import 'package:flutter_projects/shared/componnetns/components.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userModel = SocialCubit.get(context).userModel;
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(SocialCubit.get(context).users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit.get(context).users.length,
          ),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            ChatDetailsScreen(
              userModel: model,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(model.image),
                radius: 30.0,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                model.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: Colors.black),
              )
            ],
          ),
        ),
      );
}
