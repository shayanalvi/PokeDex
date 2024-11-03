import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_riverpod/providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonURL;

  PokemonStatsCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonURL),
    );

    return AlertDialog(
      backgroundColor: Colors.grey[900], // Dark background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      title: const Text(
        "Statistics",
        style: TextStyle(
          color: Colors.white, // White title text
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((s) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "${s.stat?.name?.toUpperCase()}: ${s.baseStat}",
                      style: const TextStyle(
                        color: Colors.white, // White text for stats
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) {
          return Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.red, // Red text for error messages
            ),
          );
        },
        loading: () => const CircularProgressIndicator(
          color: Colors.white, // White progress indicator
        ),
      ),
    );
  }
}
