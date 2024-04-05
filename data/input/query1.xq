for $question in collection("Posts")//row[@PostTypeId="1"]
let $title := $question/@Title
let $viewCount := $question/@ViewCount
order by xs:integer($viewCount) descending
return (
  <question>
    <title>{$title}</title>
    <viewCount>{$viewCount}</viewCount>
  </question>
)

