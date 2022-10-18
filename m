Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D22602374
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 06:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJREru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 00:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJRErt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 00:47:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111C1923F9
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 21:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVuDOuP1AxTHLK6ydjnbXksjsQ9n3LLldkytgpgRgNkgcPWdHCsZJI+lE2qHZepSFX6o+ksCglk5q23yhaxME4Rd3jgtC5rAUwZ3Wqzx/ACkKx5pbgqhFXwoP6d6cVOykwCzdCrINWyxWCss3UimgNl5wqMnKKKP92rOeT8Wo+dmpVdpaa/kreYwnw+xMv5j/SWaXaAxqgvx95EhubVREwLIs6tF7+7rLc2ztjexwV/gDAcFcUHZ7Wjb5yHn3GRSzXcis5Oy4y1CM6m3/QkY3PbPHhxw6FjV1cP5jYZdKKNkFIK7CxolfuAgWuBweF1JD1ZaXJFTL+PnUc4ZTHLgcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cn/qeeYoJofZEbcWNC/g7gYhpfC2bu4VaIORh72eWrM=;
 b=ZVkEjB1o/FN2G338KUd5dtTBrToENWwMzIms4YV/taI3Geq8IJ6A0WbrD+G6E0sqbIxg4CcAeGupaKwQuACoEo1JWg2Rczrsl2wJXkbZY/z50w5+2XwVhcRpc7s6I1Y4dTBLWi8N7CzqDALV8k2w/IzVhFx9nLrtLNl6yeIGnY8uzGZpEICjHdWn8WP2azBmdOQHbEz6ud1CpuBGgjVjcrZInQLSlhXMZ0bMM+IgyaSMQ69jhfZJK/7zQjZ3I11oF7qHwPs7Tzi/XRlsT6escEihwWZsiC0Jmcmcso5V9Dt2DNzTPZRjBoVAa7CoFnIrNz4Iz5A6FO8f7Ohf6x3oqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn/qeeYoJofZEbcWNC/g7gYhpfC2bu4VaIORh72eWrM=;
 b=LG9YjLH987RcAgFGsNua+wQxNFBhDPwfA4IcJeTRLpHIg1/P2W5OK/Q42dphq3u2DjO4gHQHbRCDIxoXtnjev5oqexSzhExhEtMeB8h+fMWUa4eg5lPHjXN+vYsLgdd9TDOFXHgOn/fDxt1/GQrXtdsZUgDQfi4dtIXDeY0DP58=
Received: from BN0PR04CA0165.namprd04.prod.outlook.com (2603:10b6:408:eb::20)
 by CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 04:47:45 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::87) by BN0PR04CA0165.outlook.office365.com
 (2603:10b6:408:eb::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32 via Frontend
 Transport; Tue, 18 Oct 2022 04:47:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 04:47:44 +0000
Received: from mlse-blrlinux-ll.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 23:47:42 -0500
From:   Lijo Lazar <lijo.lazar@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Hawking.Zhang@amd.com>, <Alexander.Deucher@amd.com>,
        <helgaas@kernel.org>, <Guchun.Chen@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Date:   Tue, 18 Oct 2022 10:17:24 +0530
Message-ID: <20221018044724.86179-1-lijo.lazar@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|CH2PR12MB4181:EE_
X-MS-Office365-Filtering-Correlation-Id: e5399d33-d7e9-436b-da9a-08dab0c3e5dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzUg0bMlUIVVMfp+zYZPAm0HQ3NPfIusISa/m8YTbsZKVRQSkQMaWSLn5KR04WznlZeH8/OCJSnGyF8n6yJGVgyMkD29cgQbZqQmHB/DBTYzNlu4gQkxcpQkUJ+p/8hZMkHQ9KCMBAa9908JxfLb+lec+VmqYUs+s14IjmwJw+uaWCMOz8k+Ag0DXConLL7Tsjoo5f4LVMIpZnwcL7qvaCOMeYbLP89Yg8hfd10sKWImuJeIDcGVgDW9/RKFFkUfFVYF9SPu9NEkFoTh8CKmE5Agy3pyxmtMtuXkprXrQhhUUZxItRSCpQ0CFTDAXuL1l4AorjZo68B9Jm/zahWO868P1rLTps9yFRztgIevyIyBrDQB8H0tpA2bNv5P9N9he2lAOCibbxKi5WPUJbrYOWQXTvPwcyj9iIY1vOYt1ptAYrWe99U7ZriaDPhzuUAyaBGqX5A2+GmeyUqhFyeVMEEnOXN+zLy45bWyqxm2tD2Py3KEiFyVX6jgmHo0VStN9/ec4680Pg+dd/7VQo7gTikg7NG/4QXVTJ31JP8VsfNZ3zNQfwTEsvbYByOOD1RI1NLhQJo7ahKpy9R9U0Gybr98vYNRjf/MMCv5Y7x7RGHYoTyefhLKW842yu7sXYGrr54P22AZ8sEZMIrYC05eUm3ECOBDS3a8ENOg9qQ4bTV5sR3Sa24LiOVh2cusoA5lwM2YsiyOKY0gcqOVJnZNfR0FwMqTGM/0ZaLUZ7gQtRPnK0TeC/E7IDPEVmBL7/N//GA0sBHRXkfZYWeAIPszhFBsOxfU7GrYcEDH73XS23CD9kTdxitFqAJMZ1Moa8SP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(36840700001)(46966006)(40470700004)(426003)(47076005)(81166007)(82310400005)(82740400003)(36756003)(356005)(86362001)(40460700003)(40480700001)(70586007)(83380400001)(36860700001)(70206006)(6666004)(19627235002)(316002)(6916009)(54906003)(8676002)(44832011)(336012)(5660300002)(16526019)(1076003)(2906002)(186003)(2616005)(8936002)(7696005)(4326008)(478600001)(26005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 04:47:44.7445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5399d33-d7e9-436b-da9a-08dab0c3e5dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.

Since they are non-existing registers, read access will cause a
'Completer Abort' and gets reported when AER is enabled with the below patch.
Tagging with the patch so that this is backported along with it.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 28 +++++++------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
index 4d304f22889e..5ec6d17fed09 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -32,8 +32,6 @@
 #include "gc/gc_10_1_0_offset.h"
 #include "soc15_common.h"
 
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid                      0x064d
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid_BASE_IDX             0
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid                       0x0070
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid_BASE_IDX              0
 
@@ -574,7 +572,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
 		def1 = data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:
@@ -608,8 +605,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		if (def != data)
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
 		if (def1 != data1)
 			WREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid, data1);
 		break;
@@ -634,8 +629,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
-		break;
+		/* There is no ATCL2 in MMHUB for 2.1.x */
+		return;
 	default:
 		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG);
 		break;
@@ -646,18 +641,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
 	else
 		data &= ~MM_ATC_L2_MISC_CG__MEM_LS_ENABLE_MASK;
 
-	if (def != data) {
-		switch (adev->ip_versions[MMHUB_HWIP][0]) {
-		case IP_VERSION(2, 1, 0):
-		case IP_VERSION(2, 1, 1):
-		case IP_VERSION(2, 1, 2):
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
-			break;
-		default:
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
-			break;
-		}
-	}
+	if (def != data)
+		WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
 }
 
 static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev,
@@ -695,7 +680,10 @@ static void mmhub_v2_0_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
+		/* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
+		 * based on DAGB
+		 */
+		data |= MM_ATC_L2_MISC_CG__ENABLE_MASK;
 		data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:
-- 
2.25.1

