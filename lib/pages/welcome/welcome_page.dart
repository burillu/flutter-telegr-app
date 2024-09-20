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
        child: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FaIcon(
                Icons.telegram,
                size: 128,
                color: Colors.cyan,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: [
                    Text(
                      "Telegram",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "L' app di Messaggistica piu veloce al mondo e piu sicura!",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  Widget _slideIndicator() => Container();
}
