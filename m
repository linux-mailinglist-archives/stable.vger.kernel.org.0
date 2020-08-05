Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A115423CF96
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgHETWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:22:48 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:15328
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728870AbgHERlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:41:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqHQ2HnssiEMjvLAWEJ69JXhaNx6fGLMkVAsnhlmVHY2khkUhRuiOlNTeMdPs0z18lMNou+8f5VY2rI2QLkK3ONiT7/f2nJEUUKc4fsJOsOj7sS7JH71c4DimT7YCsjjS8oG30FCqV2iJuEAx3DNVmLH/6lG2hBaR9R79UoOmI0w7KTccDF4oDEa6pkiuIKynuTV1imV0Cgwk2Y/iEMkGtaRzCbQ/PzL5ayR7tJLWGDpVLFDiM51m9/GbRfj/BE7pzZclzgC2DEzpEyipFr2gW2EPb2oap9x54XFzEgOVs2vFnbwiP2pcXLhWWhql7/hq+BzHpA0WZky/hJAOHdj/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEXjUOIdwrf5U0CLVNIU0v2q0llnSP1SXigu0gc3bWE=;
 b=O6o3eddi83j3ml9s66b+0/Wrf+u82bNGkPoBUlhID/Tx+G59Pfnhv4MWrgq2ZRQtOQq5sYrSPR6Wxof7W61bc0YG21pskzdoZzs+Sb/wo1R3nj6GPBcdJalAViW8CYwgl2eR2uZeVYE2xhZ0vWOl0nALVtTTwfCQhPc/lqaerTf2PPFRa7hqz5JY68vLtNzesD9MeU1/P3G5HDrcrBi3hGsYk/XIElrikd7YJlGQbeP8mfzxQKI7073p6ixrA4Q30xV0rff4uGtNosFt7gaJUMkFzo5w4q2qvy7CN8rdRJ4MtrKr0AOGf9snO98mDlWDyHBTIidX7kgzd/2PniixYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEXjUOIdwrf5U0CLVNIU0v2q0llnSP1SXigu0gc3bWE=;
 b=BtMqbZM7KQvA/3wx0dp+4ZZBnQ/aQPMq0Na8WGTjcevkmzNOLt/p8XRGsAr7ivPP4MPzl8xrHaGY/DirLMi/2BaVFzpehmapXwxcxDPWgtPJqFq+3MjH9kMcMieMqPSRJjfL72/nqIZfib+BEbtFTzFmIYpB0sGmtWtaRkEpYwQ=
Received: from CO1PR15CA0080.namprd15.prod.outlook.com (2603:10b6:101:20::24)
 by MN2PR12MB3839.namprd12.prod.outlook.com (2603:10b6:208:168::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Wed, 5 Aug
 2020 17:41:03 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::9b) by CO1PR15CA0080.outlook.office365.com
 (2603:10b6:101:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend
 Transport; Wed, 5 Aug 2020 17:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3261.16 via Frontend Transport; Wed, 5 Aug 2020 17:41:02 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Aug 2020
 12:41:00 -0500
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Aug 2020
 12:41:00 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 5 Aug 2020 12:41:00 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        Aric Cyr <aric.cyr@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/9] drm/amd/display: Fix incorrect backlight register offset for DCN
Date:   Wed, 5 Aug 2020 13:40:51 -0400
Message-ID: <20200805174058.11736-3-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200805174058.11736-1-qingqing.zhuo@amd.com>
References: <20200805174058.11736-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c82266e7-30e4-4eb9-6085-08d83966b91b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3839:
X-Microsoft-Antispam-PRVS: <MN2PR12MB38392ABF952D3024768BB08EFB4B0@MN2PR12MB3839.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCidDYyBGtHGZpJ1DMZJ3Vu7JQcQRhp0Ob9gAXY4MWzsoZbQp4H0nC4zasHDDsriFyQ1OMSGkoytog4145lbQA8PHJzy9pcj9DfJrViN7UtF87gvpNynpyNu9wBKFQ9e1LeJ9teRkGJwupm6j+fcnkP80KBkaRh5i6O4oHGtZ3sWAx65c8TB8RhpZV5ADp5Km2falGUAhJzWmO8Grh5uffc0b4XlqC5LoXQHG+gBn4+oIf8HBX+u7POQ67puNrMcL/yd+3C4odn4qr41kBDLzMWvssWfeSKSZCIh4nrnwDL0OxWuGshZ+supnGn02QO/5M/JAa/AWOJSMOd5nzU79WORFQESxURdP7k1Btkg7yyJ4E1/TghsQaemFVnWpuHyFvHyPkI9B6Vgv9PhIcCIzg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966005)(356005)(54906003)(1076003)(70586007)(70206006)(186003)(316002)(478600001)(81166007)(8936002)(47076004)(336012)(36756003)(26005)(4326008)(6916009)(2616005)(6666004)(82740400003)(83380400001)(2906002)(82310400002)(44832011)(5660300002)(8676002)(426003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 17:41:02.6312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c82266e7-30e4-4eb9-6085-08d83966b91b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3839
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[Why]
Typo in backlight refactor inctroduced wrong register offset.

[How]
Change DCE to DCN register map for PWRSEQ_REF_DIV

Cc: stable@vger.kernel.org
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Ashley Thomas <Ashley.Thomas2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
index 70ec691e14d2..99c68ca9c7e0 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
@@ -49,7 +49,7 @@
 #define DCN_PANEL_CNTL_REG_LIST()\
 	DCN_PANEL_CNTL_SR(PWRSEQ_CNTL, LVTMA), \
 	DCN_PANEL_CNTL_SR(PWRSEQ_STATE, LVTMA), \
-	DCE_PANEL_CNTL_SR(PWRSEQ_REF_DIV, LVTMA), \
+	DCN_PANEL_CNTL_SR(PWRSEQ_REF_DIV, LVTMA), \
 	SR(BL_PWM_CNTL), \
 	SR(BL_PWM_CNTL2), \
 	SR(BL_PWM_PERIOD_CNTL), \
-- 
2.17.1

