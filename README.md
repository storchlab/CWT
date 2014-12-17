CWT
===

Description: 
Import the raw locomotor activity (or other) data in one minute bins
ensuring that first day of the file is padded backwards to midnight and 
the last day is padded forward to 11:59 PM with zeros.
raw data should be imported into a vector called "thedata".

Input:
thedata   - the signal
sr        - sampling rate of the signal
freqs     - vector containing the frequency values for which the 
              coefficientsN will be calculated
min/maxcyc- the frequency range of interest in cycles per day
freqs     - vector containing the frequency values for which the coefficients
         will be calculated

Written by Ian David Blum 2013

