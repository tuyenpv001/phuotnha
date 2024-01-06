import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/blocs/post/post_bloc.dart';
import 'package:social_media/domain/models/response/response_post.dart';
import 'package:social_media/domain/services/post_services.dart';
import 'package:social_media/domain/services/user_services.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/domain/models/response/response_search.dart';
import 'package:social_media/ui/screens/profile/profile_another_user_page.dart';
import 'package:social_media/ui/widgets/heading_block.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
          // BlocBuilder<PostBloc, PostState>(
          //   buildWhen: (previous, current) => previous != current,
          //   builder: (context, state)
          //     => !state.isSearchFriend
          //     ? FutureBuilder<List<Post>>(
          //         future: postService.getAllPostsForSearch(),
          //         builder: (context, snapshot) {
          //           return !snapshot.hasData
          //           ? const _ShimerSearch()
          //           : _GridPostSearch(posts: snapshot.data!);
          //         },
          //       )
          //     : streamSearchUser()
          // )
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 55),
            child: Column(
              children: [
                streamSearchUser(),
                streamSearchTrips(),
                streamSearchPosts(),
            ],)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              height: 45,
              width: size.width,
              decoration: BoxDecoration(
                
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.0)),
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) => TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      postBloc.add(OnIsSearchPostEvent(true));
                      // userService.searchUsers(value);
                      userService.searchByKeyword(value);
                    } else {
                      postBloc.add(OnIsSearchPostEvent(false));
                    }
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tìm kiếm',
                      hintStyle: GoogleFonts.roboto(fontSize: 17),
                      suffixIcon: const Icon(Icons.search_rounded)),
                ),
              ),
            ),
          ),
        ],
        ),
      ),

      bottomNavigationBar: const BottomNavigation(index: 4),
    );
  }

  Widget streamSearchUser() {
    return StreamBuilder<List<DataByKeyWord>>(
      stream: userService.searchUser,
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.data == null) return Container();

        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        if (snapshot.data!.isEmpty) {
          return ListTile(
            title: TextCustom(
                text: 'Không có kết quả cho: ${_searchController.text}'),
          );
        }

        return _ListUsers(listUser: snapshot.data!);
      },
    );
  }
  Widget streamSearchTrips() {
    return StreamBuilder<List<DataByKeyWord>>(
      stream: userService.searchTrips,
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 10,bottom: 5),
              child: HeadingBlock(
                title: 'Chuyến đi',
                subTile: 'chuyến đi có cùng từ khóa',
              ),
            ),
            _ListPost(list: snapshot.data!),
          ],
        );
      },
    );
  }
  Widget streamSearchPosts() {
    return StreamBuilder<List<DataByKeyWord>>(
      stream: userService.searchPosts,
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 10,bottom: 5),
              child: HeadingBlock(
                title: 'Bài viết',
                subTile: 'bài viết có cùng từ khóa',
              ),
            ),
            _ListPost(list: snapshot.data!),
          ],
        );
      },
    );
  }


}

class _ListUsers extends StatelessWidget {
  final List<DataByKeyWord> listUser;

  const _ListUsers({
    Key? key,
    required this.listUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listUser.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                routeSlide(
                    page: ProfileAnotherUserPage(idUser: listUser[i].uid)));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 5.0),
              height: 70,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(Environment.baseUrl + listUser[i].image),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextCustom(text: listUser[i].name),
                      TextCustom(text: listUser[i].name, color: Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ListPost extends StatelessWidget {
  final List<DataByKeyWord> list;

  const _ListPost({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                routeSlide(
                    page: ProfileAnotherUserPage(idUser: list[i].uid)));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 5.0),
              height: 250,
              child: Column(
                children: [
                  TextCustom(text: list[i].name, color: Colors.grey),
                  const SizedBox(width: 5.0),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(Environment.baseUrl + list[i].image),
                      ),
                    ),
                  )
  
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GridPostSearch extends StatelessWidget {
  final List<Post> posts;

  const _GridPostSearch({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            mainAxisExtent: 170),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, i) {
          final List<String> listImages = posts[i].images.split(',');

          return GestureDetector(
            onTap: () {},
            onLongPress: () => modalShowPost(context, post: posts[i]),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            Environment.baseUrl + listImages.first)))),
          );
        });
  }
}

class _ShimerSearch extends StatelessWidget {
  const _ShimerSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerCustom(),
        SizedBox(height: 10.0),
        ShimmerCustom(),
        SizedBox(height: 10.0),
        ShimmerCustom(),
      ],
    );
  }
}
