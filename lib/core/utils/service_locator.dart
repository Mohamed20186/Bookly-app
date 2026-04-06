import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/core/utils/api_service.dart';
import 'package:test_app/features/home/data/repos/home_repo_imp.dart';


final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<ApiService>(ApiService(getIt<Dio>()));
  getIt.registerSingleton<HomeRepoImp>(HomeRepoImp(getIt<ApiService>()));
}
