--Integrantes
--Santiago Sepúlveda Montoya
--Santiago Adolfo Yepes Zuleta


select * from [Sales].[Orders]
--Punto 1
select top(1) OrderDate, count(OrderDate) as total from [Sales].[Orders] 
Group by OrderDate 
order by total desc

--Punto 2
select SupplierID from [Purchasing].[Suppliers] where SupplierName='Litware, Inc.'
select SupplierID, StockItemID, StockItemName from [Warehouse].[StockItems] where SupplierID=(select SupplierID from [Purchasing].[Suppliers] where SupplierName='Litware, Inc.')

--Punto 3
select StockItemID, StockItemName, UnitPrice from [Warehouse].[StockItems] WHERE UnitPrice>(
select avg(UnitPrice) from [Warehouse].[StockItems]) order by UnitPrice 

--Punto 4
select UnitPrice+(UnitPrice*0.45) from [Warehouse].[StockItems]

select StockItemID, StockItemName,UnitPrice, RecommendedRetailPrice from [Warehouse].[StockItems] 
WHERE (RecommendedRetailPrice>(UnitPrice+(UnitPrice*0.45)))


--Punto 5
select PurchaseOrderID, sum(OrderedOuters*ExpectedUnitPricePerOuter) as Total from [Purchasing].[PurchaseOrderLines]
group by PurchaseOrderID
order by PurchaseOrderID

	select StockItemID, StockItems.ColorID, ColorName, UnitPrice
	from [Warehouse].[StockItems] join [Warehouse].[Colors] on StockItems.ColorID=Colors.ColorID 
	where ColorName='Blue' 

--Punto 6
BEGIN TRAN
	select StockItemID, StockItems.ColorID, ColorName, UnitPrice
	from [Warehouse].[StockItems] join [Warehouse].[Colors] on StockItems.ColorID=Colors.ColorID 
	where ColorName='Blue' 
	order by StockItemID

	Update [Warehouse].[StockItems] set UnitPrice = (UnitPrice+(UnitPrice*0.5)) 
	where  ColorID = (select top(1) StockItems.ColorID 
	from [Warehouse].[StockItems] join [Warehouse].[Colors] on StockItems.ColorID=Colors.ColorID 
	where ColorName='Blue') 

	select StockItemID, StockItems.ColorID, ColorName, UnitPrice
	from [Warehouse].[StockItems] join [Warehouse].[Colors] on StockItems.ColorID=Colors.ColorID 
	where ColorName='Blue'
	order by StockItemID
	Rollback



--Punto 7
BEGIN TRAN
	select * from [Sales].[OrderLines] join 
	(select Orders.CustomerID as MadhuId,OrderID from [Sales].[Orders] where CustomerID = (select top(1) Customers.CustomerID 
	from [Sales].[Customers] join [Sales].[Orders] 
	on Orders.CustomerID = Customers.CustomerID where CustomerName = 'Madhu Dwivedi')) as MahduTable 
	on OrderLines.OrderID = MahduTable.MadhuId

	Update [Sales].[OrderLines] set UnitPrice = (UnitPrice-(UnitPrice*0.22)) from [Sales].[OrderLines] join 
	(select Orders.CustomerID as MadhuId,OrderID from [Sales].[Orders] where CustomerID = (select top(1) Customers.CustomerID 
	from [Sales].[Customers] join [Sales].[Orders] 
	on Orders.CustomerID = Customers.CustomerID where CustomerName = 'Madhu Dwivedi')) as MahduTable 
	on OrderLines.OrderID = MahduTable.MadhuId

	select * from [Sales].[OrderLines] join 
	(select Orders.CustomerID as MadhuId,OrderID from [Sales].[Orders] where CustomerID = (select top(1) Customers.CustomerID 
	from [Sales].[Customers] join [Sales].[Orders] 
	on Orders.CustomerID = Customers.CustomerID where CustomerName = 'Madhu Dwivedi')) as MahduTable 
	on OrderLines.OrderID = MahduTable.MadhuId
	ROLLBACK


--Punto 8
delete from [Sales].[Customers] where BuyingGroupID = (select top(1) Customers.BuyingGroupID from [Sales].[Customers] 
	join [Sales].[BuyingGroups] on Customers.BuyingGroupID = BuyingGroups.BuyingGroupID 
	where BuyingGroups.BuyingGroupName = 'Wingtip Toys')

--Punto 9
BEGIN TRAN 
	select UnitPackageID, StockItems.StockItemID,StockItemName, QuantityOnHand from [Warehouse].[StockItems] join [Warehouse].[StockItemHoldings] 
		on StockItems.StockItemID = StockItemHoldings.StockItemID where StockItemName LIKE 'C%' 
		AND UnitPackageID = (select top(1) UnitPackageID from [Warehouse].[StockItems] join [Warehouse].[PackageTypes] on 
		UnitPackageID = PackageTypeID where PackageTypeName <> 'Bag') 

	Update [Warehouse].[StockItemHoldings] SET QuantityOnHand = QuantityOnHand+1000 FROM
		[Warehouse].[StockItemHoldings] join [Warehouse].[StockItems] 
		on StockItems.StockItemID = StockItemHoldings.StockItemID where StockItemName LIKE 'C%' 
		AND UnitPackageID = (select top(1) UnitPackageID from [Warehouse].[StockItems] join [Warehouse].[PackageTypes] on 
		UnitPackageID = PackageTypeID where PackageTypeName <> 'Bag')


	select UnitPackageID, StockItems.StockItemID,StockItemName, QuantityOnHand from [Warehouse].[StockItems] join [Warehouse].[StockItemHoldings] 
		on StockItems.StockItemID = StockItemHoldings.StockItemID where StockItemName LIKE 'C%' 
		AND UnitPackageID = (select top(1) UnitPackageID from [Warehouse].[StockItems] join [Warehouse].[PackageTypes] on 
		UnitPackageID = PackageTypeID where PackageTypeName <> 'Bag') 
	ROLLBACK

--Punto 10
Select CountryName, count(Countries.CountryID) as Total from [Application].[Countries] 
	Join [Application].[StateProvinces] on Countries.CountryID = StateProvinces.CountryID
	join [Application].[Cities] on StateProvinces.StateProvinceID = Cities.StateProvinceID 
	join [Sales].[Customers] on Customers.DeliveryCityID = Cities.CityID
	GROUP BY CountryName
	HAVING count(Countries.CountryID)>12
	ORDER BY Total desc
