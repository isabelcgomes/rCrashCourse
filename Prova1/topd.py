import markdown
import pdfkit

# Ler o conteúdo do arquivo Markdown
with open(r'C:\Users\Isabel Giannecchini\Desktop\SSD\rCrashCourse\Prova1\reprova.md', 'r', encoding='utf-8') as file:
    markdown_content = file.read()

# Converter o Markdown em HTML
html_content = markdown.markdown(markdown_content)

# Configurar opções para o PDF
options = {
    'page-size': 'A4',
    'margin-top': '0mm',
    'margin-right': '0mm',
    'margin-bottom': '0mm',
    'margin-left': '0mm',
}

# Converter HTML em PDF
pdfkit.from_string(html_content, r'C:\Users\Isabel Giannecchini\Desktop\SSD\rCrashCourse\Prova1\reprova.pdf', options=options)










from markdown2pdf import convert 