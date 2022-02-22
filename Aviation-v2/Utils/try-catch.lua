--// This is the `Try and Catch` Module by Frieda_VI \\--
--// This is meant to resemble the C# version of Try and Catch \\--

--// More info on how to use this util: https://github.com/Frieda-VI/try-catch

local ExceptionHandler = {}
ExceptionHandler.__index = ExceptionHandler

--// Catch Operation \\--
function Catch(Error, Function)
	--// Provides the Error to the Function \\--
	--// Side note, the function should NOT contain an error function, else it will be flagged by the Main Handler \\--

	Function(Error)
end

--// Try And Catch Handler Functions \\--
ExceptionHandler.Try = function(FunctionArray: table)
	--[[ Return Boolean Meanings :
        true = Error was processed,
        false = Error wasn't processed
    ]]
	--

	--// Checking Values Passed \\--
	assert(
		type(FunctionArray[1]) == "function",
		"The First Element Is Not Of Type ::function::! \n\nType Of Element[1]! `" .. typeof(FunctionArray[1]) .. "`"
	)

	--// This function will executed until an exception `error` is thrown or it is completed successfully \\--

	--// Attempting to run the function provided \\--
	--// Returning The PCALl results \\--
	local Function = FunctionArray[1]
	local Success, Error = pcall(Function)

	if Success then
		--// The opperation was successful \\--
		return true
	elseif not Success and typeof(FunctionArray.Catch) == "function" then
		--// Correctly Handles The Error \\--
		--// Why not XPcall? This promotes yielding but XPcall doesn't. \\--

		--// Returns false if the Catch function met an Error while processing \\--
		local ProcessError, CodeError = pcall(Catch, Error, FunctionArray.Catch)

		if ProcessError == false then
			--// Flagging the Error which took place in the Catch Method \\--
			warn("Function returned an Error, \n\n" .. tostring(CodeError))
		end
		return ProcessError
	else
		--// Warns the Error as no Error handler were provided \\--
		warn("Unable to Handle Error, \n\n" .. tostring(Error))
		return false
	end
end

return ExceptionHandler
