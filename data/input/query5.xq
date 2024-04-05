let $questions :=
    for $question in collection("Posts")//row[@PostTypeId="1"]
    order by xs:integer($question/@Score) descending
    return
    (
        <question>
            <Title>{data($question/@Title)}</Title>
            <Body>{data($question/@Body)}</Body>
            <Tags>{data($question/@Tags)}</Tags>
            <Votes>{data($question/@Score)}</Votes>
            {
                let $answers := collection("Posts")//row[@PostTypeId="2" and @ParentId = $question/@Id]
                for $answer in $answers
                let $answerVotes := data($answer/@Score)
                return
                <answer>
                    <Body>{data($answer/@Body)}</Body>
                    <Votes>{$answerVotes}</Votes>
                </answer>
            }
        </question>
    )

return $questions[position() <= 10]
