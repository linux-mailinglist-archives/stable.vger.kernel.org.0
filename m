Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9BB320FF1
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 05:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBVEDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 23:03:17 -0500
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:10336
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230088AbhBVEDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 23:03:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuVf5ZJlLhCzj4+9ohIL1tln7n7oLXjd8LueqAEy5g8kjN+WFtsqEBT13EgS8WCAdDV1TP2206tkue12J0nLiTv2VSct7RFD6j0P/zwg4hL/7kD9Vluc1KLQIxNb9ehw17R3UK9ErKWl/MOYkRRXDfGLcH8C4qJBQSaMfFwktJ32cuAZo9zYxuyGeg2rQoPL8sOq3j33f/FUrqYmsJXJFF3xUQU//jsKTvqMZPxRhs7xf9qFFGkm33WpwzfjRshdgL0yNhi4g/MT/nyOC5zD3S9S2FXx7vVncN362nmgqwboDHhuI5xEMvAjg1Jmg5xR4C7cLDL5vRgGpTzMKy+Cgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhVhdOHfwNRkva/B95IixZ+SSlKUTMAEcZ3hshAnfEw=;
 b=F+uKzDhosN8xX4v01gRnpOanGxC/NsS8qaXBTNsPLWXqhX+xJ0VGQ011GaxR0Icxm9Dt+4moUP7JBcumf8CKt2meKWmCYem7Q9CQ+70MQ6X4IWzpiLn6Tew/f4iSAs9oKvjvuDhDufxt1mrXOSIVG02oq+1P/K1LWRIbhmKructVor6FX7oTzTeMVknedOUbdEG307YUAnIj3h0PBEnMbod71Fo4bS9yPKdHVP+tKG1k5VrGkfOKXU73dJPe+1VWOD9Te4d98PjQOrM7b/Mm1JxjvQmfiYI1xR/mdPqKfDLSoQPVk1drOmIGRwhWNwyBO6j4NHg9AAE9rxeyP7x6Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=amd.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhVhdOHfwNRkva/B95IixZ+SSlKUTMAEcZ3hshAnfEw=;
 b=QCCCX81gfdtYlrNFKzgiKVNU7bratj2JdWz5YP1BIkYUhLEsSMFtHNI45tS7+4J+fg6crB0nrM1gX0ODB3miG/SskoiILl8BPLkSVZqZY0r22EPmOgpGldHDGr9fqysFM+uJrh3yk/lrEbP/4FF30g359KlBGzCJhA1C1u67x3A=
Received: from CO2PR04CA0117.namprd04.prod.outlook.com (2603:10b6:104:7::19)
 by DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Mon, 22 Feb
 2021 04:02:28 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::98) by CO2PR04CA0117.outlook.office365.com
 (2603:10b6:104:7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend
 Transport; Mon, 22 Feb 2021 04:02:27 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none
 (message not signed) header.d=none;lists.freedesktop.org; dmarc=fail
 action=none header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.84.17 as permitted sender)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 04:02:25 +0000
Received: from SATLEXMB01.amd.com (10.181.40.142) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sun, 21 Feb
 2021 22:02:24 -0600
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB01.amd.com (10.181.40.142) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Sun, 21 Feb 2021 22:02:22 -0600
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <stable@vger.kernel.org>,
        <Nicholas.Kazlauskas@amd.com>, <harry.wentland@amd.com>,
        <jerry.zuo@amd.com>, <eryk.brol@amd.com>, <qingqing.zhuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Date:   Mon, 22 Feb 2021 12:00:27 +0800
Message-ID: <20210222040027.23505-3-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210222040027.23505-1-Wayne.Lin@amd.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04da3294-41a7-4ea3-5050-08d8d6e6aa50
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33700CB0D5B57E0D4E77D0C9FC819@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ef/dlun9ArR6RYDDTp3Wy5WgwA2GBl7J5z+huCAAaFb2xr4NntVhhqIdgOnNOtHwr3t+QS43YkzqCBA5jLPBiLlVUznZzSJzQMy1SEgHF/ddjy1MIQst6XGGM8bKfemje+7AFV53ObL1xnkwOIQAwjTWyNSMYh6QQ9SbAxaNfmraCZalpqZY1BJKcQrHjO43753UWSU4olK2jgsJHV9AMZ6tLFjhYxigTyr2+Mhsj1SiMTNk8sAqxjHU57Nb8Sxm3rl5CZZT3V2FT/hpG6avjc55lYH+FidoYm6qUx/fXMhBg4LlP2/oEBSyN41iVSfR5NPqptKmIIQ9utd2K50c45vGJWIFqnBBHtFDPwfMfy0eHryN9U44/vH2SZ1x7M+9MeCJPJpqEwA99mZzeIVrdfAtZOWD46D7EHOrWH6dXvpr165AVfL5Avra5W9OwQFSDSAkf0MYuGkt45goRrDdOihh31+mIaMh+AIAEf8YPcilah+tlHPzITpuCz2T22qafVcBGr/4LoF+Pn8qyybFNTqH30tpT9xYtM3Bb5NLhTS286syILDBaKpyTMJD6IPwS8QgthzoMqNM48DceTTxKibWOm+dN6wHZCMr95Vi/UXUdOV7kD6E2qi+yO8FPqo6X4TZY+ceXPRcaZJmKiuzP3iaiI1hgD4cOZBmYCWTRPrw4pOOFVDoiP/IoxOhXBIH
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(46966006)(82310400003)(186003)(5660300002)(1076003)(54906003)(4326008)(2906002)(86362001)(7696005)(83380400001)(36860700001)(336012)(36756003)(316002)(6916009)(8676002)(81166007)(82740400003)(478600001)(8936002)(426003)(70586007)(47076005)(70206006)(26005)(2616005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 04:02:25.9468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04da3294-41a7-4ea3-5050-08d8d6e6aa50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
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
index 713ef3b42054..6d73559046e5 100644
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

