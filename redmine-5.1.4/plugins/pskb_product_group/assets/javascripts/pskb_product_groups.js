var rowsState = {};

// Получаем элементы
const modalAdd = document.getElementById("new-group-modal");
const modalEdit = document.getElementById("edit-group-modal");

const openBtnAdd = document.getElementById("add-group-btn");

const delBtns = document.querySelectorAll(".del-button");
const editBtns = document.querySelectorAll(".edit-button");

const saveBtn = document.getElementById("save-groups-btn");

const approveBtn = document.getElementById("approve-button");
const rejectBtn = document.getElementById("reject-button");

function extractData(row){
    const pgId = row.cells[1].textContent;
    const percentage = row.cells[2].textContent;
    const pgIssueId = row.cells[4].textContent;
    const issueId = document.getElementById("issue_id").textContent;
    let negId = "0";
    if (row.cells[7] !== undefined) {
        negId = row.cells[7].textContent;
    }

    return {
        pgId: pgId,
        percentage: percentage,
        pgIssueId: pgIssueId,
        issueId: issueId,
        negId: negId
    }
}

function saveGroupsEvent() {
    const rows = document.getElementById("pgTable").getElementsByTagName('tbody')[0].rows;
    let dataJson = {
    pgIssuesData: {
        "0": [],
        "1": [],
        "2": [],
        "3": []
    }
    }
    for (let row of rows) {
        dataJson.pgIssuesData[row.dataset.state].push(extractData(row));
    }

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/pskb_product_groups_issues', false);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Accept', 'application/json');

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    xhr.setRequestHeader('X-CSRF-Token', csrfToken);

    xhr.send(JSON.stringify(dataJson));

    if (xhr.readyState === 4) {
    if (xhr.status === 201) {
        const response = JSON.parse(xhr.responseText);
        console.log('Success:', response);
        window.location.reload();
    } else {
        const response = JSON.parse(xhr.responseText);
        console.log(response)
        alert(response.error);
        console.error('Error:', xhr.status, xhr.statusText);
    }
    }
};

saveBtn.addEventListener('click', saveGroupsEvent);

function delBtnEvent() {
    const row = this.closest('tr');
    if (row.dataset.state == "3"){
    return
    }
    if (row.dataset.state == "1"){
    row.remove();
    } else {
    row.dataset.state = "3";
    saveBtn.classList.remove('disabled-btn')
    }
}

function editBtnEvent() {
    const row = this.closest('tr');
    const rowIndex = row.rowIndex - 1;

    var productGroup = row.cells[1].textContent;
    var perc = row.cells[2].textContent;

    var selectPg = document.getElementById('edit-pg-selected');
    var percInput = document.getElementById('edit-percentage');
    var editedRow = document.getElementById('edited-row');

    selectPg.value = productGroup;
    percInput.value = perc;
    editedRow.value = rowIndex;

    modalEdit.style.display = "block";
}

delBtns.forEach(btn => {
    btn.addEventListener('click', delBtnEvent);
})

editBtns.forEach(btn => {
    btn.addEventListener('click', editBtnEvent);
})

const closeBtn = document.querySelector(".close-btn");
const closeBtnEdit = document.querySelector('.edit-close-btn');

closeBtnEdit.onclick = function() {
    modalEdit.style.display = "none";
}

// Открытие модального окна
openBtnAdd.onclick = function() {
    modalAdd.style.display = "block";
}

// Закрытие модального окна
closeBtn.onclick = function() {
    modalAdd.style.display = "none";
}

// Закрытие окна при клике вне модального окна
window.onclick = function(event) {
    if (event.target == modalAdd) {
    modalAdd.style.display = "none";
    } else if (event.target == modalEdit){
    modalEdit.style.display == "none";
    }
}

function createBtn(btn_class, eventCallback, textContent) {
    const btn = document.createElement('button');
    btn.type = 'submit';
    btn.classList.add(btn_class);
    btn.textContent = textContent;
    btn.addEventListener('click', eventCallback);

    return btn;
}

// Добавление данных в таблицу
function addTableRows(tableId, formObj){
    let table = document.getElementById(tableId).getElementsByTagName('tbody')[0];

    let newRow = table.insertRow();
    newRow.dataset.state = "1";
    newRow.dataset.initState = "1";
    
    const cell0 = newRow.insertCell(0);
    const cell1 = newRow.insertCell(1);
    const cell2 = newRow.insertCell(2);
    const cell3 = newRow.insertCell(3);
    const cell4 = newRow.insertCell(4);
    const cell5 = newRow.insertCell(5);

    cell0.textContent = formObj.groupName;
    cell1.textContent = formObj.pskb_product_groups_id;
    cell1.classList.add('hidden-td');

    cell2.textContent = formObj.percentage;
    cell3.textContent = formObj.owner_name;
    cell4.textContent = "-1";
    cell4.classList.add('hidden-td');


    const delButton = createBtn('del-button', delBtnEvent, 'Удалить');
    const editButton = createBtn('edit-button', editBtnEvent, 'Редактировать');

    const divBtns = document.createElement('div');
    divBtns.classList.add('action-div')

    divBtns.appendChild(editButton);
    divBtns.appendChild(delButton);
    

    cell5.appendChild(divBtns);
    saveBtn.classList.remove('disabled-btn')
}

// Редактирование строки
function editTableRow(tableId, formObj) {
    let table = document.getElementById(tableId).getElementsByTagName('tbody')[0];
    let row = table.rows[formObj.rowIndex];

    row.cells[0].textContent = formObj.groupName;
    row.cells[1].textContent = formObj.groupId;
    row.cells[2].textContent = formObj.percentage;
    row.cells[3].textContent = formObj.owner_name;

    if (row.dataset.initState == "1"){
    return
    } else {
    row.dataset.state = "2";
    }
    saveBtn.classList.remove('disabled-btn')

}

function getOwner(groupId) {
    const xhr = new XMLHttpRequest()
    xhr.open("GET", `/pskb_product_groups/${groupId}/get_owner`, false)
    xhr.send();

    if (xhr.status === 200) {
    return JSON.parse(xhr.responseText);
    }
    
}

document.getElementById('addForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const formData = new FormData(this)
    const formDataObject = {};

    const selectedOption = document.querySelector('#add_pg_selected');
    const groupId = selectedOption.value;
    const groupName = selectedOption.options[selectedOption.selectedIndex].text;

    formData.forEach((value, key) => {
        formDataObject[key] = value;
    });

    formDataObject['groupId'] = groupId;
    formDataObject['groupName'] = groupName;

    const owner = getOwner(groupId);
    formDataObject['owner_name'] = owner.name

    addTableRows('pgTable', formDataObject)
    closeBtn.onclick();
    this.reset();
    }
)

document.getElementById('editForm').addEventListener('submit', function(event){
    event.preventDefault();

    const formData = new FormData(this)
    const formDataObject = {};

    const selectedOption = document.querySelector('#edit-pg-selected');
    const groupId = selectedOption.value;
    const groupName = selectedOption.options[selectedOption.selectedIndex].text;

    formData.forEach((value, key) => {
        formDataObject[key] = value;
    });

    formDataObject['groupId'] = groupId;
    formDataObject['groupName'] = groupName;

    const owner = getOwner(groupId);
    formDataObject['owner_name'] = owner.name

    editTableRow('pgTable', formDataObject)
    closeBtnEdit.onclick();
    this.reset();
})