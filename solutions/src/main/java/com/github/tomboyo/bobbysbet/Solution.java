package com.github.tomboyo.bobbysbet;

import com.kattis.open.Kattio;
import java.io.*;
import java.util.function.Function;

public class Solution {
  private Kattio kattio;

  Solution() {
    this(System.in, System.out);
  }

  Solution(InputStream input, OutputStream output) {
    this.kattio = new Kattio(input, output);
  }

  public static void main(String[] args) {
    new Solution().run();
  }

  public void run() {
    int numberOfCases = kattio.getInt();
    while (numberOfCases-- > 0) {
      printOutputForNextCase();
    }

    kattio.close();
  }

  private void printOutputForNextCase() {
    int minimumRoll = kattio.getInt();
    int sidesOnDie = kattio.getInt();
    int minimumSuccesses = kattio.getInt();
    int maximumRolls = kattio.getInt();
    int payoff = kattio.getInt();

    if (isGoodBet(
        estimatedNumberOfSuccesses(
            sidesOnDie,
            minimumRoll,
            maximumRolls,
            minimumSuccesses),
        payoff))
      kattio.println("yes");
    else
      kattio.println("no");
  }

  static boolean isGoodBet(
    double estimatedSuccesses,
    int payoff
  ) {
    return estimatedSuccesses * payoff > 1.0;
  }

  static double estimatedNumberOfSuccesses(
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
      Function<Integer, Double> f) {
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