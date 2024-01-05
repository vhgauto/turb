rule targets:
    input:
        "figuras/rgb.png",
        "datos/fecha_actual.csv"

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
        script = "scripts/recorte_producto.R",
        file = "figuras/rgb.png"
    output:
        file = "datos/fecha_actual.csv"
    conda:
        "environment.yml"
    shell:
        """
        R --no-save --no-restore < {input.script}
        """