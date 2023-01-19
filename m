Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79067477B
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjASXw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjASXw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5279F3A7
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfV1VHg1vy3B6kHVck96cTuQefR+YQ6sgSo/0i6xea5dvZQ2jvuuIuGQzJW91CQCv1w+MPBPAO9ge9BrJEL36QikrCa8zOu6mHmA/R5P+qihrFR7OnxpVl0XIJbVPT+wqcEjjlUgXaYFhr+8hjfeT8w2IZJIWWpNzPerBdoWRCq0me+eP26RvfXWh5Qi2+9mCQDXhe5UoIrEwYb+gUnGhHPXbQxckwQcIJAvpDCmTQw8edYocu3sNzOS6Pn/IYgKc1uUhL4avKXBomaxCAUsa6MXRJPBbTmxbFl2mPm6cl4WDiDClehJsLRA/uXg1J5D7uRUXJbIe+WqsvmU7vxEYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luQxyMDDZfjpXjK5aWtkKOtEtXVpPyszO5RkumOgYdE=;
 b=UYexI6J2Xam/zu+ZAk9eA5XlkQ85cQtfDU0ECCFzs11/uAx7HCYnSgUutTmCi+eK8pumaZ7AYrY5O3A2cIFwG4xCu+lACk07m94fZYlBjGgVVAQVIbhIdTF9w3dEEwnpkWpo1HoRYKlZ1YBFKwz/sXs+C90pxB3NZF0RmBp3fp9PpepVAq56CJJWJdD5IroNW3mVYB93TVgqcPpmYMdPCws4EyG3OKMfQ6EALQf4H+CxjgGSGnh2oZftSub7E6r52cmVz/Wgidvjip9l3UuTbJQCkkMYY/P04/hNqXedKeKU3ijWnz5ChZLDBQVDCCojVVK/RrG9xhs/Fp2A+Gh6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luQxyMDDZfjpXjK5aWtkKOtEtXVpPyszO5RkumOgYdE=;
 b=YB0NcuhGlWAwiheMiLzqBSp9o8fQj6RqCdvZ6Biy1dvFvK19uJifoaLRhH/QrOqLgzKS3HVL7EkdVnG4Zs0F/o/yE4Ws7Bg1Spj9RJLr7dPsd7T1SDM4jZG1HzvFp6U01Qvd4EsQK1IyjqBk/dqeGDxAW7vMR6XDSL5/OhP9WXg=
Received: from DS7PR03CA0013.namprd03.prod.outlook.com (2603:10b6:5:3b8::18)
 by SA1PR12MB6821.namprd12.prod.outlook.com (2603:10b6:806:25c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 23:52:20 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::f6) by DS7PR03CA0013.outlook.office365.com
 (2603:10b6:5:3b8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:20 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:19 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:19 -0600
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:18 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 7/7] drm/amdgpu/display/mst: adjust the logic in 2nd phase of updating payload
Date:   Thu, 19 Jan 2023 18:52:00 -0500
Message-ID: <20230119235200.441386-8-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT006:EE_|SA1PR12MB6821:EE_
X-MS-Office365-Filtering-Correlation-Id: cae02892-51e0-48a8-7afc-08dafa783419
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wefAZEeK8AWLOsdxzRP6oP8tgXYsmAH5EdNF60naL/8Nv8j/qXb1m+K9Zq+1+uKZyGroC1qCAVzIZ30x7h1whK01H+mDDuXUQqCIXKfDldZ+YJb8wfbJc3wQxeyTKGWugt1NSRGQqy3pJHuJJlNRTp7+wv9Dwj6PHRx1FBvN6fCn3flX1X7ep/D+rGMFpxALmfEITuA1M4mftQ4gJ/2rmu8DmWNkFpgcU3TzIpahIPu5KoE8cHHWHwTJt7vur5j69hhH29aNMiwEc/AJ3tpFAwbCSCDjL9O6vWvSkwNfsTlea010snPTUsGORGvzYEuzjWQ9ZhAFCcfLfRjnuAoQtXyTgPDpztdnfo2pIV4lDRiZ8TG6x6stZAS2KbBusuUtEjtPNd60tE7ig5PYuqF4mNA6xs9SmApA5vn05+1c1CUucC9KFmdan2tC3V16eR6Lbvaas8ls9czLcCMZTzwM4c9eiXuwaC9ZVVQ12VGvJisVvEDopl0ZnCfSlybVUaRYjV/JZqtF4rriXDXG7b76dfx1+tyMQDpBuaw+z+IJwd4VzCJT06zDCUxSlXdOU5orf8KzcjVNPNDbFI+wf5GzVBWJkCl2dPYkcz1Ey6opjN8HtGHxuNT6PRM70DlfKnEXuSh9fSFrWX56NP12NIG1yBByR30MJBaiU7+aIPoTMrO0I9EQRglJgIBP8haHt2VtXRA4r8jJgRERnfmHehvzU9zgh6aOB9NbSFQ829xO6yE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(5660300002)(82310400005)(86362001)(426003)(356005)(81166007)(2906002)(336012)(44832011)(1076003)(47076005)(8936002)(2616005)(82740400003)(4326008)(8676002)(36756003)(7696005)(40460700003)(186003)(70586007)(70206006)(26005)(41300700001)(36860700001)(478600001)(40480700001)(6666004)(54906003)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:20.2669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cae02892-51e0-48a8-7afc-08dafa783419
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6821
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[why & how]
adjust the coding in dm_helpers_dp_mst_send_payload_allocation()
for reading easily.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 7aff7eb13ea2..fba6a57158cf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -274,6 +274,7 @@ bool dm_helpers_dp_mst_send_payload_allocation(
 	struct drm_dp_mst_atomic_payload *payload;
 	enum mst_progress_status set_flag = MST_ALLOCATE_NEW_PAYLOAD;
 	enum mst_progress_status clr_flag = MST_CLEAR_ALLOCATED_PAYLOAD;
+	int ret = 0;
 
 	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
@@ -290,7 +291,10 @@ bool dm_helpers_dp_mst_send_payload_allocation(
 		clr_flag = MST_ALLOCATE_NEW_PAYLOAD;
 	}
 
-	if (enable && drm_dp_add_payload_part2(mst_mgr, mst_state->base.state, payload)) {
+	if (enable)
+		ret = drm_dp_add_payload_part2(mst_mgr, mst_state->base.state, payload);
+
+	if (ret) {
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			set_flag, false);
 	} else {
-- 
2.39.0

