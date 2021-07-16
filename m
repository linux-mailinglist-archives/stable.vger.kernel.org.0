Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264303CB369
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhGPHmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:42:55 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:14816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231966AbhGPHmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:42:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCl8qJpyz0gJLCWC/KvyN/WHn1ufJejjFpPVpUavx0dlahjzuuVq9mkQtkx5GTm2eHV0m1we9IER9+TfR0G8mDKXwccetIa6RhisgToxmDujKk5sT5roPfMZeN65c6Wv9gJqCCAE5+ge82msUKD5Vm4N3GaDV+xN2XvWqGqcQENIH/98DkufMGP9esboFVk9LjPzDiSwDb12s7PNZ5geTjzlyOhdL2eDRwnypNyV65k+6atsCiMN7HxssX0jfVt0RhVsZmRVgK5jg/1vhWeoMNB7vsvUze2Qu4enKgqIQL46z+qOcwcYUnndagt5JmVoRz47v/heoMCk9MAUhfczGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+qt6H1ORxFgbVgLoaYxAJTWnxJ+1+LTK7GxzaG89W8=;
 b=W+2WIZds82ibb/RuSjlrwMtqude1B8wdqgKHkpkQp8p0jdWp5cC+bLlwupk3s9UIwqMy2jXjV8vrdr+4ksq2LXAtYsf9LInCKL1bIAlDA59fZUfvkAJbut7J9mxn5NxyoBxllkD8C4OmeapMVCx35S0P0GGD7kRyhSoE3W4H9Wg297OLU4e/Ecfq1vO3WIzlbbPwU9fJSocxjccVEAWwzXSFsEi22vc/6QZSBUuP0WshsXyoOqLx+hBgbw9Fc/B1aa48s+kWEftipvCSsATgyrXWz3LM4JKJmXuBgQp4dm2K8RxtUvoX10kKM7ihOfoPvb/MtVJnwXYRVoHGdxOXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+qt6H1ORxFgbVgLoaYxAJTWnxJ+1+LTK7GxzaG89W8=;
 b=XLZJAUE+TwUbRiOjxZzIE2XtRJ0wYlmlCp2tJg1jS+ezUWuglpDqGQagPt8+/Zl1clveLvu2gsIf8WyYV06NakuvgjJRl+cf7RMNGfi5OWxKMK42VFP8Oq0L2LLtT0UUtJvPYHtloufs+ThymTOuAjP99AEdIEIIgyZKAGD/Imk=
Received: from DM6PR07CA0077.namprd07.prod.outlook.com (2603:10b6:5:337::10)
 by BL0PR12MB4740.namprd12.prod.outlook.com (2603:10b6:208:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Fri, 16 Jul
 2021 07:39:58 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::66) by DM6PR07CA0077.outlook.office365.com
 (2603:10b6:5:337::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Fri, 16 Jul 2021 07:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:39:58 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:39:57 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:39:57 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:39:56 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 2/3] drm/dp_mst: Avoid to mess up payload table by ports in stale topology
Date:   Fri, 16 Jul 2021 15:38:30 +0800
Message-ID: <20210716073831.27500-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716073831.27500-1-Wayne.Lin@amd.com>
References: <20210716073831.27500-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b4b8005-54c8-4136-5cbd-08d9482ce98e
X-MS-TrafficTypeDiagnostic: BL0PR12MB4740:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4740CF232C3669DB5CD8B859FC119@BL0PR12MB4740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TC2O3f6uyH78Xh28j/+UQu+0BvyBZ8FPOygxqveL2uiPfuFnr27VXT9ef93BmbM680fXkfUklfFXmRwyk1qtb2R0t7/vc9mOmR4RPshhiJXQCng7Q4DcQTyNuKzmebu5MKahtN3IjTRkR6vOZhr4j/aFkx+ddfWF4qqHohXo/U2tHF3WdLiIy/aYRfGHAAa6UbGiM01tjml0jBu+IrDN6LeL3kVXS+dctP36YhHADrUUqNkl4sVfSMKp5xpa6E54Gqcdcq+fknp7vm63TuSt1F+sTftSMiC1eMR2X7NYfqODtgxzraWqWi0BQIJhxwZVUT6LFYQMPiejQ7SXFVCzMrO1krvNgz/kDszmEWUhxQyuksR5orqMj12aIqlJRcTjPZTKZtx0QP2Dxq8lMOY34SBGjHM0BwponOWYhz5VzeJXQv9rowFbJT1HLq+D7eazWgA7Alf4LWHSXIUDBhJTLBVwKJNGv6DkQC+bVW5kcIZchN4p5zw8uklV2OPt51Z0hDtsGUPHj7ELcym6V903nihZw1XYUjesgnzPE28loDf/kAtJ4l7wSED8rgBKeAgkTYq2CjBQLb1eTUdK2Sh2hz5O7D+Qu77O2dnmD9yE+rPGOCmj+6Lu93wG0wyW8VbETYGUjFMetIsyUD/y4TAcRp1KIyKRMQn/M74V1f1SQs05TaTx3T2PTWgI5qZwRsc+0qUi3g0MhgCEUNeni6H4/Ehm17rh/hTHS1LDv7m2B8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966006)(36840700001)(316002)(70586007)(966005)(2616005)(2906002)(4326008)(426003)(336012)(86362001)(1076003)(82310400003)(8936002)(70206006)(8676002)(110136005)(54906003)(83380400001)(47076005)(36756003)(26005)(7696005)(5660300002)(6666004)(478600001)(356005)(81166007)(82740400003)(186003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:39:58.2738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4b8005-54c8-4136-5cbd-08d9482ce98e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4740
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
index 41d790df81bb..b86a2b7fef39 100644
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

