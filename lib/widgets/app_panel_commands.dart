import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/commands.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/text_command.dart';
import 'package:flutter_app/widgets/app_command_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';


class AppPanelCommands extends StatelessWidget {
  final List<Commands> commands;
  final Function(Commands) listener;

  AppPanelCommands(this.commands, this.listener);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 9, left: 10),
            child: Text(
              LocaleKeys.all_commands.tr(),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Theme.of(context).primaryColor,
            child: ListView.separated(
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
                return AppCommandButton(
                  command: commands[index],
                  color: Theme.of(context).buttonColor,
                  image: "assets/images/share.svg",
                  onTap: (){
                    listener.call(commands[index]);
                  },
                );
              },
              itemCount: commands.length,
            ),
          )
        ],
      ),
    );
  }

}
