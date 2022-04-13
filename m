Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7B4FFA54
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiDMPgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiDMPgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:36:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FE6393DE
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:34:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAKfIjpRqMA7QPMDM/9X7kdPhE/GhBYFpKXTiRbm4xguJaskSiBcWPkNeSVmvWbWlqSW1K8khmk4tts+SqxKFuyQCLz4zy5M75kV/XijzBnOSxFknsoCi9j3XAn6Zs0+qMIaPDL7VVVtKGd3HG98pksOpsSNAPpI2MkVDvq3B1uOl69HxPzdn7IFjAgRpHSRb8mOzycfNkexzwMQnFqU99hFQW0YhV0eoLp4cBaggviZPBDCrTaGR/TzpyLGBUrPrJkUCATMqZABPwY6sTY1iNMd0wxwmjV+AvdmqxNhGuc88cEonIKn5W7EFTCFIcUeiDVJm3TgMqdOrHtz6wal6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9+9nf8NueFXehXU8nNJlWrQtk4MpXO7LJ3h+8KwvBM=;
 b=CfLTSfABlFwFz9VPhycRpUgpOxgVoiQ18TQf/fI7FbI0GT6LdI12AQayQlg4R5R4iUsSuq3eDoPjU3OsVhVtis/DMxMiBh0tSHd3c1E9aae8om1JuhKp3oUB+Eb0mCNJFnv3Hm94rCgiL556vkdgoSNMlK7ai7NblnMLpB/BGAcA6pykQAyR9+F1H1qIoViLa3ZLdXvMCeKECh9a3NaLwaMffHnpuSv0gZ+LD3yw3WYX9Wqqvf+6O/wRYNy8sK4gUFb3ywh41tMqGa0gt8cjVF45fAOWFMc5QocvgDjjudc4hXRrVpSy99Coy26NYXKgnjJSdnOpsD6KB1MPLavUjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9+9nf8NueFXehXU8nNJlWrQtk4MpXO7LJ3h+8KwvBM=;
 b=XGPiUJDivUOJFU6vBCZfdlxMAhT+mE/Zx9Qc31xdYD1Mjxz21V2dVwKrmxMGf/tm5mnjacvlFqiJzn4NGeKFaJVj9Mlljmzy2DXVuZQmN/eYrX6NjohdMxQjZBwKenZB10lUP+9blSo4hBnrcACQj5t1Yd4AJSdbqV7nIw+fAqg=
Received: from DM5PR07CA0049.namprd07.prod.outlook.com (2603:10b6:4:ad::14) by
 BL1PR12MB5755.namprd12.prod.outlook.com (2603:10b6:208:392::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 15:33:59 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::c0) by DM5PR07CA0049.outlook.office365.com
 (2603:10b6:4:ad::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 15:33:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 15:33:58 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 10:33:57 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        <richard.gong@amd.com>
Subject: [PATCH 1/2] drm/amd/display: Add pstate verification and recovery for DCN31
Date:   Wed, 13 Apr 2022 11:33:38 -0400
Message-ID: <20220413153339.1436168-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37afb1e3-b0cc-469e-3249-08da1d630751
X-MS-TrafficTypeDiagnostic: BL1PR12MB5755:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB57553C94FAB864926FCBB00BF7EC9@BL1PR12MB5755.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwKEYbq68v53vsUKgkDuUnJcJFknGmF7zF3bOmwaIKt8OZXXxJiXaivoK0NGb4B6hSsqQafo9X5KcKK3lm7j3j8ywP/oeR9GtYmWmRHcFRf7MydNOn8WGSxlVO506VrtV8SY6HYiMZNuHDSGKbP9ED/s9pa2TnWNhJ3xmyIYGH9gbZnuEThoo2dQ5g8PzGKpBc2ywYo9xcEsMoJinQC2JOwthlDN1XKdAX6lWFaNaPsLAGtl2D0I7pftR//8dbS0z7Hz5W0qJZ55XfKhmpN/Qg2S88v+Z+Oj2oCbq4cNKlsskkCLvHcQUsh2Haj1uNKE0Z0tGQ17rXj6oR7U3jDHlt76Qbe+XtNgWtuqW6HH5FNwrbiFjfbfFmnYR6Djh5PSp4ir5/v+oBp+IWflu8qY3dPFRZINgY8WhUIYxWDZUErfgzcjQhJuWc2KKJZtPyQGFI0oIUYe9n6RGtQtFkWqF+MgUReGzpaOxvgPyM4kEwMJrYtlWC2Mo2BNTY/bBS9YIflWLUG5sDBD9mEMpErK1ZQ+SvZAWZstKzZkbGgdoM84oafrHtZQSISL6PKQbXG2vGHP7612/IwZ4PYVFHYrT5lP2Kwrr/W6ZHNyENuQ6ZUGnBEhF3vOrxxyeTU4uwhG1eHL4iVoLJjv32yb3BwUL1eJNZkVq5uTjZnKlq/+RwfzNjQmR35qY8XD4KZBkYIz45U/H3vQPFb4B1ZnBnoN2Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7696005)(6666004)(15650500001)(356005)(2906002)(316002)(81166007)(54906003)(26005)(336012)(426003)(36756003)(6916009)(47076005)(82310400005)(5660300002)(4326008)(83380400001)(8936002)(186003)(70586007)(16526019)(8676002)(70206006)(2616005)(1076003)(40460700003)(36860700001)(86362001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:33:58.6982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37afb1e3-b0cc-469e-3249-08da1d630751
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5755
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[Why]
To debug when p-state is being blocked and avoid PMFW hangs when
it does occur.

[How]
Re-use the DCN10 hardware sequencer by adding a new interface for
verifying p-state high on the hubbub. The interface is mostly the
same as the DCN10 interface, but the bit definitions have changed for
the debug bus.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e7031d8258f1b4d6d50e5e5b5d92ba16f66eb8b4)
Cc: richard.gong@amd.com
Cc: nicholas.kazlauskas@amd.com
Cc: stable@vger.kernel.org # 3.15.x
---
 .../drm/amd/display/dc/dcn10/dcn10_hubbub.c   |  1 +
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 10 +++-
 .../drm/amd/display/dc/dcn30/dcn30_hubbub.c   |  1 +
 .../drm/amd/display/dc/dcn301/dcn301_hubbub.c |  1 +
 .../drm/amd/display/dc/dcn31/dcn31_hubbub.c   | 60 +++++++++++++++++++
 .../drm/amd/display/dc/dcn31/dcn31_resource.c |  2 +-
 .../gpu/drm/amd/display/dc/inc/hw/dchubbub.h  |  2 +
 7 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
index f4f423d0b8c3..80595d7f060c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
@@ -940,6 +940,7 @@ static const struct hubbub_funcs hubbub1_funcs = {
 	.program_watermarks = hubbub1_program_watermarks,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 };
 
 void hubbub1_construct(struct hubbub *hubbub,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 530a72e3eefe..0bd598a1d704 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1112,9 +1112,13 @@ static bool dcn10_hw_wa_force_recovery(struct dc *dc)
 
 void dcn10_verify_allow_pstate_change_high(struct dc *dc)
 {
+	struct hubbub *hubbub = dc->res_pool->hubbub;
 	static bool should_log_hw_state; /* prevent hw state log by default */
 
-	if (!hubbub1_verify_allow_pstate_change_high(dc->res_pool->hubbub)) {
+	if (!hubbub->funcs->verify_allow_pstate_change_high)
+		return;
+
+	if (!hubbub->funcs->verify_allow_pstate_change_high(hubbub)) {
 		int i = 0;
 
 		if (should_log_hw_state)
@@ -1123,8 +1127,8 @@ void dcn10_verify_allow_pstate_change_high(struct dc *dc)
 		TRACE_DC_PIPE_STATE(pipe_ctx, i, MAX_PIPES);
 		BREAK_TO_DEBUGGER();
 		if (dcn10_hw_wa_force_recovery(dc)) {
-		/*check again*/
-			if (!hubbub1_verify_allow_pstate_change_high(dc->res_pool->hubbub))
+			/*check again*/
+			if (!hubbub->funcs->verify_allow_pstate_change_high(hubbub))
 				BREAK_TO_DEBUGGER();
 		}
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
index f4414de96acc..152c9c5733f1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
@@ -448,6 +448,7 @@ static const struct hubbub_funcs hubbub30_funcs = {
 	.program_watermarks = hubbub3_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 	.force_wm_propagate_to_pipes = hubbub3_force_wm_propagate_to_pipes,
 	.force_pstate_change_control = hubbub3_force_pstate_change_control,
 	.init_watermarks = hubbub3_init_watermarks,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
index 1e3bd2e9cdcc..a046664e2031 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
@@ -60,6 +60,7 @@ static const struct hubbub_funcs hubbub301_funcs = {
 	.program_watermarks = hubbub3_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 	.force_wm_propagate_to_pipes = hubbub3_force_wm_propagate_to_pipes,
 	.force_pstate_change_control = hubbub3_force_pstate_change_control,
 	.hubbub_read_state = hubbub2_read_state,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
index 5e3bcaf12cac..3e6d6ebd199e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -949,6 +949,65 @@ static void hubbub31_get_dchub_ref_freq(struct hubbub *hubbub,
 	}
 }
 
+static bool hubbub31_verify_allow_pstate_change_high(struct hubbub *hubbub)
+{
+	struct dcn20_hubbub *hubbub2 = TO_DCN20_HUBBUB(hubbub);
+
+	/*
+	 * Pstate latency is ~20us so if we wait over 40us and pstate allow
+	 * still not asserted, we are probably stuck and going to hang
+	 */
+	const unsigned int pstate_wait_timeout_us = 100;
+	const unsigned int pstate_wait_expected_timeout_us = 40;
+
+	static unsigned int max_sampled_pstate_wait_us; /* data collection */
+	static bool forced_pstate_allow; /* help with revert wa */
+
+	unsigned int debug_data = 0;
+	unsigned int i;
+
+	if (forced_pstate_allow) {
+		/* we hacked to force pstate allow to prevent hang last time
+		 * we verify_allow_pstate_change_high.  so disable force
+		 * here so we can check status
+		 */
+		REG_UPDATE_2(DCHUBBUB_ARB_DRAM_STATE_CNTL,
+			     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_VALUE, 0,
+			     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_ENABLE, 0);
+		forced_pstate_allow = false;
+	}
+
+	REG_WRITE(DCHUBBUB_TEST_DEBUG_INDEX, hubbub2->debug_test_index_pstate);
+
+	for (i = 0; i < pstate_wait_timeout_us; i++) {
+		debug_data = REG_READ(DCHUBBUB_TEST_DEBUG_DATA);
+
+		/* Debug bit is specific to ASIC. */
+		if (debug_data & (1 << 26)) {
+			if (i > pstate_wait_expected_timeout_us)
+				DC_LOG_WARNING("pstate took longer than expected ~%dus\n", i);
+			return true;
+		}
+		if (max_sampled_pstate_wait_us < i)
+			max_sampled_pstate_wait_us = i;
+
+		udelay(1);
+	}
+
+	/* force pstate allow to prevent system hang
+	 * and break to debugger to investigate
+	 */
+	REG_UPDATE_2(DCHUBBUB_ARB_DRAM_STATE_CNTL,
+		     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_VALUE, 1,
+		     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_ENABLE, 1);
+	forced_pstate_allow = true;
+
+	DC_LOG_WARNING("pstate TEST_DEBUG_DATA: 0x%X\n",
+			debug_data);
+
+	return false;
+}
+
 static const struct hubbub_funcs hubbub31_funcs = {
 	.update_dchub = hubbub2_update_dchub,
 	.init_dchub_sys_ctx = hubbub31_init_dchub_sys_ctx,
@@ -961,6 +1020,7 @@ static const struct hubbub_funcs hubbub31_funcs = {
 	.program_watermarks = hubbub31_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub31_verify_allow_pstate_change_high,
 	.program_det_size = dcn31_program_det_size,
 	.program_compbuf_size = dcn31_program_compbuf_size,
 	.init_crb = dcn31_init_crb,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index 8d64187478e4..6b1edc88e297 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1011,7 +1011,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.max_downscale_src_width = 4096,/*upto true 4K*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
-	.sanity_checks = false,
+	.sanity_checks = true,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
 	.dwb_fi_phase = -1, // -1 = disable,
 	.dmub_command_table = true,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
index 713f5558f5e1..9195dec294c2 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
@@ -154,6 +154,8 @@ struct hubbub_funcs {
 	bool (*is_allow_self_refresh_enabled)(struct hubbub *hubbub);
 	void (*allow_self_refresh_control)(struct hubbub *hubbub, bool allow);
 
+	bool (*verify_allow_pstate_change_high)(struct hubbub *hubbub);
+
 	void (*apply_DEDCN21_147_wa)(struct hubbub *hubbub);
 
 	void (*force_wm_propagate_to_pipes)(struct hubbub *hubbub);
-- 
2.35.1

