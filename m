Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F623FA097
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 22:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhH0Uaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 16:30:35 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:42368
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230171AbhH0Uaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 16:30:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imrjNgCEJdSFskMF6pHPLVFxpV2Pdw8d8TzApf1C13WehTfibk5gHRYbWFDphxW1E9iF4joXmuSfC6rhpUjnRLFguO8q2QE6BIeEqgg5pMbTIhefc6re1MWewIJnXx0q7YxEjpQ1NifT3py6wVJTg5jkjYdb2EOP5LH9Anh4Xdu5i4VwykfhCzud//vdsFtdlPqb8HjKOLs2u79sc/bxjn7rWJYRnhDx0cjW64pzIKrN6huQ55hriuBt3gnirNAEBmjCyD+bag4M1buu6VBYTxdWrzW6k6Yb84I/NW+mKj9b/1ImI8UApaXdr1k5e6iJ2BzZWQ+KVgwVnZun+urHIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsOccHAhn48xlRq0cvV64zgZ7ahgfGzv1yKNF1hJw18=;
 b=ZQzsSMA5oFDEzpvJk7sjxzufP4rnhPz4dqHzimrXT9VJQro8keLOcFj88Seo8PF65bjHgSzHL47I5lohePPug8Kswdq2QJ7jolpseJUXzHFb8CfnuiI90DbtBwjiTt1KxtEwXTnc7E08UWzWtSN2upjq3gPis8DPEm9R4WxeKxMM/B5u+W5SzNcBJrsdF3tnd8SucyhmlqWmVQuXaW/hTMIMFoXhOksaKjNWEXgx10C/Nk4TbCW+QnRihjJQGRFBk+WNsRvyx5ukWmDdL6ZS880IkxuNrUmr/mdt4hOwcdzyESJZM27ldWGc4yYABJIyImIz8hguFR0pdFFK/bcFfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsOccHAhn48xlRq0cvV64zgZ7ahgfGzv1yKNF1hJw18=;
 b=fmHE7wLgvVfeuqSYOV7I+2q9zs1Z3bIvuy4Je8lKmRUbHYCIqwzIosMifq+sIgGpyC88hARMreKdUzjKhQKUYtbYC9YgdsMEepQYWHkzU6YlJ1h6fthCQreOvJ2kAWIakxAMpfxdj6aul2L2tyilqeay+wds2HkOpx5kFQiPQyM=
Received: from MW4PR04CA0061.namprd04.prod.outlook.com (2603:10b6:303:6b::6)
 by DM6PR12MB3979.namprd12.prod.outlook.com (2603:10b6:5:1cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 20:29:43 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::19) by MW4PR04CA0061.outlook.office365.com
 (2603:10b6:303:6b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Fri, 27 Aug 2021 20:29:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 20:29:43 +0000
Received: from DESKTOP-9DR2N9S.localdomain (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 27 Aug 2021 15:29:42 -0500
From:   Mikita Lipski <mikita.lipski@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <Qingqing.Zhuo@amd.com>,
        <mikita.lipski@amd.com>, <Anson.Jacob@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        <stable@vger.kernel.org>, Josip Pavic <josip.pavic@amd.com>
Subject: [PATCH 17/19] drm/amd/display: Get backlight from PWM if DMCU is not initialized
Date:   Fri, 27 Aug 2021 16:29:08 -0400
Message-ID: <20210827202910.20864-18-mikita.lipski@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827202910.20864-1-mikita.lipski@amd.com>
References: <20210827202910.20864-1-mikita.lipski@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 046dd5d3-3fd1-4117-9398-08d969996771
X-MS-TrafficTypeDiagnostic: DM6PR12MB3979:
X-Microsoft-Antispam-PRVS: <DM6PR12MB39796115A7F31A6E202A8088E4C89@DM6PR12MB3979.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebxenBc5tXCCgj78Yo+K70RVYqvubJPYC09Dte7BB0I/YLLxF4H9znx8BSaGrvuTes1ef0VtfD6hYc8SkHHf77tY4Ew0ySzbkyA8/M1wpoKHkGRHqJ8m07XnTegSw88fSy5mTwKDh3KLiKqnchDO/qgOU+euV6e3pi68YbUZSuGCpdBGKSUUAitjp63XreK5n30txWnZjOvOuIYkS8ijve+j9AcKluyCXLRQniEB9e2QnxDKQFoOG6nLuOVHkZaD7EV3Kx6Lauy27EdgLpfdRbvF3px6k2nrdXnZsIb9Kcm25/5WlpHEqCkup73aPyOFxTaK1VlntwxPq9XnQTZvm1de6FyOgAndV48OnbBDLEeCgeozBtEnpVovDjj5LtAH6BZDfRrZNdo8IxQmDGu64l4OHYF9dHmaFW2VYoJnBrsjZ/QXZ0XfiuZKUtD5EueGx1Pm68hvgWRfC7stTE54GX9B+nnub+eZtHw8bgHhtaoJlof+rkPEyKEYPHlYMYEMtICn5nJJvY+tFCDu7WmUk3oNNFKgqsdMrhUp7U+7zRlfUT+e9KFjuW2/B9D8reoNv9AfeuFZHAnVTWtgienLlpv3TsHeawRIRFayseCVtF1jIy+WKLPxE06myGM6eR3BdcApi8oQm4+SJarsiNHqub3lkuQ8Xe7p87MMsUiNSct6izWQ72Gs26kx7D5/iNRhVvzvrexif0MHho2TsNgMjQ0B2nKWRZXlqXzZuFo4CXY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(70586007)(70206006)(4326008)(2616005)(44832011)(6666004)(426003)(2906002)(81166007)(54906003)(5660300002)(36756003)(83380400001)(36860700001)(966005)(82310400003)(47076005)(6916009)(26005)(8936002)(336012)(1076003)(8676002)(16526019)(478600001)(356005)(86362001)(186003)(316002)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 20:29:43.4476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 046dd5d3-3fd1-4117-9398-08d969996771
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3979
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
index 3c3637fcc2b8..7928852185b8 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2586,13 +2586,21 @@ static struct abm *get_abm_from_stream_res(const struct dc_link *link)
 
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

