Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E5523CF97
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgHETWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:22:49 -0400
Received: from mail-eopbgr770077.outbound.protection.outlook.com ([40.107.77.77]:56848
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728360AbgHERlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq4jYttRP2Y3lw+i8eyEBMDXVnwx9bTwfKF2Z94ZacZgiHy7c3pPIEty0TR5FOu8GQBJR8pEKUIvfZkKk7Sot4YG3Zur07mcVnezYWk7UVDusHubkNdbjF3bY6LxHz00TaDgmmPAlh2SBW8Kzxwy4sICC0T0q1No9X9xXYzvc0QNz0/bFYHoM2vkE1nptBoieeWrkMznSwqNd1ZB5t+6o8QJuhgockgPV4zgpRQ4wfWt/eEyHj9rDN5bUOOPWSCKEgf+8bMFtAn80rPL30LCi8i2zDZ52UEugmlDX7SxcMF/Re+SEpGCZX1MlYyyKV1C5qz+ZNg0xSEiLZfpembUBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9Agzt7iNk4McnaR2qaWLxRdiBZiGx48fk24De3KGCw=;
 b=dBD5GFHdcfVV47YxuGKzhY2uCgqpCwY7pASEhn7OnAfdeQjt5ST4hnPNyWe1+LU5xODhThDwkWGJUQKy3GZMX9cJGShpx2Psagilg7YT5ujKZrFTFWgTewwSKwqKESUPZiJUiQyfmh+5I11GLafZe/bfz669pRp8cNDYddpaVoqQSTvlbeJ2U2nZKJT07XrBytaPM9jJwUA7mjEpfw1Duy4gnoBm7DzDvgCcRqVldFodWrtO56t/m83OfwLVa8d8xI2uRAXtnPWTdAfL4gtW7oPOqTP5DcXGFfjO/Saa8ODNIF6jgFZTAvDHr8ElAci6FN+WRayVnI8bJv2RdUNSMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9Agzt7iNk4McnaR2qaWLxRdiBZiGx48fk24De3KGCw=;
 b=hvHtM8Mez6jh2Vgp1j1vssUGaBliQvB2JPPW10e1IvXLOzz4cqZpQFqqce6q0h4HVcBiYegzktC6JMKZ9Id39MfzHHIW4KnLFs6Aj8vmiSm0onp0Y1/KqHqgKRLleljDJumHgZyTsQhrvQqRxC3xt/teWRL8hzIK2p18MjHBeZA=
Received: from CO1PR15CA0084.namprd15.prod.outlook.com (2603:10b6:101:20::28)
 by BN7PR12MB2689.namprd12.prod.outlook.com (2603:10b6:408:29::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 5 Aug
 2020 17:41:10 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::c5) by CO1PR15CA0084.outlook.office365.com
 (2603:10b6:101:20::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend
 Transport; Wed, 5 Aug 2020 17:41:10 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3261.16 via Frontend Transport; Wed, 5 Aug 2020 17:41:09 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Aug 2020
 12:41:04 -0500
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Aug 2020
 12:41:04 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 5 Aug 2020 12:41:04 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        Stylon Wang <stylon.wang@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 8/9] drm/amd/display: Fix EDID parsing after resume from suspend
Date:   Wed, 5 Aug 2020 13:40:57 -0400
Message-ID: <20200805174058.11736-9-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200805174058.11736-1-qingqing.zhuo@amd.com>
References: <20200805174058.11736-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ec91160-9ea5-4304-22f1-08d83966bd66
X-MS-TrafficTypeDiagnostic: BN7PR12MB2689:
X-Microsoft-Antispam-PRVS: <BN7PR12MB26890BB987CF58483792648AFB4B0@BN7PR12MB2689.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGGYivWKKlIEWGhA98DmnubVK/UGAIScSD6ovmB6OX/I2pzcXldsudfnwoNn97AM8CNZFhnelfl2yEP9pi3j6UBgAPC3tiJ6LRkDmWe9bcSUEbFz8+eaIPGTxJtATs3DkjPjtNbsSiLnBRkM8cL6XWnFirB01MeD2/SGUycwOLkjOscOeL9DmM18ezAQOSyW1mQd09ctmxloUqCatPjPEBqnQgz7ouvjXmUn8m+WPGApKxaC/rz8JPdP+pAi0HB5IhJLF7KaA62dcvmZ4hwSE3pgFUGWgACH1W4iStDjrufWshtLaXmV3KiiPXLaMyRQQBHqjm8xAzJtY1Ed+bEsYyGJIUDLB09NLd2mTAErA8FCt3RV1Bxnt4lU0pDluE7gtA2XVmzD62yXsBkHn02S/Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB01.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966005)(8676002)(2616005)(82310400002)(1076003)(47076004)(82740400003)(70206006)(6666004)(83380400001)(6916009)(316002)(15650500001)(186003)(5660300002)(36756003)(86362001)(81166007)(54906003)(26005)(478600001)(426003)(356005)(2906002)(4326008)(8936002)(336012)(70586007)(44832011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 17:41:09.8330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec91160-9ea5-4304-22f1-08d83966bd66
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2689
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[Why]
Resuming from suspend, CEA blocks from EDID are not parsed and no video
modes can support YUV420. When this happens, output bpc cannot go over
8-bit with 4K modes on HDMI.

[How]
In amdgpu_dm_update_connector_after_detect(), drm_add_edid_modes() is
called after drm_connector_update_edid_property() to fully parse EDID
and update display info.

Cc: stable@vger.kernel.org
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 53bf8f60d30c..bfb06c168fba 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2202,6 +2202,7 @@ void amdgpu_dm_update_connector_after_detect(
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
-- 
2.17.1

