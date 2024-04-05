let $topTags := (
    let $tags := collection("Posts")//row/@Tags
    let $tagList := for $tag in $tags
                    return tokenize(substring-before(substring-after($tag, "&lt;"), "&gt;"), "&gt;")
    let $tagCounts := map:merge(
                        for $tag in $tagList
                        return map:entry($tag, 1)
                     )
    let $sortedTags := 
        for $tag in map:keys($tagCounts)
        let $count := map:get($tagCounts, $tag)
        order by xs:integer($count) descending
        return $tag
    return $sortedTags[position() <= 10]
)

let $questions :=
    for $question in collection("Posts")//row[@PostTypeId="1"]
    where some $tag in $topTags satisfies contains($question/@Tags, concat("&lt;", $tag, "&gt;"))
    order by xs:integer($question/@ViewCount) descending
    return (
        <question>
            <Body>{data($question/@Body)}</Body>
            <ViewCount>{data($question/@ViewCount)}</ViewCount>
        </question>
    )

return $questions[position() <= 100]
