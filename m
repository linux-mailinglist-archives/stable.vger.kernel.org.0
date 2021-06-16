Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15763A902D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 05:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFPD6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 23:58:03 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:37729
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229931AbhFPD6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 23:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kINpXXWUJMi0v74MQZpscoSCRccN1+U5ZQUTxWT+0Z3l4yr9HKNL4w0V5At8CzaGNdLaSgftyE+HuUPoFCYp+MpVybjsqpklBUIwvT4bSY/yg7K5FPFS1GzztSBUpL+IXa5Cehq02cAdKKWlDV4Xg8tf2E9PxJW7Yst6jKQ4F7ousWIS4e2UcDz2PZCHRKtHqSMx4gtcteuzXjHbkZ3kGyBp7dEggS7wH/58Rl03EHB37UoF/bT75e0H9sQh99ffNwt+viK1S6vShFZjk23KHRhGgkU9oed6eRDmrf86Np91QI07WCVIaDtVCXwPzKF5tRIR8c/7RdaQ/Yq911s9Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mln9HhtwWqUVJUt9shkU5clzS8X0D8nsD2B9afkXI6w=;
 b=fw5z8w2PsmhfJNQ6Q9H5BnsWVqr2xu82/6R2l5varkGeaShLN3nNd2VZkeAOULcjBxkLvc5K6gbtRNoQznyGLM4iRTziamzEaDc/o9D4LJJU9HRo8z12Bp5HtkRub6X8Xmidl0D+VkDrNiUchyCKMa4ZEhyggiaudmd9WOJI9CNKIaKKugKfYkLEnK8eywGsopYupyd27Qw33Q+y6hSiWnHNSf/RmfXo5gG6HgKZ7kvLJA4KfXzpkCDbNFoEEwfziBq92i4n2+/1fakuoUhU+efIB/uMoffhEVjZTq71kgzDxvH0J9rVNRrSM+QuEoa+nIN0XiBALAoJ0J/yLNpKqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mln9HhtwWqUVJUt9shkU5clzS8X0D8nsD2B9afkXI6w=;
 b=eakum4qR6nfzQtNrOPn8ASiF56gaGvdpqP7NVOsLBKyAY0lP9pbGT2P7GOnhw+F8W6YhQbMxXiqR+Af28MCIte0xwy+N2ERbdrskBTemAHt7+qp8xdl0cSEu0F71nF/iE0TyDBFsylFIusqwIpf6gHCMmVsc9KvQaH0gG9XoaI8=
Received: from MWHPR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:301:15::21) by DM6PR12MB3290.namprd12.prod.outlook.com
 (2603:10b6:5:189::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 16 Jun
 2021 03:55:56 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:15:cafe::af) by MWHPR2001CA0011.outlook.office365.com
 (2603:10b6:301:15::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend
 Transport; Wed, 16 Jun 2021 03:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 03:55:55 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 15 Jun
 2021 22:55:54 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 15 Jun
 2021 20:55:54 -0700
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 22:55:52 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        <aurabindo.pillai@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] drm/dp_mst: Avoid to mess up payload table by ports in stale topology
Date:   Wed, 16 Jun 2021 11:55:01 +0800
Message-ID: <20210616035501.3776-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210616035501.3776-1-Wayne.Lin@amd.com>
References: <20210616035501.3776-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ca4a5b5-14b4-4102-af1a-08d9307aa4dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3290:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3290E2DACA340C1D81B493A2FC0F9@DM6PR12MB3290.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QStP8uaJYJaAcubfW53cBKReybExw8c1UQFhqpqvnUgd2LiMyeXyVMr+40KH/oFMnwHck6W/7A0Jld3rIgrozr8JsmhIqXWv+Xlx0M9Uxx89PWSlL2O/r+qsZK+EJJBfVIitdCPZeTatYPmghcgEM6buQhEgWqCy30VOlP2D1o9idRaPCWGpAuoBXBjE3jWvlShtQIdJ1Maq9KqBD5p+jLs6IZUacEgbHx0g4u9FLpiRDSyblLR/nbyHMergkFKwCz6sZtHAL3nNeXxFe/yxcQ1eKaYBQwj2kpNiLqY6MWbXA99/yCKE5AS5jy02X8nMFYBfnd3QIgN0n+ROpFsnwaKnU4+2LZKu1cuRDQBg1Qw8vAXiP+gpdnuhIHtJIup7g1DTCYmxi3fLHXpjHY6OJA7dXENrN1H+rzsQ8JpRiEeW7x1hbkjTrr0u+dtiGVTE9PQU5As1b3wYUcIiBkGaAqNqM45H8pEERj9GdNab1063nu7Ju53U6lFB6/j6z0LwcNwQC3p0q4ljdW6/raJg/4Zba0nlvj1ILQx8FMPOATJ9zxr273B7Ka4Puox9xi2vY3o9ETk5BP/u3RNygEwmfnyZ+CCtkc/vgav2oj1ik9fFIre1WPuilp+3+wU2azm32+gNLSmPuxkTeZEQzetPZHCXMeIcEK7cXMj/x3vldROq0bRPcUpc0AofTAL/BRoC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(36840700001)(46966006)(4326008)(5660300002)(186003)(2906002)(70586007)(336012)(2616005)(82310400003)(8676002)(86362001)(26005)(1076003)(8936002)(426003)(356005)(6666004)(81166007)(83380400001)(7696005)(36860700001)(36756003)(54906003)(47076005)(70206006)(478600001)(82740400003)(316002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:55:55.7186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca4a5b5-14b4-4102-af1a-08d9307aa4dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3290
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
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 29 +++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index b41b837db66d..9ac148efd9e4 100644
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
@@ -3366,6 +3369,7 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i, j;
 	int cur_slots = 1;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3380,6 +3384,14 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
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
@@ -3479,6 +3491,7 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i;
 	int ret = 0;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3488,6 +3501,13 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 
 		port = container_of(mgr->proposed_vcpis[i], struct drm_dp_mst_port, vcpi);
 
+		mutex_lock(&mgr->lock);
+		skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+		mutex_unlock(&mgr->lock);
+
+		if (skip)
+			continue;
+
 		drm_dbg_kms(mgr->dev, "payload %d %d\n", i, mgr->payloads[i].payload_state);
 		if (mgr->payloads[i].payload_state == DP_PAYLOAD_LOCAL) {
 			ret = drm_dp_create_payload_step2(mgr, port, mgr->proposed_vcpis[i]->vcpi, &mgr->payloads[i]);
@@ -4574,9 +4594,18 @@ EXPORT_SYMBOL(drm_dp_mst_reset_vcpi_slots);
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

