import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      //backgroundColor: Colors.grey.shade600,
      //textColor: Colors.white,
      fontSize: 16,
    );
