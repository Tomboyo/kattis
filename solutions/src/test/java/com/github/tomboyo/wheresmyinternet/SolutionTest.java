package com.github.tomboyo.wheresmyinternet;

import static org.junit.Assert.*;
import static com.github.tomboyo.Streams.*;

import java.io.*;
import java.nio.file.Paths;
import java.util.stream.Collectors;

import org.junit.*;
import org.junit.rules.Timeout;

public class SolutionTest {

  private PipedInputStream pipedIn;
  private PipedOutputStream pipedOut;

  @Rule
  public Timeout globalTimeout = Timeout.seconds(1);

  @Before
  public void setOutputStream() throws Exception {
    pipedIn = new PipedInputStream();
    pipedOut = new PipedOutputStream(pipedIn);
  }

  @After
  public void close() throws Exception {
    pipedIn.close();
    pipedOut.close();
  }

  private Solution createSolution(
      String sampleFile
  ) throws Exception {
    return new Solution(
        streamResource(getClass(), sampleFile),
        pipedOut);
  }

  @Test
  public void noCables() throws Exception {
    Solution solution = createSolution("no-cables");
    solution.run();

    String result = readToString(pipedIn);
    assertTrue(result.contains("1"));
    assertTrue(result.contains("2"));
    assertTrue(result.contains("3"));
    assertEquals(3, result.split(System.lineSeparator()).length);
  }

  @Test
  public void connected() throws Exception {
    Solution solution = createSolution("connected");
    solution.run();

    String result = readToString(pipedIn);
    assertEquals("Connected", result);
  }

  @Test
  public void spanning() throws Exception {
    Solution solution = createSolution("spanning");
    solution.run();

    String result = readToString(pipedIn);
    assertEquals("Connected", result);
  }

  @Test
  public void houses5And6Disconnected() throws Exception {
    Solution solution = createSolution("5-6-disconnected");
    solution.run();

    String result = readToString(pipedIn);
    assertTrue(result.contains("5"));
    assertTrue(result.contains("6"));
    assertEquals(2, result.split(System.lineSeparator()).length);
  }

  @Test
  public void largeNonConnected() throws Exception {
    Solution solution = createSolution("large-nonconnected");
    solution.run();

    String result = readToString(pipedIn);
    assertTrue(result.contains("2"));
    assertTrue(result.contains("3"));
    assertTrue(result.contains("4"));
    assertTrue(result.contains("5"));
    assertTrue(result.contains("6"));
    assertEquals(5, result.split(System.lineSeparator()).length);
  }
}
