
# Popularity vs. Quality: exploring the quadtric relationship between ratings and vote counts on IMDb
This study investigates the relationship between popularity (measured by the number of votes) and perceived quality (average IMDb rating) of films and series. Using IMDb data, the analysis examines whether highly rated titles also attract more votes, or whether popularity and quality diverge and it explores whether this relationship differs across genres and between movies and series (i.e. content form). 

## Motivation

The relationship between the number of votes and the average rating of movies could give an interesting insight into audience behavior and preferences. At first the expectation would be that more votes lead to a higher rating, but it is not clear if this is always the case. By researching this relationship, knowledge is gained that is valuable for film studios, reviewers and marketing professionals in the entertainment industry.

Due to prior research on the polarization effect, the expectation is that there is not a linear relationship between the number of votes and the average rating of movies but a quadratic one. There are two competing hypotheses on the shape of this non-linear (quadratic) relationship. First, it could be that very popular (i.e. high rating) and very non-popular (i.e. low rating) content is reviewed more often because strong opinions might be expressed more often. This would create a concave up relationship between rating and vote count. On the other hand, it could be that more mainstream movies which are watched very often, receive also many ratings which are all quite average because it appeals to a large mass. This would be the case of a concave down relationship.

The relationship is controlled for 1) the difference in genre, and 2) the difference between movies and series. Different genres can attract different audiences which could have a different behavior towards giving ratings. A very wide spread popular movie could be rated very different than a very niche genre for a specific audience. The difference between movies and series can lead to different outcomes because the length and setting in which people view those two can vary.

The suitable research question follows: 
What is the relationship between the number of votes and the average rating of movies on IMDb?
Sub questions: 
  1. Does the relationship between number of votes and average rating differ across movie genres (escapist (fantasy, comedy, romance) and heavy (drama, thriller))?
  2. Does the relationship between number of votes and average rating differ across movies and series (i.e. content form)?

## Data

### Datasets used and how obtained  
The analysis uses two official **IMDb datasets** ([IMDb Interfaces](https://www.imdb.com/interfaces/)):  

- `title.basics.tsv.gz` – metadata on titles (type, release year, genres)  
- `title.ratings.tsv.gz` – user ratings and vote counts  

For reproducibility and speed, we downloaded a **programmatic sample of 200,000 rows** from each file and merged them using the unique identifier `tconst`.  

---

### Final dataset  
From the merged data, a **cleaned analytical dataset** was created with the following steps:  

- Limited to **movies and series** (`movie`, `tvSeries`, `tvMiniSeries`)  
- Excluded titles with fewer than **1,000 votes** (to ensure stable rating estimates)  
- `numVotes` was **log-transformed** (`logVotes`) to reduce skew  
- Genres were collapsed into two broad **genre families**:  
  - *Escapist*: Fantasy, Comedy, Romance  
  - *Heavy*: Drama, Thriller  
- Content form was recoded into **`type`**: *movie* vs *series*  

This cleaned dataset is the one used in all analyses.  

---

### Observations  
- **Total titles analyzed:** 17,243  
- **Movies:** 15,631  
  - Escapist → 3,970  
  - Heavy → 6,220  
- **Series:** 1,612  
  - Escapist → *(observation numbers will follow)*  
  - Heavy → *(observation numbers will follow)*  

---

### Variables & operationalisation  

| Variable        | Description       s            | Type         | Operationalisation |
|-----------------|-------------------------------|--------------|--------------------|
| `tconst`        | IMDb unique identifier        | ID           | Used to merge `basics` and `ratings` datasets |
| `titleType`     | Original IMDb title type      | Categorical  | Kept for reference; collapsed into `type` |
| `type`          | Content form                  | Categorical  | Recoded: *movie* vs *series* |
| `startYear`     | Release year                  | Continuous   | Used for descriptives; not in main regression |
| `genres`        | Original genre labels         | String       | Source for collapsing into `genre_family` |
| `genre_family`  | Broad genre grouping          | Categorical  | *Escapist* (Fantasy, Comedy, Romance) vs *Heavy* (Drama, Thriller) |
| `averageRating` | IMDb mean user rating (1–10)  | Continuous   | Independent variable |
| `numVotes`      | Raw number of IMDb votes      | Continuous   | Popularity measure |
| `logVotes`      | Log-transformed votes         | Continuous   | Derived variable: `log10(numVotes)`; used in regression & plots |


## Method

The first step in R is visual; the number of votes against the average rating are plotted. To handle the extreme skew in vote counts (since probably a few titles get millions of votes while most get very few) the votes variable is log transformed. 

Then the correlation between votes and ratings is calculated to get an indication of the relationship.  A very low correlation could hint at no relationship or a non-linear relationship. 

A polynomial regression model with log(votes) as the dependent variable and rating as the independent variable allows to test the actual relationship between the primary variables of interest. To explore the moderating effect of genre escapist (fantasy, comedy, romance) and heavy (drama, thriller)), an interaction term of ratings and genre is created and added to the regression. In a seperate regression, an interaction term for content form and ratings is created and added to the regression. As a fourth step, the full model is tested where both interaction terms are added to test whether it improves model fit.

Additionally, plots are produced for each regression model to show the effects visually. 

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Repository Overview 

**Include a tree diagram that illustrates the repository structure*

## Dependencies 

*Explain any tools or packages that need to be installed to run this workflow.*

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

- [Sanne Wielders](https://github.com/SanneWielders), e-mail: s.c.h.wielders@tilburguniversity.edu  
- [Jeroen Swolfs](https://github.com/JeroenSwolfs), e-mail: j.a.j.d.swolfs@tilburguniversity.edu 
- [Edwin van Zon](https://github.com/edwinvanzon), e-mail: e.vanzon@tilburguniversity.edu  
- [Eveline Verhage](https://github.com/eef223), e-mail: e.m.a.verhage@tilburguniversity.edu  
- [Eefje van der Sanden](https://github.com/EefjevdSanden), e-mail: e.j.m.vdrsanden@tilburguniversity.edu

