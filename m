Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4598114DB7
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 09:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfLFIkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 03:40:53 -0500
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:6074
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfLFIkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 03:40:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WepbXKF9a4xtIPEVKc6UaFS9oqWnefbvwINUfT8c/h9CcAK1EKpXZccDO20yITjdwpdeBWD6fqdF6m3M2R4Pqf5aXDL9n4CfjapqTzAhyPFHA+x3QXn9UFhgNjafG9WPckDFizXS/kk/7WI4oGVgdXObzVctrDOiFCGs7OHspuZ6xeumCS2f4W4i+AntO7LWcSMVqbwizsFhxdp07g6dhN9nd4UIvCiCCWELecoTFfD2z5CuqH6l6Vr3t82Nc1+vLktzpmH28g6IwHPr4p2nq70dEFiL0JboWhIdpRNlwWv0PPN1gFU5xui80IBDS6UTLW2d+P7j+AcBV6gLjMAuzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R3dwO+2QLbiZ9BuHUs+Nq2pQBuBJEMh0pkrHYFUtHQ=;
 b=QlCd/pQEZKTJzPnjTVWuMXAtwE2Yxx/5XN6ZA/nrZF5XlVbCRLBMmxTTtlQEysvIMxfLO02fBccOIwhX8SJdvN1grSS9cM2MlIgBwU8hKznqdXrRkO7wioiTPEJzdc+TvgfRAPKNJRaDzvH/W2u0sYiIGNAKRJ4yQPh4xARBMA/g1EBVQuaJcEtI+ZZ/j8JJf7UEYdlcLQHYBm/pdUEJvfvXL5sRxPIi54EkjEzw0t+5/TnOmBz08EvDy4E5WVlIyZM/zhfLPqlR+p2V4gieuXQlAtAUhFtsuA0zteoYkRnG9+vlrerLaZqYCiVpaTaTOLuHaN19oAJT/Ugd3f7FzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R3dwO+2QLbiZ9BuHUs+Nq2pQBuBJEMh0pkrHYFUtHQ=;
 b=qqLDZBuU9o0/gDYBXM2SQ8/drNgFRuCR1F5wT+Yun2kn2N4yYY/xa4eae8JlR1ya0F3gFIsm4GmtHRxfTIJGLcP3PH/eCb86vPmf2ghPzKT8iZ+YLCP6DISCCtV+k+ZcQ6tKhND+GB0IFlZ5lmWS3/t1HUHIYcZ1C907ZTAPK9s=
Received: from DM5PR12CA0017.namprd12.prod.outlook.com (2603:10b6:4:1::27) by
 MW2PR12MB2555.namprd12.prod.outlook.com (2603:10b6:907:b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Fri, 6 Dec 2019 08:40:03 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eae::208) by DM5PR12CA0017.outlook.office365.com
 (2603:10b6:4:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.14 via Frontend
 Transport; Fri, 6 Dec 2019 08:40:03 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2451.23 via Frontend Transport; Fri, 6 Dec 2019 08:40:02 +0000
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 6 Dec 2019
 02:40:01 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB02.amd.com (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5
 via Frontend Transport; Fri, 6 Dec 2019 02:39:59 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>, <amd-gfx@lists.freedesktop.org>
CC:     <Nicholas.Kazlauskas@amd.com>, <harry.wentland@amd.com>,
        <jerry.zuo@amd.com>, <lyude@redhat.com>, <stable@vger.kernel.org>,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH] drm/dp_mst: clear time slots for ports invalid
Date:   Fri, 6 Dec 2019 16:39:37 +0800
Message-ID: <20191206083937.9411-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(428003)(199004)(189003)(14444005)(7696005)(36756003)(51416003)(316002)(426003)(8676002)(336012)(16586007)(86362001)(110136005)(54906003)(2906002)(356004)(478600001)(2616005)(48376002)(70206006)(6666004)(70586007)(50466002)(8936002)(81156014)(81166006)(186003)(26005)(4326008)(1076003)(5660300002)(53416004)(305945005)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:MW2PR12MB2555;H:SATLEXMB02.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2eb6768-d564-4169-35eb-08d77a27e32b
X-MS-TrafficTypeDiagnostic: MW2PR12MB2555:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2555070DAE4E8477A74E14D7FC5F0@MW2PR12MB2555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0243E5FD68
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FiEVtJ8tJp6edj/AHvcZX3sbn9OtUUsEFVtRIzDy+KCt4cwXZTiYORYSyyFgGdCKIMnktb59Ju7XrVX2i4ABmRFlR24sc9PVeqEcy5B0ABXJTsIj6tvYKsMSa9o6zfcsZ3LbXHTmrhCB/odgQuGT1I1ovDP+ad8gsGr3BpqU0nj5CUWDoS9ao25m3eYoom7qw3eCnKl4d15JSq78a46alYLj0vDXyn/CIRpkFjnPfope5mPy4FjFfkaqg1inBjuY5DyQFWKQdC7jYjWSc/4fsTJN49ZuW3vK2KuhH6WxVkntdeJCosw95OlajFJ2vXbMIxUucpfXtirrJQLa+4CLoCC1ufT9EWgjD+oF101z2F2l02ggdfs62+OvLbsd9j18exne67zYtFwbi5wFSV6ZkzecNVMoaD5SSNWvZyuK9RcWAlxn9kBUTlJEMB67wUsM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2019 08:40:02.9347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2eb6768-d564-4169-35eb-08d77a27e32b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2555
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

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 5306c47dc820..2e236b6275c4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2318,7 +2318,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
 	struct drm_dp_mst_port *port;
-	int old_ddps, ret;
+	int old_ddps, old_input, ret, i;
 	u8 new_pdt;
 	bool dowork = false, create_connector = false;
 
@@ -2349,6 +2349,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	}
 
 	old_ddps = port->ddps;
+	old_input = port->input;
 	port->input = conn_stat->input_port;
 	port->mcs = conn_stat->message_capability_status;
 	port->ldps = conn_stat->legacy_device_plug_status;
@@ -2373,6 +2374,27 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 		dowork = false;
 	}
 
+	if (!old_input && old_ddps != port->ddps && !port->ddps) {
+		for (i = 0; i < mgr->max_payloads; i++) {
+			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
+			struct drm_dp_mst_port *port_validated;
+
+			if (vcpi) {
+				port_validated =
+					container_of(vcpi, struct drm_dp_mst_port, vcpi);
+				port_validated =
+					drm_dp_mst_topology_get_port_validated(mgr, port_validated);
+				if (!port_validated) {
+					mutex_lock(&mgr->payload_lock);
+					vcpi->num_slots = 0;
+					mutex_unlock(&mgr->payload_lock);
+				} else {
+					drm_dp_mst_topology_put_port(port_validated);
+				}
+			}
+		}
+	}
+
 	if (port->connector)
 		drm_modeset_unlock(&mgr->base.lock);
 	else if (create_connector)
-- 
2.17.1

