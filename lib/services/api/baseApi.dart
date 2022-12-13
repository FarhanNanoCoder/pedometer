import 'package:pedometer/services/api/userApi.dart';
import 'package:pedometer/services/api/userFitApi.dart';

class BaseApi {

  //singleton pattern
  BaseApi._internal();
  static final BaseApi _instance = BaseApi._internal();
  factory BaseApi() {
    return _instance;
  }

  UserApi userApi = UserApi();
  UserFitApi userFitApi = UserFitApi();
}
