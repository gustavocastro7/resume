const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration
const LAST_RUN_FILE = path.join(__dirname, 'last_run.json');
const ROOT_DIR = path.resolve(__dirname, '..');
const CONVERT_SCRIPT = path.join(__dirname, 'convert_md.bat');

// Load last run time
let lastRunTime = 0;
if (fs.existsSync(LAST_RUN_FILE)) {
    try {
        const data = JSON.parse(fs.readFileSync(LAST_RUN_FILE, 'utf8'));
        lastRunTime = data.lastRun || 0;
    } catch (e) {
        console.error('Error reading last_run.json:', e.message);
    }
}

const startTime = Date.now();
console.log(`Last run time: ${new Date(lastRunTime).toLocaleString()}`);

// Function to scan directory recursively
function scanDir(dir) {
    const files = fs.readdirSync(dir);

    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            // Skip hidden folders and specific directories
            if (file.startsWith('.') || file === 'node_modules' || file === 'output' || file === 'tools') {
                continue;
            }
            scanDir(fullPath);
        } else if (file.endsWith('.md')) {
            checkAndConvert(fullPath, stat.mtimeMs);
        }
    }
}

// Function to check modification time and convert if needed
function checkAndConvert(filePath, mtimeMs) {
    if (mtimeMs > lastRunTime) {
        console.log(`File modified: ${filePath}`);
        try {
            // Use 'call' to ensure the batch script executes properly and returns
            // Using execSync to run the batch file
            console.log(`Converting: ${filePath}`);
            execSync(`"${CONVERT_SCRIPT}" "${filePath}"`, { stdio: 'inherit' });
        } catch (error) {
            console.error(`Error converting ${filePath}:`, error.message);
        }
    } else {
        // console.log(`Skipping (not modified): ${filePath}`);
    }
}

// Start scanning
console.log(`Scanning directory: ${ROOT_DIR}`);
try {
    scanDir(ROOT_DIR);

    // Update last run time
    fs.writeFileSync(LAST_RUN_FILE, JSON.stringify({ lastRun: startTime }, null, 2));
    console.log('Scan completed. Last run time updated.');
} catch (error) {
    console.error('Error during scan:', error);
    process.exit(1);
}
