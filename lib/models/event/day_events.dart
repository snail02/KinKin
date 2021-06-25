import 'package:intl/intl.dart';
import 'package:flutter_app/models/event/event.dart';

class DayEvents{
  final DateTime dateTime;
  final List<Event> events;


  DayEvents( this.dateTime,  this.events);

  bool isSameDay(DateTime checkDateTime) {
    if(checkDateTime.day == dateTime.day)
      return true;
    else
      return false;
  }

  String getDate(String lang){
    var formatDate = DateFormat('d MMMM yyyy', lang);
    var dateString = formatDate.format(dateTime);

    return dateString;
  }

}