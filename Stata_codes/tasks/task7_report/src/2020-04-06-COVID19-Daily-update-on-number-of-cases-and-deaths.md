---
layout: post
title: COVID-19 - Daily update on number of cases and deaths
date: 2020-04-06 17:00:00 +0100
category: daily-updates
---
[Federico Gallina](https://www.ulb.be/fr/federico-gallina) [(ECARES, ULB)](https://ecares.ulb.be) and [Glenn Magerman (ECARES, ULB)](http://www.glennmagerman.com).
### Introduction

-------------------------------------

This article presents daily numbers and insights on COVID-19 infections for Belgium, the EU28 and most infected countries in the world.
By combining different statistics, the goal is to better understand where we are in the trajectory of the epidemic, taking the current measures as given. 
We report the number and growth rates of cases and deaths by country, and more detailed information on hospitalization, cases and deaths for Belgium.
We also estimate a real-time epidemic curve, which gets updated daily. This curve serves as a blueprint for the predicted trajectory of the epidemic.
The more data becomes available over time, the more accurate this predicted epicurve will be. 

Today's key numbers:
- Global: {{.1}} total cases, and {{.2}} deaths in {{.3}} countries with reported COVID-19 cases.
- EU28: {{.4}}, and {{.5}} deaths.
- Belgium: {{.6}} total cases, {{.7}} total hospitalised, {{.8}} in intensive care, {{.9}} on respiration, {{.10}} deceased, and {{.11}} released. 

<!--more-->


**Note 1**: We report statistics based on the number of confirmed COVID cases and deaths. 
These world-wide available daily numbers are informative and the best which are available cross-country. However, they are not perfect. 
First, the number of infected people is indisputably much higher than the reported number of cases per country. 
Not everyone is, will be, nor can be, tested. 
This is due to a combination of technical constraints (it is simply impossible to test the whole population), policy constraints (who to test if there are limited resources to test), and the presence of asymptomatic infected people.
See [Bloomberg](https://www.bloomberg.com/opinion/articles/2020-03-28/confirmed-coronavirus-cases-is-an-almost-meaningless-metric) for a short discussion on who we should test.
Second, cross-country differences in infection rates are in part driven by differences in testing policies, which can also vary over time. 
This implies that both across- and within-country numbers based on the number of cases and deaths (including case-fatality rates etc.) are partly driven by these (changes in) testing policies, and therefore not only reflect the evolution of the virus per se.
Third, up to today, the number of cases does not convey the severity of the disease by case. Health care data scientists would need much more detailed information on tested people to help make informed policy decisions on when/how to close and open up again: positive/negative, demographics, pre-existing conditions, etc.
Finally, there are [several sources of over, under and late reporting](https://www.bbc.com/future/article/20200401-coronavirus-why-death-and-mortality-rates-differ)) of the number of deaths, which again can vary over time and across countries. 
For Belgium, one source of lagged reporting of deaths is the transmission of numbers outside hospitals to Epistat (e.g. from retirement homes). In general, differences in testing across countries leads to differences in death cause attribution.
We take moving averages to smooth out these reporting lags in several graphs.
We take these observations as given.

**Note 2**: This article is of a descriptive nature: it does not make policy or normative statements. Please see [Learning from the curve](https://github.com/Learning-from-the-curve) for other initiatives.

**Note 3**: Analysis will be evolving as the project continues. Feedback, suggestions, and/or critiques are highly welcomed at [glenn.magerman@ulb.ac.be](glenn.magerman@ulb.ac.be).

**Data sources:** 
- Detailed COVID data for Belgium from [Epistat](https://epistat.wiv-isp.be/covid/). 
- Vector maps for Belgium from [geo.be](geo.be).
- Life tables for Belgium from [Statbel](https://statbel.fgov.be/sites/default/files/files/documents/bevolking/5.4%20Sterfte%2C%20levensverwachting%20en%20doodsoorzaken/5.4.3%20Sterftetafels%20en%20levensverwachting/sterftetafelsAE.xls).
- COVID data by country around the world from [ECDC](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide).
- Country population data from [UN](https://population.un.org/wpp/Download/Standard/CSV). 


### 1. Daily updates for Belgium

-------------------------------------

We start with the analysis of daily updated data for Belgium. All of the graphs in the article are interactive. Click on the legend to activate/deactivate lines, and select measures/observations using the dropdown menus.

Figure 1 shows total COVID numbers for confirmed cases, hospitalizations and deceased patients by date. 

While the numbers of cases are a very noisy measure (see Note 1 in the introduction), the detailed information on hospitalizations by date for Belgium are a more informative measure of the virus spread.
There is no under-reporting of hospitalizations, and they also reflect the severity of the outbreak. 
Moreover, they are key numbers to measure the load on the health care system. [^1]
[^1]: If the hospital capacity constraint would become binding at a given moment, hospitalization numbers would be under-reporting as severely ill people stay at home. For now, there is still sufficient capacity. 
  
As of today, there is a current maximum capacity of 2,293 ICU beds reserved for COVID patients (red horizontal line), and there is {{.12}} % capacity of ICU beds taken. 
Based on this data, it is possible to make predictions on the expected load for future days, and plan accordingly as a hospital and/or policy maker.

{% include BE_cases_hosp_dead %}
*Figure 1: The number of cases, hospitalizations and deaths in Belgium are currently stabilizing.*  


Next, figure 2 shows the number of cases and hospitalized patients by province, for the latest available date.[^2] 

[^2]: There is currently no information on the number of deceased patients by province. These numbers by province can be lagged a few days.

{% include BE_hosp_by_province %}
*Figure 2: All provinces are hit by COVID, more cases in Flanders than Wallonia.*

Then, we show the number of cases by city in Figure 3.[^3] 

[^3]: At the moment, there is only info on the number of cases by city, not hospitalized or deaths.

The city with the highest number of infections is {{.13} with {{.14}}. {{.15}} follows with {{.16}} and {{.17}} is third with {{.18}} cases. 
In absolute terms, Flanders is much more infected than Wallonia, and these infections are also spread out across most cities.

{% include BE_cumcases_bycity %}
*Figure 3: There are cases in almost all cities, with more infections in Flanders.*

In Figure 4, we construct an estimate of the real-time epidemic curve for both cases and deaths.
The epicurve reports the fraction of total cases/deaths over the span of the disease. 
When people talk about "flattening the curve", THIS is the curve.

This curve provides information on the speed (growth rate by day) and severity (number of cases/deaths) of the COVID epidemic, and are important blueprints to benchmark further outbreaks of the disease in the future.
Some examples of epicurves for [Mers-Cov](https://www.nature.com/articles/s41598-019-43586-9), [SARS](https://www.who.int/csr/sars/epicurve/epiindex/en/index1.html), [influenza in Canada](https://onlinelibrary.wiley.com/doi/full/10.1111/j.1750-2659.2010.00154.x) and [influenza in Belgium](https://epistat.wiv-isp.be/influenza/). 

The main drawback is that true epicurves are only available at the end of the disease. 
At that moment, we will have the full distribution of cases/deaths over time per country (conditional on all the remarks on the measurement of cases and deaths).
Still, we construct epicurves for Belgium and other countries while the disease evolves, as follows.[^4] 

[^4]: This is a model-based estimation of the epicurves. Assumptions on the underlying model(s) will affect the predicted growth paths. 
We do not pretend to provide the best predictive model, and more complex but refined methods are available, such as [Bayesian estimation](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0002185).

First, we target one or more countries that have potentially completed the first wave of the disease. We use these countries as a benchmark epicurve.
As of today, we use only China as a benchmark.[^5] 

[5^]: Typically, epicurves are benchmarked against earlier epidemics of the same disease in the same country. Here, we do a cross-country analysis in real time. 
There can be several mechanisms that make the curves different for different countries, such as different policies, population density and geographic heterogeneity.
 
Under the assumption that China has completed its cycle, we can plot the epicurve for China as follows:
We calculate the number of cases or deaths over time for each country, relative to the peak of the outbreak, i.e. the day with the most reported cases or deaths (time 0).
Next, to compare across other outbreaks over time or across countries, we rescale the number of cases/deaths to a daily share in the total outbreak for that country cycle.
This provides the epicurve for countries that have completed their cycle. 
We plot the curve from the moment 0.1% of cases/deaths are reported to avoid excessive noise in the positioning of the curve.
As more countries will complete the outbreak cycle, they will contribute to the benchmark of the "true" epicurve for COVID for other countries still completing their cycles.[^6] 

[^6]: At the end of the outbreak for a country, in theory the real-time epicurve coincides with the true epicurve. In practice, we still face measurement issues as discussed in the introduction.

In other words, we keep an eye on these epicurves as more countries pass the first peak and this solidifies the structure of the general epicurve.
At this stage, one important observation is that the decline of the epicurve after the peak is slower than the increase before the turning point.
In other words, even conditional on having the same policies in place, it will take longer for the numbers to go to zero. 
Any premature release of stringent policies will add to the length of this tail. 

Second, only for countries that have completed their cycle, the peak is known. 
For countries still evolving, we forecast their peak using time series prediction models on the daily growth rates.
In particular, we predict future growth rates using a 4th degree polynomial on current growth rates presented above. 
A peak arrives when the growth rate turns zero, and then turns negative afterwards.
Based on the predicted peak (*x*-axis), we can recalibrate the share of infections (*y*-axis) as a fraction of the total predicted number retrieved from the current cases and predicted growth rates. 

Third, we compare cases and deaths over time as the outbreak evolves, and we re-estimate, fit and update the curves daily. 
Finally, this calibration allows to compare different countries relative to the benchmark, or different cycles of different intensity within a country.

These initial projections suggest that China has experienced a turning point at around 25-30 days for the number of cases. 
We do see signs however, of a starting second wave in China, both in terms of cases and deaths.
It is too early to draw conclusions for Belgium, but we might be hopeful that we are around the peak, with around zero growth rates and similar lead times to the peak (25-30 days).

At this stage, it is important to note that: 
(i) these curves change daily, with the difference between the estimated and the true curve going to zero as a country completes a cycle.
(ii) growth rates, and thus the epicurves, are affected by the particular policies in place, and the moment they are implemented. Too early lifting of measures can and will result in a direct second wave. 
(iii) it is highly probable that additional waves will arrive within a country. As of today, it is not certain that China has finished its full cycle, or that there are additional cycles coming up. 
(iv) these figures do not serve as any policy measure in any way. They only serve to get an estimate of the epicurves in real time, instead of waiting until the end of the outbreak.

{% include BE_epicurve_cases %}
{% include BE_epicurve_deaths %}
*Figure 4: Epicurves: predicted evolution of the epidemic waves. Where are we?.*


Finally, we end the analysis for Belgium with a comparison of the age distribution of COVID deaths, against life expectancy for Belgians in 2018.
We start by showing the life expectancy curve for Belgians in 2018 in Figure 5. 
The curve plots the probability of being dead by a certain age for each year of age (i.e. a cumulative distribution function). 
The curve is shown for both sexes jointly, and male and female separately. This graph shows for example that females have in general a higher life expectancy than males, as is well known.

We then overlay the deaths by age group reported in the COVID data.
We discretize the distribution to match the COVID data which is represented in age bins (0-24 years, 25-44, 45-64, 65-74, 75-84, 85+).
While the life tables are fixed, the COVID death tolls by age are updated daily.
It's important to note that there are relatively few observations of deaths by category, so this distribution might change over the course of the disease.


There is a clear higher than expected death rate for the very elderly. 
However, this data does not account for pre-existing conditions, some of which might be a plausible risk factor for COVID diseases (diabetes, vascular diseases etc.)
Moreover, both age and pre-existing conditions are positively correlated, so it is not clear whether the risk of dying from COVID is mostly related to either of these factors.
More detailed data on pre-existing conditions by age would help in disentangling both factors. Unfortunately, this data is not (yet) available. 
We split the comparison also by sex.

We also compare COVID deaths by region (Brussels, Flanders, Wallonia) against the Belgian life tables.
There might be regional differences (e.g. from health care capacity or quality), but at this stage, there is no clear distinguishable pattern.

{% include BE_lifetables_bysex %} --> this is the continuous benchmark,  I would put it not as the first tab.
{% include BE_lifetables_all %}
{% include BE_lifetables_male %}
{% include BE_lifetables_female %}
{% include BE_lifetables_regions %}
*Figure 5: Life expectancy and COVID deaths by age show a larger mortality rate for the very elderly.*



### 2. Number of cases, world and EU28

--------------------------------------


#### 2.1 Number of cases

We continue with reporting the number of cases for the 10 most infected countries in the world and the EU28.
Some of these graphs are very similar to the popular graphs in the [Financial Times](https://www.ft.com/coronavirus-latest).[^7] 

[^7]:You can use the dropdown menu to select variants of the same curve. All graphs are interactive, and allow for a sub-selection of countries.

Figure 6 shows the total number of cases over time. 
The country with the most cases is {{.12}}  with {{.13}} total confirmed cases. 
Second is {{.14}} with {{.15}} confirmed cases, and {{.16}} follows, with {{.17}} cases.

The first tab reports the total number of cases (in log scale), since the 100th confirmed case within that country. 
In the initial outbreak phase, the epidemic spreads exponentially, not arithmetically, i.e a log scale is the natural way to track the spread.
Synchronizing dates since the 100th confirmed case allows to compare the speed and evolution of the epidemic across countries.

However, [exponential growth curves cannot continue forever](https://medium.com/data-for-science/epidemic-modeling-101-or-why-your-covid19-exponential-fits-are-wrong-97aa50c55f8),
and growth has to decline at some moment due to constraints on the population its is passing through (conceptually, the availability of next victims to infect for various reasons (policies, geography, density...)).
China has been stabilizing since the end of February, signalling that the first peak has passed. However, new domestic cases signal the possible onset of a second wave.
Several countries show a decline in the increase of the number of new daily cases, hopefully pointing to passing a peak, or at least a stabilization of the number of infected people.
However, many countries are still facing exponential growth rates (linear in logs), signalling those countries face the onset of the pandemic.

We repeat the graph for the 10 most infected countries in the EU28.
The EU28 country with the most cases is {{.18}} with {{.19}} total confirmed cases. 
Second is {{.20}}, with {{.21}} confirmed cases, and {{.22}} follows, with {{.23}} cases.
It's worth noting that Sweden's infection rate has decreased significantly since around the 9th day after the 100th confirmed case, while having a [rather lenient policy](https://www.forbes.com/sites/davidnikel/2020/03/30/why-swedens-coronavirus-approach-is-so-different-from-others/#538677cb562b) towards the spread of the virus.  

![Figure 6: Total cases.](../../task2_cumcases/output/global_lncumcases_post100.svg){width=75%}
![Figure 6: Total cases.](../../task2_cumcases/output/EU_lncumcases_post100.svg){width=75%}
*Figure 6: Total cases still show close to exponential growth rates for countries like the USA and UK.*

#### 2.2 Number of cases per million population

Figure 7 shows the total number of cases, per million population, since the 100th case per million people for these top 10 countries.
Absolute numbers are a key statistic in the onset of the epidemic, as they relate to the number of people infected from one patient. 
Moreover, in standard S(E)IR models, the number of infected people rises almost identical in countries with vastly different population sizes. 
The first few weeks in the outbreak, higher per-capita numbers mostly imply smaller countries, not different policies or growth rates.
However, as the epidemic evolves over time and reaches a steady state, a certain fraction of the population will be infected. 
A significant part of the friction the virus encounters, and which in turn affects its growth rate, is country-specific: policy measures, geographic dispersion, population density etc.

Tab 1 shows these numbers for the 10 most infected countries in the world, tab 2 does this for the top 10 EU28 countries.
As of today, the EU28 has an average infection rate of {{.......}}, calculated as the total number of cases/deaths over the EU28 population. 
This is still far off the [projections](https://www.hsph.harvard.edu/news/hsph-in-the-news/the-latest-on-the-coronavirus/) of 30-70% of adult world population ultimately being infected. 
There are at least four plausible scenarios: 
(i) real infection rates are orders of magnitude larger than reported ones. If we are at the end of the epidemic, this implies real infection rates are around 100-300 times larger than currently reported. 
We will never know the true infection rate (due to significant under-testing and a sizeable fraction of asymptomatic infected), and only obtain a guess at the end of the epidemic.
(ii) the epidemic is only in its onset, and we expect to reach higher infection rates. Given that most countries have not passed their first peak yet, this is a plausible scenario. 
(iii) we are reaching the end of the epidemic, and infection rates are much lower than projected. Given the growth rates and our initial estimates for epidemic curves discussed below, we believe this scenario is not probable at this moment.
(iv) flattening-the-curve policies lowers the speed with which the epidemic rages. It is not clear yet whether these policies affect the total infection rate at the end of the epidemic. 
With these policies in place, the share of infected population can grow at a lower rate but over a longer period.


{% include global_lncumcasesperMln_post100perMln %}
{% include EU_lncumcasesperMln_post100perMln %}
*Figure 7: Correcting for population size, the most infected countries are Spain, Switzerland and Belgium.*


#### 2.3 Growth rate of the number of cases

Next, we plot the evolution of growth rates of the number of cases in Figure 8.
Growth rates are expressed in percentage changes from date *t-1* to *t*.[^8]
[^8]: The growth rate on absolute numbers is identical to one calculated as cases per million inhabitants.
We take a 3-day simple moving average to account for strong fluctuations from e.g. reporting lags within countries. 
Each country wants to see this growth rate going to zero as soon as possible. 

Two things are worth noting. 
First, the slopes, or decreases in growth rates, are not the same across countries.
Second, even smoothed by a 3-day moving average, these growth rates are not monotonically decreasing. This might be partially due to temporal new outbursts of the virus within countries, or to increased testing policies.[^9] 
[^9]: Approximating these growth rates with a 4th-order polynomial fit also shows these non-monotonicities. 


{% include global_growthcases_post100 %}
{% include EU_growthcases_post100 %}
*Figure 9: Growth rates are declining for most countries, but some stay fluctuating at high levels.*



### 3. Number of deaths, world and EU28

-------------------------------------


#### 3.1 Number of deaths
As noted in the introduction, the number of cases is prone to several important sources of non-random measurement error. 
While measurement error also exists for the number of deaths, this number draws a clearer (but morbid) picture. 

Figure 10 shows the total number of deaths for the top 10 countries with the deadliest outbreak over time. 
As of today, the country with the most deaths is {{.26}}, with {{.27}} deaths. 
Second is {{.28}}, with {{.29}} deaths, and {{.30}} follows, with{{.31}} deaths. Together, they account for {{}} % of all deaths worldwide.

The first tab plots the total number of deaths (in log scale) since the 10th death.
Again, we see that China has stabilized for now, with around 3,500 deaths.
Since the second half of February, China has been overtaken by Italy and Spain.
Since April 1, the USA is the country with the third highest number of deaths due to COVID. 
Most western countries are on a similar trajectory as Italy, with Spain faring worse, and Sweden and Germany being on a better growth path.


The second tab shows the same total number of deaths by date, in levels.

We repeat the graph for the 10 highest mortality countries in the EU28 in tabs 3 and 4. 
The EU28 country with the most deaths is {{.32}}, with {{.33}} deaths. Second is {{.34}}, with {{.35}}, and {{.36}} follows, with {{.37}}deaths.


{% include global_lncumdeaths_post100 %}
{% include EU_lncumdeaths_post100 %}
*Figure 10: Most countries are on a similar trajectory as Italy.*


#### 3.2 Number of deaths per million population

Figure 11 shows the total number of deaths, per million population, since the 10th death per million people for these top 10 countries.
Correcting for country size, Italy and Spain are still ahead of other countries. However, Belgium and the UK are on a similar trajectory.

{% include global_lncumdeathsperMln_post100perMln %}
{% include EU_lncumdeathsperMln_post100perMln %}
*Figure 11: Total deaths, per million population.*

#### 3.3 Growth rate of the number of deaths

We plot the evolution of growth rates of the number of deaths in Figure 12.
The growth rate of Italy is slowing down relatively fast, a hopeful sign.
However, other countries like the United States or the United Kingdom, so not see steady declining growth rates yet.

{% include global_growthdeaths_post100 %}
{% include EU_growthdeaths_post100 %}
*Figure 12: Growth rates, number of deaths.*


### 4. Derived measures, world and EU28

-------------------------------------
We continue with two measures that are highly imperfect, but serve as a benchmark for longer time horizons in tracking the epidemic spread.

The first is the mortality rate, or the number of people dying from COVID as a fraction of total population.
For the 10 countries with the highest current mortality rates in the world, this is reported in Figure 13, tab 1. For the EU, this is reported in tab 3.

Since population is (nearly) fixed, this number will increase monotonically over time and reach a constant value at the end of the epidemic. Various studies put the mortality rate in a range between 1% and 8%.
There are several sources of measurement error.[^4] [^4]: See also Note 1 in the introduction.
Therefore, the rate within countries is more informative than the cross-country comparison of the levels of these rates, and we focus on the direction and speed of these measures, rather than their absolute numbers.

The second measure is the case-fatality rate (CFR), which reports the number of people dying as a fraction of the infected population. This number is always higher than the mortality rate, as it is a ratio over a strict subset of the population (confirmed infected cases).
This measure also deserves important critiques.
First, in real time, estimates of the CFR can be biased upwards by under-reporting of cases, and downwards by failure to account for the delay from confirmation to death.
Second, the CFR is surely biased upwards since the true number of infected people is much larger than what is reported. Therefore, we focus on the within-country evolution of these rates, rather than comparing across countries, or even the numbers themselves at face value.
Again, we therefore rather focus on the direction and growth of these numbers within countries, acknowledging there might also be within-country changes over time that drive part of the patterns.



{% include global_mortalityrate_post10 %}
{% include EU_mortalityrate_post10 %}
{% include global_CFR_post10 %}
{% include EU_CFR_post10 %}
*Figure 13: Growth rates, number of deaths.*

### 5. Estimated epidemic curves, world and EU28

-------------------------------------

We conclude with an estimate of real-time epidemic curves for cases and deaths, for both the top 10 world countries and the EU in Figure 14.
These initial projections suggest that China has experienced a turning point at around 25-30 days. Italy might be on a similar track with a turning point at around 30 days.
Most other countries however, still face increasing rates of infections and deaths.

{% include global_mortalityrate_post10 %}
{% include global_CFR_post10 %}
{% include EU_mortalityrate_post10 %}
{% include EU_CFR_post10 %}
*Figure 14: Real-time epicurves.*




We are back with updated numbers tomorrow.
In the mean time, stay safe, and take care of yourself and of others.
Federico and Glenn.



