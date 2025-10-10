
# Votes vs Valence: exploring the quadratic relationship between ratings and vote counts on IMDb
This study investigates the relationship between popularity (measured by the number of votes) and perceived quality (average IMDb rating) of films and series. Using IMDb data, the analysis examines whether highly rated titles also attract more votes, or whether popularity and quality diverge and it explores whether this relationship differs across genres and between movies and series (i.e. content form). 

## Motivation

The relationship between the number of votes and the average rating provides important insight into **audience behaviour** and **viewing preferences**. Understanding this connection helps to interpret online rating patterns and audience engagement on platforms such as IMDb. It also offers practical implications for filmmakers, distributors, and streaming services in understanding how users respond to different types of content.

Building on prior research on the **polarization effect**, this study expects that the relationship between popularity and quality is **non-linear (quadratic)** rather than linear. Two main hypotheses are considered:

1. **Polarization hypothesis:** Both highly rated and poorly rated titles may attract more votes, as individuals with strong opinions are more likely to share them. This would produce a **U-shaped** relationship between votes and ratings.  
2. **Mainstream hypothesis:** Widely viewed titles may receive a high number of votes with more moderate ratings, reflecting broad appeal but less extreme opinions. This would result in an **inverted U-shaped** relationship.

The analysis controls for two moderating factors that could influence this relationship: differences between **genres** (e.g., escapist vs. heavy content), and differences between **content forms** (**movies vs. series**).

## Data

### Sources
We use two publicly available **IMDb datasets** ([IMDb Interfaces](https://www.imdb.com/interfaces/)):

- **`title.basics.tsv.gz`** — metadata on titles (type, release year, genres)  
- **`title.ratings.tsv.gz`** — user ratings and vote counts  

For reproducibility and speed, a **sample of 200,000 rows** was downloaded from each file and merged via the unique identifier **`tconst`**.  
Sampling was performed with a fixed seed (`set.seed(123)`) to ensure the same subset of data is used when the pipeline is re-run.  

### Cleaning & Preparation
The raw IMDb files were merged and then cleaned to produce an analytical dataset suitable for testing our research questions.  

Key steps:  
- Merged the datasets on the common identifier tconst.  
- Removed titles with fewer than **20 votes** (to ensure stable and representative ratings).  
- Limited to the main content forms: **movies** (`movie`, `tvMovie`) and **series** (`tvSeries`, `tvMiniSeries`).  
- Grouped genres into broader **families**:  
  - *Escapist*: Fantasy, Comedy, Romance, Action, Adventure, Animation, Family  
  - *Heavy*: Drama, Thriller, Biography, Crime, Documentary  
- Created a **final dataset** (`imdb_enriched`) that combines ratings, votes, content form, and genre family.  
- To address skew, the **log10 of vote counts** is used in visualizations and regressions.  
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

The analysis was conducted entirely in **R**, following a structured and automated workflow.  
After cleaning and transforming the IMDb data, the relationship between **average rating** and **number of votes** was examined using a series of linear regression models.

To correct for the strong right-skew in vote counts, the variable was **log-transformed**, and a **quadratic term** (`log_votes²`) was added to capture potential non-linear effects.  
The dependent variable in all models was the **average IMDb rating**, representing perceived quality.

Four models were estimated sequentially:
1. **Baseline linear model:**  
   Tests the simple linear relationship between log-transformed votes and ratings, controlling for release period.
2. **Quadratic model:**  
   Adds the squared log(votes) term to test for a non-linear (U-shaped or inverted U-shaped) pattern.
3. **Genre moderation model:**  
   Introduces interaction terms between log(votes) and genre family (*Escapist* vs *Heavy*) to assess whether the relationship differs across genres.
4. **Content form moderation model:**  
   Includes interactions between log(votes) and type (*Movie* vs *Series*) to test whether audience engagement patterns vary across formats.

Model comparisons (via ANOVA and adjusted R²) assess whether including non-linear and interaction terms improves explanatory power.  
Each model’s results are supported by visualizations, allowing a clear interpretation of linearity, curvature, and moderation effects.

## Preview of Findings
The analyses reveal the following:
- An clear **non-linear (quadratic)** relationship between the number of votes and IMDb ratings.  
- Titles with very few or very many votes tend to have **higher ratings on average**, while moderately popular titles receive more balanced evaluations.  

This pattern supports the **polarization hypothesis**: strong opinions drive engagement at both ends of the quality spectrum.

Further, the results show that the relationship differs by both **genre** and **content form**.  
- **Heavy genres** (e.g., drama, thriller) exhibit more pronounced polarization, with stronger audience divisions.  
- **Escapist genres** (e.g., fantasy, comedy, romance) show flatter curves, indicating more uniform audience reception.  
- **Movies** generally follow the U-shaped pattern, while **series** display a more inverted U-shape, suggesting that moderately popular series are rated highest.

All models and visualizations are generated automatically and exported to the `gen/output/` directory, enabling full **reproducibility** and transparent interpretation of the results.

These findings contribute to a better understanding of **audience behaviour** and **online rating dynamics**. They offer practical insights for **film studios**, **streaming platforms**, and **review aggregators** in interpreting consumer feedback and tailoring strategies to specific genres or content types.

## Repository Overview 

The repository is structured as follows: 
```
imdb-votes-vs-ratings/
├── makefile                     
├── README.md                    
├── git
├── .gitignore   
├── .Rhistory            
├── data/                       
   ├── title.basics.tsv.gz       
   ├── title.ratings.tsv.gz 
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
       ├── model4.png
       ├── basic_descriptives.png
       ├── regression_models.png
       ├── regression_models.html
       └── report.html
├── src/                         
   ├── 1-raw-data/             
       ├── download-data.R
       ├── loading-packages.R
       ├── installing_packages_DIY.R
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
       ├── report.html
       └── makefile
```

## Running Instructions

### Dependencies
Please make sure the install the following:
- **Make** – Installation guide: [here](https://tilburgsciencehub.com/building-blocks/configure-your-computer/automation/make/)  
- **R** – Installation guide: [here](https://tilburgsciencehub.com/building-blocks/configure-your-computer/setup/software/r/)  

Before running the project with `make`, you must first install all required R packages.You can do this by running this following command in your terminal once:
```bash
Rscript src/1-raw-data/installing_packages_DIY.R
```

### Running the Code

1. **Open your command line or terminal.**
2. **Navigate to the project directory** (where this `README.md` file is located).  
3. **Run the full automated workflow:**
   ```bash
   make
   ```
   This command executes all stages in sequence: data download, cleaning, analysis, and report generation.

### Generated Files

After successful execution, the key output files are stored in the `gen/output/` directory:

- `model1_2.png` – linear vs. quadratic model comparison  
- `model3.png` – moderation by genre  
- `model4.png` – moderation by content form  
- Additional regression summaries and HTML visualizations

The final report (`report.html` / `report.pdf`) is generated automatically in the reporting stage.

## Resources
- Badami, M., Nasraoui, O., Sun, W., & Shafto, P. (2017). Detecting polarization in ratings: An automated pipeline and a preliminary quantification on several benchmark data sets. 2017 IEEE International Conference on Big Data (Big Data), 2682–2690. https://doi.org/10.1109/BigData.2017.8258231 researchwithrutgers.com
- Baugher, D., & Ramos, C. (2017). The cross-platform consistency of online user movie ratings. Atlantic Marketing Journal, 5(3), Article 9. https://digitalcommons.kennesaw.edu/amj/vol5/iss3/9/ activityinsight.pace.edu
- Gomes, A. L., Vianna, G., Escovedo, T., & Kalinowski, M. (2022). Predicting IMDb rating of TV series with deep learning: The case of Arrow. In Proceedings of the XVIII Brazilian Symposium on Information Systems (SBSI ’22). https://doi.org/10.1145/3535511.3535520 arXiv
- Ramos, M., Calvão, A. M., & Anteneodo, C. (2015). Statistical patterns in movie rating behavior. PLOS ONE, 10(8), e0136083. https://doi.org/10.1371/journal.pone.0136083 PLOS
- Schoenmueller, V., Netzer, O., & Stahl, F. (2020). The polarity of online reviews: Prevalence, drivers and implications. Journal of Marketing Research, 57(5), 853–877. https://doi.org/10.1177/0022243720941832 SAGE Journals
- Sunder, S., Kim, K. H., & Yorkston, E. A. (2019). What drives herding behavior in online ratings? The role of rater experience, product portfolio, and diverging opinions. Journal of Marketing, 83(6), 93–112. https://doi.org/10.1177/0022242919875688 researchwithrutgers.com
- Wasserman, M., Mukherjee, S., Scott, K., Zeng, X. H. T., Radicchi, F., & Amaral, L. A. N. (2015). Correlations between user voting data, budget, and box office for films in the Internet Movie Database. Journal of the Association for Information Science and Technology, 66(4), 858–868. https://doi.org/10.1002/asi.23213

## Authors
This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

### Team 5
This team comprises students participating in the aforementioned program.
- [Sanne Wielders](https://github.com/SanneWielders), e-mail: s.c.h.wielders@tilburguniversity.edu  
- [Jeroen Swolfs](https://github.com/JeroenSwolfs), e-mail: j.a.j.d.swolfs@tilburguniversity.edu 
- [Edwin van Zon](https://github.com/edwinvanzon), e-mail: e.vanzon@tilburguniversity.edu  
- [Eveline Verhage](https://github.com/eef223), e-mail: e.m.a.verhage@tilburguniversity.edu  
- [Eefje van der Sanden](https://github.com/EefjevdSanden), e-mail: e.j.m.vdrsanden@tilburguniversity.edu

