package com.github.tomboyo.wheresmyinternet;

import com.open.kattis.Kattio;
import java.util.List;
import java.util.LinkedList;
import java.util.Map;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;

/*
A new town is being built far out in the country, and currently there are N
houses. People have already started moving in. However, some of the houses
aren’t connected to the internet yet, and naturally residents are outraged.

The houses are numbered 1 to N. House number 1 has already been connected to the
internet via a long network cable to a neighboring town. The plan is to provide
internet to other houses by connecting pairs of houses with separate network
cables. A house is connected to the internet if it has a network cable to
another house that’s already connected to the internet.

Given a list of which pairs of houses are already connected by a network cable,
determine which houses are not yet connected to the internet.

Input
The first line of input contains two integers 1≤N,M≤200000, where N is the
number of houses and M is the number of network cables already deployed. Then
follow M lines, each containing a pair of house numbers 1≤a,b≤N meaning that
house number a and house number b are already connected by a network cable.
Each house pair is listed at most once in the input.

Output
If all the houses are already connected to the internet, output one line
containing the string Connected. Otherwise, output a list of house numbers
in increasing order, one per line, representing the houses that are not yet
connected to the internet.
*/
public class Solution {
  private int countHouses, countCables;
  private Map<Integer, List<Integer>> adj;
  private boolean[] connectedHouse; 
  private Kattio kattio;

  Solution() {
    this(System.in, System.out);
  }

  Solution(InputStream is, OutputStream os) {
    kattio = new Kattio(is, os);
  }

  public static void main(String[] args) {
    Solution solution = new Solution();
    solution.run();
  }

  void run() {
    readCounts();
    if (checkForTrivialCases()) {
      kattio.close();
      return;
    }
    readAdjacencies();
    breadthFirstSearchFromConnectedHouse();
    printDisconnected();
    kattio.close();
  }

  private void readCounts() {
    countHouses = kattio.getInt();
    countCables = kattio.getInt();
  }

  private boolean checkForTrivialCases() {
    if (countCables == 0) {
      for (int i = 1; i <= countHouses; i++)
        kattio.println(i);
      return true;
    }

    if (countCables == maximumEdges(countHouses, 2)) {
      printConnected();
      return true;
    }

    return false;
  }

  private int maximumEdges(int n, int k) {
    return (n * (n - 1)) / 2;
  }

  private void printConnected() {
    kattio.println("Connected");
  }

  private void readAdjacencies() {
    adj = new HashMap<>();
    for (int i = 0; i < countHouses; i++)
      adj.put(i, new LinkedList<>());
    for (int i = 0; i < countCables; i++)
      addEdge(kattio.getInt(), kattio.getInt());
  }

  private void addEdge(int from, int to) {
    adj.get(from - 1).add(to - 1);
    adj.get(to - 1).add(from - 1);
  }

  private void breadthFirstSearchFromConnectedHouse() {
    connectedHouse = new boolean[countHouses];
    connectedHouse[0] = true;
    List<Integer> horizon = new LinkedList<Integer>();
    horizon.add(0);

    while(!horizon.isEmpty()) {
      Integer current = horizon.remove(0);
      for (Integer neighbor : adj.get(current)) {
        if (connectedHouse[neighbor] == false) {
          connectedHouse[neighbor] = true;
          horizon.add(neighbor);
        }
      }
    }
  }

  private void printDisconnected() {
    boolean isConnected = true;
    for (int i = 0; i < countHouses; i++) {
      boolean isHouseConnected = connectedHouse[i];
      if (!isHouseConnected) {
        isConnected = false;
        kattio.println(i + 1);
      }
    }

    if (isConnected)
      printConnected();
  }
}