#!/usr/bin/env bash
# Common interface for service management

# These functions must be implemented by the specific backend scripts
# ($DOTFILES_DIR/scripts/install/init/systemd.sh, etc.)

# enable_service <service_name> [user|system]
# start_service <service_name> [user|system]
# restart_service <service_name> [user|system]
# stop_service <service_name> [user|system]

load_init_backend() {

    if [[ -z "${INIT_SYSTEM:-}" ]]; then
        error "INIT_SYSTEM is not set. Call detect_init first."
    fi

    local backend_script="${DOTFILES_DIR}/scripts/install/init/${INIT_SYSTEM}.sh"

    if [[ -f "$backend_script" ]]; then

        source "$backend_script" \
            || error "Failed to load init backend: ${backend_script}"

    else
        warn "Init backend for '${INIT_SYSTEM}' not found."
        warn "Service management will be skipped."

        # --- Dummy fallbacks ---
        enable_service() {
            warn "Service management unavailable for INIT_SYSTEM=${INIT_SYSTEM}"
            return 0
        }

        start_service() {
            warn "Service management unavailable for INIT_SYSTEM=${INIT_SYSTEM}"
            return 0
        }

        restart_service() {
            warn "Service management unavailable for INIT_SYSTEM=${INIT_SYSTEM}"
            return 0
        }

        stop_service() {
            warn "Service management unavailable for INIT_SYSTEM=${INIT_SYSTEM}"
            return 0
        }
    fi
}
