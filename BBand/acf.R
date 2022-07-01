setwd("/Users/shihyi-yang/Programming/R/論文/generated data/num of nolume")


# 把資料切到 3/22, 配合疫苗已經打好的 code
num_of_volume_MVC <- read.csv("MVC_num_of_volume.csv", header = T)
num_of_volume_MVC <- num_of_volume_MVC[81:313, ]   
num_of_volume_MVC$X <- NULL


MVC_period_volume <- c()

# 第 1 期：8/23 - 8/29
df_MVC_volume_period <- num_of_volume_MVC[155:161, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 2 期：8/30 - 9/2
df_MVC_volume_period <- num_of_volume_MVC[162:165, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 3 期：9/3 - 9/10
df_MVC_volume_period <- num_of_volume_MVC[166:173, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 4 期：9/11 – 9/14
df_MVC_volume_period <- num_of_volume_MVC[174:177, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 5 期：9/15 - 9/23
df_MVC_volume_period <- num_of_volume_MVC[178:186, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 6 期：9/24 - 10/2
df_MVC_volume_period <- num_of_volume_MVC[187:195, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 7 期：10/3 - 10/5
df_MVC_volume_period <- num_of_volume_MVC[196:198, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 8 期：10/6 - 10/14
df_MVC_volume_period <- num_of_volume_MVC[199:207, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 9 期：10/15 - 10/21
df_MVC_volume_period <- num_of_volume_MVC[208:214, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 10 期：10/22 - 10/28
df_MVC_volume_period <- num_of_volume_MVC[215:221, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 11 期：10/29 - 11/3
df_MVC_volume_period <- num_of_volume_MVC[222:227, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))

# 第 12 期：11/4 - 11/12
df_MVC_volume_period <- num_of_volume_MVC[228:233, ]
MVC_period_volume <- c(MVC_period_volume, sum(df_MVC_volume_period$negative))


# ACF
my_acf <- acf(MVC_period_volume)
my_pacf <- pacf(MVC_period_volume)

