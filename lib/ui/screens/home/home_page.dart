import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/ui/screens/addPost/add_post_page.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/logo.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:social_media/domain/models/response/response_stories.dart';
import 'package:social_media/domain/services/story_services.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/ui/screens/Story/add_story_page.dart';
import 'package:social_media/ui/screens/Story/view_story_page.dart';
import 'package:social_media/ui/screens/comments/comments_post_page.dart';
import 'package:social_media/ui/screens/messages/list_messages_page.dart';
import 'package:social_media/ui/screens/notifications/notifications_page.dart';
import 'package:social_media/domain/models/response/response_post.dart';
import 'package:social_media/domain/services/post_services.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/ui/widgets/widgets.dart';
import 'package:social_media/domain/blocs/post/post_bloc.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if( state is LoadingSavePost || state is LoadingPost){
          modalLoadingShort(context);
        }else if ( state is FailurePost ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if ( state is SuccessPost ){
          Navigator.pop(context);
          setState((){});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Logo(),
          elevation: 0,
          actions: [
          Button(
          height: 40, 
          width: 40, 
          bg: bgGrey,
          icon: const Icon(Icons.messenger_outline, color: Colors.black,), 
          onPress: () => Navigator.push(
                      context,
                      routeSlide(page: const ListMessagesPage()))),
          Button(
          height: 40, 
          width: 40, 
          bg: bgGrey,
          icon: const Icon(Icons.notifications_none_outlined, color: Colors.black,), 
          onPress: () => Navigator.pushAndRemoveUntil(
                      context,
                      routeSlide(page: const NotificationsPage()),
                      (_) => false)),
          Button(
            height: 40,
            width: 40,
            bg: bgPrimary, 
            icon: const Icon(Icons.add), 
            onPress: () {
                Navigator.pushAndRemoveUntil(context, routeSlide(page: const AddPostPage()), (_) => false);
              },),
          ],
        ),
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              
              const _ListHistories(),
    
              const SizedBox(height: 5.0),
              FutureBuilder<List<Post>>(
                future: postService.getAllPostHome(),
                builder: (_, snapshot) {

                  if( snapshot.data != null && snapshot.data!.isEmpty){
                    return _ListWithoutPosts();
                  }

                  return !snapshot.hasData
                  ?const  Column(
                      children:  [
                        ShimmerCustom(),
                        SizedBox(height: 10.0),
                        ShimmerCustom(),
                        SizedBox(height: 10.0),
                        ShimmerCustom(),
                      ],
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, i) => _ListViewPosts(posts: snapshot.data![i]),
                    );
                  
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigation(index: 1)
      ),
    );
  }
}

class _ListHistories extends StatelessWidget {

  const _ListHistories({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      height: 90,
      width: size.width,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          BlocBuilder<UserBloc, UserState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) 
              =>  state.user != null
              ? InkWell(
                onTap: () => Navigator.push(context, routeSlide(page: const AddStoryPage())),
                child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),

                        ),
                        child: Container(
                          height: 80,
                          width: 75,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(Environment.baseUrl + state.user!.image.toString() )
                            )
                          ),
                        ),
                      ),
                      // const SizedBox(height: 5.0),
                      // TextCustom(text: state.user!.username, fontSize: 15)
                    ],
                ),
              )
              : const CircleAvatar()
          ),

          const SizedBox(width: 10.0),
          SizedBox(
            height: 90,
            width: size.width,
            child: FutureBuilder<List<StoryHome>>(
              future: storyServices.getAllStoriesHome(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                ? const ShimmerCustom()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.push(context, routeFade(page: ViewStoryPage(storyHome:  snapshot.data![i]))),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                     begin: Alignment.topCenter,
                                      colors: [
                                        Colors.pink,
                                        Colors.amber
                                      ]
                                  )
                                ),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(Environment.baseUrl + snapshot.data![i].avatar )
                                    )
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              TextCustom(text: snapshot.data![i].username, fontSize: 15)
                            ],
                          ),
                        ),
                      );
                    },
                  );
              },
            ),
          )

        ],
      ),
    );
  }
}


class _ListViewPosts extends StatelessWidget {

  final Post posts;

  const _ListViewPosts({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);

    final List<String> listImages = posts.images.split(',');
    final time =  timeago.format(posts.createdAt, locale: 'vi');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin:const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image:NetworkImage(Environment.baseUrl+ posts.avatar), fit: BoxFit.cover)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      posts.username,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  height: 25,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(0.1)),
                  child:Text(
                  posts.isLeader != 0 ? "Leader": 'Member',
                    style:const TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.more_vert)
              ],
            ),
            const SizedBox(height: 10),
            Text(posts.description, textAlign: TextAlign.end),
            const SizedBox(height: 10),
            Hero(
              tag: posts.postUid,
              child: Container(
                height: 140,
                width: double.maxFinite,
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(Environment.baseUrl+ listImages[0]), fit: BoxFit.cover)),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  child: const Icon(Icons.attachment, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: () => postBloc.add( OnLikeOrUnLikePost(posts.postUid, posts.personUid) ),
                  child: posts.isLike == 1
                  ? const Icon(Icons.favorite_rounded, color: Colors.red)
                  : const Icon(Icons.favorite_outline_rounded, color: Colors.black),
                ),
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {},
                  child: TextCustom(text: posts.countLikes.toString(), fontSize: 16, color: Colors.black)
                ),
                const SizedBox(width: 10.0),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    routeFade(page: CommentsPostPage(uidPost: posts.postUid))
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/message-icon.svg'),
                      const SizedBox(width: 5.0),
                      TextCustom(text: posts.countComment.toString(), fontSize: 16, color: Colors.black)
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => postBloc.add(OnSavePostByUser( posts.postUid )),
                  icon: posts.isSave != 0 ? 
                            const Icon(Icons.bookmark_added_rounded,size: 27, color: ColorsCustom.primary) 
                          : const Icon(Icons.bookmark_border_rounded, size: 27, color: Colors.black)
                )
               
              ],
            )
          ],
        ),
      ),
    );
  }

}


class _ListWithoutPosts extends StatelessWidget {


  final List<String> svgPosts = [
    'assets/svg/without-posts-home.svg',
    'assets/svg/without-posts-home.svg',
    'assets/svg/mobile-new-posts.svg',
  ];

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      children: List.generate(3, (index) => Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(10.0),
          height: 350,
          width: size.width,
          // color: Colors.amber,
          child: SvgPicture.asset(svgPosts[index], height: 15),
        ),
      ),
    );
  }
  
}



