# FSIV - A high-speed Focusing Schlieren Velocimetry system

Big thanks to MazinLab for publishing their laser driver! It enabled us to build this project at a very low cost!

## Samples

Here's a couple samples of the images acquired with this light source:

| Shear Layer of a M=0.92 jet (dt=800 ns) | Boundary Layer of a M=0.91 plug nozzle (dt=800 ns) |
|---|---|
| ![Shear Layer](https://raw.githubusercontent.com/3dfernando/SAFS_SIV_Laser/main/Samples/DoubleFrame_ShearLayer.gif) | ![Boundary Layer](https://raw.githubusercontent.com/3dfernando/SAFS_SIV_Laser/main/Samples/DoubleFrame_Plug.gif) |

## Project Description

Velocimetry in high-speed aerodynamics (supersonic flows, more specifically) is very challenging. The flow velocities are so high that you need a high-frequency light source to be able to capture all the dynamics of the flow. More challengingly, the high velocities also bring the required delay between consecutive frames to order <500ns, requiring two light sources and the staggering of pulses.
For Particle Image Velocimetry (PIV), a laser capable of illuminating particles with sufficiently strong light energy to scatter enough light to excite a camera sensor is tremendous. Anything short of ~10mJ/pulse makes the diagnostic extremely challenging to perform. With the high speed constratint to capture the dynamics, the cost of a light source can run over 200,000 USD - making this type of research prohibitively expensive even for the most well-funded labs.

Convective velocity is also a useful flow variable, which is the velocity of the turbulent structures and is related to noise sources in aeroacoustics. It would require at least two consecutive PIV velocity field measurements to obtain a measurement of convective velocity. However, if an image of the flow structure can be acquired directly through focusing schlieren, then it is possible to measure the convective velocity directly by cross-correlating the structures of the schlieren images.

Further, the double-pulsed schlieren images can also be processed with Online DMD to extract the coherent behavior of the flow at very high frequencies, limited by the Nyquist frequency based on the inter-frame pulse delay (dt, typically <300ns). This enables the observation of coherent structures in the several hundred kHz to MHz range with the full camera resolution, which is beyond the capability of state-of-the-art high-speed cameras.

With our SAFS-SIV system, we are able to build a light source for under USD 1000 that is capable of 50kHz double-pulses with 30ns pulse width, able to almost eliminate motion blur from flows at even supersonic speeds.

