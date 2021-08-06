Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B693E2E57
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 18:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhHFQfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 12:35:50 -0400
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:24347
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231682AbhHFQfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 12:35:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOXifPzpk7ePeuum0HYdfW9c/OcJD4BiwvKHrRheMbrEyKjRx3nWChlRix4Ib1qby/y5x1kYTopHnSAQL3qpGtGzMTV2acIT1qiypLhSi+Q6Yb217hAqZv06VdGzvPkcqMvQmv1YRAbZglWNd9UzG6HVNwwy0FZ48Ie3+hnpt2DMc14PFiqkwvTHTdxQH3FsTatGjdkwsL4gGQscwNw9xppTbcAlY6xzQoMt15H7Ed1Y/EuzYmaMTJQLjnhA2Ux1um0qGf0C/HijbsqDHa8DNXJX4fTTYdy0SpEf5HTCV0pQ4TpFptj6/KH+qYTIttLlQ5rPwiRw7cBR8jUPdQfCIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2cyG43YGVFsuk6CcwXDn50EhHzgw5QOFK4i2eke05I=;
 b=mWJg9Lr8NOAX40LJEHaGC7enEIHEvhzPf2EG77Eq9souJNYs48etynULmYtg7JPIPdRwXkYNpB9LS2KEDBL6SLxhkfXd8ltf4YK4iK5ezDkoho0BvymfR8HEfvI636ZS+GuIB9d7ZmPf4oGnIN8vjFKwNTCN5LGqr4HoEMX5pLDme409CHrD/2lyE0xQLuGoWa9A6PAzWS6Xb2aovytdbkLZTW67HHT6xm2pig9S+48dmHObSOxwFj9W8V42QPgAQz51H1l/XMKVawoK7StMJO3AvsoeVWHPlXfL0KfceifKAZsuhmeFK1ZZW9gvDYz/RnNzIUDQ6T1FOnM8AnMzeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2cyG43YGVFsuk6CcwXDn50EhHzgw5QOFK4i2eke05I=;
 b=PNSGeIueueTI0PQIYKyfL8hP2aZm6dpFaixrDMXSVQvVnm0cxIkrtMaIbLL/KEN+aU8HZY0BGLx+YH1HyGYoqbZ98QSZnlDuSdpj0FaAqNCdQOMgV2sWyGtFetw3oR3ZKeOIAd4RkiIMXl01ykMAQoj7RjBMKRk1zb8oBmbtQf4=
Received: from BN6PR17CA0014.namprd17.prod.outlook.com (2603:10b6:404:65::24)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 16:35:32 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::b9) by BN6PR17CA0014.outlook.office365.com
 (2603:10b6:404:65::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Fri, 6 Aug 2021 16:35:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 16:35:32 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Fri, 6 Aug
 2021 11:35:31 -0500
Received: from Bumblebee.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2242.12 via Frontend
 Transport; Fri, 6 Aug 2021 11:35:28 -0500
From:   Anson Jacob <Anson.Jacob@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <Qingqing.Zhuo@amd.com>,
        <Eryk.Brol@amd.com>, <bindu.r@amd.com>, <Anson.Jacob@amd.com>,
        Eric Bernstein <eric.bernstein@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 01/13] drm/amd/display: Remove invalid assert for ODM + MPC case
Date:   Fri, 6 Aug 2021 12:34:37 -0400
Message-ID: <20210806163449.349757-2-Anson.Jacob@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806163449.349757-1-Anson.Jacob@amd.com>
References: <20210806163449.349757-1-Anson.Jacob@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e482d85-245e-4c2d-1f87-08d958f8359e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267818D4F0E346422578093EBF39@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kzMGOyhNpdasKPTstun7UKit/dsCKZXouwtZEAncsorfJDzmQ7gGQCIc0sNL+ymye/QpgMPIIt1tvqcG2lej4ZK+Kuyk67q+c+w3KwtqnNFbtBg7ZE+rzhfsu9xLNeFPqijH/pKIo9Ebxl5jyTfFbbVUrrWtf0Gs9mQVRy2fAUB4TGvxzaMJvcAGvlpqePgcXiFk7q4J6o69RjKe12zHHKjj+T0C3muazoWQWsz83UFJzwSKuLDcqJjYxksKyI92sRFqllgbVmqg4rlaEKKjHQhHKU3G1wtRwoFjOIjf5SBvJmVQgLqDInyT64VsTCsiiUFSObjwtByX9kU1XPiXieRQmWFJdJiEDbmW+Aq+EIllmB6hk7S4zCjeBJfDMJGiozOG157MOtTtFBuIw16yQlDEMGGepG90lxLkYtr0hE8wc2YCZCzJZl1NHGjStIm+e+IIwYcpf856E5y9+ajaWjSusnKaSWVtUl3k3oLlg7EARwiQ7pgeRyxuJNopw/XrD8LzrtWZe3uiYaCPe5LPTSks/mE3PQnLD9+mgnz5GTnyJCZVd+hNhKOza3r6lNbjSK0qUSBTTcY3U5JZT0hs9j8TBIOOC957tc9JSUBEIMpjqBgEnGxkg0ctJJbisSNEjdcskOmXHbDYYZDLJgBIJ89xRf7i2SAfQDpeUUZvyxfc6it3zHZYxOh1nucnpM7V/d+tLrZpI2SFoAGliCgY0egc5h/pvknM4JkCuYWWRXc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(508600001)(316002)(86362001)(5660300002)(4744005)(336012)(6666004)(70586007)(70206006)(2906002)(82310400003)(83380400001)(47076005)(6916009)(1076003)(4326008)(8936002)(26005)(36756003)(7696005)(8676002)(54906003)(36860700001)(81166007)(356005)(426003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 16:35:32.3894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e482d85-245e-4c2d-1f87-08d958f8359e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Bernstein <eric.bernstein@amd.com>

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Eric Bernstein <eric.bernstein@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 253654d605c2..28e15ebf2f43 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1788,7 +1788,6 @@ static bool dcn30_split_stream_for_mpc_or_odm(
 		}
 		pri_pipe->next_odm_pipe = sec_pipe;
 		sec_pipe->prev_odm_pipe = pri_pipe;
-		ASSERT(sec_pipe->top_pipe == NULL);
 
 		if (!sec_pipe->top_pipe)
 			sec_pipe->stream_res.opp = pool->opps[pipe_idx];
-- 
2.25.1

