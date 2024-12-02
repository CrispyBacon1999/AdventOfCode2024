import fs from "fs";

// Get text file from command line arguments
const fileName = process.argv[2];

const input = fs.readFileSync(fileName, "utf8");

const lines = input.split("\n");
const leftNumbers: number[] = [];
const rightNumbers: Record<number, number> = {};

/**
 * Calculates the number of 
 * @param num
 * @param rightNumbers 
 */
function calculateSimilarityScore(num: number, rightNumbers: Record<number, number>): number {
    return (rightNumbers[num] * num) || 0;
}

function addNumberToRecord(num: number, record: Record<number, number>): void {
    if (record[num]) {
        record[num]++;
    } else {
        record[num] = 1;
    }
}

console.log(lines.length);

lines.forEach((line) => {
    const [left, right] = line.split(/\s+/);
    leftNumbers.push(parseInt(left));
    addNumberToRecord(parseInt(right), rightNumbers);
});

// Zip the arrays, then find the difference between the left and right numbers
const similarities = leftNumbers.map((left) => calculateSimilarityScore(left, rightNumbers));

console.log(similarities);

// Sum the differences
const sum = similarities.reduce((acc, curr) => acc + curr, 0);

console.log(sum);
