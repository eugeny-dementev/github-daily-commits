#!/usr/local/bin/node

import { writeFileSync } from 'fs';
import fetch from 'node-fetch';

function getTodaysDate() {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are zero-based
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
}

async function fetchCommits() {
  const username = process.env.GITHUB_USERNAME;

  if (!username) throw new Error('GITHUB_USERNAME env is empty');

  const response = await fetch(`https://github.com/${username}`);
  const html = await response.text();

  const today = getTodaysDate();

  console.log(`Searching contributions for ${today}`);

  const tdRegExp = new RegExp(`data-date="${today}"[\\S\\s]+tool-tip>`, 'g');

  const extractedTd = html.match(tdRegExp);

  // Extract the td containing data for the current date
  const td = extractedTd[0];

  // Extract the tooltipId
  const tooltipId = /(tooltip\-[0-9a-zA-Z\-]+)/.exec(td)[0];

  // Extract the number of contributions
  const contributionsRegex = new RegExp(`<.+id=\"${tooltipId}\".+>([0-9]+).+<`);
  const contributions = contributionsRegex.exec(html)[1];

  console.log(`Found contributions for the day ${today}: ${contributions}`);

  // Store the number of contributions in the file
  const filePath = `${process.env.HOME}/.config/github-daily-commits/commits.txt`;
  writeFileSync(filePath, contributions);
}

fetchCommits()
  .then(() => console.log('fetch is done'))
  .catch(console.error);
