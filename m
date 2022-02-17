Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81084BA24E
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241559AbiBQN7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 08:59:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbiBQN7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 08:59:54 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67572B100A;
        Thu, 17 Feb 2022 05:59:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiyO3vUzwUDgKBx/rimX9N7md6q+G6SM1CML3jX7i9LS+1G/gt9/eTLRn4GAuQbGEOgJRBCxhxujaTzKQLNdu3WGY1B8r3/Lc/Pxq70PsKgxigMcOAQEMZ81WtrkXUnmDwDu8bHPPgIrMn6eZZ2HerS/w/WHa5yWUicqgBRKESonfButXvdyH2NnVoVk1KIbOraUAukb+LduNMQdUAH/PLKmhtEjXZXXFXR2QYU68zO/xdyLNbCGUOuM7gsDodt6uKN5advKOIr3mm2nMoLUigxvmO5VmFYhHgy7QPJm9xWr4iHJV6tbAp/AkU47GXdDNbtvvcR5EmPOKHUK9omJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCcUVX7UBLxJgJcjhtpPOkc7vV1wAWf7jfNUPetjIO8=;
 b=iScSPA36xYWyC3zJPSyc6nVXAG3BKbwEpJ30wVyTKgO3begUBisN8mIZtvoO0XKC5tNInGJOXikh1/cP/vIheU7Y2zQcc4+yjyNqezLTcPEZV/VYbaJkpSfbm01eVlHjG9TG37+rvJW7N9SGxd5rLHeF1edVDguP514FpyIQC8Js6XMtdV/D8PPaTl3UQ6nt8RCkr+PzcEcmSWVQiBgfMQiVqm5gisRq+DAb3Bnn5ExK5HGp/DwirpMTgQ20SDYtw1zamyOjT1DZX4S62rhPeKjOw24NQSn5GrtJleczLygBVNRxYcFg8K0SKg7w/phz4mPOKwSOXkbmuzl7kIwE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCcUVX7UBLxJgJcjhtpPOkc7vV1wAWf7jfNUPetjIO8=;
 b=CQqE6q4TOGpfIUa6rmheTRxU/EFT6XIxUpCMx84ZDpy8JePKO0AbjLkXtdphKkH+xGcz2MFTB1Hzv9AgXDNawyci8fPyisq0fUdK3/ZFEz79/kM2u7zAATvwdtX1VVZCufXtVeWnZmMtUAlYOdQMkTPPiHkOJEFUquXcDsKf2fKyMaWhslbm3q3KLOxBo8TKf1g67SuDLeZPQVlAWxCDjECNuBtSjlfgKkqwOFT++O4nIq2LSqTTDeV8StbS/z9+9FJc9cGa4/PrOAs4y8E0SV0njf3G5PHdKapUKoBRPWml7tOQYYcoiM50h1iQohohE5m4NxBeV5/UKgXEf29ONg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from PH7PR01MB7800.prod.exchangelabs.com (2603:10b6:510:1db::11) by
 DM5PR0101MB3129.prod.exchangelabs.com (2603:10b6:4:2d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Thu, 17 Feb 2022 13:59:38 +0000
Received: from PH7PR01MB7800.prod.exchangelabs.com
 ([fe80::f182:8810:c22c:a1ce]) by PH7PR01MB7800.prod.exchangelabs.com
 ([fe80::f182:8810:c22c:a1ce%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 13:59:37 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        <stable@vger.kernel.org>
Subject: [PATCH for-rc] IB/qib: Fix duplicate sysfs directory name
Date:   Thu, 17 Feb 2022 08:59:32 -0500
Message-Id: <1645106372-23004-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BL0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:2d::19) To PH7PR01MB7800.prod.exchangelabs.com
 (2603:10b6:510:1db::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33ad06a0-1a5b-4401-a2f7-08d9f21dbc0f
X-MS-TrafficTypeDiagnostic: DM5PR0101MB3129:EE_
X-Microsoft-Antispam-PRVS: <DM5PR0101MB3129527F5DBDC2A4C4E55F9CF2369@DM5PR0101MB3129.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EM582EE765mWUESM1c1E25WthftAvnbb7K/65zoIFxelwzbZSjZRwqXBah+cTd1bsAi/0gJboR8YYN6MSmglh20+MVbhJcjW5MY0pj7pwEHYkFTtY11nXY272bKKhtIu8SXleWGrfXgj4XjU00An4qwlJMH0EeZH9uoSALXHNibXqXYrtB0929NQO2L2tTM4L1JqGluE/ZaddoOHCX3T9mxzYipcm2MxwS4W+rK6qxcQ343vRiHGcJq2+DsqqBAFSyXVgf3DTA0KlxnceLbAEn7XM3UN8zlU20V9XZcq55f9+Q5rF030OtPEbOErocqQMmKW3ioL3lhco8WwR2EZOPfPttSTmk3b6hXSbAIqA+6cx7H2Q6A7Xcy8wS9bPZNa6rq9SAboAZveIidJeMe5sPOfjmiATEuRcT2o8dMsNC49pX9+3TFlB6Qht++lyrvi7st21d21QKT4s59qkv58WAZI40wPCzMOO/FIWNgR3QmXU3xhQSIP0UmTGwWwFa1DiD4WZWFhTYHogbnVPjn8HVKOfrLDsB/Vm/chBKG7utAJbc7VGo6+fjhH6SnKofbUnGoUx5SCV/LdROXDyisEzbeWBUE9w7Nc+Higp0CvI9vN4JgiBozhI/6HoIf1Zp2uvLuBx7ZHnw/0UX+GeuvfDpXlohGTBYc/ep2taD2BOA65lZ3YUBchz2f8DOpXT+Zsrm3HtUG5zIiRFJ2Q/EEFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR01MB7800.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39840400004)(366004)(136003)(396003)(346002)(376002)(316002)(66556008)(66476007)(66946007)(186003)(6486002)(8676002)(4326008)(26005)(508600001)(52116002)(6506007)(9686003)(6512007)(36756003)(2906002)(6666004)(2616005)(8936002)(54906003)(6916009)(86362001)(83380400001)(38100700002)(38350700002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5ovSq8n0H8TObxGRxsVDV2y900X1OADgGTODDR+DkPDa0pLOK7ea23Qa1pN?=
 =?us-ascii?Q?IhP+sERkBoz+OXx07J2l6Yg/pVxItGUVRyNZdpriSI/jh11qxmL/9blTfugh?=
 =?us-ascii?Q?OhiCqKPoveZ92UIobN3ESy0xXn9C5nKglP4njMZlX/QkCnA7Xx1D9bICa4EH?=
 =?us-ascii?Q?UQoYMtxiv11CAutVU4e9GPER8bV75lP8FHGEKFjAyih0oJpPTFUg0+h7hWO2?=
 =?us-ascii?Q?Ghn8UpV8EyfoQmWt5d4oVZW4D4Ocfl491HetXxUD7+FSE0+U45XQ9JH3kuNa?=
 =?us-ascii?Q?nWcfWrpj0gmBAZA/+bcnhUIAziOxHY3OPSTVi1GTLbG2UGAWgMjKMHZnjuYw?=
 =?us-ascii?Q?GjmMhxQSrIyTLA0hEF5jDXTdCURSg3Aj8Wl7bDlkJ3H0oLFctjlGWfoSKy0s?=
 =?us-ascii?Q?BaXZQK8VvBANl/cmF1fi8l3SphOMcHvHxGwi9simhfbJt7ao5fbS8HzUXRru?=
 =?us-ascii?Q?6LCPzTOUv/IQmiVkjKuE3L8ArB/Phvb3K6yW0wf+AyvEqdyk/mOsf/2minHd?=
 =?us-ascii?Q?FUBOZXyV2HUS+Q/JTrmOoU/hZB7qpybvCXLfBaC9LUwJ16re+SSaIIOh91DV?=
 =?us-ascii?Q?1qGh9xfXDNLrIH1hl2mMswLoCj0it/PIKXh1UGm3k7brf/AYNUZ4QJfxOB6A?=
 =?us-ascii?Q?EIhJ+SHFOrPs7/TYYnoYvs3XN3f/XncLorOI500MDJbLXHUKijCUM72hrwXo?=
 =?us-ascii?Q?msnWsHLOWlmZ9x7stUGdy9f6lEtHCxmO6vXByk86gESWjyKem6ycQd0hVpGy?=
 =?us-ascii?Q?6nS22FwFRcXPuEV1MqcYhgZXfdnZKyAaDNY7VYInQRKYcoUfOTB8VTNuB2pi?=
 =?us-ascii?Q?VeyduJIms11LVyieAj5tyWilNNR6iqw/T/Duc8p2lBr7VqDdp7QdXNjseb0H?=
 =?us-ascii?Q?hTrX1oC9s4mWHta7FE6dLCcGbGmpR1j62nOzHYIeEDygMDlkEn2SyNa+5npW?=
 =?us-ascii?Q?UH5HsUdnzoh/3/jxf7bGa0xbI3XJ0Q7PQGzPwmir6naiGHp813I72GegMkXL?=
 =?us-ascii?Q?ZaXeRshTQKdrNPf0fFqt7ndgUYQqc5Dq//Kq80lIZfpwAeoLezYyex/JbY2E?=
 =?us-ascii?Q?p1UjCWUkGy+KngVNhfV8KU1kZGHsQVHQyH50Da/aRXFwlfTBZCPovPpmoFl9?=
 =?us-ascii?Q?rC52tciHPMuf7y6cC7oFCzlFUw1jYN4co9iRfzozBfFNkohjjvh0zCHwp1HL?=
 =?us-ascii?Q?gHKsK6F/4028vcMbGMZHX1G7gB3hw9jr0Qo4Qr1QeQgtO+J2tNB8T4CLr5mh?=
 =?us-ascii?Q?kVKXpScA79QbaLjDGdkoR80HoocmZ0GQjDZCJUj5lFUSEmHssYoqIBznTaox?=
 =?us-ascii?Q?GUYJ+6CuYa1U5t46nrpZdQmBTTZdzRUGq70UY0V5yTfOBtxS8aefqPQ+Kqhe?=
 =?us-ascii?Q?4pyUag110+Ek/lo0mwx3+xIh4kVhQjAqab0YopbWHrP8HrI9cDxDPZpFPuvv?=
 =?us-ascii?Q?6brrhEr7v8dAD16aspggveICFunZ7PgCEVzqprndbG9gWgNs8n+798GDFVtf?=
 =?us-ascii?Q?6fm2N+Xif4GDvgDEIAXI45VdqxbjkTgHtO7sIBceUh35qHStWLbcatUxbSXD?=
 =?us-ascii?Q?nzNRhv32zXirkZplShTziL+SPTbRr8Keu+EaxjHqT8VEuncjWUR3uu2zoo0j?=
 =?us-ascii?Q?8adPK+RkdKd9+bN+Axcjicpk37jizzS0x4HP1rS/GBMMp6agjP+l1SbG3Pbs?=
 =?us-ascii?Q?6LkfF5ZHQfwWRAgUrUR8CP3ALta+VTrbe2jey+Kf+VPP7MIRZAtcoazMuaUY?=
 =?us-ascii?Q?E8Ro3GQMbw=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ad06a0-1a5b-4401-a2f7-08d9f21dbc0f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR01MB7800.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 13:59:37.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhKCSKN4qcwr2nC8bhyiIqFcPDLR2HNUnNMaZzSjtzlYyMLW2+J8Fb4tsH2dp7wyW+36ls2wDNnv0YI3/phBP8SNG8rLbxlbAwCM9eyH9t7mzEejGU6FINHGwk/Q0Ei5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0101MB3129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

The qib driver load has been failing with the
following message:

[   21.186138] sysfs: cannot create duplicate filename '/devices/pci0000:80/0000:80:02.0/0000:81:00.0/infiniband/qib0/ports/1/linkcontrol'

The patch below has two "linkcontrol" names causing the duplication.

Fix by using the correct "diag_counters" name on the second instance.

Fixes: 4a7aaf88c89f ("RDMA/qib: Use attributes for the port sysfs")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
---
 drivers/infiniband/hw/qib/qib_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 0a3b281..41c2729 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -541,7 +541,7 @@ static ssize_t rc_delayed_comp_store(struct ib_device *ibdev, u32 port_num,
 };
 
 static const struct attribute_group port_diagc_group = {
-	.name = "linkcontrol",
+	.name = "diag_counters",
 	.attrs = port_diagc_attributes,
 };
 
-- 
1.8.3.1

