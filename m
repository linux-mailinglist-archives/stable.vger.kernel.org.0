Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AAE46F68A
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhLIWNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:52 -0500
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:2657
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233305AbhLIWNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaBqz9YQYTtqTBGbw8QNWlBWvl8LiotHbOJizGEfgHiqiUSB29/WNjjYKgMeY9gD6X4ig3J6MF7jutM34sAUzlnSEipE5jfAD2EemeFZGF+5KqJbdtwgwtnHQ81G6SD2hNoiz7Cka08KWfnAli4fPy4hG8hRfPmxp1cpOfnbb/uEhwDk9yqdRmqlOKB4zDsy3aPCAgqFqe6Xe/jQtcP9qBjwbgXs/J2C8INNhIJkYsokwwXbSHAPQgOsbbyDZuUTEUULgqznQciBWT2tzfji5GUkcwIn2UqPhweV3eQI1p2vQqiRsNu0t6dsEyleP2Tdy4h+TLze3TpQdiLba/Fs/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLBvRtcTecUtodgDVuo/idWfUp6Z6SHDpqx/lUFu6IY=;
 b=R0drtglsF+TsnlgeYZS0ZODj9bf0naASczzzTe7JfdRbRz79pHQbB5XrifQz7SN3haYpriytp9Mz22dTmpIq7DmMuxXAkQSAQTH0m1GtOhyvtqIE2LuHT27U6ny/UbG/qQyoalSCU/OcUzSCOOm+IVSi4Zv/4/ywa9j2h/WVrtNJHIAL9LBWtkJUSKMl4TKkufDtm8Z9rBdazYU4ndXdv3hAJly18DjbFPrAQBKS6l3c++0iErQWojgEMK1nDgyMpuPUT24hG4U55PGjzdpQ83ET4iKD+H2T67pBFxjBnLFX1DTFZIada3MttcjrcJMEWJ9PXk0r+Bmn4CkdPMGlFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLBvRtcTecUtodgDVuo/idWfUp6Z6SHDpqx/lUFu6IY=;
 b=E+UzVK18fvHH1pTM3Twx2rgaw0PUNJHcgYU+kRqPSp7gbzFHhfx15CovJq9U6mTC81aKW+fwzsdwGu/XsGLwzd+B7aLsEm8/aOPAlcPmJVS0m3Y2sPDdFQcb3/q+GiO+3FDNvZzOoXw1FW9/TFujPm194Ax6C4M5p39UCDM2QPE=
Received: from DS7PR06CA0041.namprd06.prod.outlook.com (2603:10b6:8:54::10) by
 CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Thu, 9 Dec 2021 22:10:16 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::e8) by DS7PR06CA0041.outlook.office365.com
 (2603:10b6:8:54::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 22:10:16 +0000
Received: from jz-tester.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:10:14 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Yifan Zhang <yifan1.zhang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5/6] drm/amdgpu: init iommu after amdkfd device init
Date:   Thu, 9 Dec 2021 17:09:55 -0500
Message-ID: <20211209220956.3466442-6-James.Zhu@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209220956.3466442-1-James.Zhu@amd.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0350271d-0fd4-44af-7d43-08d9bb60ae14
X-MS-TrafficTypeDiagnostic: CH0PR12MB5089:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5089D8E527D9FE80BC98D292E4709@CH0PR12MB5089.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cCaQVJ52YCa/C42oozI5B+p7D1znL9AkzjfKrG93L7gP97xCnjuWbMwCKle/oMsGgAsJQAn/7Iuw6HUhmddoEFLiet2ywjFEZWidjzYBDbxrx49mPPxgyewkDuujDVRBPPBDnHRH6yGQRjrYjNWiDvmL0Zhyfs0h/tGUAwjs5Fc1l8iu7cbHh01E54Inruibu/ev8UVzCULKHclqq5fH9FgKRd0gZ0XZWGgPAG/wAan1J7XZlPemPgS7SNFF42Lbs0WZcIk9Chtn/iVFOPtZ8ehcNgqdFku3HYmGDVi8mnfWofetNtoqWOyRv5uwqyhaP7H32Xrinfj3mABExsCQ+4sc+zdbbWG3g6bCuH9gz69MFYv7jO+MWYv5xT/cOapsjqmHM56trZmZv1UxuQp0sjROFKi7kjOi1chNJz98Ogze6t6pQGAiNz/o+AusxdW4q3IBqd9echHsHfbkg8sjug8khyOtHOOqRcTuU8wS9mxG3ufnUqiVy3loS2kN+G/XAXUdqgEu3ByybIa2SHu8uTrhWqs53DflfvTw3xl+kprcFL8W8WNLHwGKtOsGtL0nvmut1aPrRzqxm788DsE2WJq1Y95+8meBZwaVHkUz/eihShu+RXRj4RQS36R6hOjbUU85xOaTuPPVa64CXFqvdDw2FYzbMddoLLCw7r5Ba2vagQktOmJ3Jpx22x2FdtXmjAZ1OM/56J+jLF9bGN0q1ShPTWbcjLcuetb2NrEjihlHI8Ew6XIkdH52vvnglYZpcDcCcQFhOdzgv64kiwGm25K3BTFl6PjaIAXEL3h0K4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(356005)(8676002)(26005)(5660300002)(336012)(6666004)(426003)(83380400001)(81166007)(40460700001)(70586007)(2616005)(6916009)(186003)(70206006)(4326008)(508600001)(36756003)(86362001)(47076005)(1076003)(36860700001)(82310400004)(54906003)(316002)(8936002)(16526019)(7696005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:16.0375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0350271d-0fd4-44af-7d43-08d9bb60ae14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 714d9e4574d54596973ee3b0624ee4a16264d700 ]

This patch is to fix clinfo failure in Raven/Picasso:

Number of platforms: 1
  Platform Profile: FULL_PROFILE
  Platform Version: OpenCL 2.2 AMD-APP (3364.0)
  Platform Name: AMD Accelerated Parallel Processing
  Platform Vendor: Advanced Micro Devices, Inc.
  Platform Extensions: cl_khr_icd cl_amd_event_callback

  Platform Name: AMD Accelerated Parallel Processing Number of devices: 0

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: James Zhu <James.Zhu@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2947bded074a..488e574f5da1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2220,10 +2220,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2259,6 +2255,10 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		amdgpu_xgmi_add_device(adev);
 	amdgpu_amdkfd_device_init(adev);
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
-- 
2.25.1

