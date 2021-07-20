Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50F3CFEAA
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhGTP0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:26:00 -0400
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:41632
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239112AbhGTPZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 11:25:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQn5n2AhyPnfyDE06VpXkM+lIM+nSpPl2dJ46yO6CVFZ3fKAVgOZwnwYTkac5V+tME0DiuPyzSd7GT381gHVh4XPFKbFc+LADE+M4ibX2Opes9QYLkulGGzJFHeuV42hMw30Yu8aZT4cXAA7ckQX7JiMOTrkwD863uplPyUvPb/0qh58ntLAKtxt+yNWJ/5092Ng+VdoVY/hGQVhrVGLX1nGPqKQxd+ELG1TnJ4KMnVHdwrI2Mb9JdsHKOuHb6DVUl7kr5NZlmE2e4WwrEv9LTmfPh8fAG24h+BMgzJ/vCPLPMnXUI2mldHWwkx+dRrKEMTNKaezS1MAFXcCdYKQew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObpvobRwDFTxdLEuwNKXCWqKl11FvEP01gDlhjRAz+k=;
 b=RfvoyBATMLrq7TWz78aG3lF1Xn5JzQ0e/1y+InYXJnHBc5mq9tswGKzBFPtQiuIK/PmbCczbtwWRQLsfcBuOfqgajmb8+82C7NiGxVvkdOGRsn4+66/MlOj0v09gB82jtm8TCOjajxSFZ7wqAe9afqMvpfJ0Vx61ZHNqf0qlEdmCD7jj56xxcIzX3uGYWsipOzAF2jiv1d4zlh5KH3rZg2pKHk8FRII4bkmpMMGOFhjwR2bXWjrBBvwnpDEOeD88mJP0Aal+k9FLcmMn3KX7ziKqU33Mel5ozyFP9tIzX++b8l82DJs2GcCqvaGcB9uTbYbKmVkaM4/U2MKKV9tuPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObpvobRwDFTxdLEuwNKXCWqKl11FvEP01gDlhjRAz+k=;
 b=YGC5vTiUGz1AJ7z0ue8qBWd9oVHgWhsN9aEZTDiFrx617lcKgbemL14aDzMtoyjUI2Di1nQYkQiVF3zq8HqYqZurzyvydDppZxjpbOpBj7UQ9w890bVQRqIfYhPnmpYgMvKYkd5q+JpsOpdKhu7Fzs/l3/M7D0h5XsxEx+87F20=
Received: from BN9PR03CA0089.namprd03.prod.outlook.com (2603:10b6:408:fc::34)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Tue, 20 Jul
 2021 16:06:12 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::53) by BN9PR03CA0089.outlook.office365.com
 (2603:10b6:408:fc::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 16:06:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 16:06:12 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 11:06:11 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Jul
 2021 09:06:11 -0700
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Tue, 20 Jul 2021 11:06:09 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>,
        <hersenxs.wu@amd.com>, "Wayne Lin" <Wayne.Lin@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 4/4] drm/dp_mst: Release disconnected connectors when resume
Date:   Wed, 21 Jul 2021 00:03:42 +0800
Message-ID: <20210720160342.11415-5-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210720160342.11415-1-Wayne.Lin@amd.com>
References: <20210720160342.11415-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9052a7b-5e8a-4c8e-8079-08d94b984b73
X-MS-TrafficTypeDiagnostic: DM4PR12MB5183:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5183272A9B1DDD19757D46A6FCE29@DM4PR12MB5183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngzJbE1vCiffCaNIF7qLWz7jYwQ1M1TQiJkV0vMGtH+FtLujyeTwZR4HF29Rd99VH3rTFg8UwvP5i9jRKMGIk2GjQwExnL+bt2oGo5qdNfXkOLsB9H3Et55BCUCzIrjfXP6yoRLLeAD0W6MzOhOJqi1q6VIShaMYoI6CyeWE5hFSqP9o4x/LYgtK1PVf/A8SdIcQXhAEJTPG1L+BJTkMUCWFn/QaArM2A8KEhNkCEBV6qlx81ZzHZGU0oMAvKqFdD1LfqE6zwSNihbYePdIgcxNAMpNCJ2ZSYWlPgkzUaxdawikyFvWE2j6jQp1Q5LQEb3vW903kyiIQa2QlxibX2OpPXWJ780LND3XeqJfN/JHJd4CDxBPWcOMBDWiPAV+G9rw4opQhHa+Jg2oxXeLD0d91f40zMMFZ6F42cCpxflGafPdF+Z0ZX9YWCZTeZjoq2G5hfmHhYGgE7xprks0aCM3n6SaF/f19IByUmwD1ShNm1qUhrD978UCkBtbtGlk0hlyVUtfDqSTUjISbE0J2x4/nJ2Jq+PCuY3R1STv0YGyLRPcB3i4iZ2wTqiUW4zIgJSj6TRT0xT+vj6+Bu7ySw80RzKCUFgDv+gef8hK/3KxiZIMREhOCs1HID1OFx+zKUJQRuXdh6q3oek0nVmoTGUSAb8lXU8WochWkKgfABFIqU0psUq8Nw6/yDg4m1QTQEzxVhMqdxydwqUQ+oWQUeGmChuMSFFycG4pTYDSlKGo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36840700001)(46966006)(81166007)(7696005)(36756003)(5660300002)(8936002)(356005)(4326008)(1076003)(36860700001)(26005)(2906002)(47076005)(6916009)(6666004)(70586007)(70206006)(8676002)(82310400003)(83380400001)(186003)(336012)(86362001)(2616005)(426003)(316002)(478600001)(54906003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 16:06:12.2079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9052a7b-5e8a-4c8e-8079-08d94b984b73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[why]
When resume, we will reprobe the topology to detect any changes during
suspend. If we unplug a branch device during suspend and then resume, we
can eventually unregister child connectors of this branch device because
we call drm_dp_mst_topology_put_mstb() in drm_dp_port_set_pdt().
However, we don't unregister connectors for end devices which is
disconnected during suspend. e.g. Unplug a SST monitor during
suspend then resume. We won't unregister this connector which is no
longer exist in the topology.

[How]
Unregister connectors for disconnected end devices when resume.

Cc: stable@vger.kernel.org
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 85a959427247..0b04ea65cb8e 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2478,6 +2478,12 @@ drm_dp_mst_handle_link_address_port(struct drm_dp_mst_branch *mstb,
 		 drm_dp_mst_is_end_device(port->pdt, port->mcs))
 		drm_dp_mst_port_add_connector(mstb, port);
 
+	if (port->connector && port->pdt == DP_PEER_DEVICE_NONE) {
+		drm_connector_unregister(port->connector);
+		drm_connector_put(port->connector);
+		port->connector = NULL;
+	}
+
 	if (send_link_addr && port->mstb) {
 		ret = drm_dp_send_link_address(mgr, port->mstb);
 		if (ret == 1) /* MSTB below us changed */
-- 
2.17.1

