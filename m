Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE2403BED
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349193AbhIHO4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:56:18 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:60160
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233754AbhIHO4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 10:56:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqeqOLiOt78Tzzs+yIsUkd4eJ8bY/hYPSS/VFIXBAUpcTlJ8Bw+O+28ZuACRDtugNL+VSEWO7hFocJu8cKui+rO9e+jdFJ5BNrMosIdkgdIqO8lsCPO4mfJzthPSXb5IbwCYVLwVzaGp10Z0ogzvx8FReOA6vSthzFpEXHTozoeq2X4Boa0jtyj1B9A1HQy2wAGjpF9/4OtqEV2KVB7bwKWBcx4E0ewNoZUIPEhH1ih1esmO0oG1joUVtsPVg91Hd6ffY+jSaS5O14gQ5P092L0PyDvGv2ZkLiPwfzdQak2mKX0ObptKuiHPl49wkd56B01ajF9+wcQpuHyxiGuOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZYj+a3vFIz/VTk3GSZ7HjVDs2Ms11Q/Ih0RSZlfYe0=;
 b=nVCu19pyg19sEZV9ltLobnKxHI8avka3j349Y+s2WP4Aqnm3RiezVLGFBbHiMC0l08lhq+2SPaiH0fyCE7ApVmbrj88oUNKXt0+4acP/fDFjlgsiTpMBZfl/OGenTJRqKn8JfXP30wN1fJjJm63WwioWjDRY/SGCWdPreCdCskU8cmP3g9+aKR0AfgxWJqUjyLuVAxJA9egIF0m2i4ZcOpc3tnZ2CNgrh9xvCMfb3AhfuYjHb+AHVV/yh8wzwpnSt2bW/4YZ3ZFIyHORZZYwPVSZDsaYdJ3S7bD7gF8cxc70YNf0o0PwH+bMLtr4bpIhfgIAEsD7wxssRzYlvqtCkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZYj+a3vFIz/VTk3GSZ7HjVDs2Ms11Q/Ih0RSZlfYe0=;
 b=d/dz8rEa9lla7PTaWLLmzKdUx5IvFFMdGoUTne6lx8FaZv5RfJ5pCTzdiuM3yXLPm4dYDPQqwd+bjb15yCwSWIfCY9EeUH5P50XkOq7r0wFErZ2FkUmfsouqbrEhjNfcErlkbKRfbSFlU5PB/XoHYKDf4bhhCTp6tHVuHAW9lGI=
Received: from DM5PR13CA0052.namprd13.prod.outlook.com (2603:10b6:3:117::14)
 by BYAPR12MB2695.namprd12.prod.outlook.com (2603:10b6:a03:71::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 8 Sep
 2021 14:55:03 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::37) by DM5PR13CA0052.outlook.office365.com
 (2603:10b6:3:117::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend
 Transport; Wed, 8 Sep 2021 14:55:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 14:55:02 +0000
Received: from DESKTOP-9DR2N9S.localdomain (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 8 Sep 2021 09:55:01 -0500
From:   Mikita Lipski <mikita.lipski@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <mikita.lipski@amd.com>, <roman.li@amd.com>, <Anson.Jacob@amd.com>,
        <wayne.lin@amd.com>, <stylon.wang@amd.com>, <solomon.chiu@amd.com>,
        Hersen Wu <hersenwu@amd.com>, <stable@vger.kernel.org>,
        Scott Foster <Scott.Foster@amd.com>
Subject: [PATCH 22/33] drm/amd/display: dsc mst 2 4K displays go dark with 2 lane HBR3
Date:   Wed, 8 Sep 2021 10:54:13 -0400
Message-ID: <20210908145424.3311-23-mikita.lipski@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210908145424.3311-1-mikita.lipski@amd.com>
References: <20210908145424.3311-1-mikita.lipski@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5135934f-f20d-4fdd-f4b8-08d972d8a34a
X-MS-TrafficTypeDiagnostic: BYAPR12MB2695:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2695ED98BF646D8263AEC9AFE4D49@BYAPR12MB2695.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:419;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmUJqWEfXz1bSF9rm+jHUW090d3p51kNZNhGTH0BPy6mYjfXYSpsWUnS4JZaXZxeD1XF2f1G4bnQPka4eRcfb2lQuB7cb+8+BnA0xANjzyZd7NTJCU3RIzHRjYh1mTkNmD2tDBqp94JhQvQ7B2b+UDE9tU1SRM2DjfmCswQMH/h182F9stRN1LUzBSHBWYphWXdTM0ZJn3m+FcjZyK3NL8FsPl2O/oYk3CGeHOYI6nFxx13jA+O5IE8DGQC12PsoLVhwrrfq8hjtJc2C/hwD0lyyJxqqAigdi3+yCaoG2S9DfYcVBk7m/2cqxJpJO3e5HbNZnXJBDSTsKUtNDZ1HFNyWaaECoNyOmy77t5YaYg5woddyz/BaVGNnze3fsXqIIge0PmLyLNreIT1nOnDip6c/P2I7oyzpF6r4+BmH+SILY4unquLYTTv7JveDKb+Ftm0fC+4pQ3gKUfaBNO7jjrIIjEzvyzMSV0E1gwMZSP4khEktUdAajpY3bwPSUAKdW/WDFklg9sPuOIsh/IFFv5IBk9eU09bFDSKhDXO1wPWLO+MxgdbbdQJdhoSeidXzgxpVaBnDqrGuCY0OIhh5pTRYd5t+n2+FdxkB8LtDQtN0XT0roIjkP+0TylC9Av0/VxyD4FkRvVYzjIo8tKmYrpqEaOpGifhwGgNiqBurV8iDDQFXVBMJMIuJBTrdbSs0a8VMSpbh1VchUrQTsokjYMHjDTd1jO+xrls+E83kjjU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(36840700001)(47076005)(82740400003)(81166007)(186003)(54906003)(1076003)(70206006)(4326008)(6916009)(6666004)(356005)(478600001)(5660300002)(83380400001)(36756003)(86362001)(316002)(336012)(36860700001)(8936002)(8676002)(2616005)(82310400003)(44832011)(2906002)(426003)(16526019)(26005)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 14:55:02.6747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5135934f-f20d-4fdd-f4b8-08d972d8a34a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2695
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hersen Wu <hersenwu@amd.com>

[Why]
call stack of amdgpu dsc mst pbn, slot num calculation is as below:
-compute_bpp_x16_from_target_bandwidth
-decide_dsc_target_bpp_x16
-setup_dsc_config
-dc_dsc_compute_bandwidth_range
-compute_mst_dsc_configs_for_link
-compute_mst_dsc_configs_for_state

from pbn -> dsc target bpp_x16

bpp_x16 is calulated by compute_bpp_x16_from_target_bandwidth.
Beside pixel clock and bpp, num_slices_h and bpp_increment_div
will also affect bpp_x16.

from dsc target bpp_x16 -> pbn

within dm_update_mst_vcpi_slots_for_dsc,
pbn = drm_dp_calc_pbn_mode(clock, bpp_x16, true);

drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc)
{
  return DIV_ROUND_UP_ULL(mul_u32_u32(clock * (bpp / 16), 64 * 1006),
            8 * 54 * 1000 * 1000);
}

bpp / 16 trunc digits after decimal point. This will cause calculation
delta. drm_dp_calc_pbn_mode does not have other informations,
like num_slices_h, bpp_increment_div. therefore, it does not do revese
calcuation properly from bpp_x16 to pbn.

pbn from drm_dp_calc_pbn_mode is less than pbn from
compute_mst_dsc_configs_for_state. This cause not enough mst slot
allocated to display. display could not visually light up.

[How]
pass pbn from compute_mst_dsc_configs_for_state to
dm_update_mst_vcpi_slots_for_dsc

Cc: stable@vger.kernel.org

Reviewed-by: Scott Foster <Scott.Foster@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Hersen Wu <hersenwu@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 22 ++++++++++++++-----
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 18 +++++++--------
 .../display/amdgpu_dm/amdgpu_dm_mst_types.h   | 11 +++++++++-
 3 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a6c8c30f8c2d..87499ef5282c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7090,14 +7090,15 @@ const struct drm_encoder_helper_funcs amdgpu_dm_encoder_helper_funcs = {
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
-					    struct dc_state *dc_state)
+					    struct dc_state *dc_state,
+					    struct dsc_mst_fairness_vars *vars)
 {
 	struct dc_stream_state *stream = NULL;
 	struct drm_connector *connector;
 	struct drm_connector_state *new_con_state;
 	struct amdgpu_dm_connector *aconnector;
 	struct dm_connector_state *dm_conn_state;
-	int i, j, clock, bpp;
+	int i, j, clock;
 	int vcpi, pbn_div, pbn = 0;
 
 	for_each_new_connector_in_state(state, connector, new_con_state, i) {
@@ -7136,9 +7137,15 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 		}
 
 		pbn_div = dm_mst_get_pbn_divider(stream->link);
-		bpp = stream->timing.dsc_cfg.bits_per_pixel;
 		clock = stream->timing.pix_clk_100hz / 10;
-		pbn = drm_dp_calc_pbn_mode(clock, bpp, true);
+		/* pbn is calculated by compute_mst_dsc_configs_for_state*/
+		for (j = 0; j < dc_state->stream_count; j++) {
+			if (vars[j].aconnector == aconnector) {
+				pbn = vars[j].pbn;
+				break;
+			}
+		}
+
 		vcpi = drm_dp_mst_atomic_enable_dsc(state,
 						    aconnector->port,
 						    pbn, pbn_div,
@@ -10542,6 +10549,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	int ret, i;
 	bool lock_and_validation_needed = false;
 	struct dm_crtc_state *dm_old_crtc_state;
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	struct dsc_mst_fairness_vars vars[MAX_PIPES];
+#endif
 
 	trace_amdgpu_dm_atomic_check_begin(state);
 
@@ -10772,10 +10782,10 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-		if (!compute_mst_dsc_configs_for_state(state, dm_state->context))
+		if (!compute_mst_dsc_configs_for_state(state, dm_state->context, vars))
 			goto fail;
 
-		ret = dm_update_mst_vcpi_slots_for_dsc(state, dm_state->context);
+		ret = dm_update_mst_vcpi_slots_for_dsc(state, dm_state->context, vars);
 		if (ret)
 			goto fail;
 #endif
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 705f2e67edb5..1a99fcc27078 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -518,12 +518,7 @@ struct dsc_mst_fairness_params {
 	uint32_t num_slices_h;
 	uint32_t num_slices_v;
 	uint32_t bpp_overwrite;
-};
-
-struct dsc_mst_fairness_vars {
-	int pbn;
-	bool dsc_enabled;
-	int bpp_x16;
+	struct amdgpu_dm_connector *aconnector;
 };
 
 static int kbps_to_peak_pbn(int kbps)
@@ -750,12 +745,12 @@ static void try_disable_dsc(struct drm_atomic_state *state,
 
 static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 					     struct dc_state *dc_state,
-					     struct dc_link *dc_link)
+					     struct dc_link *dc_link,
+					     struct dsc_mst_fairness_vars *vars)
 {
 	int i;
 	struct dc_stream_state *stream;
 	struct dsc_mst_fairness_params params[MAX_PIPES];
-	struct dsc_mst_fairness_vars vars[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	int count = 0;
 	bool debugfs_overwrite = false;
@@ -776,6 +771,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		params[count].timing = &stream->timing;
 		params[count].sink = stream->sink;
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
+		params[count].aconnector = aconnector;
 		params[count].port = aconnector->port;
 		params[count].clock_force_enable = aconnector->dsc_settings.dsc_force_enable;
 		if (params[count].clock_force_enable == DSC_CLK_FORCE_ENABLE)
@@ -798,6 +794,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	}
 	/* Try no compression */
 	for (i = 0; i < count; i++) {
+		vars[i].aconnector = params[i].aconnector;
 		vars[i].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 		vars[i].dsc_enabled = false;
 		vars[i].bpp_x16 = 0;
@@ -851,7 +848,8 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 }
 
 bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state)
+				       struct dc_state *dc_state,
+				       struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
@@ -882,7 +880,7 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			return false;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link)) {
+		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars)) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
 			return false;
 		}
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index b38bd68121ce..900d3f7a8498 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -39,8 +39,17 @@ void
 dm_dp_create_fake_mst_encoders(struct amdgpu_device *adev);
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
+
+struct dsc_mst_fairness_vars {
+	int pbn;
+	bool dsc_enabled;
+	int bpp_x16;
+	struct amdgpu_dm_connector *aconnector;
+};
+
 bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state);
+				       struct dc_state *dc_state,
+				       struct dsc_mst_fairness_vars *vars);
 #endif
 
 #endif
-- 
2.25.1

