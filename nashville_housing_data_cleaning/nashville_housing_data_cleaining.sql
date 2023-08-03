/****** Script from SSMS  ******/

/*
 Cleaning Data in SQL Queries
*/

SELECT * FROM [dbo].[NashvilleHousing]

--------------------------------------------------------------Standardize Date Format---------------------------------------------------------------------------
SELECT SaleDate FROM [dbo].[NashvilleHousing]

ALTER TABLE [dbo].[NashvilleHousing]
ALTER COLUMN SaleDate Date;

-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
SELECT * FROM [dbo].[NashvilleHousing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT A.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

SELECT PropertyAddress FROM [dbo].[NashvilleHousing]
WHERE PropertyAddress IS NULL

-------------------------------------------------------------Breaking out Address into Individual Colummns (Address, City, State---------------------------------
--PopertyAddress
SELECT PropertyAddress FROM [dbo].[NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) AS Address, --CHARINDEX gives position number for the comma. subtract 1 from it to exclude comma
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM [dbo].[NashvilleHousing]

-- create two cloumns and update
ALTER TABLE [dbo].[NashvilleHousing] ADD PropertyAddressSplit NVARCHAR(255)
ALTER TABLE [dbo].[NashvilleHousing] ADD PropertyCitySplit NVARCHAR(255)

UPDATE [dbo].[NashvilleHousing]
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)

UPDATE [dbo].[NashvilleHousing]
SET PropertyCitySplit  =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


SELECT * FROM [dbo].[NashvilleHousing]


--Owner Address
SELECT OwnerAddress FROM [dbo].[NashvilleHousing]

--PARSENAME() looks for a period, replace comma with period to work with PARSENAME()

SELECT REPLACE(OwnerAddress,',','.')
FROM [dbo].[NashvilleHousing]

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [dbo].[NashvilleHousing]

--Add columns and update
ALTER TABLE [dbo].[NashvilleHousing] ADD OwnerAddressSplit NVARCHAR(255)
ALTER TABLE [dbo].[NashvilleHousing] ADD OwnerCitySplit NVARCHAR(255)
ALTER TABLE [dbo].[NashvilleHousing] ADD OwnerStateSplit NVARCHAR(255)

UPDATE [dbo].[NashvilleHousing]
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

UPDATE [dbo].[NashvilleHousing]
SET [OwnerCitySplit] = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

UPDATE [dbo].[NashvilleHousing]
SET [OwnerStateSplit] = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT [OwnerAddressSplit], [OwnerCitySplit], [OwnerStateSplit]  FROM [dbo].[NashvilleHousing]

-------------------------------------------------------------Change Y to YES and N to No in SoldasVacant column--------------------------------------------------
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM [dbo].[NashvilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

--USE CASE STATEMENT
SELECT [SoldAsVacant],
	CASE
		WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
		WHEN [SoldAsVacant] = 'N' THEN 'No'
		ELSE [SoldAsVacant]
	END
FROM [dbo].[NashvilleHousing]

UPDATE [dbo].[NashvilleHousing]
SET SoldAsVacant = CASE
						WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
						WHEN [SoldAsVacant] = 'N' THEN 'No'
						ELSE [SoldAsVacant]
					END


-------------------------------------------------------------Remove Duplicates----------------------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address d ata-----------------------------------------------------------------------