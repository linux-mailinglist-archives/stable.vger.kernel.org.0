Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3443E4C83BA
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 07:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiCAGHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 01:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiCAGH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 01:07:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A5262122
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 22:06:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0paZ7OYlvLGrfRJN5JlJTbD3StODqCFe3XPsnZJ03KloqrgY6GG2ZS14/A0yxsJM9aXondqcii9QGtZEcwDdD8yp97HEeYT2bWRe3pGN9L/yV895aNCR1l8bvdstDxmBjCOcBMT1mKwubGYxPCSYEVwYBh4it35KMF4YBKvOyVM2y7rCJlPd6hxB8jW2Z0I7jAkqphrt5F4bepwIjj6vfhp/kxsLE5Pl+wChw2m75blPXPAU9InH7HofbYAThVcEHoN5P93c5ik0bF9o34xmphlxAp/YlxlLMqhGvNPvJp/DRlUOKDIPKNIwV7ETmYhcFRsk3aPSn9J1WMnAdJKgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZR85/1nrbsZJIRQPQmTD0zqCB/ojKKu5YfZl2JBOgAI=;
 b=Ga1/5iCvF7S1BdYW8bHCXjd+A7MHYt0kpIaMfwPHxqM+/+orCq28Exha4AraZqug/JPQV2pcf4GBN7czWWByFOIhxt65alpj2O8XMDzBYkkl+NShnBmYieA+t/fwsdbG1M58UZYL9ZiHytr2USNsxfa12nz59e7knX/ofI9xGCJv8b5Nyx2ZFpFFyspRj6iwB5ko6OchmkD36OrqkbxvPZ1/B4s/vnLrCWiSSyJajm8NGB98aMthqQRYw6vwmDWn+AH6q8otpqYYmJQQ+4o22fAtcF6iKlDpHlByLwgJYIkr/xQV618Q81e5pAYVx8h4z+iP2bnp3mJwv4AOeQzULw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZR85/1nrbsZJIRQPQmTD0zqCB/ojKKu5YfZl2JBOgAI=;
 b=Lu5hIAu7Esi1NSWOwuCDlBAYOMa+tCfmnLIUIlpmLm3rQD7AB2n74EmTjm1ug38CnT4eMPv9zNZtuq0wimlRd2FJRwkY9Lhvpv3v9vdq1HCMVjGoWw6y9Y+jLTbPhtKbIELqq6ZUZbousIeGuz4BwIy2oyaRDnlNGk0TzrtICW4=
Received: from DS7PR03CA0276.namprd03.prod.outlook.com (2603:10b6:5:3ad::11)
 by BY5PR12MB5015.namprd12.prod.outlook.com (2603:10b6:a03:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Tue, 1 Mar
 2022 06:06:46 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::2) by DS7PR03CA0276.outlook.office365.com
 (2603:10b6:5:3ad::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 06:06:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 06:06:46 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Mar
 2022 00:06:44 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: Reduce dmesg error to a debug print
Date:   Tue, 1 Mar 2022 00:04:13 -0600
Message-ID: <20220301060414.1543486-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 576d27f8-0646-4685-5f6f-08d9fb49aa85
X-MS-TrafficTypeDiagnostic: BY5PR12MB5015:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB5015CEF59C1833F916C061E6E2029@BY5PR12MB5015.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kEO6mBaHWNLozsqwEZwhdX2DBidWuzJMvFymHVhkY+6xQXHRcaIBSbhg3KV+vRM46XVb437B321Ij9y4luR1cfXVyXbTuGHPHNwtGttFOFRf+HIt7NwLdy2VFVtY2TQdA9Bdb+IESxQx2N9sHyqqd+AD+4OPWD+6BtjU7IA9wx9fGGrqqS6EJrfdL4+c1wzkhqZ1eeiJzsxcpz1CSLVbVBG8T0KoZS8Z7DERekbFY1MJZwohWtcnnFZBON+FMStq2yw8Y6cUusFl+9d6Gi6ghiN73SqUPt06YIejMN/Yy1Px1ybyhDvnavHzN4B4MZuDOoV3a+53+zQtgCdPOBmoqdYDViKtvjkbaM9K9u2IJc1GUk0v4cNf5UBb0ndGYYWzhOLxI3UEqCo8SNDYmBlL67h4HmSMc7bwKAWNtzcVdNEwdi9iQ836RXi/9IJaO0p3x/kSSW6N9QOtUaDmyxyr4TDnfP7mliL9sEVTBYsA0Kq6QW9SbKoHSipACgH7gElukigPmJIPOUwVqeSWi/pfc4LSn+XBfCbDWE8VxKTf/N5thyaz5/eWHh0W/K9S1usaucrwcUcpcxIQe4VZWTLifUSWd9r/xiWPmZLIZtbG3MGXdpN9+cVy+3U1dTEOqKCXX/dBY4TAkTWtTvMOVOpUuwXOu31J/o2YZHb/+Wbome1gDerxsw+nCTFqQC+CPip1SBXa0Av7+uV1dUQV7Hasvw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(6916009)(81166007)(356005)(1076003)(2616005)(40460700003)(36860700001)(2906002)(36756003)(26005)(316002)(47076005)(186003)(508600001)(426003)(336012)(44832011)(16526019)(5660300002)(86362001)(4326008)(8676002)(82310400004)(6666004)(8936002)(83380400001)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 06:06:46.0594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 576d27f8-0646-4685-5f6f-08d9fb49aa85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5015
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Leo (Hanghong) Ma" <hanghong.ma@amd.com>

[Why & How]
Dmesg errors are found on dcn3.1 during reset test, but it's not
a really failure. So reduce it to a debug print.

Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1d925758ba1a5d2716a847903e2fd04efcbd9862)
---
Add explicit definition for macro not present in 5.15.y currently

Backport to 5.15.y only, different backport for newer kernel.
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 4 +++-
 drivers/gpu/drm/amd/display/include/logger_types.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 93c20844848c..605b96873d8c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3650,7 +3650,9 @@ bool dp_retrieve_lttpr_cap(struct dc_link *link)
 				lttpr_dpcd_data,
 				sizeof(lttpr_dpcd_data));
 		if (status != DC_OK) {
-			dm_error("%s: Read LTTPR caps data failed.\n", __func__);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+			DC_LOG_DP2("%s: Read LTTPR caps data failed.\n", __func__);
+#endif
 			return false;
 		}
 
diff --git a/drivers/gpu/drm/amd/display/include/logger_types.h b/drivers/gpu/drm/amd/display/include/logger_types.h
index 571fcf23cea9..a3a9ea077f50 100644
--- a/drivers/gpu/drm/amd/display/include/logger_types.h
+++ b/drivers/gpu/drm/amd/display/include/logger_types.h
@@ -72,6 +72,9 @@
 #define DC_LOG_DSC(...) DRM_DEBUG_KMS(__VA_ARGS__)
 #define DC_LOG_SMU(...) pr_debug("[SMU_MSG]:"__VA_ARGS__)
 #define DC_LOG_DWB(...) DRM_DEBUG_KMS(__VA_ARGS__)
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+#define DC_LOG_DP2(...) DRM_DEBUG_KMS(__VA_ARGS__)
+#endif
 
 struct dal_logger;
 
-- 
2.34.1

