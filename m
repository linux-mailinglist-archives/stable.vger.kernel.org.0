Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666A922D03F
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 23:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGXVIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 17:08:05 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:44257
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbgGXVIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 17:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMGxvxPb0fyanu4A4WOyRb+hUD85w17g9egZHWu3sQhpHIDn6X/bN/RZst5I1VaRloAsb1LtQSeY/DSct8W/k9bbcm2izoCjeT7BOaj9aR2jXfZmS97+8uhYjWzaosjc5D/KZ6Xvea0KsNwak1jUfHlcOyIXYLvvxqJuFNVJ+E+azqyLWuVJCYrdNHPh/JAy/c/iWNOaaDuK34JcpXXsrSgZ9jqXS8LSwhMI2V3j2XtKw1q2A7rTXSWajFOyiYhL4QJJYLgknPBg0tHE+tNF5P8fnoJB7gHQZWk4uEnfHQacFkI4KsMgwNEn2sqE1CN6wAgWtEScQd3+Zd0MadNeOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVhYw8/cYHe6SyZ8+o4ERJO+rJ6KcgLU9mcGBR9P0JE=;
 b=Omp95yuIawtPWToplCh6ffYRAY6J0OTxIOu03rycu39I9ZMNVbSfhqyrleYeSTitK7VdD+kPtfi26RHkJlc+H+0sWqLT7Ub+kFji/vmx0Ya6P0Q3kf/OtTuTY8wUfUdkz76AD3gdEFV7oeqNai9l8BUxlz11JnJsBqZxkgsV/3zs0qJ8T/dRzBvKkwg3Bz919PHVrdT2zcXetkDZpCpg2VM+R1ddpTdxAqvhouKP7gLe2qkDEap+Pzqd+dHwYUH18L9Pee94zFutJBU2nEq7rSSGtJ4qGFItVeoU9dpNLr3S2o6FuLwuJjLbIJ6o8kS/Naw3PkxYLqIBuPc98JzHMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVhYw8/cYHe6SyZ8+o4ERJO+rJ6KcgLU9mcGBR9P0JE=;
 b=DugFD3iCeKzWRsbs4yE4a5arrRKozx/6lMZY2w5UwV+6qX2uRsLbUEQOoVKopDl5fcT+4tt3oFJYvMU8Wckb3WKTi6ssIgRr6/kbb/OnxAdr1qRfeTVMLiMeaMBve2uuyO1t+tyQ7Bn/IkvUu1I2I9M3rnGR/JXoZXj0yE/S6C0=
Received: from BN4PR11CA0011.namprd11.prod.outlook.com (2603:10b6:403:1::21)
 by MN2PR12MB3968.namprd12.prod.outlook.com (2603:10b6:208:16f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Fri, 24 Jul
 2020 21:08:01 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:403:1:cafe::87) by BN4PR11CA0011.outlook.office365.com
 (2603:10b6:403:1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend
 Transport; Fri, 24 Jul 2020 21:08:01 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3216.10 via Frontend Transport; Fri, 24 Jul 2020 21:08:01 +0000
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 24 Jul
 2020 16:08:00 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 24 Jul 2020 16:07:54 -0500
From:   Eryk Brol <eryk.brol@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        hersen wu <hersenxs.wu@amd.com>,
        Stable <stable@vger.kernel.org>, Aric Cyr <Aric.Cyr@amd.com>,
        Eryk Brol <eryk.brol@amd.com>
Subject: [PATCH 11/15] drm/amd/display: dchubbub p-state warning during surface planes switch
Date:   Fri, 24 Jul 2020 17:06:14 -0400
Message-ID: <20200724210618.2709738-12-eryk.brol@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724210618.2709738-1-eryk.brol@amd.com>
References: <20200724210618.2709738-1-eryk.brol@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6239269f-69e2-48bd-b8c1-08d83015a65c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3968:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3968E1E7336862B04F62EC4FE5770@MN2PR12MB3968.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLcjFcnPAuGq4tzyrYrUj5DL594WBswsOenC3jwITZaZmdjFVCsVRXyeR6HSxOV2XUt76k0dZCb/qztLbuSDbAXQeNzXayGQAfeHzJu3ibpQH+vsGcSJ0wDh56VUPty4OBvUiLX9pKcQhhy2dwB7kIMyxFjFB564U1m53/PHu4ZugukTw0k5XEYjXfVaB5j49tiwpyAYwuFwGbwdOeb7dFcIwWRK5yznqsZLNLjRDNnETMhMtiJdVB7KtOjsVhu5dLUKG0NkoFf0A8DsN9Q00yWWL9lzUB2UzLstV2Mbjl/g7MHXTuT8ScsHSuL/wwiIzV/57w79xv1JVDeeuHgLMrxh9zgVJpySEFviJBMwIxPbnCXQ/L5kngFg5g3AWWygGJVU8dWBQ7srcBIqFTAanA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966005)(54906003)(83380400001)(8936002)(70586007)(86362001)(82310400002)(356005)(2906002)(70206006)(36756003)(1076003)(6666004)(478600001)(47076004)(316002)(2616005)(26005)(5660300002)(6916009)(186003)(44832011)(336012)(426003)(82740400003)(8676002)(81166007)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 21:08:01.6036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6239269f-69e2-48bd-b8c1-08d83015a65c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3968
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hersen wu <hersenxs.wu@amd.com>

[Why]
ramp_up_dispclk_with_dpp is to change dispclk, dppclk and dprefclk
according to bandwidth requirement. call stack: rv1_update_clocks -->
update_clocks --> dcn10_prepare_bandwidth / dcn10_optimize_bandwidth
--> prepare_bandwidth / optimize_bandwidth. before change dcn hw,
prepare_bandwidth will be called first to allow enough clock,
watermark for change, after end of dcn hw change, optimize_bandwidth
is executed to lower clock to save power for new dcn hw settings.

below is sequence of commit_planes_for_stream:
step 1: prepare_bandwidth - raise clock to have enough bandwidth
step 2: lock_doublebuffer_enable
step 3: pipe_control_lock(true) - make dchubp register change will
not take effect right way
step 4: apply_ctx_for_surface - program dchubp
step 5: pipe_control_lock(false) - dchubp register change take effect
step 6: optimize_bandwidth --> dc_post_update_surfaces_to_stream
for full_date, optimize clock to save power

at end of step 1, dcn clocks (dprefclk, dispclk, dppclk) may be
changed for new dchubp configuration. but real dcn hub dchubps are
still running with old configuration until end of step 5. this need
clocks settings at step 1 should not less than that before step 1.
this is checked by two conditions: 1. if (should_set_clock(safe_to_lower
, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) ||
new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz)
2. request_dpp_div = new_clocks->dispclk_khz > new_clocks->dppclk_khz

the second condition is based on new dchubp configuration. dppclk
for new dchubp may be different from dppclk before step 1.
for example, before step 1, dchubps are as below:
pipe 0: recout=(0,40,1920,980) viewport=(0,0,1920,979)
pipe 1: recout=(0,0,1920,1080) viewport=(0,0,1920,1080)
for dppclk for pipe0 need dppclk = dispclk

new dchubp pipe split configuration:
pipe 0: recout=(0,0,960,1080) viewport=(0,0,960,1080)
pipe 1: recout=(960,0,960,1080) viewport=(960,0,960,1080)
dppclk only needs dppclk = dispclk /2.

dispclk, dppclk are not lock by otg master lock. they take effect
after step 1. during this transition, dispclk are the same, but
dppclk is changed to half of previous clock for old dchubp
configuration between step 1 and step 6. This may cause p-state
warning intermittently.

[How]
for new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz, we
need make sure dppclk are not changed to less between step 1 and 6.
for new_clocks->dispclk_khz > clk_mgr_base->clks.dispclk_khz,
new display clock is raised, but we do not know ratio of
new_clocks->dispclk_khz and clk_mgr_base->clks.dispclk_khz,
new_clocks->dispclk_khz /2 does not guarantee equal or higher than
old dppclk. we could ignore power saving different between
dppclk = displck and dppclk = dispclk / 2 between step 1 and step 6.
as long as safe_to_lower = false, set dpclk = dispclk to simplify
condition check.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
---
 .../display/dc/clk_mgr/dcn10/rv1_clk_mgr.c    | 69 ++++++++++++++++++-
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c
index 3fab9296918a..e133edc587d3 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c
@@ -85,12 +85,77 @@ static int rv1_determine_dppclk_threshold(struct clk_mgr_internal *clk_mgr, stru
 	return disp_clk_threshold;
 }
 
-static void ramp_up_dispclk_with_dpp(struct clk_mgr_internal *clk_mgr, struct dc *dc, struct dc_clocks *new_clocks)
+static void ramp_up_dispclk_with_dpp(
+		struct clk_mgr_internal *clk_mgr,
+		struct dc *dc,
+		struct dc_clocks *new_clocks,
+		bool safe_to_lower)
 {
 	int i;
 	int dispclk_to_dpp_threshold = rv1_determine_dppclk_threshold(clk_mgr, new_clocks);
 	bool request_dpp_div = new_clocks->dispclk_khz > new_clocks->dppclk_khz;
 
+	/* this function is to change dispclk, dppclk and dprefclk according to
+	 * bandwidth requirement. Its call stack is rv1_update_clocks -->
+	 * update_clocks --> dcn10_prepare_bandwidth / dcn10_optimize_bandwidth
+	 * --> prepare_bandwidth / optimize_bandwidth. before change dcn hw,
+	 * prepare_bandwidth will be called first to allow enough clock,
+	 * watermark for change, after end of dcn hw change, optimize_bandwidth
+	 * is executed to lower clock to save power for new dcn hw settings.
+	 *
+	 * below is sequence of commit_planes_for_stream:
+	 *
+	 * step 1: prepare_bandwidth - raise clock to have enough bandwidth
+	 * step 2: lock_doublebuffer_enable
+	 * step 3: pipe_control_lock(true) - make dchubp register change will
+	 * not take effect right way
+	 * step 4: apply_ctx_for_surface - program dchubp
+	 * step 5: pipe_control_lock(false) - dchubp register change take effect
+	 * step 6: optimize_bandwidth --> dc_post_update_surfaces_to_stream
+	 * for full_date, optimize clock to save power
+	 *
+	 * at end of step 1, dcn clocks (dprefclk, dispclk, dppclk) may be
+	 * changed for new dchubp configuration. but real dcn hub dchubps are
+	 * still running with old configuration until end of step 5. this need
+	 * clocks settings at step 1 should not less than that before step 1.
+	 * this is checked by two conditions: 1. if (should_set_clock(safe_to_lower
+	 * , new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) ||
+	 * new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz)
+	 * 2. request_dpp_div = new_clocks->dispclk_khz > new_clocks->dppclk_khz
+	 *
+	 * the second condition is based on new dchubp configuration. dppclk
+	 * for new dchubp may be different from dppclk before step 1.
+	 * for example, before step 1, dchubps are as below:
+	 * pipe 0: recout=(0,40,1920,980) viewport=(0,0,1920,979)
+	 * pipe 1: recout=(0,0,1920,1080) viewport=(0,0,1920,1080)
+	 * for dppclk for pipe0 need dppclk = dispclk
+	 *
+	 * new dchubp pipe split configuration:
+	 * pipe 0: recout=(0,0,960,1080) viewport=(0,0,960,1080)
+	 * pipe 1: recout=(960,0,960,1080) viewport=(960,0,960,1080)
+	 * dppclk only needs dppclk = dispclk /2.
+	 *
+	 * dispclk, dppclk are not lock by otg master lock. they take effect
+	 * after step 1. during this transition, dispclk are the same, but
+	 * dppclk is changed to half of previous clock for old dchubp
+	 * configuration between step 1 and step 6. This may cause p-state
+	 * warning intermittently.
+	 *
+	 * for new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz, we
+	 * need make sure dppclk are not changed to less between step 1 and 6.
+	 * for new_clocks->dispclk_khz > clk_mgr_base->clks.dispclk_khz,
+	 * new display clock is raised, but we do not know ratio of
+	 * new_clocks->dispclk_khz and clk_mgr_base->clks.dispclk_khz,
+	 * new_clocks->dispclk_khz /2 does not guarantee equal or higher than
+	 * old dppclk. we could ignore power saving different between
+	 * dppclk = displck and dppclk = dispclk / 2 between step 1 and step 6.
+	 * as long as safe_to_lower = false, set dpclk = dispclk to simplify
+	 * condition check.
+	 * todo: review this change for other asic.
+	 **/
+	if (!safe_to_lower)
+		request_dpp_div = false;
+
 	/* set disp clk to dpp clk threshold */
 
 	clk_mgr->funcs->set_dispclk(clk_mgr, dispclk_to_dpp_threshold);
@@ -209,7 +274,7 @@ static void rv1_update_clocks(struct clk_mgr *clk_mgr_base,
 	/* program dispclk on = as a w/a for sleep resume clock ramping issues */
 	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)
 			|| new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz) {
-		ramp_up_dispclk_with_dpp(clk_mgr, dc, new_clocks);
+		ramp_up_dispclk_with_dpp(clk_mgr, dc, new_clocks, safe_to_lower);
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
 		send_request_to_lower = true;
 	}
-- 
2.25.1

