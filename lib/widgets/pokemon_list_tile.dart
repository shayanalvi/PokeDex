import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_riverpod/models/pokemon.dart';
import 'package:pokedex_riverpod/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemons;

  PokemonListTile({
    required this.pokemonURL,
  });
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    _favoritePokemonsProvider = ref.watch(
      favoritePokemonsProvider.notifier,
    );
    _favoritePokemons = ref.watch(
      favoritePokemonsProvider,
    );
    final pokemon = ref.watch(
      pokemonDataProvider(
        pokemonURL,
      ),
    );

    return pokemon.when(data: (data) {
      return _tile(
        context,
        false,
        data,
      );
    }, error: (error, StackTrace) {
      return Text("Error: $error");
    }, loading: () {
      return _tile(
        context,
        true,
        null,
      );
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  pokemon.sprites!.frontDefault!,
                ),
              )
            : CircleAvatar(),
        title: Text(
          pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Currenty loading name for pokemon",
        ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0}moves"),
        trailing: IconButton(
          onPressed: () {
            if (_favoritePokemons.contains(pokemonURL)) {
              _favoritePokemonsProvider.removeFavoritePokemon(
                pokemonURL,
              );
            } else {
              _favoritePokemonsProvider.addFavoritePokemon(
                pokemonURL,
              );
            }
          },
          icon: Icon(
            _favoritePokemons.contains(pokemonURL)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
