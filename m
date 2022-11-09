Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95706223C6
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 07:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiKIGP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 01:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKIGP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 01:15:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE04E1EEE0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 22:15:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSchK8KfvDol0rFGrHTu+hLCaaS2hrlU/eIb12O8rSmp4dLDlQ23Krvu1KZUqck6+8LxoB4o3N3BjbKs94AOef8b8VGvxbyU2/zLqAQElBPqgCTZ+XCzgUh4BYfQCWdmye9dgZDbiVPHPs+agmyNWvAFyNtvfXquRtstdDS6kkrrR97X05ZRYmyFaVcAo996NACWen2Wm+aneqSPWntwVuNZRqZC20AxtaMqec71GMNt/7sAf4Z94vQtWLKDEoZ9JWOB90ryQ0ycuVxje4+asMh7PG1xmxe6MV0TYSflBNz4HeeqmXfpSMV1K+ZfN4c5vyCdFLY68xUKxQsF8MOxLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2yB8mv+NtBDBGPCp4+OdESSnW6o3oqE7V5Z+VvP4zw=;
 b=a+vVA3VAKUHarKT7enBUX15Ihenh0z4QmTAzHJcw52njD2u76cmj7RQwv1UTay1ZaIDazJiG+B/dAuw+ttmPJbrQ9L53odwzVWvzXmeli7ZrrYz10ewOJaUL4N92TogJQsTK3uSgw4ozD9Qh2ADn8BvTcCc4FmJtvNTnglH7kC2q2Uf8CHbjxsDXNLOG6Q6pk5XGAVhjz9ySVottWzroijGytPYyB/4O2viV4uhxqDE+i1ZteEugE7/H/7JBjUE5/SI4H6WZEdBphkayOM9tEp2uV7kbUOtqsqVUj1G+XWzuBvdm5PrA0gdgGjxrQpXBvOTRNVHnXx7K/qpt7Yd+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2yB8mv+NtBDBGPCp4+OdESSnW6o3oqE7V5Z+VvP4zw=;
 b=F0PuI1TlHrFBuzZr5w/VRreXhRAHgiWsY8ysKSf5+BowFiZgvgr/eAn13yjnE8oKhcNJHh5h3p5j+jYX+/inxoN+nnX3S7ptem5X087+3SL25IbI9Tuk4nAvhZCz/MxzhO8UqJv7D3Vtu5wyyrYDHnJwxXgTV0ekeoRHgnHCmV8=
Received: from DM5PR07CA0084.namprd07.prod.outlook.com (2603:10b6:4:ad::49) by
 CH2PR12MB5004.namprd12.prod.outlook.com (2603:10b6:610:62::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 06:15:24 +0000
Received: from DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::d8) by DM5PR07CA0084.outlook.office365.com
 (2603:10b6:4:ad::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15 via Frontend
 Transport; Wed, 9 Nov 2022 06:15:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT091.mail.protection.outlook.com (10.13.173.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Wed, 9 Nov 2022 06:15:24 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 9 Nov
 2022 00:14:37 -0600
Received: from tom-HP.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Wed, 9 Nov 2022 00:14:28 -0600
From:   Tom Chung <chiahsuan.chung@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 01/29] drm/amd/display: Fix access timeout to DPIA AUX at boot time
Date:   Wed, 9 Nov 2022 14:12:51 +0800
Message-ID: <20221109061319.2870943-2-chiahsuan.chung@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109061319.2870943-1-chiahsuan.chung@amd.com>
References: <20221109061319.2870943-1-chiahsuan.chung@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT091:EE_|CH2PR12MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: f7fdf333-48ee-402b-e5a7-08dac219c9b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cj4qP9UPX4CT0a6Y29mYkKuKVLa2YQJ38I5oz1EwX2EWN/Yjh9HAUE9t3e+nnlh8b4EsItvSGbqoiEsBiLSDw0rP/81XpW5LaCAYLdVF/fzC3JjZW1biWRfUPQS+9YpMKULWaPqdxh9se7U0cZZaw0/ge6Jq3yks3oiW0al3iywMfrYySKmg56sf8MH+3Fg1I417TQsMtHSc+c2go13nyXkkOwan2XNCDe33kxNj8G04QKyuWYfxQJxqqhGa5aI3/kcN4Sn0o0zOJgHAHwfWcsH3fuqfi6j/IKbE6ImoJvjn7MG+f9dyC0mIu6D/ZaQw+kOSORPsiQKXoJzPr3iT1V4CyiACPHjObPXzIzumeaJ+DkyxLHodR2rLJJJU6yD1+IIriFO5rs/+7xAvTdb8efeaECvn4jH5Jxqz/r+Cen0ySCuNCg4NCueO6ku2vZpcJy2b4zBwogwme9wYfjy0tj39e/JoHiDNU/rApXeZhl5sXFYpPuq8ZB1iBtqXx2WaCMi+9OOavz0ZtkvyVWEiGdieD9NAfGYMgGDWPRDYE1vcrlL6UIy7BJrLvZ3pRQuQILWZ4ClTLbNP7Dl9LYH4HfAgXktA/hdnSZCc8GLoucHUWCDCtzBLXOHL4YJhmPSOtU0xoBLBeuwoEto1rfSqVZcvaYnLpVW0+FAhc2/E3C37Yu1gMgKz8L9/Q3JwQxFkUl7s6j0jzGHOf/yKWByXgZGsjmroiUvip482JXgNK1eWy8yeIoQr435K4rJ/f4z17NJ7vGh8rzZnggu1EBYjazZLf1QRbfh2kAnklgpJA7iMwCbIpHL1LSJAgUcjzcKT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(2616005)(426003)(26005)(7696005)(1076003)(336012)(186003)(47076005)(6666004)(83380400001)(54906003)(36860700001)(2906002)(40480700001)(40460700003)(82310400005)(478600001)(41300700001)(5660300002)(8676002)(8936002)(4326008)(70586007)(70206006)(316002)(6916009)(36756003)(86362001)(81166007)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 06:15:24.0095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fdf333-48ee-402b-e5a7-08dac219c9b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5004
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[Why]
Since introduction of patch "Query DPIA HPD status.", link detection at
boot could be accessing DPIA AUX, which will not succeed until
DMUB outbox messaging is enabled and results in below dmesg logs:

[  160.840227] [drm:amdgpu_dm_process_dmub_aux_transfer_sync [amdgpu]] *ERROR* wait_for_completion_timeout timeout!

[How]
Enable DMUB outbox messaging before link detection at boot time.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Cc: stable@vger.kernel.org #6.0.x
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 66eb16fbe09f..4d90c5415d5c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1633,12 +1633,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		}
 	}
 
-	if (amdgpu_dm_initialize_drm_device(adev)) {
-		DRM_ERROR(
-		"amdgpu: failed to initialize sw for display support.\n");
-		goto error;
-	}
-
 	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
 	 * It is expected that DMUB will resend any pending notifications at this point, for
 	 * example HPD from DPIA.
@@ -1646,6 +1640,12 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (dc_is_dmub_outbox_supported(adev->dm.dc))
 		dc_enable_dmub_outbox(adev->dm.dc);
 
+	if (amdgpu_dm_initialize_drm_device(adev)) {
+		DRM_ERROR(
+		"amdgpu: failed to initialize sw for display support.\n");
+		goto error;
+	}
+
 	/* create fake encoders for MST */
 	dm_dp_create_fake_mst_encoders(adev);
 
-- 
2.25.1

