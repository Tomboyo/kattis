package wheresmyinternet;

import com.kattis.open.Kattio;
import java.util.List;
import java.util.LinkedList;
import java.util.Map;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;

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

    if (countCables > edgesOfConnectedGraph(countHouses - 1)) {
      printConnected();
      return true;
    }

    return false;
  }

  private long edgesOfConnectedGraph(long n) {
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
