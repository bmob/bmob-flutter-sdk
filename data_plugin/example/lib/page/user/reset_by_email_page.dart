import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';

/**
 * login page
 */
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';

class EmailResetPage extends StatefulWidget {
  @override
  _EmailResetPageState createState() => _EmailResetPageState();
}

class _EmailResetPageState extends State<EmailResetPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 30.0),
                buildVerifyTextField(context),
                SizedBox(height: 30.0),
              ],
            )));
  }



  TextFormField buildVerifyTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String? value) => _email = value,
      validator: (String? value) {
        if (value!.isEmpty) {
          return '请输入邮箱';
        }
      },
      decoration: InputDecoration(
          labelText: '邮箱',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {
                _formKey.currentState!.save();
                _sendEmail(context);
              })),
    );
  }



  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '发送重置密码邮件',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  ///发送重置密码邮件到邮箱
  _sendEmail(BuildContext context) {
    BmobUser bmobUser = BmobUser();
    bmobUser.email = _email;
    bmobUser
        .requestPasswordResetByEmail()
        .then((BmobHandled bmobHandled) {})
        .catchError((e) {
      showError(context, BmobError.convert(e)!.error!);
    });
  }

}
