# In this directory, you will keep all source code related to your analysis.

# Exploration of main question
ggplot(imdb_all, aes(x=log10(numVotes), y=averageRating)) +
  geom_point(alpha=.2) +
  geom_smooth(method="lm") +
  labs(title="Votes vs Average Rating (All Titles)",
       x="log10(Number of Votes)", y="Average Rating")

# Exploration of sub question 1
ggplot(movies_fam, aes(x=log10(numVotes), y=averageRating, color=genre_family)) +
  geom_point(alpha=.3) +
  geom_smooth(method="lm") +
  labs(title="Votes vs Rating by Genre Family (Movies)",
       x="log10(Number of Votes)", y="Average Rating", color="Genre Family")

# Exploration of sub question 2
ggplot(imdb_types, aes(x=log10(numVotes), y=averageRating, color=type)) +
  geom_point(alpha=.3) +
  geom_smooth(method="lm") +
  labs(title="Votes vs Rating by Content Form",
       x="log10(Number of Votes)", y="Average Rating", color="Content form")