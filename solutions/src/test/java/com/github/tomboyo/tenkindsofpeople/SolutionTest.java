package com.github.tomboyo.tenkindsofpeople;

import static com.github.tomboyo.Streams.*;

import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.util.Arrays;
import static java.util.stream.Collectors.joining;
import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class SolutionTest {
  
  @Test
  public void testSample() throws Exception {
    PipedInputStream pipedIn = new PipedInputStream();
    PipedOutputStream pipedOut = new PipedOutputStream(pipedIn);
    
    createSolution("sample", pipedOut).run();

    String expected = Arrays.asList(
        "binary", "decimal", "neither"
    ).stream()
        .collect(joining(System.lineSeparator()));

    assertEquals(expected, readToString(pipedIn));
  }

  private Solution createSolution(
      String sampleFile,
      PipedOutputStream pipedOut
  ) throws Exception {
    return new Solution(
        streamResource(getClass(), sampleFile),
        pipedOut);
  }
}