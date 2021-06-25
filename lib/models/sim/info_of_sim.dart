import 'package:flutter_app/models/sim/sim_balance.dart';
import 'package:intl/intl.dart';


class InfoOfSim {
  String? simOperator;
  int? simUpdated;
  SimBalance? simBalance;

  InfoOfSim( String? simOperator, int? simUpdated,  SimBalance? simBalance)
  {
    this.simOperator = simOperator;
    this.simUpdated = simUpdated;
    this.simBalance = simBalance;
  }

  String getUpdateTime(String lang){
    if(simUpdated!=null) {
      var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(
          simUpdated! * 1000);
      return DateFormat('dd MMM yyyy, kk:mm', lang).format(dateToTimeStamp);
    }
    else
      return "";
  }



}