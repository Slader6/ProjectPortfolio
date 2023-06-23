/*

Cleaning Data in SQL Queries

*/

--------------------------------------------------------------------------------------------------------------------------
---- Standardize Date Format
SELECT SaleDateConverted, CONVERT(DATE,SaleDate)
FROM ProjectPortfolio.dbo.NashvilleHousing;

-- Updating the Date Format
UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate);

-- Checking if Date Format is updated
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing;



 --------------------------------------------------------------------------------------------------------------------------
---- Populate Property Address data
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM ProjectPortfolio.dbo.NashvilleHousing a
JOIN ProjectPortfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM ProjectPortfolio.dbo.NashvilleHousing a
JOIN ProjectPortfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

-- Checking
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing ORDER BY ParcelID;



--------------------------------------------------------------------------------------------------------------------------
---- Breaking out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress FROM ProjectPortfolio.dbo.NashvilleHousing;


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM ProjectPortfolio.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

-- Checking
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing;


-- Another way to add and replace the dataset
SELECT OwnerAddress
FROM ProjectPortfolio.dbo.NashvilleHousing;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM ProjectPortfolio.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Checking
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing;



--------------------------------------------------------------------------------------------------------------------------
---- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS Vacant_Solds
FROM ProjectPortfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM ProjectPortfolio.dbo.NashvilleHousing;


UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM ProjectPortfolio.dbo.NashvilleHousing;

-- Checking
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing;



-----------------------------------------------------------------------------------------------------------------------------------------------------------
---- Remove Duplicates
-- Checking the Duplicates
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY UniqueID) row_num
	FROM ProjectPortfolio.dbo.NashvilleHousing)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

-- Removing the Duplicates
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY UniqueID) AS row_num
	FROM ProjectPortfolio.dbo.NashvilleHousing)
DELETE
FROM RowNumCTE
WHERE row_num > 1;

-- Checking
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing;



---------------------------------------------------------------------------------------------------------
---- Delete Unused Columns
ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

-- Checking
SELECT * FROM ProjectPortfolio.dbo.NashvilleHousing;



---------------------------------------------------------------------------------------------------------




















