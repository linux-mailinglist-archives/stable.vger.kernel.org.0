Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFFE5379A5
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 13:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiE3LRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 07:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiE3LRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 07:17:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60461CFF5;
        Mon, 30 May 2022 04:17:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtsaNEjfdmczm/NVytNKjbrtotoxHBGZi0ik7Ly42SSEF+HS4pUWNfOf6xL5vjzFkCYqQRh4/VDCBKWEDNgBfeUEVs9opdxOp31flJ9DqMcrUkunxxYnAAqovovbjqYyLhtcfyS+S2U69iIPGrtivmZjrJ/id1VpheqzGSDWXvr+Tvr3qTMEsBd+ebjRvNL6r2rK0Pg1VETSyrfLqfR6yeWGCBfTgvucLOOkzd2upvTXyDBMWoj92Q80Wr09ODBOn9bw43S6XaE+0+2a/76qXN2PlBBMpiZE4MR9erqiPTlYVXaGxFKiyOKrhkMTWjz3NO0IDC2SQ+1kFIWzu+bMSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1HqXc6ZUQUfeVE9nPrbhhSXTzga2Uc3FbMfu0n3ncE=;
 b=JMAyopKdXCrKQNervchD1yZrvUGw40HiD2dBp/Jh0DOnMhpYWpYTID3uTYR0AmygkSQN5uGuBbHeFYP0ge061LSRTAsEv63TdKORJ6jjSUBj+W4kBI1puUM78vUljhxSK6q/KITM3zrt5nvjGddy01jA29tNUtn6PMu4oFzsp4gEHYlFObtHMyNg0tr8wj9wX1i0IH1I5pFvuFSOr4GPEhe6Uxae3MXIUQFEnvOtCoko6c86sidlaYtVmGFDlxxxAcj8b5p7ePvxD/uDmCEReDTo948udw14aQRWyB4QkDiH8XSPgiiqu0acxXrFFXchDy2Kr07kXQfX1JRY7x4CyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ffwll.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1HqXc6ZUQUfeVE9nPrbhhSXTzga2Uc3FbMfu0n3ncE=;
 b=gNrR/2bye0KrehEc/pzmaChsbHqX0ShZgbVckTu9UjxAtYpU0KqJ+Dc2JqSEfb9OaGxCQNNutuCd+Skz+s5wad4enJDXRv16MFGIClTVhnyBWGuTG+LV9fAS5zRfOB3TZA5pePcDGKOLW3nRjQOpnmx1pLNquKQO6P+V5JgAPZk=
Received: from BN0PR03CA0028.namprd03.prod.outlook.com (2603:10b6:408:e6::33)
 by DM6PR12MB4028.namprd12.prod.outlook.com (2603:10b6:5:1ce::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.16; Mon, 30 May
 2022 11:17:14 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::27) by BN0PR03CA0028.outlook.office365.com
 (2603:10b6:408:e6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Mon, 30 May 2022 11:17:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5293.13 via Frontend Transport; Mon, 30 May 2022 11:17:13 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 30 May
 2022 06:17:13 -0500
Received: from Ryan-AMD.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Mon, 30 May 2022 06:16:44 -0500
From:   Ryan Lin <tsung-hua.lin@amd.com>
CC:     <leon.li@amd.com>, <praful.swarnakar@amd.com>, <shirish.s@amd.com>,
        <ching-shih.li@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
        "Daniel Vetter" <daniel@ffwll.ch>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        <stable@vger.kernel.org>, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        "Mark Yacoub" <markyacoub@google.com>, Roman Li <Roman.Li@amd.com>,
        Ikshwaku Chauhan <ikshwaku.chauhan@amd.corp-partner.google.com>,
        Simon Ser <contact@emersion.fr>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] BACKPORT: drm/amdgpu/disply: set num_crtc earlier
Date:   Mon, 30 May 2022 17:29:02 +0800
Message-ID: <20220530092902.810336-1-tsung-hua.lin@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5741dfe9-c5db-4581-b1b5-08da422df2ba
X-MS-TrafficTypeDiagnostic: DM6PR12MB4028:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4028F45A2810DBCBF835D158B2DD9@DM6PR12MB4028.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLIgqRbzsCtNrKttQ1bNiwZ+9hYzWbwRrNnwYAhBNIOrLieUYpAHHjberQT/j38Pgsui0eH3NS/l0iWURU+TBglkOkTuDlo/htxGtg0IU48vXHfzkPlRP5Pq3eokUzZ7oPKZxkcQnLUhFz4fLKSqno0R/9Du6ZBf3kMsLEVcYGhSEIdYxnGBorjS7X2+N/OPiGKWya57jjg+b5PlFHAwOjor1xXvprXtJl4FI1KsxJ86aOAIGF1Az1NR+9a4523SAwfjWY0FVwnoPPtZxKYaZCsnwvd2l9V0RizU6wKN6coK3LQR8084g6+ew5T8nRvb/gL2ndkcW3uoS0TEsOb/T5UHIEVedJL+g9AHHNWtCHQoWtny3Hxx3iMCRRQ0o7HsS8VP7n6J6sRKATpagHt7de9MjGTEx+P26aaGb9ia3ZaAwUjl4lnn6ebPxycX/E2hfQnQUZahbiXQuLRVgjeG/eqkEBIn2bVxC17dp7tJ4f86dMZ3onnBWQZAMddNDSxEvpIqhv0Rb3FCuhU7gm+zlWTSrO4+iYg67hD+RsQyWBZ6L+Lfx6v7pqHCGmOGoGGa3DBDF0jy/LPGOk9p7l4/hK1DjpjGDV5oandU6BCf4WR4M2AzTwsko1Qp52xAXNyg8+C3xYCFsy+Dr5eexz/LZrP+vk+dxJ7AJA62Af/svqVztNDUi8eHTVY4jlsD/h8BH5KSjikn3Cp1rY8I5/f3JIlOBJ95vygI+PPWo7HedvKAGoAw+dAkHYlJOiELlmR61vFZHM4Va4/oMW2n4b7r9NSjGZRFuFkNyoK+Ke8jMZUUsUAGkY2wdgv63pn8W3Zb
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(316002)(47076005)(8936002)(54906003)(966005)(426003)(36756003)(336012)(508600001)(86362001)(40460700003)(5660300002)(7416002)(4326008)(82310400005)(70586007)(70206006)(8676002)(26005)(2906002)(6666004)(7696005)(109986005)(186003)(1076003)(2616005)(356005)(83380400001)(81166007)(36860700001)(266003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 11:17:13.9004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5741dfe9-c5db-4581-b1b5-08da422df2ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

To avoid a recently added warning:
 Bogus possible_crtcs: [ENCODER:65:TMDS-65] possible_crtcs=0xf (full crtc mask=0x7)
 WARNING: CPU: 3 PID: 439 at drivers/gpu/drm/drm_mode_config.c:617 drm_mode_config_validate+0x178/0x200 [drm]
In this case the warning is harmless, but confusing to users.

Fixes: 0df108237433 ("drm: Validate encoder->possible_crtcs")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=209123
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

Conflicts:
	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
	[Ryan Lin: Fixed the conflict, remove the non-main changed part
	of this patch]

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fb918b7890ac..5ef88a2d2161 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -766,9 +766,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		goto error;
 	}
 
-	/* Update the actual used number of crtc */
-	adev->mode_info.num_crtc = adev->dm.display_indexes_num;
-
 	/* TODO: Add_display_info? */
 
 	/* TODO use dynamic cursor width */
@@ -2448,6 +2445,10 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	const struct dc_plane_cap *plane;
 
+	dm->display_indexes_num = dm->dc->caps.max_streams;
+	/* Update the actual used number of crtc */
+	adev->mode_info.num_crtc = adev->dm.display_indexes_num;
+
 	link_cnt = dm->dc->caps.max_links;
 	if (amdgpu_dm_mode_config_init(dm->adev)) {
 		DRM_ERROR("DM: Failed to initialize mode config\n");
@@ -2509,8 +2510,6 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 			goto fail;
 		}
 
-	dm->display_indexes_num = dm->dc->caps.max_streams;
-
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
-- 
2.25.1

