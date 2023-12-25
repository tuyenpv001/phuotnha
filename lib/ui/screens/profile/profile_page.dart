

import 'package:flutter/material.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/models/response/response_profile.dart';
import 'package:social_media/domain/services/user_services.dart';
import 'package:social_media/ui/helpers/getBadges.dart';
import 'package:social_media/ui/screens/profile/setting_profile_page.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:social_media/ui/widgets/heading_block.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileDetail profile;
  late List<TripProfile> tripsProfile;
  late List<TripImage> tripsImage;
  late List<PostImage> postsImage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TitleAppbar(title: "Thông tin cá nhân",),
        elevation: 0,
        actions: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(14)),
              child: IconButton(
                  splashRadius: 20,
                  onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const SettingProfilePage();
                                },
                              ));      
                  },
                  icon: const Icon(Icons.settings,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: FutureBuilder(
          future: userService.getProfile(),
          builder: (context,snapshot) {
            if(snapshot.hasData) {
              profile = snapshot.data!.profile;
              tripsProfile = snapshot.data!.tripsProfile;
              tripsImage = snapshot.data!.tripsImage;
              postsImage = snapshot.data!.postsImage;
            } 
      
            return !snapshot.hasData
                  ? const Center(child: Text("Loading...."))
                  :  SingleChildScrollView(
                child: Column(
                   mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                         Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(Environment.baseUrl + profile.avatar)
                            )
                          ),
                        ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullname,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: kTitle2Style,
                              ),
                                Text(
                                profile.email,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: kSubtitleStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                       Container(
                        height: 85,
                        width: 85,
                        padding: const EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kShadowColor.withOpacity(0.1),
                              offset: const Offset(0, 12),
                              blurRadius: 18.0,
                            ),
                          ],
                        ),
                        child: Badges.getBadgesByAchiement(profile.achievement).isNotEmpty ? Image.asset(Badges.getBadgesByAchiement(profile.achievement)) :  Text("") ,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardProfile(size: size,title: "Tổng chuyến đi đã tạo",value: profile.countTripCreated,),
                      CardProfile(size: size,title: "Tổng chuyến đi đã tham gia",value: profile.countTripJoined,
                                  color: bgBox1)
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardProfile(size: size,title: "Người theo dõi",value: profile.countUserFollower,color: bgBox2),
                      CardProfile(size: size,title: "Đang theo dõi",value: profile.countUserFollowing,color: bgBox3)
                    ],
                  ), 
                  const SizedBox(height: 15,),
                  const HeadingBlock(title: "Chuyến đi",subTile: "nhìn lại những hành trình bạn đã tạo."),
                  const SizedBox(height: 5,),
                  SizedBox(
                    height: 250,

                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tripsProfile.length,
                      itemBuilder: (context, index) {
                        return _renderTripCard(tripsProfile[index]);
                      },
                    ),
                  ),
                ],
                ),
      
            );
          }
        ),
      ),
      bottomNavigationBar: const BottomNavigation(index: 6),
    );
  }

  Widget _renderTripCard(TripProfile trip) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        constraints:const BoxConstraints(
          minHeight: 150
        ),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -5),
              blurRadius: 5
            ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 5
              )
          ],
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children:
            [
            Container(
                  height: 80,
                  width: 200,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius:
                        BorderRadius.circular(10),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          Environment.baseUrl +
                              "cover_default.jpg"),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                    15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      trip.title,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w800
                      ),
                      maxLines: 2,
                    ),
                    Container(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                      NumberDetail(value: "${trip.memberJoined}",modifier: "Thành viên",),
                      NumberDetail(value: "${trip.totalComment}",modifier: "Bình luận",),
                      NumberDetail(value: "${trip.avgRate}",modifier: "Đánh giá",),
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

}

class CardProfile extends StatelessWidget {
  const CardProfile({
    super.key,
    required this.size, required this.title, required this.value, this.color, this.titleColor, this.valueColor,
  });

  final Size size;
  final String title;
  final int value;
  final Color? color;
  final Color? titleColor;
  final Color? valueColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: size.width * 0.43,
      height: 145,
      decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(14),
          color: color ?? bgBox,
          boxShadow: const [
            BoxShadow(

                color: Color.fromRGBO(241, 243, 245, 1),
                offset: Offset(0, 5),
                blurRadius: 2)
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(
            fontSize: 16.0,
            color: titleColor ?? Colors.black87,
            fontFamily:  'SF Pro Text',
            decoration: TextDecoration.none,
          ),),
          const SizedBox(height: 5,),
          Text("$value", style:  TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
                fontFamily: 'SF Pro Text',
                decoration: TextDecoration.none,
              ),)
        ]
        ),
    );
  }
}

class NumberDetail extends StatelessWidget {
  const NumberDetail({super.key, required this.value, required this.modifier});
  final String value;
  final String modifier;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(modifier,
        style:const TextStyle(fontSize: 14)),
        const SizedBox(
            width: 5,
        ),
        Text(
          value,
          style:const  TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:social_media/domain/blocs/blocs.dart';
// import 'package:social_media/data/env/env.dart';
// import 'package:social_media/domain/models/response/response_post_profile.dart';
// import 'package:social_media/domain/models/response/response_post_saved.dart';
// import 'package:social_media/domain/services/post_services.dart';
// import 'package:social_media/ui/components/animted_toggle.dart';
// import 'package:social_media/ui/helpers/helpers.dart';
// import 'package:social_media/ui/screens/profile/followers_page.dart';
// import 'package:social_media/ui/screens/profile/following_page.dart';
// import 'package:social_media/ui/screens/profile/list_photos_profile_page.dart';
// import 'package:social_media/ui/screens/profile/saved_posts_page.dart';
// import 'package:social_media/ui/themes/colors_frave.dart';
// import 'package:social_media/ui/widgets/widgets.dart';

// class ProfilePage extends StatelessWidget {

//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     final size = MediaQuery.of(context).size;
//     final userBloc = BlocProvider.of<UserBloc>(context);

//     return BlocListener<UserBloc, UserState>(
//       listener: (context, state) {
//         if( state is LoadingUserState ){
//           modalLoading(context, 'Cập nhật ảnh đại diện...');
//         }
//         if ( state is SuccessUserState ){
//           Navigator.pop(context);
//           modalSuccess(context, 'Cập nhật thành công', onPressed: () => Navigator.pop(context));
//         }
//         if ( state is FailureUserState ){
//           Navigator.pop(context);
//           errorMessageSnack(context, state.error);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: ListView(
//           children: [

//             _CoverAndProfile(size: size),

//             const SizedBox(height: 10.0),
//             const _UsernameAndDescription(),

//             const SizedBox(height: 30.0),
//             const _PostAndFollowingAndFollowers(),

//             const SizedBox(height: 30.0),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: BlocBuilder<UserBloc, UserState>(
//                 builder: (_, state) => AnimatedToggle(
//                   values: const ['Ảnh', 'Đã lưu'],
//                   onToggleCalbBack: (value) {
//                     userBloc.add( OnToggleButtonProfile(!state.isPhotos) );
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20.0),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: BlocBuilder<UserBloc, UserState>(
//                 buildWhen: (previous, current) => previous != current,
//                 builder: (_, state) =>
//                   state.isPhotos
//                   ? const _ListFotosProfile()
//                   : const _ListSaveProfile()
//               ),
//             ),

//           ],
//         ),
//         bottomNavigationBar: const BottomNavigation(index: 5)
//       ),
//     );
//   }
// }

// class _ListFotosProfile extends StatelessWidget {

//   const _ListFotosProfile({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<PostProfile>>(
//       future: postService.getPostProfiles(),
//       builder: (context, snapshot) {
//         return !snapshot.hasData
//         ? Column(
//           children: const[
//             ShimmerFrave(),
//             SizedBox(height: 10.0),
//             ShimmerFrave(),
//             SizedBox(height: 10.0),
//             ShimmerFrave(),
//           ],
//         )
//         : GridView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 2,
//               mainAxisSpacing: 2,
//               mainAxisExtent: 170
//             ),
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, i) {

//             final List<String> listImages = snapshot.data![i].images.split(',');

//             return InkWell(
//               onTap: () => Navigator.push(context, routeSlide(page: const ListPhotosProfilePage())),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(Environment.baseUrl + listImages.first)
//                   )
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     );
//   }
// }

// class _ListSaveProfile extends StatelessWidget {

//   const _ListSaveProfile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ListSavedPost>>(
//       future: postService.getListPostSavedByUser(),
//       builder: (context, snapshot)
//         => !snapshot.hasData
//         ? Column(
//             children: const [
//               ShimmerFrave(),
//               SizedBox(height: 10.0),
//               ShimmerFrave(),
//               SizedBox(height: 10.0),
//               ShimmerFrave(),
//             ],
//           )
//         : GridView.builder(
//           itemCount: snapshot.data!.length,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 2,
//               mainAxisExtent: 170
//             ),
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           itemBuilder: (context, i) {
//             final List<String> listImages = snapshot.data![i].images.split(',');
//             return InkWell(
//               onTap: () => Navigator.push(context, routeSlide(page: SavedPostsPage(savedPost: snapshot.data!))),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(Environment.baseUrl + listImages.first)
//                   )
//                 )
//               ),
//             );
//           }
//         ),
//     );
//   }
// }

// class _PostAndFollowingAndFollowers extends StatelessWidget {

//   const _PostAndFollowingAndFollowers({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         width: size.width,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     BlocBuilder<UserBloc, UserState>(
//                       builder: (_, state)
//                         => state.postsUser?.posters != null
//                         ? TextCustom(text: state.postsUser!.posters.toString(),  fontSize: 22, fontWeight: FontWeight.w500)
//                         : const TextCustom(text: '0')
//                     ),
//                     const TextCustom(text: 'Post',  fontSize: 17, color: Colors.grey,  letterSpacing: .7),
//                   ],
//                 ),
//                 InkWell(
//                   onTap: () => Navigator.push(context, routeSlide(page: const FollowingPage())),
//                   child: Column(
//                     children: [
//                       BlocBuilder<UserBloc, UserState>(
//                         builder: (_, state)
//                           => state.postsUser?.friends != null
//                           ? TextCustom(text: state.postsUser!.friends.toString(),  fontSize: 22, fontWeight: FontWeight.w500)
//                           : const TextCustom(text: '')
//                       ),
//                       const TextCustom(text: '...', fontSize: 17, color: Colors.grey,  letterSpacing: .7),
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () => Navigator.push(context, routeSlide(page: const FollowersPage())),
//                   child: Column(
//                     children: [
//                       BlocBuilder<UserBloc, UserState>(
//                         builder: (_, state)
//                           => state.postsUser?.followers != null
//                           ? TextCustom(text: state.postsUser!.followers.toString(),  fontSize: 22, fontWeight: FontWeight.w500)
//                           : const TextCustom(text: '0')
//                       ),
//                       const TextCustom(text: 'người theo dõi', fontSize: 17, color: Colors.grey, letterSpacing: .7),
//                     ],
//                   ),
//                 ),

//               ],
//             ),
//           ],
//         ),
//       );
//   }
// }

// class _UsernameAndDescription extends StatelessWidget {

//   const _UsernameAndDescription({ Key? key,}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Center(
//           child: BlocBuilder<UserBloc, UserState>(
//             builder: (_, state)
//               => ( state.user?.username != null)
//               ? TextCustom(text: state.user!.username != '' ? state.user!.username : 'Người dùng' , fontSize: 22, fontWeight: FontWeight.w500 )
//               : const CircularProgressIndicator()
//           )
//         ),
//         const SizedBox(height: 5.0),
//         Center(
//           child: BlocBuilder<UserBloc, UserState>(
//             builder: (_, state)
//               => ( state.user?.description != null)
//               ? TextCustom(
//                   text: (state.user?.description != '' ? state.user!.description : 'Miêu tả'), fontSize: 17, color: Colors.grey
//                 )
//               : const CircularProgressIndicator()
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _CoverAndProfile extends StatelessWidget {

//   const _CoverAndProfile({
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       width: size.width,
//       child: Stack(
//         children: [

//           SizedBox(
//             height: 170,
//             width: size.width,
//             child: BlocBuilder<UserBloc, UserState>(
//               builder: (_, state)
//                 => ( state.user?.cover != null && state.user?.cover != '')
//                 ? Image(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(Environment.baseUrl + state.user!.cover )
//                   )
//                 : Container(
//                   height: 170,
//                   width: size.width,
//                   color: ColorsCustom.primary.withOpacity(.7),
//                 )
//             ),
//           ),

//           Positioned(
//             bottom: 28,
//             child: Container(
//               height: 20,
//               width: size.width,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
//               ),
//             ),
//           ),

//           Positioned(
//             bottom: 0,
//             child: Container(
//               alignment: Alignment.center,
//               height: 100,
//               width: size.width,
//               child: Container(
//                 height: 100,
//                 width: 100,
//                 decoration: const BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle
//                 ),
//                 child: BlocBuilder<UserBloc, UserState>(
//                   builder: (_, state)
//                     => ( state.user?.image != null )
//                     ? InkWell(
//                         highlightColor: Colors.transparent,
//                         splashColor: Colors.transparent,
//                         onTap: () => modalSelectPicture(
//                           context: context,
//                           title: 'Cập nhập ảnh đại diện',
//                           onPressedImage: () async {

//                             Navigator.pop(context);
//                             AppPermission().permissionAccessGalleryOrCameraForProfile(await Permission.storage.request(), context, ImageSource.gallery);
//                           },
//                           onPressedPhoto: () async {

//                             Navigator.pop(context);
//                             AppPermission().permissionAccessGalleryOrCameraForProfile(await Permission.camera.request(), context, ImageSource.camera);
//                           }
//                         ),
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage( Environment.baseUrl + state.user!.image )
//                         ),
//                     )
//                     : const CircularProgressIndicator()
//                 ),
//               ),
//             ),
//           ),

//           Positioned(
//             right: 0,
//             child: IconButton(
//               onPressed: () => modalProfileSetting(context, size),
//               icon: const Icon(Icons.dashboard_customize_outlined, color: Colors.white ),
//             )
//           ),

//           Positioned(
//             right: 40,
//             child: IconButton(
//               splashRadius: 20,
//               onPressed: () => modalSelectPicture(
//                 context: context,
//                 title: 'Cập nhật ảnh bìa',
//                 onPressedImage: () async {

//                   Navigator.pop(context);
//                   AppPermission().permissionAccessGalleryOrCameraForCover(await Permission.storage.request(), context, ImageSource.gallery);

//                 },
//                 onPressedPhoto: () async {

//                   Navigator.pop(context);
//                   AppPermission().permissionAccessGalleryOrCameraForCover(await Permission.camera.request(), context, ImageSource.camera);
//                 }
//               ),
//               icon: const Icon(Icons.add_box_outlined, color: Colors.white ),
//             )
//           )

//         ],
//       ),
//     );
//   }
// }






