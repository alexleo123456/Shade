#tag Class
Protected Class SPIRVVirtualMachine
	#tag Method, Flags = &h0
		Sub Clear()
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  AddressingModel = 2 // Phyical64
		  Bound = 0
		  Constants = new Dictionary()
		  Redim Decorations(-1)
		  EntryPoints = new Dictionary()
		  Redim Errors(-1)
		  Functions = new Dictionary()
		  GeneratorMagicNumber = 0
		  MemoryModel = 0 // Simple
		  Names = new Dictionary()
		  OpcodeLookup = new Dictionary()
		  Redim Opcodes(-1)
		  SourceLanguage = 0 // Unknown
		  SourceVersion = 0
		  Types = new Dictionary()
		  Version = 99
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadModule(binary As MemoryBlock)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  Dim ip As UInt32
		  Dim moduleUB As Integer
		  Dim tempIP As UInt32
		  Dim ub As UInt32
		  Dim ep As ZocleeShade.SPIRVEntryPoint
		  Dim dec As ZocleeShade.SPIRVDecoration
		  Dim typ As ZocleeShade.SPIRVType
		  Dim op As ZocleeShade.SPIRVOpcode
		  Dim cnst As ZocleeShade.SPIRVConstant
		  
		  Clear()
		  
		  if binary <> nil then
		    
		    ModuleBinary = binary
		    
		    // test magic number
		    
		    if ModuleBinary.UInt32Value(0) <> &h07230203 then
		      
		      Errors.Append "Invalid magic number."
		      
		    else
		      
		      Version = ModuleBinary.UInt32Value(4)
		      GeneratorMagicNumber = ModuleBinary.UInt32Value(8)
		      Bound = ModuleBinary.UInt32Value(12)
		      moduleUB = ModuleBinary.Size - 1
		      
		      //  instructions
		      
		      ip = 20
		      while ip < moduleUB
		        
		        select case ModuleBinary.UInt16Value(ip)
		          
		        case 0 // ***** OpNop ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpNop)
		          
		        case 1 // ***** OpSource ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSource)
		          SourceLanguage = ModuleBinary.UInt32Value(ip + 4)
		          SourceVersion = ModuleBinary.UInt32Value(ip + 8)
		          
		        case 2 // ***** OpSourceExtension ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSourceExtension)
		          
		        case 3 // ***** OpExtension ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpExtension)
		          
		        case 4 // ***** OpExtInstImport ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpExtInstImport)
		          
		        case 5 // ***** OpMemoryModel ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpMemoryModel)
		          AddressingModel = ModuleBinary.UInt32Value(ip + 4)
		          MemoryModel = ModuleBinary.UInt32Value(ip + 8)
		          
		        case 6 // ***** OpEntryPoint ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpEntryPoint)
		          ep = new ZocleeShade.SPIRVEntryPoint
		          ep.ExecutionModel = ModuleBinary.UInt32Value(ip + 4)
		          ep.EntryPointID = ModuleBinary.UInt32Value(ip + 8)
		          EntryPoints.Value(ep.EntryPointID) = ep
		          
		        case 7 // ***** OpExecutionMode ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpExecutionMode)
		          
		        case 8 // ***** OpTypeVoid ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeVoid)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Void
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 9 // ***** OpTypeBool ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeBool)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Boolean
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 10 // ***** OpTypeInt ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeInt)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Integer
		          typ.Width = ModuleBinary.UInt32Value(ip + 8)
		          if ModuleBinary.UInt32Value(ip + 12) = 0 then
		            typ.Signed = false
		          else
		            typ.Signed = true
		          end if
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 11 // ***** OpTypeFloat ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeFloat)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Float
		          typ.Width = ModuleBinary.UInt32Value(ip + 8)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 12 // ***** OpTypeVector ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeVector)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Vector
		          typ.ComponentTypeID = ModuleBinary.UInt32Value(ip + 8)
		          typ.ComponentCount = ModuleBinary.UInt32Value(ip + 12)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 13 // ***** OpTypeMatrix ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeMatrix)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Matrix
		          typ.ColumnTypeID = ModuleBinary.UInt32Value(ip + 8)
		          typ.ColumnCount = ModuleBinary.UInt32Value(ip + 12)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 14 // ***** OpTypeSampler ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeSampler)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Sampler
		          typ.SampledTypeID = ModuleBinary.UInt32Value(ip + 8)
		          typ.Dimensionality = ModuleBinary.UInt32Value(ip + 12)
		          typ.Content = ModuleBinary.UInt32Value(ip + 16)
		          typ.Arrayed = ModuleBinary.UInt32Value(ip + 20)
		          typ.Compare = ModuleBinary.UInt32Value(ip + 24)
		          typ.Multisampled = ModuleBinary.UInt32Value(ip + 28)
		          if ModuleBinary.UInt16Value(ip + 2) >= 9 then
		            typ.AccessQualifier = ModuleBinary.UInt32Value(ip + 32)
		          else
		            typ.AccessQualifier = 0
		          end if
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 15 // ***** OpTypeFilter ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeFilter)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Filter
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 16 // ***** OpTypeArray ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeArray)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Array_
		          typ.ElementTypeID = ModuleBinary.UInt32Value(ip + 8)
		          typ.Length = ModuleBinary.UInt32Value(ip + 12)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 17 // ***** OpTypeRuntimeArray ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeRuntimeArray)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.RuntimeArray
		          typ.ElementTypeID = ModuleBinary.UInt32Value(ip + 8)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 18 // ***** OpTypeStruct ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeStruct)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Struct
		          tempIP = ip + 8
		          ub = ip + (ModuleBinary.UInt16Value(ip + 2) * 4)
		          while tempIP < ub
		            typ.MemberTypeID.Append ModuleBinary.UInt32Value(tempIP)
		            tempIP = tempIP + 4
		          wend
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 19 // ***** OpTypeOpaque ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeOpaque)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Opaque
		          typ.Name = ModuleBinary.CString(ip + 8)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 20 // ***** OpTypePointer ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypePointer)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Pointer
		          typ.StorageClass = ModuleBinary.UInt32Value(ip + 8)
		          typ.TypeID = ModuleBinary.UInt32Value(ip + 12)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 21 // ***** OpTypeFunction ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeFunction)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Function_
		          typ.ReturnTypeID = ModuleBinary.UInt32Value(ip + 8)
		          tempIP = ip + 12
		          ub = ip + (ModuleBinary.UInt16Value(ip + 2) * 4)
		          while tempIP < ub
		            typ.ParmTypeID.Append ModuleBinary.UInt32Value(tempIP)
		            tempIP = tempIP + 4
		          wend
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 22 // ***** OpTypeEvent ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeEvent)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Event_
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 23 // ***** OpTypeDeviceEvent ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeDeviceEvent)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.DeviceEvent
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 24 // ***** OpTypeReserveId ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeReserveId)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.ReservedId
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 25 // ***** OpTypeQueue ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypeQueue)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Queue
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 26 // ***** OpTypePipe ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTypePipe)
		          typ = new ZocleeShade.SPIRVType(self, ModuleBinary.UInt32Value(ip + 4))
		          typ.Type = SPIRVTypeEnum.Pipe
		          typ.DataTypeID = ModuleBinary.UInt32Value(ip + 8)
		          typ.AccessQualifier = ModuleBinary.UInt32Value(ip + 12)
		          Types.Value(ModuleBinary.UInt32Value(ip + 4)) = typ
		          
		        case 27 // ***** OpConstantTrue ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstantTrue)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.BooleanTrue
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 28 // ***** OpConstantFalse ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstantFalse)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.BooleanFalse
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 29 // ***** OpConstant ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstant)
		          
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.Constant
		          if Types.HasKey(ModuleBinary.UInt32Value(ip + 4)) then
		            typ = Types.Value(ModuleBinary.UInt32Value(ip + 4))
		            select case typ.Type
		            case SPIRVTypeEnum.Float
		              cnst.Type = SPIRVConstantType.Float
		            case SPIRVTypeEnum.Integer
		              cnst.Type = SPIRVConstantType.Integer
		            end select
		          end if
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 30 // ***** OpConstantComposite ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstantComposite)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.Composite
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          tempIP = ip + 12
		          ub = ip + (ModuleBinary.UInt16Value(ip + 2) * 4)
		          while tempIP < ub
		            cnst.Constituents.Append ModuleBinary.UInt32Value(tempIP)
		            tempIP = tempIP + 4
		          wend
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 31 // ***** OpConstantSampler ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstantSampler)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          cnst.Mode = ModuleBinary.UInt32Value(ip + 12)
		          cnst.Param = ModuleBinary.UInt32Value(ip + 16)
		          cnst.Filter = ModuleBinary.UInt32Value(ip + 20)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 32 // ***** OpConstantNullPointer ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstantNullPointer)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.NullPointer
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 33 // ***** OpConstantNullObject ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConstantNullObject)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.NullObject
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 34 // ***** OpSpecConstantTrue ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSpecConstantTrue)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.SpecBooleanTrue
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 35 // ***** OpSpecConstantFalse ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSpecConstantFalse)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.SpecBooleanFalse
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 36 // ***** OpSpecConstant ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSpecConstant)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.SpecConstant
		          if Types.HasKey(ModuleBinary.UInt32Value(ip + 4)) then
		            typ = Types.Value(ModuleBinary.UInt32Value(ip + 4))
		            select case typ.Type
		            case SPIRVTypeEnum.Float
		              cnst.Type = SPIRVConstantType.Float
		            case SPIRVTypeEnum.Integer
		              cnst.Type = SPIRVConstantType.Integer
		            end select
		          end if
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 37 // ***** OpSpecConstantComposite ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSpecConstantComposite)
		          cnst = new ZocleeShade.SPIRVConstant
		          cnst.Type = SPIRVConstantType.SpecComposite
		          cnst.ResultID = ModuleBinary.UInt32Value(ip + 8)
		          cnst.ResultTypeID = ModuleBinary.UInt32Value(ip + 4)
		          tempIP = ip + 12
		          ub = ip + (ModuleBinary.UInt16Value(ip + 2) * 4)
		          while tempIP < ub
		            cnst.Constituents.Append ModuleBinary.UInt32Value(tempIP)
		            tempIP = tempIP + 4
		          wend
		          Constants.Value(cnst.ResultID) = cnst
		          
		        case 38 // ***** OpVariable ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpVariable)
		          
		        case 39 // ***** OpVariableArray ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpVariableArray)
		          
		        case 40 // ***** OpFunction ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFunction)
		          Functions.Value(ModuleBinary.UInt32Value(ip + 8)) = op
		          
		        case 41 // ***** OpFunctionParameter ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFunctionParameter)
		          
		        case 42 // ***** OpFunctionEnd ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFunctionEnd)
		          
		        case 43 // ***** OpFunctionCall ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFunctionCall)
		          
		        case 44 // ***** OpExtInst ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpExtInst)
		          
		        case 45 // ***** OpUndef ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpUndef)
		          
		        case 46 // ***** OpLoad ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpLoad)
		          
		        case 47 // ***** OpStore ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpStore)
		          
		        case 48 // ***** OpPhi ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpPhi)
		          
		        case 49 // ***** OpDecorationGroup ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpDecorationGroup)
		          
		        case 50 // ***** OpDecorate ***************************************************
		          
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpDecorate)
		          dec = new ZocleeShade.SPIRVDecoration
		          dec.TargetID = ModuleBinary.UInt32Value(ip + 4)
		          dec.Decoration = ModuleBinary.UInt32Value(ip + 8)
		          select case dec.Decoration
		            ' Stream, Location, Component, Index, Binding, DescriptorSet, Offset, Alignment, XfbBuffer, Stride,
		            ' Built-In, FuncParamAttr, FP Rouding Mode, FP Fast Math Mode, Linkage Type, SpecId
		          case 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44
		            tempIP = ip + 12
		            ub = ip + (ModuleBinary.UInt16Value(ip + 2) * 4)
		            while tempIP < ub
		              dec.ExtraOperands.Append ModuleBinary.UInt32Value(tempIP)
		              tempIP = tempIP + 4
		            wend
		          end select
		          Decorations.Append dec
		          
		        case 51 // ***** OpMemberDecorate ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpMemberDecorate)
		          
		        case 52 // ***** OpGroupDecorate ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpGroupDecorate)
		          
		        case 53 // ***** OpGroupMemberDecorate ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpGroupMemberDecorate)
		          
		        case 54 // ***** OpName ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpName)
		          Names.Value(ModuleBinary.UInt32Value(ip + 4)) = ModuleBinary.CString(ip + 8)
		          
		        case 55 // ***** OpMemberName ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpMemberName)
		          
		        case 56 // ***** OpString ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpString)
		          
		        case 57 // ***** OpLine ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpLine)
		          
		        case 58 // ***** OpVectorExtractDynamic ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpVectorExtractDynamic)
		          
		        case 59 // ***** OpVectorInsertDynamic ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpVectorInsertDynamic)
		          
		        case 60 // ***** OpVectorShuffle ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpVectorShuffle)
		          
		        case 61 // ***** OpCompositeConstruct ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpCompositeConstruct)
		          
		        case 62 // ***** OpCompositeExtract ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpCompositeExtract)
		          
		        case 63 // ***** OpCompositeInsert ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpCompositeInsert)
		          
		        case 64 // ***** OpCopyObject ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpCopyObject)
		          
		        case 65 // ***** OpCopyMemory ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpCopyMemory)
		          
		        case 66 // ***** OpCopyMemorySized ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpCopyMemorySized)
		          
		        case 67 // ***** OpSampler ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSampler)
		          
		        case 68 // ***** OpTextureSample ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSample)
		          
		        case 69 // ***** OpTextureSampleDref ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleDref)
		          
		        case 70 // ***** OpTextureSampleLod ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleLod)
		          
		        case 71 // ***** OpTextureSampleProj ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleProj)
		          
		        case 72 // ***** OpTextureSampleGrad ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleGrad)
		          
		        case 73 // ***** OpTextureSampleOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleOffset)
		          
		        case 74 // ***** OpTextureSampleProjGrad ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleProjGrad)
		          
		        case 75 // ***** OpTextureSampleProjLod ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleProjLod)
		          
		        case 76 // ***** OpTextureSampleLodOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleLodOffset)
		          
		        case 77 // ***** OpTextureSampleProjOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleProjOffset)
		          
		        case 78 // ***** OpTextureSampleGradOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleGradOffset)
		          
		        case 79 // ***** OpTextureSampleProjLodOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleProjLodOffset)
		          
		        case 80 // ***** OpTextureSampleProjGradOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureSampleProjGradOffset)
		          
		        case 81 // ***** OpTextureFetchTexel ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureFetchTexel)
		          
		        case 82 // ***** OpTextureFetchTexelOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureFetchTexelOffset)
		          
		        case 83 // ***** OpTextureFetchSample ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureFetchSample)
		          
		        case 84 // ***** OpTextureFetchBuffer ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureFetchBuffer)
		          
		        case 85 // ***** OpTextureGather ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureGather)
		          
		        case 86 // ***** OpTextureGatherOffset ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureGatherOffset)
		          
		        case 87 // ***** OpTextureGatherOffsets ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureGatherOffsets)
		          
		        case 88 // ***** OpTextureQuerySizeLod ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureQuerySizeLod)
		          
		        case 89 // ***** OpTextureQuerySize ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureQuerySize)
		          
		        case 90 // ***** OpTextureQueryLod ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureQueryLod)
		          
		        case 91 // ***** OpTextureQueryLevels ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureQueryLevels)
		          
		        case 92 // ***** OpTextureQuerySamples ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpTextureQuerySamples)
		          
		        case 93 // ***** OpAccessChain ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpAccessChain)
		          
		        case 94 // ***** OpInBoundsAccessChain ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpInBoundsAccessChain)
		          
		        case 95 // ***** OpSNegate ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSNegate)
		          
		        case 96 // ***** OpFNegate ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFNegate)
		          
		        case 97 // ***** OpNot ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpNot)
		          
		        case 98 // ***** OpAny ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpAny)
		          
		        case 99 // ***** OpAll ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpAll)
		          
		        case 100 // ***** OpConvertFToU ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpConvertFToU)
		          
		        case 122 // ***** OpIAdd ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpIAdd)
		          
		        case 123 // ***** OpFAdd ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFAdd)
		          
		        case 124 // ***** OpISub ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpISub)
		          
		        case 125 // ***** OpFSub ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFSub)
		          
		        case 126 // ***** OpIMul ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpIMul)
		          
		        case 127 // ***** OpFMul ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpFMul)
		          
		        case 160 // ***** OpSLessThan ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSLessThan)
		          
		        case 206 // ***** OpLoopMerge ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpLoopMerge)
		          
		        case 207 // ***** OpSelectionMerge ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpSelectionMerge)
		          
		        case 208 // ***** OpLabel ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpLabel)
		          
		        case 209 // ***** OpBranch ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpBranch)
		          
		        case 210 // ***** OpBranchConditional ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpBranchConditional)
		          
		        case 213 // ***** OpReturn ***************************************************
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.OpReturn)
		          
		        case else
		          op = new ZocleeShade.SPIRVOpcode(self, SPIRVOpcodeTypeEnum.Unknown)
		          
		          Errors.Append ("ERROR [" + Str(ip) + "]: Unknown opcode.")
		          
		        end select
		        
		        // store opcode
		        
		        op.Offset = ip
		        Opcodes.Append op
		        
		        // check for duplicate result id, and store in lookup table if necessary
		        
		        if op.ResultID > 0 then
		          if OpcodeLookup.HasKey(op.ResultID) then
		            Errors.Append ("ERROR [" + Str(ip) + "]: Duplicate result ID.")
		          else
		            OpcodeLookup.Value(op.ResultID) = op
		          end if
		        end if
		        
		        if (ip + 2) >= ModuleBinary.Size then
		          Errors.Append ("ERROR [" + Str(ip) + "]: IP out of bounds.")
		          ip = moduleUB + 1
		          if Opcodes.Ubound >= 0 then
		            if OpcodeLookup.HasKey(Opcodes(Opcodes.Ubound).ResultID) then
		              OpcodeLookup.Remove(Opcodes(Opcodes.Ubound).ResultID)
		            end if
		            Opcodes.Remove(Opcodes.Ubound)
		          end if
		        elseif ModuleBinary.UInt16Value(ip + 2) = 0 then
		          Errors.Append ("ERROR [" + Str(ip) + "]: Word count of zero.")
		          ip = moduleUB + 1
		        else
		          ip = ip + (ModuleBinary.UInt16Value(ip + 2) * 4)
		        end if
		        
		      wend
		      
		      validateOpcodes()
		      
		    end if
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub logError(op As ZocleeShade.SPIRVOpcode, errMsg As String)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  Errors.Append "ERROR [" + Str(op.Offset) + "]: " + errMsg
		  op.HasErrors = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validateOpcodes()
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  Dim i As UInt32
		  Dim j As UInt32
		  Dim k As Integer
		  Dim ub As UInt32
		  Dim op As ZocleeShade.SPIRVOpcode
		  Dim typ As ZocleeShade.SPIRVType
		  
		  i = 0
		  while i <= Opcodes.Ubound
		    
		    op = Opcodes(i)
		    
		    select case op.Type
		      
		      ' ***** OpAccessChain ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpAccessChain
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Base ID out of bounds.", "Base ID not declared.")
		      
		      ' ***** OpAll ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpAll
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Vector ID out of bounds.", "Vector ID not declared.")
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        if typ.Type <> SPIRVTypeEnum.Boolean then
		          logError op, "Result Type must be a Boolean scalar type."
		        end if
		      end if
		      
		      ' ***** OpAny ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpAny
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Vector ID out of bounds.", "Vector ID not declared.")
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        if typ.Type <> SPIRVTypeEnum.Boolean then
		          logError op, "Result Type must be a Boolean scalar type."
		        end if
		      end if
		      
		      ' ***** OpBranch ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpBranch
		      validate_WordCountEqual(op, 2)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target Label ID out of bounds.", "Target Label ID not declared.")
		      
		      ' ***** OpBranchConditional ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpBranchConditional
		      validate_WordCountMinimum(op, 4)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Condition ID out of bounds.", "Condition ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 8), "True Label ID out of bounds.", "True Label ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "False Label ID out of bounds.", "False Label ID not declared.")
		      
		      ' ***** OpCompositeConstruct ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpCompositeConstruct
		      validate_WordCountMinimum(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Constituent " + Str(k) + " ID out of bounds.", "Constituent " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpCompositeExtract ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpCompositeExtract
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Composite ID out of bounds.", "Composite ID not declared.")
		      // todo: validate that result type id is the same type as the object selected by the last provided index
		      
		      ' ***** OpCompositeInsert ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpCompositeInsert
		      validate_WordCountMinimum(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Object ID out of bounds.", "Object ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Composite ID out of bounds.", "Composite ID not declared.")
		      
		      ' ***** OpConstant ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstant
		      validate_WordCountMinimum(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        select case typ.Type
		        case SPIRVTypeEnum.Float, SPIRVTypeEnum.Integer
		          // do nothing
		        case else
		          logError op, "Invalid constant type. Expected integer or float."
		        end select
		      end if
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      
		      ' ***** OpConstantComposite ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstantComposite
		      validate_WordCountMinimum(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Constituent " + Str(k) + " ID out of bounds.", "Constituent " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpConstantFalse ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstantFalse
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        if typ.Type <> SPIRVTypeEnum.Boolean then
		          logError op, "Expected scalar Boolean type."
		        end if
		      end if
		      
		      ' ***** OpConstantNullObject ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstantNullObject
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      
		      ' ***** OpConstantNullPointer ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstantNullPointer
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      
		      ' ***** OpConstantSampler ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstantSampler
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if (ModuleBinary.UInt32Value(op.Offset + 12) > 8) or (ModuleBinary.UInt32Value(op.Offset + 12) mod 2 <> 0) then
		        logError op, "Invalid Sampler Addressing Mode enumeration value."
		      end if
		      if (ModuleBinary.UInt32Value(op.Offset + 16) > 1) then
		        logError op, "Invalid Param enumeration value."
		      end if
		      if (ModuleBinary.UInt32Value(op.Offset + 20) <> 16) and (ModuleBinary.UInt32Value(op.Offset + 20) <> 32) then
		        logError op, "Invalid Sampler Filter Mode enumeration value."
		      end if
		      
		      ' ***** OpConstantTrue ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConstantTrue
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        if typ.Type <> SPIRVTypeEnum.Boolean then
		          logError op, "Expected scalar Boolean type."
		        end if
		      end if
		      
		      ' ***** OpConvertFToU ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpConvertFToU
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Float Value ID out of bounds.", "Float Value ID not declared.")
		      // todo: result type cannot be signed integer type
		      // todo: operand type and result type must have same number of components
		      
		      ' ***** OpCopyMemory ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpCopyMemory
		      validate_WordCountMinimum(op, 3)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target ID out of bounds.", "Target ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 8), "Source ID out of bounds.", "Source ID not declared.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      while j < ub
		        if (ModuleBinary.UInt32Value(j) < 1) or (ModuleBinary.UInt32Value(j) > 2) then
		          logError op, "Invalid Memory Access enumeration value."
		        end if
		        j = j + 4
		      wend
		      
		      ' ***** OpCopyMemorySized ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpCopyMemorySized
		      validate_WordCountMinimum(op, 4)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target ID out of bounds.", "Target ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 8), "Source ID out of bounds.", "Source ID not declared.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 16
		      while j < ub
		        if (ModuleBinary.UInt32Value(j) < 1) or (ModuleBinary.UInt32Value(j) > 2) then
		          logError op, "Invalid Memory Access enumeration value."
		        end if
		        j = j + 4
		      wend
		      
		      ' ***** OpCopyObject ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpCopyObject
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand ID out of bounds.", "Operand ID not declared.")
		      
		      ' ***** OpDecorate ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpDecorate
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target ID out of bounds.", "Target ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) > 44 then
		        logError op, "Invalid Decoration enumeration value."
		      end if
		      
		      select case ModuleBinary.UInt32Value(op.Offset + 8)
		      case 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 44
		        validate_WordCountEqual(op, 4)
		      case 39 // Built-In
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 12) > 41 then
		          logError op, "Invalid Built-In enumeration value."
		        end if
		      case 40 // Function Parameter Attribute
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 12) > 8 then
		          logError op, "Invalid Function Parameter Attribute enumeration value."
		        end if
		      case 41 // FP Rounding Mode
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 12) > 3 then
		          logError op, "Invalid FP Rounding Mode enumeration value."
		        end if
		      case 42 // FP Fast Math Mode
		        validate_WordCountEqual(op, 4)
		        break // todo
		      case 43 // Linkage Type
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 12) > 1 then
		          logError op, "Invalid Linkage Type enumeration value."
		        end if
		      case else
		        validate_WordCountEqual(op, 3)
		      end select
		      
		      ' ***** OpDecorationGroup ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpDecorationGroup
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpEntryPoint ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpEntryPoint
		      validate_WordCountEqual(op, 3)
		      if ModuleBinary.UInt32Value(op.Offset + 4) > 6 then
		        logError op, "Execution Model enumeration value."
		      end if
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 8), "Entry Point ID out of bounds.", "Entry Point ID not declared.")
		      
		      ' ***** OpExecutionMode ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpExecutionMode
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Entry Point ID out of bounds.", "Entry Point ID not declared.")
		      if not EntryPoints.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        logError op, "Entry Point not declared."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 8) > 30 then
		        logError op, "Invalid Execution Mode enumeration value."
		      end if
		      select case ModuleBinary.UInt32Value(op.Offset + 8)
		      case 0 // Invocations
		      case 16 // LocalSize
		        validate_WordCountEqual(op, 6)
		      case 17 // LocalSize
		        validate_WordCountEqual(op, 6)
		      case 25 // OutputVertices
		        validate_WordCountEqual(op, 4)
		      case 29 // VecTypeHint
		        validate_WordCountEqual(op, 4)
		      case else
		        validate_WordCountEqual(op, 3)
		      end select
		      
		      ' ***** OpExtension ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpExtension
		      validate_WordCountMinimum(op, 1)
		      if Trim(ModuleBinary.CString(op.Offset + 4)) = "" then
		        logError op, "Invalid name."
		      end if
		      
		      ' ***** OpExtInst ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpExtInst
		      validate_WordCountMinimum(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Set ID out of bounds.", "Set ID not declared.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 20
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Operand " + Str(k) + " ID out of bounds.", "Operand " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpExtInstImport ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpExtInstImport
		      validate_WordCountMinimum(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      if Trim(ModuleBinary.CString(op.Offset + 8)) = "" then
		        logError op, "Invalid name."
		      end if
		      
		      ' ***** OpFAdd ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFAdd
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpFMul ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFMul
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpFNegate ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFNegate
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand ID out of bounds.", "Operand ID not found.")
		      // todo: Result Type must be scalars or vectors of floatint-point types
		      
		      ' ***** OpFSub ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFSub
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpFunction ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFunction
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 15 then
		        logError op, "Invalid Function Control Mask value."
		      end if
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 16), "Function Type ID out of bounds.", "Function TypeID not declared.")
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 16)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 16))
		        if typ.ReturnTypeID <> ModuleBinary.UInt32Value(op.Offset + 4) then
		          logError op, "Result Type ID does not match Return Type ID in function declaration."
		        end if
		      end if
		      
		      ' ***** OpFunctionCall ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFunctionCall
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_functionId(op, ModuleBinary.UInt32Value(op.Offset + 12), "Function ID out of bounds.", "Function ID not declared.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 16
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Argument " + Str(k) + " ID out of bounds.", "Argument " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpFunctionEnd ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFunctionEnd
		      validate_WordCountEqual(op, 1)
		      
		      ' ***** OpFunctionParameter ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpFunctionParameter
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      
		      ' ***** OpGroupDecorate ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpGroupDecorate
		      validate_WordCountMinimum(op, 2)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Decoration Group ID out of bounds.", "Decoration Group ID not found.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 8
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Target " + Str(k) + " ID out of bounds.", "Target " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpGroupMemberDecorate ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpGroupMemberDecorate
		      validate_WordCountMinimum(op, 2)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Decoration Group ID out of bounds.", "Decoration Group ID not found.")
		      j = op.Offset + 8
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Target " + Str(k) + " ID out of bounds.", "Target " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpIAdd ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpIAdd
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpIMul ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpIMul
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpInBoundsAccessChain ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpInBoundsAccessChain
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Base ID out of bounds.", "Base ID not found.")
		      
		      ' ***** OpISub ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpISub
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpLabel ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpLabel
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpLine ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpLine
		      validate_WordCountEqual(op, 5)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target ID out of bounds.", "Target ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 8), "File ID out of bounds.", "File ID not found.")
		      
		      ' ***** OpLoad ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpLoad
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Pointer ID out of bounds.", "Pointer ID not found.")
		      
		      ' ***** OpLoopMerge ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpLoopMerge
		      validate_WordCountEqual(op, 3)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Label ID out of bounds.", "Label ID not found.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) > 2 then
		        logError op, "Invalid Loop Control enumeration value."
		      end if
		      
		      ' ***** OpMemberDecorate ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpMemberDecorate
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target ID out of bounds.", "Target ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 44 then
		        logError op, "Invalid Decoration enumeration value."
		      end if
		      
		      select case ModuleBinary.UInt32Value(op.Offset + 12)
		      case 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 44
		        validate_WordCountEqual(op, 4)
		      case 39 // Built-In
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 16) > 41 then
		          logError op, "Invalid Built-In enumeration value."
		        end if
		      case 40 // Function Parameter Attribute
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 16) > 8 then
		          logError op, "Invalid Function Parameter Attribute enumeration value."
		        end if
		      case 41 // FP Rounding Mode
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 16) > 3 then
		          logError op, "Invalid FP Rounding Mode enumeration value."
		        end if
		      case 42 // FP Fast Math Mode
		        validate_WordCountEqual(op, 4)
		        break // todo
		      case 43 // Linkage Type
		        validate_WordCountEqual(op, 4)
		        if ModuleBinary.UInt32Value(op.Offset + 16) > 1 then
		          logError op, "Invalid Linkage Type enumeration value."
		        end if
		      case else
		        validate_WordCountEqual(op, 3)
		      end select
		      
		      
		      ' ***** OpMemberName ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpMemberName
		      validate_WordCountMinimum(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      if Trim(ModuleBinary.CString(op.Offset + 12)) = "" then
		        logError op, "Invalid name."
		      end if
		      
		      ' ***** OpMemoryModel ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpMemoryModel
		      validate_WordCountEqual(op, 3)
		      if ModuleBinary.UInt32Value(op.Offset + 4) > 2 then
		        logError op, "Invalid Addressing Model enumeration value."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 8) > 4 then
		        logError op, "Invalid Memory Model enumeration value."
		      end if
		      
		      ' ***** OpName ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpName
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Target ID out of bounds.", "Target ID not found.")
		      if Trim(ModuleBinary.CString(op.Offset + 8)) = "" then
		        logError op, "Invalid name."
		      end if
		      
		      ' ***** OpNop ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpNop
		      logError op, "Use of OpNop is invalid."
		      
		      ' ***** OpNot ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpNot
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand ID out of bounds.", "Operand ID not found.")
		      // todo: Result Type must be scalars or vectors of floatint-point types
		      
		      ' ***** OpPhi ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpPhi
		      validate_WordCountMinimum(op, 3)
		      if ((op.WordCount mod 2) <> 1) then
		        logError op, "Operands need to be in pairs."
		      end if
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Operand " + Str(k) + " ID out of bounds.", "Operand " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpReturn ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpReturn
		      validate_WordCountEqual(op, 1)
		      
		      ' ***** OpSampler ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSampler
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      // todo: validate that sampler object type is OpTypeSampler
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Filter ID out of bounds.", "Filter ID not found.")
		      // todo: validate that sampler object type is OpTypeFilter
		      
		      ' ***** OpSelectionMerge ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSelectionMerge
		      validate_WordCountEqual(op, 3)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Label ID out of bounds.", "Label ID not found.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) > 2 then
		        logError op, "Invalid Selection Control enumeration value."
		      end if
		      
		      ' ***** OpSLessThan ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSLessThan
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand 1 ID out of bounds.", "Operand 1 ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Operand 2 ID out of bounds.", "Operand 2 ID not found.")
		      
		      ' ***** OpSNegate ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSNegate
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Operand ID out of bounds.", "Operand ID not found.")
		      // todo: Result Type must be scalars or vectors of integer types
		      
		      ' ***** OpSource ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSource
		      validate_WordCountEqual(op, 3)
		      if ModuleBinary.UInt32Value(op.Offset + 4) > 4 then
		        logError op, "Invalid Source Language enumeration value."
		      end if
		      
		      ' ***** OpSourceExtension ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSourceExtension
		      validate_WordCountMinimum(op, 1)
		      if Trim(ModuleBinary.CString(op.Offset + 4)) = "" then
		        logError op, "Invalid extension."
		      end if
		      
		      ' ***** OpSpecConstant ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSpecConstant
		      validate_WordCountMinimum(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        select case typ.Type
		        case SPIRVTypeEnum.Float, SPIRVTypeEnum.Integer
		          // do nothing
		        case else
		          logError op, "Invalid constant type. Expected integer or float."
		        end select
		      end if
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      
		      ' ***** OpSpecConstantComposite ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSpecConstantComposite
		      validate_WordCountMinimum(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      k = 0
		      while j < ub
		        validate_Id(op, ModuleBinary.UInt32Value(j), "Constituent " + Str(k) + " ID out of bounds.", "Constituent " + Str(k) + " ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpSpecConstantFalse ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSpecConstantFalse
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        if typ.Type <> SPIRVTypeEnum.Boolean then
		          logError op, "Expected scalar Boolean type."
		        end if
		      end if
		      
		      ' ***** OpSpecConstantTrue ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpSpecConstantTrue
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if Types.HasKey(ModuleBinary.UInt32Value(op.Offset + 4)) then
		        typ = Types.Value(ModuleBinary.UInt32Value(op.Offset + 4))
		        if typ.Type <> SPIRVTypeEnum.Boolean then
		          logError op, "Expected scalar Boolean type."
		        end if
		      end if
		      
		      ' ***** OpStore ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpStore
		      validate_WordCountMinimum(op, 3)
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 4), "Pointer ID out of bounds.", "Pointer ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 8), "Object ID out of bounds.", "Object ID not found.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      while j < ub
		        if (ModuleBinary.UInt32Value(j) < 1) or (ModuleBinary.UInt32Value(j) > 2) then
		          logError op, "Invalid Memory Access enumeration value."
		        end if
		        j = j + 4
		      wend
		      
		      ' ***** OpString ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpString
		      validate_WordCountMinimum(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      if Trim(ModuleBinary.CString(op.Offset + 8)) = "" then
		        logError op, "Invalid string."
		      end if
		      
		      ' ***** OpTextureFetchBuffer ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureFetchBuffer
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Element ID out of bounds.", "Element ID not found.")
		      
		      ' ***** OpTextureFetchSample ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureFetchSample
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Sample ID out of bounds.", "Sample ID not found.")
		      
		      ' ***** OpTextureFetchTexel ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureFetchTexel
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Level of Detail ID out of bounds.", "Level of Detail ID not found.")
		      
		      ' ***** OpTextureFetchTexelOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureFetchTexelOffset
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Offset ID out of bounds.", "Offset ID not found.")
		      
		      ' ***** OpTextureGather ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureGather
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      if (ModuleBinary.UInt32Value(op.Offset + 20) > 3) then
		        logError op, "Component number must be 0, 1, 2 or 3."
		      end if
		      
		      ' ***** OpTextureGatherOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureGatherOffset
		      validate_WordCountEqual(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      if (ModuleBinary.UInt32Value(op.Offset + 20) > 3) then
		        logError op, "Component number must be 0, 1, 2 or 3."
		      end if
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "Offset ID out of bounds.", "Offset ID not found.")
		      
		      ' ***** OpTextureGatherOffsets ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureGatherOffsets
		      validate_WordCountEqual(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      if (ModuleBinary.UInt32Value(op.Offset + 20) > 3) then
		        logError op, "Component number must be 0, 1, 2 or 3."
		      end if
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "Offsets ID out of bounds.", "Offsets ID not found.")
		      
		      ' ***** OpTextureQueryLevels ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureQueryLevels
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      
		      ' ***** OpTextureQueryLod ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureQuerySizeLod
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      
		      ' ***** OpTextureQuerySamples ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureQuerySamples
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      
		      ' ***** OpTextureQuerySize ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureQuerySize
		      validate_WordCountEqual(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      
		      ' ***** OpTextureQuerySizeLod ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureQuerySizeLod
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Level of Detail ID out of bounds.", "Level of Detail ID not found.")
		      
		      ' ***** OpTextureSample ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSample
		      validate_WordCountMinimum(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      if op.WordCount = 6 then
		        validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Bias ID out of bounds.", "Bias ID not found.")
		      end if
		      // todo: this opcode is only allowed under the fragment execution model
		      
		      ' ***** OpTextureSampleDref ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleDref
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Dref ID out of bounds.", "Dref ID not found.")
		      // todo: this opcode is only allowed under the fragment execution model
		      
		      ' ***** OpTextureSampleGrad ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleGrad
		      validate_WordCountEqual(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "dx ID out of bounds.", "dx ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "dy ID out of bounds.", "dy ID not found.")
		      
		      ' ***** OpTextureSampleGradOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleGradOffset
		      validate_WordCountEqual(op, 8)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "dx ID out of bounds.", "dx ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "dy ID out of bounds.", "dy ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 28), "Offset ID out of bounds.", "Offset ID not found.")
		      // todo: offset must an <id> of an integer-based constant instruction of scalar or vector type
		      // todo: number of components in Offset must equal the number of components in Coordinate, minus the array layer component, if present
		      
		      ' ***** OpTextureSampleLod ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleLod
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Level of Detail ID out of bounds.", "Level of Detail ID not found.")
		      // todo: this opcode is only allowed under the fragment execution model
		      
		      ' ***** OpTextureSampleLodOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleLodOffset
		      validate_WordCountEqual(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Level of Detail ID out of bounds.", "Level of Detail ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "Offset ID out of bounds.", "Offset ID not found.")
		      // todo: this opcode is only allowed under the fragment execution model
		      // todo: offset must an <id> of an integer-based constant instruction of scalar or vector type
		      // todo: number of components in Offset must equal the number of components in Coordinate, minus the array layer component, if present
		      
		      ' ***** OpTextureSampleOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleOffset
		      validate_WordCountMinimum(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Offset ID out of bounds.", "Offset ID not found.")
		      if op.WordCount = 7 then
		        validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "Bias ID out of bounds.", "Bias ID not found.")
		      end if
		      // todo: this opcode is only allowed under the fragment execution model
		      
		      ' ***** OpTextureSampleProj ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleProj
		      validate_WordCountMinimum(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      if op.WordCount = 6 then
		        validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Bias ID out of bounds.", "Bias ID not found.")
		      end if
		      // todo: this opcode is only allowed under the fragment execution model
		      
		      ' ***** OpTextureSampleProjGrad ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleProjGrad
		      validate_WordCountEqual(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "dx ID out of bounds.", "dx ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "dy ID out of bounds.", "dy ID not found.")
		      
		      ' ***** OpTextureSampleProjGradOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleProjGradOffset
		      validate_WordCountEqual(op, 8)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "dx ID out of bounds.", "dx ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "dy ID out of bounds.", "dy ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 28), "Offset ID out of bounds.", "Offset ID not found.")
		      
		      ' ***** OpTextureSampleProjLod ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleProjLod
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Level of Detail ID out of bounds.", "Level of Detail ID not found.")
		      
		      ' ***** OpTextureSampleProjLodOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleProjLodOffset
		      validate_WordCountEqual(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Level of Detail ID out of bounds.", "Level of Detail ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Offset ID out of bounds.", "Offset ID not found.")
		      
		      ' ***** OpTextureSampleProjOffset ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTextureSampleProjOffset
		      validate_WordCountMinimum(op, 7)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Sampler ID out of bounds.", "Sampler ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Coordinate ID out of bounds.", "Coordinate ID not found.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 20), "Offset ID out of bounds.", "Offset ID not found.")
		      if op.WordCount = 7 then
		        validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 24), "Bias ID out of bounds.", "Bias ID not found.")
		      end if
		      // todo: this opcode is only allowed under the fragment execution model
		      // todo: offset must an <id> of an integer-based constant instruction of scalar or vector type
		      // todo: number of components in Offset must equal the number of components in Coordinate, minus the array layer component, if present
		      
		      ' ***** OpTypeArray ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeArray
		      validate_WordCountEqual(op, 4)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Element Type ID out of bounds.", "Element Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) = ModuleBinary.UInt32Value(op.Offset + 4) then
		        logError op, "Circular Element Type  ID reference."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 12) < 1 then
		        logError op, "Invalid length."
		      end if
		      
		      ' ***** OpTypeBool ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeBool
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpTypeDeviceEvent ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeDeviceEvent
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpTypeEvent ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeEvent
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpTypeFloat ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeFloat
		      validate_WordCountEqual(op, 3)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      if ModuleBinary.UInt32Value(op.Offset + 8) <= 0 then
		        logError op, "Invalid width."
		      end if
		      
		      ' ***** OpTypeFunction ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeFunction
		      validate_WordCountMinimum(op, 3)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Return Type ID out of bounds.", "Return Type ID not declared.")
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 12
		      k = 0
		      while j < ub
		        validate_typeId(op, ModuleBinary.UInt32Value(j), "Parameter " + Str(k) + " Type ID out of bounds.", "Parameter " + Str(k) + " Type ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpTypeInt ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeInt
		      validate_WordCountEqual(op, 4)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      if ModuleBinary.UInt32Value(op.Offset + 8) <= 0 then
		        logError op, "Invalid width."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 1 then
		        logError op, "Invalid sign value."
		      end if
		      
		      ' ***** OpTypeMatrix ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeMatrix
		      validate_WordCountEqual(op, 4)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Column Type ID out of bounds.", "Column Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) = ModuleBinary.UInt32Value(op.Offset + 4) then
		        logError op, "Circular Column Type  ID reference."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 12) < 2 then
		        logError op, "Invalid Column Count."
		      end if
		      
		      ' ***** OpTypeOpaque ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeOpaque
		      validate_WordCountMinimum(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      if Trim(ModuleBinary.CString(op.Offset + 8)) = "" then
		        logError op, "Invalid opaque type name."
		      end if
		      
		      ' ***** OpTypePipe ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypePipe
		      validate_WordCountMinimum(op, 4)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Type ID out of bounds.", "Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 2 then
		        logError op, "Invalid Access Qualifier enumeration value."
		      end if
		      
		      ' ***** OpTypePointer ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypePointer
		      validate_WordCountEqual(op, 4)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      if ModuleBinary.UInt32Value(op.Offset + 8) > 10 then
		        logError op, "Invalid Storage Class enumeration value."
		      end if
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 12), "Type ID out of bounds.", "Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 12) = ModuleBinary.UInt32Value(op.Offset + 4) then
		        logError op, "Circular Type  ID reference."
		      end if
		      
		      ' ***** OpTypeQueue ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeQueue
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpTypeReserveId ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeReserveId
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpTypeRuntimeArray ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeRuntimeArray
		      validate_WordCountEqual(op, 3)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Element Type ID out of bounds.", "Element Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) = ModuleBinary.UInt32Value(op.Offset + 4) then
		        logError op, "Circular Element Type  ID reference."
		      end if
		      
		      ' ***** OpTypeSampler ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeSampler
		      validate_WordCountMinimum(op, 8)
		      if op.WordCount > 9 then
		        logError op, "Invalid word count."
		      end if
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Sampled Type ID out of bounds.", "Sampled Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 5 then
		        logError op, "Invalid Dimensionality enumeration value."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 16) > 2 then
		        logError op, "Invalid Content value."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 20) > 1 then
		        logError op, "Invalid Arrayed value."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 24) > 1 then
		        logError op, "Invalid Compare value."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 28) > 1 then
		        logError op, "Invalid Multisampled value."
		      end if
		      if op.WordCount >= 9 then
		        if ModuleBinary.UInt32Value(op.Offset + 32) > 2 then
		          logError op, "Invalid Access Qualifier enumeration value."
		        end if
		      end if
		      
		      ' ***** OpTypeStruct ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeStruct
		      validate_WordCountMinimum(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      ub = op.Offset + (op.WordCount * 4)
		      j = op.Offset + 8
		      k = 0
		      while j < ub
		        validate_typeId(op, ModuleBinary.UInt32Value(j), "Member " + Str(k) + " Type ID out of bounds.", "Member " + Str(k) + " Type ID not declared.")
		        j = j + 4
		        k = k + 1
		      wend
		      
		      ' ***** OpTypeVector ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeVector
		      validate_WordCountEqual(op, 4)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 8), "Component Type ID out of bounds.", "Component Type ID not declared.")
		      if ModuleBinary.UInt32Value(op.Offset + 8) = ModuleBinary.UInt32Value(op.Offset + 4) then
		        logError op, "Circular Component Type  ID reference."
		      end if
		      if ModuleBinary.UInt32Value(op.Offset + 12) < 2 then
		        logError op, "Invalid Component Count."
		      end if
		      
		      ' ***** OpTypeVoid ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpTypeVoid
		      validate_WordCountEqual(op, 2)
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 4))
		      
		      ' ***** OpUndef ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpUndef
		      validate_WordCountEqual(op, 3)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      
		      ' ***** OpVariable ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpVariable
		      validate_WordCountMinimum(op, 4)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 10 then
		        logError op, "Invalid Storage Class enumeration value."
		      end if
		      
		      ' ***** OpVariableArray ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpVariableArray
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      if ModuleBinary.UInt32Value(op.Offset + 12) > 10 then
		        logError op, "Invalid Storage Class enumeration value."
		      end if
		      
		      ' ***** OpVectorExtractDynamic ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpVectorExtractDynamic
		      validate_WordCountEqual(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Vector ID out of bounds.", "Vector ID not declared.")
		      // todo: validate that vector id is a vector type
		      // todo: validate that index not out of bounds
		      // todo: validate that result type is sane type as vector type
		      
		      ' ***** OpVectorInsertDynamic ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpVectorInsertDynamic
		      validate_WordCountEqual(op, 6)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Vector ID out of bounds.", "Vector ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Component ID out of bounds.", "Component ID not declared.")
		      // todo: validate that index not out of bounds
		      
		      ' ***** OpVectorShuffle ***********************************************************************************
		      
		    case SPIRVOpcodeTypeEnum.OpVectorShuffle
		      validate_WordCountMinimum(op, 5)
		      validate_typeId(op, ModuleBinary.UInt32Value(op.Offset + 4), "Result Type ID out of bounds.", "Result Type ID not declared.")
		      validate_ResultId(op, ModuleBinary.UInt32Value(op.Offset + 8))
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 12), "Vector 1 ID out of bounds.", "Vector 1 ID not declared.")
		      validate_Id(op, ModuleBinary.UInt32Value(op.Offset + 16), "Vector 2 ID out of bounds.", "Vector 2 ID not declared.")
		      // todo: validate that vectors has same component type
		      // todo: validate that components are not out of bounds
		      
		    case else
		      logError op, "Unknown opcode type."
		      
		    end select
		    
		    i = i + 1
		  wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validate_functionId(op As ZocleeShade.SPIRVOpcode, id As UInt32, errMsgOutOfBounds As String, errMsgNotDeclared As String)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  if (id <= 0) or (id >= Bound) then
		    logError op, errMsgOutOfBounds
		  end if
		  if not Functions.HasKey(id) then
		    logError op, errMsgNotDeclared
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validate_Id(op As ZocleeShade.SPIRVOpcode, id As UInt32, errMsgOutOfBounds As String, errMsgNotDeclared As String)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  if (id <= 0) or (id >= Bound) then
		    logError op, errMsgOutOfBounds
		  end if
		  if not OpcodeLookup.HasKey(id) then
		    logError op, errMsgNotDeclared
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validate_ResultId(op As ZocleeShade.SPIRVOpcode, id As UInt32)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  if (id <= 0) or (id >= Bound) then
		    logError op, "Result ID out of bounds."
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validate_typeId(op As ZocleeShade.SPIRVOpcode, id As UInt32, errMsgOutOfBounds As String, errMsgNotDeclared As String)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  if (id <= 0) or (id >= Bound) then
		    logError op, errMsgOutOfBounds
		  end if
		  if not Types.HasKey(id) then
		    logError op, errMsgNotDeclared
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validate_WordCountEqual(op As ZocleeShade.SPIRVOpcode, cnt As UInt32)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  if op.WordCount <> cnt then
		    logError op, "Invalid word count."
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub validate_WordCountMinimum(op As ZocleeShade.SPIRVOpcode, min As UInt32)
		  ' {Zoclee}™ Shade is an open source initiative by {Zoclee}™.
		  ' www.zoclee.com/shade
		  
		  if op.WordCount < min then
		    logError op, "Invalid word count."
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AddressingModel As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		Bound As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		Constants As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Decorations() As ZocleeShade.SPIRVDecoration
	#tag EndProperty

	#tag Property, Flags = &h0
		EntryPoints As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Errors() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Functions As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		GeneratorMagicNumber As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		MemoryModel As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		ModuleBinary As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		Names As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private OpcodeLookup As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Opcodes() As ZocleeShade.SPIRVOpcode
	#tag EndProperty

	#tag Property, Flags = &h0
		SourceLanguage As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		SourceVersion As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		Types As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Version As UInt32
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
