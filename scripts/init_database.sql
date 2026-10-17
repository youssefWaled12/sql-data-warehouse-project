
use master;
DROP DATABASE IF EXISTS DataWarehouse;
GO
create DATABASE DataWarehouse;
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
