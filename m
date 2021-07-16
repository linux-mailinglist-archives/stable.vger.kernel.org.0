Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F5E3CB368
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhGPHmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:42:53 -0400
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:50401
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231966AbhGPHmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:42:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJeXWMrSdvFcf0WbkGthgxanttO/qeGWyg6u1Vz6v+XwXiNUOrH00hlUugxg0H6hiTgr718vJZ1z2hHH7NP2viWU/+W/+BY3YDkEaS+p+U6wdp1pVJy64ddHPWEScwGx1hGv5hRAHYMvsHOdt5tVuV3SYsDgVPOLFQhIcWlodEn8P0aSVnxyUxmv+RnIyGlo5Kmp0ZuHv4eZebbAWiuKLdy2gspqQZA03g8VeRnyoUWCS7biKusRkwDa6P6oqRigb5YXiVG1CwzwdACOuYjzGuHJYNVI/fa7OkXjEbZMiMsdOTI0cCQ+Mpok0mdVor0NDb1hv5cOAN40JMuorXvY4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhtGvcuU2SdSFx1Sny8kOF31+LtWoW/Csa9MSf5IzY4=;
 b=XP3x1yumR1/HAnHwHki92vkKsYmE2IR6KrUQEaphwauQHcofio8iAR0cvZzBgy7FCxP52GAsZmpiz2HlaE4GSlgzsp7ty9mmRGMu3lQ0cDcYiknkQ/z1gy9hu0kjcFK1MvT1TnWuItSXpQgUiLCJvt5gOVf1osMf0g/z+nFzSAYkDBzp8/vMu4RymWdcV3Dwq1V9xi8lyXhy6NmO4jn1l9PEvyXjnDTPNQ+1kbS78uzG6FhlQU88hG7GX+QIEaiV8L5Rud/8w8mJeWzoSK6DMXD+/aVbQOC8rCumPbEZjM1+SrU+lBNRyoL/ridyHgR2zxCaeXsbqVq/dMtMrksGOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhtGvcuU2SdSFx1Sny8kOF31+LtWoW/Csa9MSf5IzY4=;
 b=nUUIR3tD6H6WXozHW7SYUOAW4MUp93CA4y6cAXnI+Dku6wIOz5PUqisv6uja8grYy3z5y/+IWduh4iNuKSF5YXBudjyhZtoBvpPlSCCCkdL9utUARUXj9XunYsLjE/Nn2vh5oY9mowcaNKxnDBl3hk+i0A0z1YP1psPD6oe/CZ8=
Received: from DM5PR18CA0090.namprd18.prod.outlook.com (2603:10b6:3:3::28) by
 DM6PR12MB2620.namprd12.prod.outlook.com (2603:10b6:5:42::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21; Fri, 16 Jul 2021 07:39:56 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::a) by DM5PR18CA0090.outlook.office365.com
 (2603:10b6:3:3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Fri, 16 Jul 2021 07:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:39:56 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:39:54 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:39:54 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:39:52 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 1/3] drm/dp_mst: Do not set proposed vcpi directly
Date:   Fri, 16 Jul 2021 15:38:29 +0800
Message-ID: <20210716073831.27500-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716073831.27500-1-Wayne.Lin@amd.com>
References: <20210716073831.27500-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 665ad1e1-8cd0-4b06-ab6a-08d9482ce838
X-MS-TrafficTypeDiagnostic: DM6PR12MB2620:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2620FCCA09F381C2EED63756FC119@DM6PR12MB2620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EvbF9YDvJq/1pXiQItmOHOU952vgqpfC33oqirpMMC+9R87WeQ2WM621VNibgBlJT6LEHLtflOcTX76B37z9grMgRla09p88JAwfUQg35nXvNurryL4YOhy+R+X0EwLzuYXh9hSfHpPnNG4v3AA0NIBxBpqqsiXImAZl2o+M3+0XXSNGcim8zwXAQePQ+p5m/rvJGlAsrkr8Wfy5cKvCJkH8u4u9LfkSFZHE7xSoxNfycSQDX9zlQ/AYgnqAGQp2Zey4Piqw4mBU+pYjAsdKyZRl3tgeO00Es0+hCY2fM5bHHDj+pQY9thI0Y1p9f01WtyJm7uvsRa55O53c6K1x+KGsTH9nHdYdDP2waxD8tUscKmOy2sBRa1YTrG3JXBQOc01p/L1Gn3Y5kU+yqpRURstaM3/99Lq2wQuONeJcDdxv7ezKox8BdKbK4jSpwAbYqs5hslsbSL/e6x4kXXAchvxajT6A5jTBsoC95svZq0cul8Gy8QkfhSOUCxJII52ARYwSNWJ0krrRciCLbugeBliguFx7qsIsbQhansWAvw1jvf1tiEKFIDrYFUU8lBbkKv/+8XCwQKYn32Y1HwpHTtJtSvLu7D+D4YsBh9Rv275wtA9LCtb40mpT8sDk7wfzepD25WkWQSzyF3XpkVawTcT5Fmdp4ED8TByk3Z3I1uegLGx2fe0K8pwIuo2Zb7f8ZxeYJblQlzlrm3UEv6l41SmpHlIVd1W2rsJ9mShaN+0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(46966006)(478600001)(966005)(426003)(36756003)(336012)(4326008)(82310400003)(36860700001)(7696005)(186003)(26005)(86362001)(2616005)(82740400003)(54906003)(316002)(356005)(5660300002)(6666004)(70586007)(110136005)(70206006)(2906002)(8676002)(83380400001)(81166007)(47076005)(1076003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:39:56.0325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 665ad1e1-8cd0-4b06-ab6a-08d9482ce838
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2620
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
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616035501.3776-2-Wayne.Lin@amd.com
Reviewed-by: Lyude Paul <lyude@redhat.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 36 ++++++++-------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 9c75c8815056..41d790df81bb 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2499,7 +2499,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
 	struct drm_dp_mst_port *port;
-	int old_ddps, old_input, ret, i;
+	int old_ddps, ret;
 	u8 new_pdt;
 	bool new_mcs;
 	bool dowork = false, create_connector = false;
@@ -2531,7 +2531,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	}
 
 	old_ddps = port->ddps;
-	old_input = port->input;
 	port->input = conn_stat->input_port;
 	port->ldps = conn_stat->legacy_device_plug_status;
 	port->ddps = conn_stat->displayport_device_plug_status;
@@ -2554,28 +2553,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
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
@@ -3406,8 +3383,15 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
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

