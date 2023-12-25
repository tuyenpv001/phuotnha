import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/ui/screens/tripschedule/commons/utils.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/title_appbar.dart';

class TripStartPage extends StatefulWidget {
  const TripStartPage({super.key, required this.tripId});
  final String tripId;

  @override
  State<TripStartPage> createState() => _TripStartPageState();
}

class _TripStartPageState extends State<TripStartPage> {

  final CameraPosition _kgoogleMapInit =const  CameraPosition(
    target: LatLng(10.772129, 106.724629),
    zoom: 15
  );
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  late List<LatLng> o;
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    //  Utils.getAddressPlace();
    o = PolylinePoints().decodePolyline("wfl_Coz~dS{CUEb@jF^~ALzLz@tBPzM`AbAFbJp@w@jH]hDnCVFFHDh@FRDFBbBbArCdB`Aj@h@|A|@hAt@JDnAb@p@Tb@NnAb@rAd@`@NfA^NDb@PlDjAnDpALDLDdAd@VJVHHDNDLF|@VHVJdA^PFNFNdBl@dA^j@Rj@Rd@PnC`Ar@^NH`@D`@AZEVMPY^m@hAyAbDUd@Sb@IR_@x@ADYj@GPcB|DOd@`@RD@lAf@pAj@dAb@`A`@xAl@jAd@fAd@hF~BT^f@B^@dA?~EBn@HZRZ^`@z@v@bBzA|CnCdA~@d@`@ZVjBfBp@j@fA|@z@t@fAz@bEvCdAt@bAt@f@^PL`@@p@t@z@b@h@`@h@JXH^c@t@MVYl@EFq@tAZNpAiCJJ`@d@`@HHJHXVTRFD^NLTTTPNNNLHF??NJ|@p@JDDBARCDc@`@g@l@_@d@IJHK^e@f@m@b@a@BE@SECKE}@q@OK??IGOMOOUQUUOM_@]GEUSYWKImErIqBxDKGq@g@MISOYSW`@y@pAmAnBaBlCuCvEgExGQX_@d@g@l@w@z@}A`BML{@~@a@b@u@|@UVuBbB[T_@VOJkAv@aAh@Ya@X`@k@ZiAf@cA`@kCdAk@TkChAMFUJWJcBx@sAp@q@^k@^s@l@mAnA}@fAa@f@OP{AhBsA~AKJYRULYJe@Hc@BOA[Ce@Gq@Mk@O{@[kAg@UMOZUl@M^M`@EN}@|BCHYdAWd@MTCHKRGJMVIPUd@GJS^CFKRl@Zh@Vd@Vn@No@Oe@Wi@Wm@[JSBGR_@FKTe@HQLWFKJSBILUVe@XeABI|@}BDOLa@L_@Tm@N[q@_@_Ak@cBoAq@}@m@m@cGoFQO_A_A]]_@[]nAIOT[f@CDINSXiAtA}@`Ai@h@OPg@j@WXu@v@w@z@gCfCaBfBs@t@Ub@Uj@EPKOj@e@xBu@hDwAnGGTI`@VHj@ZFD`Ah@zBvA`Al@|AfAs@lAjAr@CLUzAbANS~ArARzBpARtCh@jC`@fBX`CAJjA?PEt@WZSxAuApEmFtAwAJG|CGRCZGpAnBjBnCl@|@PXn@bAZf@bA~ApAtB|C~EXU|DoCz@o@wBcEvBbEh@x@d@r@xAeAdAs@l@`Ab@r@n@fAxAeA|AiArA_Ad@_@rEkDvEcD~@s@nEgDbFyDtCtEnAhBnAjB|@zAJNz@vA@JDPJPl@|@VSvH{FpAcAHEFGbE}Cb@]`AIj@@d@Fb@Rd@Z|@rANT~CdFBFBFaAb@OJ^n@dA`BPFBH{BfByCzBeBoCaBiCKOqBaDk@}@}AaCbE}Cb@]ObBw@vC{BpAwAZ[h@e@BCNMTQ~AkAXULKx@o@bAu@BAl@e@zA|BtClEjAdB~@tAhBvCdA`BeAaBiBwC_AuAkAeBuCmE{A}BfDgC`CgBVQi@aAmJfHiAz@e@}ErD]XQ@c@Ai@IaAS{Aa@WK_@QYW[_@gAaBq@cAeA_BKIOEKQq@iAS[cA{AkAcBqAoBe@q@_AuAuAuBwAoBe@m@m@q@Y]g@i@w@}@g@k@Y]UUOQa@c@_EsEf@[g@ZW[oAuAY]gBuBaAiAaAgAIAQDIHARJJ|BfCfBrBZ^DDHvAVjEF~@@XBZADALEZo@~Be@xEd@yEn@_CD[@M@EC[AYG_AWkEl@W~AfBn@t@bCnCb@f@PP`@a@Y]UUOQa@c@_EsEW[oAuAY]q@YeH_I{AcBgCyC{A{A[Yo@c@}@q@_@Q}@c@wBcA_CkAq@[y@_@{@c@_@S{As@yAu@}BiAw@a@kB}@WMWM}EaC{Aw@yAw@EC{Ao@_Ac@YIoDq@WGmCg@oASSE{@SSEeBUy@MyAUc@IICaAQ_@IaAUiBa@fAmGN_ALiADU^sAVw@Aa@WqD[kEg@yGYsDQiCMwAMuAEk@Gs@IeAM_BIy@KuAKiAEa@Em@M_BGq@q@eGe@yDKw@Iq@Ea@AMAG?c@@K@SHq@NmAFc@DWNaA`@uBD[TmAJc@DUDW@CDQ?CH_@F[@GLm@Je@Lo@??FUDSF]Nq@XyAVoAp@qDVqALo@?ABQt@wDd@aCHe@TcALq@KKSGcBQuC[mIs@{AKyMaAuBO{L}@aBMmAI").map((e) => LatLng(e.latitude,e.longitude)).toList();

   print(o);
   Utils.getAddressPlace();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: _appBar(),
        body:   Stack(
          children:[
            GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kgoogleMapInit,
              onMapCreated: (controller) {
                controllerGoogleMap = controller;
                _googleMapController.complete(
                  controllerGoogleMap
                );
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("RouteTesst"),
                  points: o,
                  width: 5,
                  color: Colors.black87
                ),

              },
              )
          ]
        ),
       
    );
  }


  Future<void> getCurrentLocation() async {
    await Permission.locationWhenInUse.isDenied.then((value)  {
      Permission.locationWhenInUse.request();
    });
     await Permission.notification.isDenied.then((valueOfPermission) {
      if (valueOfPermission) {
        Permission.notification.request();
      }
    });
  }
 
  

  AppBar  _appBar () {
    return AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const TitleAppbar(title: "Đang đi"),
          elevation: 0,
          actions: [
            Button(bg: bgGrey,height: 40,width: 40,icon:const Icon(Icons.close, color: Colors.black),onPress: () {
              Navigator.pop(context);
        },),
      ],
    );
  }


} 



 