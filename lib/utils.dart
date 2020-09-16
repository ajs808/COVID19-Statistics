import 'dart:convert' as convert;
import 'dart:math';


import 'package:english_words/english_words.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// This file has a number of platform-agnostic non-Widget utility functions.
//TODO: Add theme customizability
const _myListOfRandomColors = [
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.pink,
  Colors.orange,
  Colors.blueGrey,
];

final _random = Random();

// Avoid customizing the word generator, which can be slow.
// https://github.com/filiph/english_words/issues/9
final wordPairIterator = generateWordPairs();

String generateRandomHeadline() {
  final artist = capitalizePair(wordPairIterator.first);

  switch (_random.nextInt(10)) {
    case 0:
      return '$artist says ${nouns[_random.nextInt(nouns.length)]}';
    case 1:
      return '$artist arrested due to ${wordPairIterator.first.join(' ')}';
    case 2:
      return '$artist releases ${capitalizePair(wordPairIterator.first)}';
    case 3:
      return '$artist talks about his ${nouns[_random.nextInt(nouns.length)]}';
    case 4:
      return '$artist talks about her ${nouns[_random.nextInt(nouns.length)]}';
    case 5:
      return '$artist talks about their ${nouns[_random.nextInt(nouns.length)]}';
    case 6:
      return '$artist says their music is inspired by ${wordPairIterator.first.join(' ')}';
    case 7:
      return '$artist says the world needs more ${nouns[_random.nextInt(nouns.length)]}';
    case 8:
      return '$artist calls their band ${adjectives[_random.nextInt(adjectives.length)]}';
    case 9:
      return '$artist finally ready to talk about ${nouns[_random.nextInt(nouns.length)]}';
  }

  assert(false, 'Failed to generate news headline');
  return null;
}

List<MaterialColor> getRandomColors(int amount) {
  return List<MaterialColor>.generate(amount, (index) {
    return _myListOfRandomColors[_random.nextInt(_myListOfRandomColors.length)];
  });
}

List<String> getRandomNames(int amount) {
  return wordPairIterator
      .take(amount)
      .map((pair) => capitalizePair(pair))
      .toList();
}

//TODO: change array to map
//TODO: Allow for rearrangement of cards
Future<List<String>> getValues(int amount) async{
  List<String> res = new List(amount);
  var url = 'https://disease.sh/v3/covid-19/all';
  var response = await http.get(url);
  if (response.statusCode == 200) {

    dynamic jsonResponse = convert.jsonDecode(response.body);
    dynamic cur = jsonResponse['cases'];
    res[0] = '$cur';

    cur = jsonResponse['deaths'];
    res[1] = '$cur';

    cur = jsonResponse['recovered'];
    res[2] = '$cur';

    cur = jsonResponse['active'];
    res[3] = '$cur';

    cur = jsonResponse['todayCases'];
    res[4] = '$cur';

    cur = jsonResponse['todayDeaths'];
    res[5] = '$cur';
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  return res;

}

String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}
