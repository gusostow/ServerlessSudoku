function get_input_board() {
    let input_board = [];
    for (let row_idx = 0; row_idx <= 8; row_idx++){
        let row = [];
        for (let col_idx = 0; col_idx <= 8; col_idx++){
            var cell_val = document.getElementById("c" + row_idx + col_idx).value;
            if (cell_val == "") {
                cell_val = "."
            }
            row.push(cell_val)
        }
        input_board.push(row)
    }
    return input_board
}

function fill_board() {
    let input_board = get_input_board()
    const payload = JSON.stringify({board: input_board})
    const endpoint_url = "https://bkv4y1mug2.execute-api.us-east-2.amazonaws.com/development/sudoku"
    $.post(endpoint_url, payload, function(data) {
        for (let row_idx = 0; row_idx <= 8; row_idx++) {
            for (let col_idx = 0; col_idx <= 8; col_idx++){
                let e = document.getElementById("c" + row_idx + col_idx)
                e.value = data[row_idx][col_idx]
            }
        }
    })
}

