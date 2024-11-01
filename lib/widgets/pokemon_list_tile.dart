import 'package:flutter/material.dart';

class PokemonListTile extends StatelessWidget {
  final String pokemonURL;

  PokemonListTile({
    required this.pokemonURL,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _tile(
      context,
    );
  }

  Widget _tile(BuildContext context) {
    return ListTile(
      title: Text(pokemonURL),
    );
  }
}
