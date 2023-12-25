import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/blocs/post/post_bloc.dart';
import 'package:social_media/domain/models/response/response_post_saved.dart';
import 'package:social_media/domain/services/post_services.dart';
import 'package:social_media/ui/helpers/error_message.dart';
import 'package:social_media/ui/helpers/modal_loading_short.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:intl/intl.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SaveState();
}

class _SaveState extends State<SavePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc,PostState>(
      listener: (context, state) {
       if (state is LoadingSavePost || state is LoadingPost) {
          modalLoadingShort(context);
        } else if (state is FailurePost) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessPost) {
          Navigator.pop(context);
          setState(() {});
        }
    },
    child: Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TitleAppbar(title: "Danh sách đã lưu"),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FutureBuilder(
                future: postService.getListPostSavedByUser(),
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!.isEmpty) {
                    return  const Center(child:
                      Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Không có bài viết nào được lưu."),),
                    );
                  }
                  return !snapshot.hasData
                      ? const Text("Không có dữ liệu")
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, i) =>
                              SaveItem(post: snapshot.data![i]),
                        );
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
  }
}

class SaveItem extends StatelessWidget {
  final ListSavedPost post;
  const SaveItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
     final postBloc = BlocProvider.of<PostBloc>(context);
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 15, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(241, 243, 245, 1),
                offset: Offset(0, 5),
                blurRadius: 2)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: Environment.baseUrl + post.images,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(post.fullname,
                          style: kHeadlineLabelStyle.copyWith(
                              overflow: TextOverflow.ellipsis)),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
                onPressed: () => postBloc.add(OnUnSavePostByUser(post.postSaveUid)),
                icon: const Icon(Icons.bookmark_remove_outlined,
                    size: 27, color: ColorsCustom.primary)),
          )
        ],
      ),
    );
  }
}

