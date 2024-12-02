import fs from "fs";

// Get text file from command line arguments
const fileName = process.argv[2];

const input = fs.readFileSync(fileName, "utf8");

const lines = input.split("\n");
const leftNumbers: number[] = [];
const rightNumbers: number[] = [];

console.log(lines.length);

lines.forEach((line) => {
    const [left, right] = line.split(/\s+/);
    leftNumbers.push(parseInt(left));
    rightNumbers.push(parseInt(right));
});

// Sort the arrays
leftNumbers.sort((a, b) => a - b);
rightNumbers.sort((a, b) => a - b);

// Zip the arrays, then find the difference between the left and right numbers
const zipped = leftNumbers.map((left, index) => [left, rightNumbers[index]]);
const differences = zipped.map(([left, right]) => Math.abs(right - left));

console.log(zipped);

// Sum the differences
const sum = differences.reduce((acc, curr) => acc + curr, 0);

console.log(sum);
