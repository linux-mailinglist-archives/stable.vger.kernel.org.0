Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8B1571FBE
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiGLPnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiGLPnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:43:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B57FC4448
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 08:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2nvVfPoyAkhAyNci/FboW4xsCiBVK30NW8YNNRZIJ0WEm1c2FJw/f/W7WJbaM6qwv1nn+B6tC3KMsOVBHBMIAFqH0lw4yLZjjvZt/R9Jjc3Tjw8uGGph0sZmZlkSvsRjU745+qIk1IsXpzrUjhEXiVXkYKPQgRRWerTDDAy1dyqGxxVvi5iYL0G//gJoLYFM3L2S64v91FDrIPi9lhHRPjsXbE7hIxr7+fzV4TXwV7tKsjj/9uecLVDHiHz7vGGSCXhvYeTSIOkreaJKaYJguY/4wKMGhdyC6fcLmauWKv4EzBkcy5t5igXjUL/gAQpraU6XGu2gWGof5z4iy9B5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm1u/9xz8/JoVyMH6Wz0B+NelSLj4f3fVooK8FmsOs0=;
 b=XGwchA4u66fFQtVSez88JS2LZ16AF8ALcGk2l8ZBXeSc+pms5k+EFllhaj/mpz0IPZhLwVaA4Tyq5PFJvCTWsM27WXW8Li/bo4UJHVow8nki4a8gvyv+VVTe8y0Z3VH9p8C7xxPazttrxWsSBIr/pxf0ybgto8tj4YWXnXjkhcsVqvpaFO1MrAdG9zcTrMh9dp+tOImwQzmk+s/v66pknVEmkYtwjJaMRKh3L+BzkgK/WLjtuZnMB6P7Rb7ikTO0E0Y2K+9o2jcEDUQKJkxkt9FO4annQbvWxVhH0CC+TL+eje9dpPklE5GnsdWbRJi/J7cHOGu2dtP7H6CLSFL5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm1u/9xz8/JoVyMH6Wz0B+NelSLj4f3fVooK8FmsOs0=;
 b=v1L5ZNIqxoxPVPkRlRiro8oUrTMeRPb+bqAcd1jfOs25/fgMx2Ein/VkBHxtC/G8QI3cLJpdQD5SMUgZx6IaOleHs7DYxNAriLiLyfI3DeA/MBWVgOAg5/Y/vbtyIMUwYs7x8UzLfbY1i15IQ0L8lm29DtvU+hL08bQmAJNa4nM=
Received: from BN9PR03CA0670.namprd03.prod.outlook.com (2603:10b6:408:10e::15)
 by CY4PR12MB1702.namprd12.prod.outlook.com (2603:10b6:903:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 15:42:55 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::66) by BN9PR03CA0670.outlook.office365.com
 (2603:10b6:408:10e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15 via Frontend
 Transport; Tue, 12 Jul 2022 15:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 15:42:54 +0000
Received: from ryzen32.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 12 Jul
 2022 10:42:49 -0500
From:   Solomon Chiu <solomon.chiu@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        <stable@vger.kernel.org>, Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 21/21] drm/amd/display: Ignore First MST Sideband Message Return Error
Date:   Tue, 12 Jul 2022 23:42:32 +0800
Message-ID: <20220712154232.501735-1-solomon.chiu@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708163529.3534276-1-solomon.chiu@amd.com>
References: <20220708163529.3534276-1-solomon.chiu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e5a38fe-45c3-46d5-8c27-08da641d3016
X-MS-TrafficTypeDiagnostic: CY4PR12MB1702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +39bJNaTUBC81TpsF25+BD12uoRcs89aNalA9WvULQWNkEsagEZcHAcBHveLS6vxy+/NAgMwOdjJzNhdAzgmJ5RerOvn2+5VsCGtaQJ1x8cj7LHhpb8EPjCHNXlHdQWH/IjZb3XpvM5VlJ2b/kl3ea81fbz/aJYkfebUsnh4JTdNZhtplPHkF7bdxHT6lD0O0aSS6IEKAioVtqPuce3EWPoVwXKdaNoHUqKj8p84zmfUbqIFYL10TfjzLNE0cwmQTbTmAROw9RFULmrNGDdR78EW4rNPn4+x67R0o3osV6a1zm2mPMfIx0RYJBr37L6jsrXihj7Cm3tP0jesllfMRKKwm9B92yEenLIJMEnM+BRFXAI1roiCbtMxFSN5K0NATqzdlokD04b7Mi4LMrP2oP5uKngE0PJ7oNPSiNRRDqEaqQmEnjocsbFYHL0huNrVdNzAW6zA8V9+RD2Kaeju/CdPCyfmhoHus6hIu+ve9cRDCRB+Dh/ZuM05OLMbfgXyeq8yHUJbxpmLBycIb1gf6X4Mk7pS0De8CPkcFRak3LmOJMzNya8R9EhhvszRHxZTEKDHDYSjXKuuPx93vjfozTQZW/SbHMWxqXFPnNnoFgVSI2wB6qBPXtvyUkc/ZEOLYJ8vGBJR9EJQu4bvMrfg4TemrV6jlruqCHubYtjqVAFrVat+D+DJtTOshcQw+S65HR3Wv75mIMvZdjFpqwOL35UbdbYoMksYcaLl2Nd6o/tadNGtykrVtTimAxq2kjWVcGdIN3A20LqHEJCU7lMtPtHAshwpoJ4Xssazdhls8pCMw0wtHk4KAS2Ow7dZiucrCaR985SiYSf19xZzjKj1vq2jb7GDiNOm+fcmeY2cGOc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(36840700001)(40470700004)(16526019)(15650500001)(82740400003)(54906003)(186003)(47076005)(40480700001)(81166007)(36756003)(6916009)(70206006)(70586007)(83380400001)(356005)(8676002)(316002)(426003)(36860700001)(4326008)(336012)(2906002)(41300700001)(40460700003)(6666004)(478600001)(26005)(2616005)(44832011)(8936002)(82310400005)(5660300002)(7696005)(1076003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 15:42:54.9178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5a38fe-45c3-46d5-8c27-08da641d3016
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[why]
First MST sideband message returns AUX_RET_ERROR_HPD_DISCON
on certain intel platform. Aux transaction considered failure
if HPD unexpected pulled low. The actual aux transaction success
in such case, hence do not return error.

[how]
Not returning error when AUX_RET_ERROR_HPD_DISCON detected
on the first sideband message.

Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 27 +++++++++++++++++++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 ++++++
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 ++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 476fe60f4b7d..e203d75834de 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -72,6 +72,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_uapi.h>
@@ -1400,6 +1401,29 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
 	return false;
 }
 
+static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
+		},
+	},
+	{}
+};
+
+void retrieve_dmi_info(struct amdgpu_display_manager *dm)
+{
+	const struct dmi_system_id *dmi_id;
+
+	dm->aux_hpd_discon_quirk = false;
+
+	dmi_id = dmi_first_match(hpd_disconnect_quirk_table);
+	if (dmi_id) {
+		dm->aux_hpd_discon_quirk = true;
+		DRM_INFO("aux_hpd_discon_quirk attached\n");
+	}
+}
+
 static int amdgpu_dm_init(struct amdgpu_device *adev)
 {
 	struct dc_init_data init_data;
@@ -1531,6 +1555,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	init_data.nbio_reg_offsets = adev->reg_offset[NBIO_HWIP][0];
 
 	INIT_LIST_HEAD(&adev->dm.da_list);
+
+	retrieve_dmi_info(&adev->dm);
+
 	/* Display Core create. */
 	adev->dm.dc = dc_create(&init_data);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index e04e6b3f609f..33d66d4897dc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -547,6 +547,14 @@ struct amdgpu_display_manager {
 	 * last successfully applied backlight values.
 	 */
 	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
+
+	/**
+	 * @aux_hpd_discon_quirk:
+	 *
+	 * quirk for hpd discon while aux is on-going.
+	 * occurred on certain intel platform
+	 */
+	bool aux_hpd_discon_quirk;
 };
 
 enum dsc_clock_force_state {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 8237029cedf5..168d5676b657 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -56,6 +56,8 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	ssize_t result = 0;
 	struct aux_payload payload;
 	enum aux_return_code_type operation_result;
+	struct amdgpu_device *adev;
+	struct ddc_service *ddc;
 
 	if (WARN_ON(msg->size > 16))
 		return -E2BIG;
@@ -74,6 +76,21 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
+	/*
+	 * w/a on certain intel platform where hpd is unexpected to pull low during
+	 * 1st sideband message transaction by return AUX_RET_ERROR_HPD_DISCON
+	 * aux transaction is succuess in such case, therefore bypass the error
+	 */
+	ddc = TO_DM_AUX(aux)->ddc_service;
+	adev = ddc->ctx->driver_context;
+	if (adev->dm.aux_hpd_discon_quirk) {
+		if (msg->address == DP_SIDEBAND_MSG_DOWN_REQ_BASE &&
+			operation_result == AUX_RET_ERROR_HPD_DISCON) {
+			result = 0;
+			operation_result = AUX_RET_SUCCESS;
+		}
+	}
+
 	if (payload.write && result >= 0)
 		result = msg->size;
 
-- 
2.25.1

