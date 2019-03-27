from functools import reduce
from itertools import chain, groupby
from typing import List, Tuple, Set


Board = List[List[str]]
Coord = Tuple[int, int]


class SudokuNode:
    def __init__(self, num=None, loc=None, parent=None):
        self.num = num
        self.loc = loc
        self.children = []
        self.parent = parent
        self.visited = False


def numbers_available(board: Board, cell_coord: Coord) -> Set[str]:
    n = len(board)
    pool = {str(i) for i in range(1, n + 1)}
    i, j = cell_coord

    row_used = set(board[i])

    col_used = set(tuple(zip(*board))[j])

    square_row_idx = (i // 3) * 3
    square_col_idx = (j // 3) * 3
    rows = board[square_row_idx:square_row_idx + 3]
    square_used = {
        num
        for col in tuple(zip(*rows))[square_col_idx:square_col_idx + 3]
        for num in col
    }

    return pool.difference(row_used.union(col_used).union(square_used))


def yield_squares(board):
    for row_idx in range(0, 9, 3):
        for col_idx in range(0, 9, 3):
            rows = board[row_idx:row_idx + 3]
            columns = list(zip(*rows))[col_idx:col_idx + 3]
            yield reduce(lambda x, y: x + y, columns)


def yield_rows(board: Board):
    for row in board:
        yield tuple(row)


def yield_cols(board: Board):
    for col in zip(*board):
        yield col


def isValidSudoku(board: Board) -> bool:
    for nums in chain(yield_squares(board), yield_rows(board), yield_cols(board)):
        for key, group in groupby(sorted(nums)):
            if key == ".":
                continue
            elif len(list(group)) > 1:
                return False
    return True


def solve(board: Board) -> Board:
    invalid_message = "Invalid sudoku board!"
    if not isValidSudoku(board):
        raise ValueError(invalid_message)

    n = len(board)
    loc = 0
    pointer = SudokuNode(num=None, loc=None, parent=None)
    while loc < n ** 2:
        i, j = divmod(loc, n)
        if board[i][j] == ".":  # Only insert value when cell is open
            if not pointer.visited:
                avail = numbers_available(board, (i, j))
                pointer.children = [
                    SudokuNode(num=num, loc=loc, parent=pointer) for num in avail
                ]
                pointer.visited = True

            if pointer.children:
                pointer = pointer.children.pop(0)
                board[i][j] = pointer.num
                loc += 1
            else:
                if pointer.parent is None:  # Returned to the root
                    raise ValueError(invalid_message)

                i_reset, j_reset = divmod(pointer.loc, n)
                board[i_reset][j_reset] = "."
                loc = pointer.loc
                pointer = pointer.parent

        else:
            loc += 1
    return board


def handler(event, context) -> Board:
    board: Board = event["board"]
    return solve(board)


if __name__ == "__main__":
    board = [
        ["5", "3", ".", ".", "7", ".", ".", ".", "."],
        ["6", ".", ".", "1", "9", "5", ".", ".", "."],
        [".", "9", "8", ".", ".", ".", ".", "6", "."],
        ["8", ".", ".", ".", "6", ".", ".", ".", "3"],
        ["4", ".", ".", "8", ".", "3", ".", ".", "1"],
        ["7", ".", ".", ".", "2", ".", ".", ".", "6"],
        [".", "6", ".", ".", ".", ".", "2", "8", "."],
        [".", ".", ".", "4", "1", "9", ".", ".", "5"],
        [".", ".", ".", ".", "8", ".", ".", "7", "9"],
    ]
    assert numbers_available(board, (0, 2)) == {"1", "2", "4"}
    assert isValidSudoku(solve(board))
