import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/device_detail.dart';
import 'package:flutter_app/models/event/day_events.dart';
import 'package:flutter_app/pages/device_detail/events/events_states.dart';
import 'package:flutter_app/pages/device_detail/events/events_view.dart';
import 'package:flutter_app/pages/device_detail/events/events_view_model.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_notifications_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class EventsPage extends StatefulWidget {
  final DeviceDetail deviceDetail;

  const EventsPage({Key? key, required this.deviceDetail}) : super(key: key);

  @override
  _EventsPage createState() => _EventsPage();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _EventsPage extends State<EventsPage>
    with NotificationsMixin
    implements EventsView {
  late EventsViewModel _viewModel;

  late ScrollController _controller;

  _scrollListener() {
    if (_controller.offset <= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      // _viewModel.updateEventsDetail(id: widget.deviceDetail.id);

    }
  }

  @override
  void initState() {
    _viewModel = EventsViewModel(view: this);
    _viewModel.updateEventsDetail(id: widget.deviceDetail.id);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventsState>(
        initialData: UpdateEventsInProgress(),
        stream: _viewModel.statesStream,
        builder: (context, snapshot) {
          final EventsState state = snapshot.data!;

          final bool updateEventsInProgress = state is UpdateEventsInProgress;
          final bool loadEventsInProgress = state is LoadEventsInProgress;

          if (updateEventsInProgress) return _buildLoadingView();
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).toggleableActiveColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
              title: Text(
                widget.deviceDetail.name + " - Уведомления",
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/setting.svg',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: 16,
                )
              ],
            ),
            body: RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _viewModel.dayEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  return dayEventGroup(_viewModel.dayEvents[index]);
                },
              ),
            ),
          );
        });
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        height: 36,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildLoadingEvents() {
    return Container(
      height: 36,
      child: CircularProgressIndicator(),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _viewModel.updateEventsDetail(id: widget.deviceDetail.id);
  }

  Widget dayEventGroup(DayEvents dayEvents) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 9, top: 10, left: 10),
            child: Text(
              shortDate(dayEvents),
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              //textAlign: TextAlign.start,
            ),
          ),
          Card(
            margin: EdgeInsets.all(0),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  //primary: false,
                  shrinkWrap: true,

                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).dividerColor,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return AppNotificationsCard(
                      event: dayEvents.events[index],
                    );
                  },
                  itemCount: dayEvents.events.length,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String shortDate(DayEvents dayEvents) {
    if (_viewModel.nowDateTime.day == dayEvents.dateTime.day)
      return LocaleKeys.all_today.tr();
    if (_viewModel.nowDateTime.subtract(Duration(days: 1)).day ==
        dayEvents.dateTime.day) return LocaleKeys.all_yesterday.tr();
    return dayEvents.getDate(context.locale.toString());
  }
}
