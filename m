Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3E570D03
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 23:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiGKVwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 17:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiGKVwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 17:52:46 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6301880525
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 14:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pdyu7I0Rc815Qv7HUA7jDdQ5maMpSqKt/mPN+UJzETpc09zfGJpVLVxUM4A3xLA+jUkXsYkr+KAaWb2ePzhC+KD2y1mehSR7T4mFzqznI2YkuOjgjmjXf34QxB9AmfuUTKA6hbA9CgSATFPO79yfiFjpZYFT4SlEHOiihq16m8uaikBe/yOLByDIiZtOWTuVTtTlOdXieMvNzd3vxAUkYIAlow+t6XTHqQiBKlF+3a3LGmtziyUm1KlrdX5+Z7ujm1HiPJ4KbNUpR9XaKlI5Lv9qn8Eec7IUH8dkvKNziGon3A/1QEUaikmiFmMVFoHqIf0GAvJV9O3B/crY7tPz3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N74tIzUytXSgLCRsIEolWDzAWjKB65nY4xmob4w1qeA=;
 b=Z2tu06MMk4/B4j/vD0KSodFqHKxxyh13JHgfXCR9960dv9TCgzWp3u9UDqPrs/Bq9VqLgSZiZGz42GUs0BSD7SvIAxZIjKOhcOly3n/6AcRZ1ZMemRqa3F2nUV1P4Edlmq8A4ewiLHbtiUeKDeVwxBycV+wleQz1r4YlcVUCfj5UEXsg20ggkzbsNlAZ+BPrQkoF8FskezpZ+Br8Ot06IYb17aYiPdTj9vo0Ku72GEBkNT3RNi47zpJjXr+cDzjoWyB6e5XsaRtOSz2PUoRgqC58RE0aLSicVDkRqMYVJL+lJnQwk+PlVw97uycmATWUCS9hzJS9wZcpK8oAOX1egA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N74tIzUytXSgLCRsIEolWDzAWjKB65nY4xmob4w1qeA=;
 b=PuUSh5YUDcgTndJoKWE5E3EZGlPZRsSmn44c5sOiJsdxTvNcXmO93GOhRBzFKa43mlzFSWUW+lxVPKw4MzHtRE3gXnOZ/p9R8xjnp+MExHpxUsPdO9cw8j5GQKF+lv4/SnGSRzi/Xw0aVRVOlG1tHU2qVWsZ3daYG+qpujasF9g=
Received: from MW2PR2101CA0036.namprd21.prod.outlook.com (2603:10b6:302:1::49)
 by MW5PR12MB5622.namprd12.prod.outlook.com (2603:10b6:303:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Mon, 11 Jul
 2022 21:52:43 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::5c) by MW2PR2101CA0036.outlook.office365.com
 (2603:10b6:302:1::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.5 via Frontend
 Transport; Mon, 11 Jul 2022 21:52:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Mon, 11 Jul 2022 21:52:43 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 11 Jul
 2022 16:52:42 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 11 Jul
 2022 14:52:41 -0700
Received: from arch-sec.hitronhub.home (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Mon, 11 Jul 2022 16:52:41 -0500
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Qian Fu <Qian.Fu@dell.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: Ignore First MST Sideband Message Return Error
Date:   Mon, 11 Jul 2022 17:52:46 -0400
Message-ID: <20220711215246.88773-1-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a78fcdb-55de-4df1-09e3-08da6387aeee
X-MS-TrafficTypeDiagnostic: MW5PR12MB5622:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0hgGGC4kPh3xFkiD3HnM/8FFZPRjzHRd0nYFMJPNPXSsZ4Pv4uKNmLXux2c62x6ZgpAcV5zGFczb7HtZ57lVHsrzlVj1M7lMNO05EGKT5Ptgf4J1MfrO14W3cPdPr1iYsT8k7mhT+eFWVyc+qseavILT+/Npq7AXdDbKMXqJpM0qmJc+EtwY3kahz1u6WiFsPeWwy5JAQcXOuSerxoLGfgR4+6MY4OMShFvRkbCtK15TPBfQomlbhUte7DoyO+MtZRkQDeIail0K+KBfNmhnq0+w/0qQ1+uF78jw5GBfGzMQKIzYkSDn7P4eArPlg5gI5G3qFUJUNHfQo1TZvHSu1ZXb+jFR9rCJWB20MRvVp1WMctXklcMH29EeLyz6qbfzRVHn4jHO5uCmK5vz00hwbKepwyMrdcxLB4pDKdxwhfzBH9UDFCdMMkE6Eh20AYEDkII1Gvv9DXDwXI6+CfDaCwHHxKARMmqIiTV327dhMADMGZ7ukWgrw6aY+gMMm2Wft3ngdvKcSb5MP+Rs8KTWVALth6+ImeTaS7+DanfQKSv7nbSWXsfeDQd0L24iVfNk/weP0j333LW1NL/A8mrJECuwRLh5bttVZ3NXEpEkty7aR87LerNResJ6apmYVaIJTb7MVvdDXSfnpOmzdZQYnpoyWD1D79y4R5K7VwNjcghhHtpXdqQNdkNc8AKxC/mCqGtfuYUkGfPtaiwE6hn9UwY75+SdAXJ3Cu9ALJl4twc0Xv5528PAI8writ4kDKGodxqx/ODf7KqcCMDMIGsW0UY+p2TzUG/Yotk178oWJPp37kaPiuPCIy9pssG7QD7W4suou5m9ItcH+JqWID/eAsYixNjcyH+pT5bDnMTViog=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(46966006)(40470700004)(86362001)(81166007)(2616005)(8936002)(4326008)(186003)(41300700001)(70206006)(82310400005)(2906002)(316002)(82740400003)(26005)(356005)(8676002)(6916009)(15650500001)(1076003)(36756003)(40460700003)(70586007)(336012)(83380400001)(5660300002)(54906003)(36860700001)(47076005)(426003)(40480700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 21:52:43.1042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a78fcdb-55de-4df1-09e3-08da6387aeee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5622
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

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Qian Fu <Qian.Fu@dell.com>
Cc: stable@vger.kernel.org
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 27 +++++++++++++++++++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 ++++++
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 ++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index de1c139ae279..e0af3d003b5c 100644
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
@@ -1528,6 +1552,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
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

