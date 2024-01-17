import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/data/env/env.dart';

class Utils {

   static sendRequestToAPI(String apiUrl) async {
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));

    try {
      if (responseFromAPI.statusCode == 200) {
        String dataFromApi = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromApi);
        return dataDecoded;
      } else {
        return "error";
      }
    } catch (errorMsg) {
      return "error";
    }
  }

  ///Reverse GeoCoding
  static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
      Position position, BuildContext context) async {
    String humanReadableAddress = "";
    String apiGeoCodingUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Environment.apiKey}";

    var responseFromAPI = await sendRequestToAPI(apiGeoCodingUrl);

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];
      print("humanReadableAddress = " + humanReadableAddress);
    }

    return humanReadableAddress;
  }



  static Future<void> getAddressPlace() async {
    
    // String urlGG = "https://rsapi.goong.io/Geocode?latlng=21.013715429594125,%20105.79829597455202&api_key&api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU";
    // String urlPlace = "https://rsapi.goong.io/geocode?address=Trạm Xăng Dầu Minh Hưng&api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU";
    // String urlSearch = "https://rsapi.goong.io/Place/AutoComplete?api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU&input=Hồ trị an, Tôn Đức Thắng, TT. Vĩnh An, Vĩnh Cửu, Đồng Nai, Việt Nam";


    String urlPlace = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=${Environment.apiKey}";
    var res = await http.get(Uri.parse(urlPlace));
    var result = jsonDecode(res.body);
    print(result);
  }

  static Future<Direction> getDirectionTwoPoint(LatLng source, LatLng des) async {
    String url = "https://rsapi.goong.io/Direction?origin=${source.latitude},${source.longitude}&destination=${des.latitude},${des.longitude}&vehicle=bike&api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU";

    var res = await http.get(Uri.parse(url));
    var result = jsonDecode(res.body);
    return Direction.fromJson(result);
  }


  static String path = 'uqwaA_{gkSqA~@m@f@GBEDEDCFAF?@A@?BAF@D?B???@?@@B@F@@@BDDDDDDF@FBH?F?FAFA@?DCFEDE?AbBAdMHXA`@C^KX?bHB~VL~A@tE?hCDhCNd@Dv@LL@RL^F~Cf@lAVrA^fBj@dBp@rB`AbBbAvA`AdAv@xArA|C|C~WjXj\\t\\zXdY\\\\LJ~BtBlAhAdEhEtA`BfAtAvArBnApBn@hANXp@vAt@zBZlAxC~KfAfEj@|BlCjKfDrMlD|MWHz@~CZlAp@nClA|Et@bDXjA|@jDdAnEBR@VAl@TTpAdA`@r@PRTR\\l@t@hAl@v@N\\x@nA~AjBzA~AdBzAhAv@xA`AvCnBhFlDhIpFnBpAj@^`BfAlFlDtCnBhFjDjK`Hr@f@~AfAjFlDfDxBtClBxE~CfAt@t@f@b@d@lEzCLRd@zATNbIlFVPjBlAVNtFxDVPdD|BvFrDTN\\TfBjAbBrApChCzBjCVXdA~Av@fAj@z@v@vA^MRCNAJDxAxCnAjC~AfDfErIpB`E|ChGpDjH^p@`ExHDHHHf@|@x@zAxNlYXh@?TDPfBlD^t@~BzEzCjG|HnO|A|CpGjMxCbGdAnBvA|BrAjBb@l@d@d@VVJDL@pBlBRPbBtAhAt@GJdAp@fCrApDfBdDbBlGzChIxDpHhDtDbBzE|B`HbD`K|ELFLFLDz@b@nEpBzHpDjD`BtCrA`GpCxHlDrG~CXLtFdCxAt@~CtAlAd@jBl@~@VlB`@tAXxCh@zC\\xCZzEf@zEj@~CXbD\\`DXjMrA|H~@j@HpB\\n@N^JlCp@rAd@~B`AtBhAZPdAn@tAbAvAlArApAr@x@l@r@dAxAj@|@p@pAT`@R^Zn@bAnC`@pAb@dBThALr@Z|B^tCRdBRnBTpBXbC\\`ETrB|AvNnBtQt@~GlBxQFTDJDBXrB^nCHn@CBALD^rDb\\h@xEvB`TFf@FVFH?j@?z@C`@CTGl@Mt@IZ{@dC]v@u@|AMDKHQZs@vAq@vAi@fAk@bBa@jAK`@CPDPO`@g@`BWv@CHSr@U|@q@bD_@pBIh@BD@DEf@G~@Cn@GvDBhBDj@JjA`@dDN|@D\\?HAFh@xBADBN\\dAXr@hAzBlAxBx@nAlAzA|@`ApXhWh@f@LJpB~AJHfBbBfA`AjAhAAD?F?F?D?DBJDJDJHJ?@HFDBD@B@D@B?D?B?HHh@f@LJr@n@jBhBh@f@t@r@HHBL@PCZ[ZQT[Zi@n@{A~A]^CF?V|BrBf@f@|@|@d@b@l@p@VT`AdAlAfAh@f@r@r@n@l@~@~@f@d@~@|@pAnAdA`APRPP\\\\^\\LLTV^^pAjAxAxAnAnAPRDDbAbARPn@n@bAbAPP`@`@`A~@LLlBlBd@d@hChCdBfBjFjFnFpFlAjAXXXVz@|@LZI@GBGBEBEDEFCFCFAF?F?F@F@DBD@FDDFDDBFB??FBH?D?X\\z@j@zDdBfD|A|@`@RNZZPVvE|IjDpGzBfEh@bA`B|CNXNXd@z@bAvBHNbCpFf@dAFNf@fA^x@v@jBNJPZ^v@jArCnBrEdBxDzDpIDN@PZp@rAxCJRt@fBpAvC|AlDj@nA^|@^v@v@hBN\\LXDHDJNZvA`DnCjGJRx@dBHPNZhBbEVj@Vj@`AvBvBxEl@pAnArCTh@P`@P`@Rb@j@rAFLn@xArBvEl@rARb@Th@h@jA^z@Zr@v@hBlAlCvAbDRd@n@xAFDHLJNvDhI|AvCJZ?@BLBr@Ex@e@nIG~@EZIZCh@Cx@GdAAt@C`ACt@?b@?n@?ZBlGBf@Hb@FZRp@\\r@f@nA??A?CFAFAHAF@F@H@FBF??DDDD????DBFDD@@???F@H@HA??Zb@PZ~@bBv@pAvAvBZ`@fB~BjGzI|CfELRvAnBxEnG|@hAtJjMZ`@PPJHHF@FBFDDBDpAbBzAlBvD|EhAxAX`@|AxBnAdBbB|B??jB`Cf@l@lB`C|@dAd@n@|@fATXVZtClDn@f@PLNDN@JFTLz@d@\\PlAn@`@PLH@JHHPLnCtAx@`@zAt@TL|Av@rBz@hFjCr@\\rHvDlAn@PH~@n@t@n@f@f@`@l@X`@HNVb@jApBh@`A\\l@|AhCDFFDVb@xCtFh@~@`BpC`AbBhB|CZj@h@x@f@p@\\^VThBtAx@h@XVJPFPDb@ABAD?F?D?H@F@FBFDFDDDDFBFBH@F@\\Hb@H|CVh@FH@JAD@|A^|B\\|@LxEf@n@DnJ|@|Ed@xD^nFf@~Fl@bBPxCXv@Hl@BR@|CHn@DdHp@jAL`AJnCVvCX`BVr@LjAZnC|@hAXxANzA@rA@bCCfIOnBAjB@vAHzFf@~B\\~@Rv@Ph@JhMnCp@NlFjAlBb@x\\tHlCp@TFr@TZJl@T^Pf@TjB|@vCpBhAdAt@v@fAhAxBxBdAfA|A|Ah@n@Z^r@|@hB|BlA|AjDpEpChDbD`EdC|Cp@v@fGzHlBrB`@b@hEnE|G|GzBzBvBzBrBjCzApBrBnCnBhCd@p@x@hAx@fAtCvDjEzFTZ`BxBfAxAdDnEbBxBTXp@fApA`Cz@zAbAjBZn@nD|G`AlBz@~AhCbFVf@Xj@H`@EtAB`@^dA@Df@r@h@^tAn@PTl@hAZr@DJ^x@hA`C`BpDbBpDbBnDdAxB@@~B`FlA|BZd@V`@`D|DlGdI~K~NtAhBdAxAnBjC`UhZ~F|HlBfCV\\|DhFhAhBd@v@v@`BnExJnFxLlC`GjAjC~@tB`E~Il@fBn@zBzEvPbGlTb@lB|@dHpEz_@nBjP\\tCj@|ERlBJ`A@zA?DKnAgAbMARgBdSs@|IS`Cm@dGi@zFeA|HsCfReCvOKt@U|AaEhYYzBmBnNAJ[bCe@tDM`A_@rCs@rFKpAAd@AR?~@J~CpAzXF`ALx@R|@^pAXv@d@z@fDrFR\\p@hAhH|Lv@nAv@`AnBbB~AfAPJt\\tS~VrO~e@dZbe@zY~E|CpHdFdMdJnKzHlFvDNJb@ZbFlDh@\\jCzAfDxAnC`A|DnAx@X`AZlYjJhg@lPhDdAtAb@zEpAhD|@pGbBlL|ClC|@jAh@lErB`Ad@`CnAvDbCzC|BzNbMtFxEtKfJvLbKTNzHfFrPpK`@VhBjAjDxBf@^f@f@@F?FBD@FDDBDDBFDF@NJPRNVdSfg@vEvKz@nBlCrGdEnKv@tBtKzWz@lBt@rA`BdCx@fA`ClCVV^Zn@j@hAz@rA|@xBnA|Ax@bC`AbCt@xCt@`Ch@`Gt@~ARpQtB~g@~F~AP~OjBtDh@jBZtBb@bU`F~D|@h@ARC\\VRFz@N|Eb@^H|E`CbBz@hFnCvAt@|Ax@z@d@bEvBtDhBl_@bRfMhGxMlGpKfFfH|C|@`@\\NrAj@tCnAd]fOnNhGrOjHzGnDjEjChEhCLFdAh@rBfArIlFLHnLnHpTpPrNvKnHjFpBvAfD`CfD~BpGtEdPhLbGhEpA|@`HzEbFlDXV`CrCdBnBfBxAz@r@dAn@hCxAp@^bB~@dDhBzAz@xBhApI~D`ElBjKbFjCnAzAr@l@XdCnATJ~G`DzAp@jBx@^Pj@Lb@Fd@F~BL|EVnBJxCN~AHpBHnETJ?zJf@lId@nUfAf^bB`ERxCP`I`@pDPtFXpPx@zBLzH^v@DzAF`BJvUjAzDP|CNl@DfMn@`GXlAFhGVxMj@~AHxAF~Mp@rR~@dKh@vIb@~CPbDNpERtB?FBHBv@Cr@Gf@E`@EFEDEr@Id@Il@M~L{C|FwAr@QlG{ATEvBi@rA[~FuAh@IXCT@PBBBBBBDD@DBF@F@FAF?FCFCDEBCBGBE@G?GX[ROdA_@l@OzIwBvBi@vGaBLEb@Mn@Wt@_@j@]d@]NMlAgAn@w@PILAH?TDlCxBfA~@`@XDB^Rn@Rl@PZDvD`@hJ~@dAJtFf@hCVtANj@FjMpAh@F~Ix@\\@zBBfC@lA?vC@fD?fDBhIBbD@`D@hD@|FDpB@lA?T?b@C\\HVJXNb@^DJVLZ@TClMcCJ@@?NADADCDADABC@A@ApJmCNQH]tB[vAm@sA{GrAzGwAl@uBZgLtAKk@Q}@GAEAE@E?G?M@CBIFgGv@{C\\m@HMBIDIFS`@ELGLGJMPQJa@Rq@?mA?uAAyGE}CAqICoNGwE?gBAsEA_CCc@A_Gk@qAMm@Gy@IqKgAaCUkCYgFe@sAMqHu@eFi@a@Gk@Om@Se@U]WoBaBiB{AQMOEKQ{AfBq@n@c@^WRQLi@Zu@^o@V_@Lq@PuEjAuCr@iKfCuCl@GAG?E@G@EBEBCDwBl@aATcFlAiMzC??}Ct@_Dv@kDz@sHfBe@Ju@HKAc@Ba@Dw@Fo@DUB_B?oACQAgH]sAIgDQqCO}FYeJe@{Ic@uJe@qPw@uBI_BIyCMyG[ePw@aFWuEUqFUgCMmRaAcGYiJe@mCOiKg@{FYeDQcIa@aG[eFWsFWwPy@aCKsH_@sFWsAGoDScH_@sFYaCK{AGsEUaGYaG[aBKe@Ea@Gi@OICUKiCkAuCqA{E{BeCoAaCgAuCsAqMmG{@a@m@[qHkDaDaByCaBgAm@wF_D}BqAeAw@qBcBeBoBaCqCYYaEsCiAy@kBqAcCcB}AeAgUgP}AiAmJyGcJsGoEaD}BaByMaKoNsKcE_DaKoG{@i@{A_AkFeDcCmAiAo@AA{A}@cBcAyD_C}HgEsOiHs\\_OyNoGiDyAgAe@]OiAg@qD}AiCiAsJuEmGyCcBw@iBy@cMmG{EaCsXaNiDcBoE_C_DaByDqB{BkAwBgAaFeCWCQESIaFoCECEEGCGAIAG?G@G@GBGBEDEDEDCFADAFWTODWD[CqBe@eNyCwIkBkB]uDi@aPiBaBS}g@_GqGu@s@KkGs@kH}@iAQqCw@oBe@cCu@_CaA_Bw@uBmAsA}@iAy@g@e@_@]][_CkCy@gA_BcCu@sA{@kBsAcDaIwR}@qBcEoKmCsGeBaE{BeF_CwFwPob@GYC_@BCBCBGBE@G@G?GAGAGCGCGEEEEGCECGAIAG?G@G@GBe@IWIg@YeDuBgBgAe@[}GiEmLwHwDeCmNuLiNqLiB{AaOiMoHaGkB_Ba@Y[Mi@UiCeAuBs@qGwAwI_CwSqFoH_CcSuGeQ{FqQ_G{@YkBi@cCy@_@Ms@YwBmAsVmOGEg@[uI{FwQ}KsUaOoLqH}UcOed@_YmBkAsj@g]uImF}AeAmBcBu@}@u@oAuC}EgEkHA?uDsGc@{@Um@Qm@Oo@Ko@}As]MsDCoAAY@i@LgAbA_Iz@wGVoBjBmNZ}Bv@sFZ{Bd@_DbBsLpDmUNkA|A}J|@}GDa@`@eEHu@Hw@X}CHq@fA}MfBgS@QfAcMJqAAeBKaAaAmI_J_v@}@eHa@oBeGkToAqE{DeNm@gBeA{BQa@cKeUcHwOiDqHk@mAuBgDg@s@gDoEi^ue@gA{A{DkFuP{TeEmFcD{DU_@[e@kA{B{BwEACyA{CyBqEKWmAgCsBoE}BaFMe@Cq@?QUcBYgAy@eAWMaA]]Wa@o@Q_@sImPyBgEsB{DcB{CYc@g@s@gBaC_EqFk@w@e@m@i@s@{HcKmGwIuGuIg@o@uAiBgBmBcFcFwBwBiAgAaCcCeEmE}AmBuDuEqDyEwF}G{@gAcAoA}BwCuBmC[a@kAyAqA_B}CcDy@y@uDwD{@}@{@q@mAw@c@[cBu@u@]_Bq@yAe@iCo@oDu@qEgAyPwDoBc@eGwAoAYaDq@aB]{@ScCi@{AWyCc@]CuEc@mAK_AE{@CqB@eIN{BDwC@oAGSAu@QmBm@}Ai@q@OmB_@cD]{Fm@mCSoCYgAK}@KuB_@k@Is@I}Da@qEe@aAIuNuA}D_@gCWoCWqC[_Iu@aAIuBIe@GGAe@MKEc@O_DyAEEGEICoBuAo@c@g@]m@e@o@o@_@c@a@i@S[g@y@kBcDgAiBkHeMYc@AKAIEKa@s@oAwB{AmCs@mAa@q@e@o@q@q@g@a@IIcAq@c@UqJ}EcFeC}@c@{Au@mBaAsFoCaCmA_@SyBgAo@_@OIWQo@g@SQY[yBoCo@w@e@m@{AkBw@_AsAaBkCeDIK]e@wAkBkA_BiBcCi@s@a@i@_AkAaBuByAkBSYKOg@sA?GAIAECEGGGCKCE?G?E@SIOMw@gAoAaBwBqCoCqD_@g@Y_@{DgFMQk@y@kA_BqAgBeDwE]e@u@gAm@y@o@}@gB_C[c@iA_BOUiAqBu@sA[q@?ABG?A?A@C?G?GAGAGCGCEEGCCA?GEECGAGAG?G@I???]i@Ua@GSGSAMC]?aACcBc@wGC_@?MPqEHeBJ}AJkAHsATcELmCJuBa@EKAYEIIGEu@I?MAKGOuBuE}@oBg@kAoBuE_@{@wAcDYm@c@aAgAeCm@qA[u@Sc@MYSc@{@oBw@eBO]GMw@gBaA{B{@oBQ_@GOWk@k@oAc@aASe@c@aAWk@ISy@iBIQSe@a@}@Sc@y@gBKSe@eAgC}F_CiFKUCGCG_@y@Wm@_@y@Ui@Sc@[s@{@mBe@iAw@eB{@oBw@gBqAwCg@iAOMIOk@kAoCaGuEmKyBkFC[w@aB_@w@[s@ISa@{@]w@e@aAuA{CGO_@u@a@y@c@{@_@q@S_@[o@]m@Ua@c@{@a@u@_@s@[m@a@u@]m@[o@iBiDGKgAsB}AuCs@sAQY_@_@UOSK}G}CiBy@m@c@Oi@DEBG@G@G?G?GAG??CGCGEGDStA_DdBuDA?IKWWc@e@a@a@aCeCmBqBqByBkBqBqByBa@c@qAwAmBwBmBsBwBaCkAmAcAcAy@{@IIOOiDeDqBoBsBsBoBmBmAkAy@q@cDsC_BaBeAeAsAuAe@a@_B{AsAmAa@a@aA{@}ByBuBqBs@q@QWc@w@?C?I?GCGAIEMGG?ACEGEGEECEACAA?C?[[_Ay@sAmAyAsAkAgA[W][g@_@i@g@cHuGaNkM{@}@mA{Aw@kAkAyBiAwBWq@Uu@EGGCm@}BGWGKEUO{@k@oFEk@CwADcCDqBBWHm@Fa@DGBCVmBZgB^gBf@iB@EX}@f@_BNa@LCLKLUJQf@qAdAaC~BwEDOBSr@_B\\SZo@@En@mBPeBD}@?oDIaAcAyK{AgNaDqZKw@Gg@EUGKCCWkAo@oDIe@BI?OKkAwAuMoG{l@Go@OyAAu@?s@HsADcAAYASMqAGWCSOc@k@uAY{@Ss@Ki@O{@QaBU{AOy@WaAMe@a@uAgAsCq@yAq@mAi@_AuBuC{@aAoAqA][_@[}@w@gBoAq@c@w@g@{Au@mBy@c@O}@YaBg@aAUsAYsB_@m@I}H_AmMuAaDYeD]e@E]EsEm@gEg@_@C??_CIeFm@OOWIgB[sB]q@QcCq@s@OyCy@u@a@{FqCo@W{BaA[MaEmBsDeBqAk@cHcDgHeDgAg@wMoGoAk@cAe@MEMG{DkBmI{DeD{AgEqBgAg@wMeGwJuEqBcAyAs@}BoAyGkDs@_@uA{@w@i@y@o@e@c@QQ_CwBq@u@cAoAiAaBkBmCU_@S_@qPu\\iCcFsC{FqB{DgA}BwAuC]u@mBuDEEECOGWg@gCcF?SEQIScIcPyAyCuEqJ{EoJmEoI]o@oAgCy@aBk@eAuAgCSa@EOEKEq@Ga@Wk@c@aA_BeDe@u@mByCIOSOg@s@e@o@a@g@g@o@g@k@cCcC{AsA}AoA{B}AEESMwCmB_BgAeBgAyA_A_DwBeBoASOu@i@GGEIg@_@_@U{EcD{BwA{@i@qAy@eBgAcEoCiRcM{ByAMBYBK@_DsB_C}AqH_FkAw@{I_Gq@c@m@c@sEyCqBsAyQyLEEq@c@kAw@WQkBqA_Au@m@i@WYyA_BcAmAIMaAyAeAoB_@{@e@cA_@aAe@uAgAoDK_@y@cD}@cDiAeEwBcIs@uCODa@wAqD{MeDgMqCoK_@yAOo@iFaR[iA_AwBo@wAS]m@gAoAqBwAqBgAuAuAcBeEkEiAoAu@w@{@{@OOCGKMiYsYk\\u\\{MaNcIkI_D}CyAsAgAy@yAaAeBeAuBcA}Aq@wAg@uAc@eBa@cCa@m@GQAQ@YEu@Kc@GmCOiCCgGBkWMiECyCA[I_@C[CeMEUAUOKQCU@QFYdAw@IMs@f@'; 


}

class Direction {
  final List<Route> routes;

  Direction({required this.routes});

  factory Direction.fromJson(Map<String, dynamic> json) =>
   Direction(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))));

}

class Route {
  final OverviewPolyLine overviewPolyline;
  final List<PointLatLng> polylinePoints;
  final List<Leg> legs; 
  Route({required this.overviewPolyline,
   required this.legs, required this.polylinePoints
  });

 factory Route.fromJson(Map<String, dynamic> json) => Route(
  overviewPolyline: OverviewPolyLine.fromJson(json['overview_polyline']), 
  legs: List<Leg>.from(json['legs'].map(((x) => Leg.fromJson(x)))),
  polylinePoints: PolylinePoints().decodePolyline(json['overview_polyline']['points']),
  );
}

class Leg {
  final String distance;
  final String duration;
  final String endAddress;
  final String startAddress;

  Leg({required this.distance, required this.duration, required this.endAddress, required this.startAddress});

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    distance: json['distance']['text'], 
    duration: json['duration']['text'], 
    endAddress: json['end_address'], 
    startAddress: json['start_address']);
}

class OverviewPolyLine {
  final String point;

  OverviewPolyLine({required this.point});

  factory OverviewPolyLine.fromJson(Map<String, dynamic> json) => OverviewPolyLine(
    point: json['points'],);
}

// open' |'block'|'cancel'| 'pending'|'is_beginning'|'completed' | 'reopen'
final Map<String, String> StatusTrip = {
  "open": "open",
  "begin": "is_beginning",
  "cancel": "cancel",
  "pending": "pending",
  "completed": "completed"
};