Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7C0113D78
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 10:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfLEJBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 04:01:37 -0500
Received: from mail-eopbgr760082.outbound.protection.outlook.com ([40.107.76.82]:11297
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726096AbfLEJBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 04:01:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bR4dlc3pglR6dLuR+c/yaz7fPS5X2CFKpZZOPk8JwJwZmVgjz4qTKzaM87hcUTH3aKb/A3kRBeO5PGfF7VJjCp4yt0mQNdO1KTpYEom9baNIg49QPBhh6YZCk7VjBnmzxi0B93OZ3T2KpDr9uEfNgRy/UmitcDA+l+a1ghOtPR7ZCW8B563WqRIcX+TeLvAuVIbGWBdUJsMgXlBhsQ/U73fIgCdgAG3P4GwbQz3yzA0DaDX1REyPUkEEepuJaJwQGYV3rTxzhlVpm7tLDscFzunktSXS/UTwD1SEeynoV5/iQ/UJYmpprwc1vYyM9QvMJ+uKwJ+AjAZdgcQNQDzXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdFr6837ay9GVGu4ppW1TvFtsVwna6j2PxUPEW9dbI4=;
 b=GtpycWjpGMFCC18LLaJIvDLvCmBLoJJGljbfNMiSaRIuvoDCqUh/0R18bXR7luS18srO8vwzjUw6LzMB7u9dSJiai8kVp3dw9wGiYrF6LwV59Z9DZIoJjV/W6MAyLeniB31pTq74TSX1kZe+o1SEJK2kxjF3t+zi5ZkX3ewLiCAAf3dhH/f3ldpZCrXvHIZrbDNT6/MztSgufUNBwTWnjiumi2vIlmT7iCsTgoAB0HxazXgf0gW+4jvTYyEv0dHn7mFce58iR5MLuixwn9714RHlCJfJb7B4ztxZvzzC67BHhC/yKQuzsG2zcuxHKtFVTYevLcZO12eTaz4AQbdPng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdFr6837ay9GVGu4ppW1TvFtsVwna6j2PxUPEW9dbI4=;
 b=N39/J981y635pBN4yG62PlLzIbfTQJUlHFMU7mexgJRsPmWdpbGXRKKYnZf2CV5HLCEvwqmoKjIQwVJlKZqJmksBe4aJhhjsimA1ZcEkODH2ngHUky9nQDHribG43Y1R5HRDvi5Nh5sTFn3DEvFMPfLcXK9fqitW/oTtjYxp8/A=
Received: from BN6PR12CA0030.namprd12.prod.outlook.com (2603:10b6:405:70::16)
 by DM6PR12MB3786.namprd12.prod.outlook.com (2603:10b6:5:14a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.14; Thu, 5 Dec
 2019 09:01:18 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eaa::206) by BN6PR12CA0030.outlook.office365.com
 (2603:10b6:405:70::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.13 via Frontend
 Transport; Thu, 5 Dec 2019 09:01:18 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2451.23 via Frontend Transport; Thu, 5 Dec 2019 09:01:18 +0000
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 5 Dec 2019
 03:01:17 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB02.amd.com (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 03:01:15 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>, <amd-gfx@lists.freedesktop.org>
CC:     <Nicholas.Kazlauskas@amd.com>, <harry.wentland@amd.com>,
        <jerry.zuo@amd.com>, <lyude@redhat.com>, <stable@vger.kernel.org>,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
Date:   Thu, 5 Dec 2019 17:00:43 +0800
Message-ID: <20191205090043.7580-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(428003)(199004)(189003)(2616005)(426003)(53416004)(51416003)(7696005)(1076003)(4326008)(14444005)(50226002)(305945005)(186003)(26005)(478600001)(336012)(36756003)(16586007)(54906003)(2906002)(5660300002)(48376002)(110136005)(81166006)(81156014)(8676002)(316002)(8936002)(70206006)(356004)(6666004)(70586007)(50466002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3786;H:SATLEXMB02.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 702d6a9d-542e-4c89-9252-08d77961b0cc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3786:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37863F64909420F4E8B76FFAFC5C0@DM6PR12MB3786.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 02426D11FE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: loDQL3WHreVe5duDJXX5v2aUSlsTHz7u4rHWMiET8n81481+hd2BeYcM6uzq7cUOhWbc/06OvGWLtpzJ2yc9k429dIhvmYa7CKMFg7EHF/ZPMw/otjzNjrjAVvUha0Ef2IfGnIykCKp1GCtXH2PaO/SaW0ctYSRJOBSePXoDMTChVB/EaWlwe5idYjJd4m4hi13mvInUWfGr96scdAdH4R+TFuBN/f0RBa9s2XWMy80NhT23FHKuZ9dCAey/ilDxt3gfd7kkcieVtY/F0uPhM3e3VA2P7OUUtzHBKgkxukzUyvqLg3OLNYTdYsrReV77959xLtJN5owbmqT6xiuMwDzeJNkQMxCSJ74jE6KFZaQx2cY18vlysbH5DflKEe3tGdJvIcyu0xS2XH/TlXxzYzryZxbUu36ZeNsFJOw2kFygNauBmWeuvIRIuzXIxDBr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2019 09:01:18.0269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 702d6a9d-542e-4c89-9252-08d77961b0cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3786
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]

This patch is trying to address the issue observed when hotplug DP
daisy chain monitors.

e.g.
src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
(plug in again)

Once unplug a DP MST capable device, driver will call
drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
it cleans data of topology manager while disabling mst_state. However,
it doesn't clean up the proposed_vcpis of topology manager.
If proposed_vcpi is not reset, once plug in MST daisy chain monitors
later, code will fail at checking port validation while trying to
allocate payloads.

When MST capable device is plugged in again and try to allocate
payloads by calling drm_dp_update_payload_part1(), this
function will iterate over all proposed virtual channels to see if
any proposed VCPI's num_slots is greater than 0. If any proposed
VCPI's num_slots is greater than 0 and the port which the
specific virtual channel directed to is not in the topology, code then
fails at the port validation. Since there are stale VCPI allocations
from the previous topology enablement in proposed_vcpi[], code will fail
at port validation and reurn EINVAL.

[How]

Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().

Changes since v1:
*Add on more details in commit message to describe the issue which the 
patch is trying to fix

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ae5809a1f19a..bf4f745a4edb 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3386,6 +3386,7 @@ static int drm_dp_get_vc_payload_bw(u8 dp_link_bw, u8  dp_link_count)
 int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool mst_state)
 {
 	int ret = 0;
+	int i = 0;
 	struct drm_dp_mst_branch *mstb = NULL;
 
 	mutex_lock(&mgr->lock);
@@ -3446,10 +3447,21 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
+		mutex_lock(&mgr->payload_lock);
 		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payload));
 		mgr->payload_mask = 0;
 		set_bit(0, &mgr->payload_mask);
+		for (i = 0; i < mgr->max_payloads; i++) {
+			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
+
+			if (vcpi) {
+				vcpi->vcpi = 0;
+				vcpi->num_slots = 0;
+			}
+			mgr->proposed_vcpis[i] = NULL;
+		}
 		mgr->vcpi_mask = 0;
+		mutex_unlock(&mgr->payload_lock);
 	}
 
 out_unlock:
-- 
2.17.1

