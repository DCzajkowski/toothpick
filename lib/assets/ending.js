
/**
 * The main() function call and the exit status.
 */

const statusOrPrintable = main();

if (statusOrPrintable === 0 || statusOrPrintable === 1) {
  process.exit(statusOrPrintable);
} else {
  console.log(statusOrPrintable);
}
