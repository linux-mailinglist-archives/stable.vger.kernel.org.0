Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79F369464
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhDWOKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 10:10:45 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:32353
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229549AbhDWOKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 10:10:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZmNnxtQ4fjU1mVi7YVGvWRRZqM32mmwUdBFTkcQrkLCky3Ps6qYRm+fWbq+0I5to68a0KBogx87V8YLzx2kCc0wEsG98ZsIs6XFrV6qujCbcoiEjYkx6BWMGWLI2je+yGIf7rEjtVUSewRgX9bCtQ+GOIMG1oNRkUJuj51ziTVi6NxYYPNAZAF07bpe8EA+VSp47sDSOmfXoGktWfR9MPN1cQmd/kvqpyXhWvsf3I2nkFs6HHd3z37BZx4rDgOZ9F1Hg90mMd8X22/09CeW4NeuxW88qsxdX+nJlKmHLtcUYP7ECRjUTx3LyBMZJDwwZOfndLXoNFIPPvP2qBv7ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouEC4Eo56Z2RHsoI0JY5xupEnUFN/AnEi7+ZdPccIFg=;
 b=NT8s4yOUeSfz68W645frgcoXtvlLc4IA7p/xxA80j6qHQwjBpC+2PpAhzAbabsMc1Y77iY3+WU/MVdDfv77mpDKw5jPFuxJ8L2nkf07UFMSKq4j4rKeHNdj+Y6NQ6fHHou+fLITPiSGeGjQ28Qfz+pNTJX9fOtbHgmV2iBfwfxcaZH2qESItJwOkHqJk4u4WLYelyrff/Wl9onbjGiyB0Fpmw2LvmvDChvRqEDbdMoF6+qry+pfVGgw6K2FcQQ72q8T0HdXuRe8l/YsliC+gUvZfC4ANTOKN/U+XZN2JDcQ/4W5NOLsDG/yXlDZ/WG04zM+Ja/gzDyxLfMNInbfmOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouEC4Eo56Z2RHsoI0JY5xupEnUFN/AnEi7+ZdPccIFg=;
 b=X6OodBB1mW6SVfxjuDUVB7fEqrn3UQZm1oqVBaclduXnpOXvkIJKRUjyxaDi9Y5z9h9Uq5e+iIlasulTBeraVbGBqXb7Y4MvhqvHHbOknzp3zxZLP+eEpsBwj7S7lttxynAQ0mLilUqKCdscfh4iyht5COrw7R2Dly4N7pdluQY=
Received: from CO2PR04CA0143.namprd04.prod.outlook.com (2603:10b6:104::21) by
 CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.23; Fri, 23 Apr
 2021 14:10:07 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::48) by CO2PR04CA0143.outlook.office365.com
 (2603:10b6:104::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 14:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 14:10:06 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 23 Apr
 2021 09:10:05 -0500
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Fri, 23 Apr 2021 09:10:05 -0500
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Harry Wentland <harry.wentland@amd.com>, <stable@vger.kernel.org>,
        <nicholas.kazlauskas@amd.com>, <alexander.deucher@amd.com>,
        <Roman.Li@amd.com>, <hersenxs.wu@amd.com>, <danny.wang@amd.com>
Subject: [PATCH v2] drm/amd/display: Reject non-zero src_y and src_x for video planes
Date:   Fri, 23 Apr 2021 10:09:58 -0400
Message-ID: <20210423140958.25205-1-harry.wentland@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ecdefb8-7cbf-48e8-4653-08d906617f72
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:
X-Microsoft-Antispam-PRVS: <CY4PR12MB19428C6A2704F16317FFC8DD8C459@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7pxf/NKBffZztdMbxlXaO1aLrZ5N9s1nFzjYTfRtHPjZpq3xKxkCglDARdLARusUjBI0h8lks+qXC1jMVTAKGXNdDahK2/H2yyNIKd+ZD6JQ77M71E1usR1DYdDEC5cw6GNNzIV0w2X0plTIJRlw5uQNNnqFKsDq3hxW64B3J9C/rwXSgh2WEiymGtwST8h9cenBi+1iO+rW5QNXumKZk0u//lyk4Ezz8YbF+mnLwifhd67oETbE69EV9ArPh0XJt4AoYIB9xxZ+85SvWKPB6pCgQkGTBFx09mvvv2C/Foy+DpBpiwgIhZcVug/gJs+6DnV/P62S3pzfj1y/ZV7v5ViXpgY2XPaOf4XkQ7bh/Kc0UZA1zOKMMYi0I1WeCfGQSfLZ2ikLVaLLY4/7Kc3kvjJFaGhFwKom0N7+IpUOwaWquSP2grICfANWs4MQJw798tkPGBp9l2/XlhXXtlaE7YQASeywbEeVmEQ9zZ3M99ZUYkbv/WHqYfSrj+VGC0Nqf5mR291qOKZJ9cuMrP4t0bBG3Ye7nVo7vfmK4r4a6Qc3UYCt+0E0/+eJ0H6UmiFHjJdRqzPWGAhEQfqOBNuYdM0chW4uZf9UYwrGJDAM4ginoeUov+hKmvVcV71GEOYOjuMpxTkgrR4MFgLjSENcTfvMWuGVpvtJBwj2y3YJZNUHjEDjtUYnhfkWwGwaVNya
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(36840700001)(46966006)(478600001)(316002)(26005)(2616005)(47076005)(426003)(70206006)(5660300002)(6916009)(82740400003)(54906003)(186003)(356005)(44832011)(336012)(2906002)(36756003)(4326008)(8936002)(70586007)(1076003)(6666004)(36860700001)(82310400003)(7696005)(86362001)(8676002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 14:10:06.7806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecdefb8-7cbf-48e8-4653-08d906617f72
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
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
index be1769d29742..b12469043e6b 100644
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

