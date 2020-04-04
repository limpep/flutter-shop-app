import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/utils/constants.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY';

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      if (responseData['expiresIn'] != null) {
        _expireDate = DateTime.now().add(
          Duration(
            seconds: int.parse(responseData['expiresIn']),
          ),
        );
      }
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String()
      });
      prefs.setString(USER_DATA_PREFS, userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(USER_DATA_PREFS)) {
      return false;
    }

    final extractedUserData =
        jsonDecode(prefs.getString(USER_DATA_PREFS)) as Map<String, Object>;
    final expireDate = DateTime.parse(extractedUserData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userData'];
    _expireDate = expireDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpire = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
