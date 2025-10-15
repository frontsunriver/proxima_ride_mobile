import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proximaride_app/consts/constFileLink.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

imageUploadBottomSheet(controller, context){
  return defaultTargetPlatform == TargetPlatform.android ?
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => getBottomSheet(controller, context),
    shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)
        ),
        side: BorderSide(
            color: Colors.white,
            style: BorderStyle.solid,
            width: 2.0
        )
    ),
  ): showMaterialModalBottomSheet(
      context: context,
      builder: (context) => getBottomSheet(controller, context),
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0)
          ),
          side: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 2.0
          )
      )
  );
}

getBottomSheet(controller, context){
  // Detect navigation mode by checking bottom padding
  // 3-button nav has higher padding (48+), gesture nav is lower (0-24)
  final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
  final isThreeButtonNav = bottomPadding >= 30;
  final dynamicPadding = isThreeButtonNav ? 80.0 : 20.0;
  final dynamicHeight = isThreeButtonNav ? 200.0 : 140.0;
  
  return SizedBox(
    height: dynamicHeight,
    child: Padding(
      padding: EdgeInsets.only(bottom: dynamicPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Ink(
              child: Row(
                children: [
                  Image.asset(cameraImage,width: 50,height: 50, fit: BoxFit.fill),
                  "Camera".text.sm.semiBold.make()
                ],
              ),
            ),
            onTap: () async{
              controller.getImage(ImageSource.camera);
            },
          ),
          const Divider(),
          InkWell(
            child: Ink(
              child: Row(
                children: [
                  Image.asset(galleryImage,width: 50,height: 50, fit: BoxFit.fill),
                  "Gallery".text.sm.semiBold.make()
                ],
              ),
            ),
            onTap: () async{
              controller.getImage(ImageSource.gallery);
            },
          )
        ],
      ),
    ),
  );
}