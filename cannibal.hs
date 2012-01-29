module Main where
import System.Environment
import Char
import List
import RunoffVoting
import Maybe
import Data.Ord

data Cannibal = Cannibal { name :: String, weight :: Double } deriving (Eq)
instance Show Cannibal where
	show (Cannibal name weight) = name ++ " (" ++ show weight ++ " lbs)"

main = do
	args <- getArgs
	let pv s = if (last args == "v") then putStrLn s else return ()
	sFile <- readFile (head args)
	let cannibals = map parseCannibal (lines sFile)
	pv $ "Cannibals:\n" ++ (show cannibals) ++ "\n"
	let lRound = concat [combinations n cannibals | n <- [1..length cannibals]]
	pv $ "Rounds:\n " ++ showLL show lRound
	let lSolvedRound = map (solveRound lSolvedRound) lRound
	pv $ "Benefits:\n" ++ showLL showTTL lSolvedRound
	let lCannibalTTL = reverse $ sortBy (comparing snd) (last lSolvedRound)
	putStrLn $ "Time to live:\n" ++ unlines (map showTTL lCannibalTTL)

parseCannibal :: String -> Cannibal
parseCannibal sLine = Cannibal sName dWeight
	where
		sName = head $ words sLine
		dWeight = read $ head $ tail $ words sLine

showLL fx ll = unlines (map ((joinStr ", ") . (map fx)) ll)
joinStr sTween = foldl1 (\s1 s2 -> s1 ++ sTween ++ s2)

showTTL :: (Cannibal, Double) -> String
showTTL (c, ttl) = show c ++ " lives " ++ show ttl ++ " days"

solveRound :: [[(Cannibal, Double)]] -> [Cannibal] -> [(Cannibal, Double)]
solveRound lSolvedRound lCannibal
	| length lCannibal == 1 = [(head lCannibal, 0)]
	| otherwise = map (\c -> (c, benefitFrom (cannibalToEat, getBenefit survivors) c)) lCannibal
	where
		survivors = delete cannibalToEat lCannibal -- Fixme we're just picking the first loser
		cannibalToEat = head $ runoffWeighted lCannibal (map (weightedVotes lCannibal) lCannibal)
		weightedVotes lC cannibal = (weight cannibal, map fst (rankedRounds lC cannibal))
		rankedRounds lC cannibal = reverse $ sortBy (comparing snd) (roundsWithBenefits lC cannibal)
		roundsWithBenefits lC cannibal = (map (\(c,r) -> (c, benefitFrom (c,r) cannibal)) (lOptionsWithBenefits lC))
		lOptionsWithBenefits lC = map (\(x,y) -> (x, getBenefit y)) (lOptions lC)
		lOptions lC = map (\x -> (x, delete x lC)) lC
		getBenefit lC = fromJust $ find (\l -> map fst l == lC) lSolvedRound -- get from the cache of previous rounds

benefitFrom :: (Cannibal, [(Cannibal, Double)]) -> Cannibal -> Double
benefitFrom (cannibalToEat, roundWithBenefits) cannibal
	| isNothing inNext = 0
	--	| otherwise = fromJust inNext + (weight cannibalToEat) / sum (map (\p -> (weight (fst p) / 100)) roundWithBenefits) --everyone eats 1% their body weight every day
	| otherwise = fromJust inNext + (weight cannibalToEat) / fromIntegral (length roundWithBenefits) --every eats 1 lb of food per day
	where
		inNext = lookup cannibal roundWithBenefits

-- Just gives all n-length combinations from the list
-- From http://www.haskell.org/haskellwiki/99_questions/21_to_28
combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [ [] ]
combinations n xs = [ y:ys | y:xs' <- tails xs, ys <- combinations (n-1) xs']
