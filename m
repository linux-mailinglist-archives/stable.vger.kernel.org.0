Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A8345C982
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhKXQI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:08:29 -0500
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:52832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229849AbhKXQI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:08:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAbMnNt1PP1mYswKhY/ARqNIHYEPEwh8FJDm1Enb47IrljiGDNgZ5yabFEO4+3JIxVH6quyIZcuiSsblPmVZIgl4j5b3cAWcbyG8eo8xfXlue88WKNlNM65NHQL3IxXPvE78igP0skuIVuaACiir5EbrBVNrSi4JwR5YWl0gyIr+H/5LnG/XDOYPgXItAageH+G9vje9vSbHChWiZp+p98e5Spp4/rv+Ox8ZONG8cZIKMup7JrAZiBl+P9Y+HF6Ady+AjysO6wKk1f2RIQEhJbPNE7JvjRV9vtGInvI11RkGK8gD9NC8YBo3CcnPPzEy6A+Np9CHfsmfQq24UFNFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoTnJujxs618VJZtHG0+xguvBdxQVKQsiSTHvdv32HI=;
 b=GtyrtczbCguemd6IZRxz2N/LyAsLJDQkaIX5sZXAU21TLj1SqctK40SH9c7JdUrT5vo6zCxYHn/f1NydnN1+H80wEZTdyLxRQIcfDfMPSvFw0PTgGnT12BWv4snl4e7yukoMqOGGWE/Uo1PU79GNBs+XR04SxCo7zA5iQHzRc6NJeZMmZhQEEH6wKAuLsXXI55OhBmg3ORVZeg/9GV/L0jmWaap7BtqDH7PUrQm6qixiQ6Vr1Ms0joKdz9djNpgCGYUZhT+1RJhLk1eFK61JP1fFGMr8VZ22HShrxPd0dnwP4QpGGmBAwGYB1xo9iKNQOrkbqVKXPdzyJjkj17njLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoTnJujxs618VJZtHG0+xguvBdxQVKQsiSTHvdv32HI=;
 b=WIBqX3Db9o0X4bqdvBixxlIPQpQU6vVsE+wGZOBy9LJrZKGb0stixyWXCmeCCytgkkEwOMQVWOWI5mcw1ydLfgFimjVt4bHGrcnIeqwP3/efa2eCpPFIZjrsuLtkDl5b4Wt3L+j2lvYPFDvLRw8bxpaWnD1KPTFeiXVwpj/EnIo=
Received: from CO2PR04CA0078.namprd04.prod.outlook.com (2603:10b6:102:1::46)
 by DM6PR12MB3018.namprd12.prod.outlook.com (2603:10b6:5:118::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 16:05:17 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::70) by CO2PR04CA0078.outlook.office365.com
 (2603:10b6:102:1::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Wed, 24 Nov 2021 16:05:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 16:05:16 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 24 Nov
 2021 10:05:15 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <linux-stable@vger.kernel.org>
CC:     Roman Li <Roman.Li@amd.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: Fix OLED brightness control on eDP
Date:   Wed, 24 Nov 2021 11:05:03 -0500
Message-ID: <20211124160503.2471736-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0765e60b-f088-4a81-0bb9-08d9af6434ca
X-MS-TrafficTypeDiagnostic: DM6PR12MB3018:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3018EE13D9307BA3FB7C4BF0F7619@DM6PR12MB3018.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:318;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h3j5WQrJcbRZDTxreQGiNjw+Uqsf926vyyp/HLkRN9C+Lw3yKX1PEaC7e1E9CJ+yGEII2eBBZt44bZtvR3ShK5md9nbAZ5a6wcbg/2eTpZj1r3BQmqplu3wJJDjG3iJz70Pydv4znao+5/FtIgrqGHIp4nEB/wVWKVbm50mQMd1G9NAgky19SwX8wLUHlzWbwfEYXVQu0F9bYsEkucotMRubJdXaHI6Rkj2ig5UzYZWE6RXlUwNFOCydXRFi352W8fz5xGA5xvToICsD4+FeF9KbbSkH+s2D39xX77rb78S+6YDGo7rRsh/mMSV+AnarqzPfoRzOuENUAzwwlmAxHj77d5rJCtUpcP86Pw/Pz5ZMGQiO0zPrPaY9fc3C79K15GcI1LSxKr12+XUjureL1WVfekanm9ebBm/YMlOhyJbXREs11DqLEdhm18Qb7PEDHIdW6ycATCofZ2DcKVZtQVCWrs4Nq7DlTAE2+MY62DFbtzPgWQd295KLff9DUOLY/4/8VhTzrMFCg/FZeZ+D/tugiGDOT0XzzYVFSXm+BQIq+L5KhkNhuYpJO/ybF+scG4N+vfD2pojJElmw31icjBV6NW+fjdzFNo2zrndKp/dbRbUJZj+Og+5t6s1GdoAgqNh3UVyCVgg0GjgcCyZ3OXjgt5L1o7SAxpXrgJ3SddULYrc7C6e8Css8uKEHDeE9c9eyI172fxwLmh1x5uo5C/niguHo9BfhbnIG0Z7Ydf8vE03j3dbZ8P7kBKt82yxgY+dE16eRWwxtiv+N4nDNwYd2x03vGGImHWXbSVYsEy7X+qIO2UB43LR+2+mm1RLC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(66574015)(81166007)(6666004)(70586007)(83380400001)(316002)(36860700001)(2616005)(47076005)(86362001)(36756003)(6916009)(356005)(4326008)(508600001)(426003)(5660300002)(8936002)(8676002)(16526019)(966005)(336012)(1076003)(2906002)(186003)(70206006)(54906003)(26005)(7696005)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 16:05:16.5293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0765e60b-f088-4a81-0bb9-08d9af6434ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3018
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[Why]
After commit ("drm/amdgpu/display: add support for multiple backlights")
number of eDPs is defined while registering backlight device.
However the panel's extended caps get updated once before register call.
That leads to regression with extended caps like oled brightness control.

[How]
Update connector ext caps after register_backlight_device

Fixes: 7fd13baeb7a3a4 ("drm/amdgpu/display: add support for multiple backlights")
Link: https://www.reddit.com/r/AMDLaptops/comments/qst0fm/after_updating_to_linux_515_my_brightness/

Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Samuel Čavoj <samuel@cavoj.net>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit dab60582685aabdae2d4ff7ce716456bd0dc7a0f)
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1ea31dcc7a8b..a70c57e73cce 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3839,6 +3839,9 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 		} else if (dc_link_detect(link, DETECT_REASON_BOOT)) {
 			amdgpu_dm_update_connector_after_detect(aconnector);
 			register_backlight_device(dm, link);
+
+			if (dm->num_of_edps)
+				update_connector_ext_caps(aconnector);
 			if (amdgpu_dc_feature_mask & DC_PSR_MASK)
 				amdgpu_dm_set_psr_caps(link);
 		}
-- 
2.31.1

