Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0B2369470
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhDWOMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 10:12:52 -0400
Received: from mail-eopbgr700082.outbound.protection.outlook.com ([40.107.70.82]:9217
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236941AbhDWOMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 10:12:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxKWh9ypOSv0tsYRB86EomaMqCbqUXwyduCUPxyNgv/9qVWaeV9wPCuPn08OIanUCjc7SoQGc6Ch1UIvFzx7hN//b3YHkQ3JyuTmsik36rYHPi0ZEoTqobKLTjrZNDOkh2uulzJ2dYmeQnLqUH2xFlX66Af+VM1CbOlpWgwEuh9HQt0c0azcJPvxS16YNhPdVtvS4FQtDRUW4AxzDPgY5jJ9s6v284u2HLhCptvNqMcyQt8Ned8l69UlLUvuB066hU6Gz7NtIX2kxGQD36cHado/uFllvLKUMaEwuY/T6gLInAvvEIUbGnqP+JT+pmA4EyCxvMmS9lu+9hJ8L04cfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBNGeJ/KqlK0qdnXbOfW99X4viDdVlhsUcb+ARonJH0=;
 b=IixkKr8danT2tDL4cvzo9gamzRpVkFbz39qytOZkVV91Zy+OlRzGeWe50r0ymjWx93aoHQvuEl+73hNcy8FoexIcWy+xahdGm7WlklxLB7cguTNkrMCeiWKGwdq+yhoMUp1W/152Lo8O1IAsY3aOipY/gHoyfzWq+Qz0wsbCmGa4Bp2ohP2LZOb6zvlyADZDiUph7kmcE5ejRDnR3s4h4UUc0LtalGPsXBfrU0QUz277WpLfag2aLD3xS6W8b0Xfq/zfT6OvmAvBI3NE7yq0FfMvRSR5x6V17RyoWpDczPgv8N1E5CrWJqoBO4W92+2M6wiX7LeEerqmXPU1jjWAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBNGeJ/KqlK0qdnXbOfW99X4viDdVlhsUcb+ARonJH0=;
 b=FIf+4WLmLdmINfFMcV5rWyz01AUD2fz3/SqLjYd9B8mPPAd3vkw/WPV+A6ZEZt6n0eg+9bBs31aqzDKNNiN7hmOq4kcuznZ7XZrmYfTCNzmqmfp2E83NbKxmHDeb0cqEfPB1XVBRE1tXeSXy8aVGGLRc0HQ13fJUz8xyY5zGjqQ=
Received: from DM6PR08CA0046.namprd08.prod.outlook.com (2603:10b6:5:1e0::20)
 by BYAPR12MB3333.namprd12.prod.outlook.com (2603:10b6:a03:a9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 14:12:13 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::5f) by DM6PR08CA0046.outlook.office365.com
 (2603:10b6:5:1e0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 14:12:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 14:12:12 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 23 Apr
 2021 09:12:12 -0500
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Fri, 23 Apr 2021 09:12:11 -0500
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Harry Wentland <harry.wentland@amd.com>, <stable@vger.kernel.org>,
        <nicholas.kazlauskas@amd.com>, <alexander.deucher@amd.com>,
        <Roman.Li@amd.com>, <hersenxs.wu@amd.com>, <danny.wang@amd.com>
Subject: [PATCH v3] drm/amd/display: Reject non-zero src_y and src_x for video planes
Date:   Fri, 23 Apr 2021 10:12:10 -0400
Message-ID: <20210423141210.28814-1-harry.wentland@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5220c5a-b355-4061-aa8e-08d90661ca94
X-MS-TrafficTypeDiagnostic: BYAPR12MB3333:
X-Microsoft-Antispam-PRVS: <BYAPR12MB333375804B28FA7DFFE760B38C459@BYAPR12MB3333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScvMOC8NuvQ0gMP/3w3jzppf1MWmJXydwsboflVkrhFeNA5eE02ypKzbQTMSlWlEzVcyiJx83Bnmg/yhYBt6jRaOQeftbZSMFRwR3W6jLMx48UraM5XxShKXmPPOBpu8cFe93CFCkqk7O6iaOIIgYqe0mna9kpup3NA2JxI9JMPAeE+6fn6uP8Cb7h7ysklsYTzWKFz1NXNeiAbfrRyDsoFpeWf97Hsk7r3OCoqvBvmBNh9ExHTdSZZ912IjkbqmpkTSIZEuFEw0Iw55tocTg5fY8qc0JCNhSr7jiP8RJOgk9OfM/TSYbmSz0KMCH21EREQcgo28yFD4Qo2O6/QDB/ZtlMAZg4rhPnVXIImbSNajmFPwZc75cWzWWXtxuLxLVd0dO3xSWEiaO8lSc1ENxSu8Mz24tx+RE7SF1Q1wvZRNT8qjekPcrp88dN1orHfsPXZmovF8k0pJIalL3M62aaKvYtHpM0Y4jboPEiUfi0/W49rExJinmgDLlp+U0LRoQ4VF6lT08yIGwj10g/UAd5DSFFj5+jQ9Qzo7QKFoUAApYXwAttoHPgIBYIohrBHYBlXCAIR+cylVtzmLb+8yAR6xkbq1Vb/QqO3LNYYYKaB9PApBJqrYwCr9SbCzgmIaRm/bgzKOQ5eeF7vuc63q4ACFpvlEY1fabjoRAJt58qW4D/8BhNhsMBF61eYkW+sm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(46966006)(36840700001)(336012)(26005)(36756003)(356005)(186003)(82310400003)(2616005)(426003)(44832011)(2906002)(478600001)(86362001)(6916009)(316002)(5660300002)(4326008)(1076003)(70586007)(47076005)(82740400003)(54906003)(70206006)(8676002)(36860700001)(7696005)(81166007)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 14:12:12.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5220c5a-b355-4061-aa8e-08d90661ca94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3333
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
This hasn't been well tested and leads to complete system hangs on DCN1
based systems, possibly others.

The system hang can be reproduced by gesturing the video on the YouTube
Android app on ChromeOS into full screen.

[How]
Reject atomic commits with non-zero drm_plane_state.src_x or src_y values.

v2:
 - Add code comment describing the reason we're rejecting non-zero
   src_x and src_y
 - Drop gerrit Change-Id
 - Add stable CC
 - Based on amd-staging-drm-next

v3: removed trailing whitespace

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org
Cc: nicholas.kazlauskas@amd.com
Cc: amd-gfx@lists.freedesktop.org
Cc: alexander.deucher@amd.com
Cc: Roman.Li@amd.com
Cc: hersenxs.wu@amd.com
Cc: danny.wang@amd.com
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index be1769d29742..aeedc5a3fb36 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4089,6 +4089,23 @@ static int fill_dc_scaling_info(const struct drm_plane_state *state,
 	scaling_info->src_rect.x = state->src_x >> 16;
 	scaling_info->src_rect.y = state->src_y >> 16;
 
+	/*
+	 * For reasons we don't (yet) fully understand a non-zero
+	 * src_y coordinate into an NV12 buffer can cause a
+	 * system hang. To avoid hangs (and maybe be overly cautious)
+	 * let's reject both non-zero src_x and src_y.
+	 *
+	 * We currently know of only one use-case to reproduce a
+	 * scenario with non-zero src_x and src_y for NV12, which
+	 * is to gesture the YouTube Android app into full screen
+	 * on ChromeOS.
+	 */
+	if (state->fb &&
+	    state->fb->format->format == DRM_FORMAT_NV12 &&
+	    (scaling_info->src_rect.x != 0 ||
+	     scaling_info->src_rect.y != 0))
+		return -EINVAL;
+
 	scaling_info->src_rect.width = state->src_w >> 16;
 	if (scaling_info->src_rect.width == 0)
 		return -EINVAL;
-- 
2.31.1

