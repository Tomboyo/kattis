package com.github.tomboyo;

import static java.util.stream.Collectors.joining;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;

public final class Streams {

  private Streams() {}

  public static InputStream streamResource(
      Class<?> context,
      String fileName
  ) throws FileNotFoundException {
    return context.getResourceAsStream(fileName);
  }

  public static String readToString(
      InputStream is
  ) {
    return new BufferedReader(new InputStreamReader(is))
        .lines()
        .collect(joining(System.lineSeparator()));
  }
}