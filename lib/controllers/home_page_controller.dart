import 'package:get_it/get_it.dart';
import 'package:pokedex_riverpod/models/page_data.dart';
import 'package:pokedex_riverpod/services/http_services.dart';
import 'package:riverpod/riverpod.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getit = GetIt.instance;

  late HttpServices _httpService;
  HomePageController(
    super._state,
  ) {
    _httpService = _getit.get<HttpServices>();
  }
}
