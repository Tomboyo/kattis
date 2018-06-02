package com.github.tomboyo.wheresmyinternet;

import static org.junit.Assert.*;

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

  @Test
  public void noCables() throws Exception {
    Solution solution = new Solution(
        streamSample("no-cables"),
        pipedOut);
    solution.run();

    String result = readToString(pipedIn);
    assertTrue(result.contains("1"));
    assertTrue(result.contains("2"));
    assertTrue(result.contains("3"));
    assertEquals(3, result.split(System.lineSeparator()).length);
  }

  @Test
  public void connected() throws Exception {
    Solution solution = new Solution(
        streamSample("connected"),
        pipedOut);
    solution.run();

    String result = readToString(pipedIn);
    assertEquals("Connected", result);
  }

  @Test
  public void spanning() throws Exception {
    Solution solution = new Solution(
        streamSample("spanning"),
        pipedOut);
    solution.run();

    String result = readToString(pipedIn);
    assertEquals("Connected", result);
  }

  @Test
  public void houses5And6Disconnected() throws Exception {
    Solution solution = new Solution(
        streamSample("5-6-disconnected"),
        pipedOut);
    solution.run();

    String result = readToString(pipedIn);
    assertTrue(result.contains("5"));
    assertTrue(result.contains("6"));
    assertEquals(2, result.split(System.lineSeparator()).length);
  }

  @Test
  public void largeNonConnected() throws Exception {
    Solution solution = new Solution(
        streamSample("large-nonconnected"),
        pipedOut);
    solution.run();

    String result = readToString(pipedIn);
    assertTrue(result.contains("2"));
    assertTrue(result.contains("3"));
    assertTrue(result.contains("4"));
    assertTrue(result.contains("5"));
    assertTrue(result.contains("6"));
    assertEquals(5, result.split(System.lineSeparator()).length);
  }

  private InputStream streamSample(String fileName) throws FileNotFoundException {
    return new FileInputStream(
        Paths.get(
            System.getProperty("com.github.tomboyo.samples.path"),
            fileName)
        .toFile());
  }

  private String readToString(InputStream is) {
    return new BufferedReader(new InputStreamReader(is))
        .lines()
        .collect(Collectors.joining(System.lineSeparator()));
  }
}
