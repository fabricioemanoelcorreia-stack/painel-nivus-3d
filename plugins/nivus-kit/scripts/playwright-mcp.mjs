// Starts the Playwright MCP server. In Claude Code cloud sessions, reuse the
// pre-installed Chromium instead of downloading a browser.
import { spawn } from 'node:child_process';
import { existsSync } from 'node:fs';

const args = ['-y', '@playwright/mcp@0.0.83', '--headless', '--browser', 'chromium'];
if (existsSync('/opt/pw-browsers/chromium')) args.push('--executable-path', '/opt/pw-browsers/chromium');

const child = spawn('npx', args, { stdio: 'inherit', shell: process.platform === 'win32' });
child.on('exit', code => process.exit(code ?? 0));
