import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/cubits/welcome_cubit.dart';
import 'package:telegram_app/router/app_router.gr.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(_) {
    return _welcomeCubit(
      LayoutBuilder(builder: (context, _) {
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _sliderContainer(context),
                _startMessagingButton(context)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _welcomeCubit(child) => BlocProvider(
        create: (_) => WelcomeCubit(),
        child: child,
      );

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
      onPressed: () {
        context.router.push(SignInRoute());
      },
      child: Text(AppLocalizations.of(context)?.action_start_chatting ?? ""));

  Widget _slide(BuildContext context) => Container(
        height: 400,
        child: PageView.builder(
          controller: context.read<WelcomeCubit>().controller,
          itemCount: _itemContent(context).length,
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
  Widget _slideIndicator() =>
      BlocBuilder<WelcomeCubit, int>(builder: (context, page) {
        return Container(
          // width: double.maxFinite,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _itemContent(context).length,
                (index) => GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              index == page ? Colors.black87 : Colors.black38,
                        ))),
              )),
        );
      });

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
            FontAwesomeIcons.bolt,
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
