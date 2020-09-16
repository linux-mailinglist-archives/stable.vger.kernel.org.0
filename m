Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1B126C9EE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgIPTiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:38:00 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:62804
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727725AbgIPThK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 15:37:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHoAD2ImXrTDa4bw1RKdWQzwlWPyNpg3O5l65bEiaLOAqyTHTgrDEghdjtnd2b90+9jwtHr68RjJyrdR5oFgJtZTpqGX5tfioDRLcW87SvRh3D/NCbi2q1D+lEaxXIIficXDoNXucdoQNG94HTNN+vAIND4F7xvEeaZO9GKALd+W9yF7zDjaLn6uU6puKuKBHAnxa5gB6Gy7p1mkR3+7M0QMykZllS28bu3wfADaYoW2FhfT9StykCeWGYsj6r8QRjU0esrQPSEmPg9TazyTcqEiomR8maIVhhQbPv6HCO4yjt6PG1XsFU5ciHBwjYDVBcc6kjC+6gnpkzuQ2tyoyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UXiV4rY7PR7UYtR/sa8+Ilea7/YgxY/HCYyLDLzcR0=;
 b=oBNipYLf+hCpQwdDy9YgajqGal53z7/odENk+UmidYks2ZqpmHQfiENf+v71jW4Uj2hje9kcZxAJyfWFUvnDDtrDNb0obySn7YJT8fJFdMJXfbgR51KW0hpFpSQ2dubH4SlQc6KRyJsN3HSDdI7/0OAkSHbip+A9OphIMOH9o+ptkjq15f6RhuosfReFQsxKEjbdz1aSTJUS/TS22KNM5fN/aohW96p70FGOgjWrFdlqVGx1+H1RSionLFJh1sCQRq0YMFEVF909UTSF+Q+ecnatVG6tift71RYA0fX7iisXV4wlSOKaE78lEgjUP/rOreDf3FN7DgX1FGN0B8VGmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UXiV4rY7PR7UYtR/sa8+Ilea7/YgxY/HCYyLDLzcR0=;
 b=rW8fGOYTkveEXWCD1ndv+yD96T+79BNC9p4mrJ8x0OVu761kASxYzzDuifz216rXSOfy2bU8mh7nrqLlUa+bgj9DWRPi75supqQLKFfb8TEgUBfkyO9kThihpnzwDPz8UUkYCxLrZ5g+dJBvLDstex5ofWumc4VjBa9PB5sEOK8=
Received: from DM6PR06CA0035.namprd06.prod.outlook.com (2603:10b6:5:120::48)
 by BN6PR12MB1250.namprd12.prod.outlook.com (2603:10b6:404:17::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 19:36:42 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::dd) by DM6PR06CA0035.outlook.office365.com
 (2603:10b6:5:120::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend
 Transport; Wed, 16 Sep 2020 19:36:41 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3370.16 via Frontend Transport; Wed, 16 Sep 2020 19:36:41 +0000
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 16 Sep
 2020 14:36:41 -0500
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 16 Sep 2020 14:36:40 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Qingqing.Zhuo@amd.com>, <Eryk.Brol@amd.com>,
        Wesley Chalmers <Wesley.Chalmers@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 08/15] drm/amd/display: Increase timeout for DP Disable
Date:   Wed, 16 Sep 2020 15:36:28 -0400
Message-ID: <20200916193635.5169-9-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916193635.5169-1-qingqing.zhuo@amd.com>
References: <20200916193635.5169-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 222a51a3-2325-43df-2acb-08d85a77d676
X-MS-TrafficTypeDiagnostic: BN6PR12MB1250:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1250F6760A09E6DA4943685CFB210@BN6PR12MB1250.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWvzieSWO7o+Iqm+HwKUorNshQ5nj/ODZiKHpqxW7aHmvXJVJUDZ4vwLe7WLdOV7dUm1uyuhDNlmQJWD+ini5rNCqUyikhtej3i4mhkz3P5NqEpi+3nRkPRP7U6A306OZiaJ5IDmmbtmZYotKdEIjTrT+ALdelElnJ7hS98XvLAGaPUfZ867UpMkLFxgx+r6yvQaDsGPL1FWzWKJhnr9OprxXv2bKSLfPF2mY7Vqm9FDI7j19ON4OXf0gBoR3Uw956aq8cR3DGDdhF80hEbfLEP7QqjCxs7NX3gp/zPfifRxntITYuipbgrmKbSydjshfQfmlSLB052HyWh9ZxCk7Utqeh5Fq2yBFEFz6HcZUlTbHQJxq5oFTOuNy4n7oJJHBhN5L20Ov1Zgb/hgkPCwIg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39850400004)(46966005)(1076003)(47076004)(83380400001)(82740400003)(8936002)(2906002)(2616005)(54906003)(82310400003)(81166007)(316002)(6916009)(8676002)(356005)(36756003)(478600001)(86362001)(426003)(5660300002)(70206006)(70586007)(336012)(186003)(6666004)(44832011)(26005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 19:36:41.7642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 222a51a3-2325-43df-2acb-08d85a77d676
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1250
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[WHY]
When disabling DP video, the current REG_WAIT timeout
of 50ms is too low for certain cases with very high
VSYNC intervals.

[HOW]
Increase the timeout to 102ms, so that
refresh rates as low as 10Hz can be handled properly.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Cc: <stable@vger.kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
index 9cf139be3f40..f70fcadf1ee5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -896,10 +896,10 @@ void enc1_stream_encoder_dp_blank(
 	 */
 	REG_UPDATE(DP_VID_STREAM_CNTL, DP_VID_STREAM_DIS_DEFER, 2);
 	/* Larger delay to wait until VBLANK - use max retry of
-	 * 10us*5000=50ms. This covers 41.7ms of minimum 24 Hz mode +
+	 * 10us*10200=102ms. This covers 100.0ms of minimum 10 Hz mode +
 	 * a little more because we may not trust delay accuracy.
 	 */
-	max_retries = DP_BLANK_MAX_RETRY * 250;
+	max_retries = DP_BLANK_MAX_RETRY * 501;
 
 	/* disable DP stream */
 	REG_UPDATE(DP_VID_STREAM_CNTL, DP_VID_STREAM_ENABLE, 0);
-- 
2.17.1

