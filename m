Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2526C9E9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgIPTht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:37:49 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:4032
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727527AbgIPThK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 15:37:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbCzeGNZa1zcigGoCNi2hpkdR12qkKM81PiLNR8//ippb0dH/NLz5GlVFrXysglC5cly+5XUDOtJzEfy6ujhqTQ4a0WxPdCiVmcgj79kPGtbCTinaALSswnm7J56W8mlTWO+PAD0mPACaeh5mmDtAkIIk5AoSxrKq4Xi8sLbWLTxIYrNnpGaY4qzMzs2zp01MVEiwQj1jHn/4kIfZMiNRNhrg3ZxPjqMq/bAl3OHE9vQHJItRDGNrsmQaa2lYHgq5FVIvk+E1o6f0O6J8Kc4/Upfk066K+dFRAZU8Lw5SJ8LBG6Frp03XiU+sTZSDQyXxoAwP8vbAAs60Jxc9zaeLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RtXeTOcZfsHWL3n2wEFH72T/DlyJf3iP8hDH+sqZrI=;
 b=YKeDxCQOoCagAi363idBbwASgquWMi8ci9VPWXxoU1b/l6ts3VuVScr1+iiE07i3bHMcqNd6rAFhqC5AYumEZeiU+7Tf9mv7SAP5iKI2RWlW69MrfrZZQYbd+m27CYsVPSpKIzrqyhtzXZHL8b7RBq9ujDW9hlzo3oL5QK4OdVXVtkBdiRTr4QSxIGdtIHik0y7llnY3s19Xfeq5g+CuL6KBkGxExs0saVFH0eV0VWoZqpYDH/JKGSp3wN9SG5gDgu0entkHgD/zm3cMsu8MBb1LMFfZ2MPtYbcqmyo/4+Fpu6d/NpS8Hfo5iV+hAZJZQT41uZnod8gD+L0tadK46w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RtXeTOcZfsHWL3n2wEFH72T/DlyJf3iP8hDH+sqZrI=;
 b=XCGjy6CZtqOZaGU3GfOTD8/Ey9/YWDlccEnG5/ugn++e2LlmiGVlUg/BF5S2nhQJkO1TP+KMIlkjn+/BhuuP7aPlmOyhiT01l508hKUUw/7YpN4opXgjb0BLd8ch96inoYMQH1f2guR1Fk13JazYGnn3fHlShm+3yw0kJD4BJwo=
Received: from DM6PR18CA0001.namprd18.prod.outlook.com (2603:10b6:5:15b::14)
 by BL0PR12MB4754.namprd12.prod.outlook.com (2603:10b6:208:8e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 19:36:38 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::d7) by DM6PR18CA0001.outlook.office365.com
 (2603:10b6:5:15b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend
 Transport; Wed, 16 Sep 2020 19:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3370.16 via Frontend Transport; Wed, 16 Sep 2020 19:36:37 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 16 Sep
 2020 14:36:36 -0500
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 16 Sep
 2020 14:36:36 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 16 Sep 2020 14:36:36 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        David Galiffi <David.Galiffi@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 01/15] drm/amd/display: Fix incorrect backlight register offset for DCN
Date:   Wed, 16 Sep 2020 15:36:21 -0400
Message-ID: <20200916193635.5169-2-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916193635.5169-1-qingqing.zhuo@amd.com>
References: <20200916193635.5169-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 222d152b-c814-48fa-78ce-08d85a77d3ee
X-MS-TrafficTypeDiagnostic: BL0PR12MB4754:
X-Microsoft-Antispam-PRVS: <BL0PR12MB47540ED9C759C5F5B71915F7FB210@BL0PR12MB4754.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IhljxLH2plv5PP4ratDFJaOa55uSvsTnJmvDBA9lZ8+NebRICVTdnoXAflm3TCaMhJc7vk0Mp4FUmOMEYARhnp0U+JeqQFrtl9AGmbQ6dR2APtAk7WwPO5JrkBvPDHJm3oW94rxq2YsuS4o6gnxfvH1+3BEjUkvQ6n/2RG8tbgVljZ5MckENdrc6aSe7DsCxC/BwozTbPhE6ln1O5srjOoy6j/i38xhydZc9cp8Kta7G0YOmy7YATtKMbpV4QScPR+k7TJcreaFcJL8bHxCI14BDBuFcq6JuPCIzyK+EyN+dSBjv8wHdOrYMVe3aMH5dbzAx+O7h3OJWDFZfLhOjIMuSuKDf55jhTPtA8yWmNA9RmAYSBDxu8EC/IERvNG1HBxG7JJczOB6ALylyH8218g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966005)(47076004)(44832011)(54906003)(26005)(426003)(70206006)(6916009)(2616005)(82310400003)(478600001)(70586007)(4326008)(336012)(36756003)(356005)(6666004)(186003)(83380400001)(8676002)(82740400003)(316002)(86362001)(81166007)(8936002)(5660300002)(1076003)(2906002)(4744005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 19:36:37.5194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 222d152b-c814-48fa-78ce-08d85a77d3ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4754
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Galiffi <David.Galiffi@amd.com>

[Why]
Typo in backlight refactor introduced wrong register offset.

[How]
SR(BIOS_SCRATCH_2) to NBIO_SR(BIOS_SCRATCH_2).

Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Cc: <stable@vger.kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
index 99c68ca9c7e0..967d04d75b98 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
@@ -54,7 +54,7 @@
 	SR(BL_PWM_CNTL2), \
 	SR(BL_PWM_PERIOD_CNTL), \
 	SR(BL_PWM_GRP1_REG_LOCK), \
-	SR(BIOS_SCRATCH_2)
+	NBIO_SR(BIOS_SCRATCH_2)
 
 #define DCE_PANEL_CNTL_SF(reg_name, field_name, post_fix)\
 	.field_name = reg_name ## __ ## field_name ## post_fix
-- 
2.17.1

