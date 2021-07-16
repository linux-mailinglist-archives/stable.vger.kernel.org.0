Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF543CB374
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhGPHqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:46:21 -0400
Received: from mail-bn8nam11on2060.outbound.protection.outlook.com ([40.107.236.60]:31077
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231966AbhGPHqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:46:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDc1PhjKgD+UFGjStR+fUOio2Ox7ONtfWrKnKT8j9rmvUhaEplSMrmNT//tv9HyQN7l+x1ZW29TBvel802tbQ7eOznyEbwmvx9ODw4HFNeHbhzju4IX0s2pQkmgpgkqy2WOZ/kU7i8ptQjsZSbGsOHhpWCXrI3/G3ur4X3gxr9iMg8ogY3me1zeRXo6xvVAep7HBbV82QkCgYPd5PaKNy860pdWUIsUWUG2xL72owOvsl/a7dBzsFLJbERotaLyAI7JGMFIElYA25pE0irLdukj7v++s5//UjT1HKRfhv/ZKxeTL2W8UGJz3WeBPNmSZfVO4/F55D/BHmhqdfylgmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1sxl3ff0huFdWlKsN3H5SYJhZYjkDKyknJ51i/YGo0=;
 b=cOlcTob3eY/pVMwWG1K4iUH6M31jlmNJWnqj7Oy1Lx7sMIQqvWauOJTtBO3QEEgOyZ3HEfBtnZiIpyhuyxnfQAYfoeH1XjiT5ambK3Y88mqEsF+GT0SWroVTlEGqHLLPX+oyAodPQv5oHFq5CqTylqj+JlPUME5237pLhSpckX93iREU3HvZ/20lOMvVmgxOe133BlIuN41WmvXdEtNbv6oc8zpwBhm6yWaHwsuOYi24z70RpX19Vay8i9Qcnko6wt3NIghST9lEtN3wvYhpUdTsqNn3cTFLeTaQeWe6vWIOegmCqueO7Oj+90pMGJWV/CHPRYLenjNOHlhe1RehCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1sxl3ff0huFdWlKsN3H5SYJhZYjkDKyknJ51i/YGo0=;
 b=uVk3L5DRfTuVoHOdzwK9p3LH88WHOHI6+cW3xoFu3bXyvIjmjwbhOw17sEuk6DYU0Tu7OoL2RrTLIKB0FTfLlTWzEAIcvO8RYVNUShHKuLDWQvCM7lsvkuYBh9b8Ksw9qHQqopF1WwL/5GlRyYoZ2jOCT6mcKZvaJM8KYnZWlqU=
Received: from DM3PR03CA0016.namprd03.prod.outlook.com (2603:10b6:0:50::26) by
 SN1PR12MB2542.namprd12.prod.outlook.com (2603:10b6:802:26::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.23; Fri, 16 Jul 2021 07:43:20 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::a8) by DM3PR03CA0016.outlook.office365.com
 (2603:10b6:0:50::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Fri, 16 Jul 2021 07:43:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:43:20 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:43:19 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:43:18 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 2/3] drm/dp_mst: Avoid to mess up payload table by ports in stale topology
Date:   Fri, 16 Jul 2021 15:42:00 +0800
Message-ID: <20210716074201.28291-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716074201.28291-1-Wayne.Lin@amd.com>
References: <20210716074201.28291-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a187070-90bd-4c5c-eedd-08d9482d6207
X-MS-TrafficTypeDiagnostic: SN1PR12MB2542:
X-Microsoft-Antispam-PRVS: <SN1PR12MB25425BDA47F1B0E0256BE2F2FC119@SN1PR12MB2542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uCbLk6AsJbF5UQy1hw3ObiDfAbjbhJHsB2ANvdloLGwxZKCC8fiuMsqmN9kxE0hJDTzq8cPsP9vD1oKL8ET1IBVRThDQmjFe3z1EDfDXOV3ric0RWHajMkVBCTe8uNTkmoUDkvqFJ5C57WjyOAlCRIN9ZjmivVvUpKP0Z8VYz0RqBeTA/NMqy/z4BMxMU5+5OBvm6IFu7vpcygLAX5zYml+6gY0OnxHzcWJE2lt45Gf1lMs9rFbYh06MuUuT+rCo03CEYAOxoVfspwmFqH83Rg14ff8Go69d9Eu1VcmXqR7KJ9ViTer5+BEhL6s50a9n4NJZvzHpeJTDIYFz4m1CEOVbhDsHbk0FPrEq54K0+2bRldNah/M4Vf0YlVWzSPgx4s6f646c1fYlh98Ttfl1TvcowhEMJiRfH6ZUMpw4mBc0mL/UONOI1gv2dC++P5v1vZahChqjKVYZzvx+T1rT/pUNhmhfVJww5ELm5Ii/G4lg39qjzB+Ub/Pf8UZbSCCK//8tH+5byABRFSrYzFMCLL2we1nD3HiKrXn7FYLWczKYAWADOkcMstgINa5JQjA6eaxEgeJQjEggPKoajz1F4V1SKIeghWQtqJOKkU4I6ytqG8U0E3L0Ntek3WLOo8lssUG5t4LSHIURjyRXZKNYDo6Jy+PIAmX2dOIk5oSW13FZPncFbyaK7HRcse/vvX8eoKU3uMMedBZVdE2+QKO9tUaGFpiouf4Bl7JRZgjiEZ0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(46966006)(36840700001)(426003)(110136005)(336012)(54906003)(2616005)(1076003)(2906002)(316002)(26005)(8936002)(6666004)(4326008)(5660300002)(186003)(8676002)(70586007)(7696005)(70206006)(36860700001)(82310400003)(966005)(82740400003)(81166007)(356005)(36756003)(47076005)(83380400001)(86362001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:43:20.4031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a187070-90bd-4c5c-eedd-08d9482d6207
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2542
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
index 2495e2c014ac..bf6fa98b4ab7 100644
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
@@ -3360,6 +3363,7 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i, j;
 	int cur_slots = 1;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3374,6 +3378,14 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
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
@@ -3473,6 +3485,7 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i;
 	int ret = 0;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3482,6 +3495,13 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 
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
@@ -4561,9 +4581,18 @@ EXPORT_SYMBOL(drm_dp_mst_reset_vcpi_slots);
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

