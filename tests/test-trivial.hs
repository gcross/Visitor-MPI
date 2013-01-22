-- Language extensions {{{
{-# LANGUAGE UnicodeSyntax #-}
-- }}}

-- Imports {{{
import Control.Monad.Trans.Visitor.Parallel.MPI
-- }}}

main =
    (runMPI $
        runVisitor
            (return Nothing)
            (const $ return ())
            (return [()])
    ) >>= (\x → case x of
        Nothing → return ()
        Just (Aborted progress) → error $ "Visitor aborted with progress " ++ show progress ++ "."
        Just (Completed [()]) → putStrLn $ "Trivial search completed successfully."
        Just (Completed result) → error $ "Result was " ++ show result ++ " not [()]."
        Just (Failure description) → error $ "Visitor failed with reason " ++ show description ++ "."
    )