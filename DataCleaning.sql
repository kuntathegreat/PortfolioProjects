select *
from PortfolioProject..NashvilleHousing

--Standardize date format

Select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted
from PortfolioProject..NashvilleHousing

---------------------------------------------

--Populate PropertyAddress Data

select ParcelID, PropertyAddress
from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and  a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null
order by a.ParcelID

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and  a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------

--Breaking Address into individual columns (address city state) 

select PropertyAddress
from PortfolioProject..NashvilleHousing

select PropertyAddress,
	   SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as UpdatedAddress,
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress)) as UpdatedCity

from PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add UpdatedAddress Nvarchar(255);

Update NashvilleHousing
SET UpdatedAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
ADD UpdatedCity Nvarchar(255)

UPDATE NashvilleHousing
SET UpdatedCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress))


select *
from PortfolioProject..NashvilleHousing

Select OwnerAddress
from PortfolioProject..NashvilleHousing

Select
OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD UpdatedOwnerAddress Nvarchar(255)

UPDATE NashvilleHousing
SET UpdatedOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD UpdatedOwnerCity Nvarchar(255)

UPDATE NashvilleHousing
SET UpdatedOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD UpdatedOwnerState Nvarchar(255)

UPDATE NashvilleHousing
SET UpdatedOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from PortfolioProject..NashvilleHousing

------------------------------------------------------------------------------

--Change Y and N to Yes and No in SoldAsVacant 

Select SoldAsVacant
from PortfolioProject..NashvilleHousing

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' THEN 'YES'
		When SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
from PortfolioProject..NashvilleHousing
Where SoldAsVacant = 'Y' or
		SoldAsVacant = 'N' 

UPDATE NashvilleHousing
SET SoldAsVacant = 
Case When SoldAsVacant = 'Y' THEN 'YES'
	 When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END

-------------------------------------------------------------

--REMOVE DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




