Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA166D10E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 22:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjAPVof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 16:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbjAPVoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 16:44:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA024497
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 13:44:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUY93nDRjFk6U2pdoNwWs++qhDgOxMRxYWEkuN+hEdSdBcE1QoFElO5jih1ujSEf16inZYRh10Ogy5wAJ04Hk1+wi4PVy7qhtpSxU0cZY65d2Xi7+zfLV2STZgtBifYbNsB58iiHu+L0VfTRcMDN0n+NL02Qhp2cCbfQXr84d6ffbgoLAGLTuDjwemZLEHlgVWRTDLRoARNU3VU8QNLaeQgTYe3Mmvwmz03fj03XTxVkgWiOZ8rnqzygot9Ph9hh5KqngU0LiAJTM585MRVIHti72GZzRocfiUQoVQ9DhrDcQ7E0JogxA45kWBfmkJeB0E0WvW9wvcCczIdx6Dh49Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYRlKv/WRwuzCnC5f0Y+LSArYBZrOgSs7i6+XmbwNNo=;
 b=JX0ynOL+Qh3g8O3kYeWpnMzjhgmbK3SXH+Arf8NlCNLdm4fnvnPgJTioqyqQvtxiHq8vtNmZjK6qcbhpaFZnJjP4SnnxKqt3/xQU3mM/6UVzYXFya+ONYCovsElv1jRAtiikL7z7EaAWqGA6NKTF7dOyCKVQGSRNCRNdWYGcnimGmSkNdnm3Tm6NdU1Ap4aeE1LYVx1nMYa3ht4AptncBMFiC2paCL/ggFnn3n6gHjR3TavwaqkpiUz7/qVpBUJaK+YG3nyLFPsSP1wg/N6kjmw9dDpuhoYU8XV2szvCmrFAVM7GG5pQPMUD29BZHp1G03A/7REpfsVczE25V6GClg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYRlKv/WRwuzCnC5f0Y+LSArYBZrOgSs7i6+XmbwNNo=;
 b=Yl8nGXP9YfRlDEvPY3G4pSPiORG/kYiFW0j5MziRvnOQuxB5ZyPTwnou3slItDX7P51rIC8nBKEyHKQ8//xLqwW3opGizY+GebQCcxGZJ/g2DoGtNhgjl1ww5NCs3SLa/wn/10dLoZTPcXhrATx2CC1ifNpqZOhaVSWvvuFLPX8=
Received: from DM6PR07CA0102.namprd07.prod.outlook.com (2603:10b6:5:337::35)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 21:44:29 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::78) by DM6PR07CA0102.outlook.office365.com
 (2603:10b6:5:337::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 21:44:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Mon, 16 Jan 2023 21:44:28 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 15:44:27 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>, <kolAflash@kolahilft.de>,
        <jrf@mailbox.org>, <mario.limonciello@amd.com>
Subject: [PATCH] Revert "drm/amdgpu: make display pinning more flexible (v2)"
Date:   Mon, 16 Jan 2023 16:44:11 -0500
Message-ID: <20230116214411.1091288-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|MN0PR12MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d64814c-5cc3-4890-fda9-08daf80ad84f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBLGELE0XXOmTnxigneqJ9eASzXz9vXZsXb97ssUxZX9LU85QAcGrv61H98Rg9qLdnrpjZ26c5dqkDkhsk+hTL04XclthVB8vU/w/ww5z28jchHsiRUowlllqrEzAGAxLET2Or9oTOrh4URXig9yizWX9qVmYFhRNmj0UT2JSoaVS2yqWYN7bDfAuvWaOTRUBM2AztGBPsx+DHUq+KiTbWYgw6Ody3TZgEMs8YcSRDjGWINPQNcZuZM4Kde5bZzKpWFvPVdbdJ78RMl3/ZlbhWQV5k87xAmTIwitWsAHMtEQcbbluD0PJP4yqKaJaziwFqbg8TQ1/fF1KdlIhjnwgMrXkr7rBT+ujVvkcpHoKfE1QGDwVVB4BatPZj06ikJed+UM/EOJUgEs8DR+ogTtLEjd6lzNaIT1bPUBQRcQXNSporELCWNvTTOpI0Ma8i4Q9Aq2Bt2jorJf+5VTy1Jlm8J7/fHo4x8Y5fFU9OvkflM+jHQPW4mKDD6upy2YGiS5dGKWVLm+Yj6/2eXsmdcLjMR764PA5oKl+O34tW/rACIFXSP+HI5e51ytViyAVd+ofWPcvxDdbuyjifEVSxQaOT+dSg8yGkGzTMjONqsfj0Sk5DNJFFXOLk34rUtHgiy/jc/9jP2owAqIHxWsvhJoPcDWtWOfPPoN1/Ud4cgYROoe8Tzn3KROQwFPNSvGARTIB+jPE/qP4mI5fLUfoeyK9igxJGZs/R2ZX4IvGi45DXMRqvg68hfDdvr4zDap4tk0aTGri10S6zaSJ96lXFtEcg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(83380400001)(36860700001)(81166007)(86362001)(356005)(5660300002)(70586007)(4326008)(2906002)(8936002)(8676002)(70206006)(41300700001)(82310400005)(40480700001)(2616005)(186003)(26005)(16526019)(336012)(1076003)(426003)(47076005)(6666004)(316002)(110136005)(54906003)(966005)(7696005)(40460700003)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 21:44:28.8203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d64814c-5cc3-4890-fda9-08daf80ad84f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5740
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 78623b10fc9f8231802536538c85527dc54640a0.

This commit causes hiberation regressions on some platforms
on kernels older than 6.1.x (6.1.x and newer kernels works
fine) so let's revert it from 5.15 and older stable kernels.
This should be reverted from 6.0.x as well, but that kernel
is no longer supported.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216917
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: kolAflash@kolahilft.de
Cc: jrf@mailbox.org
Cc: mario.limonciello@amd.com
Cc: stable@vger.kernel.org # 5.15.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index b1d0cad00b2e..a0b1bf17cb74 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1510,8 +1510,7 @@ u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo)
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
-	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
+	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;
-- 
2.39.0

