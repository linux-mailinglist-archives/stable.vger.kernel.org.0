Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24ED3CB373
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhGPHqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:46:20 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:28648
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231482AbhGPHqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:46:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZWTsRkvZy9zDGQEZKzLV5BdLU8wZCF1fi++MfM32o/M3tD47cZIr2Iw9MYFsBZdRNB3RQ8oKBb3yIiKfFF83Q1ibFNryiw/7GIkSUKJIRuhhcRMZxfBS5yvgoj3AoE8SQEK/Rjp1YufJTy6/oZBQkq1+JI3n652089ctXgdDA0XoJGgCpjT8X/x+g8RmnOT6tWBr3RmeFgDcCIQjCzsHHZgWTXORoJjP0MmzWaj0udIM9IrNwsfwMjJTCdbLPocNN2aWdOF30BCxwW99miTW93zvnUg9M/+5ZDSWW7+DC6XOXifubBLx2Ucwt5h1JQr3K/hj/UoDIRQrN5q/9z14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9s/fIgSYtU61AA2XyGDRtdnGYEs3yXlUPNtC0eOTQU=;
 b=nxT97//WOeIecoFyrZ2JJsasN5HQmU6ID9uHCnxkX+XaOfLFzj9necaoNqnYfC7W4QArKLUYW3OFkL0a/nn2VN6YGUiPDgLRkRa2kg9FDtKGBh0NyCLYbpwsKoTyJMvUCL0S2MPFQFXMXrr6ElU36Z+Ntjga8P0YGwp9sY9ClkWO0X5MA40fQ4oLBYq1u8nwk0SIXNcZ1jR2MS0mCrEYHB+39yPW2MDwIHSV/lJZ91h7HnhyD/+/qZ09mH6FswumhKG8mVXHDqDvKpPTSmQ4eNmQcvD57FEtUA30UbtelK5Zf/R4i4sx6kDzYaCJBFE5uxeI5vfKHUu+nhR5hK7J7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9s/fIgSYtU61AA2XyGDRtdnGYEs3yXlUPNtC0eOTQU=;
 b=L8IT9h8oC+IsMYXewMFrdv3HtjAncBpXhGcjsseUgCNIAtg9KZ+CvMfkuwVM6Uop1YQI+TZ0YzWSG0AKfhYTc7K8acPfXQp04jr91uFeAbEn5C/NKDdD2OYpSe73ehjd/GW4uwqzDFz4wtT2/ssi4zFhbjVKwXIgF+tsHH229QE=
Received: from DS7PR03CA0151.namprd03.prod.outlook.com (2603:10b6:5:3b2::6) by
 BN6PR12MB1508.namprd12.prod.outlook.com (2603:10b6:405:f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.23; Fri, 16 Jul 2021 07:43:18 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::2) by DS7PR03CA0151.outlook.office365.com
 (2603:10b6:5:3b2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Fri, 16 Jul 2021 07:43:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:43:18 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:43:17 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:43:15 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 1/3] drm/dp_mst: Do not set proposed vcpi directly
Date:   Fri, 16 Jul 2021 15:41:59 +0800
Message-ID: <20210716074201.28291-2-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716074201.28291-1-Wayne.Lin@amd.com>
References: <20210716074201.28291-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2de51133-3c73-4769-dd70-08d9482d60aa
X-MS-TrafficTypeDiagnostic: BN6PR12MB1508:
X-Microsoft-Antispam-PRVS: <BN6PR12MB150863EC32EF59FDB7B55A5FFC119@BN6PR12MB1508.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNLH8+ILllexlMumciwb6qaCLTm+IW/jauNmDoKjCLXIK/WBuJvdGibXE39bcD9JpzAN+hvph9DoQ5cvgbo8WQVOu53OToklN/WaPHRGPfWDPlknAQ0cEALSg2E+mbMBgG8y4pwOBL2cZqfXmc4mLwd/NLqI4Nu9vUujN2nw3ZpLsSRDoezEPg1uQ0qqDfja0C3jgjLalVv6AO8usySWsugKZJMRId8Z1hG/ONWfVSy01aOYPz+vqFT6sXBPMsP0p+7QCFkKu3VNwfjqhd/4YGZASeyuWcmZ/BGy/SwXhgHhV9kQaT8LCE8o8Sr+ZHk1KwM6z//k4w6X4e/6tjc/JiSJ96oAPb8nFSv0SWigDHfP6er7qUbW+YxdnqaMTvMw8JhHUGN8IW/WZjB/+/CwAZc/4XTvE0cc1fFa42P3MlPpxF0K4mmVwmRQrFQ1YeeE05WSvfaTm6PTEIm4lUfJp8QbNw8RNJ2Gme+eDWWrP1HHnUPrzcfLAxKtcXDtjfiQd8PRBqtpBcWRRP+pPFWkVSgX+hcSsDNjI+wfNPUiKTN6NyHMkCwuvY+JdymsnbQL4XjVjsrZiMAOWqWlrxEr/VB71mGXX8qPHg/sOu+Mv37PQOOoQkwYMTztOcN+fNX2kJZ3j7NntU36cN/tA7IjZleyLHDuceVIE96DWNsplR8ybzs3fmThWIORq7cmsKyx3dXm9qFhV+rBUnHTqtlkcXfrOE/aub1VXscrShsiZaU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(47076005)(186003)(70586007)(8676002)(110136005)(83380400001)(6666004)(1076003)(8936002)(7696005)(5660300002)(70206006)(336012)(2906002)(36756003)(4326008)(86362001)(36860700001)(316002)(2616005)(26005)(82310400003)(966005)(426003)(478600001)(54906003)(81166007)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:43:18.1185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de51133-3c73-4769-dd70-08d9482d60aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1508
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
index 159014455fab..2495e2c014ac 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2497,7 +2497,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
 	struct drm_dp_mst_port *port;
-	int old_ddps, old_input, ret, i;
+	int old_ddps, ret;
 	u8 new_pdt;
 	bool new_mcs;
 	bool dowork = false, create_connector = false;
@@ -2529,7 +2529,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	}
 
 	old_ddps = port->ddps;
-	old_input = port->input;
 	port->input = conn_stat->input_port;
 	port->ldps = conn_stat->legacy_device_plug_status;
 	port->ddps = conn_stat->displayport_device_plug_status;
@@ -2552,28 +2551,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
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
@@ -3404,8 +3381,15 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
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

