{-# LANGUAGE TemplateHaskell #-}

-- | This module exports version information about the Futhark
-- compiler.
module Futhark.Version
  ( version,
    versionString,
  )
where

import Data.Version
import GitHash
import qualified Paths_futhark

{-# NOINLINE version #-}

-- | The version of Futhark that we are using.  This is equivalent to
-- the version defined in the .cabal file.
version :: Version
version = Paths_futhark.version

{-# NOINLINE versionString #-}

-- | The version of Futhark that we are using, as a 'String'
versionString :: String
versionString =
  showVersion version
    ++ gitversion $$tGitInfoCwdTry
  where
    gitversion (Left _) = ""
    gitversion (Right gi) =
      concat
        [ "\n",
          "git: ",
          branch,
          take 7 $ giHash gi,
          " (",
          giCommitDate gi,
          ")",
          dirty
        ]
      where
        branch
          | giBranch gi == "master" = ""
          | otherwise = giBranch gi ++ " @ "
        dirty = if giDirty gi then " [modified]" else ""
