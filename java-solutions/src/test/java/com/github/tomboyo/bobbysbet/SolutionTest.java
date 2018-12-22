package com.github.tomboyo.bobbysbet;

import static com.github.tomboyo.Streams.readToString;
import static com.github.tomboyo.Streams.streamResource;
import static java.util.stream.Collectors.joining;
import static org.junit.Assert.assertEquals;

import java.io.InputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.util.Arrays;

import org.junit.Test;

public class SolutionTest {

  @Test
  public void takeBet_GoodBet1()
      throws Exception {
    assertInputFileGarnersResult("good-bet-1", "yes");
  }

  @Test
  public void takeBet_GoodBet2()
      throws Exception {
    assertInputFileGarnersResult("good-bet-2", "yes");
  }

  @Test
  public void takeBet_GoodBet3()
      throws Exception {
    assertInputFileGarnersResult("good-bet-3", "yes");
  }

  private void assertInputFileGarnersResult(
      String fileName,
      String expected
  ) throws Exception {
    PipedInputStream pipedIn = new PipedInputStream();
    PipedOutputStream pipedOut = new PipedOutputStream(pipedIn);

    createSolution(fileName, pipedOut).run();

    String result = readToString(pipedIn);
    pipedOut.close();
    pipedIn.close();
    assertEquals(expected, result);
  }

  private Runnable createSolution(
    String sampleFile,
    PipedOutputStream pipedOut
  ) throws Exception {
    try {
      final InputStream in = streamResource(getClass(), sampleFile);
      return () -> Solution.run(in, pipedOut);
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  @Test
  public void rejectBet_badBet1()
      throws Exception {
    assertInputFileGarnersResult("bad-bet-1", "no");
  }

  @Test
  public void rejectBet_badBet2()
      throws Exception {
    assertInputFileGarnersResult("bad-bet-2", "no");
  }

  @Test
  public void handleManyCases()
      throws Exception {
    String expected = Arrays.asList(
      "no", "yes", "yes", "no", "yes"
    ).stream().collect(joining(System.lineSeparator()));

    assertInputFileGarnersResult("5-tests", expected);
  }
}