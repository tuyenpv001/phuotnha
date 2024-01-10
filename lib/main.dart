// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/domain/blocs/call/call_bloc.dart';
import 'package:social_media/domain/blocs/post/post_bloc.dart';
import 'package:social_media/ui/screens/intro/checking_login_page.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  // AwesomeNotifications().initialize(
  //     // set the icon to null if you want to use the default app icon
  //     'resource://drawable/res_app_icon',
  //     [
  //       NotificationChannel(
  //           channelGroupKey: 'basic_channel_group',
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           defaultColor: Color(0xFF9D50DD),
  //           ledColor: Colors.white)
  //     ],
  //     // Channel groups are only visual and are not required
  //     channelGroups: [
  //       NotificationChannelGroup(
  //           channelGroupKey: 'basic_channel_group',
  //           channelGroupName: 'Basic group')
  //     ],
  //     debug: true);
  timeago.setLocaleMessages('vi', timeago.ViMessages());
  runApp(const MyApp());}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark )
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add( OnCheckingLoginEvent())),
        BlocProvider(create: (_) => UserBloc()),
        BlocProvider(create: (_) => PostBloc()),
        BlocProvider(create: (_) => TripBloc()),
        BlocProvider(create: (_) => ChatTripBloc()),
        BlocProvider(create: (_) => TripScheduleBloc()),
        BlocProvider(create: (_) => StoryBloc()),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => CallBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Phượt Nha',
        home: CheckingLoginPage(),
      ),
    );
  }
}