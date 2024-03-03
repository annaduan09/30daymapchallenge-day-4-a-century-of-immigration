# Animation: A Century of Migration in NYC  
Anna Duan   
November 4, 2023  


This project visualizes the evolution of New York City's population density distribution at the census tract level over the last 110 years, from 1910 to 2020. The animation created showcases changes in population density across different neighborhoods, highlighting growth patterns and demographic shifts within the city. This work was completed as part of the 2023 [#30daymapchallenge](https://30daymapchallenge.com/), specifically for Day 3 themed "polygons."

## Data Sources

- **Census Tract Level Census Data:** The data was sourced from the [National Historical Geographic Information System (NHGIS)](https://www.nhgis.org/), providing detailed demographic, social, and economic information at the census tract level across multiple decades.

## Tools and Libraries

The project was developed using R, with visual enhancements made in Canva. Key R packages used include:

- [`sf`](https://cran.r-project.org/package=sf): For handling spatial data.
- [`tidyverse`](https://www.tidyverse.org/): An ecosystem of packages for data manipulation and visualization.
- [`mapview`](https://cran.r-project.org/package=mapview): For interactive viewing of spatial data.
- [`conflicted`](https://cran.r-project.org/package=conflicted): For managing namespace conflicts between packages.
- [`tigris`](https://cran.r-project.org/package=tigris): For loading geographic boundary files.
- [`stringr`](https://cran.r-project.org/package=stringr): For string operations.
- [`gganimate`](https://gganimate.com/): For creating animations from ggplot figures.
- [`viridis`](https://cran.r-project.org/package=viridis): For color scales.
- [`crsuggest`](https://cran.r-project.org/package=crsuggest): For suggesting coordinate reference systems.

R and its packages are available from [The Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/).

## Methodology

1. **Data Preparation:** Census data from NHGIS was imported for each decade from 1910 to 2020. Census tract boundaries were also sourced from NHGIS for corresponding years.
2. **Data Wrangling:** Population data was filtered, selected, and renamed to ensure consistency across decades. The data was then joined with spatial data to prepare for visualization.
3. **Animation Creation:** Using `gganimate` alongside spatial and population data, an animation was created to visualize changes in population density across NYC's census tracts over the last century.

## Visualization

The final visualization was enhanced with graphic design elements in Canva, emphasizing clarity, engagement, and aesthetic appeal. The animation provides a dynamic view of NYC's evolving population landscape, highlighting areas of growth, decline, and transformation.

## Acknowledgments

This project owes its success to the comprehensive data provided by NHGIS and the vibrant R programming community for developing powerful libraries that facilitate spatial data analysis and visualization.

## Participation

This work was done as part of the [#30daymapchallenge](https://30daymapchallenge.com/), a challenge that encourages participants to create and share maps based on different themes throughout the month. This project corresponds to Day 3: "Polygons."

## License

The project is open-sourced under the MIT License. Feel free to use, modify, and distribute the code, with appropriate attribution.

