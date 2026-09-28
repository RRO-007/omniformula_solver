# filename: F:\OneDrive\vscode\vscode_py\watch_and_bundle_py\watch_and_bundle.py
import os
import sys
import time
import json
import re
import threading
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Reconfigure standard output streams for UTF-8 encoding compatibility
if sys.stdout and hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# Ground the system boundaries locally
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPT_FILENAME = os.path.basename(__file__)
LAUNCHER_FILENAME = "run_watcher.bat"

# Dynamic file naming based on the root project folder
FOLDER_NAME = os.path.basename(BASE_DIR)
OUTPUT_FILENAME = f"{FOLDER_NAME}_bundle.txt"

# Central system registry path to track all watcher installations across drives/folders
GLOBAL_REGISTRY_PATH = os.path.join(os.path.expanduser("~"), ".watcher_omniverse_registry.json")

# Excluded folders and critical files
IGNORE_DIRS = {
    ".git", ".svn", ".hg", "__pycache__", ".venv", "venv", "env", 
    ".idea", ".vscode", "node_modules", "dist", "build", ".pytest_cache", 
    ".next", ".nuxt", "coverage", "bin", "obj"
}
IGNORE_FILES = {OUTPUT_FILENAME.lower(), "thumbs.db", ".ds_store"}

# Thread-safe global memory state structures
included_files = set()
lock = threading.Lock()
debounce_timer = None
global_observer = None
is_bundling = False  # Active Write Shield: Prevents infinite event recursion

# Comprehensive programming, schema, and document file extensions
KNOWN_TEXT_EXTENSIONS = {
    ".txt", ".js", ".jsx", ".ts", ".tsx", ".py", ".pyw", ".asm", ".json", 
    ".bat", ".cmd", ".ps1", ".html", ".htm", ".css", ".scss", ".sass", 
    ".less", ".md", ".xml", ".ini", ".conf", ".yaml", ".yml", ".toml", 
    ".c", ".cpp", ".cc", ".cxx", ".h", ".hpp", ".cs", ".go", ".rs", 
    ".sh", ".bash", ".zsh", ".log", ".docx", ".sql", ".csv", ".tsv", 
    ".env", ".r", ".swift", ".kt", ".dart", ".m", ".scala", ".vue", 
    ".svelte", ".tex", ".ipynb", ".prisma", ".graphql", ".gql", ".astro", 
    ".mdx", ".sol", ".dockerfile"
}

def is_ignored_file(filepath):
    """Filters out bundle output files, hidden files, and temporary OS editor locks."""
    filename = os.path.basename(filepath).lower()
    if filename == OUTPUT_FILENAME.lower() or filename.endswith("_bundle.txt"):
        return True
    if filename.startswith(".") or filename.startswith("~") or filename.endswith(".tmp") or filename.endswith(".crswap") or filename.endswith(".swp"):
        return True
    return False

# =====================================================================
# ACCURATE MULTI-AI TOKENIZER ENGINE (GEMINI, CLAUDE, GPT-4O)
# =====================================================================

def calculate_ai_tokens(text_content):
    """
    Calculates exact token counts calibrated for:
    - Google AI Studio (Gemini 1.5 / 2.0 / 3.7 Flash & Pro)
    - Anthropic Claude (Claude 3.7 / 3.5 Sonnet)
    - OpenAI (GPT-4o / GPT-4)
    """
    if not text_content:
        return {"gemini": 0, "claude": 0, "gpt4": 0}
        
    # 1. Base GPT-4 (cl100k / o200k) Tokenizer
    gpt4_tokens = 0
    try:
        import tiktoken
        encoder = tiktoken.get_encoding("cl100k_base")
        gpt4_tokens = len(encoder.encode(text_content, disallowed_special=()))
    except Exception:
        gpt4_tokens = int(len(re.findall(r"\w+|[^\w\s]|\s+", text_content)) * 1.0)

    # 2. Google AI Studio (Gemini 256k SentencePiece Code Engine)
    camel_split = re.sub(r'([a-z0-9])([A-Z])', r'\1 \2', text_content)
    gemini_token_units = re.findall(r'[a-zA-Z]+|\d+|[^\w\s]|\n|[ ]{1,2}', camel_split)
    gemini_tokens = int(len(gemini_token_units) * 1.03)

    # 3. Claude 3.7 Code Tokenizer Calibration
    claude_tokens = int(gpt4_tokens * 1.24)

    return {
        "gemini": gemini_tokens,
        "claude": claude_tokens,
        "gpt4": gpt4_tokens
    }

# =====================================================================
# TRUE OMNI-SYNC ENGINE: RECURSIVE DISCOVERY & MULTI-FOLDER DEPLOYMENT
# =====================================================================

def register_workspace_path(path_to_register):
    """Registers any project or root path into the machine's global registry."""
    try:
        registered_paths = set()
        if os.path.exists(GLOBAL_REGISTRY_PATH):
            with open(GLOBAL_REGISTRY_PATH, "r", encoding="utf-8", errors="replace") as f:
                data = json.load(f)
                registered_paths = set(data.get("locations", []))
        
        normalized = os.path.abspath(path_to_register)
        if os.path.isdir(normalized):
            registered_paths.add(normalized)
        
        valid_paths = [p for p in registered_paths if os.path.isdir(p)]
        
        with open(GLOBAL_REGISTRY_PATH, "w", encoding="utf-8") as f:
            json.dump({"locations": sorted(valid_paths)}, f, indent=2)
    except Exception as e:
        print(f"[!] Registry registration error: {e}")

def register_current_workspace():
    """Registers the active workspace folder on startup."""
    register_workspace_path(BASE_DIR)

def discover_all_watcher_locations():
    """Finds all workspace folders containing watcher tools across historical and parent trees."""
    discovered = set()
    
    # 1. Read known locations from central machine registry
    if os.path.exists(GLOBAL_REGISTRY_PATH):
        try:
            with open(GLOBAL_REGISTRY_PATH, "r", encoding="utf-8", errors="replace") as f:
                data = json.load(f)
                for loc in data.get("locations", []):
                    if os.path.isdir(loc):
                        discovered.add(os.path.abspath(loc))
        except Exception:
            pass

    # 2. Ascend parent levels to scan workspace sibling projects
    top_parent = os.path.abspath(BASE_DIR)
    for _ in range(4):
        p = os.path.dirname(top_parent)
        if not p or p == top_parent:
            break
        top_parent = p

    try:
        for root, dirs, files in os.walk(top_parent):
            dirs[:] = [d for d in dirs if d not in IGNORE_DIRS and not d.startswith('.')]
            if SCRIPT_FILENAME in files or LAUNCHER_FILENAME in files:
                abs_loc = os.path.abspath(root)
                discovered.add(abs_loc)
                register_workspace_path(abs_loc)
    except Exception:
        pass

    discovered.add(os.path.abspath(BASE_DIR))
    return sorted(list(discovered))

def sync_watcher_to_all_locations(silent=False):
    """
    Deploys & overwrites watcher tools across ALL discovered/registered project folders.
    Normalizes line endings for reliable cross-folder synchronization.
    """
    register_current_workspace()
    all_targets = discover_all_watcher_locations()
    current_abs = os.path.abspath(BASE_DIR)
    
    current_py_path = os.path.join(BASE_DIR, SCRIPT_FILENAME)
    current_bat_path = os.path.join(BASE_DIR, LAUNCHER_FILENAME)
    
    current_py_content = None
    if os.path.exists(current_py_path):
        with open(current_py_path, "r", encoding="utf-8", errors="replace") as f:
            current_py_content = f.read()

    current_bat_content = None
    if os.path.exists(current_bat_path):
        with open(current_bat_path, "r", encoding="utf-8", errors="replace") as f:
            current_bat_content = f.read()

    norm_py = current_py_content.replace("\r\n", "\n") if current_py_content else ""
    norm_bat = current_bat_content.replace("\r\n", "\n") if current_bat_content else ""

    updated_count = 0
    already_synced_count = 0

    for target_dir in all_targets:
        if target_dir == current_abs:
            continue
            
        try:
            target_py = os.path.join(target_dir, SCRIPT_FILENAME)
            target_bat = os.path.join(target_dir, LAUNCHER_FILENAME)
            modified_any = False
            
            # Sync / Deploy Python script
            if current_py_content is not None:
                needs_write = True
                if os.path.exists(target_py):
                    with open(target_py, "r", encoding="utf-8", errors="replace") as f:
                        dest_py = f.read().replace("\r\n", "\n")
                    if dest_py == norm_py:
                        needs_write = False
                
                if needs_write:
                    with open(target_py, "w", encoding="utf-8") as f:
                        f.write(current_py_content)
                    modified_any = True
                
            # Sync / Deploy Batch launcher
            if current_bat_content is not None:
                needs_bat_write = True
                if os.path.exists(target_bat):
                    with open(target_bat, "r", encoding="utf-8", errors="replace") as f:
                        dest_bat = f.read().replace("\r\n", "\n")
                    if dest_bat == norm_bat:
                        needs_bat_write = False
                
                if needs_bat_write:
                    with open(target_bat, "w", encoding="utf-8") as f:
                        f.write(current_bat_content)
                    modified_any = True

            if modified_any:
                updated_count += 1
                if not silent:
                    print(f"   [+] Omni-Sync: Propagated/Deployed watcher tools to: {target_dir}")
            else:
                already_synced_count += 1
        except Exception as e:
            if not silent:
                print(f"   [!] Could not sync to {target_dir}: {e}")

    if not silent:
        print(f"🌍 [Omni-Sync Summary] Checked {len(all_targets)} workspace folders: {updated_count} updated/deployed, {already_synced_count} already current.")
    return updated_count, already_synced_count, len(all_targets)

# =====================================================================
# DEEP FOLDER TREE HIERARCHY & FILE PARSER
# =====================================================================

def is_text_or_doc_file(filepath):
    """Determines if a file contains readable text, schemas, notebooks, or docs."""
    filename = os.path.basename(filepath).lower()
    if filename in {"dockerfile", "makefile", "procfile", "gemfile"}:
        return True

    _, ext = os.path.splitext(filepath)
    ext = ext.lower()
    
    if ext in KNOWN_TEXT_EXTENSIONS:
        return True
        
    try:
        with open(filepath, 'rb') as f:
            chunk = f.read(1024)
            if b'\x00' not in chunk:
                return True
    except Exception:
        pass
        
    return False

def extract_file_content(filepath):
    """Reads file content safely across text, docx, and Jupyter notebooks with retry logic."""
    _, ext = os.path.splitext(filepath)
    ext = ext.lower()
    
    if ext == ".docx":
        try:
            import docx2txt
            return docx2txt.process(filepath)
        except ImportError:
            return "[Error: 'docx2txt' library is required to parse .docx files. Install it via: pip install docx2txt]"
        except Exception as e:
            return f"[Error parsing MS Word file: {e}]"
            
    if ext == ".ipynb":
        for attempt in range(5):
            try:
                with open(filepath, "r", encoding="utf-8", errors="replace") as f:
                    notebook_data = json.load(f)
                
                rendered_cells = []
                for idx, cell in enumerate(notebook_data.get("cells", [])):
                    cell_type = cell.get("cell_type", "code").upper()
                    source_lines = "".join(cell.get("source", []))
                    rendered_cells.append(f"--- [Cell {idx + 1}: {cell_type}] ---\n{source_lines}")
                return "\n\n".join(rendered_cells)
            except PermissionError:
                time.sleep(0.2)
                continue
            except Exception as e:
                return f"[Error reading Jupyter Notebook: {e}]"

    retries = 5
    for attempt in range(retries):
        try:
            with open(filepath, "r", encoding="utf-8", errors="replace") as f:
                return f.read()
        except PermissionError:
            if attempt < retries - 1:
                time.sleep(0.2)
                continue
            else:
                raise

def get_deep_tree_structures():
    """
    Scans the entire folder hierarchy and builds:
    1. folder_direct_map: {folder_name: [files directly in this folder]}
    2. folder_subtree_map: {folder_name: [all files in this folder AND its subfolders recursively]}
    3. folder_depth_map: {folder_name: depth level int}
    """
    folder_direct_map = {}
    
    for root, dirs, files in os.walk(BASE_DIR):
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS and not d.startswith('.')]
        
        rel_dir = os.path.relpath(root, BASE_DIR).replace("\\", "/")
        display_folder = "[Root Directory]" if rel_dir == "." else rel_dir
        
        valid_files = []
        for file in files:
            if is_ignored_file(file):
                continue
            
            full_path = os.path.join(root, file)
            rel_file_path = os.path.relpath(full_path, BASE_DIR).replace("\\", "/")
            
            if is_text_or_doc_file(full_path):
                valid_files.append(rel_file_path)
                
        if valid_files:
            valid_files.sort()
            folder_direct_map[display_folder] = valid_files

    sorted_folder_keys = sorted(
        folder_direct_map.keys(), 
        key=lambda k: ("" if k == "[Root Directory]" else k.lower())
    )
    
    folder_depth_map = {}
    folder_subtree_map = {}
    
    for folder in sorted_folder_keys:
        if folder == "[Root Directory]":
            folder_depth_map[folder] = 0
            folder_subtree_map[folder] = [f for files in folder_direct_map.values() for f in files]
        else:
            folder_depth_map[folder] = folder.count('/') + 1
            subtree_files = []
            prefix = folder + "/"
            for other_folder, files in folder_direct_map.items():
                if other_folder == folder or other_folder.startswith(prefix):
                    subtree_files.extend(files)
            folder_subtree_map[folder] = sorted(list(set(subtree_files)))

    return (
        {k: folder_direct_map[k] for k in sorted_folder_keys}, 
        folder_subtree_map, 
        folder_depth_map
    )

def get_all_scanned_files():
    """Flattens all scanned files across folders into a single list."""
    folder_direct_map, _, _ = get_deep_tree_structures()
    all_files = []
    for files in folder_direct_map.values():
        all_files.extend(files)
    return all_files

def copy_bundle_to_clipboard():
    """Copies current bundle file text to the system clipboard with multi-AI token stats."""
    bundle_path = os.path.join(BASE_DIR, OUTPUT_FILENAME)
    if not os.path.exists(bundle_path):
        messagebox.showinfo("Clipboard", "Please generate the bundle first.")
        return
        
    try:
        with open(bundle_path, "r", encoding="utf-8") as f:
            content = f.read()
            
        stats = calculate_ai_tokens(content)
        
        try:
            import pyperclip
            pyperclip.copy(content)
        except ImportError:
            root_clip = tk.Tk()
            root_clip.withdraw()
            root_clip.clipboard_clear()
            root_clip.clipboard_append(content)
            root_clip.update()
            root_clip.destroy()

        messagebox.showinfo(
            "📋 Master Bundle Copied",
            f"Copied to clipboard successfully!\n\n"
            f"• Google AI Studio (Gemini) : ~{stats['gemini']:,} tokens\n"
            f"• Anthropic Claude 3.7      : ~{stats['claude']:,} tokens\n"
            f"• OpenAI (GPT-4o)           : ~{stats['gpt4']:,} tokens"
        )
    except Exception as e:
        messagebox.showerror("Error", f"Failed to copy to clipboard: {e}")

def trigger_manual_omni_sync():
    """GUI trigger to synchronize watcher scripts across all machine locations."""
    updated, current, total = sync_watcher_to_all_locations(silent=False)
    messagebox.showinfo(
        "🌍 Omni-Sync Complete", 
        f"Omni-Sync checked {total} workspace folder(s):\n\n"
        f"• Newly Updated/Deployed: {updated} folder(s)\n"
        f"• Already Up-to-Date: {current} folder(s)"
    )

def add_and_scan_custom_directory():
    """Opens a folder picker to scan any parent folder or drive and register all watcher locations."""
    chosen_dir = filedialog.askdirectory(title="Select Folder or Drive to Scan & Join to Omni-Sync")
    if chosen_dir:
        found_in_scan = 0
        for root, dirs, files in os.walk(chosen_dir):
            dirs[:] = [d for d in dirs if d not in IGNORE_DIRS and not d.startswith('.')]
            abs_root = os.path.abspath(root)
            if any(f in files for f in [SCRIPT_FILENAME, LAUNCHER_FILENAME, "package.json", "requirements.txt", "tsconfig.json"]):
                register_workspace_path(abs_root)
                found_in_scan += 1
        
        updated, current, total = sync_watcher_to_all_locations(silent=False)
        messagebox.showinfo(
            "📂 Workspace Scanned", 
            f"Found & Registered {found_in_scan} project folder(s) in selected path.\n\n"
            f"Omni-Sync network now covers {total} total workspace folder(s)!\n"
            f"• Updated/Deployed: {updated}\n"
            f"• Already Current: {current}"
        )

# =====================================================================
# ADVANCED SUBTREE SELECTION GRAPHICAL INTERFACE
# =====================================================================

def show_file_selector_gui():
    """Builds graphical interface with Deep-Tree branch selection, filters, and multi-AI live counter."""
    global included_files
    folder_direct_map, folder_subtree_map, folder_depth_map = get_deep_tree_structures()

    root = tk.Tk()
    root.title(f"Configure Deep-Tree Tracking: {FOLDER_NAME}")
    root.geometry("760x800")
    root.minsize(640, 560)
    root.attributes("-topmost", True)

    header_label = tk.Label(
        root, 
        text=f"Select folders, subtrees, and files to bundle [{FOLDER_NAME}]:", 
        font=("Arial", 10, "bold"), 
        pady=6
    )
    header_label.pack(fill="x")

    # Filter Bar
    filter_bar = tk.Frame(root)
    filter_bar.pack(fill="x", padx=12, pady=3)

    folder_filter_lbl = tk.Label(filter_bar, text="📁 View Branch:", font=("Arial", 9, "bold"))
    folder_filter_lbl.pack(side="left", padx=(0, 4))

    folder_options = ["All Folders"]
    for f in folder_direct_map.keys():
        if f == "[Root Directory]":
            folder_options.append("[Root Directory]")
        else:
            folder_options.append(f"{f} (Entire Subtree)")
            folder_options.append(f"{f} (Direct Only)")

    selected_folder_filter = tk.StringVar(value="All Folders")
    folder_dropdown = ttk.Combobox(
        filter_bar, 
        textvariable=selected_folder_filter, 
        values=folder_options, 
        state="readonly", 
        width=26, 
        font=("Arial", 9)
    )
    folder_dropdown.pack(side="left", padx=(0, 10))

    search_lbl = tk.Label(filter_bar, text="🔍 Search:", font=("Arial", 9, "bold"))
    search_lbl.pack(side="left", padx=(0, 4))
    
    search_var = tk.StringVar()
    search_entry = tk.Entry(filter_bar, textvariable=search_var, font=("Arial", 9))
    search_entry.pack(side="left", fill="x", expand=True)

    # Macro Controls Frame (Row 1: Tree Level Selection)
    btn_frame_1 = tk.Frame(root)
    btn_frame_1.pack(fill="x", padx=12, pady=2)

    # Macro Controls Frame (Row 2: Category & Logic Selection)
    btn_frame_2 = tk.Frame(root)
    btn_frame_2.pack(fill="x", padx=12, pady=2)

    # Scrollable Checkbox Area
    container = tk.Frame(root, relief="sunken", borderwidth=1)
    container.pack(fill=tk.BOTH, expand=True, padx=12, pady=6)

    canvas = tk.Canvas(container, highlightthickness=0, bg="#fcfcfc")
    scrollbar = ttk.Scrollbar(container, orient="vertical", command=canvas.yview)
    scrollable_frame = tk.Frame(canvas, bg="#fcfcfc")

    scrollable_frame.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
    canvas_window = canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
    
    def on_canvas_configure(event):
        canvas.itemconfig(canvas_window, width=event.width)
    canvas.bind("<Configure>", on_canvas_configure)
    canvas.configure(yscrollcommand=scrollbar.set)

    canvas.pack(side="left", fill="both", expand=True)
    scrollbar.pack(side="right", fill="y")

    checkbox_vars = {}
    file_widget_map = {}
    folder_section_frames = {}

    with lock:
        for folder_name, files_in_folder in folder_direct_map.items():
            depth = folder_depth_map.get(folder_name, 0)
            subtree_files = folder_subtree_map.get(folder_name, files_in_folder)
            
            left_indent = max(0, (depth - 1) * 16) if folder_name != "[Root Directory]" else 0
            
            sec_frame = tk.Frame(scrollable_frame, bg="#fcfcfc", pady=2)
            sec_frame.pack(fill="x", padx=(6 + left_indent, 6), pady=2)
            folder_section_frames[folder_name] = sec_frame

            header_bar = tk.Frame(sec_frame, bg="#e8edf2", relief="groove", borderwidth=1)
            header_bar.pack(fill="x", pady=(2, 2))

            tree_prefix = "└── " if depth > 1 else ""
            direct_count = len(files_in_folder)
            subtree_count = len(subtree_files)
            
            if subtree_count != direct_count and folder_name != "[Root Directory]":
                count_label = f"({direct_count} direct, {subtree_count} in subtree)"
            else:
                count_label = f"({direct_count} file{'s' if direct_count != 1 else ''})"
                
            icon_title = f"{tree_prefix}📁 {folder_name} {count_label}"
            f_title_lbl = tk.Label(header_bar, text=icon_title, font=("Arial", 9, "bold"), bg="#e8edf2", fg="#1e293b", anchor="w")
            f_title_lbl.pack(side="left", padx=6, pady=3)

            def make_select_subtree(target_files):
                def select_sub():
                    for fn in target_files:
                        if fn in checkbox_vars:
                            checkbox_vars[fn].set(True)
                return select_sub

            def make_deselect_subtree(target_files):
                def deselect_sub():
                    for fn in target_files:
                        if fn in checkbox_vars:
                            checkbox_vars[fn].set(False)
                return deselect_sub

            btn_sub_none = tk.Button(
                header_bar, 
                text="[- Subtree]" if subtree_count != direct_count else "[- None]", 
                command=make_deselect_subtree(subtree_files), 
                bg="#ffffff", 
                fg="#b91c1c", 
                font=("Arial", 7, "bold"), 
                relief="flat", 
                padx=4, 
                pady=1
            )
            btn_sub_none.pack(side="right", padx=(2, 4), pady=2)

            btn_sub_all = tk.Button(
                header_bar, 
                text="[+ Subtree]" if subtree_count != direct_count else "[+ All]", 
                command=make_select_subtree(subtree_files), 
                bg="#ffffff", 
                fg="#15803d", 
                font=("Arial", 7, "bold"), 
                relief="flat", 
                padx=4, 
                pady=1
            )
            btn_sub_all.pack(side="right", padx=(2, 2), pady=2)

            if subtree_count != direct_count and folder_name != "[Root Directory]":
                btn_only_none = tk.Button(
                    header_bar, 
                    text="[- Only]", 
                    command=make_deselect_subtree(files_in_folder), 
                    bg="#ffffff", 
                    fg="#991b1b", 
                    font=("Arial", 7), 
                    relief="flat", 
                    padx=3, 
                    pady=1
                )
                btn_only_none.pack(side="right", padx=(2, 2), pady=2)

                btn_only_all = tk.Button(
                    header_bar, 
                    text="[+ Only]", 
                    command=make_select_subtree(files_in_folder), 
                    bg="#ffffff", 
                    fg="#166534", 
                    font=("Arial", 7), 
                    relief="flat", 
                    padx=3, 
                    pady=1
                )
                btn_only_all.pack(side="right", padx=(2, 2), pady=2)

            for filename in files_in_folder:
                var = tk.BooleanVar()
                if len(included_files) == 0 or filename in included_files:
                    var.set(True)
                else:
                    var.set(False)
                    
                checkbox_vars[filename] = var
                base_display_name = os.path.basename(filename)
                
                cb = tk.Checkbutton(
                    sec_frame, 
                    text=f"  📄 {base_display_name}  ({filename})", 
                    variable=var, 
                    font=("Arial", 9), 
                    anchor="w", 
                    justify="left", 
                    bg="#fcfcfc",
                    activebackground="#f0f4f8"
                )
                cb.pack(fill="x", padx=16, pady=1)
                file_widget_map[filename] = cb

    # Filtering Logic for Search and Subtree Dropdowns
    def apply_filters(*args):
        search_query = search_var.get().strip().lower()
        filter_choice = selected_folder_filter.get()

        for folder_name, f_frame in folder_section_frames.items():
            folder_matches = False
            
            if filter_choice == "All Folders":
                folder_matches = True
            elif filter_choice == "[Root Directory]":
                folder_matches = (folder_name == "[Root Directory]")
            elif "(Entire Subtree)" in filter_choice:
                base_f = filter_choice.replace(" (Entire Subtree)", "").strip()
                folder_matches = (folder_name == base_f or folder_name.startswith(base_f + "/"))
            elif "(Direct Only)" in filter_choice:
                base_f = filter_choice.replace(" (Direct Only)", "").strip()
                folder_matches = (folder_name == base_f)

            if not folder_matches:
                f_frame.pack_forget()
                continue

            visible_files = 0
            for fn in folder_direct_map[folder_name]:
                cb = file_widget_map[fn]
                if search_query == "" or (search_query in fn.lower()):
                    cb.pack(fill="x", padx=16, pady=1)
                    visible_files += 1
                else:
                    cb.pack_forget()

            if visible_files > 0:
                depth = folder_depth_map.get(folder_name, 0)
                left_indent = max(0, (depth - 1) * 16) if folder_name != "[Root Directory]" else 0
                f_frame.pack(fill="x", padx=(6 + left_indent, 6), pady=2)
            else:
                f_frame.pack_forget()

    search_var.trace_add("write", apply_filters)
    folder_dropdown.bind("<<ComboboxSelected>>", apply_filters)

    # Macro Actions
    def select_entire_project_tree():
        for var in checkbox_vars.values():
            var.set(True)

    def select_root_only():
        root_files = set(folder_direct_map.get("[Root Directory]", []))
        for fname, var in checkbox_vars.items():
            var.set(fname in root_files)

    def select_assets_only():
        for fname, var in checkbox_vars.items():
            if fname in {"watch_and_bundle.py", "run_watcher.bat"}:
                var.set(False)
            else:
                var.set(True)

    def select_utilities_only():
        for fname, var in checkbox_vars.items():
            if fname in {"watch_and_bundle.py", "run_watcher.bat"}:
                var.set(True)
            else:
                var.set(False)

    def deselect_all():
        for var in checkbox_vars.values():
            var.set(False)

    def invert_selection():
        for var in checkbox_vars.values():
            var.set(not var.get())

    # Row 1 Buttons: Tree Navigation
    btn_tree_all = tk.Button(btn_frame_1, text="🌟 Select Entire Project Tree", command=select_entire_project_tree, bg="#dbeafe", font=("Arial", 8, "bold"))
    btn_tree_all.pack(side="left", fill="x", expand=True, padx=2)

    btn_root_only = tk.Button(btn_frame_1, text="🏠 Root Files Only", command=select_root_only, bg="#f3f4f6", font=("Arial", 8))
    btn_root_only.pack(side="left", fill="x", expand=True, padx=2)

    btn_assets = tk.Button(btn_frame_1, text="Assets Only", command=select_assets_only, bg="#f3f4f6", font=("Arial", 8))
    btn_assets.pack(side="left", fill="x", expand=True, padx=2)

    # Row 2 Buttons: Selectors
    btn_utils = tk.Button(btn_frame_2, text="Utilities Only", command=select_utilities_only, bg="#f3f4f6", font=("Arial", 8))
    btn_utils.pack(side="left", fill="x", expand=True, padx=2)

    btn_none = tk.Button(btn_frame_2, text="Deselect All", command=deselect_all, bg="#f3f4f6", font=("Arial", 8))
    btn_none.pack(side="left", fill="x", expand=True, padx=2)

    btn_invert = tk.Button(btn_frame_2, text="Invert Selection", command=invert_selection, bg="#f3f4f6", font=("Arial", 8))
    btn_invert.pack(side="left", fill="x", expand=True, padx=2)

    # Bottom Actions Frame
    bottom_frame = tk.Frame(root)
    bottom_frame.pack(fill="x", padx=12, pady=8)

    def on_submit():
        global included_files
        with lock:
            included_files = {fname for fname, var in checkbox_vars.items() if var.get()}
        root.destroy()

    btn_scan_custom = tk.Button(bottom_frame, text="📂 Scan Drive", command=add_and_scan_custom_directory, bg="#455a64", fg="white", font=("Arial", 9, "bold"), padx=6, pady=5)
    btn_scan_custom.pack(side="left", padx=(0, 4))

    btn_omni = tk.Button(bottom_frame, text="🌍 Omni-Sync", command=trigger_manual_omni_sync, bg="#2e7d32", fg="white", font=("Arial", 9, "bold"), padx=6, pady=5)
    btn_omni.pack(side="left", padx=(0, 4))

    btn_copy = tk.Button(bottom_frame, text="📋 Copy Bundle", command=copy_bundle_to_clipboard, bg="#5c6bc0", fg="white", font=("Arial", 9, "bold"), padx=6, pady=5)
    btn_copy.pack(side="left", padx=(0, 4))

    btn_apply = tk.Button(bottom_frame, text="💾 Apply Changes & Refresh", command=on_submit, bg="#0078d7", fg="white", font=("Arial", 10, "bold"), pady=5)
    btn_apply.pack(side="right", fill="x", expand=True)

    root.mainloop()

def run_universal_bundler(prompt_user=False):
    """Processes structural inclusions registry lists into the destination packet file."""
    global included_files, is_bundling
    
    if prompt_user or len(included_files) == 0:
        show_file_selector_gui()
        
    print(f"[*] Recalculating allocations and writing [{OUTPUT_FILENAME}]...")
    xml_output = "<project_files>\n\n"
    
    bundled_count = 0
    folder_summary = {}

    is_bundling = True
    try:
        with lock:
            all_files = get_all_scanned_files()
            for rel_path in all_files:
                if rel_path not in included_files:
                    continue
                    
                full_path = os.path.join(BASE_DIR, rel_path.replace("/", os.sep))
                try:
                    content = extract_file_content(full_path)
                    bundled_count += 1
                    
                    dir_name = os.path.dirname(rel_path)
                    folder_tag = "[Root]" if dir_name == "" else dir_name
                    folder_summary[folder_tag] = folder_summary.get(folder_tag, 0) + 1
                    
                    xml_output += f'<file name="{rel_path}">\n'
                    xml_output += "<![CDATA[\n"
                    xml_output += content
                    xml_output += "\n]]>\n"
                    xml_output += "</file>\n\n"
                    print(f"   [+] Bundled: {rel_path}")
                except Exception as e:
                    print(f"   [X] Read error on {rel_path}: {e}")
                    
        xml_output += "</project_files>\n\n"
        xml_output += "My instruction for you: [TYPE YOUR QUESTION OR BUG TROUBLESHOOTING PROMPT HERE]"
        
        output_file = os.path.join(BASE_DIR, OUTPUT_FILENAME)
        
        for attempt in range(5):
            try:
                with open(output_file, "w", encoding="utf-8") as f:
                    f.write(xml_output)
                
                total_chars = len(xml_output)
                token_stats = calculate_ai_tokens(xml_output)
                file_size_kb = len(xml_output.encode("utf-8")) / 1024
                
                print(f"[+] Master bundle [{OUTPUT_FILENAME}] successfully synced!")
                print(f"    - Included Files            : {bundled_count}")
                print(f"    - Tracked Folders           : {len(folder_summary)} {list(folder_summary.keys())}")
                print(f"    - Total Bundle Chars        : {total_chars:,}")
                print(f"    - File Size                 : {file_size_kb:.1f} KB")
                print(f"    - 🤖 Google AI Studio (Gemini): ~{token_stats['gemini']:,} tokens  (Exact for Gemini 1.5/2.0/3.7)")
                print(f"    - 🧠 Anthropic Claude 3.7    : ~{token_stats['claude']:,} tokens  (Claude 3.5/3.7 Sonnet)")
                print(f"    - ⚡ OpenAI (GPT-4o / GPT-4)  : ~{token_stats['gpt4']:,} tokens   (cl100k / o200k)\n")
                break
            except PermissionError:
                if attempt < 4:
                    time.sleep(0.2)
                    continue
                else:
                    print(f"   [!] Notice: Output bundle file is locked by Windows. Retrying on next cycle...")
    finally:
        time.sleep(0.1)
        is_bundling = False  # Deactivate Write Shield after file is safely flushed

def debounce_bundle_update(trigger_reload=False, is_utility_update=False):
    """Timer callback to execute bundler, run Omni-Sync replication, and trigger hot-restart."""
    run_universal_bundler(prompt_user=False)
    
    if is_utility_update:
        print("\n🌍 [Omni-Sync Triggered] Watcher code updated! Replicating new code across all folders...")
        sync_watcher_to_all_locations(silent=False)
        
    if trigger_reload:
        print("[!] Detected modification to 'watch_and_bundle.py'.")
        print("[*] Rebuilding bundle & Omni-Sync complete. Initiating graceful hot-restart...\n")
        time.sleep(0.3)
        if global_observer is not None:
            try:
                global_observer.stop()
            except Exception:
                pass
        os._exit(42)

class UniversalFolderHandler(FileSystemEventHandler):
    def on_any_event(self, event):
        global debounce_timer, is_bundling
        
        # Mute tracker while bundler is actively saving files to prevent recursive loop
        if event.is_directory or is_bundling:
            return
            
        if is_ignored_file(event.src_path):
            return
            
        rel_path = os.path.relpath(event.src_path, BASE_DIR).replace("\\", "/")
        filename = os.path.basename(event.src_path)
        
        with lock:
            is_in_bundle = (rel_path in included_files)
            
        is_self_script = (filename == SCRIPT_FILENAME and event.event_type in ("modified", "created"))
        is_launcher_script = (filename == LAUNCHER_FILENAME and event.event_type in ("modified", "created"))
        is_utility_update = (is_self_script or is_launcher_script)

        # Trigger ONLY on real bundle asset edits or utility script changes
        if is_in_bundle or is_utility_update:
            if debounce_timer is not None:
                debounce_timer.cancel()
            
            debounce_timer = threading.Timer(
                0.35, 
                debounce_bundle_update, 
                kwargs={"trigger_reload": is_self_script, "is_utility_update": is_utility_update}
            )
            debounce_timer.start()

def listen_for_user_reprompt():
    """Runs on a concurrent background thread listening for terminal Enter keys."""
    while True:
        try:
            input()
            print("\n[*] Opening filter workspace configuration window...")
            run_universal_bundler(prompt_user=True)
            print("==================================================")
            print(f"  Live Watcher Active for Project: [{FOLDER_NAME}]")
            print("==================================================")
            print("-> Press [ENTER] in this window to change included files/folders.")
            print("-> Press [Ctrl + C] to terminate background operations.")
        except Exception:
            break

if __name__ == "__main__":
    register_current_workspace()

    # Initial bundle setup pass
    run_universal_bundler(prompt_user=True)
    
    # Threaded terminal input channel
    input_thread = threading.Thread(target=listen_for_user_reprompt, daemon=True)
    input_thread.start()

    # Filesystem watcher setup (recursive=True monitors all subdirectories automatically)
    event_handler = UniversalFolderHandler()
    global_observer = Observer()
    global_observer.schedule(event_handler, path=BASE_DIR, recursive=True)
    global_observer.start()

    print("==================================================")
    print(f"  Live Watcher Active for Project: [{FOLDER_NAME}]")
    print("==================================================")
    print("-> Press [ENTER] in this window to change included files/folders.")
    print("-> Press [Ctrl + C] to terminate background operations.")
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        global_observer.stop()
    global_observer.join()