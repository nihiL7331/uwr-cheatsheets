import os
import sys
import subprocess
import tomllib
from pathlib import Path


def main():
    repo_root = Path(__file__).resolve().parent.parent.parent
    fonts_dir = repo_root / "fonts"
    groups = ["letnie", "obowiazki"]

    failures = []

    # 1. Discover subject directories
    subject_dirs = []
    for group in groups:
        group_path = repo_root / group
        if group_path.is_dir():
            for entry in group_path.iterdir():
                if entry.is_dir() and (entry / ".meta.toml").is_file():
                    subject_dirs.append(entry)

    subject_dirs.sort()

    if not subject_dirs:
        print("No subject directories with .meta.toml files found.")
        sys.exit(0)

    print(f"Found {len(subject_dirs)} subject directories to process.")

    # 2. Iterate through each subject
    for subject_dir in subject_dirs:
        print(f"\n========================================\nProcessing subject: {
              subject_dir.name}\n========================================")
        meta_path = subject_dir / ".meta.toml"

        # Load .meta.toml file
        try:
            with open(meta_path, "rb") as f:
                config = tomllib.load(f)
        except Exception as e:
            err_msg = f"[{subject_dir.name}] Failed to parse .meta.toml file as TOML: {
                e}"
            print(f"Error: {err_msg}", file=sys.stderr)
            failures.append(err_msg)
            continue

        # 3. Process each build target (section) inside .meta
        for target_name, target_config in config.items():
            print(f"\n--- Target: {target_name} ---")

            # Key checks
            source = target_config.get("source")
            output = target_config.get("output")
            range_str = target_config.get("range")
            inputs = target_config.get("inputs")

            # Validation: source key
            if source is None or not isinstance(source, str):
                err_msg = f"[{subject_dir.name} : {
                    target_name}] 'source' key is missing or not a string"
                print(f"Validation Error: {err_msg}", file=sys.stderr)
                failures.append(err_msg)
                continue

            # Validation: output key
            if output is None or not isinstance(output, str):
                err_msg = f"[{subject_dir.name} : {
                    target_name}] 'output' key is missing or not a string"
                print(f"Validation Error: {err_msg}", file=sys.stderr)
                failures.append(err_msg)
                continue

            # Validation: source file existence
            source_path = subject_dir / source
            if not source_path.is_file():
                err_msg = f"[{subject_dir.name} : {target_name}] Source file '{
                    source}' does not exist on disk"
                print(f"Validation Error: {err_msg}", file=sys.stderr)
                failures.append(err_msg)
                continue

            # Validation: range parsing
            is_ranged = False
            lo, hi = None, None

            if "range" in target_config:
                if not isinstance(range_str, str):
                    err_msg = f"[{subject_dir.name} : {
                        target_name}] 'range' must be a string (e.g. 'lo..hi')"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

                parts = range_str.split("..")
                if len(parts) != 2:
                    err_msg = f"[{subject_dir.name} : {
                        target_name}] 'range' must be in format 'lo..hi', got '{range_str}'"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

                try:
                    lo = int(parts[0])
                    hi = int(parts[1])
                except ValueError:
                    err_msg = f"[{subject_dir.name} : {
                        target_name}] 'range' bounds must be integers, got '{range_str}'"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

                if lo < 1:
                    err_msg = f"[{subject_dir.name} : {
                        target_name}] 'range' lower bound must be >= 1, got {lo}"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

                if lo > hi:
                    err_msg = f"[{subject_dir.name} : {target_name}] 'range' lower bound {
                        lo} cannot be greater than upper bound {hi}"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

                is_ranged = True

            # Validation: output placeholder match with range presence
            has_n_placeholder = "{n}" in output

            if has_n_placeholder and not is_ranged:
                err_msg = f"[{subject_dir.name} : {
                    target_name}] 'output' contains '{{n}}' but 'range' is missing"
                print(f"Validation Error: {err_msg}", file=sys.stderr)
                failures.append(err_msg)
                continue

            if not has_n_placeholder and is_ranged:
                err_msg = f"[{subject_dir.name} : {
                    target_name}] 'range' is defined but 'output' does not contain '{{n}}'"
                print(f"Validation Error: {err_msg}", file=sys.stderr)
                failures.append(err_msg)
                continue

            # Set default inputs if not provided
            if inputs is None:
                inputs = ["od", "do"] if is_ranged else []
            else:
                if not isinstance(inputs, list) or not all(isinstance(x, str) for x in inputs):
                    err_msg = f"[{subject_dir.name} : {
                        target_name}] 'inputs' must be a list of strings"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

            # Parse and validate schemes key
            schemes = target_config.get("schemes")
            if schemes is None:
                schemes = [None]
            else:
                if not isinstance(schemes, list) or not all(isinstance(x, str) for x in schemes):
                    err_msg = f"[{subject_dir.name} : {
                        target_name}] 'schemes' must be a list of strings"
                    print(f"Validation Error: {err_msg}", file=sys.stderr)
                    failures.append(err_msg)
                    continue

            # 4. Compilation execution
            if not is_ranged:
                # Single compile target
                for scheme in schemes:
                    output_path = subject_dir / output
                    if scheme is not None:
                        output_path = output_path.parent / f"{scheme}_{output_path.name}"
                    output_path.parent.mkdir(parents=True, exist_ok=True)

                    cmd = [
                        "typst", "compile",
                        "--ignore-system-fonts",
                        "--font-path", str(fonts_dir),
                    ]
                    if scheme is not None:
                        cmd.extend(["--input", f"scheme={scheme}"])
                    cmd.extend([str(source_path), str(output_path)])

                    print(f"Compiling{f' (scheme={scheme})' if scheme is not None else ''}: {' '.join(cmd)}")
                    res = subprocess.run(cmd, capture_output=True, text=True)

                    if res.stdout:
                        print(res.stdout, end="")
                    if res.stderr:
                        print(res.stderr, end="", file=sys.stderr)

                    if "unknown font family" in res.stderr:
                        err_msg = f"[{subject_dir.name} : {
                            target_name}] Compilation failed due to unknown font family"
                        if scheme is not None:
                            err_msg += f" (scheme: {scheme})"
                        failures.append(err_msg)
                    elif res.returncode != 0:
                        err_msg = f"[{subject_dir.name} : {
                            target_name}] Compilation failed with exit code {res.returncode}"
                        if scheme is not None:
                            err_msg += f" (scheme: {scheme})"
                        failures.append(err_msg)
            else:
                # Ranged compile target
                for n in range(lo, hi + 1):
                    n_padded = f"{n:02d}"
                    output_resolved = output.replace("{n}", n_padded)
                    for scheme in schemes:
                        output_path = subject_dir / output_resolved
                        if scheme is not None:
                            output_path = output_path.parent / f"{scheme}_{output_path.name}"
                        output_path.parent.mkdir(parents=True, exist_ok=True)

                        cmd = [
                            "typst", "compile",
                            "--ignore-system-fonts",
                            "--font-path", str(fonts_dir),
                        ]
                        if scheme is not None:
                            cmd.extend(["--input", f"scheme={scheme}"])

                        # Add input flags
                        for param in inputs:
                            if param == "od":
                                cmd.extend(["--input", "od=1"])
                            elif param == "do":
                                cmd.extend(["--input", f"do={n}"])

                        cmd.extend([str(source_path), str(output_path)])

                        print(f"Compiling (n={n_padded}{f', scheme={scheme}' if scheme is not None else ''}): {' '.join(cmd)}")
                        res = subprocess.run(cmd, capture_output=True, text=True)

                        if res.stdout:
                            print(res.stdout, end="")
                        if res.stderr:
                            print(res.stderr, end="", file=sys.stderr)

                        if "unknown font family" in res.stderr:
                            err_msg = f"[{subject_dir.name} : {target_name}] Compilation failed for n={
                                n} due to unknown font family"
                            if scheme is not None:
                                err_msg += f" (scheme: {scheme})"
                            failures.append(err_msg)
                        elif res.returncode != 0:
                            err_msg = f"[{subject_dir.name} : {target_name}] Compilation failed for n={
                                n} with exit code {res.returncode}"
                            if scheme is not None:
                                err_msg += f" (scheme: {scheme})"
                            failures.append(err_msg)

    # 5. Report and exit
    if failures:
        print("\n========================")
        print("BUILD FAILED: The following errors occurred:", file=sys.stderr)
        for fail in failures:
            print(f"  - {fail}", file=sys.stderr)
        print("==========================")
        sys.exit(1)
    else:
        print("\n==========================")
        print("BUILD SUCCESSFUL!")
        print("==========================")
        sys.exit(0)


if __name__ == "__main__":
    main()
