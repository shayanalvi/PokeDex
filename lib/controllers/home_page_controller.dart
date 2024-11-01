import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_riverpod/models/page_data.dart';
import 'package:pokedex_riverpod/models/pokemon.dart';
import 'package:pokedex_riverpod/services/http_services.dart';
import 'package:riverpod/riverpod.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getit = GetIt.instance;

  late HttpServices _httpService;
  HomePageController(
    super._state,
  ) {
    _httpService = _getit.get<HttpServices>();
    _setup();
  }

  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpService.get(
        "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0",
      );
      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(
          data: data,
        );
        print(state.data?.results?.first);
      }
    } else {}
  }
}
