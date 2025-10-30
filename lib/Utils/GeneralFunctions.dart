
import 'package:flutter/foundation.dart';

void printData(String str, String val) {
  if (kDebugMode) {
    print("$str :::  $val");
  }
}
bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(em);
}

bool isPhone(String input) =>
    RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(input);

// void onLoading(BuildContext context, String msg) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       // return Image.asset(loader, height: 20, width: 20,);
//       return Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0),
//                 child: Text(msg),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
