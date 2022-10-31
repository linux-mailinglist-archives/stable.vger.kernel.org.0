Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDFE612F86
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 05:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJaEyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 00:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaEyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 00:54:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC47BDBE;
        Sun, 30 Oct 2022 21:54:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29V3d0Ck017667;
        Mon, 31 Oct 2022 04:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=OBKjq4rnxZfhU/7Q+f+D7Gj/EYc3qslXdt/Scx+xjYk=;
 b=nJH2anr2mWIWzw0NeY9cXuaDcfLaWhKT2g166YWU+wWVuJwANQOFkpDJCPTf4H10Fv+/
 RrqFMYnldXulwnRmTJN+MKcrHbbj07I8kXvHuYzzuHXYmUGtB+XR1+5p8Ng0L0clt++q
 VVPkyXw14GOOF4GWSeQFeDn/R+uSlAVKPwyCTJUxpzFzEdi+GrNqbCdHizos8KKL93Vv
 AhxD+Moeq9uLU3R+uW5DTfZf0tg+hytRm4/IghfotUq8HNx16m1uniQO74JLRgi5rKT/
 qYTQk/J2IIW6gyGuOmCvkA8pDnkt+SLwYn4OhUk+DtROm/Msa6848P3Dnch3c+EdPDMI Hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty2tdn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29V3SVM8019508;
        Mon, 31 Oct 2022 04:54:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm8v2tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMf+moAd+PeZIs1ksVfO2nlTwUrt+NN3hkok+TGxbMupmQpfZyXY/XzuKKzWDI+iQlG87Q0VqqNeOMyO5Kcq+DyT/pG+K6HKMwrHzS54WNfkhtyGsPKx7SIMDF3s0fCOvRdn1tItMPkKK2G+DiKjI67Y6XHsiXMZuLlwz/P8cbisqf02sgmP4iTmxoZj4hPga4dLXObfTytg+dDSDXlxo15Bm0VrfHa8ZmVweDSlRCZNmBdPNRv1VjwRpckMxmfwuRyzBg1aSln1U2LNQ9HqMvfuicfKw3QTtnZHh+qDmv54H7jRh3qvorlLXzRCZriXhn5eP3SmSpSxSovrb6cfXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBKjq4rnxZfhU/7Q+f+D7Gj/EYc3qslXdt/Scx+xjYk=;
 b=huICPoNZCU0PXVr2gHsF3ayZqk61+mXrVYFvyOFYsXLAdQ4bgcyICzqFfg7t9NNBALkgTG68oyJ6clKiTPteS0ha1Sm/dMC3ho8/O7yCfFhiZqJuLOieP9deriJQAdm8Hr81FiXjla1JCPCI7tJvf1iWJRbWAS9fK5Ie8rOAll3h4F7A+TepCo3Pnn/2gjGEUGDzvrmX59FjqfDAFnYGro1RqX7ghfwW5oD3JjfyHij68Lahu+wrezn4BgczWjjquGquSNXqZaj4nEr1mftSJ0bCMnzAzJ/4JXunq+th22sESECiEvfBeqGGRfhWW5c+EtdcpYG0Y9WzglgSn7ziKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBKjq4rnxZfhU/7Q+f+D7Gj/EYc3qslXdt/Scx+xjYk=;
 b=RS7WSIz29c8m/B7hwa3C0dFDthRqaFr1sHP4fFS2r2p4vyn28NSfqlGbzS2oc+Eaz33dFr+O1PE1sNIIikG6x1o/8ICpwjMMCxpRxRBHsflgs48c5w95bJ8P9A8yg1OLeEYMK7QsnfyElijw5ElTc28ZKizjJYzjJ3S36w6avlE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SN4PR10MB5623.namprd10.prod.outlook.com (2603:10b6:806:20a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Mon, 31 Oct
 2022 04:54:06 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 04:54:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 1/3] xfs: finish dfops on every insert range shift iteration
Date:   Mon, 31 Oct 2022 10:23:52 +0530
Message-Id: <20221031045354.183020-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031045354.183020-1-chandan.babu@oracle.com>
References: <20221031045354.183020-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0019.apcprd04.prod.outlook.com
 (2603:1096:404:f6::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SN4PR10MB5623:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2e89c2-176a-4fd2-ad61-08dabafbf098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fVCyiNVM5AxNJjAQcmvIGUs5yOffgFsWk1Rt2M9Waxmo1RYGwXVHTQRFc7RelKpblscnkpDxPUhaG7GbJY7FwpmuN5OKKFthDzOspYfn0/s3Ut5KyL/4xVzxOhlLQJU0xtH+4gbmFohTa5Rsmk+SONZug+VQ6Y3QZE0jTNKkgAMA4pVcZpHDoTm21pSp+Ot9H+papmvlN1nYD/cbxcc8zTxxdyBcWnyuIfY1g1Y5YYHHUTXVJPnhT2glOOfgIYGGqvxl9mQKW1SIHMfUep9X78oXALgTDUPurWCUi4L2xdkVZ74udcWvu6ubRglFYBrw4A004RGtEFQhMh3sQel3HwLCfN0StbY0ZBPUGXJmtPHzeAwxQYmB/DsTqN0H1cXM/hGfhcA+kfbq87uorxkWytkai/q7K0dhGoHqZDqJsNVjU+tcDauDaQX2M3iNa4WdmVP+GbqjvXG/JS3/iiW9+UM+pv/uVAMklj2XWy4ysSrslzFZgf7pzpAklp4BMckCC43KVvMTgqgcnC99CyWPkeTjgKG/XAmuYKqnfjK8a4ybxB76d57w77Lk5cd7xajj0DzAtZGqD+kS7NChCC3vGYj8W+rcZ8xa+LId1kNSkjCe52KA8G5yzPKsd2YIjRAAvkPE0hOMxJbjkt3/M5+BvF298rB1/wc2cAu7ZCSQIeaGnmWHqXf/aIrnKWESPlT5mL4f+PSwujZ6LKKZ34j7pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199015)(36756003)(38100700002)(5660300002)(2906002)(83380400001)(86362001)(6916009)(26005)(2616005)(6666004)(186003)(1076003)(478600001)(8676002)(6486002)(316002)(66556008)(4326008)(41300700001)(8936002)(66476007)(66946007)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wA+KpGfxxku8N3C8ttEe/3wsvP+pyPJuHigR787IXXkwXHBehkgNKZ6pa38?=
 =?us-ascii?Q?C1BV+fwODokaV799BvHwr8pH5oVDC13aEAV+Pb/dFRJVUO+40Rz0rPtYoVm9?=
 =?us-ascii?Q?8xVC/uU/xKPp/o0PGlww2eT22bpBa12EAHuFmMWpBT0Gj6ycQ/EF3WbjE1ju?=
 =?us-ascii?Q?/lnoICi1Fr4SqKTfnhUcLFH6Om5TCh4J5RDc5GHZK1ciXDoHFOqJYHND84zH?=
 =?us-ascii?Q?oON/Fi3tKtbgLdJuBo0iS4X3PdGpzQMxL5t3C2mOP1wn4FUPdDKr4NXqnSHN?=
 =?us-ascii?Q?skQOvyMvvYrMnbuY0ruUGiUwSs5zPIcG7DSA87FSdfMOZ0oJHq9it7lEr0S8?=
 =?us-ascii?Q?u7RCconaqSU7l6gru+wE3bCf7nNgyDbNiNX4rK8x7umLkbH/PnGDPiSkAf1x?=
 =?us-ascii?Q?96bMdKO7k6n3Sy4ABdZKIspCuAgVCJ+WeVlbzWWa356cqDMNNIi74rJAcSGS?=
 =?us-ascii?Q?xMfSjkK2Qv1O4IMioH7Kezhp6f/JXrl9oHwKs6cWGCyb1tPS6TiAl7qECe0O?=
 =?us-ascii?Q?uUsa39k1Xc1tB3FYRsxLsHhnTxR3VTMiJlQYJQNVYjiThQQa0EXx4eq8IAUV?=
 =?us-ascii?Q?7NEovRA5nDqz2tF3XFAPYBgxv2OoUQV9BNtn1+ZK63FFGkFC9OmU+zPLgNNM?=
 =?us-ascii?Q?LFhLh1p1+mPGiHhD7qh7W2vaxvZzkWjdPMclR0rQbVvcOOGKYcwd1+fbsWvI?=
 =?us-ascii?Q?tMAZmqFOQWhYLjjyuCxilnkTGuY3cYzmdwlPwh2847UDlayIgaoxWthLci6I?=
 =?us-ascii?Q?4QTfIULgfVjPK3b/xgegL8HLrg9VmgUorxGbr8Aw/ss4LuzkvENZSJ3Ipjzv?=
 =?us-ascii?Q?M0aVpDJYkzixw5llA4BNvmo+NlXALZyY5ImxjUo+8iCJlPqeSHpB7cpNFQqy?=
 =?us-ascii?Q?+E5xzSwItdLmo1D6ovUNJ81It5vsDNW09dUUxBQ7hwbwy8H10L0uf8WQQl68?=
 =?us-ascii?Q?vZOicNQKTW9sUux4TFoIFnQF4NMUfxTlisaAtBewQGkCtHfX4Uo6hRWqd5JD?=
 =?us-ascii?Q?lxhGMGGTzelmUoKAV2q2q3S02M+LFPvpH5mb0ns/VEW+VR2pmX00YKh4oyDs?=
 =?us-ascii?Q?i9eFrawFGv3tGAIGwSTuxhRvbCMPeGC2qIOanaKxg4HJ55DMUmf81msnY0p8?=
 =?us-ascii?Q?ZBsidLU8EpvFf80t55n3YIIALsSxZ2f9rSEEUaq/QUjcM9tM3J9rM+qxpqSv?=
 =?us-ascii?Q?hbbLEj2J88MJxpNt8SWvEKd9omihobLN0Y23EFJbun3Ee6mGW0UhwEqlEH1t?=
 =?us-ascii?Q?EJdFL+fQCfyu7lxL/38wFS+Pllk97aqHcgBGcUqBv9kQQxo8wUFtKzXTWWp3?=
 =?us-ascii?Q?Hmzrx7gN/qLZoFlVX/fWShIvMyKYUbiiW1Y5gabycAvnJ/V4phy7uDFfGa+C?=
 =?us-ascii?Q?QotvmMvxyqdqjLe7jn6xxU/CdcYCfipDow4LjvBJv9VaC3Im0WP8Uat66LYO?=
 =?us-ascii?Q?u4D5g6Ny3yJvSuBScX0whsJlXQscOsrxLAl5ftO2kRHERZs0/eqHGvU/30cC?=
 =?us-ascii?Q?I7E/mPUiEGtKQaWb+S5PHJJ8u/V8+BwO2nptxIRFBeUnvxmtbPqO75vPFAht?=
 =?us-ascii?Q?8t2JyHa8BS8tY9Lqegc++XNnjhC1sfLDbkk3L/MRINBRaD4xiK/iETx/AqHt?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2e89c2-176a-4fd2-ad61-08dabafbf098
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 04:54:06.4472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvygZ+Km3POJ66oyWVO5vcg4McLGXUPW8Swnc9h/OUxpreAr96OskXPQehF/tIwLqPAyeO50CMRs4Ip0kE69Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5623
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_02,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210310031
X-Proofpoint-ORIG-GUID: o8AtWOJYNx3ywSuEFSEypXRlGYOGP2D5
X-Proofpoint-GUID: o8AtWOJYNx3ywSuEFSEypXRlGYOGP2D5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 9c516e0e4554e8f26ab73d46cbc789d7d8db664d upstream.

The recent change to make insert range an atomic operation used the
incorrect transaction rolling mechanism. The explicit transaction
roll does not finish deferred operations. This means that intents
for rmapbt updates caused by extent shifts are not logged until the
final transaction commits. Thus if a crash occurs during an insert
range, log recovery might leave the rmapbt in an inconsistent state.
This was discovered by repeated runs of generic/455.

Update insert range to finish dfops on every shift iteration. This
is similar to collapse range and ensures that intents are logged
with the transactions that make associated changes.

Fixes: dd87f87d87fa ("xfs: rework insert range into an atomic operation")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5b211cb8b579..12c12c2ef241 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1340,7 +1340,7 @@ xfs_insert_file_space(
 		goto out_trans_cancel;
 
 	do {
-		error = xfs_trans_roll_inode(&tp, ip);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.35.1

