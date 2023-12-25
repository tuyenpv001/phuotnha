import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/ui/screens/profile/widgets/item_profile.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class PrivacyProgilePage extends StatelessWidget {

  const PrivacyProgilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {

        if( state is LoadingChangeAccount ){
          modalLoading(context, 'Đang thay đổi quyền riêng tư...');
        }else if( state is FailureUserState ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if ( state is SuccessUserState ){
          Navigator.pop(context);
          modalSuccess(context, 'Thay đổi quyền riêng tư thành công', onPressed: () => Navigator.pop(context));
        }

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'Quyền riêng tư', fontSize: 19, fontWeight: FontWeight.w500 ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black)
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            physics: const BouncingScrollPhysics(),
            children: [
              
              const TextCustom(text: 'Bảo mật tài khoản', fontSize: 16, fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  child: BlocBuilder<UserBloc, UserState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (_, state) => Row(
                      children: [
                        const Icon(Icons.lock_outlined),
                        const SizedBox(width: 10),
                        const TextCustom(text: 'Tài khoản cá nhân', fontSize: 17 ),
                        const Spacer(),
                        ( state.user != null && state.user!.isPrivate == 1)
                          ? const Icon(Icons.radio_button_checked_rounded, color: ColorsCustom.primary)
                          : const Icon(Icons.radio_button_unchecked_rounded),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  onTap: () => modalPrivacyProfile(context),
                ),
              ),
    
              const Divider(),
              const SizedBox(height: 10.0),
              const TextCustom(text: 'Tương tác', fontSize: 16, fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              ItemProfile(
                text: 'Bình luận', 
                icon: Icons.chat_bubble_outline_rounded, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Bài viết', 
                icon: Icons.add_box_outlined, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Email', 
                icon: Icons.alternate_email_sharp, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Lịch sử', 
                icon: Icons.control_point_duplicate_rounded, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Tin nhắn', 
                icon: Icons.send_rounded, 
                onPressed: (){}
              ),
    
              const Divider(),
              const SizedBox(height: 10.0),
    
              const TextCustom(text: 'Kết nối', fontSize: 16, fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
    
              ItemProfile(
                text: 'Hạn chế tài khoản', 
                icon: Icons.no_accounts_outlined, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Chặn tài khoản', 
                icon: Icons.highlight_off_rounded, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Ẩn thông báo', 
                icon: Icons.notifications_off_outlined, 
                onPressed: (){}
              ),
              ItemProfile(
                text: 'Tài khoản theo dõi', 
                icon: Icons.people_alt_outlined, 
                onPressed: (){}
              ),
    
            ],
          ),
        ),
      ),
    );
  }
}