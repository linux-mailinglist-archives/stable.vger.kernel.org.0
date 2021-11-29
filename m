Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354F1461DF2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379200AbhK2Sa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:30:58 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:7521
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376808AbhK2S24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 13:28:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGyovq+AozlM59CSJ5gWSWyZVAXOi2i2V0so9pKR39Ql+BB3bsPNY6yBl50iJ8P3OHEC2zeBlkIwHN/Ya2jgaJSgE9pHISE4DYY51B91KhyJRIb8nA+jAdPxwTAZmX6ezQ0xq8bMmis5xb2AVUc5n+0dbF+jtrDUQbeofDNa4/BNUdKgKKoEJcUr2dSLmsrJjPL2Tjec+xKNKXnkH4a5rKCTKS6EUqxm1eVWipZkuJlwpFopcamyLs4kj2mYNdQJAn9tB+xbNHVCyEYYWTBH0fY0qb+9rIGQs7f5bRXFjXlFyss286TPFkarIVostGmtIwe6XrzP2kP/aMJ5ykXG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJ3I5o3+tvPUGYGk8Kq7qQAeim5OcU/cXm+Kn4czK6Q=;
 b=Q51t06PTsB0GhPgqEz02uWIJmEjgIF7h2hqIf9AYpuHV+pCp9Fm3ziawH/yX8I2aBWwtrcKsAd6Xr9Mc0twH80IHm5GbahvSm7V3DpPHJCqRHYhkxY7gt4p2C6Pu3wuRLAASjE268EUnTfGJJcHOCXGpTqz+PKk0wC0h3B1XnW3h3+vB6vEuR7ZCLs5gGwqRAfIrwh3sOqStbo/13P2Zw/OiORmTsbcSetV4Kg3We1fAq+PTjvC3fqfFs9HmIZfnyE7MuPJtaMMhwb7Vzzr5nHxevINXdKbdyY04OCnZmN0NmyfeZ/rXuyhZ9rrPXYIvrk39odPRTKWHpwaIquHzJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJ3I5o3+tvPUGYGk8Kq7qQAeim5OcU/cXm+Kn4czK6Q=;
 b=pZRK8W14Kwje/gkJakZmgjlgbZdazT4Zb3stOXCyzD92MNLLwvEvzuGouFA8SfRUiev070jxCHqM15Hmw0/owQKQaoIazTo1tTBu8RPPtpI+ul9eZIZOyWLCQwRqup1eXcLUzC95DTbsiDy2Kl5nuqRX/c4HT7AHRBJYVgC+B9o=
Received: from DM5PR17CA0068.namprd17.prod.outlook.com (2603:10b6:3:13f::30)
 by MN2PR12MB3694.namprd12.prod.outlook.com (2603:10b6:208:165::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 18:25:36 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::64) by DM5PR17CA0068.outlook.office365.com
 (2603:10b6:3:13f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Mon, 29 Nov 2021 18:25:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 18:25:36 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 29 Nov
 2021 12:25:35 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH] drm/amdgpu/gfx9: switch to golden tsc registers for renoir+
Date:   Mon, 29 Nov 2021 12:25:26 -0600
Message-ID: <20211129182527.26440-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4abeab35-7df9-4346-3837-08d9b365a384
X-MS-TrafficTypeDiagnostic: MN2PR12MB3694:
X-Microsoft-Antispam-PRVS: <MN2PR12MB369431D374B041A8AE78DB9EE2669@MN2PR12MB3694.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5br0hG5cnZi2yjWcaBdZPJxRC9cPh5a2iSMJDjjrybFpH1GfjKqy9+r1cc4m36wt9AwmFyxT0kwba6IGbQZ+nR90Bi2Jq8edyp5dBbKLrcekO4GMbOFcf8O2HgwMEDVP8j4jFzjg9UL+yt2anX5uZ9xuNiWkjQMp/ZzN+CrulY49YE1hZu7j8FfAU6++NjH+wxHBX855JbDslMeAiK/OowLWlHogptHKCYw63jipbTmG19BPCs5FZm8OaitC51JVN1hz5dCH0FLfo2ddJ2mZAt2jOHhmzJan+HHoQNzvBVNCHXJCDhgUwAeZcq580Ci6YolKNB7bLz5VFkkx2CSg96m0gSG2iHgEHb7gdRygY/kFs7lsBOr/GCGQG70VnDa6Ednmd+D+K1IVu6h+/t00iWlWLKKEEYIYpDKjeUWcUN2RzBWWCOyuwBJlrPKIZ2d9WG7uYF2zX6aikhQmdJbbKHKMP6aD/daB/j2cnvKJ47qX+Kjocg9eVMJHl4dgJfgG53iuSG4nkOirpRqDhTC+knwiJpP6PQPJ18fCU4+g1Nc18qX0R7mrZYgsXM/iRhnIezB90uJqTneimOHPnWlWDVwsAPhYgDM27jB1AzWfKI1NCO/PFECO3pweiipTac1QLxqiYvQpDyT5pEnEOC8ofP6g2k9pqdjZPlmVZDUvfEs2mtvPn4WyrCwC2zzLa+26PVeodZ1ReAItcGZjTSziI2rOuqqC3ZUY43ALH1dAq4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(82310400004)(44832011)(186003)(4326008)(356005)(70206006)(36860700001)(6916009)(8936002)(16526019)(81166007)(6666004)(5660300002)(2616005)(54906003)(1076003)(2906002)(70586007)(426003)(47076005)(86362001)(336012)(83380400001)(316002)(7696005)(8676002)(26005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 18:25:36.5192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abeab35-7df9-4346-3837-08d9b365a384
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3694
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 53af98c091bc ("drm/amdgpu/gfx9: switch to golden tsc registers
for renoir+")

Renoir and newer gfx9 APUs have new TSC register that is
not part of the gfxoff tile, so it can be read without
needing to disable gfx off.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 46 ++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 11 deletions(-)

This is necessary for s0i3 to work well on GNOME41 which tries to access
timestamps during suspend process causing GFX to wake up.

Modified to take use ASIC IDs rather than IP version checking
Please apply this to both 5.14.y and 5.15.y.

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
2.25.1

