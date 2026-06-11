-- Emit LaTeX section commands with optional short titles for running headers.
-- Pandoc parses {short="..."} on headings but the stock LaTeX writer ignores it.

local CMDS = {
  'section', 'subsection', 'subsubsection', 'paragraph', 'subparagraph'
}

local function inlines_to_latex(inlines)
  local tex = pandoc.write(pandoc.Pandoc({ pandoc.Plain(inlines) }), 'latex')
  return (tex:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function latex_escape(s)
  return (s:gsub('\\', '\\textbackslash{}')
             :gsub('([#$%%&_{}])', '\\%1')
             :gsub('%^', '\\^{}')
             :gsub('~', '\\textasciitilde{}'))
end

function Header(el)
  local short = el.attr.attributes['short']
  if not short or not FORMAT:match('latex') then
    return el
  end

  local cmd = CMDS[el.level]
  if not cmd then
    return el
  end

  local unnumbered = ''
  for _, class in ipairs(el.attr.classes) do
    if class == 'unnumbered' then
      unnumbered = '*'
      break
    end
  end

  local title = inlines_to_latex(el.content)
  local label = ''
  if el.attr.identifier ~= '' then
    label = '\\label{' .. el.attr.identifier .. '}'
  end

  local line = '\\' .. cmd .. unnumbered .. '[' .. latex_escape(short) .. ']{' .. title .. '}' .. label
  return pandoc.RawBlock('latex', line .. '\n')
end
