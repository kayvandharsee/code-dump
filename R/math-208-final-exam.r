library(tidyverse)
i <- 10

f <- function(y){
  d <- 8
  i <- 2
  h <- function(){ 
    while (i <= 5){
      print(i)
      i = i+1
    }
    return(i*y+d) 
  }
  return(h())
}

g<- function(y, dd=d){
  return(f(y) + i + dd)
}

# 1a
  # None

# 1b
  # Russ, Kiwon

# 1c pt 1
  # We get this error message as d is not defined in the global environment
  # and instead defined in the local environment of the function f which is not
  # accessible by g in this context. Thus when we run g(1), the function looks
  # to set variable dd to variable d, but cannot find such variable in its own
  # local environment, or the global environment.

# 1c pt 2
i <- 10

f <- function(y){
  d <- 8
  d <<- d
  i <- 2
  h <- function(){ 
    while (i <= 5){
      print(i)
      i = i+1
    }
    return(i*y+d) 
  }
  return(h())
}

g<- function(y, dd=d){
  return(f(y) + i + dd)
}
g(1)

# 2
library(gapminder)
gapminder_recent <- gapminder %>% filter(year %in% c(2002, 2007))
head(gapminder_recent)
# 2a
gapminder %>% select(country, continent, year) %>% map(~n_distinct(.))

# 2b
gapminder_diff <- gapminder_recent %>%
  pivot_wider(id_cols = country, names_from = year, values_from = pop) %>%
  mutate(pop_increase = `2007` - `2002`)

# 2c
gapminder_diff <- gapminder_diff %>%
  mutate(country = fct_reorder(country, pop_increase, .desc = TRUE))

# 2d setup
gap_filtered <- gapminder_diff[gapminder_diff$country %in% (levels(gapminder_diff$country)[1:10]), ]
gap_filtered

# 2d
gap_filtered <- gap_filtered %>%
  arrange(country)
gap_longer <- gap_filtered %>%
  pivot_longer(cols = c(`2002`, `2007`), names_to = "year", values_to = "pop")
ggplot(gap_longer, aes(x = country, y = pop, fill = year)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 2e
gap_lifeExp <- gapminder %>%
  group_by(continent, year) %>%
  summarise(avg_lifeExp = mean(lifeExp))
ggplot(gap_lifeExp, aes(x = year, y = avg_lifeExp, color = continent)) +
  geom_line() +
  labs(y = "average life expectancy", color = "continent")


# 3a
continent_lifeExp <- gapminder %>%
  group_by(year, continent) %>%
  summarise(lifeExp = mean(lifeExp)) %>%
  split(.$continent) %>%
  map(~ select(.x, -continent))

# 3b
gapminder_summary <- function(year_vector, cat_group, var_group) {
  gapminder %>%
    filter(year %in% year_vector) %>%
    group_by(year, {{ cat_group }}) %>%
    summarise(across(all_of(var_group), list(Avg = mean, Med = median), .names = "{.col}_{.fn}")) %>%
    select(year, {{ cat_group }}, ends_with("Avg"), ends_with("Med"))
}

# 3c setup
gapminder_asia <- gapminder %>% filter(continent == "Asia")
pop_mean_summary <- gapminder_asia %>% group_by(country) %>% summarise(mean_pop = mean(pop))
pop_mean_summary

# 3c
first_year_above_mean <- vector("integer", length = nrow(pop_mean_summary))
for (i in seq_along(first_year_above_mean)) {
  country_data <- gapminder_asia %>% filter(country == pop_mean_summary$country[i])
  first_year_above_mean[i] <- min(country_data$year[country_data$pop > pop_mean_summary$mean_pop[i]])
}
names(first_year_above_mean) <- pop_mean_summary$country
first_year_above_mean

# 3d
gapminder_asia <- left_join(gapminder_asia, pop_mean_summary, by = "country")
gapminder_asia <- gapminder_asia %>% filter(pop > mean_pop)
result <- gapminder_asia %>% group_by(country) %>% summarise(year = min(year))
result


# 4 setup
gap_year_filtered <- gapminder %>% filter(year %in% c(1987, 1992, 1997, 2002, 2007))
dim(gap_year_filtered)


# 4a
gapminder_means <- gap_year_filtered %>%
  pivot_longer(cols = c(lifeExp, pop, gdpPercap), names_to = "var", values_to = "value") %>%
  group_by(year, continent, var) %>%
  summarise(value = mean(value, na.rm = TRUE))
gapminder_wide <- gapminder_means %>%
  pivot_wider(names_from = var, values_from = value)
gapminder_array <- array(unlist(gapminder_wide[,c("lifeExp", "pop", "gdpPercap")]), 
                         dim = c(length(unique(gapminder_wide$year)), 
                                 length(unique(gapminder_wide$continent)), 
                                 3),
                         dimnames = list(year = unique(gapminder_wide$year),
                                         continent = unique(gapminder_wide$continent),
                                         var = c("lifeExp", "pop", "gdpPercap")))


gapminder_array
# 4b
apply(gapminder_array, c("year", "var"), mean)
# 4c
apply(gapminder_array, c("year", "var"), range)
# 4d
apply(gapminder_array[,, "gdpPercap"] * gapminder_array[,, "pop"], 1, sum)
# 4e
gapminder_array[,,c("1987", "1992")]


# 5a
super_mario <- matrix(c(0.2, 0.8, 0, 0, 0,
                        0.2, 0, 0.8, 0, 0,
                        0.2, 0, 0, 0.8, 0,
                        0.2, 0, 0, 0, 0.8,
                        0.4, 0, 0, 0, 0.6),
                      nrow = 5, ncol = 5, byrow = TRUE)
colnames(super_mario) <- rownames(super_mario) <- c("stage_0", "stage_1", "stage_2", "stage_3", "stage_4")
super_mario

# 5b
mario_limit = diag(1,5)
for (i in 1:200){
  mario_limit = mario_limit%*% super_mario
  if (i==100 | i==101) print(mario_limit)
}

# 5c
limiting_distribution <- function(P, max_iter = 1000) {
  n <- nrow(P)
  pi <- rep(1/n, n)
  for (i in 1:max_iter) {
    pi_next <- pi %*% P
    if (sqrt(sum((pi_next - pi)^2)) < 1e-8) break 
    pi <- pi_next
  }
  return(pi)
}
pi <- limiting_distribution(super_mario)
print(pi)
average_times <- 100 * pi[5]
average_times

# 5d
super_mario_game <- function(seed, max_iter, init = 0) {
  set.seed(seed)
  stage <- init
  stages <- integer(max_iter)
  for (i in 1:max_iter) {
    stages[i] <- stage
    stage <- sample(0:4, size = 1, prob = super_mario[stage + 1, ])
  }
  stage_counts <- table(stages)
  stage_counts_tibble <- as_tibble(table(stages))
  colnames(stage_counts_tibble) <- c("stage", "count")
  return(stage_counts_tibble)
}

super_mario_game(6, 1000)

# 5e
rescue_peach <- function(seed, max_iter) {
  set.seed(seed)
  times <- rnorm(max_iter, mean = 16, sd = sqrt(9))
  successful_rescues <- sum(times <= 20)
  print(paste("According to the simulation, I could rescue Princess Peach", successful_rescues, "out of", max_iter, "times."))
}
rescue_peach(6, 1000)
theoretical_prob <- pnorm(20, mean = 16, sd = sqrt(9))
theoretical_prob



