package com.github.tomboyo.wheresmyinternet;

import static com.github.tomboyo.Streams.readToString;
import static com.github.tomboyo.Streams.streamResource;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.util.function.Consumer;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.Timeout;

public class SolutionTest {

  @Rule
  public Timeout globalTimeout = Timeout.seconds(1);

  @Test
  public void noCables() throws Exception {
    withSolutionForSample("no-cables", result -> {
      assertTrue(result.contains("1"));
      assertTrue(result.contains("2"));
      assertTrue(result.contains("3"));
      assertContainsNLines(3, result);
    });
  }

  private void withSolutionForSample(
      String sampleFile,
      Consumer<String> assertionsOnResult
  ) throws Exception {
    PipedInputStream pipedIn = new PipedInputStream();
    PipedOutputStream pipedOut = new PipedOutputStream(pipedIn);

    createSolution(sampleFile, pipedOut).run();
    assertionsOnResult.accept(readToString(pipedIn));

    pipedIn.close();
    pipedOut.close();
  }

  private Solution createSolution(
      String sampleFile,
      PipedOutputStream pipedOut
  ) throws Exception {
    return new Solution(
        streamResource(getClass(), sampleFile),
        pipedOut);
  }

  private void assertContainsNLines(int lines, String subject) {
    assertEquals(lines, subject.split(System.lineSeparator()).length);
  }

  @Test
  public void connected() throws Exception {
    withSolutionForSample("connected", result -> {
      assertEquals("Connected", result);
    });
  }

  @Test
  public void spanning() throws Exception {
    withSolutionForSample("spanning", result -> {
      assertEquals("Connected", result);
    });
  }

  @Test
  public void houses5And6Disconnected() throws Exception {
    withSolutionForSample("5-6-disconnected", result -> {
      assertTrue(result.contains("5"));
      assertTrue(result.contains("6"));
      assertContainsNLines(2, result);
    });
  }

  @Test
  public void largeNonConnected() throws Exception {
    withSolutionForSample("large-nonconnected", result -> {
      assertTrue(result.contains("2"));
      assertTrue(result.contains("3"));
      assertTrue(result.contains("4"));
      assertTrue(result.contains("5"));
      assertTrue(result.contains("6"));
      assertContainsNLines(5, result);
    });
  }

  @Test
  public void maximalDisjointGraphs() throws Exception {
    withSolutionForSample("maximal-disjoint-1", result -> {
      assertTrue(result.contains("5"));
      assertContainsNLines(1, result);
    });

    withSolutionForSample("maximal-disjoint-2", result -> {
      assertTrue(result.contains("2"));
      assertTrue(result.contains("3"));
      assertTrue(result.contains("4"));
      assertTrue(result.contains("5"));
      assertContainsNLines(4, result);
    });
  }
}
