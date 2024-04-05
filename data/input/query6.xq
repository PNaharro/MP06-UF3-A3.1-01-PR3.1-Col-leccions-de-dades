let $userIds := distinct-values(collection("Posts")//row[@PostTypeId="2"]/@OwnerUserId)
for $userId in $userIds[position() <= 100]
let $userDetails := /users/row[@Id = $userId]
let $displayName := $userDetails/@DisplayName
let $answerCount := count(collection("Posts")//row[@PostTypeId="2" and @OwnerUserId = $userId])
order by xs:integer($answerCount) descending
let $sortedResults := (
    <user>
        <UserId>{$userId}</UserId>
        <UserName>{$displayName}</UserName>
        <answerCount>{$answerCount}</answerCount>
    </user>
)
return $sortedResults