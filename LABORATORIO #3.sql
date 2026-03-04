--PROBLEMA #1
--Insertar en una tabla temporal las órdenes que su monto total sea mayor
--a 90 con el CustumerID,OrderID y orderTotal, estos registros deben ser
--evaluados uno a uno haciendo uso de los cursores y un bucle while para
--iterarlos y además se debe tomar en cuenta los siguientes aspectos:

-- Inicio de la tranasacción y la tabla temporal 
 Begin Try

			DECLARE  @TempOrders TABLE(
					CustumerID VARCHAR(5),
					OrderID INT, 
					OrderTotal INT,
					Country NVARCHAR(15)
			)
	-- Declarar las variable axiliares del cursor para iterar las ordenes

			DECLARE @CustomerID VARCHAR(5), 
					@OrderID INT, @OrderTotal INT, 
					@Country NVARCHAR(15),
					@TipoPremio VARCHAR(1)

	-- Insertat en la tabla temporal los datos de las órdenes que el monto sea > 90

			INSERT INTO @TempOrders (CustumerID, OrderID, OrderTotal,Country)
			SELECT C.CustomerID, O.OrderID, SUM(OD.Quantity * OD.UnitPrice) AS OrderTotal, Country
			From Orders O
			INNER JOIN [Order Details] OD ON  O.OrderID = OD.OrderID
			INNER JOIN Customers C ON C.CustomerID = O.CustomerID
			GROUP BY C.CustomerID, O.OrderID, C.Country
			HAVING SUM(OD.Quantity * OD.UnitPrice) > 90
			ORDER BY C.CustomerID ASC

	-------------------CURSOS----------------------

		-- Declarar el cursor para recorrer las ordenes que cumplen la condicion

			DECLARE CursorOrdenes CURSOR FOR
			SELECT CustumerID, OrderID, OrderTotal,Country FROM @TempOrders
		-- Abrios el cursor
			OPEN CursorOrdenes 

		--Optener registro linea por linea 
			FETCH NEXT FROM CursorOrdenes
			INTO @CustomerID, @OrderID, @OrderTotal, @Country

		-- Bucle Para recorrer cada registro del cursor
			While @@FETCH_STATUS = 0

	  Begin  
			Begin TRAN
			Begin Try	 

		---- Tipos de premios-----
		IF @Country = 'Sweden'
			  BEGIN
				SET @TipoPremio = 'N'--Normal
			  End
		      Else if @Country = 'México'
			  BEGIN
				SET @TipoPremio = 'P'--Premium
		      END


		 Else
		 BEGIN
			   IF @OrderTotal between 90 and 100
				 BEGIN
				  SET @TipoPremio = 'B'-- Básico
				 End
			  Else if @OrderTotal between 101 and 120
				BEGIN
				  SET @TipoPremio = 'N'--Normal
				End
			  Else if @OrderTotal > 120
			   BEGIN
				  SET @TipoPremio = 'P' --Premium
			   END
		 END

			  Insert into [dbo].[GifCustomer](CustomerID, Fecha, Monto, TipoPremio)
			  Values(@CustomerID, Getdate(), @OrderTotal, @TipoPremio)
			  COMMIT
	END Try 

		  -- Si ocurre un erro, hacemo el Rollback de la transaccion.
		   Begin catch 
				Rollback
				 Print 'ERROR EN LA TRANSACCION' + ERROR_MESSAGE()
				END catch

		 -- Siguiente linea del cursor 
			FETCH NEXT FROM CursorOrdenes
			INTO @CustomerID, @OrderID, @OrderTotal, @Country

	
	END

	CLOSE CursorOrdenes 
	DEALLOCATE CursorOrdenes 


---- Si ocurre un erro General lo atrapamos,
END Try 
Begin catch 
	Print 'ERROR GENERAL' + ERROR_MESSAGE()
END catch
	


--• Si el monto total de la orden está entre 90 y menor o igual a 100, el tipo
--de regalo es básico"B".
--• Si el monto total de la orden es mayor a 100 y menor o igual a 120, el
--tipo de regalo es normal "N".
--• Si el monto total de la orden es mayor a 120, el tipo de regalo es
--Premium "P".
--• Si el país del cliente es "Sweden" el tipo de premio es normal "N" sin
--Importar el monto total, simplemente debe respetar que la orden sea
--mayor a 90.
--• Si el país del cliente es "México", el tipo de regalo es Premium "P" sin
--Importar el monto total, simplemente debe respetar que la orden sea
--mayor a 90.

--Los puntos anteriores deben ser considerados para insertarse en la
--tabla de [dbo].[GifCustomer] un registro por iteración del bucle, sin incumplir en
--las restricciones anteriores, esta tabla permite almacenar los clientes que serán
--premiados por sus buenas compras en el futuro.
--Para la implementación del script se debe hacer uso del manejo de las
--transacciones para garantizar una correcta manipulación de la información en la
--base de datos, además de un buen manejo de errores controlados, y en caso
--de ocurrir mostrarlo en la consola.
--Como último aspecto, el estudiante debe comentar de manera breve que
--realiza cada línea de código en el script para garantizar su comprensión total de
--la implementación.
--Queda a criterio del estudiante el análisis y lógica que desarrolle para
--resolverlos, además de las variables y bloques de control que pueda utilizar
--para resolver el problema.
