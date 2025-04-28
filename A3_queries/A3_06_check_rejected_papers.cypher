//A3_06_check_rejected_papers

MATCH (p:Paper)
WITH p, COUNT{(p)<-[:REVIEWED]-()} AS total_reviews,
     COUNT{(p)<-[:REVIEWED {suggested_acceptance: false}]-()} AS negative_reviews
WHERE total_reviews > 0 AND negative_reviews/total_reviews > 0.5  // Majority check (> 50%)
RETURN p.id, p.title, total_reviews, negative_reviews, 
       toFloat(negative_reviews)/total_reviews AS rejection_ratio
ORDER BY rejection_ratio DESC;