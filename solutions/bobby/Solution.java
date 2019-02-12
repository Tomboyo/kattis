package bobbysbet;

import java.io.*;
import java.util.stream.Stream;
import java.util.function.Function;

import com.kattis.open.Kattio;

public final class Solution {

  private Solution() {}

  public static void main(String[] args) {
    Solution.run(System.in, System.out);
  }

  public static void run(InputStream in, OutputStream out) {
    Kattio kattio = new Kattio(in, out);
    final int linesOfInput = kattio.getInt();
    Stream
      .generate(() -> new Input(
        kattio.getInt(),
        kattio.getInt(),
        kattio.getInt(),
        kattio.getInt(),
        kattio.getInt()
      ))
      .limit(linesOfInput)
      .map(Solution::solve)
      .forEach(solution -> kattio.println(solution));
    kattio.close();
  }

  static class Input {
    public final int minimumRoll;
    public final int sidesOnDie;
    public final int minimumSuccesses;
    public final int maximumRolls;
    public final int payoff;

    Input(
      int minimumRoll,
      int sidesOnDie,
      int minimumSuccesses,
      int maximumRolls,
      int payoff
    ) {
      this.minimumRoll = minimumRoll;
      this.sidesOnDie = sidesOnDie;
      this.minimumSuccesses = minimumSuccesses;
      this.maximumRolls = maximumRolls;
      this.payoff = payoff;
    }
  }

  public static String solve(Input input) {
    double estimatedSuccesses = estimatedNumberOfSuccesses(
      input.sidesOnDie,
      input.minimumRoll,
      input.maximumRolls,
      input.minimumSuccesses
    );

    if (isGoodBet(estimatedSuccesses, input.payoff))
      return "yes";
    else
      return "no";
  }

  private static boolean isGoodBet(
    double estimatedSuccesses,
    int payoff
  ) {
    return estimatedSuccesses * payoff > 1.0;
  }

  private static double estimatedNumberOfSuccesses(
    int sidesOnDie,
    int minimumRoll,
    int maximumRolls,
    int minimumSuccesses
  ) {
    double rollSuccessProbability = rollSuccessProbability(
        sidesOnDie,
        minimumRoll);
    double rollFailureProbability = 1 - rollSuccessProbability;

    return summation(minimumSuccesses, maximumRolls, (k) -> {
      return nChooseK(maximumRolls, k)
          * Math.pow(rollSuccessProbability, k)
          * Math.pow(rollFailureProbability, maximumRolls - k);
    });
  }

  private static double summation(
      int from,
      int to,
      Function<Integer, Double> f
  ) {
    double sum = 0;
    for (int i = from; i <= to; i++) {
      sum += f.apply(i);
    }
    return sum;
  }

  private static double rollSuccessProbability(
      int sides,
      int minimum
  ) {
    return (double)(sides - minimum + 1) / sides;
  }

  private static long nChooseK(
      int n,
      int k
  ) {
    long result = (factorial(n) / factorial(k)) / factorial(n - k);
    return result;
  }

  private static long factorial(
      int n
  ) {
    long total = 1;
    for (int i = 2; i <= n; i++)
      total *= i;
    return total;
  }
}
