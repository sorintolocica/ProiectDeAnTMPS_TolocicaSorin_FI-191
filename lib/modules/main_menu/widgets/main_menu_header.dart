import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/heartbeat_animation.dart';
import '../../../helpers/helpers.dart';

class MainMenuHeader extends StatelessWidget {
  const MainMenuHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > LayoutConstants.screenDesktop;
        final headerText = isDesktop ? 'TMPS' : 'Learn App\nTMPS';

        return Column(
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: isDesktop
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headerText,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            const SizedBox(height: LayoutConstants.spaceM),
            Row(
              mainAxisAlignment: isDesktop
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Proiect de an',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            const SizedBox(height: LayoutConstants.spaceL),
            RichText(
              text: TextSpan(
                text: 'Creator: ',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  TextSpan(
                    text: 'Tolocica Sorin',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 134, 80, 88),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => UrlLauncher.launchUrl(
                            '',
                          ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
