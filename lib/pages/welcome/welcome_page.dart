import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_sliderContainer(context), _startMessagingButton(context)],
        ),
      ),
    );
  }

  Widget _sliderContainer(BuildContext context) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _slide(context),
            _slideIndicator(),
          ],
        ),
      );

  Widget _startMessagingButton(BuildContext context) => ElevatedButton(
      onPressed: () {},
      child: Text(AppLocalizations.of(context)?.action_start_chatting ?? ""));

  Widget _slide(BuildContext context) => Container(
        height: 400,
        child: PageView.builder(
          itemBuilder: (context, index) => Container(
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _itemContent(context)[index]['icon'],
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        Text(
                          _itemContent(context)[index]['header'],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          _itemContent(context)[index]['description'],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget _slideIndicator() => Container();

  List _itemContent(BuildContext context) => [
        {
          "icon": FaIcon(
            FontAwesomeIcons.telegram,
            size: 128,
            color: Colors.cyan,
          ),
          "header": AppLocalizations.of(context)?.welcome_header1,
          "description": AppLocalizations.of(context)?.welcome_description1
        },
        {
          "icon": FaIcon(
            FontAwesomeIcons.rocketchat,
            size: 128,
            color: Colors.red,
          ),
          "header": AppLocalizations.of(context)?.welcome_header2,
          "description": AppLocalizations.of(context)?.welcome_description2
        },
        {
          "icon": FaIcon(
            FontAwesomeIcons.dollarSign,
            size: 128,
            color: Colors.green,
          ),
          "header": AppLocalizations.of(context)?.welcome_header3,
          "description": AppLocalizations.of(context)?.welcome_description3
        },
        {
          "icon": FaIcon(
            FontAwesomeIcons.boltLightning,
            size: 128,
            color: Colors.pink,
          ),
          "header": AppLocalizations.of(context)?.welcome_header4,
          "description": AppLocalizations.of(context)?.welcome_description4
        },
        {
          "icon": FaIcon(
            FontAwesomeIcons.lock,
            size: 128,
            color: Colors.orange,
          ),
          "header": AppLocalizations.of(context)?.welcome_header5,
          "description": AppLocalizations.of(context)?.welcome_description5
        },
        {
          "icon": FaIcon(
            FontAwesomeIcons.cloud,
            size: 128,
            color: Colors.grey,
          ),
          "header": AppLocalizations.of(context)?.welcome_header6,
          "description": AppLocalizations.of(context)?.welcome_description6
        }
      ];
}
