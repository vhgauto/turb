rule targets:
    input:
        "scripts/test__007_OK.py"

rule test_secreto:
    input:
        script = "scripts/test__007_OK.py"
    output:
        "resultados.csv"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}
        """
