Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FEB5535E3
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352890AbiFUPX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352669AbiFUPXu (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 21 Jun 2022 11:23:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B2329802
        for <Stable@vger.kernel.org>; Tue, 21 Jun 2022 08:23:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoGf8TI4ksufaLHfpmYw0/KQXqo0YnzUHGbutacPKmIVYOJClAxbWbAyA2QP+2pfgTgHoHtVKEQcxrpKCubD780HhFmO1Mwq4FjlnxHz2ki6WI2xjM/r5khHA1QZpu+jBsgANZ+HEWrLJTh9V3vde4vwwUZHGV/ViXI6VdueltgMNzVDhG+An2J8sNrjrDZRx4B6oN4a7lBsdj+/2FYkbZrLWZq9oPQSblg8qcgC5rrpClZKF7im5T3uUVpgzprSdsQV4ioRXPnaptIAIf4adZEJ/6RzcsWFfgHF1E54IAOkITs7/FOq1yCZRRvluDIZ0YzzA7z1OYDIz8D9TrMK0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWE/3HpcpMzlNTbGB7/sF9GoBfYUL6jOMXwtEDhtFzk=;
 b=ZL4106EMrWtpyjgyob+xG+r0jJYq/COu6E/VJD4tlj/PKwdsyqNwN4CGWylq05bh5bH0ZdG2zfA3aPLSM2cX7VDwL08za2kav/g8N7L+Kvm2vNGTrHy3CBSKEoHtCRn7T4eDVYLpBngzeWL8eVBXdBclVo7T70jYVl44Smy5H25x+weapXAC3vEpgohI9oySEO7F9NX44sW7jCRLMvwfCB32PHOlAVuw1+qHTtWSPFvDmwMn43BvS3Sj1tlgSjHEIRK1kEWFQUM+BcxeMJ93AKVYDW/VUDRYpj8HOwhCVDfYh6RqAFsPQNZkh3AqYCZFMlF7IjwwlJwZn0Qje9d3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWE/3HpcpMzlNTbGB7/sF9GoBfYUL6jOMXwtEDhtFzk=;
 b=TLqE1ADDVWDi9cdXGnN73Jpv2mJw9AP6HQIMHOiWiy5pcHBqvgcnlW3MMxK8w+41wwHkz35PQACY6fYfBLclai+lOUcQml+fYmWXf7MfjyOYLP+dEQmpSR1YEfl4oVNTbBa7Am06vKtln5Rv5mfRXws4wfQl67Qw9LxxraH5WYQ=
Received: from MW4PR04CA0349.namprd04.prod.outlook.com (2603:10b6:303:8a::24)
 by BN6PR12MB1268.namprd12.prod.outlook.com (2603:10b6:404:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 21 Jun
 2022 15:23:44 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::2f) by MW4PR04CA0349.outlook.office365.com
 (2603:10b6:303:8a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Tue, 21 Jun 2022 15:23:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Tue, 21 Jun 2022 15:23:44 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 21 Jun
 2022 10:23:41 -0500
Received: from aaurabin-elitedesk-arch.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28
 via Frontend Transport; Tue, 21 Jun 2022 10:23:40 -0500
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <alexdeucher@gmail.com>, <aurabindo.pillai@amd.com>,
        <rodrigo.siqueira@amd.com>, <Stable@vger.kernel.org>
Subject: [PATCH 2/2] drm/amd/display: fix incorrect comparison in DML
Date:   Tue, 21 Jun 2022 11:23:40 -0400
Message-ID: <20220621152340.2475484-2-aurabindo.pillai@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621152340.2475484-1-aurabindo.pillai@amd.com>
References: <20220621152340.2475484-1-aurabindo.pillai@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9a75fb3-1623-4c3a-cd27-08da539a0798
X-MS-TrafficTypeDiagnostic: BN6PR12MB1268:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1268A86EA3809FFB73BA2D8A8BB39@BN6PR12MB1268.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uYPKdoZLvb4SNOeSbFzA/oVMgAQYSV3g0nj1uw7L07DlajG0ZwB3dcwUTYHbia6scpYYL+pTcMtvyMlaRoH8Wt2/ndYThlzHGBAfRj7IZLTy9xOkr43UA/kapxxj0mi3lbtI8xeaPZf+Xa/vlxrHWXNJX8cXzqEOFFsHffqIO6DM2nQS7x8wAjX6S1tE7X53Krfom2Ue24t/0GuDXzPR1HCFqUbHVFLC8/n9owReo6YiQEBhKzxLiT0/5xoHtTyghRbTVXm4Av8hJkzq+wkLf0NiJmgoDBpHMBBlahzfOAKWbEk4RGb6WKnL6IOZjT7xRucBOSlTSh7Oa91D8RbyE7WKg/oux9JqTLASim3CMcfq6+DHvgzjm+Zuj/xQdolnpUPn6+KMBqZXL0FnkiqImysjryfAxPpYynCHUS2mvcfmLvFwvTA1ec2U8apk4KPKQpspLkK42YzXdcpG1/UoBCmqDSu7BdqoZayaxZkax6Oo0tA6nbs+iPSB8umNbrxD3pP1wmHMfWB8C+7XIv4MzwGzdugOEH2Z5gsa5HZr145SB/lXdknvNiuSE6n6F/lmjDHTiwX5ZiXV1beSJF8H9dL5dYwNtQ1WS66qqGAiPhxxoHg40266d+bBi3Z5N3yUgMN7AN5gBP/NKeZchaMVpCLAeQ59HLyXgzSgOcsbFSSD+ij9VEHxgSE7FEPxmopXuMHkwI/Ldd/uUKSupaqOG/tWR4odmuX+zZSmagHDjLj6/pcXAEH7YeU+Bj1gxRm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(40470700004)(46966006)(36840700001)(40480700001)(44832011)(36860700001)(82740400003)(81166007)(8936002)(356005)(5660300002)(83380400001)(186003)(40460700003)(41300700001)(478600001)(2616005)(336012)(426003)(47076005)(1076003)(2906002)(26005)(7696005)(86362001)(316002)(82310400005)(6916009)(54906003)(70206006)(70586007)(4326008)(8676002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 15:23:44.2151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a75fb3-1623-4c3a-cd27-08da539a0798
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1268
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why&How]
GCC 12 catches the following incorrect comparison in the if arm

drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c: In function ‘dml32_ModeSupportAndSystemConfigurationFull’:
drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c:3740:33: error: the comparison will always evaluate as ‘true’ for the address of ‘USRRetrainingSupport’ will never be NULL [-Werror=address]
3740 | || &mode_lib->vba.USRRetrainingSupport[i][j])) {
| ^~
In file included from ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/display_mode_lib.h:32,
from ./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dc.h:45,
from drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/dcn32/display_mode_vba_32.c:30:
./drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/dml/display_mode_vba.h:1175:14: note: ‘USRRetrainingSupport’ declared here
1175 | bool USRRetrainingSupport[DC__VOLTAGE_STATES][2];
|

Fix this by remove preceding & so that value is compared instead of
address

Fixes: d03037269bf2 ("drm/amd/display: DML changes for DCN32/321")
Cc: Stable@vger.kernel.org
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index c920d71fbd56..510b7a81ee12 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -3725,7 +3725,7 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				&& (!mode_lib->vba.FCLKChangeRequirementFinal || i == v->soc.num_states - 1
 				|| mode_lib->vba.FCLKChangeSupport[i][j] != dm_fclock_change_unsupported)
 				&& (!mode_lib->vba.USRRetrainingRequiredFinal
-				|| &mode_lib->vba.USRRetrainingSupport[i][j])) {
+				|| mode_lib->vba.USRRetrainingSupport[i][j])) {
 				mode_lib->vba.ModeSupport[i][j] = true;
 			} else {
 				mode_lib->vba.ModeSupport[i][j] = false;
-- 
2.36.1

