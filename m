Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C3323A57
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 11:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhBXKSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 05:18:18 -0500
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:40129
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234855AbhBXKSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 05:18:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1f2P3yhLHYHU9NZ+aquLjHSHGR+slZ3pNns1o+enRQMpD5YR6DvBKyia3ePOmf8+evoYs037t8m7KAjWnpmPMRFSOCc4qb74NehIlCcorP3kwmt3xnbqJ81eOhY5oCwdVBHaEkjXIHjyvKV4Al/iX9lKDEM6CNOWGgXSG1UqTfyVsom3wVaUyoNHnhwc6RzlE932QF9B0j7cRGbAyUIqwV4y987o0LCDQTcrMlSLma0DVa1RUScUmmAWM+UDlbxaTgwSI4GQw4aOctL61rwSUnB1N/MuHkWu3wPxRzUznyFVACpyKI6XeN+FB3zKsGnd3RvXrvM3lln7BD20sJOFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WEP1rtU3coCRUi9rCYPz3zRmSIrPhmefGygOyX1n/g=;
 b=gKqxKrDK/JokwO/OChDRgElovVn1iHrN850BgrMEG7giBVPmUum/xOQQEGfnfLgj0zebMd8yGF4GAlAsbFCeirpfsT5bvUWGykCf3FzBQaPl4Xfx5qnm/ODhhN9FgsJa/H1cnXqYJCtdqlwqGR5nqbwXhrCopb2ikpWizVYgIzCYdNiYh7WowQ6dK17DgQxhGvQd8EWZJzSjYU/9Sr6qSXWK5CnOjBDE8hjos+2uXMqCFUqlqMXZp2zGR3/yVOyxoRIqiuKMcvy+sF3bo/0JqRYb6KVHSRhM5BvHQKI6BmZ+cIDX06Y9vyTIUogxGjJJTQeo1+0WyujUJ+EkR+sJ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=amd.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WEP1rtU3coCRUi9rCYPz3zRmSIrPhmefGygOyX1n/g=;
 b=UyTamRBrLASjLXt4Mv1XoXWjaCNO4wldHjqeB4sIRR3OweIBizllC9SUNNWN9fTAxYqJg0uqGZWXQ1w6QcBLNbBck1jm5oPOJssnkyEA7Wj5UhLxMo0LwfJ9GUgyPiIn/fdNaVbjOGsfuLbQJkxHBEoEIIw+14+M1BMmac4jhGM=
Received: from DM5PR1101CA0022.namprd11.prod.outlook.com (2603:10b6:4:4c::32)
 by DM6PR12MB4498.namprd12.prod.outlook.com (2603:10b6:5:2a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 24 Feb
 2021 10:17:11 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::b2) by DM5PR1101CA0022.outlook.office365.com
 (2603:10b6:4:4c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend
 Transport; Wed, 24 Feb 2021 10:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none
 (message not signed) header.d=none;lists.freedesktop.org; dmarc=fail
 action=none header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.84.17 as permitted sender)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 10:17:09 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Feb
 2021 04:17:09 -0600
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Feb
 2021 04:17:08 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB02.amd.com (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Wed, 24 Feb 2021 04:17:06 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Nicholas.Kazlauskas@amd.com>,
        <harry.wentland@amd.com>, <jerry.zuo@amd.com>, <eryk.brol@amd.com>,
        <qingqing.zhuo@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH v2 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Date:   Wed, 24 Feb 2021 18:15:21 +0800
Message-ID: <20210224101521.6713-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224101521.6713-1-Wayne.Lin@amd.com>
References: <20210224101521.6713-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a0bd8fa-1046-4106-6a21-08d8d8ad5877
X-MS-TrafficTypeDiagnostic: DM6PR12MB4498:
X-Microsoft-Antispam-PRVS: <DM6PR12MB44983DFA333F7CCBDE5CA703FC9F9@DM6PR12MB4498.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JktcPcyKsZpMS1IRmt98c3/TDYUMDsKr6nhyVTu46DfzaLACiOMduf5+/8BbeNLNsRXfFpXKXk/YjR+05yq4O+2WIMPIgB5/DUyQ7fAXSEeoGAiNdp7Cj7yDcTJEEKcL5F/FqtOcsJpz6Dm9SxShHqNHXepIsQ/fUlQDSu1NrYkfR/nsSc/l3Eq9tJaimELy05dP9dPmqQG6QqoN4Nwm3dF97pBMgqiCBQF+nSjZp6sPM0QL+7DSnMclylA3gOMl8LPcS7aNgX86Q7bnSvmWL5FrS5PhR8wp9AKGc4dRC1QVK+YLTzw8j8TLq2DWR4OnOOKQT3rVCvSsD3JJNxXpkkwaXc+aJCwsBMSWgXZ9R/7IJbiGhsDsHXmPZ70aCN2NhimyDlOA0fVnsAcOh7ZYptoyOCqydIjiFScjTCEw2YLSB9M/bDbCxUrrTjHJkcTIvF4NyNuQ76D0EgJeXRALDktp+TY8cTsSm+hk14hv4FN10xZyZHuR9lYWdBZp6Wlu7k7v7T7DwK3HFGVKGLFuO4CcfhFTczYEKJGMs2mkzRau1BjoUvHykhldqO1BrdRmTRZrOOXijs+Rws7QBmxNF5/XYvG1ZyUKJlYuQemb3b+Vnj0HWUkv4rckXuKGu/omZIFQAf4GApHWE/SOZstoF4FiSt7tlV5x2jgiOtIGCT9gYogAXKweAtKLIHYYV20h
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(46966006)(36840700001)(83380400001)(82740400003)(36860700001)(426003)(478600001)(54906003)(5660300002)(6916009)(6666004)(81166007)(2616005)(36756003)(2906002)(356005)(336012)(316002)(1076003)(26005)(8676002)(186003)(70586007)(70206006)(86362001)(4326008)(47076005)(8936002)(82310400003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 10:17:09.7098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0bd8fa-1046-4106-6a21-08d8d8ad5877
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4498
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why & How]
According to DP spec, CLEAR_PAYLOAD_ID_TABLE is a path broadcast request
message and current implementation is incorrect. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index f11b3f718031..c32b98389349 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1072,6 +1072,7 @@ static void build_clear_payload_id_table(struct drm_dp_sideband_msg_tx *msg)
 
 	req.req_type = DP_CLEAR_PAYLOAD_ID_TABLE;
 	drm_dp_encode_sideband_req(&req, msg);
+	msg->path_msg = true;
 }
 
 static int build_enum_path_resources(struct drm_dp_sideband_msg_tx *msg,
@@ -2722,7 +2723,8 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
 
 	req_type = txmsg->msg[0] & 0x7f;
 	if (req_type == DP_CONNECTION_STATUS_NOTIFY ||
-		req_type == DP_RESOURCE_STATUS_NOTIFY)
+		req_type == DP_RESOURCE_STATUS_NOTIFY ||
+		req_type == DP_CLEAR_PAYLOAD_ID_TABLE)
 		hdr->broadcast = 1;
 	else
 		hdr->broadcast = 0;
-- 
2.17.1

