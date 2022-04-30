import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Pokemon>> fetchPokemons(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePokemon, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Pokemon> parsePokemons(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Pokemon>((json) => Pokemon.fromJson(json)).toList();
}

class Pokemon {
  final int id;
  final String name;

  const Pokemon({
    required this.id,
    required this.name,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['title'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Pokémon API';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: fetchPokemons(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PokemonsList(pokemons: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PokemonsList extends StatelessWidget {
  const PokemonsList({Key? key, required this.pokemons}) : super(key: key);

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          onLongPress: () {},
          leading: CircleAvatar(
            backgroundImage: NetworkImage(pokemons[index].name),
            radius: 30,
          ),
          title: Text(pokemons[index].name),
          subtitle: Text('${pokemons[index].name}'),
          //isThreeLine: true,
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
