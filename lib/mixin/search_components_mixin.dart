import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/widgets/two_way_binding_builder.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

mixin SearchComponentsMixin {
  Widget searchField(BuildContext context) => TwoWayBindingBuilder<String>(
      binding: context.watch<SearchCubit>().searchBinding,
      builder: (
        context,
        controller,
        data,
        onChanged,
        error,
      ) =>
          TextField(
            // cursorHeight: 20,
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)?.label_search ?? "",
                error: Text(error?.localizedString(context) ?? "")),
          ));
}
