/// \file c-types-codegen.cpp
///
/// \copyright 2026 The Fellowship of SML/NJ (https://smlnj.org)
/// All rights reserved.
///
/// \brief This file holds the implementations of the methods
/// for the types in the `CTypes` module.
///
/// \author John Reppy
///

#include "cfg.hpp"
#include "target-info.hpp"

namespace CTypes {

llvm::Type *C_void::toLLVM (smlnj::cfgcg::Context *cxt)
{
    return cxt->voidTy;
}

llvm::Type *C_float::toLLVM (smlnj::cfgcg::Context *cxt)
{
    return cxt->f32Ty;
}

llvm::Type *C_double::toLLVM (smlnj::cfgcg::Context *cxt)
{
    return cxt->f64Ty;
}

llvm::Type *C_long_double::toLLVM (smlnj::cfgcg::Context *cxt)
{
    assert (false && "long double not supported");
/* TODO */return nullptr;
}

llvm::Type *C_unsigned::toLLVM (smlnj::cfgcg::Context *cxt)
{
    switch (this->_v0) {
    case c_int::I_char: return cxt->i8Ty; break;
    case c_int::I_short: return cxt->i16Ty; break;
    case c_int::I_int: return cxt->i32Ty; break;
    case c_int::I_long:
        if (sizeof(long) == 32) { return cxt->i32Ty; }
        else { return cxt->i64Ty; }
        break;
    case c_int::I_long_long: return cxt->i64Ty; break;
    }
}

llvm::Type *C_signed::toLLVM (smlnj::cfgcg::Context *cxt)
{
    switch (this->_v0) {
    case c_int::I_char: return cxt->i8Ty; break;
    case c_int::I_short: return cxt->i16Ty; break;
    case c_int::I_int: return cxt->i32Ty; break;
    case c_int::I_long:
        if (sizeof(long) == 32) { return cxt->i32Ty; }
        else { return cxt->i64Ty; }
        break;
    case c_int::I_long_long: return cxt->i64Ty; break;
    }
}

llvm::Type *C_PTR::toLLVM (smlnj::cfgcg::Context *cxt)
{
    return cxt->ptrTy;
}

llvm::Type *C_ARRAY::toLLVM (smlnj::cfgcg::Context *cxt)
{
    return llvm::ArrayType::get(this->_v0->toLLVM(cxt), this->_v1);
}

llvm::Type *C_STRUCT::toLLVM (smlnj::cfgcg::Context *cxt)
{
/* TODO */return nullptr;
}

llvm::Type *C_UNION::toLLVM (smlnj::cfgcg::Context *cxt)
{
/* TODO */return nullptr;
}

llvm::FunctionType *c_proto::toLLVM (smlnj::cfgcg::Context *cxt)
{
    std::vector<llvm::Type *> paramTys(this->_v_paramTys.size());

    for (auto it : this->_v_paramTys) {
        paramTys.push_back (it->toLLVM(cxt));
    }

    return llvm::FunctionType::get (
        this->_v_retTy->toLLVM(cxt),
        paramTys,
        false);

}

} // namespace CTypes
