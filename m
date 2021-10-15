Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0C642FE32
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbhJOWfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:35:05 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:57889
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235622AbhJOWfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 18:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxyK0jrHj41GJCQr/BsQ18P91itCRATfVRyZn9zCDTzso9RciqMT//JinajHSOJDt2ohSFScIc2Nb3AbRWUhYEe2BcqM3fMDEcc5kOBRCLHudEpy4sWJIqkRQYgWI54xeVsSHH8j706Vx0EiOop1QRPPw1b1iSGgxdkEf3g/EB8stzUB8PagQkSdHEFVKfWbcMTRJoFuspgBvMqCe8aDbqohdl/RUiKNNG1jYMD3zMdHVaHffWFiOxC8lOxA1IvXgsCIM4uWaDsbTvd0UmCFGjvdofbx9z4+9HSRek2JaBsu0cjS65ZjbOnTSkyo7/YVxLvNvK8l5fwddA5oZWoRPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlQsl467a1c6lVEjLfasL/RhgEarYp3P6iDL9XjX7Nw=;
 b=OXdWeIungdXcYSSOJi/JzqVfQ0I5E0OEQVTcbNUTHUKV57AkoCjv1O7l8YoM0RtAtKy97W+b3hQbSbzIaoqeMPAZmZoLmKMcbyUPlGa79G+C/UPLr12RBPsWUJcD2zltIBO8N/rQWoEgxWED21hTuhYudtJP+2whAwisug6XyYJKaF7K7C11OlxPyXdGW5aH635NxoqVdBN3ydELcBrJl+CJZBcGjrUMw1mcbXMztTbYi1YAfyEXZEBcXcDgFcgOx5XIwse0nXEgsVBwlHXbCNjIvzQpXVxz/yTEeAdv3TnbvrTbwB5uJx/lsu/bTD+A43u2qpykeIrHZFE3bydsDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlQsl467a1c6lVEjLfasL/RhgEarYp3P6iDL9XjX7Nw=;
 b=Pa+BHGHL823zdxHPkOya519DOlYeExbmPMSXLhKNOqRyrimQv06jh0XVhgfRrK3E1XJUwqrBr8a7zCW9NUYIlq0n7DPikdpWXgnfAOy3T7hPorZlS9yoFv40qyHa63aBA5g7DtlLKQkkhcHqyP/s4DilOarleP+j/o6avQgeW7o=
Received: from BN9PR03CA0560.namprd03.prod.outlook.com (2603:10b6:408:138::25)
 by MN2PR12MB3616.namprd12.prod.outlook.com (2603:10b6:208:cc::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 22:32:54 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::c3) by BN9PR03CA0560.outlook.office365.com
 (2603:10b6:408:138::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Fri, 15 Oct 2021 22:32:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 22:32:53 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 15 Oct
 2021 17:32:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 15 Oct
 2021 17:32:52 -0500
Received: from roma-lnx-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2308.15 via Frontend
 Transport; Fri, 15 Oct 2021 17:32:52 -0500
From:   <Roman.Li@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <Alexander.Deucher@amd.com>,
        <Mario.Limonciello@amd.com>, <rodrigo.siqueira@amd.com>
CC:     Roman Li <Roman.Li@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
Date:   Fri, 15 Oct 2021 18:31:40 -0400
Message-ID: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d934d7b5-55fa-4e94-7b83-08d9902bbab3
X-MS-TrafficTypeDiagnostic: MN2PR12MB3616:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3616C2EA823321A2F906622689B99@MN2PR12MB3616.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxUcFekQOXtp/PuvE3yNJ7Xj+Sr3Y3fOenmzT0AmNGL7i+m+08662Jql07c2C3YaeV5pUDlC7wAuEX9DhVqqHinayxZ35RzyMj/XvQHfX0UXccECtF3Ln3hDr92ffW9vWjYz9ljBZK1Vz567nTWxzP3xws/mEj707gZbNd7CiHfXMH0ZjaXIKLRkemEsp7TrzsrQRoRs4nVhmIZTOgLyj6HDTESKqxcQolYCS/kF/5WOAUzHQTfL1pIsXtQQ1yl8w/EIcOHl2ZhcGv/MVLridpw3+QUn/XFUvWuL/HZ8yLb1HbX67RGKZd7SbPit/2D9KEEBX5B08mW5q6RjeHC85EnPj1kQvzidjaNa4yQTqiskfrYGcFNSPuRtzTXUjJbmRG2TLXh5SV81qqniX3jnrgNwwDSLHfk/sLrGR7hkf+XMntEP3jPiY/GK8J/TmDQ2IA9qfvdUCBsLPAEc0EnE2aSXaXX8XEHs6TQOygoCJmFIN3JAnOghD/aL3djgZBpxDlwf2YHaY4VFhe59pPqc4HbHMpyeBwuh3r+axwZNKSJ54gIDc6ZrkOIrOHjQVu6S2jjlCX1HN+kb99FVeAUUtS2YED0rMkTrOer8XP5nq9dcc9pdR+QmkOExzTTqAPLxSNA3OYZuMji+WOlKybXHr6qg9GcwYvlJ0WYravKhPsml3Znce9Lzvpekqmv7WgINENax7zZu4wtufbfwajRWkfH2ZhiBOkTi1fiH77FpnqOa5TGUKTkwZtGQTe3ESK94
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(5660300002)(2906002)(86362001)(336012)(26005)(7696005)(36756003)(8676002)(316002)(6666004)(2616005)(70206006)(70586007)(426003)(186003)(54906003)(36860700001)(508600001)(2876002)(4326008)(966005)(81166007)(83380400001)(110136005)(82310400003)(47076005)(356005)(6636002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 22:32:53.9519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d934d7b5-55fa-4e94-7b83-08d9902bbab3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3616
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[Why]
On renoir usb-c port stops functioning on resume after f/w update.
New dmub firmware caused regression due to conflict with dmcu.
With new dmub f/w dmcu is superseded and should be disabled.

[How]
- Disable dmcu for all dcn21.

Check dmesg for dmub f/w version.
The old firmware (before regression):
[drm] DMUB hardware initialized: version=0x00000001
All other versions require that patch for renoir.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
Cc: stable@vger.kernel.org
Signed-off-by: Roman Li <Roman.Li@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ff54550..e56f73e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1356,8 +1356,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		switch (adev->ip_versions[DCE_HWIP][0]) {
 		case IP_VERSION(2, 1, 0):
 			init_data.flags.gpu_vm_support = true;
-			if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
-				init_data.flags.disable_dmcu = true;
+			init_data.flags.disable_dmcu = true;
 			break;
 		case IP_VERSION(1, 0, 0):
 		case IP_VERSION(1, 0, 1):
-- 
2.7.4

