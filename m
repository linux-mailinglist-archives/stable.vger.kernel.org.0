Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500F93CFEAB
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhGTP0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:26:05 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:26641
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235344AbhGTPZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 11:25:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kg7zCDULrDcI1VQ7v1MQmjAr7aqLAcHtrSJu3Uy7zQvyBt/DClsiFHagukPOsczxw1ca4W8gPYlbvOjj8a1V0VSoodVthHJJOYjbw5moJyAVTxC+W1jNKgtHxOGfnMgfyO9qjVkj4VeAD+KS+HDva0f4KNI0E6+3X/RQveomwImavEUxoA8vUC57zXMYidKskr7V6iQzKXNt0ZTPpvvgcYthNzTohbbeDCz8SjXljgloQNcDmuK6zxHLwScHFfyy/0cP0hFFPd+Ik8ZY2MzxwYDcGYddallHkgMAmy6iMr/bNFYZDQWvUNvF9OOmUABUB0QQepztWEztJNLJo/d2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgRe0gwAxm8zAhn2oH+DKrNQWBlzFisJWCi9QjmF0L0=;
 b=JGhJugk54OZt/C0/F3Yq1Ub56OyUg0PCZ5fEbklKKSE/D09sR8cbHF8i1y3jD2uOp+3EgaNYKKEdAbSoVz/RU7Z0Ycq/NlaWwv5HMJVdEvr4Ynx36gs7vqIvt1FnTEXLUVGxj7iKYFkbBh/ziTFAsW6ijuesqgeKf1rfVlJeIFrrFOfdJYSBUiTa2Syv6yggo1dADwslbqcQ/x3SuhgOYTneodeSXD4aYVe6jvLyVjsrbwm5QQ8zYI9YkBpvU93Bi5sVNPz5fRyp3asniaQjCwoVF829/YOTz81eMDzXVbXnmfOgseEgSFHsSihLhARWGfBwL/H/m66zwTDkL+35jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgRe0gwAxm8zAhn2oH+DKrNQWBlzFisJWCi9QjmF0L0=;
 b=3QDVbMT+s7y6c/b2dVC8Dq6sGChss00/CTIQthk3tCryb9+ADUncimJCIKHMptK8kGzUz9Mli5C84OoBvkBWGziml96IyF7IU1eJfMZ806q9lqZAEyuq+QfmP77ACo4sDa6QO1F+KCxb4MqNO8ReOn1ThuDAy6ERP30RyqUpEu4=
Received: from BN0PR03CA0049.namprd03.prod.outlook.com (2603:10b6:408:e7::24)
 by BL0PR12MB2482.namprd12.prod.outlook.com (2603:10b6:207:4a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Tue, 20 Jul
 2021 16:06:10 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::2e) by BN0PR03CA0049.outlook.office365.com
 (2603:10b6:408:e7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
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
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 11:06:05 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 09:06:04 -0700
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Tue, 20 Jul 2021 11:05:53 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        <hersenxs.wu@amd.com>, "Wayne Lin" <Wayne.Lin@amd.com>,
        Juston Li <juston.li@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Harry Wentland <hwentlan@amd.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>,
        "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        "Sean Paul" <seanpaul@chromium.org>,
        Ben Skeggs <bskeggs@redhat.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/4] drm/dp_mst: Only create connector for connected end device
Date:   Wed, 21 Jul 2021 00:03:40 +0800
Message-ID: <20210720160342.11415-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210720160342.11415-1-Wayne.Lin@amd.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49015f0e-f2e1-4f6d-8aa6-08d94b984a3c
X-MS-TrafficTypeDiagnostic: BL0PR12MB2482:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2482FE304E8EC057AA81BA9EFCE29@BL0PR12MB2482.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gADEMcPxn1UnejJ5OE5GgmoxzRJ6BeCWQcSCsPdge5bHDOTCIOdC3gG77iOicdRFtfSzREvFyOyQfxJDnwYOrB/WWJwU0W4DCpmKD2xX9k3Sd0+TTYb8gtphgBSI0edqLQJXIbrFmeS8U0ZX9f+7INieqJ2tpzcV10CxQffjq5QOOuMOHxpeXeSo7U27EsYb0C033LD8x8+Q/Ku0+rai60usenrsBXfKTNtxVtL1NApmm0PoMIZD4e/Tx8UhjTAHi0EmwR8qBDfAiA8RE2xgxi/zDYdK2YiSLqH5qLOKciqdYsx2FXevqqjMIHhp3KzuF7nf0yLwPCgJ1n0iffOzvm/beBPAKf38frclhnm03W89WxiPTl6OdmjmwQfpyqNTufIQLLw36YXRuBwezkwaQ/KIqa98MBB5ccFGu/+AXilWoQMThagQ/IDwB98oG3F+XAzFUs6QrIpLJnW6BVOKwsHYyiBcPG3cZjwNiRuTcsjOIvOP36PbTIR4QADlnrjUzszATy/jsF4+sRzz5EXMWYIcTsfOaRaaIhd37P3oyfeThiEfsk1zT36QglC70DnzgY6GifteBC/G7pt9MKC8LZwisQGZ3hU4v33zacdK8aLyJMN1rFOzuE9VoX3uIwpmqSrbkmWm67UHZOvnE6iR3Sxo86d6SsYC3euph6xeDWX7TjWruOYVJBCpqPZeTL+CluSlrXKrkWYh9kRdob+CpatXOPcgFl4aiRTK3U8LaLM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(356005)(1076003)(83380400001)(478600001)(36860700001)(26005)(82740400003)(186003)(316002)(426003)(6666004)(7416002)(336012)(81166007)(8936002)(2906002)(86362001)(2616005)(36756003)(4326008)(5660300002)(66574015)(6916009)(54906003)(47076005)(82310400003)(7696005)(70206006)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 16:06:10.1699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49015f0e-f2e1-4f6d-8aa6-08d94b984a3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2482
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
Currently, we will create connectors for all output ports no matter
it's connected or not. However, in MST, we can only determine
whether an output port really stands for a "connector" till it is
connected and check its peer device type as an end device.

In current code, we have chance to create connectors for output ports
connected with branch device and these are redundant connectors. e.g.
StarTech 1-to-4 DP hub is constructed by internal 2 layer 1-to-2 branch
devices. Creating connectors for such internal output ports are
redundant.

[How]
Put constraint on creating connector for connected end device only.

Fixes: 6f85f73821f6 ("drm/dp_mst: Add basic topology reprobing when resuming")
Cc: Juston Li <juston.li@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <sean@poorly.run>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Eryk Brol <eryk.brol@amd.com>
Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc: Nikola Cornij <nikola.cornij@amd.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: "José Roberto de Souza" <jose.souza@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 51cd7f74f026..f13c7187b07f 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2474,7 +2474,8 @@ drm_dp_mst_handle_link_address_port(struct drm_dp_mst_branch *mstb,
 
 	if (port->connector)
 		drm_modeset_unlock(&mgr->base.lock);
-	else if (!port->input)
+	else if (!port->input && port->pdt != DP_PEER_DEVICE_NONE &&
+		 drm_dp_mst_is_end_device(port->pdt, port->mcs))
 		drm_dp_mst_port_add_connector(mstb, port);
 
 	if (send_link_addr && port->mstb) {
@@ -2557,6 +2558,10 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 		dowork = false;
 	}
 
+	if (!port->input && !port->connector && new_pdt != DP_PEER_DEVICE_NONE &&
+	    drm_dp_mst_is_end_device(new_pdt, new_mcs))
+		create_connector = true;
+
 	if (port->connector)
 		drm_modeset_unlock(&mgr->base.lock);
 	else if (create_connector)
-- 
2.17.1

