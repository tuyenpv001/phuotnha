import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:social_media/domain/blocs/call/call_bloc.dart';
import 'package:social_media/domain/blocs/user/user_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sdp_transform/sdp_transform.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/ui/themes/button.dart';

class CallScreenRTC extends StatefulWidget {
  const CallScreenRTC({super.key, required this.callerId, required this.receiverId});
  final String callerId;
  final String receiverId;
  @override
  State<CallScreenRTC> createState() => _CallScreenRTCState();
}

class _CallScreenRTCState extends State<CallScreenRTC> {
  CallBloc callBloc = CallBloc();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  double _containerWidth = 100;
  double _containerHeight = 200;
  double _containerRight = 0;
  double _containerTop = 0;

    @override
  void initState() {
    callBloc.initSocketChat();
    super.initState();
    initRenderers();
    initStreams();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    callBloc.disconnectSocket();
    callBloc.disconnectSocketVideoCallPersonal();
    super.dispose();
  }

   initRenderers() async {
    // await Permission.camera.request();
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  initStreams() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    });
    setState(() {
    _localRenderer.srcObject = _localStream;

    });
  }
  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
        {"url": "stun:stun2.l.google.com:19302"},
      ]
    };
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferTOReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUderMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    // pc.addStream(_localStream!);
    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(jsonEncode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex
        }));

      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ${stream.id}');
      // setState(() {
      _remoteRenderer.srcObject = stream;
      // });
    };

    return pc;
  }
  _getUderMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'}
    };

    MediaStream stream = await navigator.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = stream;
    _localRenderer.muted = true;
    return stream;
  }
   void stopWebRTC() {
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<UserBloc>(context).state;
    var size = MediaQuery.of(context).size;
    return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: Stack(
         alignment: Alignment.topRight,
        children: [
          !_remoteRenderer.renderVideo ?
            Container(
            width: size.width,
            height: size.height,
            alignment: Alignment.center,
            color: Colors.black87,
            child: const Text("Đang kết nối....", style: TextStyle(color: Colors.white)),)
            : SizedBox(
              key:const  Key('remote'),
            width: size.width,
            height: size.height,
            child: RTCVideoView(_remoteRenderer),),

           Positioned(
            right: _containerRight,
            top: _containerTop,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _containerRight -= details.delta.dx;
                  _containerTop += details.delta.dy;
                });
              },
              child: Container(
                 key: const Key('local'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:const [
                    BoxShadow(
                      color: Colors.white60,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    )
                  ]
                ),
                width: 150,
                height: 200,
                child: RTCVideoView(
                  _localRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),
          Positioned(
             bottom: 10,
             left: 50,
             right: 50,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Row(
                children: [
                  Button(
                    onPress: () {
                      callBloc.add(OnCancelVideoCallEvent(false));
                      stopWebRTC();
                      Navigator.pop(context);
                    },
                    height: 60,
                    width: 60,
                    bg: ColorTheme.bgDanger,
                    icon: const Icon(Icons.call_end_outlined,
                    color: Colors.white,)),
                  Button(
                    onPress: () async {
                      await _getOffer();
                    },
                    height: 60,
                    width: 60,
                    bg: Colors.green,
                    icon: const Icon(Icons.call_made_outlined,
                    color: Colors.white,)),
                   Container(
                    child:BlocBuilder<CallBloc, CallState>(
                    builder: (_, state) {

                      print('======================================');
                      print(state.isDisabled);
                      print(state.receiverId);
                      print(state.callerId);
                      print(state.sessionOffer);
                      print(state.sessionAnswer);
                      print('======================================');
                      if(state.receiverId == user.user!.uid) return Text("Offer");
                      return Button(
                        onPress: () async {
                           dynamic session = await jsonDecode('${state.sessionOffer}');
                          String sdp = write(session, null);
                          RTCSessionDescription description =
                              RTCSessionDescription(sdp, state.isOffer ? 'answer' : 'offer');
                          print(description.toMap());
                          await _peerConnection!.setRemoteDescription(description);

                          RTCSessionDescription descriptionAnswaer =
                              await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

                          var sessionAnswer = parse(descriptionAnswaer.sdp as String);
                          print(jsonEncode(sessionAnswer));
                          callBloc.add(OnCallVideoRTCEvent(state.sessionOffer as String, jsonEncode(sessionAnswer), '', state.callerId as String, state.receiverId as String, true));
                          _peerConnection!.setLocalDescription(descriptionAnswaer);
                          setState(() {
                            
                          });
                        },
                        height: 60, 
                        width: 60, 
                        bg: Colors.green, 
                        icon:const Icon(Icons.call_received_outlined));
                    },
                  ),
                   ) 
                ],
              ),
            ),
          )
        ],
      ),
    ),
    );
  }

  Future<void> _getOffer() async {
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp as String);

    callBloc.add(OnCallVideoRTCEvent(jsonEncode(session), '', '',widget.callerId , widget.receiverId, true));

    _peerConnection!.setLocalDescription(description);
  }

  //   _getAnswer(String sessionOffer, bool isOffer) async {

  //   dynamic session = await jsonDecode('$sessionOffer');
  //   String sdp = write(session, null);
  //   RTCSessionDescription description =
  //       RTCSessionDescription(sdp, isOffer ? 'answer' : 'offer');
  //   print(description.toMap());
  //   await _peerConnection!.setRemoteDescription(description);

  //   RTCSessionDescription descriptionAnswaer =
  //       await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

  //   var sessionAnswer = parse(descriptionAnswaer.sdp as String);
  //   print(jsonEncode(sessionAnswer));
  //   callBloc.add(OnCallVideoRTCEvent(strOffer, strAnswer, candidateTemp, callId, receiId, offer))
  //   _peerConnection!.setLocalDescription(descriptionAnswaer);
  // }
}

// /**
//  * FLOW
//  * 1. Offer => String offer
//  * 2. Accept => NHận string offer => Set Remote => Anwser
//  *    Sẽ có được 1 String answer và các string candiate
//  * 3. Offer => String answer => Set Remote
//  *    Lấy 1 trong bất kỳ các candiate của answer và set candiate
//  * 4.
//  * 5.
//  */
