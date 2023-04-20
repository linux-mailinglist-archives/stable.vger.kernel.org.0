Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAAD86EA031
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 01:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjDTXuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 19:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTXue (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 19:50:34 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF9110E9
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 16:50:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcg2LjqjnPt7IZwfvCM1nbbGpfasakMzFLRFit+6JzV9bc5BR6FHRUxjR28dFgGw6ZgWSmkzPIRUGeH4Lz9UwvYpN+DTKdOFjrHoqORTNFYY72BFdmGPJrGNjrLxdjKfQCnRvT1KKOEzcAdFdtN1LJasS8hY4+Jwzp0NVHRBqq3NEbbmkkp6FgexqMSqP9jayA4YgMT4Hg2fHiCx8Uu1bQVhJUBm87KOJuLh9O+TkzQBUnxcAb4mEsMqMWvcXGvdzxvc2DFBu5ccHbutZwx3TAIEY3zutZnKTKo3wGotrXN5v9fpy6uhvPl0kj7IDnfJKmwlCXS9NfAn93C/egJ88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLhRTtabpmit9IrX0gUyuFfTLAUDR7Ga/lJPMvrBnVM=;
 b=LZFOl0g+4l7a8tbDsSumhb5U+yauXFMCq6lD9G7SuLZaAxQWVtJdl+AXmHl93fWK3le3DUFkqDacBRvEJvUqm0qNPh2hT3rIK8jK66HaC3JLrD5ITNaB+MxsmN8tWy+M3bXMQZfBFNF2sNjDSVplJnD/YErzaWUVbddjmVaXGDarF3+IejJ6sSxssgA6g23mgxQqq0CVFJz+H3pWO1Ckb2AMQWcehP0+/c2FuT9gzEWTDLmfJufebD+VI/R6JHOEbdfu0CLYBeFNSlo6sBaEPYXongsJ9hJ/47dooJMRPJeXKc6EqOYYvnVrJWgoXsmZ6thJsatYs1utIoXshUAU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLhRTtabpmit9IrX0gUyuFfTLAUDR7Ga/lJPMvrBnVM=;
 b=BMQ/y1KpKpDaFAwHUR+7tz4UxzzWazkKpBT+V1/ex+jha44Q4Zq6RDTQGgD0LBKxiTLbi85Gz1bvjIj+5oQlVdoHAGHMQpBBDPs3Ra8jv0VFI+tvsg8RkM/wLasZp7tCU5iFuuNkISiNJEMqH2eJmBRl5WipCajfwxxPxSdZkv4=
Received: from DM6PR11CA0035.namprd11.prod.outlook.com (2603:10b6:5:190::48)
 by SJ2PR12MB7866.namprd12.prod.outlook.com (2603:10b6:a03:4cc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 20 Apr
 2023 23:50:28 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::4c) by DM6PR11CA0035.outlook.office365.com
 (2603:10b6:5:190::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.27 via Frontend
 Transport; Thu, 20 Apr 2023 23:50:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 23:50:27 +0000
Received: from smtp.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 20 Apr
 2023 18:50:25 -0500
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Leo Chen <sancchen@amd.com>,
        <stable@vger.kernel.org>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Subject: [PATCH 11/21] drm/amd/display: Lowering min Z8 residency time
Date:   Thu, 20 Apr 2023 17:49:41 -0600
Message-ID: <20230420234951.1772270-12-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
References: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT066:EE_|SJ2PR12MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: f1584813-06b3-4978-3f31-08db41fa0499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9FOpGBUUOeQKVLs2wa9FZefZ5h9InDRPVeAEUCADyEsxMeiXLakyR10YoeFPfYj7UkX4hwGD/NCRE6teh6BcZW7jD7mHvHb1jMgzDNmUJm+tZdJiYzbAfoTdPIDHo56fthtVK9d4EyCd8MA/SnL4IW/eVaYGZthwdtvenK/SyJbN8rTmAfI9b9an/CmQWsdI7Ba8gOlHvPoqK1kV+hKUl/RiW1mKwIwhpsKNuo2/HsGD5Ogs3h6HOaA71HzRAhI2gEWV2KeqP9T5adaaJc5izXKKnx/o48fTYvVDSnyToPS3AElk7/u2ZbZHVp17xxOwVjo5fR+ny0I5U+QL+y0k0eCvitvdjeW59mcN25gEMyXY9ShZmNTmgr7MysYbjOTqyQwbQ5V4/KOh8LZEOY6I+hIFDbCe7AcppOnrelwLDtJYK9+wSJ7BM4GDSOLpNjgKWBe6DASQQDtxedahm2fQkk3ni9dM5yl1Nbt3O4NL5REPPvLAKhDedvkppWGrZzhqJVvm1EehZ7e5ndvMSMsF4g0xmQdhkjXsJidjt2XT7pNgRRWS3BZYti3tP0h8Xm/d5M+S3BBRnOwgO1P3ATRiECWD9hh8DTcz698NkU/7wjU/iPFh/a1VexLGCwMSSRpWxzvjCvT5/3CXeWX8YLFvZqBOL2KV5d2f3SXqGa4UJOr7l6TZfyO0o6prtzr69Dyn+i3fOmYhBHWtgMdYeCrmwq/Ps2XlAKcVAgz9mWzZO0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199021)(40470700004)(36840700001)(46966006)(316002)(6916009)(82740400003)(70586007)(70206006)(86362001)(5660300002)(47076005)(336012)(2616005)(426003)(82310400005)(6666004)(36756003)(4326008)(41300700001)(40460700003)(54906003)(40480700001)(16526019)(26005)(186003)(1076003)(8936002)(2906002)(83380400001)(8676002)(36860700001)(478600001)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 23:50:27.7057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1584813-06b3-4978-3f31-08db41fa0499
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7866
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Chen <sancchen@amd.com>

[Why & How]
Per HW team request, we're lowering the minimum Z8
residency time to 2000us. This enables Z8 support for additional
modes we were previously blocking like 2k>60hz

Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Leo Chen <sancchen@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 24806acc8438..abeeede38fb3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -885,7 +885,7 @@ static const struct dc_plane_cap plane_cap = {
 static const struct dc_debug_options debug_defaults_drv = {
 	.disable_z10 = false,
 	.enable_z9_disable_interface = true,
-	.minimum_z8_residency_time = 3080,
+	.minimum_z8_residency_time = 2000,
 	.psr_skip_crtc_disable = true,
 	.disable_dmcu = true,
 	.force_abm_enable = false,
-- 
2.39.2

