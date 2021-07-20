Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B503CFEA8
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbhGTPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:47 -0400
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:49088
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231994AbhGTPZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 11:25:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzUUToDaQu7IiX3fFr3juviuZ5qMCB0JEo30nM+Cn6ABlkOVmE/dujD8zKSdNbGq3R4PH+FrX20wft0XIyXheyZbOOKxlIO+yrT9+3lLlbRFFqIjDiVlBnBUsfLlqH3E5zLD6RwXO9c18qAdRoHatBj3WoW/YcU9KpIQ1+GM6R9TN3Qp6OhZQdR9FDz3dZPzYH4V9dOoHGZoOsefXBoF/5QrBkQq6IiGKgm+zAt2CAKxkYH4S6FKBOKSo52f43kFL8AKqOqUkCe3wAC/WnQmwVM1t3q0LasG4T4LM5bkwoVsCRsJVIFpHktjWWnpep3tKc7G39nUOCKTVNPHluTqaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUx3xJryiElpCd2Vfr3UJIk072flXKARwVt2myM4U14=;
 b=RlFdV4ExChKLDDqWts5Lw5Wv+a0x/CCBFuS8zOBna4TdLvbEdNWTiHNbVSwvo2jnhvHz6HVoxgtPXuuPGtKRJYdpGPcH/51DtCn5pGj29Bmnv96r0bwzebfwwnA++s7d5JnqmZXuKVcOBS78MCQ1ZnY7GZ6vX2KcZsDHDlylOPnnE9YD4j+D6izqT1EX0KgRbTTOQaOKdQQWaBqKFmzv48n9RTGVKGU61hzoApH1aeaH84DnT0/HfUf/5i4RzKkO1JaHwbo6Hmi4pH4Y4+M/7h9srh2+E8g9sEgQ2LIfsvHFr5IsveU2V9EM/APt9DYputdYKQh+OpMG71RO5NyVnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUx3xJryiElpCd2Vfr3UJIk072flXKARwVt2myM4U14=;
 b=BtCpK0zv2tczREBCuFof4LXc6MywNTy3A2u8OlkF8IQdWKVw50g2BdwLP2Ya0ScteEFJGw20vv6xy4dhdT6DlIqVINiFZpMcdZ4aQsBQezHn9Bsor0sP7JPrV1xoQOC+ACVE9zt0LHvMVThiwuOTyHBFm8kKfaOJ3o/TzW1q6Wc=
Received: from BN0PR03CA0050.namprd03.prod.outlook.com (2603:10b6:408:e7::25)
 by CH0PR12MB5123.namprd12.prod.outlook.com (2603:10b6:610:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 16:06:09 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::b2) by BN0PR03CA0050.outlook.office365.com
 (2603:10b6:408:e7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24 via Frontend
 Transport; Tue, 20 Jul 2021 16:06:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4352.24 via Frontend Transport; Tue, 20 Jul 2021 16:06:09 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 11:05:52 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 11:05:52 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Tue, 20 Jul 2021 11:05:48 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        <hersenxs.wu@amd.com>, "Wayne Lin" <Wayne.Lin@amd.com>,
        Sean Paul <sean@poorly.run>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH 1/4] drm/dp_mst: Put malloc_kref of vcpi pointing port when disable MST
Date:   Wed, 21 Jul 2021 00:03:39 +0800
Message-ID: <20210720160342.11415-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210720160342.11415-1-Wayne.Lin@amd.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0a8d6ed-e247-47aa-1570-08d94b9849c2
X-MS-TrafficTypeDiagnostic: CH0PR12MB5123:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51230FFE1EED134163E00E08FCE29@CH0PR12MB5123.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TvEiNe09POf0c6i1lolKCK/arv7f5nkFqKZm4FQ4yowDMrQ9Z6d6cjoy245s6noWCjhUTb9GgYr1qT67uIpDZLN1iZB30fQV9etUt9iYiglBHXxxp4Hh38aI5pViuIq7LSV7KeWYWR5mPh8OquaHrWB1mzsifYEOKXKSkdS3AUq0Y27iNJ6aw55YQ+p3MMqbhTnLAN3/Qvyf+mAMrfQkKVeVvR6oqWWR/0bIql1DRXUvCINEjRiiCrTw0otLr9nf8zQm3kPFhG/5G52DmYVle+wFwNZNSa8LgKRVind0WQ45ssxtiEtsDV1JRLjh7F4aZSppfRtIeRWsOyePd84XTS0InrkQzF+jhwXoZTDYW8UTTRbOt4tfhnP1Q/vFxVw90U1usbwdoV//1qYq2mt2ob/u9Xuiq7+Bfk2QokobNHUxQCBw5sllO8qJMuod5Ak2B2pkF2UuojE1bJXkFGJRSc1DWUWhEqm5pdwbTzmImuB5oYOPNz2btT7Ix3NhH6pZohsgYtrlqTGbTHPIyNTkj898IiBSQhoGGP3i3KEgT1JHIaLiWJeOeVN/7APvqWrWLWNjwMWLLpq56eAKuB8b/OtD4jJNcPn9U5c8hOxG8Be6cOBWQ3AolXVIVEcEGj6ZO3K+ENpHV65Jzxt7/Hp3jNFg8hGAeavgkUvVS7b1Yf9gVex4mP7qw+JVuIOW1L9erpRaZmz+DzN1fnNmc5Po0ZSORBknDdfuuRjTTPbxH1U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(36840700001)(46966006)(336012)(86362001)(36756003)(54906003)(2906002)(82740400003)(8936002)(186003)(26005)(4326008)(6666004)(36860700001)(7696005)(7416002)(8676002)(478600001)(70586007)(5660300002)(70206006)(47076005)(316002)(82310400003)(81166007)(1076003)(426003)(2616005)(356005)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 16:06:09.3684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a8d6ed-e247-47aa-1570-08d94b9849c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5123
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
We directlly clean up proposed_vcpis[] but forget to put malloc_kref of
ports which the proposed_vcpis[] are pointing to.

[How]
Iterate over proposed_vcpis[] and put malloc_kref of ports which used to
have allocated payloads.

Fixes: 8732fe46b20c ("drm/dp_mst: Fix clearing payload state on topology disable")
Cc: Sean Paul <sean@poorly.run>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # v4.4+
Cc: Lyude Paul <lyude@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ad0795afc21c..51cd7f74f026 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3765,12 +3765,26 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 
 		ret = 0;
 	} else {
+		int i;
+		struct drm_dp_vcpi *vcpi;
+		struct drm_dp_mst_port *port;
 		/* disable MST on the device */
 		mstb = mgr->mst_primary;
 		mgr->mst_primary = NULL;
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
+
+		for (i = 0; i < mgr->max_payloads; i++) {
+			vcpi = mgr->proposed_vcpis[i];
+			if (vcpi) {
+				port = container_of(vcpi, struct drm_dp_mst_port,
+						    vcpi);
+				if (port)
+					drm_dp_mst_put_port_malloc(port);
+			}
+		}
+
 		memset(mgr->payloads, 0,
 		       mgr->max_payloads * sizeof(mgr->payloads[0]));
 		memset(mgr->proposed_vcpis, 0,
-- 
2.17.1

