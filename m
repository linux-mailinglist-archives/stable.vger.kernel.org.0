Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0E83CB34D
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhGPHjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:39:13 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:44554
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232012AbhGPHjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:39:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2IMrQsAJsmGz9nFg/CTfQNvsXY4eVK+J5x34ttGdblzsmzK0vpjNpfDOXs54Isy3FOXLdrT1TyIFlJkmg27h21oH3WOg91/NXIfDaHZyMXt3Kvz/DABEfBZObpv9BEX4j7mWQzrpXsTbzFh6y1mT3LafKaHN6qq8T/QdsqRwgmEsgftRQSTMFjge0JC8TUUGssqJkuqsiN1yYTYuDHq37rF7FmOPzsoT15dWI8i/wKI4fqfTGjs6Gc49JsGILPMgsbbyGtYonrtGPs1D2oY2FHBRueQUCWCsZvnbF5Yp8uGDOo7dTOJHZ55wL/DUyuztHQ3L8v+lN3zasyEpPbeOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjhTSF0by0FXfxrStOxhPjtjf4w0Kjn1UdQEBvBLOPs=;
 b=anYp9PU6DsJf+ALr+tlTL+rExNt+qOu9aCVutOSnFbm34RIy+StgDP/iu/apunTcJP+l/A/h/elkaAErv/MfagOKTeuAuCSd9J//XD/rajoCi6IiW10V3XGaY6w6tpW+ugbv1ZnuJZHzC3QNQWnAdzkV+LWdoXMbz7XvRpXfajplwghFbDjVDsOWYGoJt23q8FubOam95RtAPJIyPaJl7ANEF+yz8xsiNkuCIl4qDgjHu+8T7XInC3B2jVbJ8SAqnmldNaYJmqCC8d/C2wtUT6j6TdX1nO3G0ZgmHW9ZhnU9VUhMV/uQdsoXC1756IfA1Z0ti6PRy8CFJXgShZyO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjhTSF0by0FXfxrStOxhPjtjf4w0Kjn1UdQEBvBLOPs=;
 b=wXPW4GZSXIHh1rBmAJIX6EY6QLxuo0vYT+71LN2wsvzUj9f6angGHwT/NkuxXbRm0XLTNfEqEbBGtGSyt5VUro9Hs0Mo6nbQHmKbUCTeZS/tuYmyq11kdy9ieaSizoJdRW5BXSQMQrm+b5M3bX8cM3DQpZ+rgLdO0n86otV2EMQ=
Received: from DS7PR05CA0018.namprd05.prod.outlook.com (2603:10b6:5:3b9::23)
 by MWHPR12MB1440.namprd12.prod.outlook.com (2603:10b6:300:13::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 07:36:15 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::6c) by DS7PR05CA0018.outlook.office365.com
 (2603:10b6:5:3b9::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend
 Transport; Fri, 16 Jul 2021 07:36:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:36:14 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:14 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:13 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:36:12 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 2/3] drm/dp_mst: Avoid to mess up payload table by ports in stale topology
Date:   Fri, 16 Jul 2021 15:34:49 +0800
Message-ID: <20210716073450.26497-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716073450.26497-1-Wayne.Lin@amd.com>
References: <20210716073450.26497-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2381e4e2-157b-4754-445a-08d9482c645e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1440:
X-Microsoft-Antispam-PRVS: <MWHPR12MB14405602B6DDF2BBB9DF9A18FC119@MWHPR12MB1440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FS6ibHEUh+HdFu3tmBbt5tzLZjmhMUjb5+dMJ0BnmDST3jQYybCAAYsWPO4Lra1ETUsus2RCzr6pJuNgMF49wbDgDr+R9i3tb9Ib7yMKRAhoA3aW8mKvT0YQNJZiLGtY0iglW0mfOR4kpll+BDpUjt/A5fnqP8ep1KB1DkM/3hjaAIaMXchfbqmr/05TLdCxeWMtGuvJzBE3R4bLBqj7k9YUEH+FhFRO+8VdWg9oOgv9K9sPOqMR1zNA83vgMSG9GwJqSfxEy8RYN874fWHxHdq0K58bruiaOPWlyCNL72Iu5/q1LDPuuGEjCLi6G+l6kAJBAYwBI0SCrBmuSHiilVINt7o5leeASPO5sQEOCmRlHYRYKNC84D/LW9lmgcLxpbB1QMC9rhRuvy3e40V4MRgEDMkOq2YOKxe3Jopt89gBiWWSXri77vDEv0F/9PymJYiesR1UaNMC9bZYmVJ6fYurbao5VIWQpDrAW61035bCYR+2H/dyEN/cxFMGvWym+g5dgpfwBoadqC1cueuTgY+w/jd0H1xBoTF7efkQHdxDaLJhS/5XghMOAY91oBuLa7dumAGSlsQpuLVTiNmV1omY+zC1mkCh7sU1KW3QkPcVf8YZDnzNoJxQzlfZHxt1bAJTMEF9x9bPdZYc97aXSj/JT0P1a/YVZbvgSrLGJYFuaSUIdxwcIBeXWoH4SUPtxnJmIyvv6G/ybTb3VuJd8FaMsXfgdPy9oRm+OV/k3I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(36840700001)(46966006)(82310400003)(1076003)(6666004)(966005)(478600001)(70586007)(70206006)(2906002)(81166007)(2616005)(54906003)(83380400001)(7696005)(36756003)(356005)(5660300002)(426003)(4326008)(316002)(82740400003)(86362001)(47076005)(186003)(8936002)(8676002)(110136005)(36860700001)(26005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:36:14.8196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2381e4e2-157b-4754-445a-08d9482c645e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1440
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
After unplug/hotplug hub from the system, userspace might start to
clear stale payloads gradually. If we call drm_dp_mst_deallocate_vcpi()
to release stale VCPI of those ports which are not relating to current
topology, we have chane to wrongly clear active payload table entry for
current topology.

E.g.
We have allocated VCPI 1 in current payload table and we call
drm_dp_mst_deallocate_vcpi() to clean VCPI 1 in stale topology. In
drm_dp_mst_deallocate_vcpi(), it will call drm_dp_mst_put_payload_id()
tp put VCPI 1 and which means ID 1 is available again. Thereafter, if we
want to allocate a new payload stream, it will find ID 1 is available by
drm_dp_mst_assign_payload_id(). However, ID 1 is being used

[How]
Check target sink is relating to current topology or not before doing
any payload table update.
Searching upward to find the target sink's relevant root branch device.
If the found root branch device is not the same root of current
topology, don't update payload table.

Changes since v1:
* Change debug macro to use drm_dbg_kms() instead
* Amend the commit message to add Cc tag.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616035501.3776-3-Wayne.Lin@amd.com
Reviewed-by: Lyude Paul <lyude@redhat.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 29 +++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 702aa0711f80..01570f2549e1 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -94,6 +94,9 @@ static int drm_dp_mst_register_i2c_bus(struct drm_dp_mst_port *port);
 static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_mst_port *port);
 static void drm_dp_mst_kick_tx(struct drm_dp_mst_topology_mgr *mgr);
 
+static bool drm_dp_mst_port_downstream_of_branch(struct drm_dp_mst_port *port,
+						 struct drm_dp_mst_branch *branch);
+
 #define DBG_PREFIX "[dp_mst]"
 
 #define DP_STR(x) [DP_ ## x] = #x
@@ -3362,6 +3365,7 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i, j;
 	int cur_slots = 1;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3376,6 +3380,14 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 			port = container_of(vcpi, struct drm_dp_mst_port,
 					    vcpi);
 
+			mutex_lock(&mgr->lock);
+			skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+			mutex_unlock(&mgr->lock);
+
+			if (skip) {
+				drm_dbg_kms("Virtual channel %d is not in current topology\n", i);
+				continue;
+			}
 			/* Validated ports don't matter if we're releasing
 			 * VCPI
 			 */
@@ -3475,6 +3487,7 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i;
 	int ret = 0;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3484,6 +3497,13 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 
 		port = container_of(mgr->proposed_vcpis[i], struct drm_dp_mst_port, vcpi);
 
+		mutex_lock(&mgr->lock);
+		skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+		mutex_unlock(&mgr->lock);
+
+		if (skip)
+			continue;
+
 		DRM_DEBUG_KMS("payload %d %d\n", i, mgr->payloads[i].payload_state);
 		if (mgr->payloads[i].payload_state == DP_PAYLOAD_LOCAL) {
 			ret = drm_dp_create_payload_step2(mgr, port, mgr->proposed_vcpis[i]->vcpi, &mgr->payloads[i]);
@@ -4565,9 +4585,18 @@ EXPORT_SYMBOL(drm_dp_mst_reset_vcpi_slots);
 void drm_dp_mst_deallocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
 				struct drm_dp_mst_port *port)
 {
+	bool skip;
+
 	if (!port->vcpi.vcpi)
 		return;
 
+	mutex_lock(&mgr->lock);
+	skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+	mutex_unlock(&mgr->lock);
+
+	if (skip)
+		return;
+
 	drm_dp_mst_put_payload_id(mgr, port->vcpi.vcpi);
 	port->vcpi.num_slots = 0;
 	port->vcpi.pbn = 0;
-- 
2.17.1

