let $tags := collection("Posts")//row/@Tags
let $tagList := for $tag in $tags
                return substring-before(substring-after($tag, "&lt;"), "&gt;")
let $uniqueTags := distinct-values($tagList)
let $tagCounts := for $tag in $uniqueTags
                  return (
                      <tag>
                          <name>{$tag}</name>
                          <count>{count($tagList[. eq $tag])}</count>
                      </tag>
                  )
let $sortedTags := 
    for $tag in $tagCounts
    order by xs:integer($tag/count) descending
    return $tag
return $sortedTags
