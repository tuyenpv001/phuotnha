import 'package:flutter/material.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/ui/screens/login/login_page.dart';
import 'package:social_media/ui/screens/login/register_page.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/logo.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class StartedPage extends StatelessWidget {

  const StartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 55,
              width: size.width,
              child: const Logo()),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                width: size.width,
                child: Image.asset('assets/asset/illustrations/started_img.png'),
              ),
            ),

            const TextCustom(
              text: 'Xin chào !', 
              letterSpacing: 2.0, 
              color: ColorsCustom.secundary,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),

            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextCustom(
                text: 'Chào mừng bạn đến với Phượt Nha! Nơi chia sẻ những trải nghiệm và cùng nhau tạo nên những khoảnh khắc tuyệt vời trên những cung đường',
                textAlign: TextAlign.center,
                maxLines: 2,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  // border: Border.all(color: Color(0xFF4A47F5), width: 1.5),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF73A0F4),
                      Color(0xFF4A47F5),
                    ],
                  ),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    // backgroundColor: ColorsCustom.secundary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  child: const TextCustom(text: 'Đăng nhập', color: Colors.white, fontSize: 20),
                  onPressed: () => Navigator.push(context, routeSlide(page: const LoginPage())), 
                ),
              ),
            ),

            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color:const Color(0xFF4A47F5), width: 1.5),
                ),
                child: TextButton(
                  child: const TextCustom(text: 'Đăng Ký', fontSize: 20,),
                  onPressed: () => Navigator.push(context, routeSlide(page: const RegisterPage())), 
                ),
              ),
            ),
            const SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }
}