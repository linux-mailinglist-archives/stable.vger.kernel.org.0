Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3631D461C9B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhK2RXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 12:23:40 -0500
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:41760
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230403AbhK2RVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 12:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEvvdXqvc57aJiHxY6oK2aXz5qm32WeWRitgXlav9obENLopVbVeyNMoieSbEr6a6drBbkNmSH9B9ohEEZOe+6wzv15Br8EGYbTlk1lB14Zy8vAcYF+TujQPgKOYr5WWmCsTmRUEHMgOo+8Bfyf8apf94lC8a1gBCgPWI+otWgg30mk/1LkH+z/OQkPCHsfd/okF+XrVWPhPAjLJGI+P4aoBotejjZbaLNX5MTCTPhnrppaEqw/zMGgLXDL/MEyAENUXCdHnyQlxAe/EyULxPj0Zb6LeMPI2sIOqED6kJeP15ZP6ZzzAjLPZjQR7OVSKrMzdpu/Xj0YS3wDr3DQgeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhqB6tfv+ocwJkWAV7KKqwPw/WTYjKw06FYJgQzfPvg=;
 b=nabVuaCLQPmgvSDD67/ELsRSNvFKAcuVEV8NchfOoyTkPc1Vz8OlhpOi50XAcD/pGB6wmVFcaSg/aNNC59WAFJDuY2/2iaKw8vonaeurK1kwwteLNUBp/nH7BlXBEcvvQcoQkkV/qfAEK+YZ3SL1Zqfyn+GH6Uw3ThPSxevnqbA2HnTi7Sxo862rraNNh5K5aa8d6mrujEgNhyyDlPWKcsN4lAP/OjaNWsfoiFxp8e9jxH6STUvc2BhFyqDRdH0MgPjHMBCm/8E2hcnTyNyfXRn6f53FUW0/Krfyd50eaMVev4FQiIMyTtd6teahTZuB9dkYBJp+xoe9FVoBVSgTjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhqB6tfv+ocwJkWAV7KKqwPw/WTYjKw06FYJgQzfPvg=;
 b=UET2gNcSt3NJXv4Ri3+nl7lGKWw1ygOfWvDKlRS67fQDh7gZ86/7+G8ZfYWmv7IwpwVmTUmg2e8KrcbrHWMQC0BdEUVruR6Dd9yzpSS37enQn5nHdaT3ypH9XOFPzjze+EEBfbmda8iAbo4RGRLOBnxLrND3GKS/pC6EKSqtbcY=
Received: from BN9PR03CA0318.namprd03.prod.outlook.com (2603:10b6:408:112::23)
 by DM6PR12MB4465.namprd12.prod.outlook.com (2603:10b6:5:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 17:18:20 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112::4) by BN9PR03CA0318.outlook.office365.com
 (2603:10b6:408:112::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Mon, 29 Nov 2021 17:18:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 17:18:20 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 29 Nov
 2021 11:18:19 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>
Subject: [PATCH 1/2] drm/amdgpu/gfx10: add wraparound gpu counter check for APUs as well
Date:   Mon, 29 Nov 2021 12:18:02 -0500
Message-ID: <20211129171803.421378-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95be4a2b-f58e-4627-0b66-08d9b35c3e05
X-MS-TrafficTypeDiagnostic: DM6PR12MB4465:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4465D0BF0C3920DDC783BC26F7669@DM6PR12MB4465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:534;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQ5u6zoe+AIJZj8gJRAIxt/cpSgNPagMS4vYtcapyXd0ylZq+/AcMGOM95ml9VGkNCwi6s4C5OcTWXDFIMd3+0m8nNXxiveF3H4NvK84gM3zuuVxWuy9+nwXgc21vTxX0f6SMESnBavZiJhpnYbeqhpXvKi9irG1JlXcCFH4E59WsK51qow2dGd0EDJaJBfcqgBDvInSTRjbBL+LrTA4rbteTGqNNqKcCcTWc/nW/mXWnrowheeFqoud1lXzy9r3RCmTifKgDP2NqD6EBJZLMmOjJd2HCbgeAHGEVtZiaJ3uIbc+2krEyUVJI+fw+NmUi0JHC5P3cMhaSurI0T9NGq9U+weyWgRFQz0tHN66gyFmnKGm020UdobSQiaKF1HFGUpAvqaxkZb98Nwr63tuFE+14EHZ4/jelaFoux6sNUjDVisKlbmSdK+MUC7555Zaq75PpsSykAbinTN/Uxy5IXDig8imH4ICBh0czXwK7BUiOP8Aq0gPyIOtK+7nnxVuRfDUQiU8NENF0SHwQiPJK7EHdQef+XWh+pxhJVTbyWNl6VfIDlrTyKXvb/O4nJ24aPMSUOnNS1LfMlyjQzExHWfPkUIFiobvHc/UsU0yXbQWyIK74YVzHDNnSykDRAUHfvWR+PDr5UTxwZPYLUzG7jYBthpvAPR9PnxKRB6jH9ZvSS9i1MbGBMw+/xmNFGgAXTMx66CTqs8PoWRCPU5SNJP2H8uf3QdOJ/Rvo17Bn3c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(2616005)(1076003)(81166007)(6666004)(6916009)(8936002)(47076005)(16526019)(356005)(36756003)(54906003)(36860700001)(2906002)(316002)(7696005)(186003)(83380400001)(8676002)(508600001)(86362001)(4326008)(5660300002)(426003)(70206006)(336012)(82310400004)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 17:18:20.8047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95be4a2b-f58e-4627-0b66-08d9b35c3e05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4465
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apply the same check we do for dGPUs for APUs as well.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 244ee398855df2adc7d3ac5702b58424a5f684cc)
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

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
2.31.1

