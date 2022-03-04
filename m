Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112BB4CE033
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 23:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiCDWXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 17:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiCDWXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 17:23:24 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0E448300
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 14:22:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8bypZUAysFVx/vTXuumSxhfYkOBZvvosG23HBQMCBxsrF53z2+bCuGtqgJxHBPsutXXAwwH9Rcvilx/eyvpicHrYLjtZj9qYRg2gH8xMgKvGW0mtIvgMCkC/RKV1Q65xJr4kzsHs/bhUDP0m+IE2aeeXvf7vJH9H/xsFfrWapXousX27K/LjYuxo/iPGuYQhMlXvhvSqw4czOIHm93AEGrVhGI8CwtNjud3MZeT0ViBMG+J75RiEeO5XFjwdWhGBGjh/St2XW90nm+M9gGK682MoqSgdJp/X0cQvG0TC1hckcDdUuBHsAr9Cmx1nM/8w33ol8Rr2GZUNN1QvPiTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olBMCajeMq6aYYn53XvFBgXSSQ+XrOFfooPLsYmPLDY=;
 b=lBvFoplSCedZVn9mJZsw45r82JZj1QsIKTMXtGRjA+hu40gHzusuulm1F9itED3LM+eof6PjzBLPs2V/t9yB9cyabEIDNhbNyNMbJ+vXv0Mt+Gk4sO7/Ho0U+GU473/k6paM50wQBvfqb3D6e88jUmjuVByPMp4/73B+Rk6wl2UwffDuvCdM5iDGe4mqBeQqXaDn3BzNgJm7TyuJPFe91jrnNfkHnT2u1fllnfyPHfY2gWJJTXQ1HR4RpJwVpo9Jz98EyHlL+sjJUBVQ+yhLILArTOGKXWx/YGjTGhlFm672KxSB/cMfk5uN7gG+fnJuXxE509iC4Lx9Su4hHUzzKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olBMCajeMq6aYYn53XvFBgXSSQ+XrOFfooPLsYmPLDY=;
 b=HFXPYS7gWkpmsOFlrTmy0qRQgjvf8NJH3u5QLtDe36GAMKHCKHx90sjV4PSMGRnhp0uSS7CPVeYInfV4HwMK72vrpZVVjKAakefhdttlVW8vFOb1tsvbTotkBph3A2TzqvLuL9QRm1nMRCuClyCptcviqg6iIle/5s2T7xl5tvo=
Received: from MWHPR20CA0024.namprd20.prod.outlook.com (2603:10b6:300:13d::34)
 by DM6PR12MB3530.namprd12.prod.outlook.com (2603:10b6:5:18a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 4 Mar
 2022 22:22:31 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:13d:cafe::ae) by MWHPR20CA0024.outlook.office365.com
 (2603:10b6:300:13d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Fri, 4 Mar 2022 22:22:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Fri, 4 Mar 2022 22:22:30 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 4 Mar
 2022 16:22:29 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: Fix stream->link_enc unassigned during stream removal
Date:   Fri, 4 Mar 2022 16:20:09 -0600
Message-ID: <20220304222009.362009-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbcc8885-5f5b-44b8-e644-08d9fe2d7936
X-MS-TrafficTypeDiagnostic: DM6PR12MB3530:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB353062EF89554DCCB9BC2401E2059@DM6PR12MB3530.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mtdlc1mrtMySvd3u+diBpwGmsXVbX23/xE/5a8S+Dh5XG3X+hNdZo/D1aCcFLwwSk7NstcmN+yxNa0nf1S3llu7hEE6biqtgyvzAdmytrgzecT6Nnlji2+C3f02HbSHLBIpuDXljVnpq6MhE1rlZD37dMV0bxRkWGUpkX93qzU6vFut+J/08si1PRoC7Y2QTYON1VfzGYIe7uHnuJFpI8ofvlaVknI7REMUbNIUDT4v+nHUM9HLWieftr4M+7/tmcs2x5I03K89q8z6d5og/c8nc/6ruZNu8ST5j0N25uIStA/DO+sIakK6M13LGzJPcTKQFJ63hI0CWl2dvgJ1Bh//ymXt2LS40THLqv27pYE/JemFkivtYx7xb5uszcf44paAfBkcof65CQ4gzkxyYpRfBXZXbfXu+hNSKmOyl/M+sFjPE4NMRT96y5USiObPW6lGaEKZgltzkafMmqNKxONhHBKr3sRx0gKOc/X5NMeYBEbtXqQdSRnHA/9lK7HKtfYhHbkshKTUA1qDso1f/gtZlEsncYx+jz5u31425UhLBHi3Nrell2hUiJwgFsYst9tiVNUzdSCXzFyoZpGJVRySb7Tv+Oe8jlpT4N9F9nyS5vhED05A2wA6WOdFcV6svPvLLKzeu8PRBDMRGkEjSO0zlA6WpXu9HTrNcwUKQpYi3bCH0ohinuXRWSKVMEc6wEGZ6xBfc5uBCHTGcLiEG4w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(16526019)(426003)(356005)(1076003)(336012)(81166007)(83380400001)(70586007)(186003)(5660300002)(36756003)(44832011)(2906002)(8936002)(508600001)(86362001)(4326008)(70206006)(8676002)(82310400004)(316002)(2616005)(47076005)(40460700003)(54906003)(6666004)(6916009)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:22:30.8541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcc8885-5f5b-44b8-e644-08d9fe2d7936
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3530
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[Why]
Found when running igt@kms_atomic.

Userspace attempts to do a TEST_COMMIT when 0 streams which calls
dc_remove_stream_from_ctx. This in turn calls link_enc_unassign
which ends up modifying stream->link = NULL directly, causing the
global link_enc to be removed preventing further link activity
and future link validation from passing.

[How]
We take care of link_enc unassignment at the start of
link_enc_cfg_link_encs_assign so this call is no longer necessary.

Fixes global state from being modified while unlocked.

Reviewed-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 3743e7f6fcb938b7d8b7967e6a9442805e269b3d)
---
Please apply this for 5.15.y.
This was already targeted to stable and 5.16.y picked it up but doesn't
apply cleanly on 5.15.y. This problem exists in 5.15 as well but the nearby
`#if defined(CONFIG_DRM_AMD_DC_DCN)` from DP 2.0 support
hasn't been introduced in 5.15.y.

 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index e94546187cf1..7ae409f7dcf8 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1799,9 +1799,6 @@ enum dc_status dc_remove_stream_from_ctx(
 				dc->res_pool,
 			del_pipe->stream_res.stream_enc,
 			false);
-	/* Release link encoder from stream in new dc_state. */
-	if (dc->res_pool->funcs->link_enc_unassign)
-		dc->res_pool->funcs->link_enc_unassign(new_ctx, del_pipe->stream);
 
 	if (del_pipe->stream_res.audio)
 		update_audio_usage(
-- 
2.34.1

