// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


const key = '';

class Restaurant {
  final String name;
  final double rating;
  final String address;


  Restaurant.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        rating = jsonMap['rating'].toDouble(),
        address = jsonMap['vicinity'];
}


Future<Stream<Restaurant>> getPlaces() {
  return key.length > 0 ? getPlacesFromNetwork() : getPlacesFromAsset();
}


Future<Stream<Restaurant>> getPlacesFromNetwork() async {
  var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  var client = new http.Client();
  var streamedRes = await client.send(new http.Request('get', Uri.parse(url)));

  return streamedRes.stream
      .transform(UTF8.decoder)
      .transform(JSON.decoder)
      .expand((jsonBody) => (jsonBody as Map)['results'])
      .map((jsonPlace) => new Restaurant.fromJson(jsonPlace));
}


Future<Stream<Restaurant>> getPlacesFromAsset() async {
  return new Stream.fromFuture(rootBundle.loadString('assets/places.json'))
      .transform(json.decoder)
      .expand((jsonBody) => (jsonBody as Map)['results'])
      .map((jsonPlace) => new Restaurant.fromJson(jsonPlace));
}