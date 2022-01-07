Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A680487AAD
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 17:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiAGQsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 11:48:22 -0500
Received: from mail-sn1anam02on2073.outbound.protection.outlook.com ([40.107.96.73]:14439
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229483AbiAGQsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jan 2022 11:48:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQhK+ZcGctRSo7e1EItJ0sulkIbIfSPkCOGLsDF1L9EM03xJ/evRlxbiEWjCh8tbh49IY28hSMN2YaLPUndqm3PlDKtFEy04yJyLO3KETlPPViCxj2up3hJ4EngP/YP4v0+0kYprdc/qose8iGFLy+psrizd21CC/SreF9Ayg/7VkK9JdltC6/00vFD/JSBPmZzA7V8uwksxbcMkvVTahHsdck61qHNZz1ssjxwBEYvsrqfGNMUJzM2C/YwWoHcFbT0fh7jzBn4FBr78t8+QRXRkjq9TF+3S4sqGMmdjjrxhT4WvnNVHYOJcYYhoUC5XffDFx7OHtJXZUKZG6MFqig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91xx5VgODqOygqZB5jE5ke09j1ZyKUJkSPLpTxjuzdY=;
 b=oIITI3ZWIDja7M8XwHOJSmnPjIu7847TXiG1eMezdoLEV7UToHULOzMFO2B0JYWWa2EG7xLqjhOBwUqSRs+V8b+wiB7mIliqDPI4uufLzpglQX/Ee5UVOpOjN6qtXhTzL3NcvoY2j95fQwRJxe5WJ+XjscseOKGBcuexyBO07aIEy33fWxEoQpQNa+kK2eeXPYYfXebJs0BZpGvnX9Elh1Q1JPUbzespPpKZUAE5aIOtBKpFsK+J9g00HYp+ChgbHfEA4/RPpqPWU12fsK9cPxMgK+HXP+FO9IhzX8d6ITUapr++/randxiQzh+vPlP47wkYuzfwDoC0Ifhyh6JnGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91xx5VgODqOygqZB5jE5ke09j1ZyKUJkSPLpTxjuzdY=;
 b=jSyjIo2YnrxJlyttB49OkJNq0lnLGDcoVVcTrt940SwWpb9nLIPuBb4dKytb0/IAEWhe6EbQ6c8sJ19EydpfEKtaiyBPz2g1vpIWk5s+EYtBmFF+NdIUuGasnSDLpINKYC4S11e1T/iVxi8y5lSb1V+5PjBQSjC7ezlEixaPA6c=
Received: from BN0PR04CA0147.namprd04.prod.outlook.com (2603:10b6:408:ed::32)
 by BYAPR12MB3525.namprd12.prod.outlook.com (2603:10b6:a03:13b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Fri, 7 Jan
 2022 16:48:18 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::38) by BN0PR04CA0147.outlook.office365.com
 (2603:10b6:408:ed::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Fri, 7 Jan 2022 16:48:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Fri, 7 Jan 2022 16:48:18 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 10:48:17 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 08:48:17 -0800
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 7 Jan 2022 10:48:16 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Harry Wentland <harry.wentland@amd.com>, <stable@vger.kernel.org>,
        "Huang Rui" <ray.huang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v2] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Date:   Fri, 7 Jan 2022 11:48:14 -0500
Message-ID: <20220107164814.7161-1-harry.wentland@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fd599bb-97a1-41ca-8966-08d9d1fd81a3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3525:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3525F1BB2AECDDBA8F7A3B328C4D9@BYAPR12MB3525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9n9ONXfNWhHH6WA1Jp0SPOOb71Yy8n+E4RZqMYtmuRdbiG+wb6BUU8DFU/7EsqYiyIAt5UgmM51CiDKHGNAG2aAo0wOouOsY6tG03Q7rf5/ZvupntVa2Uiixo7JDEGPhlE9Ifd9jX/eBsenrqD2lkY8zD5ddFQ00hHr7F8peNGddziuOqMWZHWyo8irQwPqeMbNb7TxKixhoA5MtmFM+nonMMzvCm121Fdx3FSXT/taU3CMiFm6q+a7XGEG0FYxVKjEaYtsoLe1PwjJfv1/Hnfkgkbv4inkssdu8BprR5LvW7DB73Ui+pB4x25YNO4Sw9CDWtu7KqRhKVWl2C0Yp31zLTPm3UTR38T0wa1dep2yx+EC7MRKugjwY3xncuqgyfgz7jZtHhxafB6HetrCQU9ikBH0gpO9XAi7H7HnqXIR4Hb1sjyrSWXDHVe7+x4B1xdsyyMaZapf2HCRrFeXHol8sGs4Fq/YWt5ccKHmNXJmNqFwMgtchVR0W7oQFx/0gmkNOL/eN0xBYVBH35/ctqnChMeo4YXx/twvK3LzTA/M0kPzwzEYXGkvexjy+F1uMFEwzlMLA0lkJW9Baubz4x9PJYekl0NLwkG60QelFyvm8bQs+LGYxwQX9FcHnoojMeVK6eFe4XzEY6l1U1ySdxBKUgUWx+3f7B/5d7fqD/dkA1aBwYDBnEsiZMR4mnP7t5hiw2G875dR1qghjcGkU+pDIFIslA24A5/bVq2mifXBOWeZV2d51F/PWrmqU4H0Nkwly5ItzofpY6bv6sNh2MPBzQ282PIabW3WzBQRwdTw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(81166007)(40460700001)(44832011)(2616005)(186003)(86362001)(2906002)(6916009)(82310400004)(36860700001)(54906003)(36756003)(508600001)(7696005)(83380400001)(8936002)(316002)(70206006)(5660300002)(336012)(8676002)(66574015)(26005)(426003)(70586007)(356005)(1076003)(4326008)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 16:48:18.1076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd599bb-97a1-41ca-8966-08d9d1fd81a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3525
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

Cc: stable@vger.kernel.org
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 57f2729a7bd0..c1a22a8a4c85 100644
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
@@ -1134,6 +1137,8 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 	u32 d1vga_control = RREG32_SOC15(DCE, 0, mmD1VGA_CONTROL);
 	unsigned size;
 
+	/* TODO move to DC so GMC doesn't need to hard-code DCN registers */
+
 	if (REG_GET_FIELD(d1vga_control, D1VGA_CONTROL, D1VGA_MODE_ENABLE)) {
 		size = AMDGPU_VBIOS_VGA_ALLOCATION;
 	} else {
@@ -1142,7 +1147,6 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 		switch (adev->ip_versions[DCE_HWIP][0]) {
 		case IP_VERSION(1, 0, 0):
 		case IP_VERSION(1, 0, 1):
-		case IP_VERSION(2, 1, 0):
 			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION);
 			size = (REG_GET_FIELD(viewport,
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
@@ -1150,6 +1154,14 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct amdgpu_device *adev)
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
 				4);
 			break;
+		case IP_VERSION(2, 1, 0):
+			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2);
+			size = (REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
+				REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
+				4);
+			break;
 		default:
 			viewport = RREG32_SOC15(DCE, 0, mmSCL0_VIEWPORT_SIZE);
 			size = (REG_GET_FIELD(viewport, SCL0_VIEWPORT_SIZE, VIEWPORT_HEIGHT) *
-- 
2.34.1

