(* ex12.sml
 *
 * COPYRIGHT (c) 2026 The Fellowship of SML/NJ (https://smlnj.org)
 * All rights reserved.
 *
 * Hand-crafted CFG to test raw C calls
 *
 *      double atan2 (double y, double x);
 *
 *)

structure Ex12 =
  struct

    local
      structure CTy = CTypes
      structure P = CFG_Prim
      structure C = CFG
      structure II = IntInf
      fun v id = LambdaVar.fromId id
      fun V id = C.VAR{name = v id}
      fun LAB id = C.LABEL{name = v id}
      fun mkParam (x : LambdaVar.lvar, ty : C.ty) = {name = x, ty = ty}
      val mkParams = List.map mkParam
      fun attrs bp = { (* cluster attrs *)
	      alignHP = 8, needsBasePtr = bp, hasTrapArith = false, hasRCC = false
	    }
      val f64Ty = C.FLTt{sz=64}
      val fn100 = C.Cluster{
            attrs = attrs false,
            frags = [
                C.Frag{
                    kind = C.STD_FUN,
                    lab = v 100,
                    params = mkParams [
                        (v 196, C.PTRt), (v 195, C.PTRt), (v 194, C.LABt),
                        (v 193, C.PTRt), (v 192, C.PTRt), (v 191, C.PTRt),
                        (v 190, C.PTRt), (v 189, f64Ty), (v 188, f64Ty)
                      ],
                    body = C.RCC{
                        reentrant = false,
                        linkage = "",
                        proto = {
                            conv = "",
                            retTy = CTy.C_double,
                            paramTys = [CTy.C_double, CTy.C_double]
                          },
                        args = [V 190, V 189, V 188],
                        results = [mkParam(v 200, f64Ty)],
                        live = [],
                        k = C.THROW(V 194,
                          [V 194, V 193, V 192, V 191, V 200],
                          [C.LABt, C.PTRt, C.PTRt, C.PTRt, f64Ty])
                      }
                  }
              ]
          }

    in
    val cu = {srcFile = "ex12.sml", entry = fn100, fns = []}
    end (* local *)

  end
