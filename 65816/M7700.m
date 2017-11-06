/*
 Copyright (c) 2014-2017, Alessandro Gatti - frob.it
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "M7700.h"
#import "Common.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

static const Opcode kOpcodeTable42[256];

static const Opcode kOpcodeTable89[256];

static NSData *_Nonnull kNOPSequence;

@implementation ItFrobHopper65816M7700

+ (void)load {
  const uint8_t kNOPByte = 0xEA;
  kNOPSequence = [NSData dataWithBytes:(const void *)&kNOPByte length:1];
}

+ (NSString *_Nonnull)family {
  return @"Mitsubishi";
}

+ (NSString *_Nonnull)model {
  return @"M7700";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 24;
}

+ (NSData *_Nonnull)nopOpcodeSignature {
  return kNOPSequence;
}

- (const Opcode *_Nonnull)
  opcodeForFile:(NSObject<HPDisassembledFile> *_Nonnull)file
      atAddress:(Address)address
andFillMetadata:(FRBInstructionUserData *_Nonnull)metadata {

  uint8_t byte = [file readUInt8AtVirtualAddress:address];
  switch (byte) {
  case 0x42:
    metadata->wideOpcode = YES;
    return &kOpcodeTable42[[file readUInt8AtVirtualAddress:address + 1]];

  case 0x89:
    metadata->wideOpcode = YES;
    return &kOpcodeTable89[[file readUInt8AtVirtualAddress:address + 1]];

  default:
    metadata->wideOpcode = NO;
    return &kOpcodeTable[byte];
  }
}

@end

#define _NO OpcodeUndocumented
#define _NA ModeUnknown
#define _NR RegisterNone

#define _                                                                      \
  { _NO, _NA, _NR, _NR, AccumulatorDefault }

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, ModeStack, N, S | P, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndexedIndirect, A | D | X, A, AccumulatorA},
    _,
    {OpcodeORA, ModeStackRelative, A | D | S, A, AccumulatorA},
    {OpcodeSEB, ModeDirectBitAddressing, N, N, AccumulatorDefault},
    {OpcodeORA, ModeDirect, A | D, A, AccumulatorA},
    {OpcodeASL, ModeDirect, D, N, AccumulatorA},
    {OpcodeORA, ModeDirectIndirectLong, A | D, A, AccumulatorA},
    {OpcodePHP, ModeStack, P | S, S, AccumulatorDefault},
    {OpcodeORA, ModeImmediate, A, A, AccumulatorA},
    {OpcodeASL, ModeAccumulator, A, A, AccumulatorA},
    {OpcodePHD, ModeStack, D | S, S, AccumulatorDefault},
    {OpcodeSEB, ModeAbsoluteBitAddressing, N, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsolute, A, A, AccumulatorA},
    {OpcodeASL, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteLong, A, A, AccumulatorA},

    {OpcodeBPL, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndirectIndexedY, A | D, A, AccumulatorA},
    {OpcodeORA, ModeDirectIndirect, A | D, A, AccumulatorA},
    {OpcodeORA, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorA},
    {OpcodeCLB, ModeDirectBitAddressing, N, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndexedX, A | D | X, A, AccumulatorA},
    {OpcodeASL, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndirectLongIndexed, A | Y, A, AccumulatorA},
    {OpcodeCLC, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A, AccumulatorA},
    {OpcodeDEC, ModeAccumulator, A, A, AccumulatorA},
    {OpcodeTAS, ModeImplied, A, S, AccumulatorDefault},
    {OpcodeCLB, ModeAbsoluteBitAddressing, N, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A, AccumulatorA},
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteLongIndexed, A, A, AccumulatorA},

    {OpcodeJSR, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndexedIndirect, A | D | X, A, AccumulatorA},
    {OpcodeJSL, ModeAbsoluteLong, N, N, AccumulatorDefault},
    {OpcodeAND, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorA},
    {OpcodeBBS, ModeDirectBitAddressingProgramCounterRelative, N, N,
     AccumulatorDefault},
    {OpcodeAND, ModeDirect, A | D, A, AccumulatorA},
    {OpcodeROL, ModeDirect, N, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirectLong, A, A, AccumulatorA},
    {OpcodePLP, ModeStack, S, P | S, AccumulatorDefault},
    {OpcodeAND, ModeImmediate, A, A, AccumulatorA},
    {OpcodeROL, ModeAccumulator, A, A, AccumulatorA},
    {OpcodePLD, ModeStack, S, D | S, AccumulatorDefault},
    {OpcodeBBS, ModeDirectBitAddressingAbsolute, N, N, AccumulatorDefault},
    {OpcodeAND, ModeAbsolute, A, A, AccumulatorA},
    {OpcodeROL, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteLong, A, A, AccumulatorA},

    {OpcodeBMI, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorA},
    {OpcodeAND, ModeDirectIndirect, A | D, A, AccumulatorA},
    {OpcodeAND, ModeStackRelativeIndirectIndexed, A | D | S | Y, A,
     AccumulatorA},
    {OpcodeBBC, ModeDirectBitAddressingProgramCounterRelative, N, N,
     AccumulatorDefault},
    {OpcodeAND, ModeDirectIndexedX, A | D | X, A, AccumulatorA},
    {OpcodeROL, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirectLongIndexed, A | D | Y, A, AccumulatorA},
    {OpcodeSEC, ModeImplied, N, P, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A, AccumulatorA},
    {OpcodeINC, ModeAccumulator, A, A, AccumulatorA},
    {OpcodeTSA, ModeImplied, S, A, AccumulatorDefault},
    {OpcodeBBC, ModeDirectBitAddressingAbsolute, N, N, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A, AccumulatorA},
    {OpcodeROL, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteLongIndexed, A | X, A, AccumulatorA},

    {OpcodeRTI, ModeStack, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndexedX, A | D | X, A, AccumulatorA},
    _, // Table42
    {OpcodeEOR, ModeStackRelative, A | D | S, A, AccumulatorA},
    {OpcodeMVP, ModeBlockMove, C | X | Y, C | X | Y, AccumulatorDefault},
    {OpcodeEOR, ModeDirect, A | D, A, AccumulatorA},
    {OpcodeLSR, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirectLong, A | D, A, AccumulatorA},
    {OpcodePHA, ModeStack, A | S, S, AccumulatorDefault},
    {OpcodeEOR, ModeImmediate, A, A, AccumulatorA},
    {OpcodeLSR, ModeAccumulator, A, A, AccumulatorA},
    {OpcodePHG, ModeStack, PBR | S, S, AccumulatorDefault},
    {OpcodeJMP, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsolute, A, A, AccumulatorA},
    {OpcodeLSR, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteLong, A, A, AccumulatorA},

    {OpcodeBVC, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorA},
    {OpcodeEOR, ModeDirectIndirect, A | D, A, AccumulatorA},
    {OpcodeEOR, ModeStackRelativeIndirectIndexed, A | D | S | Y, A,
     AccumulatorA},
    {OpcodeMVN, ModeBlockMove, C | X | Y, C | X | Y, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndexedX, A | D | X, A, AccumulatorA},
    {OpcodeLSR, ModeDirectIndexedX, X | D, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirectLongIndexed, A | D | Y, A, AccumulatorA},
    {OpcodeCLI, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A, AccumulatorA},
    {OpcodePHY, ModeStack, Y | S, S, AccumulatorDefault},
    {OpcodeTAD, ModeImplied, A, D, AccumulatorDefault},
    {OpcodeJMP, ModeAbsoluteLong, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A, AccumulatorA},
    {OpcodeLSR, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteLongIndexed, A | X, A, AccumulatorA},

    {OpcodeRTS, ModeStack, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndexedIndirect, N, N, AccumulatorA},
    {OpcodePER, ModeProgramCounterRelativeLong, S, S, AccumulatorDefault},
    {OpcodeADC, ModeStackRelative, A | D | S, A, AccumulatorA},
    {OpcodeLDM, ModeDirectMemoryAccess, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirect, A | D, A, AccumulatorA},
    {OpcodeROR, ModeDirect, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirectLong, A | D, A, AccumulatorA},
    {OpcodePLA, ModeStack, S, A | S, AccumulatorDefault},
    {OpcodeADC, ModeImmediate, A, A, AccumulatorA},
    {OpcodeROR, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodeRTL, ModeStack, N, N, AccumulatorDefault},
    {OpcodeJMP, ModeAbsoluteIndirect, N, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsolute, A, A, AccumulatorA},
    {OpcodeROR, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteLong, A, A, AccumulatorA},

    {OpcodeBVS, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorA},
    {OpcodeADC, ModeDirectIndirect, A | D, A, AccumulatorA},
    {OpcodeADC, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorA},
    {OpcodeLDM, ModeDirectMemoryAccessIndexed, X, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndexedX, A | D | X, A, AccumulatorA},
    {OpcodeROR, ModeDirectIndexedX, A | D | X, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirectLongIndexed, A | D | Y, A, AccumulatorA},
    {OpcodeSEI, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A, AccumulatorA},
    {OpcodePLY, ModeStack, S, Y | S, AccumulatorDefault},
    {OpcodeTDA, ModeImplied, D, A, AccumulatorDefault},
    {OpcodeJMP, ModeAbsoluteIndexedIndirect, X, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A, AccumulatorA},
    {OpcodeROR, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteLongIndexed, A | X, A, AccumulatorA},

    {OpcodeBRA, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndexedIndirect, A | D | X, N, AccumulatorA},
    {OpcodeBRA, ModeProgramCounterRelativeLong, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeStackRelative, A | D | S, N, AccumulatorA},
    {OpcodeSTY, ModeDirect, Y | D, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirect, A | D, N, AccumulatorA},
    {OpcodeSTX, ModeDirect, X | D, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirectLong, A | D, N, AccumulatorA},
    {OpcodeDEY, ModeImplied, Y, Y, AccumulatorDefault},
    _,
    {OpcodeTXA, ModeImplied, A | X, A | X, AccumulatorDefault},
    {OpcodePHT, ModeStack, D | S, S, AccumulatorDefault},
    {OpcodeSTY, ModeAbsolute, Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsolute, A, N, AccumulatorA},
    {OpcodeSTX, ModeAbsolute, X, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteLong, A, N, AccumulatorA},

    {OpcodeBCC, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirectIndexedY, A | D | Y, N, AccumulatorA},
    {OpcodeSTA, ModeDirectIndirect, A | D, N, AccumulatorA},
    {OpcodeSTA, ModeStackRelativeIndirectIndexed, A | D | Y | S, N,
     AccumulatorA},
    {OpcodeSTY, ModeDirectIndexedX, D | X | Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndexedX, A | D | X, N, AccumulatorA},
    {OpcodeSTX, ModeDirectIndexedY, D | X | Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirectLongIndexed, A | D | Y, N, AccumulatorA},
    {OpcodeTYA, ModeImplied, A | Y, A | Y, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, N, AccumulatorA},
    {OpcodeTXS, ModeImplied, X | S, X | S, AccumulatorDefault},
    {OpcodeTXY, ModeImplied, X | Y, X | Y, AccumulatorDefault},
    {OpcodeLDM, ModeAbsoluteMemoryAddress, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, N, AccumulatorA},
    {OpcodeLDM, ModeAbsoluteMemoryAddressIndexed, X, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteLongIndexed, A | X, N, AccumulatorA},

    {OpcodeLDY, ModeImmediate, N, Y, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndexedX, D | X, A, AccumulatorA},
    {OpcodeLDX, ModeImmediate, N, X, AccumulatorDefault},
    {OpcodeLDA, ModeStackRelative, D | S, A, AccumulatorA},
    {OpcodeLDY, ModeDirect, D, Y, AccumulatorDefault},
    {OpcodeLDA, ModeDirect, D, A, AccumulatorA},
    {OpcodeLDX, ModeDirect, D, X, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirectLong, D, A, AccumulatorA},
    {OpcodeTAY, ModeImplied, A | Y, A | Y, AccumulatorDefault},
    {OpcodeLDA, ModeImmediate, N, A, AccumulatorA},
    {OpcodeTAX, ModeImplied, A | X, A | X, AccumulatorDefault},
    {OpcodePLT, ModeStack, S, D | S, AccumulatorDefault},
    {OpcodeLDY, ModeAbsolute, N, Y, AccumulatorDefault},
    {OpcodeLDA, ModeAbsolute, N, A, AccumulatorA},
    {OpcodeLDX, ModeAbsolute, N, X, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteLong, N, A, AccumulatorA},

    {OpcodeBCS, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirectIndexedY, D | Y, A, AccumulatorA},
    {OpcodeLDA, ModeDirectIndirect, D, A, AccumulatorA},
    {OpcodeLDA, ModeStackRelativeIndirectIndexed, D | Y | S, Y, AccumulatorA},
    {OpcodeLDY, ModeDirectIndexedX, D | X, Y, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndexedX, D | X, A, AccumulatorA},
    {OpcodeLDX, ModeDirectIndexedY, D | Y, X, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirectLongIndexed, D | Y, A, AccumulatorA},
    {OpcodeCLV, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A, AccumulatorA},
    {OpcodeTSX, ModeImplied, X | S, X | S, AccumulatorDefault},
    {OpcodeTYX, ModeImplied, X | Y, X | Y, AccumulatorDefault},
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A, AccumulatorA},
    {OpcodeLDX, ModeAbsoluteIndexedY, Y, X, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteLongIndexed, X, A, AccumulatorA},

    {OpcodeCPY, ModeImmediate, Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndexedIndirect, A | D | X, N, AccumulatorA},
    {OpcodeCLP, ModeImmediate, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeStackRelative, A | D | S, N, AccumulatorA},
    {OpcodeCPY, ModeDirect, D | Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirect, A | D, N, AccumulatorA},
    {OpcodeDEC, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirectLong, A | D, N, AccumulatorA},
    {OpcodeINY, ModeImplied, Y, Y, AccumulatorDefault},
    {OpcodeCMP, ModeImmediate, A, N, AccumulatorA},
    {OpcodeDEX, ModeImplied, X, X, AccumulatorDefault},
    {OpcodeWIT, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeCPY, ModeAbsolute, Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsolute, A, N, AccumulatorA},
    {OpcodeDEC, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteLong, A, N, AccumulatorA},

    {OpcodeBNE, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirectIndexedY, A | D | Y, N, AccumulatorA},
    {OpcodeCMP, ModeDirectIndirect, A | D, N, AccumulatorA},
    {OpcodeCMP, ModeStackRelativeIndirectIndexed, A | D | Y | S, N,
     AccumulatorA},
    {OpcodePEI, ModeDirectIndirect, S, S, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndexedX, A | D | X, N, AccumulatorA},
    {OpcodeDEC, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirectLongIndexed, A | D | Y, N, AccumulatorA},
    {OpcodeCLM, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, N, AccumulatorA},
    {OpcodePHX, ModeStack, X, X | S, AccumulatorDefault},
    {OpcodeSTP, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeJMP, ModeAbsoluteIndirect, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, N, AccumulatorA},
    {OpcodeDEC, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteLongIndexed, A | X, N, AccumulatorA},

    {OpcodeCPX, ModeImmediate, X, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndexedIndirect, A | D | X, A, AccumulatorA},
    {OpcodeSEP, ModeImmediate, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeStackRelative, A | D | S, A, AccumulatorA},
    {OpcodeCPX, ModeDirect, X | D, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirect, A | D, A, AccumulatorA},
    {OpcodeINC, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirectLong, A | D, A, AccumulatorA},
    {OpcodeINX, ModeImplied, X, X, AccumulatorDefault},
    {OpcodeSBC, ModeImmediate, A, A, AccumulatorA},
    {OpcodeNOP, ModeImplied, N, N, AccumulatorDefault},
    {OpcodePSH, ModeImmediate, S | P, S | P, AccumulatorDefault},
    {OpcodeCPX, ModeAbsolute, X, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsolute, A, A, AccumulatorA},
    {OpcodeINC, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteLong, A, A, AccumulatorA},

    {OpcodeBEQ, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorA},
    {OpcodeSBC, ModeDirectIndirect, A | D, A, AccumulatorA},
    {OpcodeSBC, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorA},
    {OpcodePEA, ModeAbsolute, S, S, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndexedX, A | D | X, A, AccumulatorA},
    {OpcodeINC, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirectLongIndexed, A | D | Y, A, AccumulatorA},
    {OpcodeSEM, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A, AccumulatorA},
    {OpcodePLX, ModeStack, S, X | S, AccumulatorDefault},
    {OpcodePUL, ModeImmediate, S | P, S | P, AccumulatorDefault},
    {OpcodeJSR, ModeAbsoluteIndexedIndirect, X | S, S, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A, AccumulatorA},
    {OpcodeINC, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteLongIndexed, A | X, A, AccumulatorA}};

static const Opcode kOpcodeTable42[256] = {
    _,
    {OpcodeORA, ModeDirectIndexedIndirect, B | D | X, A, AccumulatorB},
    _,
    {OpcodeORA, ModeStackRelative, B | D | S, B, AccumulatorB},
    _,
    {OpcodeORA, ModeDirect, B | D, B, AccumulatorB},
    _,
    {OpcodeORA, ModeDirectIndirectLong, B | D, B, AccumulatorB},
    _,
    {OpcodeORA, ModeImmediate, B, B, AccumulatorB},
    {OpcodeASL, ModeAccumulator, B, B, AccumulatorB},
    _,
    _,
    {OpcodeORA, ModeAbsolute, B, B, AccumulatorB},
    _,
    {OpcodeORA, ModeAbsoluteLong, B, B, AccumulatorB},

    _,
    {OpcodeORA, ModeDirectIndirectIndexedY, B | D, B, AccumulatorB},
    {OpcodeORA, ModeDirectIndirect, B | D, B, AccumulatorB},
    {OpcodeORA, ModeStackRelativeIndirectIndexed, B | D | Y | S, B,
     AccumulatorB},
    _,
    {OpcodeORA, ModeDirectIndexedX, B | D | X, B, AccumulatorB},
    _,
    {OpcodeORA, ModeDirectIndirectLongIndexed, B | Y, B, AccumulatorB},
    _,
    {OpcodeORA, ModeAbsoluteIndexedY, B | Y, B, AccumulatorB},
    {OpcodeDEC, ModeAccumulator, B, B, AccumulatorB},
    {OpcodeTBS, ModeImplied, B, S, AccumulatorDefault},
    _,
    {OpcodeORA, ModeAbsoluteIndexedX, B | X, B, AccumulatorB},
    _,
    {OpcodeORA, ModeAbsoluteLongIndexed, B, B, AccumulatorB},

    _,
    {OpcodeAND, ModeDirectIndexedIndirect, B | D | X, B, AccumulatorB},
    _,
    {OpcodeAND, ModeStackRelativeIndirectIndexed, B | D | Y | S, B,
     AccumulatorB},
    _,
    {OpcodeAND, ModeDirect, B | D, B, AccumulatorB},
    _,
    {OpcodeAND, ModeDirectIndirectLong, A, A, AccumulatorB},
    _,
    {OpcodeAND, ModeImmediate, B, B, AccumulatorB},
    {OpcodeROL, ModeAccumulator, B, B, AccumulatorB},
    _,
    _,
    {OpcodeAND, ModeAbsolute, B, B, AccumulatorB},
    _,
    {OpcodeAND, ModeAbsoluteLong, B, B, AccumulatorB},

    _,
    {OpcodeAND, ModeDirectIndirectIndexedY, B | D | Y, B, AccumulatorB},
    {OpcodeAND, ModeDirectIndirect, B | D, B, AccumulatorB},
    {OpcodeAND, ModeStackRelativeIndirectIndexed, B | D | S | Y, B,
     AccumulatorB},
    _,
    {OpcodeAND, ModeDirectIndexedX, B | D | X, B, AccumulatorB},
    _,
    {OpcodeAND, ModeDirectIndirectLongIndexed, B | D | Y, B, AccumulatorB},
    _,
    {OpcodeAND, ModeAbsoluteIndexedY, B | Y, B, AccumulatorB},
    {OpcodeINC, ModeAccumulator, B, B, AccumulatorB},
    {OpcodeTSB, ModeImplied, S, B, AccumulatorDefault},
    _,
    {OpcodeAND, ModeAbsoluteIndexedX, B | X, B, AccumulatorB},
    _,
    {OpcodeAND, ModeAbsoluteLongIndexed, B | X, B, AccumulatorB},

    _,
    {OpcodeEOR, ModeDirectIndexedX, B | D | X, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeStackRelative, B | D | S, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeDirect, B | D, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeDirectIndirectLong, B | D, B, AccumulatorB},
    {OpcodePHB, ModeStack, B | S, S, AccumulatorDefault},
    {OpcodeEOR, ModeImmediate, B, B, AccumulatorB},
    {OpcodeLSR, ModeAccumulator, B, B, AccumulatorB},
    _,
    _,
    {OpcodeEOR, ModeAbsolute, B, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeAbsoluteLong, B, B, AccumulatorB},

    _,
    {OpcodeEOR, ModeDirectIndirectIndexedY, B | D | Y, B, AccumulatorB},
    {OpcodeEOR, ModeDirectIndirect, B | D, B, AccumulatorB},
    {OpcodeEOR, ModeStackRelativeIndirectIndexed, B | D | S | Y, B,
     AccumulatorB},
    _,
    {OpcodeEOR, ModeDirectIndexedX, B | D | X, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeDirectIndirectLongIndexed, B | D | Y, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeAbsoluteIndexedY, B | Y, B, AccumulatorB},
    _,
    {OpcodeTBD, ModeImplied, B, D, AccumulatorDefault},
    _,
    {OpcodeEOR, ModeAbsoluteIndexedX, B | X, B, AccumulatorB},
    _,
    {OpcodeEOR, ModeAbsoluteLongIndexed, B | X, B, AccumulatorB},

    _,
    {OpcodeADC, ModeDirectIndexedIndirect, N, N, AccumulatorB},
    _,
    {OpcodeADC, ModeStackRelative, B | D | S, B, AccumulatorB},
    _,
    {OpcodeADC, ModeDirect, B | D, B, AccumulatorB},
    _,
    {OpcodeADC, ModeDirectIndirectLong, B | D, B, AccumulatorB},
    {OpcodePLB, ModeStack, S, B | S, AccumulatorDefault},
    {OpcodeADC, ModeImmediate, B, B, AccumulatorB},
    {OpcodeROR, ModeAccumulator, B, B, AccumulatorB},
    _,
    _,
    {OpcodeADC, ModeAbsolute, B, B, AccumulatorB},
    _,
    {OpcodeADC, ModeAbsoluteLong, B, B, AccumulatorB},

    _,
    {OpcodeADC, ModeDirectIndirectIndexedY, B | D | Y, B, AccumulatorB},
    {OpcodeADC, ModeDirectIndirect, B | D, B, AccumulatorB},
    {OpcodeADC, ModeStackRelativeIndirectIndexed, B | D | Y | S, B,
     AccumulatorB},
    _,
    {OpcodeADC, ModeDirectIndexedX, B | D | X, B, AccumulatorB},
    _,
    {OpcodeADC, ModeDirectIndirectLongIndexed, B | D | Y, B, AccumulatorB},
    _,
    {OpcodeADC, ModeAbsoluteIndexedY, B | Y, B, AccumulatorB},
    _,
    {OpcodeTDB, ModeImplied, D, B, AccumulatorDefault},
    _,
    {OpcodeADC, ModeAbsoluteIndexedX, B | X, B, AccumulatorB},
    _,
    {OpcodeADC, ModeAbsoluteLongIndexed, B | X, B, AccumulatorB},

    _,
    {OpcodeSTA, ModeDirectIndexedIndirect, B | D | X, N, AccumulatorB},
    _,
    {OpcodeSTA, ModeStackRelative, B | D | S, N, AccumulatorB},
    _,
    {OpcodeSTA, ModeDirect, B | D, N, AccumulatorB},
    _,
    {OpcodeSTA, ModeDirectIndirectLong, B | D, N, AccumulatorB},
    _,
    _,
    {OpcodeTXB, ModeImplied, B | X, B | X, AccumulatorDefault},
    _,
    _,
    {OpcodeSTA, ModeAbsolute, B, N, AccumulatorB},
    _,
    {OpcodeSTA, ModeAbsoluteLong, B, N, AccumulatorB},

    _,
    {OpcodeSTA, ModeDirectIndirectIndexedY, B | D | Y, N, AccumulatorB},
    {OpcodeSTA, ModeDirectIndirect, B | D, N, AccumulatorB},
    {OpcodeSTA, ModeStackRelativeIndirectIndexed, B | D | Y | S, N,
     AccumulatorB},
    _,
    {OpcodeSTA, ModeDirectIndexedX, B | D | X, N, AccumulatorB},
    _,
    {OpcodeSTA, ModeDirectIndirectLongIndexed, B | D | Y, N, AccumulatorB},
    {OpcodeTYB, ModeImplied, B | Y, B | Y, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteIndexedY, B | Y, N, AccumulatorB},
    _,
    _,
    _,
    {OpcodeSTA, ModeAbsoluteIndexedX, B | X, N, AccumulatorB},
    _,
    {OpcodeSTA, ModeAbsoluteLongIndexed, B | X, N, AccumulatorB},

    _,
    {OpcodeLDA, ModeDirectIndexedX, D | X, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeStackRelative, D | S, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeDirect, D, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeDirectIndirectLong, D, B, AccumulatorB},
    {OpcodeTBY, ModeImplied, B | Y, B | Y, AccumulatorDefault},
    {OpcodeLDA, ModeImmediate, N, B, AccumulatorB},
    {OpcodeTBX, ModeImplied, B | X, B | X, AccumulatorDefault},
    _,
    _,
    {OpcodeLDA, ModeAbsolute, N, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeAbsoluteLong, N, B, AccumulatorB},

    _,
    {OpcodeLDA, ModeDirectIndirectIndexedY, D | Y, B, AccumulatorB},
    {OpcodeLDA, ModeDirectIndirect, D, B, AccumulatorB},
    {OpcodeLDA, ModeStackRelativeIndirectIndexed, D | Y | S, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeDirectIndexedX, D | X, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeDirectIndirectLongIndexed, D | Y, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, B, AccumulatorB},
    _,
    _,
    _,
    {OpcodeLDA, ModeAbsoluteIndexedX, X, B, AccumulatorB},
    _,
    {OpcodeLDA, ModeAbsoluteLongIndexed, X, B, AccumulatorB},

    _,
    {OpcodeCMP, ModeDirectIndexedIndirect, B | D | X, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeStackRelative, B | D | S, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeDirect, B | D, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeDirectIndirectLong, B | D, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeImmediate, B, N, AccumulatorB},
    _,
    _,
    _,
    {OpcodeCMP, ModeAbsolute, B, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeAbsoluteLong, B, N, AccumulatorB},

    _,
    {OpcodeCMP, ModeDirectIndirectIndexedY, B | D | Y, N, AccumulatorB},
    {OpcodeCMP, ModeDirectIndirect, B | D, N, AccumulatorB},
    {OpcodeCMP, ModeStackRelativeIndirectIndexed, B | D | Y | S, N,
     AccumulatorB},
    _,
    {OpcodeCMP, ModeDirectIndexedX, B | D | X, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeDirectIndirectLongIndexed, B | D | Y, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeAbsoluteIndexedY, B | Y, N, AccumulatorB},
    _,
    _,
    _,
    {OpcodeCMP, ModeAbsoluteIndexedX, B | X, N, AccumulatorB},
    _,
    {OpcodeCMP, ModeAbsoluteLongIndexed, B | X, N, AccumulatorB},

    _,
    {OpcodeSBC, ModeDirectIndexedIndirect, B | D | X, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeStackRelative, B | D | S, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeDirect, B | D, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeDirectIndirectLong, B | D, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeImmediate, B, B, AccumulatorB},
    _,
    _,
    _,
    {OpcodeSBC, ModeAbsolute, B, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeAbsoluteLong, B, B, AccumulatorB},

    _,
    {OpcodeSBC, ModeDirectIndirectIndexedY, B | D | Y, B, AccumulatorB},
    {OpcodeSBC, ModeDirectIndirect, B | D, B, AccumulatorB},
    {OpcodeSBC, ModeStackRelativeIndirectIndexed, B | D | Y | S, B,
     AccumulatorB},
    _,
    {OpcodeSBC, ModeDirectIndexedX, B | D | X, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeDirectIndirectLongIndexed, B | D | Y, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeAbsoluteIndexedY, B | Y, B, AccumulatorB},
    _,
    _,
    _,
    {OpcodeSBC, ModeAbsoluteIndexedX, B | X, B, AccumulatorB},
    _,
    {OpcodeSBC, ModeAbsoluteLongIndexed, B | X, B, AccumulatorB}};

static const Opcode kOpcodeTable89[256] = {
    _,
    {OpcodeMPY, ModeDirectIndexedIndirect, A | D | X, A | B,
     AccumulatorDefault},
    _,
    {OpcodeMPY, ModeStackRelative, A, A | B, AccumulatorDefault},
    _,
    {OpcodeMPY, ModeDirect, A | D, A | B, AccumulatorDefault},
    _,
    {OpcodeMPY, ModeDirectIndirectLong, A | D, A | B, AccumulatorDefault},
    _,
    {OpcodeMPY, ModeImmediate, A, A | B, AccumulatorDefault},
    _,
    _,
    _,
    {OpcodeMPY, ModeAbsolute, A, A | B, AccumulatorDefault},
    _,
    {OpcodeMPY, ModeAbsoluteLong, A, A | B, AccumulatorDefault},

    _,
    {OpcodeMPY, ModeDirectIndirectIndexedY, A | D | Y, A | B,
     AccumulatorDefault},
    {OpcodeMPY, ModeDirectIndirect, A | D, A | B, AccumulatorDefault},
    {OpcodeMPY, ModeStackRelativeIndirectIndexed, A | D | S | Y, A | B,
     AccumulatorDefault},
    _,
    {OpcodeMPY, ModeDirectIndexedX, A | D | X, A | B, AccumulatorDefault},
    _,
    {OpcodeMPY, ModeDirectIndirectLongIndexed, A | D | Y, A | B,
     AccumulatorDefault},
    _,
    {OpcodeMPY, ModeAbsoluteIndexedY, A | Y, A | B, AccumulatorDefault},
    _,
    _,
    _,
    {OpcodeMPY, ModeAbsoluteIndexedX, A | X, A | B, AccumulatorDefault},
    _,
    {OpcodeMPY, ModeAbsoluteLongIndexed, A | X, A | B, AccumulatorDefault},

    _,
    {OpcodeDIV, ModeDirectIndexedIndirect, A | B | D | X, A | B,
     AccumulatorDefault},
    _,
    {OpcodeDIV, ModeStackRelative, A | B | S, A | B, AccumulatorDefault},
    _,
    {OpcodeDIV, ModeDirect, A | B | D, A | B, AccumulatorDefault},
    _,
    {OpcodeDIV, ModeDirectIndirectLong, A | B | D, A | B, AccumulatorDefault},
    {OpcodeXAB, ModeImplied, A | B, A | B, AccumulatorDefault},
    {OpcodeDIV, ModeImmediate, A | B, A | B, AccumulatorDefault},
    _,
    _,
    _,
    {OpcodeDIV, ModeAbsolute, A | B, A | B, AccumulatorDefault},
    _,
    {OpcodeDIV, ModeAbsoluteLong, A | B, A | B, AccumulatorDefault},

    _,
    {OpcodeDIV, ModeDirectIndirectIndexedY, A | B | D | Y, A | B,
     AccumulatorDefault},
    {OpcodeDIV, ModeDirectIndirect, A | B | D, A | B, AccumulatorDefault},
    {OpcodeDIV, ModeStackRelativeIndirectIndexed, A | B | S | Y, A | B,
     AccumulatorDefault},
    _,
    {OpcodeDIV, ModeDirectIndexedX, A | B | D | X, A | B, AccumulatorDefault},
    _,
    {OpcodeDIV, ModeDirectIndexedIndirect, A | B | D | Y, A | B,
     AccumulatorDefault},
    _,
    {OpcodeDIV, ModeAbsoluteIndexedY, A | B | Y, A | B, AccumulatorDefault},
    _,
    _,
    _,
    {OpcodeDIV, ModeAbsoluteIndexedX, A | B | X, A | B, AccumulatorDefault},
    _,
    {OpcodeDIV, ModeAbsoluteLongIndexed, A | B | X, A | B, AccumulatorDefault},

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeRLA, ModeImmediate, A, A, AccumulatorDefault},
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    {OpcodeLDT, ModeImmediate, N, DBR, AccumulatorDefault},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,

    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _};

#undef _NO
#undef _NA
#undef _NR

#undef _

#pragma clang diagnostic pop
