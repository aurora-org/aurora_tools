import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({Key? key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          '${pair.first} ${pair.second}',
          style: style,
        ),
      ),
    );
  }
}
