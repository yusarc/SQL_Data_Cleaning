/*

Cleaning Data in SQL Queries

*/
select * 
from Nashville_Housing.dbo.Nashville
---------------------------------------------------------------------------------------------------------------

--Standardize Date Format
select SaleDate, CONVERT(Date, SaleDate) 
from Nashville_Housing.dbo.Nashville



ALTER TABLE Nashville
Add SaleDateConverted Date;

Update Nashville
SET SaleDateConverted = CONVERT(Date, SaleDate)


select SaleDateConverted, CONVERT(Date, SaleDate) 
from Nashville_Housing.dbo.Nashville

--------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data
select *
from Nashville_Housing.dbo.Nashville
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville_Housing.dbo.Nashville a
Join Nashville_Housing.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville_Housing.dbo.Nashville a
Join Nashville_Housing.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State) 
select PropertyAddress
from Nashville_Housing.dbo.Nashville
--where PropertyAddress is null
--order by ParcelID

SELECT	
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

from Nashville_Housing.dbo.Nashville


ALTER TABLE Nashville_Housing.dbo.Nashville
Add PropertySplitAddress Nvarchar(255);

Update Nashville_Housing.dbo.Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE Nashville_Housing.dbo.Nashville
Add PropertySplitCity Nvarchar(255);

Update Nashville_Housing.dbo.Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


select *
from Nashville_Housing.dbo.Nashville




select OwnerAddress
from Nashville_Housing.dbo.Nashville



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from Nashville_Housing.dbo.Nashville




ALTER TABLE Nashville_Housing.dbo.Nashville
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_Housing.dbo.Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE Nashville_Housing.dbo.Nashville
Add OwnerSplitCity Nvarchar(255);

Update Nashville_Housing.dbo.Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE Nashville_Housing.dbo.Nashville
Add OwnerSplitState Nvarchar(255);

Update Nashville_Housing.dbo.Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


select *
from Nashville_Housing.dbo.Nashville

----------------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Nashville_Housing.dbo.Nashville
Group by SoldAsVacant




select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
from Nashville_Housing.dbo.Nashville


Update Nashville_Housing.dbo.Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END


---------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num

					 
from Nashville_Housing.dbo.Nashville
--order by ParcelID
)
DELETE
From RowNumCTE
where row_num > 1
--order by PropertyAddress


Select *
from Nashville_Housing.dbo.Nashville


---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns


Select *
from Nashville_Housing.dbo.Nashville


ALTER TABLE Nashville_Housing.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Nashville_Housing.dbo.Nashville
DROP COLUMN SaleDate