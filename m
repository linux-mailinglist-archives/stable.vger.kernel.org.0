Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664423CFEA9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhGTPZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:57 -0400
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:23041
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239086AbhGTPZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 11:25:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+P7YIUL8pMb7FuZPELdXYxL17iqP022zwmeffTEwtZ94OnIWvdmyJFjCsyqISTVvqkPjGo4itfrMC1/XHCw1vfDdecp6W7mN3NlU9mcOHUYsPthMbtNPJ4Wj0kSA1upbzYpS+dwiwd6hi1gHZNgwScNjD8O8dH4a86MECao6ri0Gf5jQ5TNJ/jaLE0R6BLsrhXdAKhB7udSeEsucBNlGcT5qBMDJP+zXlsjKduff1KlcyTrIu6xDeeNzN6hY/g+Jn8uFGKZx+9RqojlgcJvFPjW4p8OJDOhE0P1miOAkgi4PP53PUXflEc5KBy/vl/Zx04jEwbNADcFeCL/UeVD6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2t9uyzPrDPABnP7V7j85exXP8BhEOCS7x/8PBkA8zF4=;
 b=GCyoM1YDX6m/cxE2WrdljL/yf4hcg/U/tfIiFysm+7Urxz3AHUPl7aswy/vAKtd7XiG31zKvBRMa5rwYaLJuBdLm0L/InXYINxHFBKhCWh8jsaRlzaHPJ2Mo4GddpDfcQ6A9+jJp0XJtNAIKr1BQ2QqfDysw5ChRxnioqRJzqpBhB6NvWb37qgzVJ+IUkE12KPnKidgwIrxhyIBpn+Q2XNy4W/uR3koEZ60fhHu3c2k0DxQ+kwPBNWZH3UQKVqd2hiiy8T/CWpfSv82uVia7c4LSLXTlnNySeVamUAARyAV4fUu6K3Vx4UVqB96rozRMczBfZVmYQp6wvlo98UBznw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2t9uyzPrDPABnP7V7j85exXP8BhEOCS7x/8PBkA8zF4=;
 b=R4hsMY4XkdD+1JczI0cQ8U0WRiHUnnHyxRSK5+BcTQyDdKqtmLh6rlgHlP4q3xTDFNubwTsIadyquwres1C0ni2QzdH32iuCkhX3ovRyGz15VVFQOUUHzHJEbAn1JpJTrAvziZMPicfNMRskX1LAMovTYMnqtS13blEmxky/R7c=
Received: from BN0PR03CA0055.namprd03.prod.outlook.com (2603:10b6:408:e7::30)
 by CY4PR1201MB0247.namprd12.prod.outlook.com (2603:10b6:910:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Tue, 20 Jul
 2021 16:06:10 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::2b) by BN0PR03CA0055.outlook.office365.com
 (2603:10b6:408:e7::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24 via Frontend
 Transport; Tue, 20 Jul 2021 16:06:10 +0000
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
 15.20.4352.24 via Frontend Transport; Tue, 20 Jul 2021 16:06:10 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 11:06:08 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 11:06:08 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Tue, 20 Jul 2021 11:06:06 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        <hersenxs.wu@amd.com>, "Wayne Lin" <Wayne.Lin@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 3/4] drm/dp_mst: Put connector of disconnected end device when handling CSN
Date:   Wed, 21 Jul 2021 00:03:41 +0800
Message-ID: <20210720160342.11415-4-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210720160342.11415-1-Wayne.Lin@amd.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 430ef928-89cc-4994-0967-08d94b984a6d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0247:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0247298C55942AFC8910EF2EFCE29@CY4PR1201MB0247.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:195;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTOGPxYFjmd4mfojZfRfY00aXo+izUmvM5T7pv88kBd8FRlYVZC9YA4UtLxOBZkUkavEuq6WwiJsrWnGOF45yFUI6ya4NJqCoEsvy93R2RgA/4MFvjGle73UhiavcIza8gxMGPmebUBPS+3qyqGuhW0VYnwABdI0ZQaBJa1JVYe3gLzSMY9QRUXZTOFRmecO+HLwpDVUdtbyG6OC9mlJhB3pyshhfEGbV8ny6TJIpz8ctzVdrmoiZyx/8tRvSLQ0jeKEGnN6cn8VgBL6N8YuOzv/tAry88m52i6k1bdZDcvPMItiSZEFXvqp+kmAnx+wIgvPuYb08ebz8u75mFlETliuZce41YsGh9Kix97jk3yU0p7qWg0YoJBxgUl5kZCZgf2itd3m4rP54hgxC20E7O4/JaP/+fwZshIuKrmjh4CkT4wHE1ij3+Q/gvu87xbvlJ1BxoNsfokleui47SKk0cU3UTgNzM/MDcREcIKtBmzn4NJrkromKo/Aoih4MNtLuPsh/sr3eei9lLQoXQtCqlIz2rf9w/WfxdSmVUQUAMsZQ19knKq+Yis/cRGtubQ/h+Bb2U4lp3ksa1zzQw8hliME50yMlDTbDWeGRBUZolFV+4/AX0n7f9ufRV1CeA281HZ4NNQBcl+N5Qwsf2mtw9FyJBzgg4PL63TkxwEGOmKuTc1MGFs9ovrRFLKgrNYwEgaph+w0RorqAFfU5jHFNDDA4NwRCoDg/K8Zv6Iq6/E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(2906002)(186003)(6916009)(8936002)(336012)(426003)(478600001)(1076003)(26005)(82310400003)(4326008)(70586007)(2616005)(316002)(70206006)(54906003)(83380400001)(36860700001)(81166007)(86362001)(6666004)(82740400003)(356005)(47076005)(5660300002)(36756003)(7696005)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 16:06:10.4888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 430ef928-89cc-4994-0967-08d94b984a6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0247
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
Now, after receiving CSN notifying that a port is disconnected, we can
unregister child connectors under a branch device via
drm_dp_mst_topology_put_mstb() in drm_dp_port_set_pdt(). However, if
this reported disconnected port is used to connect to an end
device(sst/dp_to_legace converter), we won't unregiser such connector.

[How]
Take sst/dp_to_legacy conveter device into consideration, also
unregister connectors of this case when handling CSN.

In addition, check whether port->connector exist to avoid
null pointer dereference.

Cc: stable@vger.kernel.org
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index f13c7187b07f..85a959427247 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2567,6 +2567,12 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	else if (create_connector)
 		drm_dp_mst_port_add_connector(mstb, port);
 
+	if (port->connector && port->pdt == DP_PEER_DEVICE_NONE) {
+		drm_connector_unregister(port->connector);
+		drm_connector_put(port->connector);
+		port->connector = NULL;
+	}
+
 out:
 	drm_dp_mst_topology_put_port(port);
 	if (dowork)
@@ -4442,10 +4448,12 @@ int drm_dp_atomic_find_vcpi_slots(struct drm_atomic_state *state,
 	req_slots = DIV_ROUND_UP(pbn, pbn_div);
 
 	drm_dbg_atomic(mgr->dev, "[CONNECTOR:%d:%s] [MST PORT:%p] VCPI %d -> %d\n",
-		       port->connector->base.id, port->connector->name,
+		       port->connector ? port->connector->base.id : 0,
+		       port->connector ? port->connector->name : "NULL",
 		       port, prev_slots, req_slots);
 	drm_dbg_atomic(mgr->dev, "[CONNECTOR:%d:%s] [MST PORT:%p] PBN %d -> %d\n",
-		       port->connector->base.id, port->connector->name,
+		       port->connector ? port->connector->base.id : 0,
+		       port->connector ? port->connector->name : "NULL",
 		       port, prev_bw, pbn);
 
 	/* Add the new allocation to the state */
-- 
2.17.1

