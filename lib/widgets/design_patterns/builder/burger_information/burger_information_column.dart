import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';
import '../../../../design_patterns/builder/builder.dart';
import 'burger_information_label.dart';

class BurgerInformationColumn extends StatelessWidget {
  final Burger burger;

  const BurgerInformationColumn({
    required this.burger,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const BurgerInformationLabel('Pret'),
        Text(burger.getFormattedPrice()),
        const SizedBox(height: LayoutConstants.spaceM),
        const BurgerInformationLabel('Ingrediente'),
        Text(
          burger.getFormattedIngredients(),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: LayoutConstants.spaceM),
        const BurgerInformationLabel('Alergenti'),
        Text(
          burger.getFormattedAllergens(),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
