import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/device_detail.dart';
import 'package:flutter_app/pages/connections/connections_states.dart';
import 'package:flutter_app/pages/connections/connections_view.dart';
import 'package:flutter_app/pages/connections/connections_view_model.dart';
import 'package:flutter_app/pages/new_connection/new_connection_page.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_connected_device_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class ConnectionsPage extends StatefulWidget {
  final DeviceDetail deviceDetail;

  const ConnectionsPage({Key? key, required this.deviceDetail})
      : super(key: key);

  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _ConnectionsPageState extends State<ConnectionsPage>
    with NotificationsMixin
    implements ConnectionsView {
  late ConnectionsViewModel _viewModel;
  late ScrollController _controller;

  @override
  void initState() {
    _viewModel = ConnectionsViewModel(view: this);
    _viewModel.updateConnections(id: widget.deviceDetail.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionsState>(
        initialData: UpdateConnectionsInProgress(),
        stream: _viewModel.statesStream,
        builder: (context, snapshot) {
          final ConnectionsState state = snapshot.data!;

          final bool updateConnectionsInProgress =
              state is UpdateConnectionsInProgress;

          // updateConnectionsInProgress
          //     ? EasyLoading.show()
          //     : EasyLoading.dismiss();
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
                LocaleKeys.menu_connections.tr(),
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Theme.of(context).appBarTheme.color,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).toggleableActiveColor,
                    ),
                    onPressed: () {
                      openNewConnectionPage();
                    }),
                SizedBox(
                  width: 16,
                )
              ],
            ),
            body: (updateConnectionsInProgress)
                ? _buildLoadingView()
                : RefreshIndicator(
                    key: refreshKey,
                    onRefresh: refreshList,
                    child: (_viewModel.connectedDevices.length == 0)
                        ? _noConnectedDevices()
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            //primary: false,
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return AppConnectedDeviceCard(
                                  connectedDevice:
                                      _viewModel.connectedDevices[index]);
                            },
                            itemCount: _viewModel.connectedDevices.length,
                          )),
          );
        });
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        height: 36,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).buttonColor,
        ),
      ),
    );
  }

  Widget _noConnectedDevices() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              LocaleKeys.all_no_connected_devices.tr(),
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
                  text: LocaleKeys.all_add_connection.tr(),
                  onPressed: openNewConnectionPage),
            ),
            SizedBox(width: 16,),
          ])
        ],
      ),
    );
  }

  @override
  void openNewConnectionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewConnectionPage()),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _viewModel.updateConnections(id: widget.deviceDetail.id);
  }
}
