// Rust's heap impl doesn't support updates, so we implement our own using a simple Vec and linear
// probe. For small heaps this should be fast enough.
pub struct MinHeap<T: Eq> {
    data: Vec<HeapNode<T>>,
}

#[derive(Debug, Eq, PartialEq)]
struct HeapNode<T: Eq> {
    element: T,
    value: usize,
}

impl<T: Eq> MinHeap<T> {
    pub fn new() -> Self {
        MinHeap { data: Vec::new() }
    }

    pub fn push(&mut self, element: T, value: usize) {
        let max = self.data.len();
        let mut i = 0;
        // linear probe
        // ends when i == max OR value <= value at i
        while i < max && value > self.data[i].value {
            i += 1;
        }

        let node = HeapNode {element, value};
        if i == max {
            self.data.push(node);
        } else {
            self.data.insert(i, node);
        }
    }

    pub fn update(&mut self, element: T, new_value: usize) {
        let max = self.data.len();
        let mut i = 0;
        // linear probe
        // stops when i == max OR element == self.data[i]
        while i < max && element != self.data[i].element {
            i += 1;
        }

        if i == max { return; }
        let node = self.data.remove(i);
        self.push(node.element, new_value);
    }

    pub fn pop(&mut self) -> Option<T> {
        if self.data.is_empty() {
            Option::None
        } else {
            Some(self.data.remove(0).element)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_priority() {
        let mut heap = MinHeap::new();
        heap.push("b", 2);
        heap.push("a", 1);
        heap.push("c", 3);

        assert_eq!("a", heap.pop().unwrap());
        assert_eq!("b", heap.pop().unwrap());
        assert_eq!("c", heap.pop().unwrap());
    }

    #[test]
    fn test_update_first_element() {
        let mut heap = MinHeap::new();
        heap.push("a", 1);
        heap.push("b", 2);
        heap.push("c", 3);
        heap.update("a", 4);

        assert_eq!("b", heap.pop().unwrap());
        assert_eq!("c", heap.pop().unwrap());
    }

    #[test]
    fn test_update_second_element() {
        let mut heap = MinHeap::new();
        heap.push("a", 1);
        heap.push("b", 2);
        heap.push("c", 3);
        heap.update("b", 4);

        assert_eq!("a", heap.pop().unwrap());
        assert_eq!("c", heap.pop().unwrap());
    }

    #[test]
    fn test_update_last_element() {
        let mut heap = MinHeap::new();
        heap.push("a", 1);
        heap.push("b", 2);
        heap.push("c", 3);
        heap.update("c", 0);

        assert_eq!("c", heap.pop().unwrap());
        assert_eq!("a", heap.pop().unwrap());
    }
}