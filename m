Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09456023F6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiJRFmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJRFmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:42:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A805CA3AB2
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 22:42:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeI1fmvP0DjRTZznaNs6ukGVqU1PeYU4nsrTg00YZibhYh8ZhFnQfqdZOVYbyNaxCZ+aswvprg4b/Fnvnc9iD3znjNcXbgq6EtdKWvwa5uSRkc7ci3VyDpje7AAiifyRNrSXcR9bFkr9gK6Ii3QABWGytMyKx2quZMQvwGg42k9cOmjgs3R/3dJ+UI20PKgK5OJLqWjiUoIri0vRDEq28mB1g2MPLdrP2dhCXfVCENkUsTOnmWzI3UUf6miAvpyADTAJECKuNhF7E7n/jLWMnAMjwSWa5dqBdCuLAGjeWmQChdR8fjqJKQow4VU4/ccRxZoNVfoElWuN1nFsoSPpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQfe8o8jCGR0bHIG/P2iGRHOQoy5+kA69J09u684NFI=;
 b=gC4NXph3133E3Ko7XIpNWmmhkveMnRTkqG1qcfxROhsY2WxIsbGo5d7BsBn4sdtJ8YyQboICGZINn0Vs9Tkxpsk/a5/K3dO6TpluiaAzoJc3pLNY6DG9drTKLfhbuTO4mXQgWVYZJd4HAjBlbX8YWo/5aY2VpYVzrdAeh38b+cjptE/lxEk+odaGDYt/MpvDVigrUvLb6p95CSNt79NqjKfKFM5PAjXfJ/tZeJtl6gYdJPdU1tz5+ZgCFLzC2YHsm3gRx0FyLASJmh7tpF2weZMa8RjtHkX9bucDC6YuHWpoDi8Um7BaltDJ3juTujZgybyQeyt1G7GnQ/VuGrBNlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQfe8o8jCGR0bHIG/P2iGRHOQoy5+kA69J09u684NFI=;
 b=fDPNEA5SCJ+v1EE5qaX6YLhRFN6SlxcxE1DC205rK9sYuUMUd23d5Qe1NyJBY2OJniGVEnUrJXsQ3dkU6m7rLJd9y+wOVoOBXQsPTGZN60V6OrjcRIWlQUUIsWWTCnFgihYwxB+W3mOVGvXCrhkoX7wmLrpEvIKTx0ohXns9bJw=
Received: from BN9P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::9)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 05:41:55 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::6) by BN9P221CA0002.outlook.office365.com
 (2603:10b6:408:10a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31 via Frontend
 Transport; Tue, 18 Oct 2022 05:41:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 05:41:55 +0000
Received: from mlse-blrlinux-ll.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 00:41:06 -0500
From:   Lijo Lazar <lijo.lazar@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Hawking.Zhang@amd.com>, <Alexander.Deucher@amd.com>,
        <Guchun.Chen@amd.com>, <helgaas@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Date:   Tue, 18 Oct 2022 11:10:50 +0530
Message-ID: <20221018054050.86703-1-lijo.lazar@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cee8283-1392-4df6-d753-08dab0cb7777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oKuoRF1xvSRdTMkuCkityHHpK1SfD4KuD2/7atNN6U3ZejDulF/Ks/x/AhCLFxhvSNQ4iXeqP7xTNw3d2o/yBNjqBVtYYL1JM1ck5q4LZ50w0DwZ/bHsj3p7npxTOnxmCRn7/31ifJKZt2AWc4M5PYXG6KGJ45lv7cIQNQ+yTUAjYFvjs1XhvuDtNF/+Y5GPWId1fx4YrzHFkd1iCd2xSDVry6YwlvjRJKgVv0OWHbW7Jd80FZGq7W+JQ5cvWeLB+T8psMGosZoVXVHh0vV7OidogFoGOK1Ooe623KwWXAWTHd6BfueFRc5e8LVvtUpVkdQq1mEom9oa1RDl9lAyqHQjRQQv22oVJWtBddBjyjnHCSf5hy2/rHF+3fr3rD5duMTvoRMKCoNHfUvdJAb4xy56ZCHdBW8/QUbFOM+hrmRFX15Qvkf/lJPSHPpTGmVYk+e+LUijfYVTfJuv6wx0sFNs/QfUNRB+s1zt2bsUGk0gsej4eCgTynxXHO5Z71uFYOjCMCWCY8U0l5ekhZsuDfPsPKqn8lp5Qg95WUTQ36bE5kqEOcDwXieZgFq14KnO/QYaR6Gri7nfOz+8XbUO9xuhQme0Ik3EW4CcpBy/r6fWveJ3J/qrBEQw5S4ImrUW0XrWZASKjgbX0wN0MgpiF0TNfQkgIJdmD+WB4bBH2yLBW6B7mUrUYGZHclOvLwkHyB7iWc4TTmlRj6Xv3qnfRda9WKdC+JfWGsEP/3AjUiWjXQw6XZnVSL71XqUdIYqu8FzWbWStDWk7h7jcdO7MSTULaHL+7cXm6ibcnAWeXHEsVwgfwbdPzTdeK8SR9lxv
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36840700001)(40470700004)(46966006)(6916009)(1076003)(2616005)(186003)(16526019)(47076005)(426003)(26005)(83380400001)(356005)(81166007)(86362001)(36860700001)(336012)(5660300002)(2906002)(82740400003)(44832011)(8936002)(4326008)(82310400005)(41300700001)(40480700001)(8676002)(40460700003)(6666004)(478600001)(7696005)(19627235002)(316002)(70586007)(70206006)(54906003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 05:41:55.3820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cee8283-1392-4df6-d753-08dab0cb7777
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154
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
Cc: stable@vger.kernel.org
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

