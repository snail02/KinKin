import 'package:flutter/material.dart';
import 'package:flutter_app/pages/common/auth/login/login_page.dart';
import 'package:flutter_app/pages/new_device/new_device_page.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_states.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_view.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_view_model.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_device_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class MyDevicesPage extends StatefulWidget {
  @override
  _MyDevicesPage createState() => _MyDevicesPage();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _MyDevicesPage extends State<MyDevicesPage>
    with NotificationsMixin, AutomaticKeepAliveClientMixin<MyDevicesPage>
    implements MyDevicesView {
  late MyDevicesViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MyDevicesViewModel(view: this);
    _viewModel.updateMyDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.menu_my_devices.tr(),
          style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).toggleableActiveColor,
              ),
              onPressed: () {
                openNewDevicePage();
              }),
          SizedBox(width: 16,)
        ],
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: StreamBuilder<MyDevicesState>(
            initialData: UpdateMyDevicesInProgress(),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final MyDevicesState state = snapshot.data!;

              final bool updateMyDevicesInProgress =
                  state is UpdateMyDevicesInProgress;
              final bool errorUpdate = state is ErrorUpdate;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              if (updateMyDevicesInProgress) return _buildLoadingView();
              if(errorUpdate) return _errorUpdateMessage();
              return (_viewModel.list == null || _viewModel.list?.length == 0)
                  ? _noDevices()
                  : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10),
                //primary: false,
                shrinkWrap: true,

                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return AppDeviceCard(device: _viewModel.list![index]);
                },
                itemCount: _viewModel.list!.length,
              );
            }),
      ),
    );
  }

  Widget _noDevices() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              LocaleKeys.all_no_devices.tr(),
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(children: [
            SizedBox(width: 16,),
            Expanded(
              child: AppButton(
                  text: LocaleKeys.all_add_device.tr(),
                  onPressed: openNewDevicePage),
            ),
            SizedBox(width: 16,),
          ])
        ],
      ),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _viewModel.updateMyDevices();
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        height: 36,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void openNewDevicePage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewDevicePage()),
    );
  }


  Widget _errorUpdateMessage(){
    return Container(child: Text("Error update data"),);
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
