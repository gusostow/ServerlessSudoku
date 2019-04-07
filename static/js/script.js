function drawBoard() {
    for (let rowIdx = 0; rowIdx <= 8; rowIdx++){
        let rowElement = document.createElement("tr")
        for (let colIdx = 0; colIdx <= 8; colIdx++){
            let col = document.createElement("td")
            let cell = document.createElement("input")
            cell.setAttribute("class", "cell")
            cell.setAttribute("id", "c" + rowIdx + colIdx)
            cell.setAttribute("maxlength", "1")
            cell.setAttribute("autocomplete", "off")
            
            thickBorderStr = "4px solid black"
            if (colIdx == 0) {
                cell.style.borderLeft = thickBorderStr
            }
            if (rowIdx == 0){
                cell.style.borderTop = thickBorderStr
            }
            if (colIdx % 3 == 2) {
                cell.style.borderRight = thickBorderStr
            }
            if (rowIdx % 3 == 2) {
                cell.style.borderBottom = thickBorderStr
            }

            col.appendChild(cell)
            rowElement.appendChild(col)
        }
        $("#board-tbody").append(rowElement)
    }
}

$(document).ready(drawBoard)

function getInputBoard() {
    let input_board = [];
    for (let rowIdx = 0; rowIdx <= 8; rowIdx++){
        let row = [];
        for (let colIdx = 0; colIdx <= 8; colIdx++){
            var cellVal = document.getElementById("c" + rowIdx + colIdx).value;
            if (cellVal == "") {
                cellVal = "."
            }
            row.push(cellVal)
        }
        input_board.push(row)
    }
    return input_board
}

function fillBoard() {
    let input_board = getInputBoard()
    const payload = JSON.stringify({board: input_board})
    const endpoint_url = "https://p3mto0h4h9.execute-api.us-east-2.amazonaws.com/development/sudoku"
    $.post(endpoint_url, payload, function(data) {
        for (let rowIdx = 0; rowIdx <= 8; rowIdx++) {
            for (let colIdx = 0; colIdx <= 8; colIdx++){
                let e = document.getElementById("c" + rowIdx + colIdx)
                e.value = data[rowIdx][colIdx]
            }
        }
    })
}

