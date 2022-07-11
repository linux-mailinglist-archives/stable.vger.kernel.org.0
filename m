Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4459D570D33
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 00:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiGKWK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 18:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGKWK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 18:10:57 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C813EA7
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 15:10:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feQujnfYTGioOawlD9CIZx9w/odzIAqrLaF8kKtHXQp1TC512mhobyBcT87BAqlcDI2QTYE0xnKrvYhQ9C6dsjkk9LjRzo4Tkz0v1u7MTet+Q2ev/s//HHGCbZPw5zPIDFAuXgn/EifhiCrjBoMbwu7SEEB8wZeeRa75ib7/TumNXcKxPiCs/uwEXTEdzwFedkYyaFXcw7zoXfNKPMSk6C1PkeHnkvfp67MKQdlIgv9+pW58f33kUu5NyYl0My9W62wkMkhDQllAKMgRLy7wU34CTa2dgwvTb0w44/GVBp2rQyFnahEepHYwMsQrRytDxxcL0lz/YT+ugDQujOu1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrV/xy9PoUIRxLE/oLoyDLeQyVlYFGCyY6x6kLBMyZs=;
 b=J6V261yi9QuW+5g6wWELrI+u7QkJ6BIx1T7szrK1fcC6k21XnPZjSySu9taMVpJGcW1N07SarnC0lUnWU76Jjv490FerN686Zhoqp/k7XTJdL6zHxIwOgWS1EKu3OmQ+e1dUd0JPF5czJ9PymEz2YUIMKoJjslyRc5w5KQoW/zxevU5NbjlXWWYsTxImOpOSQGZ4K4jCfyFZUZVRh9gwtUdR7/eoP7nFnja0d+Wti0LWQOOqIDNpoBQaIxs31c91+KFwsWCZrwj0Jphf8Z47mS9uHXTkjyP9/V++CR4TGWYKDmI+xtXU4ICmOMogVHqmIU5zT6o7HvJEeoAhZ5t2RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrV/xy9PoUIRxLE/oLoyDLeQyVlYFGCyY6x6kLBMyZs=;
 b=z60GMAa1/25O5m9xrQ2YuvSrWw7cDI9ZJcQxxXj9Hbn3HAyHFwR3cAjG2g5R4NtnAJdKu2VloLcCFWVFiIvTlCqPr3C1koJ14KX51ALu0MrB4Uu1RIks8zUJTn8fu5ZLTEL6Bg+4z5Bjgv/JR/xeNAKds7LKo7ImMn4d82skiz0=
Received: from MW2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:907::18) by
 BN6PR12MB1123.namprd12.prod.outlook.com (2603:10b6:404:1b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Mon, 11 Jul 2022 22:10:53 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::bf) by MW2PR16CA0005.outlook.office365.com
 (2603:10b6:907::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Mon, 11 Jul 2022 22:10:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Mon, 11 Jul 2022 22:10:53 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 11 Jul
 2022 17:10:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 11 Jul
 2022 17:10:51 -0500
Received: from arch-sec.hitronhub.home (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Mon, 11 Jul 2022 17:10:51 -0500
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Qian Fu <Qian.Fu@dell.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] drm/amd/display: Ignore First MST Sideband Message Return Error
Date:   Mon, 11 Jul 2022 18:10:51 -0400
Message-ID: <20220711221051.89665-1-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba8efa83-951a-4886-8e46-08da638a38a1
X-MS-TrafficTypeDiagnostic: BN6PR12MB1123:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0oi45pHNoe5FoIzI9aR0osMC+BCnqGPJCf1QwDjXSbHj89eyy880wqH/R+WhQadnXj4kmOnQHnQMiI/QXQoaXTcJVi2CGzFx4+NQ9ESblcjseBpJntuZpMO/UmElunpQ6oaVAV/vhqWnzHuiXEMtnt6KXevaasJA4onbR9BAOKHCgdMr16+LtcgceSf36EkXR4mbThDWYNuNQa8tZv0kPA2Pr52YVRybO9UsAsUngSCO+XE1NvOyCOcep4n0YYIAA7oCPthp9rE4T0kv9Qm/pap3fzSkGFsnpavYvs/s8CojPN618OiEFFkWqoIyzTpDkOzhmMuBW0O2aYob1OKz9dO/JR5BSo/A4P40+c3zJ9gaTViIRwoQKARmqE+vnPmFb0GwO7Gqyh3tYefdVJBLaeXpsIeDUsrXdMqOnjPoiAcTfGh7nEgtnbZDuovuIZskuB0hRMYrFqhosH3CjABe1JcSC2E+QFintoP+vSgVpNi8L31WiectzKUEUIwH0hClDl/5UN6UGXmx3R6/C4bZLZu1J90wk+ntpjNAir6nWHQgIf5NFHN41cGUvq8Rh/VPUfIhOEaykY8FuBQ26XKwAvc2dgnJiJU/nPuZx9npBkXfBaoFt/9XzWWa4DBeIJlY47oRE0VGwesMW7/DYGQLhhb1Vt0sLT/kLeQaPeyHwbFn9XAyIGsM/ndMTN68k0oiFPgvK5/JIu5m0uTFGqKB6Lf1kJvdqsS5sD8FwMfb+gZmtYUkh8aZmf4rUKlXxRar9l8gHHk88PLMihnm6al6iByr12YbGYvxJrr6h3ZfiTy3JCKGwkQLDKPF/Gjagc8Yqu74x4DTQkvdjZuwBtFd3kSRI9dWEHRhLsDvkq99V4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(40470700004)(46966006)(186003)(47076005)(8676002)(40480700001)(426003)(4326008)(336012)(70586007)(54906003)(6916009)(70206006)(83380400001)(36756003)(26005)(2616005)(1076003)(82740400003)(81166007)(86362001)(82310400005)(36860700001)(40460700003)(2906002)(15650500001)(5660300002)(316002)(478600001)(41300700001)(8936002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 22:10:53.1220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba8efa83-951a-4886-8e46-08da638a38a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1123
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
The first MST sideband message returns AUX_RET_ERROR_HPD_DISCON on
a certain Intel platform. Aux transaction is considered a failure if HPD
unexpectedly pulled low. The actual aux transaction success in such
case, hence do not return an error. Several Dell Intel-based Precision
systems had this issue, for example, Precision 3260 and 3460.

[how]
Not returning error when AUX_RET_ERROR_HPD_DISCON detected
on the first sideband message.

Changes since v1:
* Add two missing products

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Qian Fu <Qian.Fu@dell.com>
Cc: stable@vger.kernel.org
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 29 +++++++++++++++++++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 +++++
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 +++++++++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index de1c139ae279..3c7f6920f71f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -72,6 +72,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_uapi.h>
@@ -1400,6 +1401,31 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
 	return false;
 }
 
+static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
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
@@ -1528,6 +1554,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	init_data.flags.enable_mipi_converter_optimization = true;
 
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
2.37.0

