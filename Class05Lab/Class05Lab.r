#
#' title: "Class 05: Data Visualization with GGPLOT"
#' author: "Kira Jung (PID A16026398)"
#' date: "April 24, 2023"
#' 

## Week 3 Data Visulization With ggplot2

# Install packages with install.package("ggplot2") and library(ggplot2).

# Q1: For which phases is data visualization important in our scientific workflows?
# A1: All of the above (communication of results, exploratory data analysis, detection of outliers).

# Q2: True or False? The ggplot2 package comes already installed with R?
#A2: FALSE.

# Q3: Which plot types are typically NOT used to compare distributions of numeric variables?
# A3: Network graphs

# Q4: Which statement about data visualization with ggplot2 is incorrect?
# A4: "ggplot2 is the only way to create plots in R".

library(ggplot2)
View(cars)
plot(cars)
ggplot(data=cars) + aes(x=speed, y=dist) + geom_point()

p <- ggplot(data=cars) + aes(x=speed, y=dist) + geom_point()

# Add a line geom with geom_line()
p + geom_line()

# Add a trendline close to the data
p + geom_smooth()

p + geom_smooth(method="lm")


# Read in our drug expression data
url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)
View(genes)

# Q. how many genes in dataset = 5196
nrow(genes)

# Q. column names and number = (4) Gene, Condition1, Condition2, State
colnames(genes)
ncol(genes)

# Q. how many 'up' regulated genes = 127 genes
table(genes$State)

# Q. What fraction of total genes are up-regulated = 2.4%
round((table(genes$State) / nrow(genes)) * 100, 2)


# Let's make a first plot attempt
g <- ggplot(data=genes) + aes(x=Condition1, y=Condition2, col=State) + geom_point()

# Add some color
g + scale_color_manual(values=c("blue", "gray", "red")) + labs(title="Gene expression changes", x="Control(no drug)", y="Condition 2") + theme_bw()

# 7 - Optional Portion
# installing the gapminder package
# install.packages("gapminder")
url <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"
gapminder <- read.delim(url)

# installing dplyr package
# install.packages("dplyr")
library(dplyr)
gapminder_2007 <- gapminder %>% filter(year==2007)

# basic scatter plot of gapminder_2007 dataset
ggplot(gapminder_2007) + aes(x=gdpPercap, y=lifeExp) + geom_point(alpha=0.5)

# scatterplot of gapminder_2007 dataset with color and 4 variables
ggplot(gapminder_2007) + aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) + geom_point(alpha=0.5)

# scatterplot of gapminder_2007 dataset, colored by numeric variable population
ggplot(gapminder_2007) + aes(x=gdpPercap, y=lifeExp, color=pop) + geom_point(alpha=0.8)

# Adjusting scale size of gapminder_2007 scatter plot to reflect population differences
ggplot(gapminder_2007) + aes(x=gdpPercap, y=lifeExp, size=pop) + geom_point(alpha=0.5) + scale_size_area(max_size=10)


# Q. Final 1957 and 2007 gapminder plots side by side.
library(dplyr)
gapminder_1957 <- gapminder %>% filter(year==1957 | year==2007)
ggplot(gapminder_1957) + geom_point(aes(x=gdpPercap, y=lifeExp, color=continent, size=pop), alpha=0.7) + scale_size_area(max_size=10) + facet_wrap(~year)


# 8 - Optional Bar Charts Section
gapminder_top5 <- gapminder %>% filter(year==2007) %>% arrange(desc(pop)) %>% top_n(5, pop)

# ggplot(gapminder_top5)
geom_col(aes(x=country, y=pop))

# Q. Bar chart showing life expectancy of 5 biggest countries by population in 2007.
ggplot(gapminder_top5) + geom_col(aes(x=country, y=lifeExp))

# Gapminder_top5 Bar Chart with color by population
ggplot(gapminder_top5) + geom_col(aes(x=country, y=pop, fill=continent))

# # Gapminder_top5 Bar Chart with color by life expectancy
ggplot(gapminder_top5) + geom_col(aes(x=country, y=pop, fill=lifeExp))


# Q.Gapminder_top5 Bar Chart by population
gapminder_top5 <- gapminder %>% filter(year==2007) %>% arrange(desc(pop)) %>% top_n(5, pop)

ggplot(gapminder_top5) + geom_col(aes(x=reorder(country, -pop), y=pop, fill=country, col="gray30", fill="none"))

# Flipping Bar Charts
head(USArrests)

# USArrests$State <- rownames(USArrests)
# ggplot(USArrests) + aes(x=reorder(State, Murder), y=Murder) + geom_col() + coord_flip()
# ggplot(USArrests) + aes(x=reorder(State, Murder), y=Murder) + geom_point() + geom_segment(aes(x=State, xend=State, y=0, yend=Murder), color="blue") + coord_flip()

# 9 - Animation
# install.packages("gifski")
# install.packages("gganimate")

library(gapminder)
library(gganimate)

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() + facet_wrap(~continent) + labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)


# 10 - Combining Plots

# install.packages("patchwork")
# library(patchwork)

p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

# (p1 | p2 | p3) / p4

# Session Info
sessionInfo()