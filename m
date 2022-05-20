Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA61552F314
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 20:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiETShU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 14:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352912AbiETShS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 14:37:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2112.outbound.protection.outlook.com [40.107.244.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1096620E;
        Fri, 20 May 2022 11:37:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1EbJmz/4JkFzD4awedT8cxr5654CQS5d8E4xGfcqj5EGw86tQyxh4kB0zzPOyYd+q8ViNHUDU41ihTppjpkBgJSTGtQQY/Osesb8KTBejmQ1W1OgwiPuhkOZOOHKmZpFQvGeO9Bd3wQ9cEHpm8hMv8xP63IgsxER7dNAzhUlaCf//vGIUb2R9S1snNDvKmi9oxkzsZEcV1QnYDy1gwNj9hfLk0UmF50rhL437HRRNvMzKsW/zTQp0lMBl6YFwBVfL5BOhk/a5ylDzltx9pLVmdrdtyAzIHrlp//AQK4mn2r7NAdaQgbEM4l+uFoLsV/ae1SRlJSrdNgeTErErCKxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oba2kjB8KuG6MMG1wDq9qjXc2rlurAIxQNSb1MyYjXI=;
 b=UJm/spcVupT5sTDGXHzd2deRu5bZo7z+uurUrk++pbl18Bu+5p5gNWGCtpfg+6lXOQ77huaJlcM3fnU7h3juL9Q/tzxAnv7ZZWNI1Pj1wPxopoABtQhPvP9MwTfoccME6pebpIWdWGQb9+WEuPQi8XeP/Dn1gJksc5MlYPf5p3Jni/xgT7lgV5ZKzeqVx3mGTZfg7L5dDfFcl9LWROKLMX7UWo/vyLMUr37O55CIUOeCdcJoQFvYci1vph6595+3QXGTII2Xl09ArpXwzMNUmZbiW1SoRbTm1yxnrd5FEFKFRTYUevHFmLkOyGtVRuMoa4QSaPeFeFLEJgCIyVPaqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=nvidia.com
 smtp.mailfrom=cornelisnetworks.com; dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oba2kjB8KuG6MMG1wDq9qjXc2rlurAIxQNSb1MyYjXI=;
 b=LQV+zNKgcWimN/Jfk50uWXq/ozhaCLbyBujrgIZ2QCB0x1Z0z0MN5O1RN5pOWpiKWOCOuj0lB2tDf7+rXPAFh5Ys8560v/xpYiuMkXkOiHETrwYpHRVMkvydaJZixsDrBKwzuOLF/rAF3cIbnQJOt2c+ePpYE7dfl/p/vwFAlmfBzNo93OIZ9ysKXRokBx0eQp0lfz9eoIEjRHNq4ZJozpTxiXqkjyEa23KWOLP9Qbh9KIXvJ9F2DAqo785bnZKw9LJG2p4lLWJYXLtIgJzXGWK8w+kcyK1fH+a6x4kmGX6ol7+fyFB1RP54Z8Amzwi44Go1aAEXIzgskG943CG7rw==
Received: from MW4PR03CA0111.namprd03.prod.outlook.com (2603:10b6:303:b7::26)
 by BN6PR01MB3298.prod.exchangelabs.com (2603:10b6:404:da::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.13; Fri, 20 May 2022 18:37:14 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::f9) by MW4PR03CA0111.outlook.office365.com
 (2603:10b6:303:b7::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Fri, 20 May 2022 18:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=awfm-01.cornelisnetworks.com; pr=C
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14 via Frontend Transport; Fri, 20 May 2022 18:37:13 +0000
Received: from awfm-01.cornelisnetworks.com (localhost [127.0.0.1])
        by awfm-01.cornelisnetworks.com (8.14.7/8.14.7) with ESMTP id 24KIbCAk055738;
        Fri, 20 May 2022 14:37:12 -0400
Subject: [PATCH for-next 3/6] RDMA/hfi1: Fix potential integer
 multiplication overflow errors
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     leonro@nvidia.com, jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Date:   Fri, 20 May 2022 14:37:12 -0400
Message-ID: <20220520183712.48973.29855.stgit@awfm-01.cornelisnetworks.com>
In-Reply-To: <20220520183516.48973.565.stgit@awfm-01.cornelisnetworks.com>
References: <20220520183516.48973.565.stgit@awfm-01.cornelisnetworks.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb1237c7-f868-45cf-f3d3-08da3a8fc214
X-MS-TrafficTypeDiagnostic: BN6PR01MB3298:EE_
X-Microsoft-Antispam-PRVS: <BN6PR01MB3298FE892D0B016E57ACBD34F4D39@BN6PR01MB3298.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFTJCa8UybvUJDgGUlOdmTUfCKHGqjg9G0zHV2399p5R4gVLRd0/Vhnlf5W9hdw3poYK+ai9ov7WNqs3PiRtyYMMGKGsAOj95tHXZj+KA2YjQzezteSvLawDwC34yp5/3SwbAMQpnDBK0X+rynJ9lhc6psSI1+xl4XuA1EUzpS5BDCDnZhtEv1GP+wEU0NuSyKAefJmgcINRV9ES9KcEml2RAz62f79ZJIFKf8BSbQlMOmcoMzTg/ucJnog/TKTn1hxSZH1+Rb0da4kiwGeQLsKzmFSygD/u+2bEiEHHxiOK1Wple6BopA6a22biujvs1BfV5+S0OQnttGgIZFzP2Uz5K82tfEYD9mOwhPPGkcN/3sSteqQA7UjclQdqc/hxJScth3/lbc4wbqLfY79KRWjUI+49VyJ61ZGIme7mCAp7X4zByrQ6TROqIg4vsi+xIJrO2y60EKEj6cZaKqR4iF9imfq4zBaQqH4p8RmPffWfKF1XS/CIP563MCFhek1WJElPAyiDMvUXFOIGsq+FacMrRECRcS2mx8urY2zRdqKMkPYMHUC3RVUuMeVh6+fiYb7JyQfCqhFOR4B6Tp9qF7pGFxLvsNbEtkk5kguVNFrIkG7aYmr8avU8DBgjo62b5kcan7HKnk/bjYPPtMm+PbcDc5G/8b2AwZqp6tisTuIzLiWeqhztRhFzIFHBn+Ze8v0rmIMyFuC6bdFVQXJkhg==
X-Forefront-Antispam-Report: CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:awfm-01.cornelisnetworks.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(396003)(346002)(39840400004)(136003)(376002)(36840700001)(46966006)(426003)(336012)(316002)(186003)(86362001)(36860700001)(44832011)(5660300002)(83380400001)(103116003)(70586007)(4326008)(70206006)(47076005)(7126003)(81166007)(1076003)(8676002)(8936002)(2906002)(41300700001)(508600001)(55016003)(356005)(7696005)(26005)(40480700001)(82310400005)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:37:13.5671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1237c7-f868-45cf-f3d3-08da3a8fc214
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[awfm-01.cornelisnetworks.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3298
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When multiplying of different types, an overflow is possible even
when storing the result in a larger type. This is because the
conversion is done after the multiplication. So arithmetic
overflow and thus in incorrect value is possible.

Correct an instance of this in the inter packet delay calculation.
Fix by ensuring one of the operands is u64 which will promote the
other to u64 as well ensuring no overflow.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 4436ed4..436372b 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -489,7 +489,7 @@ void set_link_ipg(struct hfi1_pportdata *ppd)
 	u16 shift, mult;
 	u64 src;
 	u32 current_egress_rate; /* Mbits /sec */
-	u32 max_pkt_time;
+	u64 max_pkt_time;
 	/*
 	 * max_pkt_time is the maximum packet egress time in units
 	 * of the fabric clock period 1/(805 MHz).

