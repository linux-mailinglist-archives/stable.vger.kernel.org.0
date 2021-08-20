Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764973F3737
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 01:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhHTXQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 19:16:27 -0400
Received: from mail-bn1nam07on2040.outbound.protection.outlook.com ([40.107.212.40]:51694
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230303AbhHTXQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 19:16:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cb+jAQxq3DvVFTCmktdvA89rH+2uu8W7bVir4uV+HaMBBM+aZvBxUYOLsSfyaYXG97g6g9swClJbYW/zv0VOnoUxK4quI6wTRm3vcGQqnQUha16X1YwRoGxJn04/A+8uZOhNc5lIgaox9yaK8FgVWY/aaNCm1ubu6KEfzWoLL2PzMp1mmgLRaNQSEAGfQ2IkS/98i1Ujoio6NRvviqy7BHePrdm5PfOhSSi3PIhbQin8I923N1jIB0qdMkOIJucqWpig9Kzi72Htm+FUXIZY/USGdc5n3/J5LF7pRXKI+EXsodCl9kguf7ta0x7ut7Ew3xmJ0UXUnylvpO5EwtrAuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5Z5SNdkKQgEmfDz5YAm1Bl3ioPVrQ922bihPX/duyA=;
 b=dhvtvHBvlgvTv/9Xz4kR/MjFpAVkajmz0JvRB3PJyHsCaNhJ/J03N3I4YwKqulqHYXQeLigYMPepxOA/vAdA8awQ8xUSlrDdl3Tvsf67dBALVv01vDRM2kOuCv1tEugiqCQvjqKcPZV7OGiCLWYarCYmkWByZ0YZ4lfZdTapf81n8TzB32O/gqttiW3Jpaw/xskFaxiG/jkmS7F9nTY3+auijux0Bh4ObanzbvyhFBFYPh64N/r9cUCZPeiFH3fiTd20U0E5KVgo8ftRjTfYqIkpS4kBngy7pnsNR+PFN0MkGPDC8BF3qXNHzUN9RdAdO5y0fj6WPtHQxt+GwV/5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5Z5SNdkKQgEmfDz5YAm1Bl3ioPVrQ922bihPX/duyA=;
 b=xDng7A0oVmqOt6x9eyMFZxmADkXOBAxUuNoBrgGezl8iXw21KBImo2nu1cLX7VK7fdiaJPKyMVGMmi40d1SJwnndFM4igBu1XkMr7Cba+j9TNlpJ4cNm7hWgU1vhlmzaq/grAZR9Z70V8hMAe/F9Bw8WLOu3L8dkdIpNmLsbEYY=
Received: from BN6PR22CA0029.namprd22.prod.outlook.com (2603:10b6:404:37::15)
 by BL0PR12MB4865.namprd12.prod.outlook.com (2603:10b6:208:17c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 20 Aug
 2021 23:15:44 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::d4) by BN6PR22CA0029.outlook.office365.com
 (2603:10b6:404:37::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Fri, 20 Aug 2021 23:15:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 23:15:44 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Fri, 20 Aug
 2021 18:15:42 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <mikita.lipski@amd.com>, <roman.li@amd.com>, <Anson.Jacob@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        XiangBing Foo <XiangBing.Foo@amd.com>,
        Martin Leung <Martin.Leung@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 08/10] drm/amd/display: Update swizzle mode enums
Date:   Fri, 20 Aug 2021 19:15:18 -0400
Message-ID: <20210820231520.1243509-8-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210820231520.1243509-1-qingqing.zhuo@amd.com>
References: <20210820231520.1243509-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 304e9a74-8ff3-4463-f453-08d964306fcc
X-MS-TrafficTypeDiagnostic: BL0PR12MB4865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB4865D205BD72D46FC282227EFBC19@BL0PR12MB4865.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:561;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aMWPkCUMJNemnLfPf4VBH4MvJGVwOB3sXOIVo6wug5/9Exr/as+XA0RhxfXoW9V+8rMVRmthboPlj41oH9GA7CtpUHBTS8VYdVVk+PjETike/+MVs6cbEfSskgOIxabewJyupamuzRh2ttJLPTpgoqeVp2ejyx5KulLPiaLMTiGvqHeiQslQPZyIVLbLDIwCTQ+k5gvrpOe3XtXZJftnxCOmG8lvI1rEDVzym/gKH/ryUZW+Xm0E+6tf2b6ilNhxJMNOkatlfBvqmE5z2KsC22c9ZLgM7Jj7uaCSvVkfOqNpm3hTVX+6Zcx5pbCOmIBM6nDs1IuldvqlHWkNsjcTCb8WIt6OqKTV+EZ9CT1AKKNObuLkUqxDoAwK0B8na1kFWEkVMJizLBfL8AB6kp7kGoKjWnK1BmxGVBQnlXgENC1aDwaFFYA/p7dJCKXfTQK1DspQShdZjQn4FtlknS5XHvlfExkHG5dXaPXEKYORK3SDqO320EssBlwgvb8vRTAJSlOfrJaFIR9zVL+mNtqn86AiUwlHrZmUx332cDDnNHrC1te+01nL4TMtZSZvDJ/OC/GFP9Ui84dJrsJZ1sCETBLGVOCwLRB7AubO9DKecnTfmqTxCc34E/SaYyAnkM2wYeyMoDdrEv+bku4gRlQh9y93xnh8n/xu1MWGpVdDR31v6aGp47ALUQJQMUNxONnvvIZ595e5d8ZKa3n+RBGecRoYYUcBaJKyqrW9E6Zd6Y/BotdOQCPNMQbviSBalpwDKBFD/I2e2FD/Bkie7H05sw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(46966006)(36840700001)(16526019)(2616005)(70586007)(336012)(36756003)(70206006)(1076003)(186003)(8676002)(83380400001)(34020700004)(82310400003)(81166007)(4326008)(86362001)(54906003)(47076005)(82740400003)(478600001)(5660300002)(15650500001)(6666004)(6916009)(8936002)(36860700001)(2906002)(26005)(44832011)(316002)(356005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 23:15:44.6136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 304e9a74-8ff3-4463-f453-08d964306fcc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4865
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <Alvin.Lee2@amd.com>

[Why]
Swizzle mode enum for DC_SW_VAR_R_X was existing,
but not mapped correctly.

[How]
Update mapping and conversion for DC_SW_VAR_R_X.

Reviewed-by: XiangBing Foo <XiangBing.Foo@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c   | 4 +++-
 drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index e3e01b17c164..8ad296a0ee68 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1854,7 +1854,9 @@ static void swizzle_to_dml_params(
 	case DC_SW_VAR_D_X:
 		*sw_mode = dm_sw_var_d_x;
 		break;
-
+	case DC_SW_VAR_R_X:
+		*sw_mode = dm_sw_var_r_x;
+		break;
 	default:
 		ASSERT(0); /* Not supported */
 		break;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h b/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
index 1051ca1a23b8..edb9f7567d6d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
@@ -80,11 +80,11 @@ enum dm_swizzle_mode {
 	dm_sw_SPARE_13 = 24,
 	dm_sw_64kb_s_x = 25,
 	dm_sw_64kb_d_x = 26,
-	dm_sw_SPARE_14 = 27,
+	dm_sw_64kb_r_x = 27,
 	dm_sw_SPARE_15 = 28,
 	dm_sw_var_s_x = 29,
 	dm_sw_var_d_x = 30,
-	dm_sw_64kb_r_x,
+	dm_sw_var_r_x = 31,
 	dm_sw_gfx7_2d_thin_l_vp,
 	dm_sw_gfx7_2d_thin_gl,
 };
-- 
2.25.1

