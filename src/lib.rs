use std::fs;
use zed_extension_api::{self as zed, ContextServerId, Project, Result};

struct RealtimeStt;

impl zed::Extension for RealtimeStt {
    fn new() -> Self {
        Self
    }

    fn context_server_command(
        &mut self,
        _context_server_id: &ContextServerId,
        _project: &Project,
    ) -> Result<zed::Command> {
        let ext_dir = std::env::current_dir()
            .map_err(|e| format!("failed to get extension dir: {e}"))?;

        let setup = ext_dir.join("server/setup.sh");

        if !fs::metadata(&setup).is_ok() {
            return Err(format!(
                "server/setup.sh not found in extension dir: {}",
                ext_dir.display()
            ));
        }

        println!("[realtime-stt] starting STT server from {}", ext_dir.display());

        Ok(zed::Command {
            command: setup.to_string_lossy().into_owned(),
            args: vec![],
            env: vec![
                ("SKIP_INSTALL".into(), "0".into()),
                (
                    "VENV_DIR".into(),
                    ext_dir.join("server/.venv").to_string_lossy().into_owned(),
                ),
                (
                    "SETTINGS_PATH".into(),
                    ext_dir.join("server/settings.yaml").to_string_lossy().into_owned(),
                ),
            ],
        })
    }
}

zed::register_extension!(RealtimeStt);
