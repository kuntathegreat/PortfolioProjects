
The NashvilleHousing file was downloaded and loaded into microsft sql server management system

## Data Preprocessing for Nashville Housing Dataset

## Introduction:

In this post, we'll dive into the data preprocessing steps carried out on the Nashville Housing dataset. The dataset was initially downloaded and loaded into Microsoft SQL Server Management System for analysis. The goal was to prepare the data for further analysis and modeling by standardizing dates, handling missing values, transforming categorical variables, removing duplicates, and eliminating unused columns.

### Step 1: Loading Data into SQL Server Management System

The first step involved downloading the Nashville Housing dataset and loading it into Microsoft SQL Server Management System. This allowed for efficient data querying and manipulation using SQL queries.


### Step 2: Standardizing Dates

One of the initial challenges in the dataset was dealing with various date formats. To ensure consistency, all date columns were standardized to a common format using SQL queries. This standardized format facilitated subsequent analysis and visualization.

The current date format for the SaleDate is highlighted below. It contains the Year, Month, day, Hour, Minute and Second.

<img width="710" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/d593bf61-e58d-4550-a3e7-52a3475df0e7">


The CONVERT function is used to transform the SaleDate to only Year, Month and Day.

<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/6df2c690-5935-417d-9251-d59dd34f07bb">

A new column SaleDateConverted is added and updated with the above function.

<img width="713" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/99969a6a-1bcd-40f0-9b22-9172a5c0432a">


### Step 3: Handling Missing Data

Address information is crucial in housing datasets, but the PropertyAddress column had missing data. To address this, missing values in the PropertyAddress column were populated using various data sources and matching techniques. This step ensured that address-related information was available for further analysis.


<img width="710" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/55ff730f-1522-4bc6-9841-d8e19f780485">

To begin with, our observation reveals the existence of missing data within the PropertyAddress column. The NULL function is utilized for this step.

<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/95aa745c-b0cd-4ddb-b03a-5f1e81ab3982">

Subsequently, we proceed to populate the missing values in the PropertyAddress column using the address information associated with the same parcelId.

<img width="709" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/761f4089-c739-4b45-a835-3c95a254068d">



<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/0f2e3f51-26d5-41ef-98f5-bd3c6af18108">

The dataset is rechecked for missing values in the Property Address with multiple matching ParcelId.

<img width="712" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/6078db13-3894-4e86-b348-9dad8d6f8994">



### Step 4: Breaking Address Information

A quick view of the PropertyAddress column is observed.
<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/2acc66d1-5cc5-42a5-9633-d59bd5b46be7">

We employed the SUBSTRING and CHARINDEX functions to extract the address and city information from the PropertyAddress Column.

<img width="712" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/d7eab34f-90f5-4fa6-81f2-95fb17a9195c">

New Columns were created for the Updated Address and Updated City that were extracted. These columns are then populated using the above functions.


<img width="712" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/bbbc3ec0-3d04-40d8-83a2-c4de9b004486">

The UpdatedAddress and UpdatedCity is highlighted.

<img width="713" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/cc502468-b49a-4ba0-a958-cb85597df231">

Also, PARSENAME and REPLACE functions can be used to split values in a column instead of the SUBSTRING function.

<img width="712" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/b8d0c512-7ad0-4ae4-9405-3b9c3ca09b53">

Results shown.

<img width="710" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/ec5b1d5e-6ba6-4cc1-9f8b-282feed9c5fe">



<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/8fa772c4-000e-4599-a41b-72486a5b5254">


The PropertyAddress column contained complete address information, including city and state. To enhance data organization and querying, the address information was broken down into separate columns for address, city, and state using SQL string manipulation functions.

### Step 5: Handling Categorical Data

The SoldAsVacant field contained values "Y" and "N," which were transformed to "Yes" and "No" for better interpretability and consistency. This transformation improved the clarity of the data and its subsequent analysis.

Displaying the first few rows of the SoldAsVacant Column.

<img width="707" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/a7d12c47-a026-43de-a7bd-2ac4e0a41d73">

We proceed to checking for all the unique values contained down the column.

<img width="708" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/1c21e17a-e70e-4e3d-80a0-df8579a41d28">

CASE is used to replace all the 'Y' and 'N' with 'YES' and 'NO'.

<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/1dde2e84-57f5-47a1-ad9c-9b516a20925d">

The UPDATE function is then used to update the SoldAsVacant column entries.

<img width="712" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/14d935f5-fe52-4a4e-b6e1-c6e0462fa345">

The Column is rechecked for the unique values after updating with the correct values.

<img width="710" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/eacbc670-19c8-4ddb-9eef-13eac291f6e6">



Step 6: Removing Duplicates

Duplicate records can distort analysis results and lead to biased insights. Therefore, duplicate entries were identified and removed from the dataset using SQL queries, ensuring that each observation was unique.

A Common Table Expression (CTE) is employed to categorize the columns for the purpose of identifying recurring values.

<img width="956" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/a621620f-ec52-47b1-9eac-680f6d072eeb">

104 rows contain duplicates 

<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/65c16223-dea9-4af0-837b-f78a4c816eed">

These 104 rows of duplicated values are then removed from the dataset 

<img width="937" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/dd984de4-0b36-473c-87de-4f76e87cafc1">



### Step 7: Eliminating Unused Columns

Some columns in the dataset were not relevant to the analysis goals or contained redundant information. These unused columns were identified and subsequently deleted to streamline the dataset and reduce unnecessary complexity.

<img width="711" alt="image" src="https://github.com/kuntathegreat/sql_data_cleaning/assets/60355382/190b1dc6-aabb-47f2-ae95-a8f1ee3d057b">


### Conclusion:

In this post, we explored the critical data preprocessing steps carried out on the Nashville Housing dataset. By loading the dataset into Microsoft SQL Server Management System, standardizing dates, populating missing address information, transforming categorical variables, removing duplicates, and eliminating unused columns, we successfully prepared the data for further analysis and modeling. These preprocessing steps are essential to ensure the accuracy, reliability, and effectiveness of subsequent data analysis and machine learning endeavors.
