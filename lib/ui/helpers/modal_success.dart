import 'package:flutter/material.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';

void modalSuccess(BuildContext context, String text, {required VoidCallback onPressed}){

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (context) 
      => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
               const Row(
                  children: [
                    TextCustom(text: 'Phượt ', color: ColorsCustom.primary, fontWeight: FontWeight.w500 ),
                    TextCustom(text: 'nha', fontWeight: FontWeight.w500),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10.0),
                Container(
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      colors: [
                        Colors.white,
                        ColorsCustom.primary
                      ]
                    )
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsCustom.primary
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 38),
                  ),                  
                ),
                const SizedBox(height: 35.0),
                TextCustom(text: text, fontSize: 17, fontWeight: FontWeight.w400 ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: onPressed,
                  child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: 150,
                    decoration: BoxDecoration(
                      color: ColorsCustom.primary,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: const TextCustom(text: 'OK', color: Colors.white, fontSize: 17 ),
                  ),
                )
              ],
            ),
          ),
      ),
  );

}