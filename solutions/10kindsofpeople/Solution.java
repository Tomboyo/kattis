package tenkindsofpeople;

import com.kattis.open.Kattio;
import java.io.InputStream;
import java.io.OutputStream;
import java.time.Duration;
import java.time.Instant;
import java.util.Stack;
import java.util.function.BiConsumer;

public class Solution {
  
  private final Kattio kattio;

  private int rows;
  private int columns;
  private boolean[][] grid;
  private int[][] components;

  public Solution() {
    this(System.in, System.out);
  }

  public Solution(InputStream is, OutputStream os) {
    kattio = new Kattio(is, os);
  }

  public static void main(String[] args) {
    new Solution().run();
  }

  public void run() {
    createGrid();
    createStronglyConnectedComponents();
    executeQueries();

    kattio.close();
  }

  private void createGrid() {
    rows = kattio.getInt();
    columns = kattio.getInt();
    grid = new boolean[rows][columns];
    for (int r = 0; r < rows; r++)
      createRow(r);
  }

  private void createRow(int rowIndex) {
    char[] row = kattio.getWord().toCharArray();
    
    for (int columnIndex = 0; columnIndex < columns; columnIndex++)
      grid[rowIndex][columnIndex] = asBool(row[columnIndex]);
  }

  private boolean asBool(char c) {
    return c == '1';
  }

  private void createStronglyConnectedComponents() {
    components = new int[rows][columns];
    int componentIndex = 1;

    for (int row = 0; row < rows; row++)
      for (int column = 0; column < columns; column++)
        if (components[row][column] == 0)
          floodFill(row, column, componentIndex++);
  }

  private void floodFill(int row, int column, int componentIndex) {
    components[row][column] = componentIndex;

    Stack<Integer[]> horizon = new Stack<>();
    horizon.push(new Integer[]{ row, column });
    
    while(!horizon.isEmpty()) {
      Integer[] current = horizon.pop();
      forEachAdjacent(current[0], current[1], (r, c) -> {
        if (components[r][c] == 0
            && grid[row][column] == grid[r][c]) {
          components[r][c] = componentIndex;
          horizon.push(new Integer[]{ r, c });
        }
      });
    }
  }

  private void forEachAdjacent(
    int row,
    int column,
    BiConsumer<Integer, Integer> neighborVisitor
  ) {
    int[][] neighbors = new int[][] {
      new int[] { row - 1, column },
      new int[] { row, column - 1 },
      new int[] { row, column + 1 },
      new int[] { row + 1, column },
    };

    for (int[] n : neighbors)
      if (coordinatesInRange(n[0], n[1]))
        neighborVisitor.accept(n[0], n[1]);
  }

  private boolean coordinatesInRange(int r, int c) {
    return r >= 0 && r < rows && c >= 0 && c < columns;
  }

  private void executeQueries() {
    int queries = kattio.getInt();
    for (int q = 0; q < queries; q++)
      executeNextQuery();
  }

  private void executeNextQuery() {
    int row1 = kattio.getInt() - 1;
    int col1 = kattio.getInt() - 1;
    int row2 = kattio.getInt() - 1;
    int col2 = kattio.getInt() - 1;

    if (components[row1][col1] == components[row2][col2])
      kattio.println(grid[row1][col1] == true
          ? "decimal"
          : "binary");
    else
      kattio.println("neither");
  }
}
