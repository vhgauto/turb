rule test_secreto:
    input:
        script = "scripts/test__007_OK.py"
    output:
        "salida/resultados.csv"
    conda:
        "environment.yml"
    shell:
        """
        python {input.script}
        """
