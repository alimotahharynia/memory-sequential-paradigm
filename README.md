# Sequential paradigm with bar stimuli
This repository contains MATLAB code implementing two analog report tasks for evaluating visual working memory (WM). These tasks involve sequential bar presentation and are categorized into two memory load conditions: low memory load (1-bar) and high memory load (3-bar).

![Figure 1](https://github.com/user-attachments/assets/71a74707-88f8-4c6c-92b9-8a5679039527)

## Paradigm Overview
### High Memory Load Condition (3-Bar Design, Six blocks of 30 trials each)
-  Fixation Phase:
A small central fixation point (0.26°) is displayed for 2 seconds at the beginning of each trial.

-  Stimulus Presentation:
Three distinguishable colored bars (red, green, and blue) are shown in pseudo-random order at the center of the screen.
Each bar (2.57° by 0.19°) is presented for 500ms, followed by a 500ms blank interval.

-  Taks:
Participants memorize both the orientation and color of the presented bars.

-  Probe:
A single bar (the "probe bar") is displayed vertically and cued by the color of one of the previously shown bars.
Participants adjust the probe bar's orientation using a mouse to match the orientation of the target bar (same color as the probe).

-  Feedback:
The correct orientation of the target bar is shown.
The participant’s response is displayed along with the angular error.

### Low Memory Load Condition (1-Bar Design)
Same structure as the high memory load condition but presents only one bar instead of three.
Fewer trials are required (30 trials) due to the absence of swap errors.
Participants complete this condition after the high memory load condition.

## Recorded Data
-  The following parameters are recorded during each trial:
Orientation of presented bars: Actual orientations of the stimuli.
Subject response: Orientation of the probe bar set by the participant.
Recall error (Absolute error): Absolute angular difference between the target bar and the response.
Reaction time: Time taken by participants to complete their response.
Dynamic record of subject response and reaction time for each click

## Requirements
-  Software
MATLAB: Required to run the code.
Psychtoolbox: Used for visual stimuli presentation and input handling.

## How to Run the Experiment
-  Clone the repository:
```bash
git clone https://github.com/alimotahharynia/memory-sequential-paradigm.git  
```
-  Open MATLAB and navigate to the cloned repository folder.
-  Run the main script:
```bash
run sequentialParadigm
```
-  Follow on-screen instructions for the experiment.

## Citation
If you use this paradigm in your research, please cite our papers:
```
Motahharynia A, Pourmohammadi A, Adibi A, Shaygannejad V, Ashtari F, Adibi I, Sanayei M. A mechanistic insight into sources of error of visual working memory in multiple sclerosis. Elife. 2023 Nov 8;12:RP87442. doi: 10.7554/eLife.87442. PMID: 37937840; PMCID: PMC10631758.
```
```
Hojjati F, Motahharynia A, Adibi A, Adibi I, Sanayei M. Correlative comparison of visual working memory paradigms and associated models. Sci Rep. 2024 Sep 6;14(1):20852. doi: 10.1038/s41598-024-72035-5. PMID: 39242827; PMCID: PMC11379810.
```
