Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04B7461C9C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344848AbhK2RXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 12:23:42 -0500
Received: from mail-dm3nam07on2066.outbound.protection.outlook.com ([40.107.95.66]:50529
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237085AbhK2RVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 12:21:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXRWJ83qG+170WWazN6us5CyRovFfF3TzoKGKROB+QXWVgBTQ/40YRHVTmwDRdq+0ZRTI4sjpIbzsiPt+kXZ/RxSmk2bHIr4i115N0/7zac7Oyo5WYH9CcV+g4FrkklBfm1DIrJvuDVvHmtkCIHScRZHK5ZocWaLgr1Lj0KDvBUwBvY4B0gg6Boydeo10q0H764WNaU0BEHhPWfot8cNB6cKsKe0OgMnEiWnOWS1a4o+w3mZJ31ajBz6YD3Jp2h/xyweW6FAnFoii855/skFEXvxG9bpvxtpxJHDMyizcc4n6EMqQA/lwzfpJ+Nu8gyD15ecl7ptOvcORw5hayNs+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEZRiv4TKZrvK+Pu8O0z8I98wUooGNZMq04OmXmAtkA=;
 b=aHt2aq42JTQdd1aqZ74fWyyCmEHn1paPKuiRWffrUASmtGW70GLgqKVJAJ0aLvjDOdjtAcB/YkB5ugOZ+drnb135Q2VHvHBi65dzV7N2aUM3tDSKCHVu9yjMeJnHcQxtaJ/Xt0DzhW1ieaVQMibtbtt3hH49+nczSoAZeeo9LZurpnXt5mCVOK3cTTOMasjdSnSRosTJVoScWz6cUbVwXkzqS4z+7/FODHdbSxSIIt6/vbJrMoAdxP6aNaLRkWjGYUEIXKhIfsNEE7MUhokEyIx9vOz+jMQOqd45fUSMHX/bq934+r3SmsVV+MtLKgnLER82jTI7F7yOiJ/hOmi/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEZRiv4TKZrvK+Pu8O0z8I98wUooGNZMq04OmXmAtkA=;
 b=Kg32vsVqPAYZz+FXo5KgaPG8gEZtSNHU/aJpoUGfS85Ubk0AlcjM5aoRIjnnaY6e3ZIobsJXPE1B2QyVBXtiB+byUkxsS1z+7gLZvNmqpJQv31Ca+7daM6jtumDpU1d1FwjnT06ypKybQ/ycoRdLrO0mXoBgnJ0Rk7c+gr9AD0g=
Received: from BN9PR03CA0303.namprd03.prod.outlook.com (2603:10b6:408:112::8)
 by DM6PR12MB3355.namprd12.prod.outlook.com (2603:10b6:5:115::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 17:18:21 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::43) by BN9PR03CA0303.outlook.office365.com
 (2603:10b6:408:112::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Mon, 29 Nov 2021 17:18:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 17:18:21 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 29 Nov
 2021 11:18:20 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>
Subject: [PATCH 2/2] drm/amdgpu/gfx9: switch to golden tsc registers for renoir+
Date:   Mon, 29 Nov 2021 12:18:03 -0500
Message-ID: <20211129171803.421378-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211129171803.421378-1-alexander.deucher@amd.com>
References: <20211129171803.421378-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a109e36a-a11f-4f91-88e0-08d9b35c3e47
X-MS-TrafficTypeDiagnostic: DM6PR12MB3355:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3355D3D5236045D9D6E67F47F7669@DM6PR12MB3355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:252;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/clr6/q8sewnOafopPSM1uIQjWcm0HsW1HApiygaRNUBGP/tu920m+C+xWhDIycY8c7Ef8K2M94AdmffSnt58cqsoul8mvz/YKZnfCBzleQ/zm0eScUsGWGTd8cGuv2gn+O/8GmyMvtDaACOOjvzBtyKx5Oih3jxFG1SJdvttU9YWK9AsKcMXOh3QMYolGZQHx/cGyuzyDiJ43S8qxpyiF04wbjN27KL+BBQv53C7RuhkGspB6V7MPrv6Bg3QKpAlOPSIKrDUJsomZwibBJQHMLIuXNBk61wxP0JFFWKGcO4kSMKGX6tlk4aQx5pZSXlhAMCtZnm7ou4UpWXTFhgeJyCe5+iWl1Y5n6+i1ZmIQNcO641EjmctiCUhhFwLsMIBtGDNq3C5Vasov4wn+C8yJWzap4Y77ulJpqQ0AhTgbA5pPtt3InBDwNJBMD86lBOkIAXSXpvezrRUGr/4iIM9dXCTITXp6LKg5z0Mwz6gAuYlJ1zlUFXX6wF+OO33/o8SxxicYutfYJ2hYRxYpHcSOc2uOHVsHOh5ziuk0s77o1QS44W2MrgKJOUGyRuOmlSukUIuU7sj1AwWycLu+EHfN/99dlGr4tPViePF1LKSJh8EUk1wj+R8nX7KFgW+h8JDMu8boJgcDfTR1qrGVx5BDAxN1d7PK6Njb3fRnzyPE4mgCSRlzYd0+NlI1zRrd+dSzOCJ0LqWvuqqoU4gKp5HdlMmxm9d4iJOCX0ahIEuE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(508600001)(82310400004)(186003)(4326008)(356005)(70206006)(36860700001)(6916009)(8936002)(16526019)(81166007)(6666004)(5660300002)(36756003)(2616005)(54906003)(1076003)(2906002)(70586007)(426003)(86362001)(47076005)(336012)(83380400001)(316002)(8676002)(26005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 17:18:21.2444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a109e36a-a11f-4f91-88e0-08d9b35c3e47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3355
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Renoir and newer gfx9 APUs have new TSC register that is
not part of the gfxoff tile, so it can be read without
needing to disable gfx off.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 53af98c091bc42fd9ec64cfabc40da4e5f3aae93)
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 46 ++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 025184a556ee..55f8dd6e56b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -140,6 +140,11 @@ MODULE_FIRMWARE("amdgpu/aldebaran_rlc.bin");
 #define mmTCP_CHAN_STEER_5_ARCT								0x0b0c
 #define mmTCP_CHAN_STEER_5_ARCT_BASE_IDX							0
 
+#define mmGOLDEN_TSC_COUNT_UPPER_Renoir                0x0025
+#define mmGOLDEN_TSC_COUNT_UPPER_Renoir_BASE_IDX       1
+#define mmGOLDEN_TSC_COUNT_LOWER_Renoir                0x0026
+#define mmGOLDEN_TSC_COUNT_LOWER_Renoir_BASE_IDX       1
+
 enum ta_ras_gfx_subblock {
 	/*CPC*/
 	TA_RAS_BLOCK__GFX_CPC_INDEX_START = 0,
@@ -4228,19 +4233,38 @@ static uint64_t gfx_v9_0_kiq_read_clock(struct amdgpu_device *adev)
 
 static uint64_t gfx_v9_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 {
-	uint64_t clock;
+	uint64_t clock, clock_lo, clock_hi, hi_check;
 
-	amdgpu_gfx_off_ctrl(adev, false);
-	mutex_lock(&adev->gfx.gpu_clock_mutex);
-	if (adev->asic_type == CHIP_VEGA10 && amdgpu_sriov_runtime(adev)) {
-		clock = gfx_v9_0_kiq_read_clock(adev);
-	} else {
-		WREG32_SOC15(GC, 0, mmRLC_CAPTURE_GPU_CLOCK_COUNT, 1);
-		clock = (uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_LSB) |
-			((uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_MSB) << 32ULL);
+	switch (adev->asic_type) {
+	case CHIP_RENOIR:
+		preempt_disable();
+		clock_hi = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Renoir);
+		clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Renoir);
+		hi_check = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Renoir);
+		/* The SMUIO TSC clock frequency is 100MHz, which sets 32-bit carry over
+		 * roughly every 42 seconds.
+		 */
+		if (hi_check != clock_hi) {
+			clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Renoir);
+			clock_hi = hi_check;
+		}
+		preempt_enable();
+		clock = clock_lo | (clock_hi << 32ULL);
+		break;
+	default:
+		amdgpu_gfx_off_ctrl(adev, false);
+		mutex_lock(&adev->gfx.gpu_clock_mutex);
+		if (adev->asic_type == CHIP_VEGA10 && amdgpu_sriov_runtime(adev)) {
+			clock = gfx_v9_0_kiq_read_clock(adev);
+		} else {
+			WREG32_SOC15(GC, 0, mmRLC_CAPTURE_GPU_CLOCK_COUNT, 1);
+			clock = (uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_LSB) |
+				((uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_MSB) << 32ULL);
+		}
+		mutex_unlock(&adev->gfx.gpu_clock_mutex);
+		amdgpu_gfx_off_ctrl(adev, true);
+		break;
 	}
-	mutex_unlock(&adev->gfx.gpu_clock_mutex);
-	amdgpu_gfx_off_ctrl(adev, true);
 	return clock;
 }
 
-- 
2.31.1

