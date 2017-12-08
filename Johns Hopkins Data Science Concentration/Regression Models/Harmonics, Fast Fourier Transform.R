## Harmonics
##Chord finder, playing the white keys on a piano from octave c4 - c5


## Simulation that shows what a discrete fourier transform is doing.

### c4, e, f, g, a, b, c5 note frequencies
notes4 <- c(261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25)
### Period range
t <- seq(0, 2, by = .001); n <- length(t)
### 1 chord = 3 notes; Wave functions for the c4,e4,g4 notes
c4 <- sin(2 * pi * notes4[1] * t); e4 <- sin(2 * pi * notes4[3] * t); 
g4 <- sin(2 * pi * notes4[5] * t)
### Chord that is to be "played" (with some random noise)
chord <- c4 + e4 + g4 + rnorm(n, 0, 0.3)
### Creating basis functions which are a bunch of sine terms
x <- sapply(notes4, function(freq) sin(2 * pi * freq * t))
### Fitting observed chord as a function the basis without intercept
fit <- lm(chord ~ x - 1)

### plots coef^2 vs notes; spikes at c4, e4, and g4 like we wanted. Regression figured
### out the chords that were played
plot(c(0, 9), c(0, 1.5), xlab = "Note", ylab = "Coef^2", axes = FALSE, frame = TRUE, type = "n")
axis(2)
axis(1, at = 1 : 8, labels = c("c4", "d4", "e4", "f4", "g4", "a4", "b4", "c5"))
for (i in 1 : 8) abline(v = i, lwd = 3, col = grey(.8))
lines(c(0, 1 : 8, 9), c(0, coef(fit)^2, 0), type = "l", lwd = 3, col = "red")


##(How you would really do it)

### Fast Fourier Transform
### plots the Real part squared of the FFT
a <- fft(chord); plot(Re(a)^2, type = "l")
### more that 3 spikes because it's checking for those notes at other octaves.
