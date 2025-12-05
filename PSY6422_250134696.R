#-------------------------------------------------------------------------------
#PSY6422_250134696 Final Project - Seth Metcalfe
#-------------------------------------------------------------------------------

#install these packages if not already on your device
install.packages("here")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("naniar")
install.packages("sf")
install.packages("ggiraph")
install.packages("svglite")
install.packages("base64enc")

#load those libraries
library(naniar)
library(here)
library(ggplot2)
library(tidyverse)
library(sf)
library(ggiraph)
library(svglite)
library(base64enc)

#loading in the data set and assigning it the name "raw" and making it a tibble
raw <- read_csv(here("Data", "indicators-Regionsstatistical.data.csv"))
raw_tib <- as_tibble(raw)

#getting a first look at the raw data
head(raw_tib)

#loading the map data
map <- read_sf(here("Data", "Regions_December_2023_Boundaries_EN_BGC_7009286823150963379"))

#-------------------------------------------------------------------------------
#After loading all the packages and data, it's time to clean
#-------------------------------------------------------------------------------

#checking for duplicated data, no duplications were found
duplicated(raw_tib)

#renaming relevant variables to remove spaces
names(raw_tib)[names(raw_tib) == "Indicator ID"] <- "Indicator_ID"
names(raw_tib)[names(raw_tib) == "Area Name"] <- "Area_Name"
names(raw_tib)[names(raw_tib) == "Time period"] <- "Time_Period"
names(raw_tib)[names(raw_tib) == "Area Code"] <- "Area_Code"

#replacing spaces in the data with underscores
raw_cleaned <- raw_tib %>%
  mutate_if(is.character, str_replace_all, ' ', '_')

#filtering and selecting the relevant data
df <- raw_cleaned %>% 
  filter(Indicator_ID == 92906) %>% 
  filter(Area_Code != "E92000001") %>% 
  filter(Sex == "Persons") %>% 
  select(Indicator_ID, Area_Name, Time_Period, Value)

#removing missing data
df <- drop_na(df)

#rounding values to nearest whole number 
#(I made this decision only because the original data source did the same)
df <- df %>% 
  mutate_if(is.numeric, round)

#filtering further to separate 92906 data from the rest of the tibble
df_all <- df %>% 
  filter(Indicator_ID == 92906)

#similar list of filters for the region types of all admission
df_all_NE <- df_all %>% 
  filter(Area_Name == "North_East_region_(statistical)")
df_all_NW <- df_all %>% 
  filter(Area_Name == "North_West_region_(statistical)")
df_all_York <- df_all %>% 
  filter(Area_Name == "Yorkshire_and_the_Humber_region_(statistical)")
df_all_EM <- df_all %>% 
  filter(Area_Name == "East_Midlands_region_(statistical)")
df_all_WM <- df_all %>% 
  filter(Area_Name == "West_Midlands_region_(statistical)")
df_all_EE <- df_all %>% 
  filter(Area_Name == "East_of_England_region_(statistical)")
df_all_Lon <- df_all %>% 
  filter(Area_Name == "London_region_(statistical)")
df_all_SE <- df_all %>% 
  filter(Area_Name == "South_East_region_(statistical)")
df_all_SW <- df_all %>% 
  filter(Area_Name == "South_West_region_(statistical)")

#filtering regions from the map
m_NE <- map %>% 
  filter(RGN23CD == "E12000001")
m_NW <- map %>% 
  filter(RGN23CD == "E12000002")
m_York <- map %>% 
  filter(RGN23CD == "E12000003")
m_EM <- map %>% 
  filter(RGN23CD == "E12000004")
m_WM <- map %>% 
  filter(RGN23CD == "E12000005")
m_EE <- map %>% 
  filter(RGN23CD == "E12000006")
m_Lon <- map %>% 
  filter(RGN23CD == "E12000007")
m_SE <- map %>% 
  filter(RGN23CD == "E12000008")
m_SW <- map %>% 
  filter(RGN23CD == "E12000009")

#-------------------------------------------------------------------------------
#After cleaning, we can start setting the subplots
#-------------------------------------------------------------------------------

#The goal of this section is to set a file path to save the subplots in a tooltip
#to pop them up when we hover over them in the final map plot
plot_to_svg_base64 <- function(plot_obj, width = 4, height = 3) { 
  # Create a temporary file path
  tmp_file <- tempfile(fileext = ".svg")
  
  # Save the plot object to the temporary SVG file
  ggsave(
    tmp_file, 
    plot = plot_obj, 
    device = svglite, 
    width = width, 
    height = height, 
    units = "in"
  )
  
  # Read the SVG content
  svg_content <- readChar(tmp_file, file.info(tmp_file)$size)
  
  # Clean up the temporary file
  unlink(tmp_file)
  
  # Encode the SVG content to Base64 to embed directly in HTML tooltip
  base64_string <- base64encode(charToRaw(svg_content))
  
  # Return the full data URI
  return(paste0("data:image/svg+xml;base64,", base64_string))
}

#plot of the time series of all admissions in the North East Region
ts_all_NE <- df_all_NE %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "darkred") +
  ylim(600, 1000) +
  labs(title = "Admissions in the North East", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
ne_plot_svg <- plot_to_svg_base64(ts_all_NE, width = 3, height = 2.5)

#plot of the time series of all admissions in the North West Region
ts_all_NW <- df_all_NW %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "skyblue") +
  ylim(700, 900) +
  labs(title = "Admissions in the North West", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
nw_plot_svg <- plot_to_svg_base64(ts_all_NW, width = 3, height = 2.5)

#plot of the time series of all admissions in the Yorkshire Region
ts_all_York <- df_all_York %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "orange") +
  ylim(400, 800) +
  labs(title = "Admissions in Yorkshire \nand the Humber", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
theme(plot.title = element_text(size = 10, face = "bold"), 
      axis.title = element_text(size = 8), 
      axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
york_plot_svg <- plot_to_svg_base64(ts_all_York, width = 3, height = 2.5)

#plot of the time series of all admissions in the East Midland Region
ts_all_EM <- df_all_EM %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "orange") +
  ylim(400, 700) +
  labs(title = "Admissions in the East Midlands", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
em_plot_svg <- plot_to_svg_base64(ts_all_EM, width = 3, height = 2.5)

#plot of the time series of all admissions in the West Midland Region
ts_all_WM <- df_all_WM %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "darkred") +
  ylim(400, 700) +
  labs(title = "Admissions in the West Midlands", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
wm_plot_svg <- plot_to_svg_base64(ts_all_WM, width = 3, height = 2.5)

#plot of the time series of all admissions in the East of England Region
ts_all_EE <- df_all_EE %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "orange") +
  ylim(300, 600) +
  labs(title = "Admissions in the East of England", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
ee_plot_svg <- plot_to_svg_base64(ts_all_EE, width = 3, height = 2.5)

#plot of the time series of all admissions in the London Region
ts_all_Lon <- df_all_Lon %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "orange") +
  ylim(400, 700) +
  labs(title = "Admissions in the London Region", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
lon_plot_svg <- plot_to_svg_base64(ts_all_Lon, width = 3, height = 2.5)

#plot of the time series of all admissions in the South East Region
ts_all_SE <- df_all_SE %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "skyblue") +
  labs(title = "Admissions in the South East", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  ylim(100, 800) +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
se_plot_svg <- plot_to_svg_base64(ts_all_SE, width = 3, height = 2.5)

#plot of the time series of all admissions in the South West Region
ts_all_SW <- df_all_SW %>% 
  ggplot(aes(x = Time_Period, y = Value)) +
  geom_point(color = "black") +
  geom_line(aes(group = "Area_Name"), color = "orange") +
  labs(title = "Admissions in the South West", 
       x = "Years", 
       y = "Number of Admissions (per 100,000)") +
  ylim(400, 800) +
  theme_classic() +
  theme(plot.title = element_text(size = 10, face = "bold"), 
        axis.title = element_text(size = 8), 
        axis.text = element_text(size = 7, angle = 45, hjust = 1, vjust = 1))
sw_plot_svg <- plot_to_svg_base64(ts_all_SW, width = 3, height = 2.5)

#-------------------------------------------------------------------------------
#The final visualization
#-------------------------------------------------------------------------------

#begin by setting a vector of the colors used in the legend
colors_legend <- c("Increasing" = "darkred", 
                   "Decreasing" = "skyblue", 
                   "No Significant Change" = "orange")

#plotting the map
final <- ggplot() +
  geom_sf_interactive(data = m_NE, size = .5, color = "black", aes(fill = "Increasing", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                         "Change: Increasing<br><br>",
                                                                                                         '<img src="', ne_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_NW, size = .5, color = "black", aes(fill = "Decreasing", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                         "Change: Decreasing<br><br>",
                                                                                                         '<img src="', nw_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_York, size = .5, color = "black", aes(fill = "No Significant Change", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                                      "Change: No Significant Change<br><br>",
                                                                                                                      '<img src="', york_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_EM, size = .5, color = "black", aes(fill = "No Significant Change", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                                    "Change: No Significant Change<br><br>",
                                                                                                                    '<img src="', em_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_WM, size = .5, color = "black", aes(fill = "Increasing", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                         "Change: Increasing<br><br>",
                                                                                                         '<img src="', wm_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_EE, size = .5, color = "black", aes(fill = "No Significant Change", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                                    "Change: No Significant Change<br><br>",
                                                                                                                    '<img src="', ee_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_Lon, size = .5, color = "black", aes(fill = "No Significant Change", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                                     "Change: No Significant Change<br><br>",
                                                                                                                     '<img src="', lon_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_SE, size = .5, color = "black", aes(fill = "Decreasing", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                         "Change: Decreasing<br><br>",
                                                                                                         '<img src="', se_plot_svg, '" width="300" height="250" />'))) +
  geom_sf_interactive(data = m_SW, size = .5, color = "black", aes(fill = "No Significant Change", tooltip = paste0("<b>", RGN23NM, "</b><br>", 
                                                                                                                    "Change: No Significant Change<br><br>",
                                                                                                                    '<img src="', sw_plot_svg, '" width="300" height="250" />'))) +
  ggtitle("Changes in Alcohol-Specific Hospital Admissions Since 2016") +
  theme_void() +
  theme(panel.grid = element_line(color = "transparent")) +
  labs(fill = "Legend",
       subtitle = "Across England's Nine Regions") +
  scale_fill_manual(values = colors_legend) +
  theme(plot.title = element_text(size = 15, hjust = 0)) +
  theme(plot.subtitle = element_text(size = 10, hjust = 0.95)) +
  theme(legend.position = "right")

girafe(ggobj = final)

#end of script