#Load required packages
source("../1-raw-data/loading-packages.R")

#Load imdb dataset 
imdb_analysis_main <- read_csv("../../data/clean/imdb_analysis.csv")

#Model 1: regress rating (averageRating) on the log number of votes (log_votes), controlling for period
model_linear <- lm(averageRating ~ log_votes + period, data = imdb_analysis_main)
summary(model_linear)
tidy(model_linear)
print('Model 1 made')

#Model 2: regress rating (averageRating) on the log number of votes (log_votes), the quadratic log number of votes (log_votes2), controlling for period
model_quadratic <- lm(averageRating ~ log_votes + log_votes2 + period, data = imdb_analysis_main)
summary(model_quadratic)
tidy(model_quadratic)
print('Model 2 made')

#Compare model fit
anova(model_linear, model_quadratic)

#Model 3 (subQ 1): Interaction with the genre variable
model_interaction_genre <- lm( averageRating ~ log_votes + log_votes2 + genre_family +
  log_votes*genre_family + log_votes2*genre_family, data = imdb_analysis_main)
summary(model_interaction_genre)
tidy(model_interaction_genre)
print('Model 3 made')

#Model 4 (subQ 2): Interaction with the type (movie vs film) variable
model_interaction_type <- lm(
  averageRating ~ log_votes + log_votes2 + type +
    log_votes*type + log_votes2*type,
  data = imdb_analysis_main)

print('Model 4 made')
summary(model_interaction_type)
tidy(model_interaction_type)

#Visualization
#Model 1 & 2 
Model_1_2 <- ggplot(imdb_analysis_main, aes(x = log_votes, y = averageRating)) +
  geom_point(alpha = 0.1) +   # raw data
  geom_smooth(method = "lm", formula = y ~ x, color = "blue") +   # linear
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), color = "violet") +   # quadratic
  labs(title = "Average Rating vs Number of votes, linear and quadratic log number of votes",
       x = "Log(Number of Votes)", y = "Average Rating")
print('Model 1,2 done')

#Model 3 
Model_3 <- ggplot(imdb_analysis_main, aes(x = log_votes, y = averageRating, color = genre_family)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE) +
  labs(title = "Rating vs Votes (logged) by Genre (Heavy versus Escapist)",
       x = "Log(Number of Votes)", y = "Average Rating") +
  facet_wrap(~ genre_family)
print('Model 3 done')


#Model 4
Model_4 <- ggplot(imdb_analysis_main, aes(x = log_votes, y = averageRating, color = type)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE) +
  labs(title = "Rating vs Votes (logged) by content type (movie vs serie)",
       x = "Log(Number of Votes)", y = "Average Rating") +
  facet_wrap(~ type)
print('Model 4 done')

print('Visualization of all models done')

# creating our gen/output folder
dir.create("../../gen/output", recursive = TRUE, showWarnings = FALSE)

# Save plots
ggsave("../../gen/output/model1_2.png", Model_1_2, width = 8, height = 6)
ggsave("../../gen/output/model3.png",   Model_3,   width = 8, height = 6)
ggsave("../../gen/output/model4.png",   Model_4,   width = 8, height = 6)
print('models saved in gen/output')
