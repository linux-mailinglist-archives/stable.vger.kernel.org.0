Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFFF5E8CC1
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIXM5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIXM5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E824109779;
        Sat, 24 Sep 2022 05:57:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3RYGk003592;
        Sat, 24 Sep 2022 12:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=Yk1uIzIFZIRLvY1FYEzbZp9gtOw45C1PDnfrTQ+Cf4BXFoLt2ThQKTp2I5Jb8gndCdL4
 Mricau0b3Vu3hKWnKEP7DxPIz/aSeK/yBKKG8c/ru3r0xmW4ZMoc7f3t/mnVorrQYiGb
 1mBvWT/1z6ORHSaEGhsYJWlFw4iK+gXnzJu4WXYFWvk/6m8sxZ3YpNFj2CucP9JewYbQ
 MuLutMxS2EVACJdgTrpkBaH/Jqb4Y2WVD8/c0zvw3ck9pMhe3nye65ccA0CqnDcPVcKS
 fbZeZSikv2OklMvnRI7DS+sivaxCV37wtWoQPgCHst51V6U2RTj23i0acEYIp/7jjzYt LQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kgg1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCUMXj021091;
        Sat, 24 Sep 2022 12:57:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gt18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBStL3i7Oj6jmgio8VtyVjxCw2hv0Njm62JWdqUvbU84j3W9VfTy5n5LB6jxKWNDjY64z8iimMNobDO8MdJFujGPKYUxsw7/OYLriFZvRZTiui3+rVcrUAudKAXTjzxeXp0+5WqWi762wWwnr/9Yhv3Szy5kD5umT86ikKF091hkUehr6ESWmcxpGi2n8/8l2mRPc1BYArMA4E386WYQkJhAQnJVUw4c4auHmRP61DwE/miFu/yscLL99V0yXODs01OgFEt/PGwT17UVcwgSEV/YYswP0X5KCtqK3tbLUTkF3ZlWyyuqJGsNOiuULitvv0+RpB/kuupba3v/tdP8Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=U5zNXxhDUhRfbPpKzIvrBYR+pHX4a4I2L4SQXP9jh7jXyIOgcDY1LmwlGgLWDGFl+JUSXE98sWhQX3ODxj4HrrGHZakgDpjY9W4HWQ9Y0p35OUgIBn5jdbntPY64GS2zOUAWcRtsxcCRZrwpo8DHv9kwhscc73rVgYwsY87/6gYNMm0c3C6um6ahwaD5GH+IEKzoSE3zk8FbTRX190mez7eb43mC7SOE4J87Gtom9bc7WQR/NefaD1AQz/8AWr/4YVzQ6nUWTwQakpOEwuFDvh0blTsgROCTWoCa+84U5/SCPEDbgGyzEYcI3EsoK/ET7k303D6bjkGKlTx2uPmvPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=BzUMXQjrPoBrVFtggCKfW7qENeEdvUQxZB8pVHV/q+u04D2bwU5upGZAxVtyK47arRHhqQR65JaD9h5Nnf6Ckl45jaNt9UPj6rSYpA4B7jUXj65VAPpEwgI3o/1e8GkIc1a+BpyDW0c7WeBFxCXkAi/xd6PiVRzl44MlaQ+9cCw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 01/19] MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
Date:   Sat, 24 Sep 2022 18:26:38 +0530
Message-Id: <20220924125656.101069-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e6953b-9680-46d5-e230-08da9e2c4b62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNwyjvrsLbgc3uza1JvrusPgfpM3WfoI6T+oa2PxVfxuV6uFfU0q3owZGK9lMh7LeTWs8h2aX8u0pn+rFksxSOC65JNDMd2iFZJHPmpyrc9VF3S9p5394tBjbU54QNvnc12VLqqhIMi9U9+vDgfT22gl3J8Ls1IrzlJM7ywJisjz8Xaow9mUl9kVxiHDT1ZQ7tDDHHxaCQlQfUlvuGwuHwlv72CbJyeG82lj8Cj8HjQoRx+Pkm+niy8K+yqyvMUSF1XaqrpvWckPXLXXwtAXVLFKxRD3i4FWBwxlrlcL3dr1Eo7mXnxiHuONXCXTljj/NI+pna+zSfZTeySDkxw1NzFg3xLZBaib3iu340CVtY1qrp2F3ElxcLooGOSCG2QrwT2TkWjYEeV7rDK32E6CvUGajujDYLgx0QUYtX/bTMhlin6BHDQLRytmwONxt3YTXzrXnCvPQ+tgzSqpHd9FazdCg1qTfJE+0JVg5uMVNKnOvCbNEoVf3UWltIstVWSSEdJbyw3xCXTrhudkEpc3czQBV4XoIO3fO+r6DSTT7Z0htCDmF2BkMFNe4kQOFNNrW1Ouom5IEJvDEtEHpsbJ/CYvRZL/tCLlnriVzdw1t5bVV1y1GNCtd6Dsihsgji7edALSZb7AbRX+EozuBNT1U5Hoj7DrSHoXoL8Efqq2vIVzuOFo0LNN9X37Tr1LCQ/7rL56QGwzfxub6VXPKlyPLf3fl2P8WsKZ3V1qGHf1P84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(966005)(5660300002)(41300700001)(186003)(4744005)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HWq+qLb15F06Eii9l6BQl1xEd8UpRlKjL9zZmrkgNf+pz68cnoI4NARXVHMQ?=
 =?us-ascii?Q?4I9UHPDQL8BdRdLlisImQOYZEt2hQSN9qPoJeIZasCZp8LBEuDdQe9P09ysu?=
 =?us-ascii?Q?ZjYXosi4UOBuP4FZymtJl2Zea+XDPXsMXeuJoKKIbJP3+8ey3mUJkQODxK7X?=
 =?us-ascii?Q?gY87BRC4AT1ceXkoi3ZlN6Gjf60fHcN6cQ5sTXJSLn6HrzQWaaxw6x5fdFoi?=
 =?us-ascii?Q?jM3kRnRwDkbtvvQ4W+hT/ucB3Db5JfwPn7sohBqMTJWzJopGwH/6/DRT0mgw?=
 =?us-ascii?Q?bQFD1m+r/cLIhBuAGpSVAWlArn7YI1JIQrKafN2OhjWFHFFytEPXoY0/fRjT?=
 =?us-ascii?Q?nXuq4yopfM2YEo0eSwNcDi9PywEhmYVCsZ/rIg/3LpnGuF/OH9QvupF9rt1Z?=
 =?us-ascii?Q?cBLsQTsY1WR3uyyg8psMXmGqAAdnzgjc5x40joIyuft9cGoRSAQiJXqT5Ype?=
 =?us-ascii?Q?Kfcazoc+q1lc0tP0PFcbPzQ7k2CtQ+itykO1CS0pK0kVXaEeieXrGGwWrnfD?=
 =?us-ascii?Q?upVIXM6YkK2/aHvEDkRrwJ+X9sSC4nwDBC/VtIQ8d3v5G8GejHbhmINF0VqU?=
 =?us-ascii?Q?W6xecE8CgneJXpvLM7wuBRgJCwOkF49zIo3geymnPnGFNYgOtkeKBumiAgwJ?=
 =?us-ascii?Q?iDf4M9VdCy5FZE+e6JRcjKhHXiVyGJrbd4ZJ+9YS3dobSJ9R8QHjDo0kFitp?=
 =?us-ascii?Q?0lfxzGuUoPQVGQoWi7s6XWeNAti52rrVGlm89BmebsxLmY6dy3pK5hJP5dwa?=
 =?us-ascii?Q?sdK3RgKpZeeUz1zSt+8dXiMHLxQ8HVgQ0Y9+XuaOgvJ+pjJCp34bgj0MM7H0?=
 =?us-ascii?Q?uIR32PBNO5jSH3Jdpm21gdOcNs6o0KmgIGFjOGlymYZjxOktfNIhhYcRVFxP?=
 =?us-ascii?Q?Lc+hrRabFWR+Z93Oo8S3KWRnbFnDZkkflhlyc9yfqSmu1vUp7xcQcieFxgIE?=
 =?us-ascii?Q?r0Qu7vHZ+ny1EqguPJXyspdp8wG6ThfCERDIAH3pf1qShvZFS+j4yu6Cso22?=
 =?us-ascii?Q?BPrMssiWbONJP5pYGfGHgax8i91poura0u2nSQ7L6My0wNdACyXql/0KE6da?=
 =?us-ascii?Q?JUgx1KV6VWOndxxpxryoaXtp8v3ZFTGI4od15waqpeE7CsUXgm+cL7Y2E82Z?=
 =?us-ascii?Q?s6pGg00W0RYEnSDD0J8BChJ8dwCOKGTYp8LXJMnyyRcC6iUNorAbYvCe95ER?=
 =?us-ascii?Q?hh6++0ODbtgkmuMWNNSRBM6uZelo1hiZagaAM0GyZOkqd70OUo+T9wFuUGsX?=
 =?us-ascii?Q?BInmdfcT7rG/izn901CCxkYKdRB5/oSp+NJX1PEBdsm/o96t1Npx7FTJbc2G?=
 =?us-ascii?Q?WApKYzEF33yrZOA1G0ki9jGeXl6ZLrOnng94G5CP9qPJYPRG/cGthCilaEkF?=
 =?us-ascii?Q?0UNSvlJNpFe+2Ph5tEigro/dqJSypizwPfmjzYE0AjUt7qP3Zm4qnxEEltL+?=
 =?us-ascii?Q?I1iqQ4M3d0RCe73ytZ/s1xhR9N0o1HD3dVQKsRpRUcqvIxMVlhBe1/x3hcqC?=
 =?us-ascii?Q?zYnb7xJ2bkjyQdfJC2gRyQpG1FeCEmjnLwyKCidmZMhETLtAiFR0GtwK5gbP?=
 =?us-ascii?Q?NoyYfiBw1A/fmWOMZqVi5QBWcKD6tw5Qh6ASfLpe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e6953b-9680-46d5-e230-08da9e2c4b62
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:10.9835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pq+Z7698dlOFpKYwBH4kAbykN0vcgzqjo3k+TxqLMTQiGDEh9kqjtvQmaiLQ3KxPgSQQoX7gGOyQGZtNqQFww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240097
X-Proofpoint-GUID: d5hQ669Br44CjFWm61h0d07r_DB76cjh
X-Proofpoint-ORIG-GUID: d5hQ669Br44CjFWm61h0d07r_DB76cjh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an attempt to direct the bots and humans that are testing
LTS 5.4.y towards the maintainer of xfs in the 5.4.y tree.

Update Darrick's email address from upstream and add Chandan as xfs
maintaier for the 5.4.y tree.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f45d6548a4aa..973fcc9143d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17864,7 +17864,8 @@ S:	Supported
 F:	sound/xen/*
 
 XFS FILESYSTEM
-M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Chandan Babu R <chandan.babu@oracle.com>
+M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
-- 
2.35.1

