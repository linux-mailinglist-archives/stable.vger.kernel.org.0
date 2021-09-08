Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62926403BE1
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349052AbhIHO4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:56:07 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:53312
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233754AbhIHO4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 10:56:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TB4XJ7EIzlVs23soUGxKEBCpt5zJHJOuQ126NNy9wY4uWDhf5gODnMzj6XODwh3aNipRXz9M/1ppvQkzeIBF9sunw7CsOB9xxI+69RtQFL2cNBmF460RDBnwh63Mk7I2NWDTTh90ctx4g+rJEaLKyTRjMQjyU2NrBnp1dYc/clZZNtJmmJEtHqIYrWnA0eo1BYC4OIdkVHQiVaiGpBLxS8VWRf5gqIh8oxsdlmOLQCeyAj1tPz+iZLypMm/SSJFvmpvi4D+KoGYjjvWHCfOEIwXMM/Csk8Vau4Dobq7DXEC1tlshViLWETbXzI/FG6Q/h7GJt4kxvU4hV+h+SWqSaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MWyYM9TQjmJUFocsNeqP6PNlviP203C8n0kxI7tch9Y=;
 b=QkthVbQFPgxGfTEeCJumNAzQQd9vG7Ks2BGtkw0lbXMXh412GVA0cHPpBkCl6cf5kpHyJf45FhV2G6C8SpLeWnDHglbRgyb2QEo17qMnlulFqY3N8oZVqxmxMgPkV/Bu9OiMyBYe85TgY7rw52Ld8rEvJbRdr4MDbTlLCP2nXeF2ryUlDXZBlaOZgK53wCKNcMCwWJio20Ni42d1IHObX/5FCG+joVFWqBLhSNSM2giAx3gXvgCboMMHJGk5f2my7+5ygpe7ACsZQ4IT52YtNcug4ZuCzhIctlhAK+3kPNITz6GqdPBl3X142MUlTXmyRklcwC+lCZhYEKivouzh0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWyYM9TQjmJUFocsNeqP6PNlviP203C8n0kxI7tch9Y=;
 b=N/IHYTQcJB0A3mbSDJ37/WOaAUsWfON6Wqn2MBSc35ganINV/iZjRXor5B4Z4IiGR/6ajZbTh7RevebsjgNkpVLwEE3kL9ayBiGY9GpxwyGl0uuBpAppTztxTsDykVF8lszMeCSyaWoHa7unBI9dPcezOYMeUnsvTyP6K1bH490=
Received: from DM5PR13CA0015.namprd13.prod.outlook.com (2603:10b6:3:23::25) by
 CH2PR12MB4874.namprd12.prod.outlook.com (2603:10b6:610:64::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Wed, 8 Sep 2021 14:54:57 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::97) by DM5PR13CA0015.outlook.office365.com
 (2603:10b6:3:23::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend
 Transport; Wed, 8 Sep 2021 14:54:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 14:54:57 +0000
Received: from DESKTOP-9DR2N9S.localdomain (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 8 Sep 2021 09:54:54 -0500
From:   Mikita Lipski <mikita.lipski@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <mikita.lipski@amd.com>, <roman.li@amd.com>, <Anson.Jacob@amd.com>,
        <wayne.lin@amd.com>, <stylon.wang@amd.com>, <solomon.chiu@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        <stable@vger.kernel.org>, Josip Pavic <josip.pavic@amd.com>
Subject: [PATCH 16/33] drm/amd/display: Get backlight from PWM if DMCU is not initialized
Date:   Wed, 8 Sep 2021 10:54:07 -0400
Message-ID: <20210908145424.3311-17-mikita.lipski@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 328d6ede-5414-4ef0-6801-08d972d89ff9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4874:
X-Microsoft-Antispam-PRVS: <CH2PR12MB48746FE2526752D94B1628ADE4D49@CH2PR12MB4874.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A6arXKyofO7FyxQ7Q2UjKR3D87TKSiZQ5xEXAaLATVVwKQjK+/B04+gB7YuqKU6dQX5iNVf+D4P/HHlR++WItzc49ICK6XY5ge6bULXF/u226SR+e74laPYne+MXpvE/tGYoPZXWZ3qrKcpquKiS4JcFxxjtVslRtCqvmcSYDQSMj6spelwe47o4YmgapTsqUkNtroA9Z1IYzsFNJL8NFRVZNFSzWOxxviKn8jxO6EGdaFhTH7xNfwxkyVmrK5Cn9KDsG9mdFKcumMPzgUVRTg8c6svZHm3qJvwtvf+t+9/HjdzzdU8Jhk8YVUK7wOJzLRNLu+9LH5Iq1xAJZ1UlAl2b/PLpkVKWvNxhMoYNCs56wgUl1gFTJoRGSySqVCC4GoEfBnSOBvNp7Cs3KWlKh/uG799O6CqKDnPY9k1ojKxAcO/6VvoXWrVg2f7dN7r6cz9tNkzhigVa/XKOGdr+0trHiYHmjsn5t7ogcorQn/TVbSCOnGHKq54lGI/vqwPV26gukGZ3/ayYtJJ+/iAPJbkDexfPDlLEuuxupeq2eqKGZAWUzFA1nrfVeiR1FYyLCqrNZb1Q+hu8YloL5ZT1fLUPzxFwbgkcFsUOfdtJLs8P1b0GQI/Fv9FtlbXHXWWakKzRfd2lkQOpElUjha4EiNY47W8sjIdWWUrtEgru48TAeVE2oxt28V1l2MUXQH6r7vVvQprwP+RQZBPwaNxzwyZSK2Hl9FUg+tSqZ/tJIDs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(36840700001)(47076005)(6916009)(70206006)(70586007)(4326008)(44832011)(8676002)(8936002)(83380400001)(966005)(478600001)(2616005)(6666004)(26005)(82740400003)(86362001)(16526019)(1076003)(316002)(36860700001)(54906003)(426003)(186003)(336012)(82310400003)(2906002)(81166007)(356005)(5660300002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 14:54:57.1141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 328d6ede-5414-4ef0-6801-08d972d89ff9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4874
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

On Carrizo/Stoney systems we set backlight through panel_cntl, i.e.
directly via the PWM registers, if DMCU is not initialized. We
always read it back through ABM registers which leads to a
mismatch and forces atomic_commit to program the backlight
each time.

Instead make sure we use the same logic for backlight readback,
i.e. read it from panel_cntl if DMCU is not initialized.

We also need to remove some extraneous and incorrect calculations
at the end of dce_get_16_bit_backlight_from_pwm.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1666
Cc: stable@vger.kernel.org

Reviewed-by: Josip Pavic <josip.pavic@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c    | 16 ++++++++++++----
 .../gpu/drm/amd/display/dc/dce/dce_panel_cntl.c  | 10 ----------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 3c8eb3e659af..61e49671fed5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2752,13 +2752,21 @@ static struct abm *get_abm_from_stream_res(const struct dc_link *link)
 
 int dc_link_get_backlight_level(const struct dc_link *link)
 {
-
 	struct abm *abm = get_abm_from_stream_res(link);
+	struct panel_cntl *panel_cntl = link->panel_cntl;
+	struct dc  *dc = link->ctx->dc;
+	struct dmcu *dmcu = dc->res_pool->dmcu;
+	bool fw_set_brightness = true;
 
-	if (abm == NULL || abm->funcs->get_current_backlight == NULL)
-		return DC_ERROR_UNEXPECTED;
+	if (dmcu)
+		fw_set_brightness = dmcu->funcs->is_dmcu_initialized(dmcu);
 
-	return (int) abm->funcs->get_current_backlight(abm);
+	if (!fw_set_brightness && panel_cntl->funcs->get_current_backlight)
+		return panel_cntl->funcs->get_current_backlight(panel_cntl);
+	else if (abm != NULL && abm->funcs->get_current_backlight != NULL)
+		return (int) abm->funcs->get_current_backlight(abm);
+	else
+		return DC_ERROR_UNEXPECTED;
 }
 
 int dc_link_get_target_backlight_pwm(const struct dc_link *link)
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
index e92339235863..e8570060d007 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
@@ -49,7 +49,6 @@
 static unsigned int dce_get_16_bit_backlight_from_pwm(struct panel_cntl *panel_cntl)
 {
 	uint64_t current_backlight;
-	uint32_t round_result;
 	uint32_t bl_period, bl_int_count;
 	uint32_t bl_pwm, fractional_duty_cycle_en;
 	uint32_t bl_period_mask, bl_pwm_mask;
@@ -84,15 +83,6 @@ static unsigned int dce_get_16_bit_backlight_from_pwm(struct panel_cntl *panel_c
 	current_backlight = div_u64(current_backlight, bl_period);
 	current_backlight = (current_backlight + 1) >> 1;
 
-	current_backlight = (uint64_t)(current_backlight) * bl_period;
-
-	round_result = (uint32_t)(current_backlight & 0xFFFFFFFF);
-
-	round_result = (round_result >> (bl_int_count-1)) & 1;
-
-	current_backlight >>= bl_int_count;
-	current_backlight += round_result;
-
 	return (uint32_t)(current_backlight);
 }
 
-- 
2.25.1

