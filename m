Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF73461DF4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379212AbhK2SbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:00 -0500
Received: from mail-bn8nam08on2043.outbound.protection.outlook.com ([40.107.100.43]:8288
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348517AbhK2S27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 13:28:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVaHTeVR2VrocKA0mSUXrm4STVhJMSZf0+AfWDAvs1E4XESNOtiCvzqJKI9Ig11tq8U8rE3TVvGBxslNzUzY/rJ/e/lCnayW+X+jxdOutpzZ8p3AY0+d3bZYKunteJWEZQ81lJDL30RdJtWwPw6F8fNH8miSO3ZMRwgjgYajR6p5fW+XTyN3QPN6CsswtXwAWgEbrQw6KU0rW8ycMqwXwXTMYIBzsTP0z/ptTc+oU0qG8hn2lwOalYmarWr2h4wpDv+BUUVxIKAJzJM5foALERcq5urybmUkDk9oujGlyPrjU5vYdey8xyC1x8E20dxoh0lNwakMyhc4wBlm5nnInw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H40ASNvjlAzn8W85gOPoIlKGIEBWoAbypaATqy6ytBo=;
 b=OnZYJEbIPwccNOkl0dMzxGLv7xs6uKh4UqXJNtxmLdInkoCIYrY4KrPEGG6QQUBccc4TEuwAvhyy0oA5Mct9FDhFgJ+B+/1lTQS1sLF3ClsBnYJLkLmnVDmLOjtEBZNY7TaLqTooVnJZdAHLa7AoA+WJUB31yuQH/s8U0mWJIK/OdoS8qgjKXbhHfbX085Mpz9jT8JGAoJy1mB7bmt8xmczn/Hfqo/RsGOCz3Oynze00kzlVia+XKEyd1g99NU7ABUA8IDTISYggupgF4NzGXvhsCw3I5eJmjBuQ0kQwzYXy0iJSghQk6RRVVU7+bu1jTb4TemK1hXeSpESfgsKn9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H40ASNvjlAzn8W85gOPoIlKGIEBWoAbypaATqy6ytBo=;
 b=fytiPtJrj34R0vgchvOGbkr9DDEW5OhVeyuuTKvkOhEPnHL2MzA/Ce4yKOlbVV9tV+ef3f32R4wejP3AvKzp4CquwvRcvd59gANvcgHpkyzenXTXXTEY1DMeTCEumQHrNavVPNNQmL+lBt7cWMf2GknzOK0EY4ipqX1AYiQT90E=
Received: from DM5PR17CA0062.namprd17.prod.outlook.com (2603:10b6:3:13f::24)
 by CH2PR12MB4151.namprd12.prod.outlook.com (2603:10b6:610:78::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 29 Nov
 2021 18:25:37 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::d1) by DM5PR17CA0062.outlook.office365.com
 (2603:10b6:3:13f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Mon, 29 Nov 2021 18:25:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 18:25:37 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 29 Nov
 2021 12:25:36 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Mario Limnonciello <mario.limonciello@amd.com>
Subject: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check for APUs as well
Date:   Mon, 29 Nov 2021 12:25:27 -0600
Message-ID: <20211129182527.26440-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211129182527.26440-1-mario.limonciello@amd.com>
References: <20211129182527.26440-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77ed2e27-2eba-4fa1-52c7-08d9b365a412
X-MS-TrafficTypeDiagnostic: CH2PR12MB4151:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4151E2F09A0672D61401D435E2669@CH2PR12MB4151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whvkE6lPH29RawfQlWEvzuC2G9SjxijXFS5vTyAdMf7dNCSGNIHF8MIFdB0deg24lM6GIrx2G0qWTMT5jOoaFp+YztnaZ3UkmNhRxKxCd05Dr/t3wqIP2Ec+7kjW7T1CAt4Yn3LQnEEu8G/ypvd3meRcYDTmdUR0Vny+kAkSB00ForIKIYaX4vVViZBd1IWFg0GUn6j5TTJ92ciDcRpV3LzGwb/xi6JLbPYsI2LR8DsHjsf8WkzmGjmMPf6CQqdSsHGOnrVWvLfT49P3dT9i+Wa6RDiYuGBlYbY4TnSUdYXz816jQ1nSzuTcnl0Z+ovTBqBGmkDswcpxMEpKiCT607ERMVBjsjlrBdY9XSW9PsRgcJW8C4q/X7dqMWCivfDH5IIVBZRJTBtYI2ZIXT9sTlVoHQBJf/jbbJzyYjIpneUddOIDLnpydeKZOAot9N++ytCqsV4WQupChyfoZ4vYQl4zErzXF3O35IRoQOzrrtV8h4UEVHpfMC49HeWDK/B69gDXW6/4rshFj/bHxS9heyvCwAbsDbZifCVRVIYrU9vf5vf22j+I805E2+QJjD8LwoNCLOA0NNasS5LFtYRtwfPNuztASlFO2bi9thzFRwi/YuJRkk/uW55cutEIZ54uH2VRdlxfk1gAAykC67/21K5V1kOUkhDfMo+Yrs7u+QrLZ5RXZXU2CfqS3tTZY8uCV2anynUW36ri0sp/+9cF8aBZW6/3Kx50iOPEm4sCfag=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(6916009)(16526019)(186003)(44832011)(81166007)(1076003)(356005)(336012)(426003)(2906002)(47076005)(8676002)(8936002)(83380400001)(7696005)(36860700001)(36756003)(4326008)(6666004)(2616005)(82310400004)(508600001)(70206006)(86362001)(54906003)(316002)(70586007)(5660300002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 18:25:37.4495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ed2e27-2eba-4fa1-52c7-08d9b365a412
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4151
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 244ee398855d ("drm/amdgpu/gfx10: add wraparound gpu counter
check for APUs as well")

Apply the same check we do for dGPUs for APUs as well.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limnonciello <mario.limonciello@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Modified to take use ASIC IDs rather than IP version checking
Please apply to both 5.14.y and 5.15.y.

When applying to 5.14.y this also has a dependency of:
commit 5af4438f1e83 ("drm/amdgpu: Read clock counter via MMIO to reduce delay (v5)")
If necessary I can send that separately.

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 16dbe593cba2..970d59a21005 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -7729,8 +7729,19 @@ static uint64_t gfx_v10_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 	switch (adev->asic_type) {
 	case CHIP_VANGOGH:
 	case CHIP_YELLOW_CARP:
-		clock = (uint64_t)RREG32_SOC15(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Vangogh) |
-			((uint64_t)RREG32_SOC15(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Vangogh) << 32ULL);
+		preempt_disable();
+		clock_hi = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
+		clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
+		hi_check = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
+		/* The SMUIO TSC clock frequency is 100MHz, which sets 32-bit carry over
+		 * roughly every 42 seconds.
+		 */
+		if (hi_check != clock_hi) {
+			clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
+			clock_hi = hi_check;
+		}
+		preempt_enable();
+		clock = clock_lo | (clock_hi << 32ULL);
 		break;
 	default:
 		preempt_disable();
-- 
2.25.1

