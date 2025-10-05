
# Popularity vs. Quality: exploring the quadtric relationship between ratings and vote counts on IMDb
This study investigates the relationship between popularity (measured by the number of votes) and perceived quality (average IMDb rating) of films and series. Using IMDb data, the analysis examines whether highly rated titles also attract more votes, or whether popularity and quality diverge and it explores whether this relationship differs across genres and between movies and series (i.e. content form). 

## Motivation

The relationship between the number of votes and the average rating of movies could give an interesting insight into audience behavior and preferences. By researching the relationship between number of votes and average rating, knowledge is gained that is valuable for film studios, reviewers and marketing professionals in the entertainment industry.

Due to prior research on the polarization effect, the expectation is that there is not a linear relationship between the number of votes and the average rating of movies but a quadratic one. There are two competing hypotheses on the shape of this non-linear (quadratic) relationship. First, it could be that very popular (i.e. high rating) and very non-popular (i.e. low rating) content is reviewed more often because strong opinions might be expressed more often. This would create a concave up relationship between rating and vote count. On the other hand, it could be that more mainstream movies which are watched very often, receive also many ratings which are all quite average because it appeals to a large mass. This would be the case of a concave down relationship.

The relationship is controlled for 1) the difference in genre, and 2) the difference between movies and series. Different genres can attract different audiences which could have a different behavior towards giving ratings. A very wide spread popular movie could be rated very different than a very niche genre for a specific audience. The difference between movies and series can lead to different outcomes because the length and setting in which people view those two can vary.

The suitable research question follows: 
What is the relationship between the number of votes and the average rating of movies on IMDb?
Sub questions: 
  1. Does the relationship between number of votes and average rating differ across movie genres (escapist (fantasy, comedy, romance) and heavy (drama, thriller))?
  2. Does the relationship between number of votes and average rating differ across movies and series (i.e. content form)?

## Data

### Sources
We use two official **IMDb datasets** ([IMDb Interfaces](https://www.imdb.com/interfaces/)):

- **`title.basics.tsv.gz`** — metadata on titles (type, release year, genres)  
- **`title.ratings.tsv.gz`** — user ratings and vote counts  

For reproducibility and speed, a **sample of 200,000 rows** was downloaded from each file and merged via the unique identifier **`tconst`**.  
Sampling was performed with a fixed seed (`set.seed(123)`) to ensure the same subset of data is used when the pipeline is re-run.  

### Cleaning & Preparation
The raw IMDb files were merged and then cleaned to produce an analytical dataset suitable for testing our research questions.  

Key steps:  
- Removed titles with fewer than **20 votes** (to ensure stable and representative ratings).  
- Limited to the main content forms: **movies** (`movie`, `tvMovie`) and **series** (`tvSeries`, `tvMiniSeries`).  
- Grouped genres into broader **families**:  
  - *Escapist*: Fantasy, Comedy, Romance, Action, Adventure, Animation, Family  
  - *Heavy*: Drama, Thriller, Biography, Crime, Documentary  
  - *Mixed*: titles spanning both groups  
- Created **transformed vote variables** to account for skew and non-linearity:  
  - `votes2` = numVotes²  
  - `log_votes` = log₁₀(numVotes)  
  - `log_votes2` = (log₁₀(numVotes))²  
- Added **period categories** (*Pre-War*, *Interwar*, *Post-War*, *Modern*) based on release year.  
- Added **rating categories** (*Very Bad*, *Bad*, *Average*, *Good*, *Excellent*) for potential ordinal analysis.  
- Produced a **final dataset** (`imdb_analysis`) combining ratings, votes, content form, period, and genre family.  

### Observations
From the current run (200k IMDb sample):  

- **All titles with ≥ 20 votes**: 367,691  
- **After restricting to main content forms**: 367,691  
- **Final dataset (`imdb_analysis`)**: 367,691  

Breakdown:  
- **Movies**: ~312,000  
- **Series**: ~55,000  
- **By genre family (across movies & series)**:  
  - Escapist → 4,822  
  - Heavy → 5,408  
  - Mixed → 6,932  

### Variables in Final Dataset (`imdb_analysis`)

| Variable           | Description                       | Type        | Notes |
|--------------------|-----------------------------------|-------------|-------|
| `tconst`           | IMDb unique identifier             | Character   | Used for joins |
| `titleType`        | Original IMDb title type           | Character   | e.g. `movie`, `tvSeries` |
| `type`             | Content form                       | Character   | Recoded: *movie* vs *series* |
| `startYear`        | Release year                       | Numeric     | Used for descriptives and period grouping |
| `genres`           | Original genre labels              | Character   | Source for `genre_family` |
| `genre_family`     | Broad genre grouping               | Character   | *Escapist*, *Heavy*, *Mixed* |
| `averageRating`    | IMDb mean user rating (1–10)       | Numeric     | Per-title perceived quality |
| `numVotes`         | Number of IMDb votes               | Numeric     | Popularity measure |
| `votes2`           | Squared number of votes            | Numeric     | Captures nonlinear scale effects |
| `log_votes`        | Log-transformed vote counts        | Numeric     | Reduces skew |
| `log_votes2`       | Squared log of votes               | Numeric     | Captures curvature |
| `period`           | Historical period                  | Character   | *Pre-War*, *Interwar*, *Post-War*, *Modern* |
| `rating_category`  | Rating category                    | Character   | *Very Bad → Excellent* (factor structure lost in CSV export) |

---
## Method

The analysis begins with a visual exploration of the data in R, where the distribution of ratings is examined across different vote counts. To account for the extreme skew in vote counts—since a few titles receive millions of votes while most receive very few—the votes variable is log-transformed.

Next, the correlation between votes and ratings is calculated to provide a preliminary indication of their relationship. A very low correlation could suggest no relationship or a non-linear relationship.

To formally test the relationship, a polynomial regression model is estimated with rating as the dependent variable and log(votes) and log(votes)<sup>2</sup> as independent variables. This allows us to capture potential non-linear effects of vote counts on ratings.

To explore potential moderating effects of genre, an interaction term between ratings and genre (categorized as escapist: fantasy, comedy, romance; and heavy: drama, thriller) is added to a separate regression model. Similarly, another model includes an interaction term between ratings and content form. Finally, a full model combines both interaction terms to assess whether including these moderators improves model fit.

For each regression, visualizations are produced to illustrate the relationships and interaction effects, providing a clear, graphical interpretation of the results.

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Repository Overview 

The repository is structured as follows: 
```
imdb-votes-vs-ratings/
├── makefile                     
├── README.md                    
├── .gitignore                   
├── .RData
├── .Rhistory            
├── data/                       
   ├── .download.stamp          
   └── clean/                  
       ├── imdb_clean.csv
       ├── imdb_clean.rds
       ├── imdb_enriched.csv
       ├── imdb_enriched.rds
       ├── imdb_analysis.csv
       └── imdb_analysis.rds
├── gen/                         
   └── output/
       ├── model1_2.png
       ├── model3.png
       └── model4.png
├── src/                         
   ├── 1-raw-data/             
       ├── download-data.R
       ├── loading-packages.R
       └── makefile
   ├── 2-data-preparation/     
       ├── data-cleaning.R
       ├── Data-preparation.R
       ├── Data_exploration.Rmd
       └── makefile
   ├── 3-analysis/             
       ├── analysis.R
       └── makefile
   └── 4-reporting/             
       ├── report.Rmd
       ├── start_app.R
       └── makefile
```

## Dependencies 
This repository contains R scripts and resources for data analysis and visualisation. To ensure smooth execution, it depends on a set of packages, most of which are built-in libraries.

External packages used
- tidyverse ```install.packages("tidyverse")```<br>
  Tidyverse is notably used for visualization (ggplot2) and data manipulation (dplyr)

## Running Instructions 

*Provide step-by-step instructions that have to be followed to run this workflow.*

## Resources
- Hsu, P., Shen, Y., & Xie, X. (2014). Predicting Movies User Ratings with Imdb Attributes. In Lecture notes in computer science (pp. 444–453). https://doi.org/10.1007/978-3-319-11740-9_41 
- IMDB data files download. (n.d.). https://datasets.imdbws.com/ 
- IMDB Non-Commercial datasets. (n.d.). developer.imdb.com. https://developer.imdb.com/non-commercial-datasets/ 
- Ramos, M., Calvão, A. M., & Anteneodo, C. (2015). Statistical patterns in movie rating behavior. PLoS ONE, 10(8), e0136083. https://doi.org/10.1371/journal.pone.0136083 
- Unveiling Audience Preferences: A big data analysis of IMDB movie ratings and trends. (2025, June 25). IEEE Conference Publication | IEEE Xplore. https://ieeexplore.ieee.org/abstract/document/11089925

## Authors
This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

### Team 5
This team comprises students participating in the aforementioned program.
- [Sanne Wielders](https://github.com/SanneWielders), e-mail: s.c.h.wielders@tilburguniversity.edu  
- [Jeroen Swolfs](https://github.com/JeroenSwolfs), e-mail: j.a.j.d.swolfs@tilburguniversity.edu 
- [Edwin van Zon](https://github.com/edwinvanzon), e-mail: e.vanzon@tilburguniversity.edu  
- [Eveline Verhage](https://github.com/eef223), e-mail: e.m.a.verhage@tilburguniversity.edu  
- [Eefje van der Sanden](https://github.com/EefjevdSanden), e-mail: e.j.m.vdrsanden@tilburguniversity.edu

