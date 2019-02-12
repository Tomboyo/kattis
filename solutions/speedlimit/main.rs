use std::io::{self, BufReader, stdin, BufRead, Stdin};

macro_rules! scan {
    ( $string:expr, $( $x:ty ),+ ) => {{
        let mut iter = $string.split(char::is_whitespace);
        ($(iter.next().and_then(|word| word.parse::<$x>().ok()).unwrap()),*)
    }}
}

fn main() {
    let mut lines = read_lines().unwrap();

    // A number precedes a travel entry. Read the number to determine how many of the following
    // lines are part of the entry, then read those lines and compute a result for the entry.
    loop {
        let records = (&mut lines).next().unwrap().unwrap().parse::<usize>();
        if let Err(_) = records {
            // Final line is -1, not a u8.
            return;
        }

        let result = (&mut lines).take(records.unwrap())
            .map(Result::unwrap)
            .map(|x| scan!(x, u16, u16))
            .fold((0, 0), |(total_distance, last_timestamp), (speed, timestamp)| {
                let distance = speed * (timestamp - last_timestamp);
                (total_distance + distance, timestamp)
            }).0;

        println!("{} miles", result);
    }
}

fn read_lines() -> Result<io::Lines<BufReader<Stdin>>, io::Error> {
    Ok(BufReader::new(stdin()).lines())
}