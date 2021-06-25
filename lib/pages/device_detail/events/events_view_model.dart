import 'package:flutter_app/api/device_api.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/models/event/day_events.dart';
import 'package:flutter_app/models/event/event.dart';
import 'package:flutter_app/pages/device_detail/events/events_events.dart';
import 'package:flutter_app/pages/device_detail/events/events_states.dart';
import 'package:flutter_app/pages/device_detail/events/events_view.dart';
import 'package:flutter_app/pages/device_detail/events_data_response.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsViewModel extends ViewModel<EventsView, EventsState, EventsEvent> {
  final DeviceApi _devicesApi = DeviceApi();

  List<Event> events = <Event>[];
  List<DayEvents> dayEvents = <DayEvents>[];
  final DateTime nowDateTime = DateTime.now();

  EventsViewModel({required EventsView view}) : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }




  Future<void> updateEventsDetail({required int id}) async {
    if (events.isEmpty)
      statesStreamController.add(UpdateEventsInProgress());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

      await _devicesApi
          .events(token: accessToken, id: id, limit: 100)
          .then((eventsDataResponse) {
        _onSuccessUpdateEventsToApi(
            eventsDataResponse: eventsDataResponse);
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
      });
      _addIdleState();
    }
    _addIdleState();
  }

  void _onSuccessUpdateEventsToApi(
      {EventsDataResponse? eventsDataResponse}) async {
    if (eventsDataResponse != null) {
      if (eventsDataResponse.result == 'success') {
        events = eventsDataResponse.events!;
        dayEvents = _toDayEvents(events);
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
    _addIdleState();
  }

  void _showNotificationError(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ERROR,
        message: message,
      ),
    );
  }

  List<Event> getSortEvents(){
    List<Event> sortEvents = events;
    sortEvents.sort((a, b) => a.datentime.compareTo(b.datentime));

    return sortEvents;
  }

  List<DayEvents> _toDayEvents(List<Event> allListEvents) {
    List<DayEvents> dayEvents = List.empty(growable: true);
    DayEvents? currDay;
    allListEvents.forEach((ev) {
      if (currDay == null || !currDay!.isSameDay(ev.getDateTime())) {
        currDay = DayEvents(ev.getDateTime(), List.of([ev]));
        dayEvents.add(currDay!);
      } else {
        currDay!.events.add(ev);
      }
    });

    return dayEvents;
  }

}
