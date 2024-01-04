rule targets:
    input:
        "scripts/descarga_safe.py",
        "figuras/rgb.png"

rule descarga_safe:
    input:
        script = "scripts/descarga_safe.py"
    conda:
        "environment.yml"
    shell:
        """
        python {input.script}
        """

rule recorte_producto:
    input:
        script = "scripts/recorte_producto.R"
    output:
        "figuras/rgb.png"
    conda:
        "environment.yml"
    shell:
        """
        R --no-save --no-restore < {input.script}
        """