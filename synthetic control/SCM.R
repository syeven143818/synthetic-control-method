library(SCtools)
library(Synth)

# loading data
setwd("/Users/shihyi-yang/Programming/R/論文/generated data/12 periods volume")
AZ_volume_12_periods <- read.csv("AZ_volume_12_periods.csv", header = T)
BNT_volume_12_periods <- read.csv("BNT_volume_12_periods.csv", header = T)
Moderna_volume_12_periods <- read.csv("Moderna_volume_12_periods.csv", header = T)
MVC_volume_12_periods <- read.csv("MVC_volume_12_periods.csv", header = T)


setwd("/Users/shihyi-yang/Programming/R/論文/generated data")
vaccine_injection_17_periods <- read.csv("vaccine_injection_17_periods.csv", header = T)


# foo (synthetic data frame)
# unit_num : AZ = 1, BNT = 2, Moderna = 3, MVC = 4

# AZ
AZ_volume_12_periods$name <- rep("AZ", 12)
AZ_volume_12_periods$unit_num <- rep(1, 12)
AZ_volume_12_periods$injection <- vaccine_injection_17_periods$AZ[1:12]

# BNT
BNT_volume_12_periods$name <- rep("BNT", 12)
BNT_volume_12_periods$unit_num <- rep(2, 12)
BNT_volume_12_periods$injection <- vaccine_injection_17_periods$BNT[1:12]

# Moderna
Moderna_volume_12_periods$name <- rep("Moderna", 12)
Moderna_volume_12_periods$unit_num <- rep(3, 12)
Moderna_volume_12_periods$injection <- vaccine_injection_17_periods$Moderna[1:12]

# MVC
MVC_volume_12_periods$name <- rep("MVC", 12)
MVC_volume_12_periods$unit_num <- rep(4, 12)
MVC_volume_12_periods$injection <- vaccine_injection_17_periods$MVC[1:12]


# BNT 9/22 才開始施打，故 9/22 以前的補登資料改成 0
# 1 ~ 4 期直接設為 0，第五期扣掉 4 (9/15 ~ 9/21)
BNT_volume_12_periods[1, 7] <- 0
BNT_volume_12_periods[2, 7] <- 0
BNT_volume_12_periods[3, 7] <- 0
BNT_volume_12_periods[4, 7] <- 0
BNT_volume_12_periods[5, 7] <- 125992


# rbind
df_synth <- rbind(AZ_volume_12_periods, BNT_volume_12_periods,
                  Moderna_volume_12_periods, MVC_volume_12_periods)

df_synth <- df_synth[, c("name", "period", "injection",
                         "negative", "positive", "neutral", "unit_num")]



# synthetic control method
dataprep.out<-
  dataprep(
    foo = df_synth,   # data
    predictors = c("negative", "positive", "neutral"),   # 非落後期之變數
    predictors.op = "mean",   # 對變數執行的函數
    dependent = "injection",   # dependent variable
    unit.variable = "unit_num",   # 疫苗編號
    time.variable = "period",   # 施打區間
    special.predictors = list(   # 落後期變數, periods: 2、3、4、5、6
      list("injection", 2, "mean"),
      list("injection", 3, "mean"),
      list("injection", 4, "mean"),
      list("injection", 5, "mean"),
      list("injection", 6, "mean")
    ),
    treatment.identifier = 4,   # MVC unit_num
    controls.identifier = c(1:3),    # 對照組 unit_num
    time.predictors.prior = c(2:6),   # 對 predictors 執行函數 mean 的期間
    time.optimize.ssr = c(2:6),   # 極小化 MSPE 的期間
    unit.names.variable = "name",   # 疫苗名稱
    time.plot = c(2:12)   # 要畫圖之期間
  )


synth.out <- synth(dataprep.out)


path.plot(dataprep.res = dataprep.out, synth.res = synth.out, tr.intake = 6,
          Ylab = "injection", Xlab = "period",
          Main = "MVC Injection vs. synthetic MVC Injection",
          Legend.position = "topleft", Legend = c("MVC", "Synthetic MVC"))


gaps.plot(dataprep.res = dataprep.out, synth.res = synth.out, tr.intake = 6,
          Ylab = "gap in Vaccine Injection", Xlab = "period",
          Main = "gap in Injection between MVC and synthetic MVC")


synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
tab.pred <- synth.tables$tab.pred
tab.w <- synth.tables$tab.w
tab.v <- synth.tables$tab.v


# placebo test
placebos <- generate.placebos(dataprep.out, synth.out)

plot_placebos(placebos, xlab = "period")

ratio <- mspe.test(placebos)
ratio$p.val
MSPE.ratio <- ratio$test

mspe.plot(placebos)
