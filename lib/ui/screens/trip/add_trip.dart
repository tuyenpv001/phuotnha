import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/ui/helpers/helpers.dart';
import 'package:social_media/ui/screens/trip/items/choose_map.dart';
import 'package:social_media/ui/screens/trip/items/search_map.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';
import './trip_page.dart';
import 'commons/label.dart';



class AddTripPage extends StatefulWidget {

  const AddTripPage({Key? key}) : super(key: key);

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}


class _AddTripPageState extends State<AddTripPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateStartController;
  late TextEditingController _dateEndController;
  late TextEditingController _tripFromController;
  late TextEditingController _tripToController;
  late TextEditingController _memberController;
  final _keyForm = GlobalKey<FormState>();
  late List<AssetEntity> _mediaList = [];
  late File fileImage;


  @override
  void initState() {
    _assetImagesDevice();
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateStartController = TextEditingController();
    _dateEndController = TextEditingController();
    _tripFromController = TextEditingController();
    _tripToController = TextEditingController();
    _memberController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  _assetImagesDevice() async {

    var result = await PhotoManager.requestPermissionExtend();
    if( result.isAuth ){

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
      if(albums.isNotEmpty){
        List<AssetEntity> photos = await albums[0].getAssetListPaged(page: 0, size: 50);
        setState(() => _mediaList = photos);
      }

    }else{
      PhotoManager.openSetting();
    }
  }


  @override
  Widget build(BuildContext context) {

    // final userBloc = BlocProvider.of<UserBloc>(context).state;
    final tripBloc = BlocProvider.of<TripBloc>(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if( state is LoadingTrip ){
          modalLoading(context, 'Tạo bài...');
        }else if( state is FailureTrip ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if( state is SuccessTrip ){
          Navigator.pop(context);
          modalSuccess(context, "Tạo chuyến đi thành công.!!",
              onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const TripPage()), (_) => false)
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Form(
              key: _keyForm,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _appBarTrip(),
                    const SizedBox(height: 10.0),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: ListView(
                          children: [
                            const Label(name: "Tên chuyến đi"),
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[100]!,
                                      ),
                                    )),
                                child: TextFormField(
                                  controller: _titleController,
                                  maxLines: 4,
                                  decoration:const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Tên chuyến đi',
                                  ),
                                  validator: RequiredValidator(errorText: 'Vui lòng nhập tên chuyến đi'),
                                ),
                              ),
                            const SizedBox(height: 15,),
                            const Label(name: "Mô tả"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  )),
                              child: TextFormField(
                                controller: _descriptionController,
                                minLines: 3,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Mô tả',
                                ),
                                validator: RequiredValidator(errorText: 'Vui lòng thêm đoạn mô tả.'),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            const Label(name: "Địa điểm bắt đầu"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  )),
                              child: TextFormField(
                                controller: _tripFromController,
                                minLines: 3,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Địa điểm bắt đầu',

                                ),
                                validator: RequiredValidator(errorText: 'Vui lòng nhập địa điểm bắt đầu'),
                              ),
                            ),
                            const Label(name: "Địa điểm đến"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  )),
                              child: TextFormField(
                                controller: _tripToController,
                                minLines: 3,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Địa điểm đến',
                                ),
                                validator: RequiredValidator(errorText: 'Vui lòng nhập địa điểm đến'),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            const Label(name: "Số lương thành viên"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  )),
                              child: TextFormField(
                                controller: _memberController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Số lượng thành viên',
                                ),
                                validator: RequiredValidator(errorText: 'Vui lòng nhập số lượng thành viên.'),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            const Label(name: "Ngày bắt đầu"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  )),
                              child: TextFormField(
                                controller: _dateStartController,
                                // keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.calculate_outlined),
                                  border: InputBorder.none,
                                  hintText: 'yyyy-MM-dd',
                                ),
                                onTap: () async {
                                  DateTime? pickDate = await showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(3000));
                                  if(pickDate != null) {
                                    setState(() {
                                      _dateStartController.text = DateFormat("yyyy-MM-dd").format(pickDate);
                                    });
                                  }
                                },

                              ),
                            ),
                            const Label(name: "Ngày kết thúc"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  )),
                              child: TextFormField(

                                controller: _dateEndController,
                                // keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.calculate_outlined),
                                  border: InputBorder.none,
                                  hintText: 'yyyy-MM-dd',
                                ),
                                onTap: () async {
                                  DateTime? pickDate = await showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(3000));
                                  if(pickDate != null) {
                                    setState(() {
                                      _dateEndController.text = DateFormat("yyyy-MM-dd").format(pickDate);
                                    });
                                  }
                                },

                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Label(name: "Hình ảnh"),
                            Padding(
                          padding:
                              const EdgeInsets.only(left: 65.0, right: 10.0),
                          child: BlocBuilder<TripBloc, TripState>(
                              buildWhen: (previous, current) =>
                                  previous != current,
                              builder: (_, state) => (state
                                          .imageFileSelectedTrip !=
                                      null)
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          state.imageFileSelectedTrip!.length,
                                      itemBuilder: (_, i) => Stack(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: size.width * 0.95,
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(state
                                                            .imageFileSelectedTrip![
                                                        i]))),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: InkWell(
                                              onTap: () => tripBloc.add(
                                                  OnClearSelectedImageEventTrip(
                                                      i)),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.black38,
                                                child: Icon(Icons.close_rounded,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox()),
                        ),
                            const SizedBox(height: 10.0,),
                            const Label(name: "Đánh dấu điểm trên hành trình"),
                            SearchMap(),
                            const SizedBox(height: 10.0,),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: MediaQuery.of(context).size.height * 0.65,
                              width: MediaQuery.of(context).size.width,
                              child: ChooseMapLocation()),
                            
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 5.0),
                    SizedBox(
                      height: 40,
                      width: size.width,
                      child: Row(
                        children: [
                          IconButton(
                              splashRadius: 20,
                              onPressed: () async {
                                AppPermission().permissionAccessGalleryMultiplesImagesNewTrip(
                                    await Permission.storage.request(),
                                    context
                                );
                              },
                              icon: SvgPicture.asset('assets/svg/gallery.svg' )
                          ),
                          IconButton(
                              splashRadius: 20,
                              onPressed: () async {
                                AppPermission().permissionAccessGalleryOrCameraForNewTrip(
                                    await Permission.camera.request(),
                                    context,
                                    ImageSource.camera
                                );
                              },
                              icon: SvgPicture.asset('assets/svg/camera.svg' )
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            )
        ),
      ),
    );
  }


  Widget _appBarTrip(){
    final tripBloc = BlocProvider.of<TripBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: ColorTheme.bgGrey, borderRadius: BorderRadius.circular(50)),
            child:  IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context, routeSlide(page: const TripPage()), (_) => false),
                icon: const Icon(Icons.close_rounded)),
          ),
        ),
       
        Text("Tạo mới chuyến đi", style: kHeadlineLabelStyle),
        BlocBuilder<TripBloc, TripState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) => TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  backgroundColor: ColorsCustom.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
              ),
              onPressed: (){
                if(_keyForm.currentState!.validate()){
                  // if(state.imageFileSelectedTrip != null){
                    tripBloc.add( OnAddNewTripEvent(_titleController.text.trim(), _descriptionController.text.trim(),
                        _tripFromController.text.trim(),  _tripToController.text.trim(), _dateStartController.text.trim().toString(),
                        _dateEndController.text.trim().toString(), int.parse(_memberController.text),"open"));
                  // } else {
                  //   modalWarning(context, 'Không có ảnh nào được chọn.!!!');
                  // }
                }

              },
              child: const TextCustom(
                text: 'Tạo',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: .7,
              )
          ),
        )
      ],
    );
  }


}
