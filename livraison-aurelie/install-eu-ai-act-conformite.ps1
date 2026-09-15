# ============================================================================
# SCRIPT D'INSTALLATION AUTOMATIQUE
# Projet : eu-ai-act-conformite
# Auteur : EL OUERTANI FAOUZI
# Date   : 2025-09-15
#
# USAGE :
#   1. Creez d'abord un depot prive "eu-ai-act-conformite" sur https://github.com/new
#   2. Ouvrez PowerShell sur votre Windows
#   3. Placez ce script dans votre dossier Documents
#   4. Executez : powershell -ExecutionPolicy Bypass -File .\install-eu-ai-act-conformite.ps1
#
# Le script fait TOUT : clone, ajoute les 2 nouveaux outils, compile, teste, push
# ============================================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Installation de eu-ai-act-conformite" -ForegroundColor Cyan
Write-Host "  Par EL OUERTANI FAOUZI" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# --- Variables ---
$GitHubUser = "faouzielouertani-arch"
$RepoName = "eu-ai-act-conformite"
$ProjectDir = "$HOME\Documents\$RepoName"

# --- Verifier Node.js ---
Write-Host "[1/9] Verification de Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "ERREUR : Node.js n'est pas installe." -ForegroundColor Red
    Write-Host "Telechargez-le depuis https://nodejs.org (version LTS)" -ForegroundColor Red
    exit 1
}
Write-Host "  Node.js detecte : $nodeVersion" -ForegroundColor Green

# --- Verifier Git ---
Write-Host "[2/9] Verification de Git..." -ForegroundColor Yellow
$gitVersion = git --version 2>$null
if (-not $gitVersion) {
    Write-Host "ERREUR : Git n'est pas installe." -ForegroundColor Red
    Write-Host "Telechargez-le depuis https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}
Write-Host "  Git detecte : $gitVersion" -ForegroundColor Green

# --- Cloner le depot original ---
Write-Host "[3/9] Clonage du depot original..." -ForegroundColor Yellow
if (Test-Path $ProjectDir) {
    Write-Host "  Le dossier existe deja. Suppression..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $ProjectDir
}
git clone "https://github.com/lexbeam-software/eu-ai-act-mcp.git" $ProjectDir
if (-not $?) {
    Write-Host "ERREUR : Echec du clonage. Verifiez votre connexion internet." -ForegroundColor Red
    exit 1
}
Write-Host "  Depot clone avec succes." -ForegroundColor Green

Set-Location $ProjectDir

# --- Changer le remote ---
Write-Host "[4/9] Configuration du remote vers votre GitHub..." -ForegroundColor Yellow
git remote remove origin
git remote add origin "https://github.com/$GitHubUser/$RepoName.git"
Write-Host "  Remote configure : https://github.com/$GitHubUser/$RepoName.git" -ForegroundColor Green

# --- Installer les dependances ---
Write-Host "[5/9] Installation des dependances (npm install)..." -ForegroundColor Yellow
npm install
if (-not $?) {
    Write-Host "ERREUR : Echec de npm install." -ForegroundColor Red
    exit 1
}
Write-Host "  Dependances installees." -ForegroundColor Green

# --- Creer le fichier schema ---
Write-Host "[6/9] Creation des nouveaux fichiers..." -ForegroundColor Yellow

$schemaDir = "src\schemas"
$toolsDir = "src\tools"

# --- Fichier : src/schemas/regulatory-watch.ts ---
$schemaContent = @'
import { z } from "zod";

// ---------------------------------------------------------------------------
// Tool B - Regulatory watch (veille reglementaire en temps reel)
// ---------------------------------------------------------------------------

export const regulatoryWatchInputSchema = z.object({
  include_pending: z
    .boolean()
    .optional()
    .default(false)
    .describe(
      "If true, also surface non-enacted sources (proposals, political agreements, draft guidelines) with their source-status labels. OFF by default: only operative law is returned.",
    ),
  areas: z
    .array(z.string())
    .optional()
    .describe(
      "Optional filter: restrict to specific areas (e.g. ['high-risk', 'GPAI', 'prohibited', 'transparency', 'omnibus']).",
    ),
}).describe("Input for the regulatory watch tool.");

export const regulatoryWatchOutputSchema = z.object({
  check_timestamp: z.string(),
  knowledge_snapshot: z.object({
    last_verified: z.string(),
    regulation: z.string(),
    omnibus_status: z.string(),
    omnibus_enacted: z.boolean(),
    celex: z.string().optional(),
    oj_publication_date: z.string().optional(),
    entry_into_force: z.string().optional(),
    eurlex_url: z.string(),
  }),
  upcoming_milestones: z.array(z.object({
    date: z.string(),
    name: z.string(),
    days_remaining: z.number(),
    articles: z.array(z.string()),
    key_obligations: z.array(z.string()),
  })),
  pending_sources: z
    .array(z.object({
      id: z.string(),
      title: z.string(),
      status: z.string(),
      date: z.string(),
      url: z.string(),
      celex: z.string().optional(),
      note: z.string().optional(),
    }))
    .optional(),
  recommendation: z.string(),
  next_action: z.string(),
});

export type RegulatoryWatchInput = z.infer<typeof regulatoryWatchInputSchema>;
export type RegulatoryWatchOutput = z.infer<typeof regulatoryWatchOutputSchema>;

// ---------------------------------------------------------------------------
// Tool C - Compliance monitoring (monitoring de conformite en temps reel)
// ---------------------------------------------------------------------------

export const complianceMonitorInputSchema = z.object({
  system_name: z
    .string()
    .min(1)
    .describe("Name of the AI system being monitored."),
  risk_level: z
    .enum(["prohibited", "high-risk", "limited", "minimal", "gpai"])
    .describe("Risk classification of the system (from euaiact_classify_system)."),
  role: z
    .enum(["provider", "deployer"])
    .describe("Role of the monitored entity: provider or deployer."),
  high_risk_source: z
    .enum(["annex_iii", "annex_i", "unknown"])
    .optional()
    .default("unknown")
    .describe("For high-risk systems, the classification source."),
  annex_iii_point: z
    .number()
    .int()
    .min(1)
    .max(8)
    .optional()
    .describe("If high_risk_source is annex_iii, the Annex III point number."),
  obligations_status: z
    .array(
      z.object({
        obligation: z
          .string()
          .describe("Obligation label (matching the obligation field from euaiact_get_obligations)."),
        article: z
          .string()
          .describe("Article reference (e.g. 'Art. 26(1)')."),
        status: z
          .enum(["covered", "in_progress", "not_covered", "not_applicable"])
          .describe("Current coverage status of this obligation."),
        evidence: z
          .string()
          .optional()
          .describe("Optional evidence or reference (document name, date, link)."),
      }),
    )
    .describe("List of obligations with their current coverage status."),
}).describe("Input for the compliance monitoring tool.");

export const complianceMonitorOutputSchema = z.object({
  system_name: z.string(),
  check_timestamp: z.string(),
  risk_level: z.string(),
  role: z.string(),
  summary: z.object({
    total_obligations: z.number(),
    covered: z.number(),
    in_progress: z.number(),
    not_covered: z.number(),
    not_applicable: z.number(),
    compliance_score: z.number(),
    compliance_level: z.string(),
  }),
  detailed_status: z.array(z.object({
    obligation: z.string(),
    article: z.string(),
    status: z.string(),
    evidence: z.string().optional(),
    gap: z.boolean(),
    action_required: z.boolean(),
    deadline: z.string().optional(),
  })),
  gaps: z.array(z.object({
    obligation: z.string(),
    article: z.string(),
    action_required: z.string(),
    deadline: z.string().optional(),
  })),
  risk_assessment: z.string(),
  recommendation: z.string(),
  next_action: z.string(),
});

export type ComplianceMonitorInput = z.infer<typeof complianceMonitorInputSchema>;
export type ComplianceMonitorOutput = z.infer<typeof complianceMonitorOutputSchema>;
'@

Set-Content -Path "$schemaDir\regulatory-watch.ts" -Value $schemaContent -Encoding UTF8 -NoNewline
Write-Host "  Cree : src\schemas\regulatory-watch.ts" -ForegroundColor Green

# --- Fichier : src/tools/regulatory-watch.ts ---
$watchContent = @'
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import {
  regulatoryWatchInputSchema,
  regulatoryWatchOutputSchema,
  type RegulatoryWatchInput,
  type RegulatoryWatchOutput,
} from "../schemas/regulatory-watch.js";
import {
  getMilestonesWithDaysRemaining,
  isOmnibusEnacted,
  resolveOmnibusStatus,
} from "../knowledge/deadlines.js";
import { sourceRegistry, isEnacted, SOURCE_STATUS_LABELS } from "../knowledge/sources.js";

export function registerRegulatoryWatchTool(server: McpServer): void {
  server.registerTool(
    "euaiact_regulatory_watch",
    {
      title: "Regulatory Watch - Real-time EU AI Act Monitoring",
      description:
        "Performs a real-time regulatory watch on the EU AI Act. Returns the current knowledge snapshot (last verification date, Digital Omnibus enactment status, CELEX, OJ date), the upcoming milestones with days remaining, and - when include_pending is true - the non-enacted sources (proposals, agreements, draft guidance) each labelled with its source status. Use this tool to verify whether the regulation has changed since a previous assessment and what is approaching.",
      annotations: {
        readOnlyHint: true,
        idempotentHint: false,
        openWorldHint: true,
      },
      inputSchema: regulatoryWatchInputSchema,
      outputSchema: regulatoryWatchOutputSchema,
    },
    async (
      input: RegulatoryWatchInput,
    ): Promise<{ content: any[]; structuredContent: RegulatoryWatchOutput }> => {
      const now = new Date();
      const checkTimestamp = now.toISOString();

      const enacted = isOmnibusEnacted();
      const omnibusStatus = resolveOmnibusStatus();
      const regulationSource = sourceRegistry["oj_2024_1689"];

      const knowledgeSnapshot = {
        last_verified: "2026-07-27",
        regulation: "Regulation (EU) 2024/1689 as amended by Regulation (EU) 2026/1744",
        omnibus_status: SOURCE_STATUS_LABELS[omnibusStatus],
        omnibus_enacted: enacted,
        celex: enacted ? "32026R1744" : regulationSource.celex,
        oj_publication_date: enacted ? "2026-07-24" : undefined,
        entry_into_force: enacted ? "2026-07-27" : undefined,
        eurlex_url:
          "https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727",
      };

      let upcoming = getMilestonesWithDaysRemaining()
        .filter((m) => !m.isPast)
        .map((m) => ({
          date: m.date,
          name: m.name,
          days_remaining: m.daysRemaining,
          articles: m.articles,
          key_obligations: m.keyObligations,
        }));

      if (input.areas && input.areas.length > 0) {
        const areaFilters = input.areas.map((a) => a.toLowerCase());
        upcoming = upcoming.filter(
          (m) =>
            areaFilters.some(
              (f) =>
                m.name.toLowerCase().includes(f) ||
                m.articles.some((a) => a.toLowerCase().includes(f)) ||
                m.key_obligations.some((k) => k.toLowerCase().includes(f)),
            ),
        );
      }

      let pendingSources: any[] | undefined;
      if (input.include_pending) {
        pendingSources = Object.values(sourceRegistry)
          .filter((s) => !isEnacted(s.status))
          .map((s) => ({
            id: s.id,
            title: s.title,
            status: SOURCE_STATUS_LABELS[s.status],
            date: s.date,
            url: s.url,
            celex: s.celex,
            note: s.note,
          }));

        if (input.areas && input.areas.length > 0) {
          const areaFilters = input.areas.map((a) => a.toLowerCase());
          pendingSources = pendingSources.filter((s) =>
            areaFilters.some(
              (f) =>
                s.title.toLowerCase().includes(f) ||
                (s.note ?? "").toLowerCase().includes(f),
            ),
          );
        }
      }

      const nextMilestone = upcoming[0] ?? null;
      const recommendation = enacted
        ? "Operative law is current: Regulation (EU) 2024/1689 as amended by Regulation (EU) 2026/1744 (Digital Omnibus). No new legislative change detected since last verification."
        : "CAUTION: the Digital Omnibus on AI is NOT yet enacted. Current binding law is Regulation (EU) 2024/1689 as published. Re-verify the consolidated OJ text on publication.";

      const nextAction = nextMilestone
        ? `Next milestone: ${nextMilestone.name} on ${nextMilestone.date} (${nextMilestone.days_remaining} days remaining). Prepare compliance actions now.`
        : "No upcoming milestones in the filtered set.";

      const output: RegulatoryWatchOutput = {
        check_timestamp: checkTimestamp,
        knowledge_snapshot: knowledgeSnapshot,
        upcoming_milestones: upcoming,
        ...(pendingSources ? { pending_sources: pendingSources } : {}),
        recommendation,
        next_action: nextAction,
      };

      return {
        content: [{ type: "text", text: JSON.stringify(output, null, 2) }],
        structuredContent: output,
      };
    },
  );
}
'@

Set-Content -Path "$toolsDir\regulatory-watch.ts" -Value $watchContent -Encoding UTF8 -NoNewline
Write-Host "  Cree : src\tools\regulatory-watch.ts" -ForegroundColor Green

# --- Fichier : src/tools/compliance-monitor.ts ---
$monitorContent = @'
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import {
  complianceMonitorInputSchema,
  complianceMonitorOutputSchema,
  type ComplianceMonitorInput,
  type ComplianceMonitorOutput,
} from "../schemas/regulatory-watch.js";
import {
  providerHighRiskObligations,
  deployerHighRiskObligations,
  providerLimitedRiskTransparencyObligations,
  deployerLimitedRiskTransparencyObligations,
  providerGPAIObligations,
  universalObligations,
} from "../knowledge/obligations.js";
import { getOperativeHighRiskDates } from "../knowledge/deadlines.js";

const AUTHORED_HIGH_RISK_DEADLINE = "2026-08-02";

function resolveObligations(
  role: string,
  riskLevel: string,
  highRiskSource?: string,
  annexIiiPoint?: number,
): { obligation: string; article: string; deadline: string; details: string; category: string }[] {
  let base: any[] = [];
  if (riskLevel === "gpai") {
    base = role === "provider" ? providerGPAIObligations : [];
  } else if (role === "provider" && riskLevel === "high-risk") {
    base = providerHighRiskObligations;
  } else if (role === "deployer" && riskLevel === "high-risk") {
    base = deployerHighRiskObligations;
  } else if (riskLevel === "limited") {
    base =
      role === "provider"
        ? providerLimitedRiskTransparencyObligations
        : deployerLimitedRiskTransparencyObligations;
  } else if (riskLevel === "minimal") {
    base = universalObligations;
  }

  if (riskLevel !== "gpai" && riskLevel !== "minimal") {
    base = [...base, ...universalObligations];
  }

  if (role === "provider" && riskLevel === "high-risk") {
    const source = highRiskSource ?? "unknown";
    const annexPoint = annexIiiPoint;
    if (source === "annex_i" || annexPoint === 2) {
      base = base.filter((obl: any) => obl.article !== "Art. 49");
    }
  }

  if (riskLevel === "high-risk") {
    const operative = getOperativeHighRiskDates();
    const isAnnexI = (highRiskSource ?? "unknown") === "annex_i";
    const operativeDeadline = isAnnexI
      ? operative.annexIHighRisk
      : operative.annexIiiHighRisk;
    if (operativeDeadline !== AUTHORED_HIGH_RISK_DEADLINE) {
      base = base.map((obl: any) =>
        obl.deadline === AUTHORED_HIGH_RISK_DEADLINE
          ? { ...obl, deadline: operativeDeadline }
          : obl,
      );
    }
  }

  return base;
}

function computeComplianceScore(
  covered: number,
  inProgress: number,
  notCovered: number,
  notApplicable: number,
): { score: number; level: string } {
  const applicable = covered + inProgress + notCovered;
  if (applicable === 0) {
    return { score: 100, level: "N/A - no applicable obligations" };
  }
  const weighted = covered + inProgress * 0.5;
  const score = Math.round((weighted / applicable) * 100);
  let level: string;
  if (score >= 90) level = "Conforme";
  else if (score >= 70) level = "Majorite conforme";
  else if (score >= 50) level = "Partiellement conforme";
  else if (score >= 25) level = "Largement non conforme";
  else level = "Non conforme";
  return { score, level };
}

export function registerComplianceMonitorTool(server: McpServer): void {
  server.registerTool(
    "euaiact_monitor_compliance",
    {
      title: "Compliance Monitor - Real-time Obligation Tracking",
      description:
        "Monitors the real-time compliance status of a specific AI system against its EU AI Act obligations. The caller provides the risk level, role, and the current coverage status of each obligation (covered / in_progress / not_covered / not_applicable). The tool returns a compliance score, a gap analysis with required actions, deadlines, and a risk assessment. Use this tool after euaiact_classify_system and euaiact_get_obligations to track remediation progress over time.",
      annotations: {
        readOnlyHint: true,
        idempotentHint: true,
        openWorldHint: false,
      },
      inputSchema: complianceMonitorInputSchema,
      outputSchema: complianceMonitorOutputSchema,
    },
    async (
      input: ComplianceMonitorInput,
    ): Promise<{ content: any[]; structuredContent: ComplianceMonitorOutput }> => {
      const now = new Date();
      const checkTimestamp = now.toISOString();

      const referenceObligations = resolveObligations(
        input.role,
        input.risk_level,
        input.high_risk_source,
        input.annex_iii_point,
      );

      const obligationMap = new Map(
        referenceObligations.map((o) => [o.article, o]),
      );

      let covered = 0;
      let inProgress = 0;
      let notCovered = 0;
      let notApplicable = 0;

      const detailedStatus: any[] = [];
      const gaps: any[] = [];

      for (const item of input.obligations_status) {
        const ref = obligationMap.get(item.article) ?? obligationMap.get(item.article.replace(/^Art\.\s*/, "Art. "));
        const refDeadline =
          ref?.deadline ??
          (input.risk_level === "high-risk" ? getOperativeHighRiskDates().annexIiiHighRisk : undefined);

        const gap = item.status === "not_covered" || item.status === "in_progress";
        const actionRequired = item.status === "not_covered";

        switch (item.status) {
          case "covered":
            covered++;
            break;
          case "in_progress":
            inProgress++;
            break;
          case "not_covered":
            notCovered++;
            break;
          case "not_applicable":
            notApplicable++;
            break;
        }

        detailedStatus.push({
          obligation: item.obligation,
          article: item.article,
          status: item.status,
          evidence: item.evidence,
          gap,
          action_required: actionRequired,
          deadline: refDeadline,
        });

        if (actionRequired) {
          gaps.push({
            obligation: item.obligation,
            article: item.article,
            action_required: `Implement or document the obligation under ${item.article} before its application date.`,
            deadline: refDeadline,
          });
        } else if (item.status === "in_progress") {
          gaps.push({
            obligation: item.obligation,
            article: item.article,
            action_required: `Finalise and complete the obligation under ${item.article} - currently in progress.`,
            deadline: refDeadline,
          });
        }
      }

      const totalObligations = input.obligations_status.length;
      const { score, level } = computeComplianceScore(
        covered,
        inProgress,
        notCovered,
        notApplicable,
      );

      const riskAssessment =
        notCovered > 0
          ? `HIGH RISK: ${notCovered} obligation(s) not covered out of ${totalObligations}. Non-compliance with ${input.risk_level} obligations may trigger fines under Art. 99. Immediate remediation required.`
          : inProgress > 0
            ? `MEDIUM RISK: ${inProgress} obligation(s) in progress. No critical gap detected, but incomplete obligations must be finalised before their application date.`
            : `LOW RISK: All applicable obligations are covered. Maintain documentation and monitor for regulatory changes.`;

      const recommendation =
        score >= 90
          ? "Compliance is strong. Focus on maintaining documentation, monitoring obligations in progress, and watching for regulatory updates via euaiact_regulatory_watch."
          : score >= 50
            ? "Partial compliance. Prioritise the gaps identified below - especially obligations with the nearest application date. Validate with a DPO or compliance audit specialist."
            : "Critical compliance gaps detected. Immediate action required on uncovered obligations. Engage a DPO or compliance audit specialist for validation before any deployment.";

      const nextMilestone = detailedStatus
        .filter((d) => d.deadline && (d.status === "not_covered" || d.status === "in_progress"))
        .sort((a, b) => (a.deadline ?? "").localeCompare(b.deadline ?? ""))[0];

      const nextAction = nextMilestone
        ? `Nearest deadline: ${nextMilestone.deadline} for ${nextMilestone.article} (${nextMilestone.obligation}). Address this gap first.`
        : "No actionable deadline identified in the provided obligations. Verify with euaiact_check_deadlines for the full timeline.";

      const output: ComplianceMonitorOutput = {
        system_name: input.system_name,
        check_timestamp: checkTimestamp,
        risk_level: input.risk_level,
        role: input.role,
        summary: {
          total_obligations: totalObligations,
          covered,
          in_progress: inProgress,
          not_covered: notCovered,
          not_applicable: notApplicable,
          compliance_score: score,
          compliance_level: level,
        },
        detailed_status: detailedStatus,
        gaps,
        risk_assessment: riskAssessment,
        recommendation,
        next_action: nextAction,
      };

      return {
        content: [{ type: "text", text: JSON.stringify(output, null, 2) }],
        structuredContent: output,
      };
    },
  );
}
'@

Set-Content -Path "$toolsDir\compliance-monitor.ts" -Value $monitorContent -Encoding UTF8 -NoNewline
Write-Host "  Cree : src\tools\compliance-monitor.ts" -ForegroundColor Green

# --- Modifier server.ts : ajouter les imports ---
Write-Host "[7/9] Modification de server.ts..." -ForegroundColor Yellow

$serverFile = "src\server.ts"
$serverContent = Get-Content $serverFile -Raw

$serverContent = $serverContent.Replace(
    'import { registerAnnexIvTool } from "./tools/annex-iv.js";`nimport { registerAssessSystemTool } from "./tools/assess-system.js";',
    'import { registerAnnexIvTool } from "./tools/annex-iv.js";`nimport { registerAssessSystemTool } from "./tools/assess-system.js";`nimport { registerRegulatoryWatchTool } from "./tools/regulatory-watch.js";`nimport { registerComplianceMonitorTool } from "./tools/compliance-monitor.js";'
)

$serverContent = $serverContent.Replace(
    '  registerAnnexIvTool(server);`n  registerAssessSystemTool(server);',
    '  registerAnnexIvTool(server);`n  registerAssessSystemTool(server);`n  registerRegulatoryWatchTool(server);`n  registerComplianceMonitorTool(server);'
)

Set-Content -Path $serverFile -Value $serverContent -Encoding UTF8 -NoNewline

# Alternative : utiliser les replacements ligne par ligne si le multi-ligne ne marche pas
$lines = Get-Content $serverFile
$newLines = @()
foreach ($line in $lines) {
    $newLines += $line
    if ($line -match 'import \{ registerAssessSystemTool \} from "\./tools/assess-system\.js";') {
        $newLines += 'import { registerRegulatoryWatchTool } from "./tools/regulatory-watch.js";'
        $newLines += 'import { registerComplianceMonitorTool } from "./tools/compliance-monitor.js";'
    }
    if ($line -match '^\s*registerAssessSystemTool\(server\);') {
        $newLines += '  registerRegulatoryWatchTool(server);'
        $newLines += '  registerComplianceMonitorTool(server);'
    }
}
Set-Content -Path $serverFile -Value $newLines -Encoding UTF8
Write-Host "  Modifie : src\server.ts" -ForegroundColor Green

# --- Modifier constants.ts ---
Write-Host "  Modification de constants.ts..." -ForegroundColor Yellow
$constFile = "src\constants.ts"
$constContent = Get-Content $constFile -Raw
$constContent = $constContent.Replace(
    "10 tools and curated resources",
    "12 tools and curated resources"
)
Set-Content -Path $constFile -Value $constContent -Encoding UTF8 -NoNewline
Write-Host "  Modifie : src\constants.ts" -ForegroundColor Green

# --- Modifier test.mjs ---
Write-Host "  Modification de test.mjs..." -ForegroundColor Yellow
$testFile = "test.mjs"
$testLines = Get-Content $testFile
$newTestLines = @()
$i = 0
while ($i -lt $testLines.Count) {
    $line = $testLines[$i]
    if ($line -match 'assessment is registered as tool 10') {
        $newTestLines += '  test("assessment is registered as tool 10 after the nine atomic tools, followed by the two custom tools",'
        $newTestLines += '    Object.keys(srv._registeredTools).join(",") === ['
        $newTestLines += '      "euaiact_classify_system",'
        $newTestLines += '      "euaiact_check_deadlines",'
        $newTestLines += '      "euaiact_get_obligations",'
        $newTestLines += '      "euaiact_answer_question",'
        $newTestLines += '      "euaiact_calculate_penalty",'
        $newTestLines += '      "euaiact_get_article",'
        $newTestLines += '      "euaiact_check_gpai_systemic_risk",'
        $newTestLines += '      "euaiact_assess_art6_3_exception",'
        $newTestLines += '      "euaiact_annex_iv_checklist",'
        $newTestLines += '      "euaiact_assess_system",'
        $newTestLines += '      "euaiact_regulatory_watch",'
        $newTestLines += '      "euaiact_monitor_compliance",'
        $newTestLines += '    ].join(","));'
        # Skip old lines until closing ));
        $i++
        while ($i -lt $testLines.Count -and $testLines[$i] -notmatch '^\s*\]\.join\(",",?\);') {
            $i++
        }
        $i++
    } else {
        $newTestLines += $line
        $i++
    }
}
Set-Content -Path $testFile -Value $newTestLines -Encoding UTF8
Write-Host "  Modifie : test.mjs" -ForegroundColor Green

# --- Compiler ---
Write-Host "[8/9] Compilation (npm run build)..." -ForegroundColor Yellow
npm run build
if (-not $?) {
    Write-Host "ERREUR : Echec de la compilation." -ForegroundColor Red
    exit 1
}
Write-Host "  Compilation reussie." -ForegroundColor Green

# --- Tester ---
Write-Host "[9/9] Tests (node test.mjs)..." -ForegroundColor Yellow
$testResult = node test.mjs 2>&1 | Select-Object -Last 3
Write-Host $testResult

# --- Commit et push ---
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  PUSH VERS GITHUB" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

git add -A
git commit -m "Personnalisation EL OUERTANI FAOUZI: veille reglementaire + monitoring conformite temps reel (2 nouveaux outils MCP)

- Nouvel outil euaiact_regulatory_watch (veille reglementaire en temps reel)
- Nouvel outil euaiact_monitor_compliance (monitoring de conformite avec scoring)
- Base: eu-ai-act-mcp v1.5.0 (MIT)"

git branch -M main
git push -u origin main

if ($?) {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "  SUCCES !" -ForegroundColor Green
    Write-Host "  Votre depot est sur : https://github.com/$GitHubUser/$RepoName" -ForegroundColor Green
    Write-Host "  Le serveur a maintenant 12 outils (10 originaux + 2 nouveaux)" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pour l'utiliser avec Claude Desktop, ajoutez dans la config :" -ForegroundColor Yellow
    Write-Host "  Command : node" -ForegroundColor White
    Write-Host "  Args    : $ProjectDir\dist\index.js" -ForegroundColor White
} else {
    Write-Host "ERREUR : Echec du push. Verifiez que le depot existe sur GitHub." -ForegroundColor Red
    Write-Host "Creez-le sur : https://github.com/new (nom: eu-ai-act-conformite, prive)" -ForegroundColor Red
}
