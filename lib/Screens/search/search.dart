import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/Screens/search/cubit/cubit.dart';
import 'package:flutter_projects/Screens/search/cubit/state.dart';
import 'package:flutter_projects/cubit/cubit.dart';
import 'package:flutter_projects/model/search/search_model.dart';

import 'package:flutter_projects/shared/componnetns/components.dart';
import 'package:flutter_projects/shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> SearchCubit(),
      child:BlocConsumer<SearchCubit,SearchState>(
        listener: (context, state){},
        builder: (context, state)
        {
          return  Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    defaultTextFormField(
                      focusNode: FocusNode(),
                      controller: SearchCubit.get(context).SearchController,
                      keyboardType: TextInputType.text,
                      validate: (String value)
                      {
                        if(value.isEmpty)
                        {
                          return 'Enter Text to get Search';
                        }return null;
                      },
                      onFieldSubmitted: ( text)
                      {
                        SearchCubit.get(context).getSearch(text: text);
                      },
                      label: 'Search',
                      prefix: Icons.search,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if(state is SearchLoadingStates)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 20.0,
                    ),
                    if(state is SearchSuccessStates)
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => BuildListProduct(SearchCubit.get(context).searchModel.data.products[index],context) ,
                          separatorBuilder: (context , index) => myDivider(),
                          itemCount: SearchCubit.get(context).searchModel.data.total,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget BuildListProduct (SearchProductModel model , context )=>  Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        children:
        [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Image(
                image: NetworkImage (model.image,),
                width: 120.0,
                height: 120.0,
              ),

            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1.5),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price.round()}',
                      style: TextStyle(
                        color: DColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),

                    Spacer(),
                    CircleAvatar(
                      backgroundColor: MainCubit.get(context).favorites[model.id] ? Colors.red : Colors.grey[300],
                      child: IconButton(
                        onPressed: ()
                        {
                          MainCubit.get(context).changeFavorites(model.id);
                        },
                        icon: Icon(
                          Icons.star_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

}