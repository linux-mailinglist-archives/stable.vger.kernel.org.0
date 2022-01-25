Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1C849B7D3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582104AbiAYPkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:40:22 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:8949
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1455395AbiAYPiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 10:38:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9OTE7yYJaSfpPGDYFFXZc0QpNE0D+U3gtBF9Ha/BDX4aagwFHygDyNEV/R9K0qkgMm9U229mJdZDF+EKcI2vpVCpn4eQu/WH3jEUdDz1dWBU6ASocKv7X3Bw+UAERLl8Ug5muh2gCF99OmNI54e+jg06OSVotRHm9vMjJqb9pxgFzei4JLaofToArcfw2XMds1il0uhuNvkl0451eFUldlW6GmKvQfMxeDe8aJ0lBb+K03/gAFufUGmdae49VcY/y5FJ1cbbN3Y/m0biGb6L2fyoGEa197GEuOYwCu1YO4fOsktXJfrNMhT5DjzFQLhIkDFwP8I1ehlFTwULs7P5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4BI9fjbpYyPdKznRjP6btbTrnHFcfHt7Yy9aXty3+4=;
 b=MbbeJnmVDkFzSq/2zin/QtXT6LHkSmrNCkCs1Mki36A+Z2P6grJMszEJ4MvsZWV0jb7OOHqi58D5OHiiJMbF5bizppeybsVXgcteUlgJflyvoej+0O/piw/sdqYEMe2HgUO+TdfuC9F77JjHS3hU5dP0Tha46VfaKrWt/1yVBGtCR8MUb32bKo9YNIcjmT1vR/E2/luckNA/oAh9sfHEt8fGMfpYnJiF3DK0BE4FvGv80ol7bL0jUjakHZr4SEVKsPoLa7EqiBJYdk2m2DRa318dpuVONfdOoi9MQFDW7a7fJC3WtVmJvjy0nIoEoBMnsBk0rSZ0QJ95vIpJc/euFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4BI9fjbpYyPdKznRjP6btbTrnHFcfHt7Yy9aXty3+4=;
 b=0vo9A5k3PxIe53aatN8fQeToW5afrsMlihEmghJg+YaauBw9M2CEGa5PkcpvdgTIgttD+atdKBdPMl1Qw4fvqS/pLFcQyKCUipaA1UB4+1xCJZIB3C2DklBonZl6B2k8PWm8VDhKfB6CQHWjCuh8PYcZwXmM/MFtECfLKcsibd8=
Received: from DM6PR03CA0095.namprd03.prod.outlook.com (2603:10b6:5:333::28)
 by BY5PR12MB4949.namprd12.prod.outlook.com (2603:10b6:a03:1df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 15:21:15 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::3c) by DM6PR03CA0095.outlook.office365.com
 (2603:10b6:5:333::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10 via Frontend
 Transport; Tue, 25 Jan 2022 15:21:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 15:21:14 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 25 Jan
 2022 09:21:13 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     <Alexander.Deucher@amd.com>, <harry.wentland@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Date:   Tue, 25 Jan 2022 09:21:11 -0600
Message-ID: <20220125152111.22515-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81ce6076-ab35-43da-5709-08d9e01653b0
X-MS-TrafficTypeDiagnostic: BY5PR12MB4949:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB49498523D80486DEBAC4E2B2E25F9@BY5PR12MB4949.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nrXzZnyTzAo/j34ouUmdCDq6GZAdQKxEnpaCk7jdx+C+vIKX5ouEsWjnDyfoilCrhspeluZGodreyY5dQHWCJljV0lz11SZ3I+bNxxkOnh016ycvNt9mmBakUuH7lWky84DHiv8ry3Bpv41ETlKLSu49TdYrMM4XxyA0L9gLGMb3hxP5EzVxHtLEmLU7Ry0OR8gR22bw74X2+32xZdyT++hjW/mYJ6zL7W/MsFzyHuEgOd5DPrVH8T80+9yBPBUDRwTosTUzPMhTjau0UjwCPZr89D++VQ7/qQt7pgLSmvDrZw3g9XYTqluYPvZ0zmP6/hEOV99gTyORlVilpGKWC0a1Z+TLFttkbkVZYddPRPBB+yQoexUsRRc8fzCuRdYxN42xHeuWELpvZhzGZEejr200SFnhN0BNftnu+6qPq529pubFmdP0F9pJmXuYxe65TeHut6Uw4NqCioZitNguBK5+35yYOHLScmnCTCIQ3D2w9GFrltLuQ9X28G6/Tl6heVrAKst70847CLv2rI8CvmwXnVa6+dkoojrZlJf/FzjOUP/JH89URn3RNLkwwfCEcGhoOlGEizveulFPedLX7RDdOJM7fUE6wvmRMYteUYcktc6MsNOZsDeAbg4qp+WSecDCsPu0A/KfjbjPNXv702kQTqhoRKUOa260+HFtGIf4kQC7ld3Jz1ReIPfPhrwNnAopnRm9jGJ2pSGoCwaQ5Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(508600001)(2616005)(54906003)(36756003)(40460700003)(36860700001)(47076005)(16526019)(186003)(316002)(426003)(336012)(70586007)(1076003)(26005)(6916009)(5660300002)(81166007)(7696005)(356005)(44832011)(8676002)(4326008)(8936002)(70206006)(82310400004)(2906002)(86362001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 15:21:14.6822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ce6076-ab35-43da-5709-08d9e01653b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4949
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some reason this file isn't using the appropriate register
headers for DCN headers, which means that on DCN2 we're getting
the VIEWPORT_DIMENSION offset wrong.

This means that we're not correctly carving out the framebuffer
memory correctly for a framebuffer allocated by EFI and
therefore see corruption when loading amdgpu before the display
driver takes over control of the framebuffer scanout.

Fix this by checking the DCE_HWIP and picking the correct offset
accordingly.

Long-term we should expose this info from DC as GMC shouldn't
need to know about DCN registers.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
(cherry picked from commit dc5d4aff2e99c312df8abbe1ee9a731d2913bc1b)
---
This is backported from 5.17-rc1, but doesn't backport cleanly because
v5.16 changed to IP version harvesting for ASIC detection.  5.15.y doesn't
have this.
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 5551359d5dfd..a4adbbf3acab 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -72,6 +72,9 @@
 #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0                                                                  0x049d
 #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0_BASE_IDX                                                         2
 
+#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2                                                          0x05ea
+#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2_BASE_IDX                                                 2
+
 
 static const char *gfxhub_client_ids[] = {
 	"CB",
@@ -1103,6 +1106,8 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 	u32 d1vga_control = RREG32_SOC15(DCE, 0, mmD1VGA_CONTROL);
 	unsigned size;
 
+	/* TODO move to DC so GMC doesn't need to hard-code DCN registers */
+
 	if (REG_GET_FIELD(d1vga_control, D1VGA_CONTROL, D1VGA_MODE_ENABLE)) {
 		size = AMDGPU_VBIOS_VGA_ALLOCATION;
 	} else {
@@ -1110,7 +1115,6 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 
 		switch (adev->asic_type) {
 		case CHIP_RAVEN:
-		case CHIP_RENOIR:
 			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION);
 			size = (REG_GET_FIELD(viewport,
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
@@ -1118,6 +1122,14 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
 				4);
 			break;
+		case CHIP_RENOIR:
+			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2);
+			size = (REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
+				REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
+				4);
+			break;
 		case CHIP_VEGA10:
 		case CHIP_VEGA12:
 		case CHIP_VEGA20:
-- 
2.25.1

