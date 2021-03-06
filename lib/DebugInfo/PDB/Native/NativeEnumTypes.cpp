//==- NativeEnumTypes.cpp - Native Type Enumerator impl ----------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DebugInfo/PDB/Native/NativeEnumTypes.h"

#include "llvm/DebugInfo/PDB/IPDBEnumChildren.h"
#include "llvm/DebugInfo/PDB/Native/NativeSession.h"
#include "llvm/DebugInfo/PDB/Native/NativeTypeEnum.h"
#include "llvm/DebugInfo/PDB/PDBSymbol.h"
#include "llvm/DebugInfo/PDB/PDBSymbolTypeEnum.h"

namespace llvm {
namespace pdb {

NativeEnumTypes::NativeEnumTypes(NativeSession &PDBSession,
                                 codeview::LazyRandomTypeCollection &Types,
                                 codeview::TypeLeafKind Kind)
    : Matches(), Index(0), Session(PDBSession) {
  for (auto Index = Types.getFirst(); Index;
       Index = Types.getNext(Index.getValue())) {
    if (Types.getType(Index.getValue()).kind() == Kind)
      Matches.push_back(Index.getValue());
  }
}

NativeEnumTypes::NativeEnumTypes(
    NativeSession &PDBSession, const std::vector<codeview::TypeIndex> &Matches,
    codeview::TypeLeafKind Kind)
    : Matches(Matches), Index(0), Session(PDBSession) {}

uint32_t NativeEnumTypes::getChildCount() const {
  return static_cast<uint32_t>(Matches.size());
}

std::unique_ptr<PDBSymbol>
NativeEnumTypes::getChildAtIndex(uint32_t Index) const {
  if (Index < Matches.size()) {
    SymIndexId Id =
        Session.getSymbolCache().findSymbolByTypeIndex(Matches[Index]);
    return Session.getSymbolCache().getSymbolById(Id);
  }
  return nullptr;
}

std::unique_ptr<PDBSymbol> NativeEnumTypes::getNext() {
  return getChildAtIndex(Index++);
}

void NativeEnumTypes::reset() { Index = 0; }

} // namespace pdb
} // namespace llvm
