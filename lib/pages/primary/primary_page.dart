import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_page.dart';
import 'package:flutter_app/pages/primary/settings/settings_page.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class PrimaryPage extends StatefulWidget {
  final int? currentTab;

  const PrimaryPage({Key? key, this.currentTab}) : super(key: key);

  @override
  _PrimaryPage createState() => _PrimaryPage();
}

class _PrimaryPage extends State<PrimaryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.currentTab != null)
      _tabController = TabController(
          initialIndex: widget.currentTab!, length: 2, vsync: this);
    else
      _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          MyDevicesPage(),
          SettingsPage(),
        ],
        // If you want to disable swiping in tab the use below code
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
      ),
      bottomNavigationBar: Container(
        height: 56 + MediaQuery
            .of(context)
            .padding
            .bottom,
        //color: Color.fromRGBO(38, 50, 56, 1),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Container(
            padding:
            EdgeInsets.only(bottom: MediaQuery
                .of(context)
                .padding
                .bottom),
            color: Color.fromRGBO(38, 50, 56, 1),
            child: TabBar(
              labelColor: Color.fromRGBO(255, 255, 255, 1),
              unselectedLabelColor: Color.fromRGBO(155, 161, 164, 1),
              labelStyle: TextStyle(fontSize: 10.0),
              indicator: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(38, 50, 56, 1),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(6), // Creates border
                color: Color.fromRGBO(151, 151, 151, 1),
              ),

              //For Indicator Show and Customization
              //indicatorColor: Colors.black54,
              tabs: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sim_card),
                    Text(
                      LocaleKeys.all_devices.tr(),
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline),
                    Text(
                      LocaleKeys.menu_settings.tr(),
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}
