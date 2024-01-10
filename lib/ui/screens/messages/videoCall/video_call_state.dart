import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/domain/blocs/call/call_bloc.dart';
import 'package:social_media/ui/screens/messages/videoCall/call_screen.dart';
import 'package:social_media/ui/themes/button.dart';

class Caller {
  final String id;
  final String name;
  final String avatar;

  Caller({required this.id, required this.name, required this.avatar});
}

class Channel {
  final String channelId;
  final String channelName;

  Channel({required this.channelId, required this.channelName});
}

class CallVideoPage extends StatefulWidget {
  const CallVideoPage(
      {super.key,  this.callerCalling,  this.receiverCalling,  this.chanel});
  final Caller? callerCalling;
  final Caller? receiverCalling;
  final Channel? chanel;

  @override
  State<CallVideoPage> createState() => _CallVideoPageState();
}



class _CallVideoPageState extends State<CallVideoPage> {
  late CallBloc callBloc;
  CallState? callState;
  @override
  void initState() {
    callBloc = BlocProvider.of<CallBloc>(context);
    callState = callBloc.state;
    callBloc.initSocketChat();

    super.initState();
  }

  @override
  void dispose() {
    callBloc.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<UserBloc>(context).state.user;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            //Bg
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.low,
                    colorFilter:
                        ColorFilter.mode(Colors.black45, BlendMode.darken),
                    fit: BoxFit.fill,
                    image: AssetImage('assets/asset/images/profile.jpg')),
              ),
            ),
             BackdropFilter(
                 // child: Image.asset('assets/asset/images/profile.jpg'),
                 child: const SizedBox(height: 100, width: 100),
                 filter: ImageFilter.blur(
                   sigmaX: 5.0,
                   sigmaY: 5.0,
                 )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    user!.uid == widget.callerCalling!.id
                        ? "Đang gọi..."
                        : 'Cuộc gọi từ...',
                    style: const TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white30),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/asset/images/profile.jpg')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(widget.receiverCalling!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Button(
                          onPress: () {
                            Navigator.pop(context);
                          },
                          height: 50,
                          width: 50,
                          bg: ColorTheme.bgGreyBold,
                          icon: const Icon(
                            Icons.call_end_outlined,
                            color: Colors.redAccent,
                          )),
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     child: Button(
                    //         onPress: () {

                    //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    //             return CallVideoScreen(channelId: 'dkjsldfjksdlkfjsdlkfjsdlkf', isGroupChat: false);
                    //           },));
                    //           // Navigator.push(context, MaterialPageRoute(
                    //           //   builder: (context) {
                    //           //     return const  VideoCallTest();
                    //           //   },
                    //           // ));
                    //         },
                    //         height: 50,
                    //         width: 50,
                    //         bg: ColorTheme.bgGreyBold,
                    //         icon: const Icon(
                    //           Icons.call_outlined,
                    //           color: Colors.green,
                    //         ))),

                    user.uid == widget.receiverCalling!.id  ?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Button(
                        onPress: () {
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return CallVideoScreen(channelId: widget.chanel!.channelId, isGroupChat: false);
                              },));
                        },
                        height: 50,
                        width: 50,
                        bg: ColorTheme.bgGreyBold,
                        icon: Icon(Icons.call_outlined, color: Colors.green,)),
                    ) :  SizedBox(),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
