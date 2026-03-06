# SAFS SIV - A high-speed Self-Aligned Focusing Schlieren Velocimetry system

Big thanks to MazinLab for publishing their laser driver! It enabled us to build this project at a very low cost!

## Project Description

Velocimetry in high-speed aerodynamics (supersonic flows, more specifically) is very challenging. The flow velocities are so high that you need a high-frequency light source to be able to capture all the dynamics of the flow. More challengingly, the high velocities also bring the required delay between consecutive frames to order <500ns, requiring two light sources and the staggering of pulses.
For Particle Image Velocimetry (PIV), a laser capable of illuminating particles with sufficiently strong light energy to scatter enough light to excite a camera sensor is tremendous. Anything short of ~10mJ/pulse makes the diagnostic extremely challenging to perform. With the high speed constratint to capture the dynamics, the cost of a light source can run over 300,000 USD - making this type of research prohibitively expensive even for the most well-funded labs.

Our SAFS-SIV design overcomes these constraints by leveraging very recent progress in focusing schlieren: The Self-Aligned Focusing Schlieren (SAFS) optics enable portable focusing schlieren with very limited depth of field (enabling slicing of the flow, like PIV) and minimal alignment complexity. We combine this technique, which already produces valuable qualitative flow visualizations, with a double-pulsed light source to obtain velocity measurements in high-speed flows.

The SAFS optics are significantly cheaper and have other applications outside of velocimetry, making for a much more flexible diagnostic tool. 

With our SAFS-SIV system, we are able to build a light source for under USD 1000 that is capable of 50kHz double-pulses with 50ns pulse width, able to almost eliminate motion blur from flows at supersonic speeds.

