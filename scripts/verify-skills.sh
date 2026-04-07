#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT_DIR/.agents/skills"
LOCK_FILE="$ROOT_DIR/skills-lock.json"

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "Skills directory not found: $SKILLS_DIR" >&2
  exit 1
fi

node - "$SKILLS_DIR" "$LOCK_FILE" <<'NODE'
const fs = require("node:fs");
const path = require("node:path");

const skillsDir = process.argv[2];
const lockFile = process.argv[3];

const requiredSkills = [
  "backend-clean-architecture",
  "backend-programming-standards",
  "backend-solid-principles",
  "spring-boot-api",
  "fullstack-workflow",
  "write-adr",
  "clean-code",
];

const backendSkillsNeedingAdrCheck = [
  "backend-clean-architecture",
  "backend-programming-standards",
  "backend-solid-principles",
  "spring-boot-api",
  "fullstack-workflow",
];

const errors = [];
const warnings = [];
const seenNames = new Map();

const skillDirs = fs
  .readdirSync(skillsDir, { withFileTypes: true })
  .filter((entry) => entry.isDirectory())
  .map((entry) => entry.name)
  .sort();

if (skillDirs.length === 0) {
  errors.push(`No skill directories found under ${skillsDir}`);
}

function parseFrontmatter(content, filePath) {
  const normalized = content.replace(/^\uFEFF/, "");
  if (!normalized.startsWith("---\n")) {
    return { error: `Missing opening frontmatter in ${filePath}` };
  }

  const endIndex = normalized.indexOf("\n---\n", 4);
  if (endIndex === -1) {
    return { error: `Missing closing frontmatter in ${filePath}` };
  }

  const block = normalized.slice(4, endIndex);
  const lines = block.split(/\r?\n/);

  let name = "";
  let description = "";

  for (const line of lines) {
    const kv = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (!kv) {
      continue;
    }

    const key = kv[1];
    const rawValue = kv[2].trim();
    const value = rawValue.replace(/^["']|["']$/g, "");

    if (key === "name") {
      name = value;
    }
    if (key === "description") {
      description = value;
    }
  }

  if (!name) {
    return { error: `Frontmatter "name" missing in ${filePath}` };
  }
  if (!description) {
    return { error: `Frontmatter "description" missing in ${filePath}` };
  }

  return { name, description };
}

for (const dirName of skillDirs) {
  const dirPath = path.join(skillsDir, dirName);
  const skillFile = path.join(dirPath, "SKILL.md");

  if (!fs.existsSync(skillFile)) {
    errors.push(`Missing SKILL.md in ${dirPath}`);
    continue;
  }

  const content = fs.readFileSync(skillFile, "utf8");
  const parsed = parseFrontmatter(content, skillFile);

  if (parsed.error) {
    errors.push(parsed.error);
    continue;
  }

  const skillName = parsed.name;
  const description = parsed.description;

  if (skillName !== dirName) {
    errors.push(
      `Skill directory "${dirName}" does not match frontmatter name "${skillName}" in ${skillFile}`,
    );
  }

  if (description.length < 20) {
    warnings.push(`Description is very short in ${skillFile}`);
  }

  if (seenNames.has(skillName)) {
    errors.push(
      `Duplicate skill name "${skillName}" in ${skillFile} and ${seenNames.get(skillName)}`,
    );
  } else {
    seenNames.set(skillName, skillFile);
  }

  const agentsDir = path.join(dirPath, "agents");
  const openaiConfig = path.join(agentsDir, "openai.yaml");
  if (fs.existsSync(agentsDir) && !fs.existsSync(openaiConfig)) {
    warnings.push(`Missing agents/openai.yaml for ${dirName}`);
  }
}

for (const required of requiredSkills) {
  if (!skillDirs.includes(required)) {
    errors.push(`Required skill missing: ${required}`);
  }
}

for (const skill of backendSkillsNeedingAdrCheck) {
  const skillFile = path.join(skillsDir, skill, "SKILL.md");
  if (!fs.existsSync(skillFile)) {
    continue;
  }
  const content = fs.readFileSync(skillFile, "utf8");
  if (!/ADR check/i.test(content) && !/write-adr/i.test(content)) {
    errors.push(`"${skill}" must include ADR guidance referencing write-adr`);
  }
}

if (fs.existsSync(lockFile)) {
  try {
    const lock = JSON.parse(fs.readFileSync(lockFile, "utf8"));
    const lockedSkills = Object.keys(lock.skills || {});
    for (const skill of lockedSkills) {
      if (!skillDirs.includes(skill)) {
        errors.push(`skills-lock.json references missing skill directory: ${skill}`);
      }
    }
  } catch (error) {
    errors.push(`Failed to parse skills-lock.json: ${error.message}`);
  }
} else {
  warnings.push("skills-lock.json not found; project-scoped npx skills restore is not reproducible.");
}

if (warnings.length > 0) {
  console.log("Skill warnings:");
  for (const warning of warnings) {
    console.log(`- ${warning}`);
  }
  console.log("");
}

if (errors.length > 0) {
  console.error("Skill validation failed:");
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  process.exit(1);
}

console.log(`Skill validation passed for ${skillDirs.length} skills.`);
NODE
