/*
==================================
Create Databse and Schema
==================================
Script purpose :
This script creates a new database named 'DataWarehouse' aafter checking if it already exists.
  If the databse exist , it is dropped and recreated. Additionally , the script sets up three schemas within the database 
:'bronz','silver',and 'gold'.

  WARNING:
Running the script will drop the entire 'DataWarehouse' databse if it exists .
  ALL data in the database will permanently deleted. Proceed with caution and ensure you have proper backup before 
running this script
*/
USE master;

GO 
--Drop and recreate the 'Datawarehouse' datbase 
IF EXISTS (SELECT 1 FROM sys.database WHERE name='DataWarehouse')
BEGIN 
      ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;

GO
--Create the 'DataWarehouse ' database
CREATE DATABASE DataWarehouse ;
GO

USE DataWarehouse;
GO

--Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

