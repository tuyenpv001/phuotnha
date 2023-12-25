import 'package:flutter/material.dart';
import 'package:social_media/ui/helpers/modal_profile_settings.dart';

modalMenuOtherProfile(BuildContext context, Size size) {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: Colors.white,
    builder: (context) => Container(
      height: size.height * .48,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50.0)
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Item(
              icon: Icons.report,
              text: 'Báo cáo...',
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.block,
              text: 'Chặn',
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.remove_circle_outline_rounded,
              text: 'Hạn chế',
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.visibility_off_outlined,
              text: 'Chỉ mình tôi',
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.copy_all_rounded,
              text: 'Sao chép liên kết',
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.send,
              text: 'Gửi',
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.share_outlined,
              text: 'Chia sẻ',
              size: size,
              onPressed: (){},
            ),
          ],
        ),
      ),
    ),
  );

}
