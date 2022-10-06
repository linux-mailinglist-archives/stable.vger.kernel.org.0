Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5845F5F703E
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 23:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiJFV1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 17:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiJFV1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 17:27:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0384BA255
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 14:27:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVvAUxSYfCDJjl7M7LJBBG1WBeUkSC8HGY6PGqiW5CHI1lga+CnLi+rULpCqDy1YhCeIP+qR9SBcJMgD/zBLhG/iLu22T4n7vDF48oMIU6BSPxX4pjiQAfi5rtttudzJXffbQ9wrP6mLgzjZDM+Ae2fTMHgqf1Q8/Tyn7Ib1xg1W+sTjbSWAPH5j2u2/QFuWHEK4Q7AWP6415JwT/wFVgNY14C9Pj+9jj3ULaDAE5POveJZC3uPUB+MA2R2HyFGRuNZNNMahJ3BjF7H0rJZJRLpNCVni+6j6kOpWae0zLr1z4z1fbBqZB4WHOb198yjMgOy+9SMMGe+usWJ492AUrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbZXNCNbzGqMKTXQfUCZZRPamaIhJzgOA99bSoiPtWI=;
 b=bzWZ6eWHPh6k/oQ+40amAiOxDpSuUf+Tbsm8ZuV2la82cw9DanRHIwYO6goIicVKi1TmeuqHLayJkNNXfG2M2VHpLLExz0hHaol1onx3bS4KshvmnNA4uq+WJ8IM4drwS8cvuPhnogtwdGR6CeHOo3TNTT8aXc0XQQnoN28TBcz1FZKJTxvc4wr9efwZRXBmOqzpLLxNDQld/fNvEZN1UM9neQVcOHywGxnrxBXCBHoKGFh4svGKOFxQvELhQLDSeRNkBRlsers6pVxGynt9fQ2JjkPEJ7Hv8ktKyJwnE8glmkeJOunw+7pjeifm2L+PO8zOlpnbXu6ARVtRGMnlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbZXNCNbzGqMKTXQfUCZZRPamaIhJzgOA99bSoiPtWI=;
 b=BvIZz8IEPeSKcfgGZ7VwJSA5jKF0hSCm/hGwTUK2Tj+jwZGp4nSzFiNY+jyos1ZYEzZ8wZx/R8H4/Zhcbw/7caHLxx8Z1w37ATZw5+wCOGSmkklhNKkIBJnL2STp3ux3RD6OxDOSKUfoT5U6i5q/Y8k1jJr3gTNX1lBTuKW9Zrk=
Received: from BN8PR03CA0003.namprd03.prod.outlook.com (2603:10b6:408:94::16)
 by DM4PR12MB5053.namprd12.prod.outlook.com (2603:10b6:5:388::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 6 Oct
 2022 21:27:34 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::5e) by BN8PR03CA0003.outlook.office365.com
 (2603:10b6:408:94::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Thu, 6 Oct 2022 21:27:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5709.10 via Frontend Transport; Thu, 6 Oct 2022 21:27:34 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 6 Oct
 2022 16:27:32 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Martin Leung <Martin.Leung@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 04/23] drm/amd/display: zeromem mypipe heap struct before using it
Date:   Thu, 6 Oct 2022 17:26:31 -0400
Message-ID: <20221006212650.561923-5-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221006212650.561923-1-qingqing.zhuo@amd.com>
References: <20221006212650.561923-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT066:EE_|DM4PR12MB5053:EE_
X-MS-Office365-Filtering-Correlation-Id: 64378ff3-e529-4f0b-8c3e-08daa7e19576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPWHU/Z66GcWPYfM+acLiN6C7yt8pT1jOLEXd6b8vG2AWlnUwRPex6cCfZKJU0EmkUTrikPqBWp2h0SadwbKcrwGrvxhtJWl6mDl7WXAKmAoOF+6UjYaRygCb5kCsuo2TbtKLzu9ztFIUGd8waFy6v03upp2EdCPoIWrS1qdWrXXKtMyW6seZcAqwmuqRDUaLjo1AFcS3kYemsGUFFlAA+J6y8O/eapJ0Ir1f/jHCVxOYVR7wVrT3hdd1tVvhP77blgLdZtyB2yPEfwy8WH/69pPrwJOmRQVdgAzdaH1gTnig6DckAa4Oa/K8Jqf8bW6K30ek0YIsaNk1rTRJmdtcnrxEnH+wIRPZOJ2eLbnpvbplGFkc+VvaAlIHn/22vqOrJ8MoZa5Q0e3q4v1nSFExEDXiJNd9RCtWEL3KOuRCdgClahH4KExUBdE2C7AGIGameYoHWdLOQQbNV/UQVYdWEtubdTfI0QEsTFvm1sVIe71TxKk3vkaH0FxwnMGFQuvKI+manLoJPPzesc1+XlZ/uQECQJrKu4hB10G0vl8AFd+c7C+j1wlpvC0f64ehzJZRbS2GJ/5NVEy7wcaeRSi/UB+ZMdtKAIHYyrNRSVvB8xavQqSQkhXwLS9AHBqG6gNnz/sqBFwp8lDkgQ7LM1y0sBw5YzUljhlCZdhqj+op4U9LhtNMt4OsIqsNNq4RlvWs4PAKBJME8VSgWvNgkWyozZXcRAy3hkDSOxX5xDS2THGcmjrxOB4v+nHhNr2AJRkh2zYwfE+0xW/vD6PZB2n4QrftKwAaMBnWdTXui6sn2dn5I7gzLvpzzVFy+x24Yuv
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(36756003)(81166007)(356005)(82740400003)(36860700001)(83380400001)(426003)(47076005)(82310400005)(86362001)(336012)(16526019)(186003)(2616005)(1076003)(40460700003)(26005)(478600001)(2906002)(8936002)(44832011)(5660300002)(6916009)(316002)(54906003)(41300700001)(4326008)(40480700001)(8676002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 21:27:34.2619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64378ff3-e529-4f0b-8c3e-08daa7e19576
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5053
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <Martin.Leung@amd.com>

[Why & How]
bug was caused when moving variable from stack to
heap because it was reusable and garbage was left
over, so we need to zero mem

Fixes: 593eef8c1a5e ("drm/amd/display: reduce stack size in dcn32 dml (v2)")
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 11d5750e15af..5b91660a6496 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -733,6 +733,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 				mode_lib->vba.FCLKChangeLatency, v->UrgentLatency,
 				mode_lib->vba.SREnterPlusExitTime);
 
+			memset(&v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe, 0, sizeof(DmlPipe));
+
 			v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe.Dppclk = mode_lib->vba.DPPCLK[k];
 			v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe.Dispclk = mode_lib->vba.DISPCLK;
 			v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe.PixelClock = mode_lib->vba.PixelClock[k];
-- 
2.25.1

