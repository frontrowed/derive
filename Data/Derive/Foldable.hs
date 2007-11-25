{-
    This module is not written/maintained by the usual Data.Derive author.

    MAINTAINER: Twan van Laarhoven 
    EMAIL: "twanvl" ++ "@" ++ "gmail" ++ "." ++ "com"

    Please send all patches to this module to Neil (ndmitchell -at- gmail),
    and CC Twan.
-}

-- NOTE: Cannot be guessed as it relies on type information

module Data.Derive.Foldable(makeFoldable) where

import Language.Haskell.TH.All
import Data.DeriveTraversal


makeFoldable :: Derivation
makeFoldable = derivation derive "Foldable"

derive dat = traversalInstance1 foldrTraversal "Foldable" dat

foldrTraversal = defaultTraversalType
        { traversalName   = "foldr"
        , traversalFunc   = \n a -> l1 "flip" (l1 n a)
        , traversalPlus   = fail "variable used in multiple positions in a data type"
        , traverseTuple   =         foldr (.:) id'
        , traverseCtor    = const $ foldr (.:) id'
        , traverseFunc    = \pat rhs -> sclause [vr "f", vr "b", pat] (AppE rhs (vr "b"))
        }