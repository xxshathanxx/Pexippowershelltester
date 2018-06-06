# Pexippowershelltester

This is a automatic tester that creates a vmr room on a pexip infinity video conferencing solution. 

Right now it creates a conference based on the name in config.json and dials participants located in the connections.csv. It then waits 30 seconds and disconnects all the participants and destroys the conference.

Todo:

Add statistically analysis of the audio/video to rate the quality and find any issues.
