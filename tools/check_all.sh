#!/usr/bin/env bash
# Contrôle complet de cohérence — à lancer après CHAQUE nouveau bloc de dialogues, de données ou de code.
#   GODOT=/chemin/vers/godot ./tools/check_all.sh          (par défaut : « godot » dans le PATH)
#   ./tools/check_all.sh --quick                            (sans les parties automatiques)
set -euo pipefail
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
fail=0
step() { printf '\n\033[1;36m== %s ==\033[0m\n' "$1"; }

step "1/4 Validation des données (lore, variables, références)"
python3 tools/validate_data.py || fail=1
python3 tools/build_gallery_doc.py --check || fail=1
python3 tools/free_assets/test_free_gen.py >/dev/null || { python3 tools/free_assets/test_free_gen.py | tail -5; fail=1; }
python3 tools/free_assets/test_backends_torch.py | tail -1 || fail=1   # vrais moteurs (ignoré sans torch/diffusers)

step "2/4 Import Godot (erreurs d'analyse GDScript)"
if "$GODOT" --headless --path . --import 2>&1 | grep -E "SCRIPT ERROR|Parse Error"; then fail=1; else echo "OK"; fi

step "3/4 Tests unitaires (état, dialogues, combat, carte, fuzz) et interface"
"$GODOT" --headless --path . -s res://tests/run_tests.gd 2>&1 | grep -E "ÉCHEC|réussis" || fail=1
"$GODOT" --headless --path . -s res://tests/run_tests.gd >/dev/null 2>&1 || fail=1
uilog=$(mktemp)
if timeout 300 "$GODOT" --headless --path . -- --uitest >"$uilog" 2>&1 && grep -q "INTERFACE OK" "$uilog"; then
  echo "Interface : $(grep -c '\[uitest\] ok' "$uilog") contrôles réussis (barre d'actions, menu pause, fiches, galerie)"
else
  echo "ÉCHEC de l'interface :"; grep -E "ÉCHEC|ERROR" "$uilog" | head -20; fail=1
fi
rm -f "$uilog"

if [[ "${1:-}" != "--quick" ]]; then
  step "4/4 Parties automatiques complètes (prologue → Nuit du Déversement, Acte IV)"
  for variant in "" "--alt" "--autotest-regress" "--act1-only" "--mode=histoire" "--mode=survie"; do
    expected="FIN DE L'ACTE 4"
    [[ "$variant" == "--act1-only" ]] && expected="FIN DE L'ACTE 1"
    log=$(mktemp)
    if timeout 900 "$GODOT" --headless --path . -- --autotest $variant >"$log" 2>&1 && grep -q "$expected" "$log" && ! grep -qE "SCRIPT ERROR|^ERROR" "$log"; then
      echo "OK  [${variant:-standard}] $(grep "$expected" "$log" | sed 's/\[autotest\] //')"
    else
      echo "ÉCHEC [${variant:-standard}]"; tail -20 "$log"; fail=1
    fi
    rm -f "$log"
  done
fi

if [[ $fail -ne 0 ]]; then printf '\n\033[1;31mÉCHEC — corriger avant de commiter.\033[0m\n'; exit 1; fi
printf '\n\033[1;32mTout est cohérent.\033[0m\n'
