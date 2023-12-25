import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_top_panel/sliding_top_panel.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/screens/messages/widgets/chat_message.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';


class ChatMessagesTripPage extends StatefulWidget {

  final String tripUid;
  final String title;

  const ChatMessagesTripPage({
    Key? key,
     required this.tripUid,
     required this.title
  }) : super(key: key);

  @override
  State<ChatMessagesTripPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesTripPage> with TickerProviderStateMixin{
  late  UserState userBloc;
  late ChatTripBloc chatTripBloc;
  late TripScheduleBloc tripScheduleBloc;
  late TextEditingController _messageController;
  final _focusNode = FocusNode();
  final ValueNotifier<bool> _isPanelVisible = ValueNotifier(false);
  final SlidingPanelTopController _controller = SlidingPanelTopController();
  late List<TripMemberDetail> members;
  List<ChatMessage> chatMessage = [];

  @override
  void initState() {
    super.initState();
   _controller.addListener(listenerController);
    chatTripBloc = BlocProvider.of<ChatTripBloc>(context);
    tripScheduleBloc = BlocProvider.of<TripScheduleBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context).state;
    chatTripBloc.initSocketChat();
    _historyMessages();

    _messageController = TextEditingController();
  }
   void listenerController() {
    _isPanelVisible.value = _controller.isPanelOpen;
  }

  @override
  void dispose() {
    _controller.removeListener(listenerController);
    _controller.dispose();
    _messageController.clear();
    _messageController.dispose();
    for (ChatMessage message in chatMessage) {
      message.animationController.dispose();
    }

    chatTripBloc.disconnectSocket();
    chatTripBloc.disconnectSocketMessagePersonal();
    super.dispose();
  }


  _historyMessages() async {

    // final List<ListMessage> list = await chatServices.listMessagesByUser(widget.uidUserTarget);

    // final history = list.map((m) => ChatMessage(
    //   uidUser: m.sourceUid,
    //   message: m.message,
    //   time: m.createdAt,
    //   animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 350))..forward()
    // ));

    // setState(() =>  chatMessage.insertAll(0, history));

  }


  _handleSubmit(String text){

    _messageController.clear();
    _focusNode.requestFocus();
    final userBloc = BlocProvider.of<UserBloc>(context).state;

    if( userBloc.user != null ){

      final chat = ChatMessage(
        uidUser: userBloc.user!.uid, 
        message: text,
        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 350)),
      );
      
      chatMessage.insert(0, chat);
      chat.animationController.forward();

      setState(() {});

      chatTripBloc.add( OnEmitMessageTripEvent(userBloc.user!.uid, widget.tripUid, text) );

      chatTripBloc.add( OnIsWrittingTripEvent(false) );

    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<TripScheduleBloc, TripScheduleState>(
      listener: (context, state) {
         if (state is SuccessTripSchedule) {
          setState(() {});
        }
      },
      child: 
      Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(text: widget.title, fontWeight: FontWeight.w500, fontSize: 21),
              ],
            ),
          ],
        ),
        elevation: 0,
        leading: IconButton(
          splashRadius: 20,
          onPressed: (){
            _controller.removeListener(listenerController);
            _controller.dispose();
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87)
        ),
        actions: [
          Button(height:40 
          , width: 40, bg: bgGrey, icon: const Icon(Icons.close, color: Colors.black), onPress: () { Navigator.pop(context); })
        ],
      ),
      body:  SlidingTopPanel(
      // maxHeight: 100,
      decorationPanel: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      controller: _controller,
      header: Container(
        color: Colors.white,
        child: ListTile(
          title: const Text("Tất cả thành viên"),
          trailing: _buildArrowIconHeader(),
          onTap: _controller.toggle,
        ),
      ),
      panel: (_) => _buildListPanel(),
      body: Column(
      children: [
        Flexible(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (_, state) {
      
              if (state.message != null) {
      
                final chatListen = ChatMessage(
                  uidUser: state.uidSource!, 
                  message: state.message!,
                  animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 350)),
                );
      
                chatMessage.insert(0, chatListen);
                chatListen.animationController.forward();
              }
      
              return ListView.builder(
                reverse: true,
                itemCount: chatMessage.length,
                itemBuilder: (_, i) => chatMessage[i],
              );
            },
          )
        ),
        Container(
          height: 1,
          color: Colors.grey[200],
        ),
        _textMessage()
      ],
        ),
        ),
      ),
    );


  }

  Widget _buildListPanel() => FutureBuilder(
    future: tripService.getMemberTripById(widget.tripUid),
    builder: (context, snapshot) {
      if(snapshot.hasData) {
        members = snapshot.data!.tripMembers;
      }
      return !snapshot.hasData ?const Center(child: Text("loading...")) :
       ListView.builder(
        itemCount: members.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(Environment.baseUrl + members[index].avatar),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(members[index].fullname),
                    ],
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   border: Border.all(
                    color: bgGrey,
                    width: 1
                   )
                ),
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  value: members[index].userRole,
                  underline:const SizedBox(),
                  items: const [
                  DropdownMenuItem(
                    value: 'member',
                    child: Text("Thành viên"),
                    
                    ),
                  DropdownMenuItem(
                    value: 'pho_nhom',
                    child: Text("Phó nhóm"),
                    
                    ),
                  DropdownMenuItem(
                    value: 'thu_quy',
                    child: Text("Thủ quỹ"),
                    ),
                  DropdownMenuItem(
                    value: 'chot_doan',
                    child: Text("Chốt đoàn"),
                    ),
                  ],
                 onChanged: (value) {
                  if( userBloc.user!.uid == members[index].tripLeader) {
                    tripScheduleBloc.add(OnAddRoleTrip(uid: members[index].tripMemberUid, role: value.toString(), tripUid: members[index].tripUid));
                    // setState(() {});
                  }
                  
                },),
              )
            ],
          ),
        )
      );
    },
   
   
  );
  
  Widget _buildArrowIconHeader() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPanelVisible,
      builder: (BuildContext _, bool isVisible, Widget? __) {
        return Icon(
          isVisible
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: Colors.black45,
        );
      },
    );
  }

  Widget _textMessage(){

    final chatTripBloc = BlocProvider.of<ChatTripBloc>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Flexible(
            child: BlocBuilder<ChatTripBloc, ChatTripState>(
              builder: (_, state) => TextField(
                controller: _messageController,
                focusNode: _focusNode,
                onChanged: (value) {
                  if( value.isNotEmpty ){
                    chatTripBloc.add( OnIsWrittingTripEvent(true) );
                  }else{
                    chatTripBloc.add( OnIsWrittingTripEvent(false) );
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Viết tin nhắn',
                  hintStyle: GoogleFonts.roboto(fontSize: 17)
                ),
              ),
            )
          ),
          BlocBuilder<ChatTripBloc, ChatTripState>(
            builder: (_, state) => TextButton(
              onPressed: state.isWritting
              ? () => _handleSubmit(_messageController.text.trim())
              : null, 
              child: const TextCustom(text: 'Gửi', color: ColorsCustom.primary)
            ),
          )
        ],
      ),
    );
  }

  String _getNameByRole (String role) {
    if(role == 'thu_quy') return "Thủ quỹ";
    if(role == 'pho_nhom') return "Phó nhóm";
    if(role == 'chot_doan') return "Chốt đoàn";

    return "Thành viên";
  }
}

