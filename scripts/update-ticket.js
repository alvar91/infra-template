// #!/usr/bin/env node

const https = require('https');
const [,, AUTH_TOKEN, ORGANIZATION_ID, TICKET_KEY, RELEASE_VERSION, COMMITTER_NAME, COMMITS] = process.argv

const ticketInfoData = JSON.stringify({
    summary: `Релиз ${RELEASE_VERSION} от ${getDate()}`,
    description: `Ответственный за релиз ${COMMITTER_NAME}
    ________________________________
    Коммиты, попавшие в релиз:
    ${COMMITS}`,
});

const ticketCommentData = JSON.stringify({
  text: `Собрали образ в тегом ${RELEASE_VERSION}`
});

const headers = {
    'Authorization': `OAuth ${AUTH_TOKEN}`,
    'X-Org-ID': Number(ORGANIZATION_ID),
    'Content-Type': 'application/json',
}

const ticketInfoOptions = {
  hostname: 'api.tracker.yandex.net',
  port: 443,
  path: `/v2/issues/${TICKET_KEY}`,
  method: 'PATCH',
  headers: {
    ...headers,
    'Content-Length': Buffer.byteLength(ticketInfoData),
  },
};

const ticketCommentOptions = {
  hostname: 'api.tracker.yandex.net',
  port: 443,
  path: `/v2/issues/${TICKET_KEY}/comments`,
  method: 'POST',
  headers: {
    ...headers,
    'Content-Length': Buffer.byteLength(ticketCommentData),
  },
};

request(ticketInfoOptions, ticketInfoData);
request(ticketCommentOptions, ticketCommentData);

function getDate() {
  const date = new Date();
  return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`
}

function request(options, payload) {
  const req = https.request(options, (res) => {

    res.on('data', (d) => {
      process.stdout.write(d);
    });
  });

  req.on('error', (e) => {
    console.error(e);
  });

  req.write(payload);
}