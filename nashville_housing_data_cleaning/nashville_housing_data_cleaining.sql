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
SELECT PropertyAddress FROM [dbo].[NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) AS Address
FROM [dbo].[NashvilleHousing]








-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------
-------------------------------------------------------------Populate Propert Address data-----------------------------------------------------------------------