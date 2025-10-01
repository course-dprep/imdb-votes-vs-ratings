#Load required packages
source("../1-raw-data/loading-packages.R")

#Load imdb dataset 
imdb_analysis <- read_csv("../../data/clean/imdb_analysis.csv")

#Keep only those observations with an exclusive genre
imdb_analysis <- imdb_analysis %>%
  filter(genre_family == "Escapist" | genre_family == "Heavy")

#Model 1: regress rating (averageRating) on the log number of votes (log_votes), controlling for period
model_linear <- lm(averageRating ~ log_votes + period, data = imdb_analysis)
summary(model_linear)
tidy(model_linear)
print('Model 1 made')

#Model 2: regress rating (averageRating) on the log number of votes (log_votes), the quadratic log number of votes (log_votes2), controlling for period
model_quadratic <- lm(averageRating ~ log_votes + log_votes2 + period, data = imdb_analysis)
summary(model_quadratic)
tidy(model_quadratic)
print('Model 2 made')

#Compare model fit
anova(model_linear, model_quadratic)

#Model 3 (subQ 1): Interaction with the genre variable
model_interaction_genre <- lm( averageRating ~ log_votes + log_votes2 + genre_family +
  log_votes*genre_family + log_votes2*genre_family, data = imdb_analysis)
summary(model_interaction_genre)
tidy(model_interaction_genre)
print('Model 3 made')

anova(model_quadratic, model_interaction_genre)

#Model 4 (subQ 2): Interaction with the type (movie vs film) variable
model_interaction_type <- lm(
  averageRating ~ log_votes + log_votes2 + type +
    log_votes*type + log_votes2*type,
  data = imdb_analysis)

--------------
  ## OPTION FIXED MODEL 4 - Model 4 code doesn't run!!!
  model_interaction_type <- lm(
    averageRating ~ log_votes + log_votes2 + type +
      log_votes*movies + log_votes2*series,
    data = imdb_analysis)
-----------

print('Model 4 made')
summary(model_interaction_type)
tidy(model_interaction_type)


anova(model_quadratic, model_interaction_type)

#Model 5: For managerial practicallity, regress rating categories (averageRating) on the log number of votes (log_votes), the quadratic log number of votes (log_votes2), controlling for period. This is a logistic regression, as both the IV and DV are non-continuous.
model_logistic_categories <- polr(rating_category ~ log_votes + I(log_votes2), 
                  data = imdb_analysis, Hess = TRUE)
print('Model 5 made')

summary(model_logistic_categories)
tidy(model_logistic_categories)

#Visualization
#Model 1 & 2 
Model_1_2 <- ggplot(imdb_analysis, aes(x = log_votes, y = averageRating)) +
  geom_point(alpha = 0.1) +   # raw data
  geom_smooth(method = "lm", formula = y ~ x, color = "blue") +   # linear
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), color = "red") +   # quadratic
  labs(title = "Average Rating vs Number of votes, linear and quadratic log number of votes",
       x = "Log(Number of Votes)", y = "Average Rating")

#Model 3 
Model_3 <- ggplot(imdb_analysis, aes(x = log_votes, y = averageRating, color = genre_family)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE) +
  labs(title = "Rating vs Votes (logged) by Genre (Heavy versus Escapist)",
       x = "Log(Number of Votes)", y = "Average Rating") +
  facet_wrap(~ genre_family)

#Model 4
Model_4 <- ggplot(imdb_analysis, aes(x = log_votes, y = averageRating, color = type)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE) +
  labs(title = "Rating vs Votes (logged) by content type (movie vs serie)",
       x = "Log(Number of Votes)", y = "Average Rating") +
  facet_wrap(~ type)

#Model 5 
Model_5 <- imdb_analysis %>%
  mutate(vote_bin = cut(log_votes, breaks = 20)) %>%
  group_by(vote_bin, rating_category) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(vote_bin) %>%
  mutate(prop = n / sum(n)) %>%
  ggplot(aes(x = vote_bin, y = prop, fill = rating_category)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Distribution of Rating Categories across Log(Votes)",
       x = "Log(Votes) (binned)", y = "Proportion")

print('Visualization of all models done')

