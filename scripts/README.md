DBT wrapper script

This PowerShell wrapper sets DBT_PROFILES_DIR to the project's local `.dbt` folder
so you can run `dbt` commands from the repository root without specifying
`--profiles-dir` each time.


Usage (PowerShell):

    # Run debug (default). The script will automatically choose a project dir
    # (prefers dbt_fundamentals, falls back to jaffle_shop).
    .\scripts\dbt.ps1

    # Run any dbt command (arguments forwarded). The wrapper will also pass
    # a matching --project-dir so you don't need to add it manually.
    .\scripts\dbt.ps1 run --models my_model

The script prefers `dbt_fundamentals/.dbt` and `dbt_fundamentals/dbt_project.yml` if present, otherwise it falls back to
the `jaffle_shop` project.
