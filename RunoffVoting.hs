module RunoffVoting where
import List
import Data.Maybe

llCandidateTollIx :: Eq a => [a] -> [[a]] -> [[Int]]
llCandidateTollIx lCandidate llCandidate = map (map toIxVote) llCandidate
	where
		toIxVote s = fromJust (elemIndex s lCandidate)

runoff :: Eq a => [a] -> [[a]] -> [a]
runoff lCandidate llCandidate = map (\x -> lCandidate !! x) (runoffIx (length lCandidate) (llCandidateTollIx lCandidate llCandidate))

runoffWeighted :: Eq a => [a] -> [(Double, [a])] -> [a]
runoffWeighted lCandidate llweightCandidate = map (\x -> lCandidate !! x) (runoffIxWeighted (length lCandidate) llweightixCandidate)
	where
		llweightixCandidate = zip weights llIx
		llIx = llCandidateTollIx lCandidate llCandidate
		(weights, llCandidate) = unzip llweightCandidate

runoffIx :: Int -> [[Int]] -> [Int]
runoffIx nCandidate llixCandidate = runoffIxWeighted nCandidate (map (\lix -> (1, lix)) llixCandidate) 

runoffIxWeighted :: Int -> [(Double,[Int])] -> [Int]
runoffIxWeighted nCandidates llweightixCandidate
	-- If we have someone with a majority, or if we have divided all remaining votes evenly, we have a tie
	| snd (head lMostVotes) > (nVotes / 2) || (snd (head lMostVotes)) == (nVotes / fromIntegral (length lMostVotes)) = map fst lMostVotes
	| otherwise = runoffIxWeighted nCandidates (dropCandidates (map fst lEliminiate) llweightixCandidate)
	where
		(nVotes, lMostVotes, lEliminiate) = countSummary nCandidates llweightixCandidate


dropCandidates :: [Int] -> [(Double, [Int])] -> [(Double, [Int])]
dropCandidates lixToDrop llweightixCandidate = map (\(nWeight, lix) -> (nWeight, filter (\ix -> notElem ix lixToDrop) lix)) llweightixCandidate

countSummary :: Int -> [(Double,[Int])] -> (Double, [(Int, Double)], [(Int, Double)])
countSummary nCandidates llweightixCandidate = (nVotesTotal, lMostVotes, lEliminiate)
	where
		lMostVotes = filter (\(n,nVotes) -> nVotes == nVotesMost) lVotes
		lEliminiate = filter (\(n,nVotes) -> nVotes <= nVotesLeast) lVotes -- Drop you if you have either zero votes or min votes this round
		nVotesMost = maximum lnVotes
		nVotesLeast = minimum (filter (/= 0) lnVotes) -- Ignore people with 0 votes this round, we drop them automatically
		lnVotes = nub $ map snd lVotes
		(nVotesTotal, lVotes) = countVotes nCandidates llweightixCandidate
		

countVotes :: Int -> [(Double,[Int])] -> (Double, [(Int, Double)])
countVotes nCandidates llweightixCandidate 
	| [] == llweightixCandidate = (0.0, [(n, 0) | n <- [0..nCandidates - 1]])
	| [] == (snd (head llweightixCandidate)) = countVotes nCandidates (tail llweightixCandidate) 
	| otherwise = (nVotesNext + (fst thisVote), [(n, x + (if (head (snd thisVote)) == n then (fst thisVote) else 0)) | (n, x) <- countVotesNext])
	where
		(nVotesNext, countVotesNext) = countVotes nCandidates (tail llweightixCandidate)
		thisVote = head llweightixCandidate
