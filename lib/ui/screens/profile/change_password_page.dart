import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/ui/screens/profile/widgets/text_form_profile.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class ChangePasswordPage extends StatefulWidget {

  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _newPasswordAgainController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _newPasswordAgainController = TextEditingController();

  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordAgainController.dispose();

    super.dispose();
  }

  void clear(){
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _newPasswordAgainController.clear();
  }


  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {

        if( state is LoadingUserState ){

          modalLoading(context, 'Đang cập nhật mật khẩu...');

        }else if( state is FailureUserState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);

        }else if( state is SuccessUserState ){

          Navigator.pop(context);
          modalSuccess(context, 'Cập nhật mật khẩu thành công!', onPressed: (){
            clear();
            Navigator.pop(context);
          });

        }

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'Mật khẩu', fontSize: 19),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: (){
                if( _keyForm.currentState!.validate() ){
    
                  userBloc.add( OnChangePasswordEvent(
                    _currentPasswordController.text.trim(), 
                    _newPasswordAgainController.text.trim()
                  ));
    
                }
              }, 
              child: const TextCustom(text: 'Đổi', fontSize: 15, color: ColorsCustom.primary)
            )
          ],
        ),
        body: Form(
          key: _keyForm,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
        
                    TextFormProfile(
                      controller: _currentPasswordController, 
                      labelText: 'Mật khẩu cũ',
                    ),
        
                    const SizedBox(height: 20.0),
                    TextFormProfile(
                      controller: _newPasswordController, 
                      labelText: 'Mật khẩu mới',
                      validator: MultiValidator([
                        MinLengthValidator(8, errorText: 'Ít nhất 8 ký tự'),
                        RequiredValidator(errorText: 'Vui lòng nhập mật khẩu')
                      ]),
                    ),
        
                    const SizedBox(height: 20.0),
                    TextFormProfile(
                      controller: _newPasswordAgainController, 
                      labelText: 'Nhập lại mật khẩu mới',
                      validator: MultiValidator([
                         MinLengthValidator(8, errorText: 'Ít nhất 8 ký tự'),
                        RequiredValidator(errorText: 'Vui lòng nhập mật khẩu')
                      ]),
                    ),
        
                  ],
                ),
              ),
            ) 
          ),
        )
      ),
    );
  }
}