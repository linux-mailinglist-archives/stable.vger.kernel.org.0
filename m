Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5473A902A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 05:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFPD6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 23:58:00 -0400
Received: from mail-dm6nam08on2079.outbound.protection.outlook.com ([40.107.102.79]:39361
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229931AbhFPD57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 23:57:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4mxiXDJfr+ZlpNDoXN+YOnf8gX5HbZZgZ9ykFnKDI3vWwx8TveLvUeVpTIy+c9CV1ZRuVrQBTqWoOjCMcrb33l3Dyzyq+lDBmgM8NB2RfA8TRAh+7dwxzsdM0hYoIgaSbFeqEwZ4zGMdNASij3l6Lo7cXr+D5AeI4Ifq9g3KrXRTXyRdqlqEuqDPS9iZ6wkOUHSOyuBzsTFnJ8XwYRT4qELb6chv4A++faSbkxAJh0FUeSTvCzPhKHviFn3sHO3O3Qt2Ci9x+MNsXF/zgJMf/IktBHUj7zb9KUZ/tYurHZeq7p0BcugZ2sGmh+RcFrqc8Wht/Aa6EY95+sdafp4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP1kudVf23kPjyJr2s9qVOX6XyzRFbMrmLQ3IsFonR4=;
 b=ExQpMXYwGyGA+e6MSpPo3y3z8ja7/aa1eRcO8GCbd1Zt208ai+49YI1csxZRavhFUIJlNefpmYL2WLdMq4HpKQSePu3ofV+LiLVN/B7UI346MlLmiC7APSGKACPVmfpBOgJMhS023i2glQ7vBKtYhOYNAZAafeCkR4itm92FdlN3x9wplAe3Wtn2MbYIbIELdh8e7oixZ4+hSI4kjmiI4ih0yt/Riz+PJqM+Oeqzv7y1vVxjiTMIQB+bZr6c2kjnPcB4dzkZiVfg35Tt98HcsSbe0abnVAe5a1NpX04UEzrvjA8TfTViQ6hBXIbmWkYz0nSJDO5ud4PGQ4qAOGsU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP1kudVf23kPjyJr2s9qVOX6XyzRFbMrmLQ3IsFonR4=;
 b=FxQsTiyVXyb2w08yrAp0uKiyqRGPsfxZcfv8tIuJ2mEsF6tTbEDUswQ8+N8gMTHha81K7TNABMoWQRz5bY4Jru9AFnb5+7UVe3RTorHEfHUHlIrdOTmJHnP2U/UsfDFW/KOQdJRdO0fOr/vGCDVNtgUDuJ6ymGHT6dU3xDBHEWY=
Received: from BN6PR1101CA0013.namprd11.prod.outlook.com
 (2603:10b6:405:4a::23) by BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:55:51 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::5d) by BN6PR1101CA0013.outlook.office365.com
 (2603:10b6:405:4a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend
 Transport; Wed, 16 Jun 2021 03:55:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 03:55:51 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 15 Jun
 2021 22:55:51 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 15 Jun
 2021 20:55:50 -0700
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 22:55:48 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        <aurabindo.pillai@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] drm/dp_mst: Do not set proposed vcpi directly
Date:   Wed, 16 Jun 2021 11:55:00 +0800
Message-ID: <20210616035501.3776-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210616035501.3776-1-Wayne.Lin@amd.com>
References: <20210616035501.3776-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a86e3b4b-97be-4ca3-57fa-08d9307aa235
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51762F141C7B1D3DE3936F07FC0F9@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FPWHemCr0nXGWtixQ2/Es/exOC52mKVP4edTQCSYtS/tjn7FDtp29fw/WCIITCDhFwZtjPJt+tZfHABFuXDa79CydA7Bewrq7KTOILmcV5U8LMYyRkUOOtyq39q+nD+OyfatKq6vlPO/as1QN3j+8wGtDWA/BNS67QNL5xM0FVSbAtNtiZWYc18GqssLjDC03SkLs834kJ+OAcnFF63hoi5GIs67cukseWFc5UDYXLCWfxlTgKkfZ9JR9+6hU4cTtio9WgmIkAeh0CNVBkd2t3aLmrCZ5m1WEY8jVVNUUhAp22VYbzwxVVz1ldf/CSHHVA3V24QJsWHzkpshK0Uz1HN+yTO1mdIXUXFs94BTtCFM3z5WkKcN2YtRMdmWmRXSozSK2G/7MzyFTyoQI+JQ13jUZFGsddm+YgkhjVr5UGtw68p8VHRJW1rHkgHxSB+rAB63vjxq9hjHD/BtO/bOL6LK+e9IrK1DL4qT4Qn5jyA1Fk3XWKtLZKk02gGHYyWMVNpiuZBz5T2LyewDkCwlL7cWozZhelhmS8d7F71WfvClFha/gn/jMoMBdZWkp/VLTMKyGPny/GdIz1Wzo+3UF33B2cscq8dK0fPrZt9OURVzXIOR9Yie5n7277BRRu1APRvU6bKaj+Gy124u4vSrXR+Ba43z4tBIeVM1OXhHZ7tiipp1I54TYQ8Z+XAJjP1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(36840700001)(46966006)(70586007)(6666004)(316002)(356005)(186003)(1076003)(47076005)(478600001)(26005)(81166007)(70206006)(2906002)(82740400003)(8936002)(426003)(336012)(83380400001)(2616005)(7696005)(5660300002)(82310400003)(4326008)(54906003)(8676002)(6916009)(36756003)(86362001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:55:51.4744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a86e3b4b-97be-4ca3-57fa-08d9307aa235
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
When we receive CSN message to notify one port is disconnected, we will
implicitly set its corresponding num_slots to 0. Later on, we will
eventually call drm_dp_update_payload_part1() to arrange down streams.

In drm_dp_update_payload_part1(), we iterate over all proposed_vcpis[]
to do the update. Not specific to a target sink only. For example, if we
light up 2 monitors, Monitor_A and Monitor_B, and then we unplug
Monitor_B. Later on, when we call drm_dp_update_payload_part1() to try
to update payload for Monitor_A, we'll also implicitly clean payload for
Monitor_B at the same time. And finally, when we try to call
drm_dp_update_payload_part1() to clean payload for Monitor_B, we will do
nothing at this time since payload for Monitor_B has been cleaned up
previously.

For StarTech 1to3 DP hub, it seems like if we didn't update DPCD payload
ID table then polling for "ACT Handled"(BIT_1 of DPCD 002C0h) will fail
and this polling will last for 3 seconds.

Therefore, guess the best way is we don't set the proposed_vcpi[]
diretly. Let user of these herlper functions to set the proposed_vcpi
directly.

[How]
1. Revert commit 7617e9621bf2 ("drm/dp_mst: clear time slots for ports
invalid")
2. Tackle the issue in previous commit by skipping those trasient
proposed VCPIs. These stale VCPIs shoulde be explicitly cleared by
user later on.

Changes since v1:
* Change debug macro to use drm_dbg_kms() instead
* Amend the commit message to add Fixed & Cc tags

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Fixes: 7617e9621bf2 ("drm/dp_mst: clear time slots for ports invalid")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 36 ++++++++-------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 32b7f8983b94..b41b837db66d 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2501,7 +2501,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
 	struct drm_dp_mst_port *port;
-	int old_ddps, old_input, ret, i;
+	int old_ddps, ret;
 	u8 new_pdt;
 	bool new_mcs;
 	bool dowork = false, create_connector = false;
@@ -2533,7 +2533,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	}
 
 	old_ddps = port->ddps;
-	old_input = port->input;
 	port->input = conn_stat->input_port;
 	port->ldps = conn_stat->legacy_device_plug_status;
 	port->ddps = conn_stat->displayport_device_plug_status;
@@ -2555,28 +2554,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 		dowork = false;
 	}
 
-	if (!old_input && old_ddps != port->ddps && !port->ddps) {
-		for (i = 0; i < mgr->max_payloads; i++) {
-			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
-			struct drm_dp_mst_port *port_validated;
-
-			if (!vcpi)
-				continue;
-
-			port_validated =
-				container_of(vcpi, struct drm_dp_mst_port, vcpi);
-			port_validated =
-				drm_dp_mst_topology_get_port_validated(mgr, port_validated);
-			if (!port_validated) {
-				mutex_lock(&mgr->payload_lock);
-				vcpi->num_slots = 0;
-				mutex_unlock(&mgr->payload_lock);
-			} else {
-				drm_dp_mst_topology_put_port(port_validated);
-			}
-		}
-	}
-
 	if (port->connector)
 		drm_modeset_unlock(&mgr->base.lock);
 	else if (create_connector)
@@ -3410,8 +3387,15 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 				port = drm_dp_mst_topology_get_port_validated(
 				    mgr, port);
 				if (!port) {
-					mutex_unlock(&mgr->payload_lock);
-					return -EINVAL;
+					if (vcpi->num_slots == payload->num_slots) {
+						cur_slots += vcpi->num_slots;
+						payload->start_slot = req_payload.start_slot;
+						continue;
+					} else {
+						drm_dbg_kms("Fail:set payload to invalid sink");
+						mutex_unlock(&mgr->payload_lock);
+						return -EINVAL;
+					}
 				}
 				put_port = true;
 			}
-- 
2.17.1

