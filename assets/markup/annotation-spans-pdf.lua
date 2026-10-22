-- Map semantic span classes to LaTeX macros for PDF/LaTeX output.
-- Other formats keep the original span classes for CSS-based rendering.

local is_latex_output = FORMAT:match("latex") or FORMAT:match("pdf")

if not is_latex_output then
  return {}
end

local class_to_macro = {
  ["ann-highlight"] = "annhighlight",
  ["ann-premise"] = "annpremise",
  ["ann-conclusion"] = "annconclusion",
  ["ann-key"] = "annkey",
  ["ann-doubt"] = "anndoubt",
  ["ann-marginal"] = "annmarginal",
}

local function escape_latex(text)
  local replacements = {
    ["\\"] = "\\textbackslash{}",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["$"] = "\\$",
    ["&"] = "\\&",
    ["%"] = "\\%",
    ["#"] = "\\#",
    ["_"] = "\\_",
    ["~"] = "\\textasciitilde{}",
    ["^"] = "\\textasciicircum{}",
  }

  return (text:gsub("[\\{}$&%%#_~^]", replacements))
end

function Span(el)
  for _, class_name in ipairs(el.classes) do
    local macro_name = class_to_macro[class_name]
    if macro_name then
      local wrapped = {
        pandoc.RawInline("latex", "\\" .. macro_name .. "{"),
      }
      for _, inline in ipairs(el.content) do
        wrapped[#wrapped + 1] = inline
      end

      if class_name == "ann-marginal" then
        local note_text = el.attributes["data-note"] or ""
        wrapped[#wrapped + 1] = pandoc.RawInline("latex", "}{" .. escape_latex(note_text) .. "}")
      else
        wrapped[#wrapped + 1] = pandoc.RawInline("latex", "}")
      end

      return wrapped
    end
  end

  return nil
end
