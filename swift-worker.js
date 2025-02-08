const { parentPort, workerData } = require("worker_threads");
const { execSync } = require("child_process");
const os = require("os");
const fs = require("fs");
const path = require("path");

// Utility function to clean up temporary files
function cleanupFiles(...files) {
    files.forEach((file) => {
        try {
            fs.unlinkSync(file);
        } catch (err) {
            // Ignore errors (for files that may not exist)
        }
    });
}

// Worker logic
(async () => {
    const { code, input } = workerData;

    // Paths for temporary Swift script
    const tmpDir = os.tmpdir();
    const sourceFile = path.join(tmpDir, `temp_${Date.now()}.swift`);

    try {
        // Write the Swift code to the source file
        fs.writeFileSync(sourceFile, code);

        // Execute the Swift code
        const swiftCommand = "/usr/local/swift/usr/bin/swift"; // Use full path to Swift binary
        let output = "";

        try {
            output = execSync(`${swiftCommand} ${sourceFile}`, {
                input,
                encoding: "utf-8",
            });
        } catch (error) {
            cleanupFiles(sourceFile);
            return parentPort.postMessage({
                error: { fullError: `Runtime Error:\n${error.message}` },
            });
        }

        // Clean up temporary Swift file after execution
        cleanupFiles(sourceFile);

        // Send the output back to the main thread
        parentPort.postMessage({
            output: output || "No output received!",
        });
    } catch (err) {
        cleanupFiles(sourceFile);
        return parentPort.postMessage({
            error: { fullError: `Server error: ${err.message}` },
        });
    }
})();
