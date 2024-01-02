rule targets:
    input:
        "scripts/test__007_OK.py"

rule test_secreto:
    input:
        script = "scripts/test__007_OK.py"
    conda:
        "environment.yml"
    shell:
        """
        {input.script}
        """
