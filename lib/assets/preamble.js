/**
 * This is a compiled program output via the Toothpick compiler.
 * The following sections are in order: the standard library,
 * Toothpick program's compiled source code, the main()
 * function call and the exit status.
 */

/**
 * The standard library
 */

// helpers
const __deepClone__ = value => JSON.parse(JSON.stringify(value))

// IO
const print = (string) => console.log(string)
const inspect = value => console.log(typeof value, value)

// String
function format() {
  let [string, ...values] = arguments
  values = values.flatten(Infinity)

  if (values.length === 0) {
    return string
  }

  const match = string.match(/(^\$)|([^\\])\$/)
  const index = match['index']

  if (index === 0) {
    const result = String(values[0]) + string.substring(1)

    return format(result, values.slice(1))
  }

  const result = string.substring(0, index)
    + match[2]
    + String(values[0])
    + string.substring(index + 2)

  return format(result, values.slice(1))
}

// Logic
const sif = (bool, a, b) => bool ? a : b
const and = (a, b) => a && b
const or = (a, b) => a || b
const not = a => !a
const eq = (a, b) => a === b
const lt = (a, b) => a < b
const gt = (a, b) => a > b
const lte = (a, b) => a <= b
const gte = (a, b) => a >= b

// Math
const add = (a, b) => a + b
const sub = (a, b) => a - b
const mul = (a, b) => a * b
const div = (a, b) => a / b
const mod = (a, b) => a % b
const pow = (a, b) => a ** b

// Lists
const map = (list, lambda) => list.map(lambda)
const filter = (list, lambda) => list.filter(lambda)
const find = (list, lambda) => list.find(lambda)
const every = (list, lambda) => list.every(lambda)
const some = (list, lambda) => list.some(lambda)
const flatten = (list, lambda) => list.flat(Infinity)
const each = (list, lambda) => list.forEach(lambda)
const push = (list, element) => [...list, element]
const pop = (list, index = null) => list[index === null ? list.length - 1 : index]
const first = list => list[0]
const last = list => list[list.length - 1]
const reduce = (list, lambda, accumulator) => list.reduce(lambda, accumulator)
const reverse = list => __deepClone__(list).reverse()
const diff = (a, b) => a.filter(e => !b.includes(e))
const range = (start, end, step = 1) => {
    const result = []
    let current = start

    while (current < end) {
        result.push(current)
        current += step
    }

    return result
}
const merge = (a, b) => [...a, ...b]
const length = list => list.length
const contains = (list, element) => list.includes(element)
const sort = list => __deepClone__(list).sort()
const sum = list => list.reduce((e, a) => e + a, 0)
const join = (list, sep) => list.join(sep)

// Misc
const raise = string => { throw string }

/**
 * Toothpick compiled source code
 */
