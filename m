Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD643323A59
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 11:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbhBXKTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 05:19:01 -0500
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:54791
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234806AbhBXKS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 05:18:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXQ9BOGpRLl+N0WmVNabjs8Lx6wyxMPl0GcH6X/jiEqMaol2926hxXch12zgLrSZPHY6GUo1l9Yn4qlQF5Eatb6UpYONuARpGueiYfzxMpVd7tn28jro2ebfK/m88rToYV9f5sAgocgJxJQL/BeO3Ne2payiuSr41SwQhKjmteFpG+5NSHBkel542KVQWfcGMG+oZh/gnGUVRD2/p40S9Pjmw6b56kh1v105ygnFtGfHFLLSCt58F74x/RMtufkCdM2eDSzGR+OJMBxWAIcnKHI9HxCQSmVqrfIn7mScLSouoV2VC92W5aRDMvcgmFEwEraAhmVu+hhdmZN3PPvBhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfAGH/InJNV4Axu7T4UHZ97O/YdkgGJ0McbrJgl2qxk=;
 b=f/do/eXMHb1vVhyCwNRJxJz3jpOV1jv5tIbqvNHnMuHzrd7JAW0CjjsxqZNHkTLhrUrjDivkPRmjMMsjA3C0Rajg07stX9XTRJXXR8CkfDhrCU6tT9kgqC7Eu8hxXCszGYaU3/bqVLXtpt/GjcU85TGDJzz/M21m1vf3Kjc9628xA5zdi7+33Vn2awmkrzTplTT4IbsI9ObwySiqNhmiLRLb3lIgkQnpZip4OZ5xLXV36+O9Brnbk5XwIKEYcKerzgjhxYw4rTi9YVT1T9jyUMRFXKcBp1NkyyM2KzhJUnjlQbJVQ3HGqRGht7wN93Ee1zAhzKuopYAYLt3sgdJCVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=amd.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfAGH/InJNV4Axu7T4UHZ97O/YdkgGJ0McbrJgl2qxk=;
 b=c2fyfXFHmq/Zo+aS0wNNLGpq7ZxOZSkqJq5CT7ZehdtHFxhYr7T8xmYdGE0czE3jwKgeJqo+3nl3mztM4bVKwV0aok90b5pu/LuR9U/2AhSDjgTT+4hr/v+qIPoDnMnTbc7LQrUwSv4oeuQFAti8dRuQz0Ft14TniqAhzMYM9t8=
Received: from BN6PR2001CA0022.namprd20.prod.outlook.com
 (2603:10b6:404:b4::32) by DM5PR12MB1610.namprd12.prod.outlook.com
 (2603:10b6:4:3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 10:17:07 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::85) by BN6PR2001CA0022.outlook.office365.com
 (2603:10b6:404:b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend
 Transport; Wed, 24 Feb 2021 10:17:07 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none
 (message not signed) header.d=none;lists.freedesktop.org; dmarc=fail
 action=none header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.84.17 as permitted sender)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 10:17:05 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Feb
 2021 04:17:05 -0600
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Feb
 2021 04:17:04 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB02.amd.com (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Wed, 24 Feb 2021 04:17:02 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>, <eryk.brol@amd.com>,
        <qingqing.zhuo@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH v2 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
Date:   Wed, 24 Feb 2021 18:15:20 +0800
Message-ID: <20210224101521.6713-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224101521.6713-1-Wayne.Lin@amd.com>
References: <20210224101521.6713-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b31f797-6079-4d02-33f4-08d8d8ad55ec
X-MS-TrafficTypeDiagnostic: DM5PR12MB1610:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16108A89BCCD78C299447133FC9F9@DM5PR12MB1610.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: blsKVezJLOyhvXtRwsGFaLIoZgwcfIGFwPppk1Cs0P3SSwbsOXwyzUbn1rfqqaPOQazw8bls+722lEb5OTNAUcOAYiIIESao36Dm9QluzcWGXLsS8Bu2LBwMJqAe0ziLmmRc7IrcUfdfw+gGXMojcd+SN7ekUh4yy1gqu8XHzA2r6zpCsrs02iqT5cf8dg8lm0Sf6LkR0CjLQqz8xFvYxbQX1NWyHz8+hvyvpSojoURVl/8UoLkxX1o8ryiZOM1VvcGOAyXdxoeHMDKW6L4zdkPYA3QSCbieHvewlVH2XJhCfkrjz+KGtQ4jk7QjLrM+rruYmEswGe9E4zQSZWp5iBlarj0zwNpgb3r6Dlmi86OquWRz9UxtstSh1e26Xq93QLAXxMCBgf0aYoWpt5Dugjy99tNwOMhPJ8kZGrB5tf++IAplnzaZYxt+5GbWY0iYhs7uaxmGUKb+AVPQyDCELulH9fTJM89pX5KKSIxEcGBAFFAPtWHb9uHZRB7ceNbX7ax16AjJefJzeosfZ6hzpi49aHgRt4to1gI/oFCvL7qlvTSOaWn7j8S8goWuPCZjB5cR55nm6HGGfVq5B8Do0T9DIevRcts3y9vxTXDJtkf7rJPaOdoIAY3U9ijmuyVqc6eWf62kuoOsu3zGleHOlM9NQCRCE4+yli0kULlPjyxmn/DUMjIBSbgn3Z2aCku0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(46966006)(26005)(36756003)(70586007)(478600001)(5660300002)(186003)(8676002)(7696005)(1076003)(36860700001)(6666004)(86362001)(4326008)(426003)(336012)(82740400003)(70206006)(54906003)(316002)(2616005)(81166007)(2906002)(356005)(6916009)(83380400001)(47076005)(82310400003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 10:17:05.4860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b31f797-6079-4d02-33f4-08d8d8ad55ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1610
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why & How]
According to DP spec, broadcast message LCT equals to 1 and LCR equals
to 6. Current implementation is incorrect. Fix it.
In addition, revise a bit the hdr->rad handling to include broadcast
case.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 17dbed0a9800..f11b3f718031 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2727,10 +2727,15 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
 	else
 		hdr->broadcast = 0;
 	hdr->path_msg = txmsg->path_msg;
-	hdr->lct = mstb->lct;
-	hdr->lcr = mstb->lct - 1;
-	if (mstb->lct > 1)
-		memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
+	if (hdr->broadcast) {
+		hdr->lct = 1;
+		hdr->lcr = 6;
+	} else {
+		hdr->lct = mstb->lct;
+		hdr->lcr = mstb->lct - 1;
+	}
+
+	memcpy(hdr->rad, mstb->rad, hdr->lct / 2);
 
 	return 0;
 }
-- 
2.17.1

