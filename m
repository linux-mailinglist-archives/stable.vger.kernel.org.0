Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34B13F7FA7
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhHZBK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 21:10:58 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:45569
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235172AbhHZBK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Aug 2021 21:10:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZkGwMQ499mGoZG1+/iOF7zt7Mnq4QQh0Fd3JY5pyeJm2LBc97Z8nlFfzk3NalPP1dEjSdtwpx1+8i6X06mjWi+ioAJVak7Gv3RPEQ1/Y7z2Yw0A4MTQUeAzfTvLsD07rX1QE+rux8V91yBBBAISu23QY60DynAKpL+AqZD9iEdgynbr6Ez3XyA2gGr77R8LK7+uAipxbdWngG9MIfL/35E2ynQ2b5AEgLg5EPS8ZERlB0uqvsbhLed6tMbIbUA9peREQ60qDuYgV3qdtDKAB+0AiZb2tMFSIvgxPCxrqyPdsWCOUKQMIEeEg17W35yadyJYjHKrX/fvLYRHoKk9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44yXU7nuuKpRgj0svW8oJ+GAjct6iDXfZis5dLxv7QY=;
 b=KaK6aeHM/hFdZANtZ+p/h8pf0NZ2Cz9dqM9emTyoJ2GCLDKEo8v2e3UGi2S2L9Fxz3geYxNzXFiLN2WK7EZUcT6JnQBcyfdMTFj7nwTPRgrz0cgjb/JL5c7G+IGAzv20QYnlYMvg2VM6xTLBoHBtmKV7vD2Clhk0UzLiVmH96Pjwe73+ZPJemQ8QfGolBVi1hsioLo8c6LnUYb0UrSImrGKoNXPmBgIHgUtUviRPDErRCCnA1Soz6d356fhPbYK3B4wpA5oydjPTfrLx5BBIJZMNXAIGmZvZ0sLbacJ+RVbBQOaCXDQH539G72+OrnFAcwL9p3BOiqkzf/UpiE44cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44yXU7nuuKpRgj0svW8oJ+GAjct6iDXfZis5dLxv7QY=;
 b=qvl6lAC/TrR3LkBoK7bUko029emvg0IJepX18N8vP5Gap8JZZkVy2rBU+hj5MY8RmY0WIDmnEc8+3ROVTgrGsZhiR6o7x/IMo5hmIeoODLEDKEBUv8xt/boB5QFiUkBtM7zup2jvqZUm26WMqVx6JI2kITonJZWeEIKDSXa76sc=
Received: from DM5PR08CA0043.namprd08.prod.outlook.com (2603:10b6:4:60::32) by
 DM5PR12MB1691.namprd12.prod.outlook.com (2603:10b6:4:8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Thu, 26 Aug 2021 01:10:09 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::7b) by DM5PR08CA0043.outlook.office365.com
 (2603:10b6:4:60::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Thu, 26 Aug 2021 01:10:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 01:10:08 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Wed, 25 Aug
 2021 20:10:06 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Wed, 25 Aug
 2021 20:10:06 -0500
Received: from elite-desk-aura.lan (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.12 via Frontend
 Transport; Wed, 25 Aug 2021 20:10:05 -0500
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <nicholas.kazlauskas@amd.com>,
        <alexander.deucher@amd.com>, <aurabindo.pillai@amd.com>,
        "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/4] drm/amd/display: Update bounding box states (v2)
Date:   Wed, 25 Aug 2021 21:10:00 -0400
Message-ID: <20210826011002.425361-2-aurabindo.pillai@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826011002.425361-1-aurabindo.pillai@amd.com>
References: <20210826011002.425361-1-aurabindo.pillai@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b5ee877-601c-4bc7-a060-08d9682e3f28
X-MS-TrafficTypeDiagnostic: DM5PR12MB1691:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1691F1EB54EE154FE1DF40FA8BC79@DM5PR12MB1691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7rUjZaFBEoRY/EAtJsinAB7WqerQvWUajVQEAgbo59Dsfz1qJKhFua+2TiQEwBqvbfgJP8enKdEi9XBE+hd9y0Gwm7pN+weDhWH8WvCPJ8toVsPoSUcMf3Ikdkg8So4fkgc1/LrWHREF6LTEJauZGn2cJF2mxw2tLEM2JPYrC7Hzn6Oes2NtK/p7Q4g9BqHk97SZ1UgrSMgJiPW24+ukhZdZG8kiOR2Q4WVXIPrOYoaO5iCm3KZdGf3PAn47+jndFs2WDjKRIcXZOorAAemGZzu+5J+rnFAKXGPiYWVsfa7L1bxco8ECrp+zn6c2A/ZR1CdKo3CUylI0cGpY7XgM+atcT2pR1x5Vk1EsyHyQjtefGH9d3Q8nN2EMMyQeKnKcsMlXda2LXrHczDnl2aoVNgMgWX2Lbd9GzG1sr0rSFBfR0TYBvFXsZLHFZbbx0EkAgll3T6rTqIwH2KJmMOgLuOCgwLY5EOkOTOvX4mmG2OcN+XKziZ3DnVdYjSb9fWAMpgRtZLNFK4j2ljLfyrE6ILl+uPgKHb6BYAMKipfA+SyBIBmiZSb3ljBLqu0k2Kq95QQx18fnKQ3NJq72zS7u78mnf5vRb3d4Crha0M8jvidWasEQbW9VGgEmucixeUbYoQSlUC2kBzQegXDn68Ua/hS52RoGQMBm3nY8+NcS+IYo4jUvFToswjm+3od7OmqWBU63vGeFSkP5suleUswvdNEH0n7I5wkaCorLFwL0UGKDKqRxYqLO2SceqJVgm17LKhNlweatSRqWue3pyMR3w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(70206006)(26005)(36756003)(82740400003)(6666004)(1076003)(70586007)(47076005)(2616005)(8936002)(6916009)(44832011)(82310400003)(36860700001)(81166007)(8676002)(356005)(83380400001)(426003)(186003)(336012)(4326008)(2906002)(86362001)(316002)(54906003)(5660300002)(478600001)(117716001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 01:10:08.4169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5ee877-601c-4bc7-a060-08d9682e3f28
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1691
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>

[Why]
Drop hardcoded dispclk, dppclk, phyclk

[How]
Read the corresponding values from clock table entries already populated.

Signed-off-by: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: stable@vger.kernel.org
---
 .../drm/amd/display/dc/dcn30/dcn30_resource.c | 41 ++++++++++++++-----
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 43ac6f42dd80..3d2443328345 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2398,16 +2398,37 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 	dc->dml.soc.dispclk_dppclk_vco_speed_mhz = dc->clk_mgr->dentist_vco_freq_khz / 1000.0;
 
 	if (bw_params->clk_table.entries[0].memclk_mhz) {
+		int max_dcfclk_mhz = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0, max_phyclk_mhz = 0;
+
+		for (i = 0; i < MAX_NUM_DPM_LVL; i++) {
+			if (bw_params->clk_table.entries[i].dcfclk_mhz > max_dcfclk_mhz)
+				max_dcfclk_mhz = bw_params->clk_table.entries[i].dcfclk_mhz;
+			if (bw_params->clk_table.entries[i].dispclk_mhz > max_dispclk_mhz)
+				max_dispclk_mhz = bw_params->clk_table.entries[i].dispclk_mhz;
+			if (bw_params->clk_table.entries[i].dppclk_mhz > max_dppclk_mhz)
+				max_dppclk_mhz = bw_params->clk_table.entries[i].dppclk_mhz;
+			if (bw_params->clk_table.entries[i].phyclk_mhz > max_phyclk_mhz)
+				max_phyclk_mhz = bw_params->clk_table.entries[i].phyclk_mhz;
+		}
+
+		if (!max_dcfclk_mhz)
+			max_dcfclk_mhz = dcn3_0_soc.clock_limits[0].dcfclk_mhz;
+		if (!max_dispclk_mhz)
+			max_dispclk_mhz = dcn3_0_soc.clock_limits[0].dispclk_mhz;
+		if (!max_dppclk_mhz)
+			max_dppclk_mhz = dcn3_0_soc.clock_limits[0].dppclk_mhz;
+		if (!max_phyclk_mhz)
+			max_phyclk_mhz = dcn3_0_soc.clock_limits[0].phyclk_mhz;
 
-		if (bw_params->clk_table.entries[1].dcfclk_mhz > dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
+		if (max_dcfclk_mhz > dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
 			// If max DCFCLK is greater than the max DCFCLK STA target, insert into the DCFCLK STA target array
-			dcfclk_sta_targets[num_dcfclk_sta_targets] = bw_params->clk_table.entries[1].dcfclk_mhz;
+			dcfclk_sta_targets[num_dcfclk_sta_targets] = max_dcfclk_mhz;
 			num_dcfclk_sta_targets++;
-		} else if (bw_params->clk_table.entries[1].dcfclk_mhz < dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
+		} else if (max_dcfclk_mhz < dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
 			// If max DCFCLK is less than the max DCFCLK STA target, cap values and remove duplicates
 			for (i = 0; i < num_dcfclk_sta_targets; i++) {
-				if (dcfclk_sta_targets[i] > bw_params->clk_table.entries[1].dcfclk_mhz) {
-					dcfclk_sta_targets[i] = bw_params->clk_table.entries[1].dcfclk_mhz;
+				if (dcfclk_sta_targets[i] > max_dcfclk_mhz) {
+					dcfclk_sta_targets[i] = max_dcfclk_mhz;
 					break;
 				}
 			}
@@ -2447,7 +2468,7 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 				dcfclk_mhz[num_states] = dcfclk_sta_targets[i];
 				dram_speed_mts[num_states++] = optimal_uclk_for_dcfclk_sta_targets[i++];
 			} else {
-				if (j < num_uclk_states && optimal_dcfclk_for_uclk[j] <= bw_params->clk_table.entries[1].dcfclk_mhz) {
+				if (j < num_uclk_states && optimal_dcfclk_for_uclk[j] <= max_dcfclk_mhz) {
 					dcfclk_mhz[num_states] = optimal_dcfclk_for_uclk[j];
 					dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 				} else {
@@ -2462,7 +2483,7 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 		}
 
 		while (j < num_uclk_states && num_states < DC__VOLTAGE_STATES &&
-				optimal_dcfclk_for_uclk[j] <= bw_params->clk_table.entries[1].dcfclk_mhz) {
+				optimal_dcfclk_for_uclk[j] <= max_dcfclk_mhz) {
 			dcfclk_mhz[num_states] = optimal_dcfclk_for_uclk[j];
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
@@ -2475,9 +2496,9 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 			dcn3_0_soc.clock_limits[i].dram_speed_mts = dram_speed_mts[i];
 
 			/* Fill all states with max values of all other clocks */
-			dcn3_0_soc.clock_limits[i].dispclk_mhz = bw_params->clk_table.entries[1].dispclk_mhz;
-			dcn3_0_soc.clock_limits[i].dppclk_mhz  = bw_params->clk_table.entries[1].dppclk_mhz;
-			dcn3_0_soc.clock_limits[i].phyclk_mhz  = bw_params->clk_table.entries[1].phyclk_mhz;
+			dcn3_0_soc.clock_limits[i].dispclk_mhz = max_dispclk_mhz;
+			dcn3_0_soc.clock_limits[i].dppclk_mhz  = max_dppclk_mhz;
+			dcn3_0_soc.clock_limits[i].phyclk_mhz  = max_phyclk_mhz;
 			dcn3_0_soc.clock_limits[i].dtbclk_mhz = dcn3_0_soc.clock_limits[0].dtbclk_mhz;
 			/* These clocks cannot come from bw_params, always fill from dcn3_0_soc[1] */
 			/* FCLK, PHYCLK_D18, SOCCLK, DSCCLK */
-- 
2.30.2

