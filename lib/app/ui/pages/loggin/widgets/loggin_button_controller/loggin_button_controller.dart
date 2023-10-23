import 'package:appeventos/app/domain/utils/resource.dart';
import 'package:flutter_meedu/meedu.dart';

class LogginButtonController extends SimpleNotifier{

  bool isLoading = false;

  processLoad(){
    isLoading=!isLoading;
    print(isLoading);
    notify();
  }

}