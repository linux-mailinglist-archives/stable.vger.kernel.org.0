Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED74320FF2
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 05:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBVEDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 23:03:20 -0500
Received: from mail-dm3nam07on2077.outbound.protection.outlook.com ([40.107.95.77]:2657
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230088AbhBVEDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 23:03:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtRsYI0nIL7bgUhHnuZi+wNj3p8VGFlWmx4TDUIhQbxX3w5g1ck47mteasLNAAv9aEyysKAIuL/3893ECfiyNDQcO8SGkf62urHbRi+UPXgAkbQDIdod68sgESEmkaVwIgLV8Gnkoklp8fn4kze4UF9IoerS/xMLGXVi5k7FzcR++Xjy+69P9HJLXv9r37XuStZi2BEVgSUqtfFQjwjeUlWIn+dYYG0001yn/KJ+HbhT6ARD411fSrk2sKWfOqBYIYbF2M7YNtq1OldF42Ki4JAcGFnB3Whn9bzC2YSrcWBPFn/uFkPUg9Ion3aW/nn7yWbkOCIDWTn0c+veg1KiEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPoWl1MY9+15FmhUDRTxiGfzV20DHMNHQXII4f1K7o4=;
 b=TpZWiLUPGqDFeoXOE3f9sGJ9gZnAgtLklOJJsVzbM1LMNvujfIzId8F+YPVTbR+KejDKnRdBLtxU6WhVqVQtCTzApEMagNeRHh7PpBe3nP/uN9+4vFkteQdEW+mP8DOxy5VufAxog0sY5ZHKHtk+GR98Iqd9ouUKj+tm/iKeYPM6/w11wA7UcIYiLzwMJoCFUaVLyt6avd+b3ABnL3oITMQDZ3ja8MKwBZ0w4CZv3czlBtERkmEVgKZiXvRCr2TgBtvdqXYPNv6xMWlWOidE+ra9GTiAmxyMhDLGFn0SrbJwwJoQBz1LKqKHzliosEF+iqK3Uda/2HdEJWiglZmHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=amd.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPoWl1MY9+15FmhUDRTxiGfzV20DHMNHQXII4f1K7o4=;
 b=EPcdFMvAeuOj+tRJV4XMFjkAYufW273ciSFsytqMvXpYO5zrC9lmrle79B6xaAlpL73x/HJllYm2Sk19AEVXaLcOVglDp8w5VjkC7CrVVx/3zBQsYawth1Gjz/vkh+KDhknZRz709wVQBAZez2d2biB5FwRcyzlURjxpQdSM5h8=
Received: from CO2PR04CA0116.namprd04.prod.outlook.com (2603:10b6:104:7::18)
 by DM6PR12MB3225.namprd12.prod.outlook.com (2603:10b6:5:188::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Mon, 22 Feb
 2021 04:02:22 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::35) by CO2PR04CA0116.outlook.office365.com
 (2603:10b6:104:7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend
 Transport; Mon, 22 Feb 2021 04:02:22 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none
 (message not signed) header.d=none;lists.freedesktop.org; dmarc=fail
 action=none header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.84.17 as permitted sender)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 04:02:19 +0000
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sun, 21 Feb
 2021 22:02:19 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB01.amd.com (10.181.40.142) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Sun, 21 Feb 2021 22:02:16 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <stable@vger.kernel.org>,
        <Nicholas.Kazlauskas@amd.com>, <harry.wentland@amd.com>,
        <jerry.zuo@amd.com>, <eryk.brol@amd.com>, <qingqing.zhuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
Date:   Mon, 22 Feb 2021 12:00:26 +0800
Message-ID: <20210222040027.23505-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210222040027.23505-1-Wayne.Lin@amd.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39f02de0-7c1e-4cda-0962-08d8d6e6a6f6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3225:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3225A95C53FB37B6A1F9F7E9FC819@DM6PR12MB3225.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qWoIS6z1K0RS64aNRAXP7YTV3QK2jp/H4P9NMixnWWormmj9Co/qf8VsMlkRodhCnddBDfNoXt7NETuZ8eGggYP8zcZdpKOIMQPSdPBrBzKi4cAeHG9OOy+3RgjSmNAHbiwdvM19Ts1/nFIzCCpX4/0d62fG3SE8zrZSeD47Il1rDsmBH2C+p5Z/kDn8WlMqOp4nuwxHXXCFar2AW19oScoaXCA44p8RvjmAi/RaT60/uA05FDgrQDwJ0t9LPHOsgo0urAj7inrt1Fj/bzcwDbo+sOoMC443XCUqqQmmQkW5FPRyZ6KRM9+tWYyBX1flNR7NCJ/bzXlAQ2Rj1gqrBcRsK2mmi61F310TuYAR9DMyl9polBLWh59OvVvN80LEUY+OYbNnVjMJlO5y5Xn09B2R/MWeW+xLVNwsc07ef2kaXdqGq2Q8jno7JH7EImHndN63DL/EgKpxQwRowQtHrDrsqMXFf/96NMvTGlgTwSBYxz1/RjX7xz9j6A09GFc1eFgD4jPc15bLWEzaqI7gv+HyHF+XxcMXDAKA2uR1OPR4RObKp0f1scd95Rxqnfck66ccb8/I68uncsLBOr5dV0uINqRAo9WhqTjuWKM/vFPZIPCBVL2yCZwA+C1nrvxl/So/EmkKwr68iefBWuLeWhAFFGhJAMUTSvFX9AYIud4Yml4muwIEOl/vyNsfpAum
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966006)(36840700001)(82310400003)(6666004)(70586007)(36756003)(6916009)(8676002)(4326008)(81166007)(86362001)(426003)(36860700001)(356005)(8936002)(26005)(83380400001)(54906003)(47076005)(2906002)(316002)(478600001)(70206006)(1076003)(5660300002)(4744005)(2616005)(7696005)(186003)(82740400003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 04:02:19.7543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f02de0-7c1e-4cda-0962-08d8d6e6a6f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3225
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why & How]
According to DP spec, broadcast message LCT equals to 1 and LCR equals
to 6. Current implementation is incorrect. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 17dbed0a9800..713ef3b42054 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2727,8 +2727,14 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
 	else
 		hdr->broadcast = 0;
 	hdr->path_msg = txmsg->path_msg;
-	hdr->lct = mstb->lct;
-	hdr->lcr = mstb->lct - 1;
+	if (hdr->broadcast) {
+		hdr->lct = 1;
+		hdr->lcr = 6;
+	} else {
+		hdr->lct = mstb->lct;
+		hdr->lcr = mstb->lct - 1;
+	}
+
 	if (mstb->lct > 1)
 		memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
 
-- 
2.17.1

