Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285F012A9C4
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 03:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLZCdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Dec 2019 21:33:08 -0500
Received: from mail-eopbgr690064.outbound.protection.outlook.com ([40.107.69.64]:51543
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726896AbfLZCdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Dec 2019 21:33:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myJD31zXjwXMk1QCNu3WlZ4Q0ws3PD/iQywMaPvi62v7XKBGOy5dpGZU1hcaF+1Cdny8s28Ix6AEKFmO1IQ8w3A+wVonTPleUvyhCLoWu/nwUVdYjSRateakQi8Q7Fb6Zr9GTgeRXzgfx7hZVWyx18VSGwC85iGZZ1LxN3DOFqEINXc6wMSptFxzpdsa9xp+c2v+BKRAnqC2AMIbxQ9KmkmhUmpRnUvdRuCmSSxLb7tH6akMTU5CKQUio2omkuwpfOw5AIL20MA1ZX8Pcq2TrfUCwZZuKwxTmvhrQGZVvp2Mq4AeoJE8QIm6FTEbdleERUe/XzCUZOeYbQfuW/kefQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1PNjT3OUDojEhmKFaN6WPvjsg1vV2p44xxhmiTQx4w=;
 b=fZ582mch71Ngzp2jSKL6i6uD8b5tUC2Hv5WvBR0Fw42EuqanNI61CMN5itxX5f8ERzhQiNE/FVI+qJcCEkvt9tl7Nepusd7t8BK3L6WLNrghTc9uOQiMVwTstxdMq3OcFxuPWkl14J/WtshZE00GfwOu4KSGS+n6j+UQUC94Z0YNpy3dfOGFT09VAoR+Q1JQ9SIgRby24jIzHW1YK6lxKkcFUtyD1aXhWvV1Q4uf8+wNNYBJo7+TLP4UDyR9PSFfdxetjCynh9jff221XMmYkmk0y5oCWMgJxt6OHv2QTdHguPnOSTJeyo0x4TXoyqzdDeJcitgpMWVgbYOi4C2xQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1PNjT3OUDojEhmKFaN6WPvjsg1vV2p44xxhmiTQx4w=;
 b=nXlBmGxoJH8WaratXGBPq7edq20DdR5X20JzYPr6oyG9xuCjufHg3avXs6wgJAqxE2XgRV0hR+1dl5JgWSVXAFlGFB/UZR7mMACvlaFIFgUzjAUs0WFvYgBjVcVZWmn/de0fMQg49ORj+Rz/Lccjl3AEYAeCigk2lvdRBse12Ng=
Received: from DM3PR12CA0093.namprd12.prod.outlook.com (2603:10b6:0:55::13) by
 DM5PR12MB2342.namprd12.prod.outlook.com (2603:10b6:4:ba::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 26 Dec 2019 02:33:04 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eae::203) by DM3PR12CA0093.outlook.office365.com
 (2603:10b6:0:55::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.15 via Frontend
 Transport; Thu, 26 Dec 2019 02:33:04 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2581.11 via Frontend Transport; Thu, 26 Dec 2019 02:33:03 +0000
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 25 Dec
 2019 20:33:03 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB01.amd.com (10.181.40.142) with Microsoft SMTP Server id 15.1.1713.5
 via Frontend Transport; Wed, 25 Dec 2019 20:33:01 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>, <amd-gfx@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <mikita.lipski@amd.com>,
        <jerry.zuo@amd.com>, <stable@vger.kernel.org>,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH] drm/dp_mst: Avoid NULL pointer dereference
Date:   Thu, 26 Dec 2019 10:31:51 +0800
Message-ID: <20191226023151.5448-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(428003)(189003)(199004)(86362001)(1076003)(316002)(2616005)(54906003)(6666004)(356004)(36756003)(26005)(5660300002)(2906002)(336012)(110136005)(7696005)(8936002)(186003)(426003)(81156014)(8676002)(70586007)(478600001)(70206006)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2342;H:SATLEXMB01.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7705947e-f40e-4639-e83e-08d789abef03
X-MS-TrafficTypeDiagnostic: DM5PR12MB2342:
X-Microsoft-Antispam-PRVS: <DM5PR12MB23425A1CE3F0FF9FDBC3F376FC2B0@DM5PR12MB2342.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 02638D901B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Cm4Q4UF+ydBe17Lz27nul5jAcRVKQVK6ml4pohsIkIjbAn9TV9sPI9p1A2pVRvYcAmyFrc23i6OkwsWSqhKHZVi2CPoGPsBdae2Mt0pga/yfT0OpwjcHp5Fp7gxJVRg3yu8iEG8aFyz0XFLUPzo9HgTnJ5HGx+CsXwKpD/P5kwjSu+7rcUP1xn7DeytJGjw2Xt/7k9LmefdiENrgKxuweVXL3QVSjrwDGPLmh55VBgHlCSKPNieUegu46FLyFvFyJloFz40InxJQ1S3iWm6k/F37+9YlrwyrqU5g0KQuTd0xvrC5y73lTUIuuF/QsFcvPSeiQBsAepCM4F9WAapk7vdn9BPgdIMRbTtYZJUTtjEhtRQUz0M3qwuLq9IYnSiTDAlXpkZwEFrCbievYZs6vTTTsJucz15aCjUAMbcF9nIpZj3l9ixvzHsO7bAYqbV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2019 02:33:03.8217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7705947e-f40e-4639-e83e-08d789abef03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2342
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
Found kernel NULL pointer dereference under the below situation:

	src — HDMI_Monitor   src — HDMI_Monitor
e.g.:	    \            =>
	     MSTB — MSTB     (unplug) MSTB — MSTB

When display 1 HDMI and 2 DP daisy chain monitors, unplugging the dp
cable connected to source causes kernel NULL pointer dereference at
drm_dp_mst_atomic_check_bw_limit(). When calculating pbn_limit, if
branch is null, accessing "&branch->ports" causes the problem.

[How]
Judge branch is null or not at the beginning. If it is null, return 0.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 7d2d31eaf003..a6473e3ab448 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4707,6 +4707,9 @@ int drm_dp_mst_atomic_check_bw_limit(struct drm_dp_mst_branch *branch,
 	struct drm_dp_vcpi_allocation *vcpi;
 	int pbn_limit = 0, pbn_used = 0;
 
+	if (!branch)
+		return 0;
+
 	list_for_each_entry(port, &branch->ports, next) {
 		if (port->mstb)
 			if (drm_dp_mst_atomic_check_bw_limit(port->mstb, mst_state))
-- 
2.17.1

