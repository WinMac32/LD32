library Pathfinder;

import "dart:math";
import "package:priority_queue/priority_queue.dart";

class Node {
    int x;
    int y;
    bool c;
    bool opened;
    bool closed;
    double f;
    double g;
    Node parent = null;

    Node(this.x, this.y, this.c) {
        this.opened = false;
    }
}

class Grid {
    List<Node> nodes;

    int width;
    int height;

    Grid(List<bool> collision, this.width, this.height) {
        nodes = new List<Node>();
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++){
                nodes.add(new Node(x, y, collision[x + (y * width)]));
            }
        }
    }

    Node getNodeAt(int x, int y) {
        return nodes[x + (y * width)];
    }

    bool walkableAt(int x, int y) {
        if (y >= height || y < 0 || x >= width || x < 0) return false;
        return !getNodeAt(x, y).c;
    }

    List<Node> getNeighbors(int x, int y) {
        List<Node> n = new List<Node>();

        bool left = false;
        bool right = false;
        bool up = false;
        bool down = false;

        if (walkableAt(x, y + 1)) {
            n.add(getNodeAt(x, y + 1));
            down = true;
        }

        if (walkableAt(x, y - 1)) {
            n.add(getNodeAt(x, y - 1));
            up = true;
        }

        if (walkableAt(x + 1, y)) {
            n.add(getNodeAt(x + 1, y));
            right = true;
        }

        if (walkableAt(x - 1, y)) {
            n.add(getNodeAt(x - 1, y));
            left = true;
        }

        if (up && right && walkableAt(x + 1, y - 1)) {
            n.add(getNodeAt(x + 1, y - 1));
        }

        if (up && left && walkableAt(x - 1, y - 1)) {
            n.add(getNodeAt(x - 1, y - 1));
        }

        if (down && right && walkableAt(x + 1, y + 1)) {
            n.add(getNodeAt(x + 1, y + 1));
        }

        if (down && left && walkableAt(x - 1, y + 1)) {
            n.add(getNodeAt(x - 1, y + 1));
        }

        return n;
    }

    void reset() {
        for (Node n in nodes) {
            n.opened = false;
            n.closed = false;
            n.g = 0.0;
            n.f = 0.0;
            n.parent = null;
        }
    }

}

class Pathfinder {

    List<Point<int>> getPath(int x, int y, int dx, int dy, Grid grid) {
        if (dx >= grid.width || dx < 0 || dy >= grid.height || dy < 0 ||
            x >= grid.width || x < 0 || y >= grid.height || y < 0) return null;

        PriorityQueue<Node> open = new PriorityQueue<Node>(comparator: (Node a, Node b) {
            return b.f - a.f;
        });
        Node start = grid.getNodeAt(x, y);
        Node dest = grid.getNodeAt(dx, dy);

        start.g = 0.0;
        start.f = this.heuristic(x, y, dx, dy);

        open.add(start);
        start.opened = true;

        while (!open.isEmpty) {
            Node c = open.removeMax();
            c.closed = true;

            if (c == dest) {
                return this.reconstruct(c);
            }

            List<Node> nbs = grid.getNeighbors(c.x, c.y);
            for (Node n in nbs) {
                if (n.closed) continue;

                double g = c.g + ((n.x == c.x || n.y == c.y) ? 1 : SQRT2);

                if (!n.opened || g < n.g) {
                    n.parent = c;
                    n.g = g;
                    n.f = g + this.heuristic(n.x, n.y, dx, dy);

                    if (!n.opened) {
                        open.add(n);
                        n.opened = true;
                    }
                }

            }
        }

        return null;
    }

    double heuristic(int x1, int y1, int x2, int y2) {
        var dx = (x1 - x2).abs();
        var dy = (y1 - y2).abs();
        var F = SQRT2 - 1;
        return (dx < dy) ? F * dx + dy : F * dy + dx;
    }

    List<Point<int>> reconstruct(Node node) {
        List<Point<int>> path = [new Point(node.x, node.y)];
        while (node.parent != null) {
            node = node.parent;
            path.add(new Point(node.x, node.y));
        }
        return path.reversed.toList();
    }

}