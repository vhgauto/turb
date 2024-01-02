rule descarga_xml:
    input:
        script = "scripts/test__007_OK.py"
    output:
        file = "MTD_MSIL2A.xml"
    conda:
        "environment.yml"
    shell:
        """
        python {input.script}
        """
