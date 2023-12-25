import 'package:flutter/material.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class ThemeProfilePage extends StatelessWidget {

  const ThemeProfilePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TextCustom(text: 'Thay đổi chủ đề', fontWeight: FontWeight.w500 ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:const  SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  TextCustom(text: 'Sáng'),
                  Icon(Icons.radio_button_checked, color: ColorsCustom.primary)
                ],
              ),
               SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  TextCustom(text: 'Tối'),
                  Icon(Icons.radio_button_off_rounded )
                ],
              ),
               SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  TextCustom(text: 'Mặc định'),
                  Icon(Icons.radio_button_off_rounded )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}