import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  if (response.statusCode >= 199 && response.statusCode < 300) {
  onSuccess();
} else {
  switch (response.statusCode) {
    case 400:
      showSnackBar(context,'طلب خاطئ، حاول مرة أخرى');
      break;
    case 500:
      showSnackBar(context,'خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقًا');
      break;
    default:
      showSnackBar(context, "لقد حدث خطأ ما");
  }

}
}

void showSnackBar(BuildContext context, String text) {
 try{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );

 }catch(e){
  print(e);
 }
}

