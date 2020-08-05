Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA5C23CF94
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgHETWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:22:47 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:61664
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728851AbgHERlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:41:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4I54Zo606C/ut2vJWhPXvvMO7Ppdve6lvL6a7qrGFwsbiqbqW9XTyb9HC7k8/RFW0l93hz5zvtYnUTpVR8hIwnu2TPKcUgPI23VVtApHvjDgNemFdlmQeC60Rd8NKS/elhNaKfPjyYa1uxBrm0U+X4g2/h09HY8Jm8oDzsheeRsF5LU2RFYlY5cTT4Rofcsd6SG6fOB9ccpw1nJY5guOhFH1XqXkXbOJFN8UmYXPdxW7qz0FPoEFKicwbKFTigNrQIG+ofdaSnG/gj85AHZQV+GyrYKMs+kXRdxTlwFJyycf+DrEImoxZW5KuLmuAMo7Vka87U2FyiCIEPid8ERqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DprzQBfuFauV2loh/P4pR3y2wnwOTpPmYmhnevmSvhA=;
 b=Q3K2mYpJHhS0sA0/k19p/jpfDxj38zwFU0P72tyPoiNgFD9TFb1qkQZUq7NQxEp7ImqrwVwWkjGMCgeNJwQDdasdXSvylfogiChT795x+8/lLxlQBtUA3wzQXwoXMTjBYHIem9prt0zoQU1RF98Jix97e7LU6V9rat7g+j5bpcXGg21vsnqsx4huZD+XvlviaPik2WoixmDt7uZSH/KReaKLNxXw6gb4rQqEJJnz4kMIhGHuhJzfMcnA3e2wEVQ0C+Bzx5mTr4ggdNsDBbVazwuwlH/9ZSKMx4bsqMp8A/jOk1IAc+tvNxr8IW46PBZMbdn3Rdf7Iuueg9mjtG71dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DprzQBfuFauV2loh/P4pR3y2wnwOTpPmYmhnevmSvhA=;
 b=1G9w3O80Ge+xjA2efEvVoJ4bAmzbMIl720AWoQsFYwkWdfIY3Gn7as8wkx+o6XMSv9/xI2gQweC+t69YRjYjZHjUSZQEGghsGofg4xKRWmvewTUKfYdPgHZ5bD+TIHLv4JueRtjbVoipdW8bc0O6Mkg9rpyJcGB+BZU8u52lJy4=
Received: from MWHPR02CA0011.namprd02.prod.outlook.com (2603:10b6:300:4b::21)
 by BYAPR12MB3368.namprd12.prod.outlook.com (2603:10b6:a03:dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 17:41:10 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::1d) by MWHPR02CA0011.outlook.office365.com
 (2603:10b6:300:4b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend
 Transport; Wed, 5 Aug 2020 17:41:10 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3261.16 via Frontend Transport; Wed, 5 Aug 2020 17:41:09 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Aug 2020
 12:41:05 -0500
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Aug 2020
 12:41:05 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 5 Aug 2020 12:41:04 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        Jaehyun Chung <jaehyun.chung@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 9/9] drm/amd/display: Blank stream before destroying HDCP session
Date:   Wed, 5 Aug 2020 13:40:58 -0400
Message-ID: <20200805174058.11736-10-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200805174058.11736-1-qingqing.zhuo@amd.com>
References: <20200805174058.11736-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b5ec078-2cea-4d5b-305a-08d83966bd74
X-MS-TrafficTypeDiagnostic: BYAPR12MB3368:
X-Microsoft-Antispam-PRVS: <BYAPR12MB33680A9AF58D8BADF4F741B1FB4B0@BYAPR12MB3368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0f2ncPeyP3SorbljQS4yqocxchyEdgXl/YL8xIXVrgSB/O9pfKTvkMbWd2ukHV5gO8gayN95oTH+J85UpYFsYQm3TUrkSEMO+XKHfIl6GVlhg6PHmQT3cHWguj2+gSBBkFb3wmuF/GGiQphk2GI6mlEpdxVL0QKosX0GLYZ+tb3kPRh6mcY5M1V1UkLJAgVbx5FzDAjYV4HxLpVFN0egl7SKcK95cd0IwyqVsJMhPfyrbp4l289cESijwg3s3GzFZCU4SZl1l8bNwjC1ICpD+339d33wyCTGiIPxFyAwpbLqY07VQnWbQtHXs/rX1mQu5iENPoJ/9vnNtqiS16ADdb6rsEy9YgmvEnFX1bGgDA3aF9hJH5PSNhFsFUHEebKAUs15bspppcaMMxQ8KIp2dg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966005)(26005)(8676002)(70586007)(82310400002)(6916009)(36756003)(356005)(70206006)(83380400001)(81166007)(186003)(44832011)(478600001)(2616005)(4326008)(5660300002)(426003)(336012)(1076003)(316002)(82740400003)(8936002)(54906003)(47076004)(86362001)(6666004)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 17:41:09.9171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5ec078-2cea-4d5b-305a-08d83966bd74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3368
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehyun Chung <jaehyun.chung@amd.com>

[Why]
Stream disable sequence incorretly destroys HDCP session while stream is
not blanked and while audio is not muted. This sequence causes a flash
of corruption during mode change and an audio click.

[How]
Change sequence to blank stream before destroying HDCP session. Audio will
also be muted by blanking the stream.

Cc: stable@vger.kernel.org
Signed-off-by: Jaehyun Chung <jaehyun.chung@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 4bd6e03a7ef3..117d8aaf2a9b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3286,12 +3286,11 @@ void core_link_disable_stream(struct pipe_ctx *pipe_ctx)
 		core_link_set_avmute(pipe_ctx, true);
 	}
 
+	dc->hwss.blank_stream(pipe_ctx);
 #if defined(CONFIG_DRM_AMD_DC_HDCP)
 	update_psp_stream_config(pipe_ctx, true);
 #endif
 
-	dc->hwss.blank_stream(pipe_ctx);
-
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 		deallocate_mst_payload(pipe_ctx);
 
-- 
2.17.1

