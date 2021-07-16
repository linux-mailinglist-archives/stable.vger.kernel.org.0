Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2743CB34A
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhGPHjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:39:11 -0400
Received: from mail-mw2nam08on2050.outbound.protection.outlook.com ([40.107.101.50]:24161
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231454AbhGPHjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:39:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyD9oc6NY4cl4qri/2rKVxXnyy70J/eaH3MGil9lKpZbhEOXy2WbiZy1XAOPSKdXWDaMfQNc/QE+qMAfyA29ZFRnXO9NkHxAKsRzaSWW3nBsWNEkSLtp/qbAnZ7D8fGu39rowZj4brXzegn9u80pZHUXrapcEKjtHoqjiUPvLxGM9duqjjGxudHVxrCZCZe58mzBDeLlBA5Cii9UvudX2GTH4HsRLDYHMlnwC8jS+BoGP2HrUOcuopDKwyNrJs+bRp0Hpdsax/krdHUTMIP/tHjSelkPhUlDOFs0mFM5SYLhqtVKTEB23mGWxnYviR/0GsEkdjo0hVb7Q/6kGQgrRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WKW1GsH+1joRBKrOshxvES4ceeCl7ctrc7pGKFjfE8=;
 b=Phat++W6qRe2jd7NTIe5eWS8OKfmnXgVwCSZdyVJZhDnSspYQwqix58Lk6eGdNJMcF5tUoF6nQHliNrQW7MCXYiBQu2f0Z2eaAGKiy1IcsRGdK//avEWX1qIOvNhpk+/mfTnIj+tzSHNbG5ZQa2jhkDjwmKiRvtsPEl1hdAJXEWso88qqx7usxTyWhhpC1MwEUbl2OTcMHleKoucLRww4aHZfS/ssn60loc+2CDloiLC3SRb6XhkLiuyDIc1kjPQpQ7aS511AEQEmNXzi0zkpvMMiy94pm3fAnYrx+cXtWiDAmrsvWGQontqihOFN1ApkV5C9K2X5/MuEti/FwuXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WKW1GsH+1joRBKrOshxvES4ceeCl7ctrc7pGKFjfE8=;
 b=nwrEQZlJiCUiEUATsh68YoqPeQoq2rDzLcE1TUNa4Z60l9bvzri6GRX5jdRPT52o600/jw7S4NNrLHhJzi/t4thGLXBe9NWz/QX5aPVQWiGLTILbc9EWR78eG3SFgV0tQVSfZEsS6ubYx5WFdOCD2ijq6jFp3NxZ/hlyvvH1rAM=
Received: from DS7PR05CA0003.namprd05.prod.outlook.com (2603:10b6:5:3b9::8) by
 CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.23; Fri, 16 Jul 2021 07:36:11 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::39) by DS7PR05CA0003.outlook.office365.com
 (2603:10b6:5:3b9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend
 Transport; Fri, 16 Jul 2021 07:36:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:36:11 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:10 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:10 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:36:08 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 1/3] drm/dp_mst: Do not set proposed vcpi directly
Date:   Fri, 16 Jul 2021 15:34:48 +0800
Message-ID: <20210716073450.26497-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716073450.26497-1-Wayne.Lin@amd.com>
References: <20210716073450.26497-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c44c5357-7f3e-4670-1aa5-08d9482c6248
X-MS-TrafficTypeDiagnostic: CH2PR12MB4837:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4837F61A31024FB638B5E9A0FC119@CH2PR12MB4837.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MR196JQxgn1RqCJamNeEdqTJ0/GvmceNZYz4AiswPzeHipojBanwjiXCjtYGORBp1vKSBtY8JBFlNnWvpS4d0Qw5n9zVbaYYxCGyhEQGrpeDOKMaFCGdMc0HkBkfPszQ2puQpQEpecC2FScOIVMyBaK8oFvhX0xxSQkDz6Fu9rrFiRznoR493kMpE+QfJWa1QecmIkfGNfJ8qW1jTqCkK6nudYlOUz9v4mY7lAKQ6RJs4QU/N18+y+IFNRNBAa7OOoo7qP9t1SwPhID72+GjHyFcAlf9LPl4vzjQLp/de0uPEU3g5qfJaEzh9jitSa1qr03xpPnEM17aQJYWIneAk2pi+Hwxq6JmMsnnll4wl8dCSXL3mS3Htgao67fQ0JoG8+JOh03szN8CDY+zvSHmLc3OOdMA4LGMITFZLHtIdI3+i5jwipcWyXleDT3pWxv/tp/xhQZ3h8NtZGkt/kvmx7ixCHdCB7CcSoAhv2klYtQYFow74416nCQz3NeKLXQ6XZMQk5paD3mMq6Lfb+YRtvJCQsqkiswy7JisCCbyvUgvhcC3I4tlRjEgoZTka8LGPCIPa3dNdMd45/ENZVrKJx9k2QNRNZ2Zpey+1mO2HYQHeOHiouPqPiJsnz8Mr4vk71RxAN9TECQNDHNssbnh1Qqgv5PLJZ4B5/eFxlM5gRaWSq3eYod8V7Nd2/bakzrZOcRwSuAeudCGxNFDTDalwVNPUARVrn02TEj1NB6m5iU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(36840700001)(2906002)(8676002)(7696005)(47076005)(356005)(36860700001)(36756003)(316002)(5660300002)(81166007)(4326008)(966005)(82310400003)(6666004)(1076003)(2616005)(70206006)(86362001)(82740400003)(8936002)(478600001)(110136005)(186003)(54906003)(26005)(83380400001)(70586007)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:36:11.3139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c44c5357-7f3e-4670-1aa5-08d9482c6248
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
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
index a08cc6b53bc2..702aa0711f80 100644
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

