Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE795B12E0
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 05:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIHDYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 23:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIHDYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 23:24:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D3EC6FFF
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 20:24:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6evhSYQm/tVxtteFfzpSTInErIxpHK4d3Xm9TcT3GCcBnR6wAH0aiL20WNPd4wMU3NxUPqkniuI3ignK2nWFiZsljDRmOHbalwRwOUkDSyPkVikdd1lOeLYJvzUZpztivYNNFD7k9Q9PXSlqsYgcEFCcHI2+BYjzXa7cxQyxzi8ncZrHuKOv3kz2O2FUE0OW030pHBQs10MyiNzreVbRYwmjn3ANqskbwid/nyVZ7zPAg76RtjcLBPcf2k7lJAvrtgbQ3e3zZO+1fFfWmdjUSR4AEPvmEdB/N1zR0xqySnCdO0hMH0pNt9SOUwL3PW2TIawd2zhNGRpD9JwA7bmOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7c9y+8wpiAlqBfpR2pl/yGh3VKvIGkgFV82qjY1tTA=;
 b=IZ+1TaWMwuI/nDJkC9NQECO63Va7Jl8QgpeASPME0fpS3/2BruBDW0XONXg18Uz13NdZKzM2xSImwekdlaH/f5ICWSWTVo//LD/ZvBTgAh9WFr0KX87tsWr5YtT+tX8EvXV7GxEIQdXQ5oi21Ew0MmUsO0f42ZPicz8ErsqCVi76mos1AQnMWmAN/ro2drGqyWPoAxLyPg8iQktsXdbeKgZEVV3bjnLXDWrs6Htnf4ggHKiCxT51VLJNVhM2/OTNiLjqF3BdMIalnOoi3jDNkgIMRttzvmY+iONfzWH9n2nQOqrpNe0nw7qilb+wWmlmw9x94luBEOowVqwTKMDGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7c9y+8wpiAlqBfpR2pl/yGh3VKvIGkgFV82qjY1tTA=;
 b=oTnB1gkITjoRXD/Ba6x6v9wCXBCQs1qeX9+AESpfhyEIsWzU8xYSV4qExXRNbr/yt7sZRu5vQ8w3RBXpqYB5TVClWKKdrzh0vZMaMlxA6V4bJ7LdwMgl+MV+plWdgG1iE4+T1beT0hBxoYUWQxygb/QSNTWpEQBaEiEajX+B/3o=
Received: from DM6PR06CA0040.namprd06.prod.outlook.com (2603:10b6:5:54::17) by
 DM4PR12MB6398.namprd12.prod.outlook.com (2603:10b6:8:b5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.17; Thu, 8 Sep 2022 03:24:14 +0000
Received: from DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::d2) by DM6PR06CA0040.outlook.office365.com
 (2603:10b6:5:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.15 via Frontend
 Transport; Thu, 8 Sep 2022 03:24:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT079.mail.protection.outlook.com (10.13.173.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 03:24:14 +0000
Received: from mlse-blrlinux-ll.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 7 Sep
 2022 22:24:09 -0500
From:   Lijo Lazar <lijo.lazar@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Hawking.Zhang@amd.com>, <Alexander.Deucher@amd.com>,
        <helgaas@kernel.org>, <wielkiegie@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/amdgpu: Don't enable LTR if not supported
Date:   Thu, 8 Sep 2022 08:53:44 +0530
Message-ID: <20220908032344.1682187-1-lijo.lazar@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT079:EE_|DM4PR12MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: cb1374ea-51e1-40e9-9903-08da91499ac1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQt/rQiWYmPesJtoNB0Ihc7yIGq8RVeHlT+zlL+NCgudALHPZEOznCh00tejBvpCGX/Bm2O3tTDgoPx64n3hi5+qWjywczIWeSuM/8mUh8hZrNMOQBHI1+h2UWhjK9Ld7QEZTB9dUF2FI6MJPSYdWEeqxj1hwlOAuCVz1zOA96APkTXuwnE9nxudnjg3P9Ue57csnWb87ULiH5R1if9HlGWsaGi+EzWlusZXpMwD9ZMyblJhHTca2MgYLl6pmzFW7W72nGh3VFAVq/NAaqFofvwjMn5e6R54zMiHG6mM56bfzVutRKUiDgPYpcZup3kuN9R0mpiHZD7Sd6DC9a4HlN91h4FkI5q9YMflU52VDmE8fTA8cefKeBO2qe82VVwzvvkUwfxkKuB9aOtgL10WNAkYyHLCsA5K5XHioWmMgDyw6mTAvJNsWfxqLzNWfIG3z+roBXeVmmkQPkK/d0+7aavDtKr5cPuLSPtpSvVXNsWUsk88GchuUXbIVZ+Ab/DgFZSYvL+4RI62V6gt1mAgikMRtz+57UW7o9EyKlZ/9nZsxlFoTkj9O+v9w01C2EvSWsQb8lPTVdGoCpeOSCf6FbNllllvSFM15TEnZymqhMqcxb2axACfIbpDjZTS2jWyVOWb+kTaMvvuBUFDEnqxYn8gxIpO7EwMWRTuh8L9dpo1d3pcQvpYkV6T2acGKas+ziUo76HnI9j2C2qF5OBbulA7kF2n14kjjprHX3xUtUb+ZFzzL5dbwmEnfaC/0WFNOsRYCo4EbvLPa9fjo6QeI2XCJ0vK0Npq/z+qdZBqOzWko5NJmrI0bdB2ShMdnEcMGfQ7mtabnwbHOhLp34VsAg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(346002)(40470700004)(36840700001)(46966006)(54906003)(36860700001)(6916009)(4326008)(5660300002)(36756003)(2906002)(316002)(8936002)(44832011)(8676002)(70586007)(70206006)(86362001)(966005)(41300700001)(478600001)(40480700001)(82310400005)(83380400001)(2616005)(7696005)(47076005)(16526019)(336012)(1076003)(426003)(186003)(26005)(40460700003)(81166007)(356005)(6666004)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 03:24:14.0428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1374ea-51e1-40e9-9903-08da91499ac1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per PCIE Base Spec r4.0 Section 6.18
'Software must not enable LTR in an Endpoint unless the Root Complex
and all intermediate Switches indicate support for LTR.'

This fixes the Unsupported Request error reported through AER during
ASPM enablement.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216455

The error was unnoticed before and got visible because of the commit
referenced below. This doesn't fix anything in the commit below, rather
fixes the issue in amdgpu exposed by the commit. The reference is only
to associate this commit with below one so that both go together.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c | 9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 9 ++++++++-
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index b465baa26762..aa761ff3a5fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
 		WREG32_PCIE(smnPCIE_LC_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v2_3_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v2_3_program_ltr(adev);
 
 	def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
index f7f6ddebd3e4..37615a77287b 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -282,6 +282,7 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
 			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -303,9 +304,11 @@ static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -361,7 +364,10 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v6_1_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v6_1_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -385,6 +391,7 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index 11848d1e238b..19455a725939 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -673,6 +673,7 @@ struct amdgpu_nbio_ras nbio_v7_4_ras = {
 };
 
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -694,9 +695,11 @@ static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(7, 4, 4))
@@ -755,7 +758,10 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v7_4_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v7_4_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -779,6 +785,7 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {
-- 
2.25.1

