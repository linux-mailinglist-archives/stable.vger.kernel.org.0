Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2E92440B2
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 23:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgHMVff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 17:35:35 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:47808
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbgHMVff (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 17:35:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mt3pjWJG4ZTgeBF40AnFrqKVyhkXDButwCe9qkHWqxGwk35YkewjdJPUDRL4th7yT+Brdiv4vISFRqxPEbkMvtUUwweJ7WWI+678cz/iOyb8WktODBXwa9Dizy/U7XBVVfMQ2bFJy/czCVK/v2YuqT9UoFljNiI+8Or+Bs8ls1uqw3eok06mBLH9p/SpEOrHzzg3eZjHsU7WCMDSrYHNk5aMVxEgXqjJIEaTHR2KjH+hyxcZqWMO4tDvC9pzA4iuuUMSc3rG1EDXvW82078btXYiQvh8G9s35MUJPEqaxGmThW01b3KRC9DXjmFZv0kpMAcpW+D8IHId0rNFPGsA/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDr3g3Iz17Cnouxs3bDOg8PRpxI4QZnwEmB3H0o7X74=;
 b=I0G/WnHwc51u0pGvPG1/+A/5Z/bRTIvKMVxRNHQ9GekcpeWrB9lhV5cMvAGjmtOE5oD9JyoE8VUXKYEJ000vtrt/mnd1DxTQOWBwvk09HW6JKA8wfTzFJsWhv1RGIA2G66Oig6KCaro6hrVZ+dIGIvcVx9y7L57X0EdG5WyIaqqafryh/7zfPrrwR3gqVXKwBub1XwNsi8s50P26B7kE3lCZwVmP+hln50RxrTGsFdyCeQHSTlheohKYRw0oPyLc3eVRH1c1Ou2jqjd2xCox81pRvCv9K5ObCGf/NrfyanWP+Hxmhl8Y569k3FUHWF6hbJ/5Jz7AGzF1EJENPK7nNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDr3g3Iz17Cnouxs3bDOg8PRpxI4QZnwEmB3H0o7X74=;
 b=tUoPJCOZDWLrONtCY8+HBiENDoQ5rSUNCQEjiQVckU5uAoo8SwbNE9p/hJvLi0JzpKZOGS4T4jrqn2crUiyRDpdlT5DW9bVlmNVXz0EVSdyZbn6tjygABjxC1BNKK1GyRfhNpjnt6uoi8AJnvP8uaVemPmY4gbUHz2zPLwAW1sM=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20)
 by DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.19; Thu, 13 Aug 2020 21:35:33 +0000
Received: from DM6PR12MB4124.namprd12.prod.outlook.com
 ([fe80::75f2:ebaa:bca6:3db7]) by DM6PR12MB4124.namprd12.prod.outlook.com
 ([fe80::75f2:ebaa:bca6:3db7%9]) with mapi id 15.20.3283.016; Thu, 13 Aug 2020
 21:35:33 +0000
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry.Wentland@amd.com, Sunpeng.Li@amd.com,
        Bhawanpreet.Lakha@amd.com, Rodrigo.Siqueira@amd.com,
        Aurabindo.Pillai@amd.com, qingqing.zhuo@amd.com, Eryk.Brol@amd.com,
        Eryk Brol <eryk.brol@amd.com>, stable@vger.kernel.org,
        Mikita Lipski <mikita.lipski@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>
Subject: [PATCH 12/17] drm/amd/display: Fix DSC force enable on SST
Date:   Thu, 13 Aug 2020 17:33:51 -0400
Message-Id: <20200813213356.1606886-13-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200813213356.1606886-1-Rodrigo.Siqueira@amd.com>
References: <20200813213356.1606886-1-Rodrigo.Siqueira@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YTBPR01CA0005.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::18) To DM6PR12MB4124.namprd12.prod.outlook.com
 (2603:10b6:5:221::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from atma2.hitronhub.home (2607:fea8:56e0:6d60::2db6) by YTBPR01CA0005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Thu, 13 Aug 2020 21:35:32 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [2607:fea8:56e0:6d60::2db6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5436e727-2a96-451c-e207-08d83fd0cee3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13550758BF1E627E52C541D398430@DM5PR12MB1355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c6ZTGUTqn24zQ0axEGoduLi2rv7yjFcbjNBNYnW3g7cpEROwwd4+LQq/raYSC+pwwFoLANLaWKwNBt692WC3tv9zAuzaG2zfk6cCFwdln8by6qEQne5SRXeIeP8bR4nw4JcKCW2WAqS/C8LULGwICrs5hhBkyoYgwrSZwVUNPXBp5Xs0I7X+awoDC+4VdbfIJxJrPMwmLXATqGICWHPYzQQ7C+I4CkgI0HKNJpX9LLLw8mrYWlVT0b5169+E0r8jswt54zhGAguszi74pcn/S4XmkAnlGNoo0bFKp0maqkmXzuzgktb+yTRQhmagkn7Q4465un/3Ez9J6wciCLX28A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4124.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(2616005)(6512007)(83380400001)(6486002)(4326008)(316002)(478600001)(1076003)(6916009)(66476007)(66556008)(36756003)(52116002)(66946007)(2906002)(6506007)(8676002)(6666004)(54906003)(16526019)(8936002)(5660300002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8vqb+/y2lzWCvo3XMuN2jxjyi4CdCg77N1/eIUZmgxKh1WITU1ipw39NZmJCBnRTYYe5l6Mr6arONrKzMYwjCMT01OlW1CFORXBdA8sTb9mUXXfrGv7QdSuD3PhyysF+mzyAq9PM6sV4lbWUm7c47bPYuy8WJ1nsyR5FR5j0NW2kTb4Z0WW8IFEfG8QuX3Qkjxg+MU4I09MUzXPBSqmRvLSlEnNf7ymyTogBtoYSrsEjNIcWE7o7+7Z+d4r7w0u8WpgBEAeu+9E4lxfrwi0aVnyvoEqUgqHxYiBkOWwPvmSEGeZczhI+aliONgoUz8/ZhnTU7CIYKfTsJ64Shp9hnI0JJGMVJLcNRuM+lzwqftMqlnqNHJT2Aw0nGo+vTpvYd1kXTM06m9eiGJmYYOTxzakNnX6R5gTT9vvPVYrZOfVKjs2RigfnifI5PZ3DBgKNT4JnH7RI+6PMyimolmmosf491PfaVAHhgKpU5AhldDLmSrV/x0YqmWsSfJF0CHiid8/tMA6MoXf7QN5qZ8ZqZI8unsTiP6qFUtWmFTCyo8JNwKS3ClBcUxede5cJEF6ZLrYxTTd0YWs1X01suo+3hHYXkIY9rsagtU48uoiMLJhAqUFWqX9HQtTpXqtjiGaMR5nQj2Eh/Q6tjKkDHhd5s3rKswddJ9mLfAagdyMj5qlLvlchOdz3fehLiQZaCbaZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5436e727-2a96-451c-e207-08d83fd0cee3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4124.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2020 21:35:33.1645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LXgfMDkhN67zQ9OviT4I7fdGOyIg6T9j311BxmpZnX2D8Uo3opO7FUCeOVhyUq5Fq6CC9bPgspw6cAIgHE/yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1355
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Brol <eryk.brol@amd.com>

[why]
Previously when force enabling DSC on SST display we unknowingly
supressed lane count, which caused DSC to be enabled automatically.

[how]
By adding an additional flag to force enable DSC in dc_dsc.c DSC can
always be enabled with debugfs dsc_clock_en forced to 1

Cc: stable@vger.kernel.org
Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    |  3 +++
 drivers/gpu/drm/amd/display/dc/dc_dsc.h          |  3 +++
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c      | 16 +++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9894d5718ed6..39d756588728 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4719,6 +4719,9 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 		if (dsc_caps.is_dsc_supported) {
+			/* Set DSC policy according to dsc_clock_en */
+			dc_dsc_policy_set_enable_dsc_when_not_needed(aconnector->dsc_settings.dsc_clock_en);
+
 			if (dc_dsc_compute_config(aconnector->dc_link->ctx->dc->res_pool->dscs[0],
 						  &dsc_caps,
 						  aconnector->dc_link->ctx->dc->debug.dsc_min_slice_height_override,
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dsc.h b/drivers/gpu/drm/amd/display/dc/dc_dsc.h
index 3800340a5b4f..768ab38d41cf 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dsc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dsc.h
@@ -51,6 +51,7 @@ struct dc_dsc_policy {
 	int min_slice_height; // Must not be less than 8
 	uint32_t max_target_bpp;
 	uint32_t min_target_bpp;
+	bool enable_dsc_when_not_needed;
 };
 
 bool dc_dsc_parse_dsc_dpcd(const struct dc *dc,
@@ -80,4 +81,6 @@ void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing,
 
 void dc_dsc_policy_set_max_target_bpp_limit(uint32_t limit);
 
+void dc_dsc_policy_set_enable_dsc_when_not_needed(bool enable);
+
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
index 8cdaa6eef5d3..da1b654833d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -34,6 +34,9 @@
 /* default DSC policy target bitrate limit is 16bpp */
 static uint32_t dsc_policy_max_target_bpp_limit = 16;
 
+/* default DSC policy enables DSC only when needed */
+static bool dsc_policy_enable_dsc_when_not_needed;
+
 static uint32_t dc_dsc_bandwidth_in_kbps_from_timing(
 	const struct dc_crtc_timing *timing)
 {
@@ -360,7 +363,7 @@ static bool decide_dsc_target_bpp_x16(
 
 	get_dsc_bandwidth_range(policy->min_target_bpp, policy->max_target_bpp,
 			dsc_common_caps, timing, &range);
-	if (target_bandwidth_kbps >= range.stream_kbps) {
+	if (!policy->enable_dsc_when_not_needed && target_bandwidth_kbps >= range.stream_kbps) {
 		/* enough bandwidth without dsc */
 		*target_bpp_x16 = 0;
 		should_use_dsc = false;
@@ -961,9 +964,20 @@ void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing, struct dc
 	/* internal upper limit, default 16 bpp */
 	if (policy->max_target_bpp > dsc_policy_max_target_bpp_limit)
 		policy->max_target_bpp = dsc_policy_max_target_bpp_limit;
+
+	/* enable DSC when not needed, default false */
+	if (dsc_policy_enable_dsc_when_not_needed)
+		policy->enable_dsc_when_not_needed = dsc_policy_enable_dsc_when_not_needed;
+	else
+		policy->enable_dsc_when_not_needed = false;
 }
 
 void dc_dsc_policy_set_max_target_bpp_limit(uint32_t limit)
 {
 	dsc_policy_max_target_bpp_limit = limit;
 }
+
+void dc_dsc_policy_set_enable_dsc_when_not_needed(bool enable)
+{
+	dsc_policy_enable_dsc_when_not_needed = enable;
+}
-- 
2.28.0

