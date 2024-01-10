import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:social_media/data/env/env.dart';




class CallVideoScreen extends StatefulWidget {
  const CallVideoScreen({super.key,
   required this.channelId, required this.isGroupChat});
  final String channelId;
  final bool isGroupChat;


  @override
  State<CallVideoScreen> createState() => _CallVideoScreenState();
}

class _CallVideoScreenState extends State<CallVideoScreen> {
  // AgoraClient? client;
    // bool _offer = false;
  // final _remoteRender = RTCVideoRenderer();
  // final sdpController = TextEditingController();
  int? _remoteUid;
  late AgoraClient client;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: 'PhuotNha',
        // channelName: 'adjdfkdjfksdfhsdkfjsdkf',
        tokenUrl: Environment.baseUrl
        )
      );
      initAgora();
  }

  initAgora() async {
    // await [Permission.microphone, Permission.camera].request();
    await client.initialize();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
            client: client,
            layoutType: Layout.floating,
            // enableHostControls: true, // Add this to enable host controls
            ),
            // AgoraVideoViewer(
            // client: client,
            // ),
            AgoraVideoButtons(
              client: client,
              // onDisconnect: () {
                
              // },
            ),
          ],
          ),
        )
    );
  }
    
}