require(sparklyr)
require(dplyr)

# spark_available_versions()
# spark_installed_versions()
# spark_install(version = '3.1')

sc <- spark_connect(master = "local",version = '3.1.1')
spark_connection_is_open(sc)

cars <- copy_to(sc, mtcars)

cars %>% 
  head()

cars %>% sdf_dim()
count(cars)


plot(cars$hp, cars$mpg)

cars %>% 
  select(hp, mpg) %>% 
  collect() %>%
  plot()

cars %>% 
  ml_linear_regression( mpg ~ hp)

# %>% 
#   summary()

mean(cars$cyl)

summarize_all(cars, mean) 
# %>% 
#  show_query()

cars %>% 
  collect() %>% 
  cor()

ml_corr(cars)


car_group <- cars %>%
  group_by(cyl) %>%
  summarise(mpg = sum(mpg, na.rm = TRUE)) %>%
  collect()

require(ggplot2)
ggplot(aes(as.factor(cyl), mpg), data = car_group) + 
  geom_col(fill = "#999999") + coord_flip()


require(dbplot)

cars %>%
  dbplot_histogram(mpg, binwidth = 3) +
  labs(title = "Distribuição MPG",
       subtitle = "Milhas por galão")

spark_disconnect(sc)