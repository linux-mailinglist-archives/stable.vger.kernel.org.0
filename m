Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5DE3CB36A
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhGPHm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:42:58 -0400
Received: from mail-bn1nam07on2044.outbound.protection.outlook.com ([40.107.212.44]:45481
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236137AbhGPHm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:42:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hml73SE6wuLbd0fDPZhFWOBhrS0ADwV+SSVbFzq0CsFe8Ow2f5Q8kcFToegPBGuDgZzu68iTWU6l6bCyMA/VBJOexkspzShOFwjpERryv2z7TkH7cmAVzreAQ6tveJyWjV39+QE0ghrSA90jwmpyHKQAoE9A05hLVHuRYs33pr37wKdVuylfdQ/WI5pDoXt12CTOS4hZfbSLZy9MzPW1SK0V+NYpe4F7szn1rk3e4avtgv3zDwOX2YPfrFIjAZG+9yjLddNMfjVqF96BaOnYP66lwtyJXaTSVBpnhHSZ852rN3Inx98TH1P+25QIwJY5IGuckRSUaGmgDMklRulj0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXzevfx3nbeXgxVN+ji8/XAT90y4RJ3s610eYwu2ocA=;
 b=liRIo9MCO55XaXaBlN64I70sztfgUPR8tcDvfHfdk6/Pv6ez0hRwkq6KgfKFaVbraJPJxop/43gH3uxnQqsZinFWKA/7/lvh/GU0ZDburYfUWWuXs9zJMAet1RA2z7BCHmghK1Bq6mUoXl6yKIY+xoZyyNlJDo+6gtseC2Ik8LzLLGxsII1a/4aq4fm3wCJahMI2/RhvS/KQ3v9BaACwHpIHacKRwtyGKwjnfnHz6/P7fEAQjFQs3ZkXPJCT8SOMz9TnYCYHY9ok5DrKCSrrI4rjDttYCnFFd7kiSEi1xwPqeT2neiwFhKyD3R0b5eGzu7Hkir1T/8e8EKMwFj4IwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXzevfx3nbeXgxVN+ji8/XAT90y4RJ3s610eYwu2ocA=;
 b=VCQgTc8GkrIaYSca1MfO758x4h9FAt8ghH2Ss2P6r2gp+rNY3hMQj9br0UWqfWyuNxszfKxourajnVlQypgiGGhX5XpPm4J0/sd6fghYtxxUtbr3nTYCaH5JhmH5waPmkX6OLrH9+QzO8mKYNcoKcsCMb+AVV96Q3kGTYIHQtYs=
Received: from DM6PR06CA0101.namprd06.prod.outlook.com (2603:10b6:5:336::34)
 by BYAPR12MB3158.namprd12.prod.outlook.com (2603:10b6:a03:13a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 07:40:01 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::a2) by DM6PR06CA0101.outlook.office365.com
 (2603:10b6:5:336::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Fri, 16 Jul 2021 07:40:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:40:00 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:40:00 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:39:58 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 3/3] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()
Date:   Fri, 16 Jul 2021 15:38:31 +0800
Message-ID: <20210716073831.27500-4-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716073831.27500-1-Wayne.Lin@amd.com>
References: <20210716073831.27500-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb7351ab-e5d3-4ed6-4ec3-08d9482ceb27
X-MS-TrafficTypeDiagnostic: BYAPR12MB3158:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3158EB726FA2012D26E68C25FC119@BYAPR12MB3158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:127;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+dbZWTGkOiMIqJ6RNSquh1hbeiU9tD7GVuru/VSJsFu6PzBlZPtgBwsBtLUamcZvg4Fufp29OKcNJ5krqQuLA8UWZH8WYOMuOOQgtHZVdXTGtmP+5+WN33ictgawYCwGE/nDgMi0TqsrunytsOkMTCPKL0gEgD7wpHWAgQXMW75JBjpy49jPbyuF+kDk8brn936csjnIIdAGgmdyfJgFy4ZIovQeusdatwh6FZG295yg6Icwn78k4itPlclxt+O2Qpj29ZRSW/csIUhzUAuC3tF5D8zx2l9yWqOYd7gOmTf6SVZyEvNVxaiTluXCcBIdScxzMqVudPAg9Zhz9vNbULyHuUNtW26a6pTRG5p+WHvKOWa26ncYG9c3bWRFR7GzLsoFkr5u6oxD1ip2+XKj02Ini7z8rLEgikm4tQtSYhJzDNL8I5zpby1Mi9ddrtJq4dNkoagBrHv7ApZWL99iOujwEdUNeGE2stjK+BvS6oYpJgrDaHGQi2AXB/LVRxYQzDLj8NeecubAsJab8hUySQbvvzNVT22oSaigtntqKtrT+vqOdMSRd7cL/HfUY2MRUyEDl43GBSl8lVylufxltDXtVwBPAtRRZGgA+zTFeD7B1hd6C5tK+DG6N0qSmGa4oszSIuYYWQJPnYvVt8ymOl0k/vZFykuP+qYlc79U2E1ciV6pHvAP1KhSIu4+52tX3xBKwIcRPw5CDLluPaulNkvO4rJAZxH6k29r6cP0Vo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(186003)(70586007)(8676002)(7696005)(6666004)(83380400001)(5660300002)(8936002)(336012)(110136005)(2906002)(36756003)(1076003)(4326008)(70206006)(86362001)(36860700001)(966005)(2616005)(26005)(426003)(82310400003)(316002)(81166007)(54906003)(478600001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:40:00.9599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7351ab-e5d3-4ed6-4ec3-08d9482ceb27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3158
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

Commit 3769e4c0af5b ("drm/dp_mst: Avoid to mess up payload table by
ports in stale topology") added to calls to drm_dbg_kms() but it
missed the first parameter, the drm device breaking the build.

Fixes: 3769e4c0af5b ("drm/dp_mst: Avoid to mess up payload table by ports in stale topology")
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616194415.36926-1-jose.souza@intel.com
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index b86a2b7fef39..dfbd90431043 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3385,7 +3385,9 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 			mutex_unlock(&mgr->lock);
 
 			if (skip) {
-				drm_dbg_kms("Virtual channel %d is not in current topology\n", i);
+				drm_dbg_kms(mgr->dev,
+					    "Virtual channel %d is not in current topology\n",
+					    i);
 				continue;
 			}
 			/* Validated ports don't matter if we're releasing
@@ -3400,7 +3402,8 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 						payload->start_slot = req_payload.start_slot;
 						continue;
 					} else {
-						drm_dbg_kms("Fail:set payload to invalid sink");
+						drm_dbg_kms(mgr->dev,
+							    "Fail:set payload to invalid sink");
 						mutex_unlock(&mgr->payload_lock);
 						return -EINVAL;
 					}
-- 
2.17.1

