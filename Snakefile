rule targets:
    input:
        "figuras/rgb.png",
        "datos/fechas_descargadas.csv"

rule descarga_safe:
    input:
        script = "scripts/descarga_safe.bash"
    output:
        file = "figuras/rgb.png"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}
        """

rule recorte_producto:
    input:
        script = "scripts/recorte_producto.R"
    output:
        file = "datos/fechas_descargadas.csv"
    conda:
        "environment.yml"
    shell:
        """
        R --no-save --no-restore < {input.script}
        """