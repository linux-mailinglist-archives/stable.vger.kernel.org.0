Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1BE13107F
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 11:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgAFKXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 05:23:32 -0500
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:6567
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726155AbgAFKXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 05:23:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2XWhVyXq2ZicUkkVYbB/Rl2j45LzZB+XHuSeHN7FVg5JAZfleQ7jklhv6nAJ6qFQuTsj79GqKtQ97ItvYR8AXaQRiXVjSBbB/lqQHMOQz7j8fEk9bnNBwHf5DHja1Pxf+U4tdJkffAWnYr0bOiDnU+9QwiE0Qysn8e6KqTsBH3HYbQKrShqfvzAJSk447VSU5umkAslhEyqWngJCJBtvJb4ta56N9+vPAZF5iV3624xbkFyAU7bmcj+5qGG9c8Jl+fBJ1d4wI8QXKrars8MQATemQXczc8C4jldZf+ci5h34qw4uY595xGuERn7FIcujGzBzOXGeZsImi1beUlfQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTw83XEi4hONHOSz02Mt32zNzr+OjKlYiC8OwlUXwEM=;
 b=GDc2du1FmPsq+3q5ZJzpFgZdfxo7vAQAXu6crJb3lNbJI2hDOrfclZ5PB4G0sPL0KoslsmcCAm7+mJCFURpj2KTEkKv/8ibkxtRj2vNtkyzGa8MgHLcx4wny5CYF6cMI6oNhCjbv8fXrdceQoCV0WkHC/6HCIuVt/ZahaBpXynrWktfpbAPa3rnByvvfxkzIxfEh+sk4NIE8toUHQb9u6N+N9Q92m4RvEGlRa8hMTJ9/6/mfF1y0q0ptMM43C6tSir3slMlIfeXGfET7JHtcDxBGwD9pC3fDGJZSwZ7pZZs1kBjIkpVz0ykXvXAhoeFU76XBkJXuZzJAFa3qCs7ItQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTw83XEi4hONHOSz02Mt32zNzr+OjKlYiC8OwlUXwEM=;
 b=Mk5ApJuDN82XGC75muhWhhe3YzUC9JhAdHilfQdk2el3A7/R206eINCQxekkuXaDqdVRGtJpTQwNrTaD6GQggUeq07aXldFpFIPBNO3J//Nd0os3enJAQ1qX0zbA7vB4QttSNsTr3nSYSBNwRXwW2ueIAcVVS/aHPeuuor9KYPA=
Received: from MWHPR1201CA0024.namprd12.prod.outlook.com
 (2603:10b6:301:4a::34) by CY4PR12MB1447.namprd12.prod.outlook.com
 (2603:10b6:910:e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12; Mon, 6 Jan
 2020 10:22:49 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eaa::204) by MWHPR1201CA0024.outlook.office365.com
 (2603:10b6:301:4a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend
 Transport; Mon, 6 Jan 2020 10:22:49 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2602.11 via Frontend Transport; Mon, 6 Jan 2020 10:22:49 +0000
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 6 Jan 2020
 04:22:48 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB02.amd.com (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5
 via Frontend Transport; Mon, 6 Jan 2020 04:22:46 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>, <amd-gfx@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] drm/dp_mst: clear time slots for ports invalid
Date:   Mon, 6 Jan 2020 18:21:58 +0800
Message-ID: <20200106102158.28261-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(396003)(428003)(199004)(189003)(186003)(7696005)(86362001)(81156014)(81166006)(8676002)(8936002)(70206006)(70586007)(36756003)(2906002)(4326008)(26005)(5660300002)(426003)(316002)(2616005)(336012)(356004)(1076003)(54906003)(6666004)(478600001)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1447;H:SATLEXMB02.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46f3d965-7940-447f-ddfa-08d79292615f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1447:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1447E20D7F94409A54B821DDFC3C0@CY4PR12MB1447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0274272F87
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REXZAyXXgDfz/Wuk/4/64qEtSfBLdB/l4yqszgmjEGoqJ686q8vxBBEiIyoyqQqXWoisWbAMrpdkSCO1GctKdeUZeVaYdGbcK5zKr/k0OMxXJqYCeVG5Ev2zpq2DIu86cA6DSnPZw0DCFnsOm3P9LIdpm3p/phWD9VnUsOCCWLz8esyCqHyos8u8Sh9Ddw9Osd45jTOpAIPHCWW2ATd8P/WrpufnwXmc28BtNI1L6YXWQ/8Y9qM8cX6/8bwTcC00rvAl4A51kJTMCkRdNRjQ729wKeDm+gMgAINBWdBfuyG66ESm/za36hwb1ho2ItMdFckCq+yryG2h05y6CMPtz2Hxf2xbvo3kRcY1a1SKUsAcxKHGYOR4Sx1+S3b473M44DBanBAdk8Ofbbc/u4Mk9UmBreLmi4evY8XnWSRPZhZonsmk08Xfq7KrpHAglRFIS8hchXMrdXd/t4EL5iFnXsvWLRjy9LN8VYaw5O5huio=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2020 10:22:49.1941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f3d965-7940-447f-ddfa-08d79292615f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1447
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
When change the connection status in a MST topology, mst device
which detect the event will send out CONNECTION_STATUS_NOTIFY messgae.

e.g. src-mst-mst-sst => src-mst (unplug) mst-sst

Currently, under the above case of unplugging device, ports which have
been allocated payloads and are no longer in the topology still occupy
time slots and recorded in proposed_vcpi[] of topology manager.

If we don't clean up the proposed_vcpi[], when code flow goes to try to
update payload table by calling drm_dp_update_payload_part1(), we will
fail at checking port validation due to there are ports with proposed
time slots but no longer in the mst topology. As the result of that, we
will also stop updating the DPCD payload table of down stream port.

[How]
While handling the CONNECTION_STATUS_NOTIFY message, add a detection to
see if the event indicates that a device is unplugged to an output port.
If the detection is true, then iterrate over all proposed_vcpi[] to
see whether a port of the proposed_vcpi[] is still in the topology or
not. If the port is invalid, set its num_slots to 0.

Thereafter, when try to update payload table by calling
drm_dp_update_payload_part1(), we can successfully update the DPCD
payload table of down stream port and clear the proposed_vcpi[] to NULL.

Changes since v1:(https://patchwork.kernel.org/patch/11275801/)
* Invert the conditional to reduce the indenting

Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 6e10f6235009..e37cd6ec6e36 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2321,7 +2321,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
 	struct drm_dp_mst_port *port;
-	int old_ddps, ret;
+	int old_ddps, old_input, ret, i;
 	u8 new_pdt;
 	bool dowork = false, create_connector = false;
 
@@ -2352,6 +2352,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	}
 
 	old_ddps = port->ddps;
+	old_input = port->input;
 	port->input = conn_stat->input_port;
 	port->mcs = conn_stat->message_capability_status;
 	port->ldps = conn_stat->legacy_device_plug_status;
@@ -2376,6 +2377,28 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 		dowork = false;
 	}
 
+	if (!old_input && old_ddps != port->ddps && !port->ddps) {
+		for (i = 0; i < mgr->max_payloads; i++) {
+			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
+			struct drm_dp_mst_port *port_validated;
+
+			if (!vcpi)
+				continue;
+
+			port_validated =
+				container_of(vcpi, struct drm_dp_mst_port, vcpi);
+			port_validated =
+				drm_dp_mst_topology_get_port_validated(mgr, port_validated);
+			if (!port_validated) {
+				mutex_lock(&mgr->payload_lock);
+				vcpi->num_slots = 0;
+				mutex_unlock(&mgr->payload_lock);
+			} else {
+				drm_dp_mst_topology_put_port(port_validated);
+			}
+		}
+	}
+
 	if (port->connector)
 		drm_modeset_unlock(&mgr->base.lock);
 	else if (create_connector)
-- 
2.17.1

