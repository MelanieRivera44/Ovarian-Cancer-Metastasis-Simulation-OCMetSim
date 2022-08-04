;;Ovarian Cancer Metastasis Simulation-Single Cells
;;OCMetSIM-Single Cells
;;AGENT-BASED MODELING PREDICTS RAC1 IS CRITICAL FOR OVARIAN CANCER METASTASIS

turtles-own [probInvasion]
globals[CrowdingDeath num_run time]

To Setup ;;Button
  clear-all
  ;; The following will create a world with 3 colors to represent 3 compartments that the turtles (ovarian cancer cells) will move through
  ;; Black- peritoneum (abdonimal cavity), red- blood, brown- distant tissue site
  ;; Initial_NumberOfCells will adhered to the peritoneum and will enter circulation and travel to the distant tissue site
  ;; Cancer cells will move according to adhesion and invasion parameters measured based on expression of Rac1 GTPase
  ;; This simulation represents ovarian cancer single cells

  set CrowdingDeath 0  ;;This monitor counts the number of cells that die from crowding along the blood vessel
  set num_run 30  ;;Changing this number allows the user to set the number of simultaneous runs performed per button push

  ;; patches for peritoneum (abdonimal cavity) compartment
  ask patches with [pycor >= -26]
  [
    set pcolor black
  ]
  ;; patches for adhesion to the blood vessel
  ask patches with [pycor = -27]
  [
    set pcolor green
  ]
  ;; patches for invasion into the blood vessel
  ask patches with [pycor = -28]
  [
    set pcolor blue
  ]
  ;; patches for blood vessel
  ask patches with[pycor <= -29 and pycor >= -46]
  [
    set pcolor red
  ]
  ;; patches for adhesion to distant tissue site
  ask patches with [pycor = -47]
  [
    set pcolor cyan
  ]
  ;; patches for invasion into distant tissue site
  ask patches with [pycor = -48]
  [
    set pcolor magenta
  ]
  ;; patches for distant tissue site
  ask patches with [pycor <= -49]
  [
    set pcolor brown
  ]

  create-turtles Initial_NumberofCells ;;Changing this slider allows the user to change the number of cancer cell agents that are created in the world
  [
    set xcor random-xcor
    set ycor -26 + random 87 ;;Creating the cells at these coordinates, creates them specifically in the peritoneal compartment
    set shape "circle"
    set color yellow
  ]

  reset-ticks

end

To Go_AdhesionAndInvasion ;;Button
  ;;The To Go_AdhesionAndInvasion button runs the simulation commands to test ovarian cancer metastasis to a distant tissue site with parameters for cellular adhesion and invasion based on Rac1 expression

  ;;Cells_MoveIn_Peritoneum- Ovarian cancer cells move in the peritoneal space
  ;;Cell_Adhesion_withDeath- Once the cells encounter the blood vessel, they are able to adhere based on experimental parameters set from in vitro experiments from cells with varying expression of Rac1
  ;;Cell_Invasion- When the cells adhere to the blood vessel, they are able to invade into ciruclation based on experimental parameters
  ;;Cells_ProbDeathInBlood- After the cells have invaded into the blood stream, some may die based on a probability of death in the blood stream
  ;;Cells_MoveIn_Blood- If the cells survive in the blood, they move toward the distant tissue site
  ;;Cells_AdhesionDistantTissue-Once the cells encounter the distant tissue, they are able to adhere based on experimental parameters set from in vitro experiments from cells with varying expression of Rac1
  ;;Cells_InvasionDistantTissue- When the cells have adhered to the distant tissue site, they are able to invade into the tissue based on experimental parameters
  ;;Cells_InDistantTissueSite- When the cell agents have invaded into the distant site, they change color and the simulation stops.  Ticks(time) and the number of cells can be quantified
  ;;Plots from each simulation run can also be saved as described below to track the number of cells in each compartment over each simulation run

  ;;Experimental adhesion and invasion parameters were set based on Rac1 overexpression or knockdown to compare differences in metastasis based on Rac1 expression

  Cells_MoveIn_Peritoneum
  Cell_Adhesion_withDeath
  Cell_Invasion
  Cells_ProbDeathInBlood
  Cells_MoveIn_Blood
  Cells_AdhesionDistantTissue
  Cells_InvasionDistantTissue
  Cells_InDistantTissueSite

  tick
  if not any? turtles with [color = yellow] ;;agents will change color to white during the last step and the simulation will stop if there are no more yellow cells left
  [
    set num_run num_run - 1
    set time (remove ":"remove":" remove " " ( date-and-time ))
    export-all-plots  (word "insert folder path here to save plots" time ".csv");;insert a folder path to export the plots from the simulation interface for further analysis/quantification
    Setup_duringRuns;;this procedure allows the simulation space to reset itself to run simultaneous run one right after another
  ]

  if num_run = 0 ;;The simulation will stop running when all the number of runs set have completed
  [
    stop
  ]

end

To Go_CellCrowding ;;Button
  ;;The To Go_CellCrowding button runs the simulation commands to test ovarian cancer metastasis to a distant tissue site while considering the possibility that cells can crowd along the blood vessel and cells can potentially die due to cell crowding and non-attachement
  ;;The adhesion and invasion parameters are the same as described above with parameters for cellular adhesion and invasion based on Rac1 expression

  ;;Cells_MoveIn_Peritoneum- Ovarian cancer cells move in the peritoneal space
  ;;Cell_Adhesion_withDeath_CrowdingEffectAdded_withCrowdingDeath- Once the cells encounter the blood vessel, they crowd the space around the blood vessel until the cells in front of eachother adhere and invade into the blood vessel
  ;;While the cells are crowding the blood vessel, they have a probability of dying due to cell crowding if they are not able to adhere to the blood vessel
  ;;Cell_Invasion- When the cells adhere to the blood vessel, they are able to invade into ciruclation based on experimental parameters
  ;;Cells_ProbDeathInBlood- After the cells have invaded into the blood stream, some may die based on a probability of death in the blood stream
  ;;Cells_MoveIn_Blood- If they cells survive in the blood, they move toward the distant tissue site
  ;;Cells_AdhesionDistantTissue-Once the cells encounter the distant tissue, they are able to adhere based on experimental parameters set from in vitro experiments from cells with varying expression of Rac1
  ;;Cells_InvasionDistantTissue- When the cells have adhered to the distant tissue site, they are able to invade into the tissue based on experimental parameters
  ;;Cells_InDistantTissueSite- When the cell agents have invaded into the distant site, they change color and the simulation stops.  Ticks(time) and the number of cells can be quantified
  ;;Plots from each simulation run can also be saved as described below to track the number of cells in each compartment over each simulation run

  Cells_MoveIn_Peritoneum
  Cell_Adhesion_withDeath_CrowdingEffectAdded_withCrowdingDeath
  Cell_Invasion
  Cells_ProbDeathInBlood
  Cells_MoveIn_Blood
  Cells_AdhesionDistantTissue
  Cells_InvasionDistantTissue
  Cells_InDistantTissueSite

  tick

  if not any? turtles with [color = yellow]
  [
    set num_run num_run - 1
    set time (remove ":"remove":" remove " " ( date-and-time ))
    export-all-plots  (word "insert folder path here to save plots" time ".csv");;insert a folder path to export the plots from the simulation interface for further analysis/quantification
    Setup_duringRuns;;this procedure allows the simulation space to reset itself to run simultaneous run one right after another
  ]

  if num_run = 0
  [
    stop
  ]

end


To Setup_duringRuns
  ;;The To Setup_during procedure is used to resetup the simulation world while running multiple simulation runs back to back
  ;;Setup_during is identical to Setup except this procedure tracks the number of turtles, ticks, the number of turtles dying from crowding, and resets plots

  show count turtles
  show CrowdingDeath
  clear-turtles
  clear-all-plots

  set CrowdingDeath 0
  ;; patches for peritoneum (abdonimal cavity)
  ask patches with [pycor >= -26]
  [
    set pcolor black
  ]
  ;; patches for adhesion to the blood vessel
  ask patches with [pycor = -27]
  [
    set pcolor green
  ]
  ;; patches for invasion into the blood vessel
  ask patches with [pycor = -28]
  [
    set pcolor blue
  ]
  ;; patches for blood vessel
  ask patches with[pycor <= -29 and pycor >= -46]
  [
    set pcolor red
  ]
  ;; patches for adhesion to distant tissue site
  ask patches with [pycor = -47]
  [
    set pcolor cyan
  ]
  ;; patches for invasion into distant tissue site
  ask patches with [pycor = -48]

  [
    set pcolor magenta
  ]
  ;; patches for distant tissue site
  ask patches with [pycor <= -49]
  [
    set pcolor brown
  ]

  create-turtles Initial_NumberofCells
  [
    set xcor random-xcor
    set ycor -26 + random 87
    set shape "circle"
    set color yellow
  ]
  show ticks
  reset-ticks
end


To Cells_MoveIn_Peritoneum
  ;;To Cells_MoveIn_Peritoneum dictates how the cells move in the peritoneal space
  ;;Ovarian cancer cell agents are created in this space
  ;;The agents move in the peritoneal compartment by random diffusion
  ;;The agents do not occupy a patch that is already occupied
  ;;The agents move around until they adhere to the blood vessel (green patches) and the next procedure step, To Cell_Adhesion_withDeath, becomes activated
  ;;When thinking about the inital number of cells to start with, be careful not to over occupy the black patches with too many agents
  ;;A counter was added to this procedure in case too many intial agents were used.  The simulation would not run if the number of agents was larger than the number of black patches
  ;;The counter is there to break the limited movement if the peritoenal space if overcrowded, however, using an appropriate number of cells is important to consider for each user's system and scientific questions to be answered.

  ask turtles
  [
    let colorofPatchAhead black
    let counter 0
    ifelse patch-ahead 1 = nobody
    [
      set heading 180
    ]
    [
      ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = black) ;;if patch ahead is black, the turtles will check if it is occupied, if it is occupied they will set heading to random 360 then forward 1

      [
        while [patch-ahead 1 != nobody and (colorofPatchAhead = black) and any? turtles-on patch-ahead 1 and counter < 100 ]
        [
         set heading random 360
         set counter counter + 1
          if patch-ahead 1 = nobody
    [
      set heading 180
    ]
          ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = green)
      [
        set counter 100
          ]
        ]

        if counter < 100
        [
          forward 1 ;;forward command moved above wiggle commands to prevent cells from moving into the blood vessel patches if they are not adhered
          right (random wiggleRight)
          left (random wiggleLeft)
        ]
        ]
      ]
    ]

end

To Cell_Adhesion_withDeath
  ;;To Cell_Adhesion_withDeath is used to test adhesion with cell death and invasion into the blood stream and distant tissue site, while ignorning crowding along the blood vessel
  ;;Activated when Go_AdhesionAndInvasion button is pushed
  ;;To test crowding along the blood vessel, use the button Go_CellCrowding, and the commands for considering cell crowding are in Cell_Adhesion_withDeath_CrowdingEffectAdded_withCrowdingDeath-described below.

  ;;Once the ovarian cancer cell agents have moved around the peritoenal space and encounter the green patches, the ovarian cancer cells are able to adhere based on an adhesion probability parameter set based on Rac1 expression
  ;;The probability of adhesion, each timestep, that a cell adheres to the blood vessel
  ;;If the cells adhere, they move forward 1 into the green patches
  ;;If the cells do not adhere, they die due to non-attachement


  ask turtles
  [
    let colorofPatchAhead red
    if pcolor = black and pycor <= 59
    [
      ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = green)
      [
        ifelse random 100 < probAdhesion ;;Adhesion variable
        [
          forward 1 ;;the cell will move forward 1 patch and officially adhere to the blood vessel based on the adhesion probability
          ]
          [
            die ;;the cell will die if it does not adhere to the blood vessel
          ]
        ]
      ]
    ]

end


To Cell_Adhesion_withDeath_CrowdingEffectAdded_withCrowdingDeath
  ;;To Cell_Adhesion_withDeath_CrowdingEffectAdded_withCrowdingDeath is used to test the effects of cells crowding about the blood vessel and potentially dying due to cell crowding
  ;;Activated when Go_CellCrowding button is pushed

  ;;Once the ovarian cancer cell agents have moved around the peritoenal space and encounter the green adhesion patches for adhesion to the blood vessel, they are only able to adhere to the blood vessel if the patch in front of them is not occupied
  ;;If the patch-ahead 1 is occupied, the cell will wait to move and adhere to the crowded blood vessel.
  ;;However, while the cels is waiting to adhere, there is a probability that the cell will die due to cell crowding and not being able to attach, per each timestep
  ;;Ovarian cancer cells are able to adhere based on an adhesion probability parameter set based on Rac1 expression
  ;;The probability of adhesion, each timestep, that a cell adheres to the blood vessel
  ;;If the cells adhere, they move forward 1 into the green patches
  ;;If the cells do not adhere, they die due to non-attachement

  ask turtles
  [
    let colorofPatchAhead red
    if pcolor = black and pycor <= 59
    [
      ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = green)
      [
        ifelse (any? turtles-on patch-ahead 1)
        [
          ifelse random 100 < probCrowdingDeath
          [
            set CrowdingDeath CrowdingDeath + 1 ;;monitor to count the number of cells that die from cell crowding
            die ;;the cell will die due to cell crowding along the blood vessel
          ]
          [
            stop ;;the cell will wait to move until the patch ahead 1 is unoccupied
          ]
          ]
        [
          ifelse random 100 < probAdhesion ;;when the patch ahead 1 is unoccupied, the cell will now have a probability of adhesion to the blood vessel
          [
            forward 1 ;;the cell will move forward 1 patch and officially adhere to the blood vessel based on the adhesion probability
            ]
          [
            die  ;;the cell will die if it does not adhere to the blood vessel
            ]
          ]
        ]
      ]
    ]

end

To Cell_Invasion
  ;;Once the cells have adhered to the blood vessel, the rate/probability of invasion is activated
  ;;Invasion parameters are set based on experimental data from in vitro experiments from cells with varying expression of Rac1
  ;;The probability, each time step, that a cell invades into the blood vessel once adhered

 ask turtles
  [
    if pcolor = green
    [
      set heading 180
      set probInvasion random-poisson InvasionParameter  ;;Invasion variable
      if (probInvasion > 0)
      [
       forward 1
      ]
    ]
  ]

end

To Cells_ProbDeathInBlood
  ;;After the ovarian cancer cells have invaded into the blood stream, they have a probability of dying in the blood stream
  ;;Probability of cell death in the blood, each time step, when the cell first enters the blood stream (red patches)

  ask turtles
  [
    if pcolor = blue
    [
      set heading 180
      let colorofPatchAhead red
      ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = red)
      [
        ifelse (random 100 < probDeathInBloodStream) ;;Probability of cell death in the blood
        [
         die
        ]
        [
          forward 1
          set heading 225
        ]
      ]
    ]
  ]

end

To Cells_MoveIn_Blood
  ;;The ovarian cancer cells that have survived in the bloodstream will move forward 1 patch until they encounter patches for Adhesion to the Distant Tissue Site.
  ;;When the agents have moved through the red patches, the Cells_AdhesionDistantTissue command becomes activated

  ask turtles
  [
    if pcolor = red
    [
      let colorofPatchAhead red
      ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = red)
      [
        forward 1
      ]
    ]
  ]

end

To Cells_AdhesionDistantTissue
  ;;After the ovarian cancer cells move through the blood and encounter the distant tissue site, they have a probability of adhering to the distant tissue
  ;;The probability of adhesion, each timestep, that a cell adheres to the distnat tissue site
  ;;If the cells adhere, they move forward 1 into the cyan patches
  ;;If the cells do not adhere, they die due to non-attachement

 ask turtles
  [
    let colorofPatchAhead red
    if pcolor = red and pycor = -46
    [
      ask patch-ahead 1
      [
        set colorofPatchAhead pcolor
      ]
      if (colorofPatchAhead = cyan)
      [
        ifelse random 100 < probAdhesion
        [
          forward 1
          ]
          [
            die
          ]
        ]
      ]
    ]

end

To Cells_InvasionDistantTissue
  ;;Once the cells have adhered to the distant tissue site, the rate/probability of invasion is activated
  ;;Invasion parameters are set based on experimental data from in vitro experiments from cells with varying expression of Rac1
  ;;The probability, each time step, that a cell invades into the distant tissue site once adhered

  ask turtles
  [
    if pcolor = cyan
    [
      set heading 180
      set probInvasion random-poisson InvasionParameter
      if (probInvasion > 0)
      [
        forward 1
      ]
    ]
  ]

end

To Cells_InDistantTissueSite
  ;;To Cells_InDistantTissueSite is the last step in the metastatic process
  ;;Once the ovarian cancer agents invade into the distant tissue site, they turn white and step forward into the distant tissue compartment and the simulation stops
  ;;The number of cells in the distant tissue site is counted by a monitor
  ;;The number of ticks at the top represents overall time it took for the cells to reach the distant tissue site

  ask turtles
  [
    if pcolor = magenta
    [
      forward 1
      set color white
    ]
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
552
10
1465
624
-1
-1
5.0
1
10
1
1
1
0
1
0
1
-90
90
-60
60
0
0
1
ticks
30.0

SLIDER
369
362
541
395
wiggleRight
wiggleRight
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
369
401
541
434
wiggleLeft
wiggleLeft
0
100
50.0
1
1
NIL
HORIZONTAL

BUTTON
18
10
82
43
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
47
192
80
NIL
Go_AdhesionAndInvasion
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
14
145
220
178
Initial_NumberOfCells
Initial_NumberOfCells
0
10000
1000.0
10
1
NIL
HORIZONTAL

PLOT
13
364
354
578
# of cells in each compartment
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Peritoneum" 1.0 0 -16777216 true "" "plot count turtles with [pcolor = black]"
"Blood" 1.0 0 -2674135 true "" "plot count turtles with [pcolor = red]"
"Distant Tissue" 1.0 0 -6459832 true "" "plot count turtles with [color = white]"
"Crowding death" 1.0 0 -7500403 true "" "plot Crowdingdeath"
"Adhesion" 1.0 0 -10899396 true "" "plot count turtles with [pcolor = green]"
"Invasion" 1.0 0 -13345367 true "" "plot count turtles with [pcolor = blue]"
"Adhesion2" 1.0 0 -11221820 true "" "plot count turtles with [pcolor = cyan]"
"Invasion2" 1.0 0 -5825686 true "" "plot count turtles with [pcolor = magenta]"

MONITOR
256
59
480
104
# of cells invaded into the blood
count turtles with [pcolor = blue]
17
1
11

MONITOR
255
107
439
152
# of cells in the blood
count turtles with [pcolor = red]
17
1
11

MONITOR
252
206
464
251
# of cells invaded into distant tissue
count turtles with [pcolor = 125]
17
1
11

MONITOR
253
157
458
202
# of cells adhered to distant tissue
count turtles with [pcolor = cyan]
17
1
11

SLIDER
13
274
252
307
probDeathInBloodStream
probDeathInBloodStream
0
100
20.0
10
1
NIL
HORIZONTAL

MONITOR
253
307
349
352
# of total cells
count turtles
17
1
11

SLIDER
12
185
184
218
probAdhesion
probAdhesion
0
100
80.0
1
1
NIL
HORIZONTAL

CHOOSER
14
224
152
269
InvasionParameter
InvasionParameter
0.060578704 2.77778E-4 0.001757813
0

MONITOR
253
256
434
301
# of cells in distant tissue site
count turtles with [color = white]
17
1
11

MONITOR
256
10
535
55
# of cells adhered to the blood vessel
count turtles with [pcolor = green]
17
1
11

SLIDER
12
314
184
347
probCrowdingDeath
probCrowdingDeath
0
100
35.0
5
1
NIL
HORIZONTAL

MONITOR
415
463
529
508
NIL
CrowdingDeath
17
1
11

BUTTON
20
85
145
118
NIL
Go_CellCrowding
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

Ovarian Cancer Metastasis Simulation-Single Cells
OCMetSim-Single Cells

This program was made to simulate ovarian cancer cell metastasis from the peritoneum, into circulation, then to a distant tissue site, based on parameters collected from in vitro adhesion and invasion experimental data using ovarian cancer cells with varying expression of Rac1 GTPase.

The goal of this model is to make predictions about ovarian cancer cell behavior and metastasis to distant niche sites based on Rac1 GTPase expression. 

This program simulates single cell ovarian cancer cells.


## HOW IT WORKS

This program simulates single cell ovarian cancer cells.  The world size of OCMetSIM-Single Cells is 3 times larger than OCMetSIM-Spheroids to compare metastasis of ovarian cancer single cells vs ovarian cancer spheroids.  In this program, a turtle represents 1 single cell.

This program was made to investigate how Rac1 GTPase contributes to ovarian cancer cell metastasis. The adhesion and invasion parameters were set based on experimental data to compare cells with Rac1 overexpression or Rac1 knockdown. The user can also change these parameters based on their experimental needs to test their favorite protein of interest.

## HOW TO USE IT

To run metastasis simulations using adhesion and invasion parameters:

1. Set Initial_NumberOfCells slider to the desired cell number
2. Set appropriate probability of adhesion parameter
3. Set appropriate probability/rate of invasion parameter
4. Set appropriate probability of death in the blood
5. Set wiggleRight and wiggleLeft values to 50 to simulate agent movement by random diffusion
6. In the code tab, under the 'To Go_AdhesionAndInvasion' procedure, setup a file path with a folder to save the plot data 
7. Click the Setup Button
8. Click the Go_AdhesionAndInvasion

To run metastasis simulations using adhesion and invasion parameters while also considering the possibility that cells can crowd along the blood vessel and die:

1. Set Initial_NumberOfCells slider to the desired number
2. Set appropriate probability of adhesion parameter
3. Set appropriate probability/rate of invasion parameter
4. Set appropriate probability of death in the blood
5. Set appropriate probability of cell death from crowding
6. Set wiggleRight and wiggleLeft values to 50 to simulate agent movement by random diffusion
7. In the code tab, under the 'To Go_CellCrowding' procedure, setup a file path with a folder to save the plot data
8. Click the Setup Button
9. Click the Go_CellCrowding

The interface tab has monitors to show the number of cells in the different compartments and a plot to track where the cells are located during the simulation runs.  Ticks are counted at the top. 


## CREDITS AND REFERENCES

NetLogo commands: http://ccl.northwestern.edu/netlogo/docs/dictionary.html
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
