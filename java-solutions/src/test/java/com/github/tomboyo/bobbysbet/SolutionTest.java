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
  public void takeGoodBet_1() {
    /**
     * Must roll 5 or higher on 6 sides
     * at least 2 out of three rolls.
     * Payoff is 4 times investment.
     * 
     * Hit: 1/3 chance, Miss: 2/3 chance
     * Ways to win: 2 or 3 hits on 3 dice
     *   2 hits:
     *     probability is (1/3)**2 * (2/3)**1 = 2/27
     *     3 choose 2 = 3 ways
     *     expected occurrences: 3 * 2/27 = 6/27
     *   3 hits:
     *     probability is (1/3)**3 = 1/27
     *     3 choose 3 = 1 way
     *     expected occurrences: 1 * 1/27 = 1/27.
     *   total: 7/27 expected occurrences.
     * 
     * Our payoff is 4 times our investment.
     * If we win 7/27 attempts, we earn 4 * 7/27 = 28/27,
     * which is more than we invested.
     * 
     * This is a good bet.
     */
    Solution.Input input = new Solution.Input(
      5, // minimum roll
      6, // sides on die
      2, // minimum successes
      3, // maximum rolls
      4  // payoff
    );

    assertEquals("yes", Solution.solve(input));
  }

  @Test
  public void takeGoodBet_2() {
    /**
     * Must roll 2 on 2-sided die
     * at least 9 out of 10 rolls
     * when payoff is 100 times investment.
     * 
     * Hit: 0.5, Miss: 0.5
     * Ways to win: 9 or 10 hits on 10 dice
     *   9 hits:
     *     probability is (1/2)**9 * (1/2)**1 = 1/1024
     *     10 choose 9 = 10 ways
     *     expected occurrences: 10 * 1/1024 = 10/1024
     *   10 hits:
     *     probablility is (1/2)**10 = 1/1024
     *     10 choose 10 = 1 ways
     *     expected occurrences: 1/1024
     *   total 11/1024 expected occurrences.
     * 
     * Our payoff is 100 times our investment.
     * If we win 11/1024 attempts, we earn 100 * 11/1024 = 1100/1024,
     * which is more than we invested.
     * 
     * This is a good bet.
     */
    Solution.Input input = new Solution.Input(
      2, // minimum roll
      2, // sides on die
      9, // minimum successes
      10, // maximum rolls
      100  // payoff
    );

    assertEquals("yes", Solution.solve(input));
  }

  @Test
  public void takeSureBet() {
    /**
     * We can roll anything on the die, so we have a 100% chance of winning.
     * Since the payoff is more than our investment, we make money.
     * 
     * This is a good bet.
     */
    Solution.Input input = new Solution.Input(
      1, // minimum roll
      2, // sides on die
      10, // minimum successes
      10, // maximum rolls
      2  // payoff
    );

    assertEquals("yes", Solution.solve(input));
  }

  @Test
  public void rejectBadBet_1() {
    /**
     * This is similar to GoodBet_1, but the payoff isn't high enough.
     * 
     * Must roll 5 or 6 on 6-sided die
     * at least 2 out of 3 rolls
     * when payoff is 3 times investment.
     * 
     * Hit: 1/3, Miss: 2/3
     * Ways to win: 2 or 3 hits on 3 dice
     *   2 hits:
     *     probability is (1/3)**2 * (2/3)**1 = 2/27
     *     2 choose 3 = 3 ways
     *     expected occurrences: 3 * 2/27 = 6/27
     *   3 hits:
     *     probablility is (1/3)**10 = 1/27
     *     3 choose 3 = 1 ways
     *     expected occurrences: 1 * 1/27 = 1/27
     *   total 7/27 expected occurrences.
     * 
     * Our payoff is 3 times our investment.
     * If we win 7/27 attempts, we earn 3 * 7/27 = 21/27,
     * which is less than we invested.
     * 
     * This is a bad bet.
     */
    Solution.Input input = new Solution.Input(
      5, // minimum roll
      6, // sides on die
      2, // minimum successes
      3, // maximum rolls
      3  // payoff
    );

    assertEquals("no", Solution.solve(input));
  }

  @Test
  public void rejectBreakEvenBet() {
    /**
     * We can roll anything on the die, which gives us a 100% chance of winning.
     * But our payoff is exactly our investment, so we will not earn money.
     * 
     * This is a bad bet.
     */
    Solution.Input input = new Solution.Input(
      1, // minimum roll
      2, // sides on die
      10, // minimum successes
      10, // maximum rolls
      1  // payoff
    );

    assertEquals("no", Solution.solve(input));
  }

  /**
   * Test the above five cases piped from a text file.
   * This ensures the solution is reading and writing in the expected format.
   */
  @Test
  public void evaluatesInputStream() throws Exception {
    try(
      InputStream in = streamResource(getClass(), "5-tests");
      PipedInputStream pipedIn = new PipedInputStream();
      PipedOutputStream pipedOut = new PipedOutputStream(pipedIn);
    ) {
      Solution.run(in, pipedOut);
      String actual = readToString(pipedIn);
      String expected = Arrays.asList(
        "no", "yes", "yes", "no", "yes"
      ).stream().collect(joining(System.lineSeparator()));

      assertEquals(expected, actual);
    }
  }
}