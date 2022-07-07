Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D66D56984F
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 04:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiGGCqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 22:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGGCqD (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 6 Jul 2022 22:46:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489E32E6AA
        for <Stable@vger.kernel.org>; Wed,  6 Jul 2022 19:46:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KS59xxOgsGd3Bk7vI/zsxAOmCcIySXgdy+Y6P3m+J1/IIzuG8NJhrCdYa6I8ciRgXlxnbFcXPX1YVMdHsWinLUN2prF/zifX4JZbI1d0y6vrb6hw3VKK6blTPUdzRavmVjeF+bVxTQiXmgbXYb9H9mKqz9WvaxxVx3JbBGWF+mLCm89SuCW5mVCMlCdyYdCXM+XzkrrPCie+lR7VEM+lD31TwaQn8azDGL75t/OgaRsry49jSMj1vfyRxGMUcRecIPVa6Gs+dT+oViU4ZbsIemJ651MCKOld1MM7C9gPtJriLSNA6fnIRmQqWA/J1BTuBz4J+hakHuYwrAZP4Vq+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MwFw24jWqXTa0jDRkZlNGg6jlt5F0vXlObDfyFuvII=;
 b=JvVhSKjuhJ/vkkL11cKfCK5fIdiVPX2igzCQBOWuiPzoYegdx6/vAY8899zaUdcdXtlQvlK3vsFH8iUveb1shfNjJxcntPIgPS8hQcLvMRKyZTtWAxtwIhpkFIlMuOQpWg4rWhOhkSQlAR5FxxdzbfqmndglxoMINAfPut5O60E/FfgT/kdIyvx5bl2+F3p6oPjJ6CzsHBP8GOAHlE93Z7ua3JvbGtrrTVfL6BZ+ltC+KPSTCZ00D38uw2nnmoZ65dVAv0BqukYnb8xONiw89X76G9+Uh3bNCEWk9b04l8W1f2U5+bbZyXTozIj35OKbo/j9Vz6aTWsD/w9la1Weag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MwFw24jWqXTa0jDRkZlNGg6jlt5F0vXlObDfyFuvII=;
 b=AR+63tCuY99Qrf7Q5iv9shuLGF1EhW45HvP6/WJJl5/4TiCX+TcYNafV0/Ee1fUCUpbC0tULZJQl2ZGETYYnILm90x0hr0BauNAroYV7WFanE7kBRVHZ5Ic3DuBInx4iToMqapIDyaK/G0bZe6AnC7SkztnpWei0Ml36u58aueA=
Received: from DS7PR05CA0053.namprd05.prod.outlook.com (2603:10b6:8:2f::34) by
 DM6PR12MB2908.namprd12.prod.outlook.com (2603:10b6:5:185::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Thu, 7 Jul 2022 02:45:57 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::22) by DS7PR05CA0053.outlook.office365.com
 (2603:10b6:8:2f::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.8 via Frontend
 Transport; Thu, 7 Jul 2022 02:45:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5395.17 via Frontend Transport; Thu, 7 Jul 2022 02:45:57 +0000
Received: from equan-buildpc.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 6 Jul
 2022 21:45:55 -0500
From:   Evan Quan <evan.quan@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Aurabindo.Pillai@amd.com>, <Alexander.Deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, <Stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: correct idle_power_optimizations disablement return value
Date:   Thu, 7 Jul 2022 10:45:31 +0800
Message-ID: <20220707024531.90263-1-evan.quan@amd.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89998830-ebe7-4c3f-3f6b-08da5fc2d1cf
X-MS-TrafficTypeDiagnostic: DM6PR12MB2908:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUD9wNrru9rloxNx7hEPaJT+Xd8PADxCu3jRMVgE0ijU7SPf4wtWibJcKg7xv7QwNyaD1ZqF/3jlxMyW2bG9zuIGDKqk81+K6NepGlGUP+PlDlksCpAKF82Afsx3nJRDhgVT9B2ox4jZj4bUAztSF4JNJLC1qeS6gCXFtyvbNDeFORW/7uGFhcDmzPCwcswDXgCP9+Q6X6fBNIzIduXXRch2LsJKPNn1KGOVSVU6l6WVVJdyTlLhbP9gYuEaWK8tq+ygzbM/jW2v/l7HlePsnxsbKcvNUp9KBKlZ9xSUv7stu5FdIFVzodD3XDmrZbrFWF0sFfk+isOSq6HqK9X3e6W2krHophTCHo5/0dK6fV01qhLnEqczVJALUHJy/WuVg0jRfa2x0ITZZ5tR4r81O/t2olXnNzsj86nmiJPrOFrI5lOQJ4rey+X2H7vscg74d8fEGT6gKM1zBfm3pMUN3Z6fSyjh6wf1oLuEMR2F/Oc9eOUy9lvWelWIA0nNU9Vv+MOnWxAzRiiJe55GHwcclFV8vvxP7GF/hyzqnrMMeHeCsfXHDBN59lZ7i8nN3SQucfowQaFpcTBWfxsiMrBFdRrmLDmIj1aEKpvFPvVQLcF1Ppg07JFr1r1PISqxUfhIdfQMCsTHcu8pKSFABZ2wZzpeqEn4IJj1ri62xLtu3nSrEhbf62fgcCrkuYfo/H+B4eai7Wha3kR1J5rVp1T8jN/eUtwss6ncqNG0NiwNtPSxFGPfeo4G/tDQ5ibmLkxOh/MmBwbr8LVZa4I7Ik7TthtDKWVe6D7JWsimm4sobVhe3guK3/mj1FWsNIxQZVvyumxQqgelLFeRHBdJaB4BWc7KE9A0SWBdWzLpWtFM5kcUaykv/QUs+AYuZGg8tuhf
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(40470700004)(46966006)(426003)(336012)(82310400005)(47076005)(81166007)(356005)(6916009)(44832011)(5660300002)(316002)(54906003)(82740400003)(70206006)(86362001)(8936002)(40480700001)(8676002)(70586007)(83380400001)(36860700001)(26005)(40460700003)(34020700004)(4326008)(36756003)(2616005)(1076003)(478600001)(2906002)(7696005)(41300700001)(16526019)(186003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 02:45:57.3567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89998830-ebe7-4c3f-3f6b-08da5fc2d1cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2908
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
The return value indicates whether the operation(disable/enable) succeeded
or not. The existing logic reports wrong result even if the disablement was
performed successfully. That will make succeeding reenablement abandoned
as dc->idle_optimizations_allowed is always true.

[How]
Correct the return value to reflect the real result of disablement.

Fixes: e40fcd4a ("drm/amd/display: add DCN32/321 specific files for Display Core")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Evan Quan <evan.quan@amd.com>
Change-Id: If87d4cf76f6cfb36d607f051ff32f9c7870b4d6d
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index d53cbfef3558..1acd74fa4e55 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -373,7 +373,7 @@ bool dcn32_apply_idle_power_optimizations(struct dc *dc, bool enable)
 	dc_dmub_srv_cmd_execute(dc->ctx->dmub_srv);
 	dc_dmub_srv_wait_idle(dc->ctx->dmub_srv);
 
-	return false;
+	return true;
 }
 
 /* Send DMCUB message with SubVP pipe info
-- 
2.29.0

