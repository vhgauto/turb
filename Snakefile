rule targets:
    input:
        "scripts/test__007_OK.py"

rule test_secreto:
    input:
        script = "scripts/run.bash"
    output:
        "salida/resultados.csv"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}
        """
