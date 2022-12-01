Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2A963E9DF
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 07:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiLAGXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 01:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLAGXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 01:23:04 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CF125EB9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 22:23:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtKgLUQ8gQL/rXlnJhGp5AZmoCAO6s1HyIkkmPzUr0wIMYok6Dl5Oarsq6Sm12HVuHQIVph1uOIsJKjfVo9eq795t/jMvpBecfV+pNYztmiDjIUSMMzILcaHQ19YZtOv4xunVPepsulrh4QhUu8/e3XJn8vnXitJjdRrZRSDCdRFdJW/HkyR2RTEsnE79AmeKBNvYYnKknDD6YKI+LraYN1G7GcwF2OrPeJzTaomYZamu+WVSLH8xQEsTPPDLHlci0e5HcjClYLe41AhIA4rVOjt+TZMWzoWxZPhNJFtaPUhV8KRI12GLXAzfVdOe+7IgvjXHFu4S8B50TKI+bwgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fuPr1i4Ikj9n501+rNTEL9fWO/Dn6w4YVwJH4asuB8=;
 b=EhrAIMJBdYwJONgaMRbSw3x+EgdMPTrM8agK/iBS0+o9jERxOTU0881iFlKikym+v7GZQip2UkIWjvFJBoq+0LQ2xbDzYKnK0nM4MuCWbba5TiwYOD0YBEvMqLXH8DVy6bmkAd8vd7RpjxEiq933vFI1oYRhtPgp+mFtMpJCUY/BF1qSSnYZRatzUxVY6RkB8Vk+zndTmMPtILr3F2fhm7TWk1CUNUC72WRMKOsq5BxuaqOxHkm22hZ/4gyGUx6XzY6HYxL62cL6zwKxYYNWUn5WIGoRpUCgJNCsFsZMRFC7yAbuvJGJ9ghmnQoTu56HVY2RWcV1L3bYGW/P4yK7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fuPr1i4Ikj9n501+rNTEL9fWO/Dn6w4YVwJH4asuB8=;
 b=C6zksDOu2rgcnw1T1OEqRlEqVaFQuX4UyOaq+DJ7BFluJ/V4Ap7q6Jor72pQ26dMQ3zPEEiOhwgnJRMmpphR/WmigrTM1YhNLUq712/i6oJIF8kOUwa/z00pkvobCECjr31Br9RRjJBEOmRLTEte/c87VEFM5OysKXaVCrM7LTs=
Received: from BN9PR03CA0919.namprd03.prod.outlook.com (2603:10b6:408:107::24)
 by PH8PR12MB6916.namprd12.prod.outlook.com (2603:10b6:510:1bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 06:22:59 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::26) by BN9PR03CA0919.outlook.office365.com
 (2603:10b6:408:107::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 06:22:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.23 via Frontend Transport; Thu, 1 Dec 2022 06:22:59 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 00:22:58 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 00:22:45 -0600
Received: from prike-code-pc.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 1 Dec 2022 00:22:43 -0600
From:   Prike Liang <Prike.Liang@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Mario.Limonciello@amd.com>, <Alexander.Deucher@amd.com>,
        Prike Liang <Prike.Liang@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend
Date:   Thu, 1 Dec 2022 14:22:42 +0800
Message-ID: <20221201062242.979864-1-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT017:EE_|PH8PR12MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: fc8330d9-33c1-43f0-7d3c-08dad3647e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lXooNVEJKr5kAdz48OWfrVR9KOXNgKHfDHL4XVvhJfKgxuwR+InVKOccP7tkXl7qoq9KGQQDxwpK4NmsEebNbPeZ4TGDXYUtbBmuYXA6YbwrUJkE8wFdVjRxtfyuNJIDPi5IAG/++o3Cdeiu4BqHSaMpfX+nwTv2jArfKseEo68y+fNAVGXT+CKq4Vr0GTWV2pmYzFCJa27Rk4I2GXtXHgYpVBrxZVXZEkNez+8NsT1tFIh31pX967U8bf2O1ZjrqxO5LN9ReyZj5d2Gmgf+NCAp1yNOzWc4aydVhIINtYNNGVMHp1SPnctwa3GOPfEKIGvTsiUXXD6oW270+En9ibJEHiUPmrAU0VJQoCbopa4rL8pUqMl2dAfu7rDh4ioVDulC3RTktaLlQ8e1hSJqqZX4hT5LcvOnp6BVgYa/LwROkbO5gxDHLP5Srz+Lm8+PhRzGaJsfjoeVXtX4+j8F55IVegPTYcl7nPoObacL375Gl/KYuBw0v5aWlByCqKUZTudlTuvFvQAFIB2crgtnzEgZhsz8DMz0oQ+to1kKdMUqhkg3Y93VbJ7iHoeECRqKzMOwjbCB/RoJbOIQXxPcDiOejmmG2ZC9HIN2vHvrz5toIl7C8a7ijGrRyKfpl5jp3dgJhma8i/DV3diVSUzIvCQVg2HhdRk0g+3kIGfwTfCwm27hIGURHg2ZnnGt4fnT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(70586007)(8936002)(26005)(426003)(5660300002)(70206006)(8676002)(186003)(40460700003)(36860700001)(316002)(82740400003)(478600001)(356005)(81166007)(83380400001)(40480700001)(7696005)(47076005)(1076003)(86362001)(966005)(82310400005)(4326008)(2616005)(36756003)(336012)(6916009)(54906003)(41300700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 06:22:59.0488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8330d9-33c1-43f0-7d3c-08dad3647e07
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the SDMA s0ix save process requires to turn off SDMA ring buffer for
avoiding the SDMA in-flight request, otherwise will suffer from SDMA page
fault which causes by page request from in-flight SDMA ring accessing at
SDMA restore phase.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2248
Cc: stable@vger.kernel.org # 6.0
Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.")

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 1122bd4eae98..2b9fe9f00343 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -913,7 +913,7 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
  *
  * Stop the gfx async dma ring buffers (VEGA10).
  */
-static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
+static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev, bool stop)
 {
 	u32 rb_cntl, ib_cntl;
 	int i;
@@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
 
 	for (i = 0; i < adev->sdma.num_instances; i++) {
 		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
-		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
+		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, stop ? 0 : 1);
 		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
 		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
-		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
+		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, stop ? 0 : 1);
 		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
 	}
 }
@@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_stop(adev, true);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_stop(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_fini(adev);
 }
@@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU restores SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_enable(adev, true);
+		sdma_v4_0_gfx_stop(adev, false);
+		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_init(adev);
 }
-- 
2.25.1

