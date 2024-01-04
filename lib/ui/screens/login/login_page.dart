import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/ui/screens/home/home_page.dart';
import 'package:social_media/ui/screens/login/forgot_password_page.dart';
import 'package:social_media/ui/screens/login/verify_email_page.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    passwordController.clear();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        
        if( state is LoadingAuthentication ){

          modalLoading(context, 'Vui lòng chờ...');

        } else if( state is FailureAuthentication ) {

          Navigator.pop(context);

          if( state.error == 'Vui lòng kiểm tra email' ){
            Navigator.push(context, routeSlide(page: VerifyEmailPage(email: emailController.text.trim())));
          }

          errorMessageSnack(context, state.error);

        } else if( state is SuccessAuthentication ){

          userBloc.add(OnGetUserAuthenticationEvent());
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, routeSlide(page: const HomePage()), (_) => false);

        }

      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A47F5),
          title: const Text("Đăng nhập"),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body:  SingleChildScrollView(
          // shrinkWrap: true,
          child: 
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 500,
                      ),
                      // height: 500,
                      width: MediaQuery.of(context).size.width * 1,
                      transform: Matrix4.translationValues(0, -75, 0),
                      child: Image.asset(
                        'assets/asset/illustrations/illustration-14.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(-40, -170, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phượt Nha",
                            style:
                                kLargeTitleStyle.copyWith(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            "Hãy bắt đầu chia sẻ \nnhững trải nghiệm của bạn",
                            style: kHeadlineLabelStyle.copyWith(
                                color: Colors.white70),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Form(
                  key: _keyForm,
                  child: Container(
                    transform: Matrix4.translationValues(0, -250, 0),
                    child: Padding(
                      padding:const  EdgeInsets.symmetric(horizontal: 40.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Text(
                            //   "Đăng nhập",
                            //   style: kTitle1Style,
                            // ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                minHeight: 130.0, 
                              ),
                              // height: 130.0,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: kShadowColor,
                                          offset: Offset(0, 12),
                                          blurRadius: 16.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5.0,
                                            right: 16.0,
                                            left: 16.0,
                                          ),
                                    
                                          child: TextFieldCustom(
                                            icon: const Icon(
                                            Icons.email,
                                            color: Color(0xFF5488F1),
                                            size: 20.0,
                                          ),
                                            controller: emailController,
                                            hintText: 'Email',
                                            keyboardType: TextInputType.emailAddress,
                                            validator: validatedEmail,
                                          ),
                                        ),            
                                        Padding(
                                          padding:const  EdgeInsets.only(
                                            bottom: 5.0,
                                            right: 16.0,
                                            left: 16.0,
                                          ),
                                          child:   TextFieldCustom(
                                            icon:const   Icon(
                                                Icons.lock,
                                                color: Color(0xFF5488F1),
                                                size: 20.0,
                                              ),
                                            controller: passwordController,
                                            hintText: 'Mật khẩu',
                                            isPassword: true,
                                            validator: passwordValidator,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            const Divider(),
                            Btn(
                              text: 'Đăng nhập', 
                              width: size.width,
                              onPressed: (){
                                if( _keyForm.currentState!.validate() ){
                                  authBloc.add( OnLoginEvent(emailController.text.trim(), passwordController.text.trim()) );
                                }
                              },
                            ),
                             const SizedBox(height: 15.0),
                            Center(
                              child: InkWell(
                                onTap: () => Navigator.push(context, routeSlide(page: const ForgotPasswordPage())),
                                child: const TextCustom(text: 'Quên mật khẩu?')
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          // ],
        ),
        
      ),
    );
  }
}

