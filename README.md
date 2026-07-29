# FSIV - A high-speed Focusing Schlieren Velocimetry system

Big thanks to MazinLab for publishing their laser driver! It enabled us to build this project at a very low cost!

## Samples

Here's a couple samples of the images acquired with this light source:

| Shear Layer of a M=0.98 jet (dt=800 ns) | Boundary Layer of a M=0.91 plug nozzle (dt=800 ns) |
|---|---|
| ![Shear Layer](https://raw.githubusercontent.com/3dfernando/SAFS_SIV_Laser/main/Samples/DoubleFrame_ShearLayer.gif?raw=true) | ![Boundary Layer](https://raw.githubusercontent.com/3dfernando/SAFS_SIV_Laser/main/Samples/DoubleFrame_Plug.gif?raw=true) |

## Project Description

Velocimetry in high-speed aerodynamics (supersonic flows, more specifically) is very challenging. The flow velocities are so high that you need a high-frequency light source to be able to capture all the dynamics of the flow. More challengingly, the high velocities also bring the required delay between consecutive frames to order <500ns, requiring two light sources and the staggering of pulses.

For Particle Image Velocimetry (PIV), the laser must deliver sufficient pulse energy to scatter enough light onto the camera sensor — typically ≥10 mJ/pulse. Combined with the high-speed requirement, a suitable light source can exceed $200,000 USD, making this research prohibitively expensive even for well-funded laboratories. However, for schlieren imaging the amount of light required is much lower - about 10nJ/pulse are sufficient to fully illuminate the camera sensor and overcome the light losses. Thus, we developed a light source capable of ~400nJ/pulse and 30ns pulse width, which is adequate for most schlieren needs. 

Convective velocity — the velocity of turbulent structures and a key contributor to noise sources in aeroacoustics — requires at least two consecutive PIV velocity field measurements to be estimated from velocity data. However, if the flow structure can be captured directly through focusing schlieren (which images density gradients in the flow), it is possible to measure convective velocity directly by cross-correlating consecutive schlieren images.

Further, the double-pulsed schlieren images can also be processed with Online Dynamic Mode Decomposition (ODMD) to extract the coherent behavior of the flow at very high frequencies, limited by the Nyquist frequency based on the inter-frame pulse delay dt (typically <300 ns). For example, at dt=300 ns, this enables the observation of coherent structures up to ~1.7 MHz — beyond the capability of state-of-the-art high-speed cameras — at full camera resolution.

With our SAFS-SIV system, we are able to build a light source for under USD 1,000 — compared to systems exceeding $200,000 — capable of 50 kHz double-pulses with a 30 ns pulse width. At supersonic speeds, a 30 ns pulse corresponds to only ~2 μm of particle displacement, nearly eliminating motion blur. This dramatic reduction in cost opens the door to high-speed flow diagnostics for a much broader range of research groups and institutions.

## Driver Picture

Below a photograph of our laser drivers forming a double-pulse system in a 1.0 mm fiber optic:

![Fiber source laser photo](https://raw.githubusercontent.com/3dfernando/SAFS_SIV_Laser/main/Samples/FS_Source_Photo.png)

A closer view of the PCB design:

![Fiber source laser photo](https://raw.githubusercontent.com/3dfernando/SAFS_SIV_Laser/main/Samples/PCB_3D.png)

