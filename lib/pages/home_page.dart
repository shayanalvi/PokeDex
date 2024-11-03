import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_riverpod/controllers/home_page_controller.dart';
import 'package:pokedex_riverpod/models/page_data.dart';
import 'package:pokedex_riverpod/models/pokemon.dart';
import 'package:pokedex_riverpod/providers/pokemon_data_providers.dart';
import 'package:pokedex_riverpod/widgets/pokemon_card.dart';
import 'package:pokedex_riverpod/widgets/pokemon_list_tile.dart';
import 'package:riverpod/riverpod.dart';

final HomePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(
    HomePageData.initial(),
  );
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonsListScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonsListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonsListScrollController.removeListener(_scrollListener);
    _allPokemonsListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonsListScrollController.offset >=
            _allPokemonsListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonsListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(HomePageControllerProvider.notifier);
    _homePageData = ref.watch(
      HomePageControllerProvider,
    );
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    return Scaffold(
      body: _buildUI(
        context,
      ),
    );
  }

  Widget _buildUI(
    BuildContext context,
  ) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _favoritePokemonsList(
              context,
            ),
            _allPokmonsList(
              context,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _favoritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Favorites",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.50,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemons.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _favoritePokemons.length,
                        itemBuilder: (context, index) {
                          String pokemonURL = _favoritePokemons[index];
                          return PokemonCard(
                            pokemonURL: pokemonURL,
                          );
                        }),
                  ),
                if (_favoritePokemons.isEmpty)
                  const Text("No fave Pokemons yet! :("),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allPokmonsList(
    BuildContext context,
  ) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
                controller: _allPokemonsListScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return PokemonListTile(
                    pokemonURL: pokemon.url!,
                  );
                }),
          )
        ],
      ),
    );
  }
}
