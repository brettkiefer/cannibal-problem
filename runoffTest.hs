module Main where
import System.Environment
import Char
import List
import Data.Maybe
import RunoffVoting

main = do
	args <- getArgs
	sFile <- readFile (head args)
	let election = parseRunoff sFile
	putStrLn $ "Election: " ++ (show election)
	putStrLn $ "Winner(s): " ++ (show (runoff (fst election) (snd election)))

parseRunoff :: String -> ([String], [(Double, [String])])
parseRunoff s = (lsCandidate, llsVote)
	where
		"Candidates:":lsCandidate = words (head lsLine)
		llsWeightedVote = map (\line -> (read head line, tail line) 
		llsVote = map words (tail lsLine)
		lsLine = lines s
