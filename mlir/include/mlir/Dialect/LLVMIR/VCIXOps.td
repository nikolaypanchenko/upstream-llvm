//===-- VCIX.td - VCIX dialect operation definitions *- tablegen -*--------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// The file defines the basic operations for the VCIX dialect.
//
// The SiFive Vector Coprocessor Interface (VCIX) provides a flexible mechanism
// to extend application processors with custom coprocessors and
// variable-latency arithmetic units. The interface offers throughput comparable
// to that of standard RISC-V vector instructions. To accelerate performance,
// system designers may use VCIX as a low-latency, high-throughput interface to
// a coprocessor
//
// https://www.sifive.com/document-file/sifive-vector-coprocessor-interface-vcix-software
//
//===----------------------------------------------------------------------===//

#ifndef VCIXIR_OPS

include "mlir/IR/OpBase.td"
include "mlir/Dialect/LLVMIR/LLVMOpBase.td"

//===----------------------------------------------------------------------===//
// VCIX dialect definition.
//===----------------------------------------------------------------------===//

def VCIX_Dialect : Dialect {
  let name = "vcix";
  let cppNamespace = "::mlir::vcix";
  let dependentDialects = ["LLVM::LLVMDialect"];
  let description = [{
     The SiFive Vector Coprocessor Interface (VCIX) provides a flexible mechanism
     to extend application processors with custom coprocessors and
     variable-latency arithmetic units. The interface offers throughput comparable
     to that of standard RISC-V vector instructions. To accelerate performance,
     system designers may use VCIX as a low-latency, high-throughput interface to
     a coprocessor

     https://www.sifive.com/document-file/sifive-vector-coprocessor-interface-vcix-software
  }];

  let useDefaultAttributePrinterParser = 1;
}

// Special version for intrinsic version where int attr is zext to i32 or i64
// depending on xlen of the target
def VCIX_VectorOrScalar
    : AnyTypeOf<[LLVM_AnyVector, I<64>, I<32>, F<16>, F<32>, F<64>]>;
def VCIX_Opcode : AnyTypeOf<[I32, I64]>;
def VCIX_Register : AnyTypeOf<[I32, I64]>;
def VCIX_ImmAttr : AnyAttrOf<[I32Attr, I64Attr]>;
def VCIX_VL : AnyTypeOf<[I<64>, I<32>]>;

class VCIX_IntrinOp<string mnemonic, int numResults, list<Trait> traits = []>
    : LLVM_IntrOpBase<VCIX_Dialect,
                      mnemonic,
                      "riscv_sf_vc_" # !subst(".", "_", mnemonic) # "_se",
                      [], [], traits, numResults>;

class VCIX_UnaryNoRetOp<string mnemonic, string lmulSew, list<Trait> traits = []>
    : VCIX_IntrinOp<mnemonic # "." # lmulSew, 0, traits>;

// Unary intrinsics with no source and no return
def VCIX_UnaryImmU8Mf8NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8mf8">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;
def VCIX_UnaryImmU8Mf4NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8mf4">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;
def VCIX_UnaryImmU8Mf2NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8mf2">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;
def VCIX_UnaryImmU8M1NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8m1">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;
def VCIX_UnaryImmU8M2NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8m2">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;
def VCIX_UnaryImmU8M4NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8m4">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;
def VCIX_UnaryImmU8M8NoRetOp
    : VCIX_UnaryNoRetOp<"i", "u8m8">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;

// Unary intrinsics with `rs1` as a source and no return
def VCIX_UnaryU8Mf8NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8mf8">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;
def VCIX_UnaryU8Mf4NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8mf4">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;
def VCIX_UnaryU8Mf2NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8mf2">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;
def VCIX_UnaryU8M1NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8m1">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;
def VCIX_UnaryU8M2NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8m2">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;
def VCIX_UnaryU8M4NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8m4">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;
def VCIX_UnaryU8M8NoRetOp
    : VCIX_UnaryNoRetOp<"x", "u8m8">,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;

def VCIX_UnaryImmOp
    : VCIX_IntrinOp<"v.i", 1>,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_VL: $vl,
                   VCIX_ImmAttr: $imm)>;

def VCIX_UnaryOp
    : VCIX_IntrinOp<"v.x", 1>,
    Arguments<(ins VCIX_Opcode: $opcode,
                   VCIX_Register: $rs2,
                   VCIX_Register: $rd,
                   VCIX_Register: $rs1,
                   VCIX_VL: $vl)>;

//def VCIX_BinaryIntrinROOp : VCIX_IntrinOp<"binary.ro"> {
//  let arguments = (ins VCIX_VectorOrScalar: $op1,
//                       VectorOfRank1: $op2,
//                       Optional<VCIX_VL>: $rvl,
//                       VCIX_OpcodeAttr: $opcode,
//                       VCIX_RdAttr: $rd);
//
//  string llvmBuilder = [{
//      const unsigned xlenWidth = getXlenFromOpcode($opcode);
//      llvm::Type *xlen =
//          llvm::Type::getIntNTy(moduleTranslation.getLLVMContext(), xlenWidth);
//      llvm::Value *opcodeConst = getLLVMConstant(
//          xlen, $opcode, $_location, moduleTranslation);
//
//      llvm::Value *rdConst = getLLVMConstant(
//          xlen, $rd, $_location, moduleTranslation);
//
//      auto intId = getBinaryROIntrinsicId(op.getOp1().getType());
//      VectorType vt = op.getOp2().getType().cast<VectorType>();
//      llvm::Value *rvl =
//          convertRvl(builder, $rvl, vt, xlen, $_location, moduleTranslation);
//
//      createIntrinsicCall(builder, intId,
//                          {opcodeConst, rdConst, $op2, $op1, rvl},
//                          {xlen, $op2->getType(), $op1->getType(), xlen});
//  }];
//}
//
//def VCIX_BinaryIntrinOp : VCIX_IntrinOp<"binary"> {
//  let arguments = (ins VCIX_VectorOrScalar: $op1,
//                       VectorOfRank1: $op2,
//                       Optional<VCIX_VL>: $rvl,
//                       VCIX_OpcodeAttr: $opcode);
//
//  let results = (outs VectorOfRank1: $result);
//
//  string llvmBuilder = [{
//      const unsigned xlenWidth = getXlenFromOpcode($opcode);
//      llvm::Type *xlen = llvm::Type::getIntNTy(
//          moduleTranslation.getLLVMContext(), xlenWidth);
//      llvm::Value *opcodeConst = getLLVMConstant(
//          xlen, $opcode, $_location, moduleTranslation);
//
//      auto intId = getBinaryIntrinsicId(op.getOp1().getType());
//      VectorType vt = op.getResult().getType().cast<VectorType>();
//      llvm::Value *rvl =
//          convertRvl(builder, $rvl, vt, xlen, $_location, moduleTranslation);
//
//      $result = createIntrinsicCall(
//          builder, intId, {opcodeConst, $op2, $op1, rvl},
//          {$_resultType, xlen, $op2->getType(), $op1->getType(), xlen});
//  }];
//}
//
//def VCIX_TernaryIntrinROOp : VCIX_IntrinOp<"ternary.ro"> {
//  let arguments = (ins VCIX_VectorOrScalar: $op1,
//                       VectorOfRank1: $op2,
//                       VectorOfRank1: $op3,
//                       Optional<VCIX_VL>: $rvl,
//                       VCIX_OpcodeAttr: $opcode);
//
//  string llvmBuilder = [{
//      const unsigned xlenWidth = getXlenFromOpcode($opcode);
//      llvm::Type *xlen = llvm::Type::getIntNTy(
//          moduleTranslation.getLLVMContext(), xlenWidth);
//      llvm::Value *opcodeConst = getLLVMConstant(
//          xlen, $opcode, $_location, moduleTranslation);
//
//      auto intId = getTernaryROIntrinsicId(op.getOp1().getType());
//      VectorType vt = op.getOp3().getType().cast<VectorType>();
//      llvm::Value *rvl =
//          convertRvl(builder, $rvl, vt, xlen, $_location, moduleTranslation);
//
//      createIntrinsicCall(
//          builder, intId, {opcodeConst, $op3, $op2, $op1, rvl},
//          {xlen, $op3->getType(), $op2->getType(), $op1->getType(), xlen});
//  }];
//}
//
//def VCIX_TernaryIntrinOp : VCIX_IntrinOp<"ternary"> {
//  let arguments = (ins VCIX_VectorOrScalar: $op1,
//                       VectorOfRank1: $op2,
//                       VectorOfRank1: $op3,
//                       Optional<VCIX_VL>: $rvl,
//                       VCIX_OpcodeAttr: $opcode);
//  let results = (outs VectorOfRank1: $result);
//
//  string llvmBuilder = [{
//      const unsigned xlenWidth = getXlenFromOpcode($opcode);
//      llvm::Type *xlen = llvm::Type::getIntNTy(
//          moduleTranslation.getLLVMContext(), xlenWidth);
//      llvm::Value *opcodeConst = getLLVMConstant(
//          xlen, $opcode, $_location, moduleTranslation);
//
//      auto intId = getTernaryIntrinsicId(op.getOp1().getType());
//      VectorType vt = op.getResult().getType().cast<VectorType>();
//      llvm::Value *rvl =
//          convertRvl(builder, $rvl, vt, xlen, $_location, moduleTranslation);
//
//      $result = createIntrinsicCall(
//          builder, intId, {opcodeConst, $op3, $op2, $op1, rvl},
//          {$_resultType, xlen, $op3->getType(), $op2->getType(), $op1->getType(), xlen});
//  }];
//}
//
//def VCIX_WideTernaryIntrinROOp : VCIX_IntrinOp<"wide.ternary.ro"> {
//  let arguments = (ins VCIX_VectorOrScalar: $op1,
//                       VectorOfRank1: $op2,
//                       VectorOfRank1: $op3,
//                       Optional<VCIX_VL>: $rvl,
//                       VCIX_OpcodeAttr: $opcode);
//
//  string llvmBuilder = [{
//      const unsigned xlenWidth = getXlenFromOpcode($opcode);
//      llvm::Type *xlen = llvm::Type::getIntNTy(
//          moduleTranslation.getLLVMContext(), xlenWidth);
//      llvm::Value *opcodeConst = getLLVMConstant(
//          xlen, $opcode, $_location, moduleTranslation);
//
//      auto intId = getWideTernaryROIntrinsicId(op.getOp1().getType());
//      VectorType vt = op.getOp3().getType().cast<VectorType>();
//      llvm::Value *rvl =
//          convertRvl(builder, $rvl, vt, xlen, $_location, moduleTranslation);
//
//      createIntrinsicCall(
//          builder, intId, {opcodeConst, $op3, $op2, $op1, rvl},
//          {xlen, $op3->getType(), $op2->getType(), $op1->getType(), xlen});
//  }];
//}
//
//def VCIX_WideTernaryIntrinOp : VCIX_IntrinOp<"wide.ternary", []> {
//  let arguments = (ins VCIX_VectorOrScalar: $op1,
//                       VectorOfRank1: $op2,
//                       VectorOfRank1: $op3,
//                       Optional<VCIX_VL>: $rvl,
//                       VCIX_OpcodeAttr: $opcode);
//
//  let results = (outs VectorOfRank1: $result);
//
//  string llvmBuilder = [{
//      const unsigned xlenWidth = getXlenFromOpcode($opcode);
//      llvm::Type *xlen = llvm::Type::getIntNTy(
//          moduleTranslation.getLLVMContext(), xlenWidth);
//      llvm::Value *opcodeConst = getLLVMConstant(
//          xlen, $opcode, $_location, moduleTranslation);
//
//      auto intId = getWideTernaryIntrinsicId(op.getOp1().getType());
//      VectorType vt = op.getResult().getType().cast<VectorType>();
//      llvm::Value *rvl =
//          convertRvl(builder, $rvl, vt, xlen, $_location, moduleTranslation);
//
//      $result = createIntrinsicCall(
//          builder, intId, {opcodeConst, $op3, $op2, $op1, rvl},
//          {$_resultType, xlen, $op3->getType(), $op2->getType(), $op1->getType(), xlen});
//  }];
//}
#endif // VCIXIR_OPS
