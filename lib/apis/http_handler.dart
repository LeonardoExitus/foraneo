import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpHandler {
  static Future<CustomResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    int timeOutseconds = 120,
  }) async {
    late CustomResponse customResponse;

    try {
    await http
        .post(
      Uri.parse(url),
      headers: headers ??
          {
            "Content-Type": "application/json",
            "charset": "UTF-8",
            "Accept": "application/json; charset=utf-8",
          },
      body: body,
    )
        .timeout(
      Duration(seconds: timeOutseconds),
      onTimeout: () {
        final response = http.Response(
              '{"error":true, "message": "Tiempo de carga"}', 404);
        customResponse = CustomResponse(response: response);
        return response;
      },
    ).then((response) {
      if (kDebugMode) {
        print("Estatus peticion: ${response.statusCode}");
      }
      customResponse = CustomResponse(response: response);
      return customResponse;
    });

    return customResponse;
  } on SocketException {
      return CustomResponse(
          response:
              http.Response('{"error":true, "message": "Mala conexión"}', 404));
    } on HttpException {
      return CustomResponse(
          response: http.Response(
              '{"error":true, "message": "No responde el servidor"}', 404));
    } on FormatException {
      return CustomResponse(
          response: http.Response(
              '{"error":true, "message": "Algo salio mal"}', 404));
    }
  }

  static Future<CustomResponse> get(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {

    try {
    final response = await http
        .get(
          Uri.parse(url),
          headers: headers ??
              {
                "Content-Type": "application/json",
                "charset": "UTF-8",
                "Accept": "application/json; charset=utf-8",
              },
        )
        .timeout(const Duration(seconds: 120));

    return CustomResponse(
      response: (response),
      error: response.statusCode != 200 ? true : false,
    );
    } on SocketException {
      return CustomResponse(
          response: http.Response(
              '{"error":true, "message": "Sin conexión a internet"}', 404));
    } on HttpException {
      return CustomResponse(
          response: http.Response(
              '{"error":true, "message": "Problema con el servidor"}', 404));
    } on FormatException {
      return CustomResponse(
          response: http.Response(
              '{"error":true, "message": "No se encontro la consulta"}', 404));
    }
  }
}

class CustomResponse {
  final http.Response response;
  final bool error;

  const CustomResponse({required this.response, this.error = true});

  CustomResponse copyWith({
    http.Response? response,
    bool? error,
    String? msg,
  }) {
    return CustomResponse(
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}
