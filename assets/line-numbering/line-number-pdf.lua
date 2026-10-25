-- Wrap ::: {.line-numbers} blocks in a LaTeX lineno environment.
-- This numbers true rendered lines in PDF, including auto-wrapped lines.

local function has_class(classes, class_name)
  for _, c in ipairs(classes) do
    if c == class_name then
      return true
    end
  end
  return false
end

function Div(div)
  if not FORMAT:match("latex") then
    return nil
  end

  if not has_class(div.classes, "line-numbers") and not has_class(div.classes, "line-number") then
    return nil
  end

  return {
    pandoc.RawBlock("latex", "\\begin{LineNumberBlock}"),
    pandoc.Div(div.content, div.attr),
    pandoc.RawBlock("latex", "\\end{LineNumberBlock}")
  }
end
