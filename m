Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F4E3F3736
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 01:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhHTXQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 19:16:22 -0400
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:43361
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230211AbhHTXQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 19:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2FXixUcat5kKlrDnUjTAMbCX3cPLJyoxitUVAVZQmjfGM9s6b3xpM84kk6tKzDW9AHzz27LP++95KnpIjku0zaT04L1F2y8KrGlyzmh8oOtXzCdj+lovSzLUq1LnOfnR5sWXVhSm+BZht+dMnCEwRmySTIS6D4dP6EcA7eSCwYg9FeQ1lxKxsl0fIZdBuuHMbW6FeRqOCBtBVSvP/+0tlhdQNH6qcz88eny46oDOFu3JjX2A4Ti0hkEj4AqphPIDptWWQY5TgxPWMv96TYJTlhSP92wEYK1Mx4mODCgg80rNV3Kdo6W3Y3GlYnysC/O6EHzdmcU6nOWt+AXhwbs3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BFx32ABToDthud4/8Dp/KqVxyqLsu+eIAve3QBs0LU=;
 b=QAY7Dm/4KEnYMBMYRFjXYJd0dCsYNsFzyWNMb/ewkBqGKVM7v+xAWkrNdYRRiUZLxXGvZUi0SQtido+/hZEjpmlvNhJcs9q/n/O3uT/d9vWRpolojtvxopwpSvhnK3S5oBI7HuMMM2yAeTA+/0vtcqzVIXyDtVerCNVlUEyHXmVYomNNMD/+nuM6eqOKLP84qYLvksyTMiLLom3Yoncjt4OcMmFJhlm51d3HhjT+oa5sv0jDtLnqiUXg1g4ItL3P7CWsKZbmcX1k6/0D5IECIsZeLD3VkCCATLN48bI0sIGMKJZu6UB5iZlITXJvI4IqtTdGry50NQZdS0jj1dyT6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BFx32ABToDthud4/8Dp/KqVxyqLsu+eIAve3QBs0LU=;
 b=M8lApC3QgcqYbeJU/MJP3pBMV13W0HJsal98AGQJdx1vA+SGe9czOkl+Qmkf5VpVLzoSn7jJsBsOEBUVoQk+SGVmebhUVjQkkJ8yRkhL83txVerb5rvAaYWgtgmAeIqhRQ75Xq/8J8UZ43ngRVEdWmBfSqkB/BkXJ+WoH2KEyWU=
Received: from BN6PR22CA0025.namprd22.prod.outlook.com (2603:10b6:404:37::11)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 23:15:40 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::55) by BN6PR22CA0025.outlook.office365.com
 (2603:10b6:404:37::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Fri, 20 Aug 2021 23:15:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 23:15:40 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Fri, 20 Aug
 2021 18:15:38 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <mikita.lipski@amd.com>, <roman.li@amd.com>, <Anson.Jacob@amd.com>,
        Roman Li <Roman.Li@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 05/10] drm/amd/display: Limit max DSC target bpp for specific monitors
Date:   Fri, 20 Aug 2021 19:15:15 -0400
Message-ID: <20210820231520.1243509-5-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210820231520.1243509-1-qingqing.zhuo@amd.com>
References: <20210820231520.1243509-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e22e4b58-0483-4d65-02a4-08d964306d7a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4480:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4480FE0310BF2B4ED658B549FBC19@SA0PR12MB4480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9Jz0SKGcqgRUIUZfQqBYGWNcYrWoh4Hmq34UzUrn8yAEuF5+r1Ev5XKr7IniNxeRw6T8891I8bcrboa9+9XAArYNn6V7zoQJ67rRPXsvGP1BXXe0kYdRPy4gqy/tN3XCyT+XBBh4eg73uopzpaXEvYx7XSZNvormFZyy7ixE7lU8Lk2LMT+vDMiOn5RE9D4kGRs2eOofteH6gA6NXmz+4X1Ks3STk6BsE96yLh3yyLGYmokBqL0dv2vHserxM7uOOm4wE3rQkllalLxqBBXihThbKCqinY3V1yQCaMVCe2HE0GMYQ7ddN42rOdh6N/lf/t4KmhsMQ4844CaiQY83cP16Gks0A2SD3ClOk5VN1ED4N7cmB1wWeUtwTlkL1W/fCx3QVuHPTnwUOfzMhVBfbvmFb7b0hNVHnTKOvu4hp/tQA/rhKQkmLjGfIlv77yjjMUyuoGDmx/+68K/oxpbd4wVeWLxHE0Hys6crXe+23dl7XgUiBjqTW8c2CQ1dE+ThLF5VCTjuEQjUcCdYCAzsrwpEuwB1t5k4s8l+6bdyz56C+RC0jvWB2ji3pnmdTLqVefqSD8tb/bO5hZe+GzMb2anAxFdIo35iPuxEoCDP+bdKZ1Kah3mp/hM5yrjFAixAp7C1PeSFRrX2u/3Q+UTrU5QJ9GS4A7wsOFfi6p503e+qR8U7GbvP15Xxh86Wrc7Au8PYqdTA2JCNTUMYvuG12ynX57DfTwMLY6syUgC+jT0syKvPC0Qy4w6HrlUG2NVqZt765EzKyayJJa3pKye0A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70586007)(336012)(82310400003)(2616005)(70206006)(426003)(34020700004)(54906003)(356005)(86362001)(2906002)(6916009)(44832011)(8676002)(16526019)(186003)(508600001)(81166007)(26005)(5660300002)(47076005)(316002)(8936002)(4326008)(36860700001)(6666004)(36756003)(1076003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 23:15:40.7116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e22e4b58-0483-4d65-02a4-08d964306d7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[Why]
Some monitors exhibit corruption at 16bpp DSC.

[How]
- Add helpers for patching edid caps.
- Use it for limiting DSC target bitrate to 15bpp for known monitors

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Cc: stable@vger.kernel.org
---
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 6fee12c91ef5..d793eec69d61 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -40,6 +40,39 @@
 
 #include "dm_helpers.h"
 
+struct monitor_patch_info {
+	unsigned int manufacturer_id;
+	unsigned int product_id;
+	void (*patch_func)(struct dc_edid_caps *edid_caps, unsigned int param);
+	unsigned int patch_param;
+};
+static void set_max_dsc_bpp_limit(struct dc_edid_caps *edid_caps, unsigned int param);
+
+static const struct monitor_patch_info monitor_patch_table[] = {
+{0x6D1E, 0x5BBF, set_max_dsc_bpp_limit, 15},
+{0x6D1E, 0x5B9A, set_max_dsc_bpp_limit, 15},
+};
+
+static void set_max_dsc_bpp_limit(struct dc_edid_caps *edid_caps, unsigned int param)
+{
+	if (edid_caps)
+		edid_caps->panel_patch.max_dsc_target_bpp_limit = param;
+}
+
+static int amdgpu_dm_patch_edid_caps(struct dc_edid_caps *edid_caps)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(monitor_patch_table); i++)
+		if ((edid_caps->manufacturer_id == monitor_patch_table[i].manufacturer_id)
+			&&  (edid_caps->product_id == monitor_patch_table[i].product_id)) {
+			monitor_patch_table[i].patch_func(edid_caps, monitor_patch_table[i].patch_param);
+			ret++;
+		}
+
+	return ret;
+}
+
 /* dm_helpers_parse_edid_caps
  *
  * Parse edid caps
@@ -125,6 +158,8 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 	kfree(sads);
 	kfree(sadb);
 
+	amdgpu_dm_patch_edid_caps(edid_caps);
+
 	return result;
 }
 
-- 
2.25.1

