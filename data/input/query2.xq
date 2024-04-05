let $userIds := distinct-values(collection("Posts")//row[@PostTypeId="1"]/@OwnerUserId)
for $userId in $userIds[position() <= 100]
let $userDetails := /users/row[@Id = $userId]
let $displayName := $userDetails/@DisplayName
let $questionCount := count(collection("Posts")//row[@PostTypeId="1" and @OwnerUserId = $userId])
order by xs:integer($questionCount) descending
let $sortedResults := (
    <user>
        <UserId>{$userId}</UserId>
        <UserName>{$displayName}</UserName>
        <questionCount>{$questionCount}</questionCount>
    </user>
)
return $sortedResults
