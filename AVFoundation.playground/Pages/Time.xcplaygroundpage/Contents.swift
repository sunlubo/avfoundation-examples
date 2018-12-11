//
//  Time.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import CoreMedia
import QuartzCore

// 3s
let time1 = CMTime(value: 3, timescale: 1)
let time2 = CMTime(value: 1800, timescale: 600)
let time3 = CMTime(value: 3000, timescale: 1000)
let time4 = CMTime(value: 1, timescale: 30)
let time5 = CMTime(seconds: 1, preferredTimescale: 30)

time1 == time2

time1 + time2
time1 - time2
CMTimeMultiply(time1, multiplier: 2)
CMTimeMultiplyByRatio(time1, multiplier: 2, divisor: 4)

CMTimeConvertScale(time1, timescale: 600, method: .default)

CMTimeMaximum(time4, time5)
CMTimeMinimum(time4, time5)

let range = CMTimeRange(start: time1, duration: time2)

// Returns the current absolute time, in seconds.
//
// A CFTimeInterval derived by calling mach_absolute_time() and converting the result to seconds.
CACurrentMediaTime()

mach_absolute_time()

//: [Next](@next)
