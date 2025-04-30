import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmortyverse/blocs/theme/theme_cubit.dart';
import 'blocs/character_bloc/character_bloc.dart';
import 'repositories/character_repository.dart';
import 'ui/screens/characters_screen.dart';
import 'ui/screens/favorites_screen.dart';
import 'storage/local_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/character.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Hive.initFlutter();
  }

  Hive.registerAdapter<Character>(CharacterAdapter());
  await LocalStorage().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = CharacterRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  CharacterBloc(repository)..add(FetchCharactersEvent()),
        ),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: const RickMortyApp(),
    );
  }
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Rick & Morty Verse',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final screens = [CharactersScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Персонажи'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Избранное'),
        ],
      ),
    );
  }
}
