import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const TextCustom(
                    text: 'Quên mật khẩu', 
                    letterSpacing: 1.5, 
                    fontWeight: FontWeight.w500, 
                    fontSize: 25, 
                    color: ColorsCustom.secundary
                ),
          
                const SizedBox(height: 10.0),
                const TextCustom(
                    text: 'Vui lòng nhập email để reset password', 
                    fontSize: 17,
                    letterSpacing: 1.0,
                    maxLines: 2,
                ),
          
                SizedBox(
                  height: 300,
                  width: size.width,
                  child: SvgPicture.asset('assets/svg/undraw_forgot_password.svg'),
                ),
          
                const SizedBox(height: 10.0),
                TextFieldCustom(
                  icon: const Icon(
                    Icons.email,
                    color: Color(0xFF5488F1),
                    size: 20.0,
                  ),
                  controller: emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
          
                const SizedBox(height: 40.0),
                Btn(
                  text: 'Tiếp tục', 
                  width: size.width,
                  onPressed: (){},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}