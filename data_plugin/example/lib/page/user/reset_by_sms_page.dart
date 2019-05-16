import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';

/**
 * login page
 */
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';

class SmsResetPage extends StatefulWidget {
  @override
  _SmsResetPageState createState() => _SmsResetPageState();
}

class _SmsResetPageState extends State<SmsResetPage> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber, _smsCode;

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
                SizedBox(height: 70.0),
                buildPhoneTextField(),
                SizedBox(height: 30.0),
                buildVerifyTextField(context),
                SizedBox(height: 60.0),
                buildVerifyButton(context),
                SizedBox(height: 30.0),
              ],
            )));
  }

  Align buildVerifyButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '短信验证重置密码',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () {
            _formKey.currentState.save();
            //TODO 执行登录方法
            print('phone number:$_phoneNumber , sms code:$_smsCode');
            _resetBySms(context);
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  TextFormField buildVerifyTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _smsCode = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入验证码';
        }
      },
      decoration: InputDecoration(
          labelText: '验证码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {
                _formKey.currentState.save();
                _sendSms(context);
              })),
    );
  }

  TextFormField buildPhoneTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '手机号码',
      ),
      onSaved: (String value) => _phoneNumber = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
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
        'Login By Sms',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  ///发送短信验证码：需要手机号码
  _sendSms(BuildContext context) {
    BmobSms bmobSms = BmobSms();
    bmobSms.template = "";
    bmobSms.mobilePhoneNumber = _phoneNumber;
    bmobSms.sendSms().then((BmobSent bmobSent) {
      showSuccess(context, "发送成功:" + bmobSent.smsId.toString());
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  ///手机号码+短信验证码重置密码
  _resetBySms(BuildContext context) {
    BmobUser bmobUser = BmobUser();
    bmobUser.mobilePhoneNumber = _phoneNumber;
    bmobUser
        .requestPasswordResetBySmsCode(_smsCode)
        .then((BmobHandled bmobHandled) {})
        .catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }
}
