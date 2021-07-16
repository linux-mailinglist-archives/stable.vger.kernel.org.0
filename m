Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACB23CB376
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhGPHq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:46:28 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:63329
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235441AbhGPHqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:46:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9TM1pXRz7Qyk2IxoE+Xm3Zn3Wn4z8arcHomNQ+g/u7pvKyJ4+m/m1QQnbVPHX7JKZpRYkbBDCMu0jFDD5PqkraxdPWxWajTsLrcKzjEqj33nHjlLNGc9R9u1gJ6sAV1Wy+24mbaWtk7YKYhFqsEMxvQnMK12LtByJrOYBGUj0FzWgaVTA7Vjhd8dL/3EIx9mHNH36AF/DsYWHgDfaoVHY/RefQD3ThqQsf9nuvb8O7tQwPiIvUejsGm7efB30nyEl028Kwd4MrWE8xw/zUNct1YxlW/uoqeVWImxHQRCHpiyUegA+J4E20xh/yfXQ+Mx4a1Io/Hfe0rKZIvqkHvJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh1+17rFOL3vDQmi1Kk/4K/5RWZs63ouXslu4lsb9Bk=;
 b=KoTXTZ29/wfAIlB2u2XXJl+55bd0Dm3j5t49A61dLqxB3l/GpcbLDHr8UaogN54OY+ueWfNDDYZpVAPPHKzrN2bu8nInbcB9Ijv1T/uR2C+WEtdZCP+uwyXEKuVX12QABWfsQDQIsfrX5/0hMF2HOH7J+oMw/uPm+RfxD4/yeDMKX+3pEy47hx4ZXUSewzgLgjcvJvExxzZIDXvoXxVk3zmK723D8N5MFjvzbMLa015YOrhZwRzZzHf8Zj8r/kG3nHZp5tu9NH4ycLffOPAiI27KJ4Q1FlnzP+e5x4Q0WD6w5SVyk0oLZgbirX8AYnR/AElYJNkPhSlTSvLKuMSXVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh1+17rFOL3vDQmi1Kk/4K/5RWZs63ouXslu4lsb9Bk=;
 b=r3OcoWUiVu4zAB880r/OQeDY47LbzERoegKQZKAt/TAngV5oA3UrgCEm7BSHEJAhCzhu9XXSjqTijWuJ9ltuf27gi5ElkKRg6fVv+mSnoPVeWW90LPe0MVoekqW89zXhw0IOhxTLWKZCwJWh5z0T2tmFuyvUWLLsmk3DaYYaFDE=
Received: from DM5PR13CA0020.namprd13.prod.outlook.com (2603:10b6:3:23::30) by
 BN9PR12MB5289.namprd12.prod.outlook.com (2603:10b6:408:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 16 Jul
 2021 07:43:28 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::b2) by DM5PR13CA0020.outlook.office365.com
 (2603:10b6:3:23::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.13 via Frontend
 Transport; Fri, 16 Jul 2021 07:43:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:43:28 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:43:27 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:43:26 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 3/3] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()
Date:   Fri, 16 Jul 2021 15:42:01 +0800
Message-ID: <20210716074201.28291-4-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716074201.28291-1-Wayne.Lin@amd.com>
References: <20210716074201.28291-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 491966ad-9bbf-4a99-e5bc-08d9482d66c4
X-MS-TrafficTypeDiagnostic: BN9PR12MB5289:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5289DA794E4F0AC0B0CF0936FC119@BN9PR12MB5289.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:127;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42DO0NYCnxyRgPrhbJrha1vIj76j00m9/jAINXMQ/ydKrz5vsFcWMfhc1k9N5IhlzbDrqa5ycHEzIVtvB6B+CbYkdQo3DOAKV1UYnhy0u9CmjtAG48vxz91FwIa9OoI9trVdK1hJTFYFRw/fjZd8ZhqUDgrqfRtSPo+riTMfsxbhFXuG5jZZojoqKmY248J6k0K/X6Bg8tH0MjjwRhLv/ZlCPEgORSzIDq159jSdhdxVSnXfgME4vT/vajTVSDWRQ7P/ZmVvGXeNwjluQaNiXWd2ByOjxxzBerUgBdk3Alp1GKeFy50QTGjV2DkyGv995naI36GP3WCSByWD7SSlD6jZ0WEL7nL2+gjmcpK2yD4hVLMizZj1L8swsJ1H5trw+tKPTZkoYXNzvrSoOSuParWscFFZgG2JzOZbv8hFqqCzZwpdlT1F034Lw0SDd/YJDgHvjCKtBHwwmS3E2KbHKF0ueCJJKbyrRepmqw7hhRmTLcvwGJF3ecB3x8+xTRMAvrbbQ6veYKB8XGaHoM/GEaBrZ+/VN/hv5a+PbeM7w7b77f5RZu5zJLV/W34y0O0sNla9b9KjwTGhYpYEpsmjL36B2N8TPmvJ5o8wiJDsGbZznPOCthWZ9oRJHM7+68gWehILEinh7Ma0Qmij5HPNHV3VyT/h7Ny4X1fesu9135pXQ13IhbHJjo2SEdEQfxZFxMrPVyBm4cBOGIBELcyWQaJMf3k44QO51tAW8szWl/A=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(426003)(8936002)(316002)(2616005)(4326008)(82310400003)(8676002)(2906002)(1076003)(70586007)(86362001)(36756003)(186003)(36860700001)(6666004)(70206006)(478600001)(26005)(7696005)(966005)(356005)(54906003)(82740400003)(83380400001)(5660300002)(336012)(110136005)(47076005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:43:28.3514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 491966ad-9bbf-4a99-e5bc-08d9482d66c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5289
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
index bf6fa98b4ab7..a68dc25a19c6 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3383,7 +3383,9 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 			mutex_unlock(&mgr->lock);
 
 			if (skip) {
-				drm_dbg_kms("Virtual channel %d is not in current topology\n", i);
+				drm_dbg_kms(mgr->dev,
+					    "Virtual channel %d is not in current topology\n",
+					    i);
 				continue;
 			}
 			/* Validated ports don't matter if we're releasing
@@ -3398,7 +3400,8 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
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

