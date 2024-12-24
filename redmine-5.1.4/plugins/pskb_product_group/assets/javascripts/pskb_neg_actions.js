// approved

function approveIssueByPg(issueId, pgNegId){
    const dataJson = {
        issue_id: issueId,
        pgNegId: pgNegId
    }

    const xhr = new XMLHttpRequest();
    xhr.open('POST', `/issues/${issueId}/approve_issue_by_pg`, false);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Accept', 'application/json');

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    xhr.setRequestHeader('X-CSRF-Token', csrfToken);

    xhr.send(JSON.stringify(dataJson));

    if (xhr.readyState === 4) {
        if (xhr.status === 200) {
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
}

// function rejectIssueByPg(){
//     const dataJson = {
//         issue_id: issueId,
//         pgNegId: pgNegId
//     }

//     const xhr = new XMLHttpRequest();
//     xhr.open('POST', `/issues/${issueId}/approve_issue_by_pg`, false);
//     xhr.setRequestHeader('Content-Type', 'application/json');
//     xhr.setRequestHeader('Accept', 'application/json');

//     const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
//     xhr.setRequestHeader('X-CSRF-Token', csrfToken);

//     xhr.send(JSON.stringify(dataJson));

//     if (xhr.readyState === 4) {
//         if (xhr.status === 200) {
//             const response = JSON.parse(xhr.responseText);
//             console.log('Success:', response);
//             window.location.reload();
//         } else {
//             const response = JSON.parse(xhr.responseText);
//             console.log(response)
//             alert(response.error);
//             console.error('Error:', xhr.status, xhr.statusText);
//         }
//     }
// }

// rejection

var modalRejectPg = document.getElementById("reject-modal-pg");
var commentAreaPg = document.getElementById("reject-comment-pg");

var notifyPg = document.getElementById('notify-pg');
var rejectIssueBtnPg = document.getElementById("reject-issue-btn-pg");

function validateTextareaPg() {
    const text = commentAreaPg.value.trim();
    if (text === "" || text.length <= 5) {
        rejectIssueBtnPg.disabled = true;
        notifyPg.style.display = "block";
    } else {
        rejectIssueBtnPg.disabled = false;
        notifyPg.style.display = "none";
    }
}

commentAreaPg.addEventListener('input', validateTextareaPg);
validateTextareaPg();

function sendComment(comment, issueId, negId) {
    const xhr = new XMLHttpRequest()
    xhr.open('POST', `/issues/${issueId}/reject_issue_by_pg`, false);
    xhr.setRequestHeader('Content-Type', 'application/json');

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    xhr.setRequestHeader('X-CSRF-Token', csrfToken);

    const commentJson = {
        comment: comment,
        issue_id: issueId,
        neg_id: negId
    };

    xhr.send(JSON.stringify(commentJson));

    if (xhr.readyState === 4) {
        if (xhr.status === 200) {
            window.onbeforeunload = null;
            location.reload();
        } else {
            const response = JSON.parse(xhr.responseText);
            alert(response.error);
        }
    }
}

function rejectIssue(issueId, negId) {
    const rejectComment = commentAreaPg.value;
    commentAreaPg.value = '';
    sendComment(rejectComment, issueId, negId);
}

const closeModalRejectPg = document.getElementById("reject-close-btn-pg");

closeModalRejectPg.addEventListener('click', function() {
    commentAreaPg.value = '';
    validateTextareaPg()
    modalRejectPg.style.display = "none";
})


function rejectIssueByPg(issueId, negId) {
    modalRejectPg.style.display = "block";
    
    rejectIssueBtnPg.addEventListener('click', () => {
        rejectIssue(issueId, negId);
    });
}
