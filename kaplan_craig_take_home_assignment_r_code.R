library(dplyr)
library(tidyr)
library(zoo)
library(ggplot2)

### Read the data
data <- read.csv('\\Users\\Craig\\Desktop\\Job Search 2019
			\\Universal Tennis\\data_challenge_raw_data.csv')
data <- read.csv('<path to raw data>')

### Look for invalid/unusual set scores

# First set
data %>%
	group_by(winnerset1, loserset1) %>%
	summarize(count = n()) %>%
	data.frame()

# Second set
data %>%
	group_by(winnerset2, loserset2) %>%
	summarize(count = n()) %>%
	data.frame()

# Third set
data %>%
	group_by(winnerset3, loserset3) %>%
	summarize(count = n()) %>%
	data.frame()

# Fourth set
data %>%
	group_by(winnerset4, loserset4) %>%
	summarize(count = n()) %>%
	data.frame()

# Fifth set
data %>%
	group_by(winnerset5, loserset5) %>%
	summarize(count = n()) %>%
	data.frame()

## Fifth set seems to be entirely no tiebreak sets
## row 4 (resultid = 10979110) appears to be a 4-game mini set
#  (4-2, one set only), or was cut short.
## row 1434 (resultid = 11206128) may have been cut short (7-6, 4-3),
#  and we don't know how many sets this match was intended to be.
## We will consider these matches to be 1-set and 3-set matches, respectively, and
#  count them like any normal match (this is what UTR does for
#  matches with 4+ completed games).


## Look at range of dates
data %>%
	group_by(resultdate) %>%
	summarize(count = n()) %>%
	data.frame()

data %>%
	group_by(resultdate) %>%
	summarize(count = n()) %>%
	mutate(day_of_week = weekdays(as.Date(resultdate))) %>%
	arrange(desc(count)) %>%
	data.frame() %>%
	head(50)

## All of the days with 100+ matches are Sunday. This could be when
#  scores are posted, or just a very popular day for matches.

ggplot(data = data, aes(x = as.Date(resultdate))) +
	geom_histogram(binwidth = 1) +
	scale_x_date(date_breaks = '1 month') +
	labs(title = 'Matches per Day', x = 'Date', y = 'Number of Matches')

## We will consider removing the last two matches from the dataset, since
#  they were played far later than all of the others.
## Alternatively, make "days_since_match" retroactive to 2018-07-25, the
#  most recent date before these two matches.
## We will do the latter option.


### Add new columns
## All rows in the dataset will be from the winners' perspectives.
## Rows from the losers' perspectives will be created and added later.

data_reformatted <- data %>%
	mutate(player      = winner1id,
		 opponent    = loser1id,
		 match_id    = resultid,
		 match_date  = as.Date(resultdate),
		 match_won   = 1,
		 games_won   = rowSums(data[grep('^winnerset[1-5]$',
					               colnames(data))]),
		 games_lost  = rowSums(data[grep('^loserset[1-5]$',
							   colnames(data))]),
		 games_total = rowSums(data[grep('^(winner|loser)set[1-5]$',
							   colnames(data))]),
		 set1_won    = ifelse(winnerset1 > 0 | loserset1 > 0,
					    ifelse(winnerset1 > loserset1, 1, 0), NA),
		 set2_won    = ifelse(winnerset2 > 0 | loserset2 > 0,
					    ifelse(winnerset2 > loserset2, 1, 0), NA),
		 set3_won    = ifelse(winnerset3 > 0 | loserset3 > 0,
					    ifelse(winnerset3 > loserset3, 1, 0), NA),
		 set4_won    = ifelse(winnerset4 > 0 | loserset4 > 0,
					    ifelse(winnerset4 > loserset4, 1, 0), NA),
		 set5_won    = ifelse(winnerset5 > 0 | loserset5 > 0,
					    ifelse(winnerset5 > loserset5, 1, 0), NA),
		 set1_diff   = na_if(winnerset1 - loserset1, 0),
		 set2_diff   = na_if(winnerset2 - loserset2, 0),
		 set3_diff   = na_if(winnerset3 - loserset3, 0),
		 set4_diff   = na_if(winnerset4 - loserset4, 0),
		 set5_diff   = na_if(winnerset5 - loserset5, 0))
head(data_reformatted)

data_reformatted <- data_reformatted %>%
	mutate(sets_won           = rowSums(data_reformatted[grep('^set[1-5]_won$',
						      colnames(data_reformatted))], na.rm = TRUE),
		 sets_total         = rowSums(!is.na(data_reformatted[grep('^set[1-5]_won',
						      colnames(data_reformatted))])),
		 set_format         = 2 * sets_won - 1,
		 games_differential = games_won - games_lost,
		 max_set_diff_win   = pmax(apply(data_reformatted[grep('^set[1-5]_diff$',
									             colnames(data_reformatted))],
							   1, max, na.rm = TRUE),
						   0),
		 max_set_diff_loss  = -1 * pmin(apply(data_reformatted[grep('^set[1-5]_diff$',
									                  colnames(data_reformatted))],
							        1, min, na.rm = TRUE),
						        0),
		 days_since_match   = pmax(as.numeric(difftime(as.Date('2018-07-25'),
									     match_date,
									     units = 'days')),
						   0))
head(data_reformatted)

data_reformatted <- data_reformatted %>%
	transmute(player, opponent, match_id, match_date, days_since_match,
		    match_won, set_format,
		    sets_won, sets_lost = sets_total - sets_won, sets_total,
		    games_won, games_lost, games_total, games_differential,
		    max_set_diff_win, max_set_diff_loss)
head(data_reformatted)


### Inspect the new columns

## Look at set formats (best of 1, 3, or 5 sets) and their counts
data_reformatted %>%
	group_by(set_format) %>%
	summarize(count = n()) %>%
	data.frame()
## Nearly all of the matches are best of 3 sets,
#  but there are a few hundred best of 5 set matches.


### Create rows from losers' perspectives
losses <- data_reformatted %>%
	rename(player = opponent, opponent = player,
		 sets_won = sets_lost, sets_lost = sets_won,
		 games_won = games_lost, games_lost = games_won,
		 max_set_diff_win = max_set_diff_loss,
		 max_set_diff_loss = max_set_diff_win) %>% 
	transmute(player, opponent, match_id, match_date, days_since_match,
		    match_won = 0, set_format,
		    sets_won, sets_lost, sets_total,
		    games_won, games_lost, games_total,
		    games_differential,
		    max_set_diff_win, max_set_diff_loss)
head(losses)


### Combine winners and losers data frames
all_results <- bind_rows(data_reformatted, losses)
nrow(all_results)

### Count number of players in dataset
length(unique(all_results$opponent))
# There are 1052 different players represented in the original dataset.


### Find players with most wins, losses, and matches played
most_wins <- all_results %>%
	filter(match_won == 1) %>%
	group_by(player) %>%
	summarize(total_wins = n()) %>%
	arrange(desc(total_wins))
head(most_wins)
most_losses <- all_results %>%
	filter(match_won == 0) %>%
	group_by(player) %>%
	summarize(total_losses = n()) %>%
	arrange(desc(total_losses))
head(most_losses)
most_matches <- all_results %>%
	group_by(player) %>%
	summarize(total_matches = n()) %>%
	arrange(desc(total_matches))
head(most_matches)


### Get running match and win counts for each player
##  Matches played on the same date will be counted all at once

# Get running count of matches played to date
# Includes a "total_wins" column, which will be used later
match_counts <- all_results %>%
	group_by(player) %>%
	arrange(match_date, match_id) %>%
	mutate(match_date,
		 matches_to_date = min_rank(match_date) - 1,
		 total_wins = sum(match_won)) %>%
	data.frame()

# Get running count of matches won to date
win_counts <- all_results %>%
	filter(match_won == 1) %>%
	group_by(player) %>%
	arrange(match_date, match_id) %>%
	mutate(match_date,
		 wins_to_date = min_rank(match_date) - 1) %>%
	data.frame()

# Join above two data frames together
# total_wins column used to help fill holes in wins_to_date column
match_and_win_counts <- left_join(match_counts, win_counts) %>% 
	arrange(player, match_date, match_id) %>%
	mutate(wins_to_date = ifelse(!is.na(wins_to_date),
					     wins_to_date,
					     ifelse(lag(player) != player,
							0,
							ifelse(player != lead(player) | is.na(lead(player)),
								 pmin(matches_to_date, total_wins),
								 wins_to_date)))) %>%
	mutate(wins_to_date = ifelse(!is.na(wins_to_date),
					     wins_to_date,
					     ifelse(lag(match_date) == match_date,
							na.locf(wins_to_date),
							na.locf(wins_to_date,
								  fromLast = TRUE)))) %>%
	arrange(match_date, match_id)

# Use matches_to_date and wins_to_date to
# make a column for win percentage to date
# Will be an "adjusted" win percentage, (wins + 1) / (matches + 2)
win_pcts <- match_and_win_counts %>%
	mutate(win_pct_to_date = round((wins_to_date + 1) /
						 (matches_to_date + 2), 3))

### Get match and win counts for opponents
opp_match_counts <- all_results %>%
	group_by(opponent) %>%
	arrange(match_date, match_id) %>%
	mutate(match_date,
		 opp_matches_to_date = min_rank(match_date) - 1,
		 opp_total_wins = sum(1 - match_won)) %>%
	data.frame()

opp_win_counts <- all_results %>%
	filter(match_won == 0) %>%
	group_by(opponent) %>%
	arrange(match_date, match_id) %>%
	mutate(match_date,
		 opp_wins_to_date = min_rank(match_date) - 1) %>%
	data.frame()

opp_match_and_win_counts <- left_join(opp_match_counts, opp_win_counts) %>%
	arrange(opponent, match_date, match_id) %>%
	mutate(opp_wins_to_date = ifelse(!is.na(opp_wins_to_date),
						   opp_wins_to_date,
						   ifelse(lag(opponent) != opponent,
							    0,
							    ifelse(opponent != lead(opponent) | is.na(lead(opponent)),
								     pmin(opp_matches_to_date, opp_total_wins),
								     opp_wins_to_date)))) %>%
	mutate(opp_wins_to_date = ifelse(!is.na(opp_wins_to_date),
						   opp_wins_to_date,
						   ifelse(lag(match_date) == match_date,
							    na.locf(opp_wins_to_date),
							    na.locf(opp_wins_to_date,
									fromLast = TRUE)))) %>%
	arrange(match_date, match_id)

opp_win_pcts <- opp_match_and_win_counts %>%
	mutate(opp_win_pct_to_date = round((opp_wins_to_date + 1)
						/ (opp_matches_to_date + 2), 3))

### Join win_pcts and opp_win_pcts
## Change match_won values of 0 to -1, which will
#  make later calculations easier
## Add a rating column (all players' ratings start at 0.000)
combined <- left_join(win_pcts, opp_win_pcts) %>%
	transmute(player, opponent, match_id, match_date, days_since_match,
		    match_won = ifelse(match_won == 1, match_won, -1),
		    set_format, sets_won, sets_lost, sets_total,
		    games_won, games_lost, games_total, games_differential,
		    max_set_diff_win, max_set_diff_loss, matches_to_date,
		    wins_to_date, win_pct_to_date, opp_matches_to_date,
		    opp_wins_to_date, opp_win_pct_to_date,
		    win_pct_difference = opp_win_pct_to_date - win_pct_to_date,
		    rating = 0.000) %>%
	arrange(match_date, match_id, player)


### Inspect "combined"
## Largest win_pct differences
combined %>% arrange(win_pct_difference) %>% head()
combined %>% arrange(win_pct_difference) %>% tail()

## Players with only one match
combined %>%
	group_by(player) %>%
	summarize(total_matches = n()) %>%
	filter(total_matches == 1) %>%
	select(player) %>%
	nrow()


### Calculate rating
## All players start with ratings of 0.
## Rating can be positive or negative.
## Players get a small bonus for playing a match, win or lose, to
#  reward players who play more matches. The bonus is larger for
#  5-set matches, and smaller for 1-set matches.

rating_breakdowns <- combined %>%
	mutate(date_multiplier          = 0.5 ^ (days_since_match / 90),				#devalue older matches (a match played 90 days ago is worth 1/2 of a match played today) (0 - 1)
		 match_bonus              = 1.5 * (1 + 0.1 * (set_format - 3)),			#bonus of 0.8, 1.0, or 1.2 awarded for playing a match, win or lose (1.2, 1.5, or 1.8)
		 opp_rating_multiplier    = 1 / (1 - (match_won * win_pct_difference)),		#wins against stronger opponents have more weight; losses against weaker opponents have more weight (0 - inf)
		 straight_set_bonus       = 2 * set_format / sets_total,				#straight-set matches have more weight than split-set matches (2 - 3.33)
		 games_differential_bonus = 2 * games_differential / games_total,		#change weight based on how many games each player won (can be negative, which benefits the loser, in very close matches) (-inf - inf)
		 set_margin_bonus         = (((match_won + 1) / 2) * max_set_diff_win +
			     		           (((1 - (match_won + 1) / 2)) * max_set_diff_loss)) / 6	#change weight based on widest victory margin for wins, or widest defeat margin for losses (0.1667 - 1)
	) %>%
	mutate(rating_change = match_won *
					(straight_set_bonus +
					 games_differential_bonus +
					 set_margin_bonus)) %>%
	mutate(rating_change_adj_opp = opp_rating_multiplier *
							rating_change) %>%
	mutate(rating_change_adj_date = rating_change_adj_opp *
							date_multiplier) %>%
	mutate(rating_change_adj_with_bonus = (date_multiplier * match_bonus) +
								rating_change_adj_date)

## Take running sum of rating (last one will be player's "final rating")
ratings_cumulative <- rating_breakdowns %>%
	group_by(player) %>%
	mutate(new_rating = cumsum(rating_change_adj_with_bonus)) %>%
	data.frame()

## Rank players based on ratings
final_rankings <- ratings_cumulative %>%
	group_by(player) %>%
	summarize(final_rating = last(new_rating)) %>%
	arrange(desc(final_rating)) %>%
	mutate(ranking = min_rank(desc(final_rating))) %>%
	data.frame()


### Find any ties
final_rankings %>%
	group_by(ranking) %>%
	summarize(count = n()) %>%
	filter(count > 1) %>%
	arrange(desc(count))
# There are no ties in the rankings


### Stats of top 20 and bottom 20 players
ratings_cumulative %>%
	group_by(player) %>%
	filter(match_id == last(match_id)) %>%
	mutate(total_matches = matches_to_date + 1,
		 total_wins = wins_to_date + (match_won + 1) / 2) %>%
	mutate(final_win_pct = (total_wins + 1) / (total_matches + 2)) %>%
	inner_join(final_rankings) %>%
	select(player,
		 final_rating,
		 total_matches,
		 total_wins,
		 final_win_pct,
		 ranking) %>%
	arrange(ranking) %>%
	data.frame() %>%
#	head(20)
	tail(20)

## losses that result in increased ratings
ratings_cumulative %>%
	filter(match_won == -1 & rating_change_adj_with_bonus > 0)
# This was a very close match, in which the loser won one more game

# Matches in which the loser won more games
ratings_cumulative %>%
	filter(match_won == -1 & games_differential < 0) %>%
	arrange(games_differential) %>%
	head(10)

### FINAL RANKINGS ###
final_rankings %>% select(player, ranking)

#Player and rank
write.csv(final_rankings %>% select(player, ranking),
	    '\\Users\\Craig\\Desktop\\Job Search 2019\\Universal Tennis\\final_rankings.csv',
	    row.names = FALSE)

#Additional statistics
write.csv(ratings_cumulative %>%
		group_by(player) %>%
		filter(match_id == last(match_id)) %>%
		mutate(total_matches = matches_to_date + 1,
			 total_wins = wins_to_date + (match_won + 1) / 2) %>%
		mutate(final_win_pct = (total_wins + 1) / (total_matches + 2)) %>%
		inner_join(final_rankings) %>%
		select(player,
			 final_rating,
			 total_matches,
			 total_wins,
			 final_win_pct,
			 ranking) %>%
		arrange(ranking) %>%
		data.frame(),
	    '\\Users\\Craig\\Desktop\\Job Search 2019\\Universal Tennis\\final_rankings_more_statistics.csv',
	    row.names = FALSE)
