Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80A160DB4E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiJZGbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiJZGbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C016A7AA2;
        Tue, 25 Oct 2022 23:31:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nZF9017455;
        Wed, 26 Oct 2022 06:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7WryNB1My5bJSxZ9gSU6/Lsoh6Sk6nBknjKAZ7z7xsc=;
 b=W4Ay8tT4yhYtFYj4C9Jc0l3kPrMZurP8gpl0jwfTXXb8+clxXdJ7esCePlJAKLoadoO3
 AZatnwojaLnvxCpPkFtNjS/757fzo7wCFeyXZe5BVRi2L28+U8udOdmPRbh++xSdts2q
 EnRSQtOwAOcAgxMkZr91BSfgB3LuPG7kTbSFZLFSfJuCT0TghP0X0yTpHkG3de+aqWyN
 FZMP39lynozcgw/wAQ/y+/MXJpN2yQk5yH4bClDIInwpNIcan11a40Vjj9FQMc06hmwR
 69hhgiJ+momyYNXbHTlL2C1/x2LMUPazPv/gXV8XI8mCwnEfM6aeMiKuubMSM88kPIHR +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e64k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q37GIH013251;
        Wed, 26 Oct 2022 06:31:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6yb73uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5ozGoNCVsSVwqFEmFqMsMU6G/IC4cqxdFCx8HQwZZqwFg9D5L06o7BR/JIBPHWTN4Tr8Sk84B7lb9jUHRUFxNe6+7mzYwH0zWz2VpYJbqtpRTVXzO0FeqniuIpltpp2C51dSWNFtHMIONLTeADf2BxPQReYFAL0S+DguZemqBCBlVccukbUJehCOb0ZiZ/rALyM91FJX/IsOfKrE4l4v+nfD/vkl3rf/6JN2rJ6GbCN/vhrnMB0dOJ4EYAgs/v5FVk1trQQoUE/Gqysp9LLjgLl5Lif9IMxz51JTvGQcuI8An9avzgDoccoK8P3blj2Sl8j5LgaAWHAIjA7mgmsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WryNB1My5bJSxZ9gSU6/Lsoh6Sk6nBknjKAZ7z7xsc=;
 b=Mcd27OsuhaploE6WoyqKEANT53lkBRjM02W+BFtCeS8wkyyV6gudnZFOOzPuy+S0b4G+/Imh0p6cyXDtfJQf0+1oR5SHt8RkYh7QCwpBtPkTQbUgcGvIV/6muVMI1yl8homJM9LqDnNg9yc4UHzqkz0aFlmTt2sOXupt2R8uAVvozwq72TkodBiwTJyEsv/fdcUMBjySNIVIl8YmErvta1QS9SHdwrxINIDZiLxnGym+K4f5y1TcH3ZxF4MgqioXZS6qMIb4c2K/0VTTjD3Zc9mHcuUzq/t70AlW5iTbqEaSIQgkNb7qkcsT5ChKD6FppI78ebSe9QXLPUntFxQitw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WryNB1My5bJSxZ9gSU6/Lsoh6Sk6nBknjKAZ7z7xsc=;
 b=mBQAWntuyuxIas7hFGpa15nr/Cbr7gaFBBj43gnPEuTrTQIfWt96ZEnnjnk64y347oQDSzwIhHpffXaRSKucTqXGOpI3Cvky5qdCYcRxOciQLZzC0nc/zg3AinptPAE1XPJje3eE0bCBZAvhfV2u/srk7iqL88Mn27V1S3J3+HM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:31:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:31:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 26/26] xfs: fix use-after-free on CIL context on shutdown
Date:   Wed, 26 Oct 2022 11:58:43 +0530
Message-Id: <20221026062843.927600-27-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0083.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: a75ef3f9-f00e-4628-83ff-08dab71bbaaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hn4CBfAJUwbKtb626G0N2GDEKPFrIDGXbB5uGEzYhI0y52gyhO49w/cqEDfm5cY8C0cRo3V/hAcaMRdK+hidtATlvoTFXJJ54aEIC0rTw95G9M683huvg2r5QNW8z/X7+89ulZWbpYjMMiOXgKDAKXFue8rfCFZnKl7kyNbShMb63nRut/g9CR8L1ACrobclVc2b50S1/ZzP21gmK3OFBNBAdC3Zdy9vlTauhcs5B7oygQWxvBLEFsmchK9X/q+TaCnW7fgXs/ZEGWsGQAi2dArp6vZThHNri7Ou8VpBpDHN7+nSGRok821cNeNT8B+A4cDLegQio2aKa2d/u71cZdrs4OyBwVemFoppNX4rUNjiUf4wo8FYCEWpgKDCR5MjFMxWH8za9CyqwYus3tPZ6g90GrSz06XUvRHZsOLvrCzX3lr8HcMGI2qCkuH64PKPbznspdrWAddIeMqKSRbd2lAHfqG1i+DueL+A+pj08Sug6Z/9QBebHCHj4fS3x1YChnI9Ak9dmNZuLLHfATu2eHfSAeAaatYFMMI7LB1ITyzgkuvYwnZgIvuOaS+J7KYT0ujsM+JxzcgyRznYK/Q3+HGJ7l157vYveVjmvG8/qIFeFN4xFA73dG8OMxUkVPOgLyCswsz1sg/4WgcVjsWmV3759Yf4c+PMcB9wH6HuNk3L0yNOPoOPWsP4G5+GTEG84No6nMEvFUsocJpP/Y9V+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MKzMO3TcikTVajbGxyH9hA4s6QjbW8dkhmzYZHXOPjlhGKMqaKCDSwTdy7Az?=
 =?us-ascii?Q?gzuzOyvDL0qnfZD+p3b6LP6+bxM7Okm9gkuPcV6zA/qtlDEnHftPk1zVt/4q?=
 =?us-ascii?Q?EAX88kO+w8Rb8SB6E1qQ9Z/HTKDz9CnSsMqUTMch0w95aHIBdOwhX4ihs2RO?=
 =?us-ascii?Q?VY83u36GGHKxmFRdpzohTa7JtBj13EJCjGNH7X+u5svx2xc0zCm2qwKot/3f?=
 =?us-ascii?Q?yNUfOLBRYF5kk+mjZyjqUXGrhGODczldqYI0smn8wz/XyVRBAl+mijGRJlIw?=
 =?us-ascii?Q?MZ/9RP8V1GkI+kwvDYmB3EQ1oePHdNv7wxOqweRj53eCUd9SFTdkXj+RaguE?=
 =?us-ascii?Q?Vo31JfjBob9ytgkpVLdkiETWaqaRC8pzpd/djGXdpg9htwbiNVv52N6/Mpl5?=
 =?us-ascii?Q?gFfZ2hNMkD1+U37BibnPgLw6fh1DB3xsMvErQ5v+ydsLJNCVtEaJCgOf2DwY?=
 =?us-ascii?Q?U7vvO5zfpkXJClzvbwLZPneiY5DQSQUZU3ScmKQLWszxATfoZDkfXnH+10Dk?=
 =?us-ascii?Q?XTVo36VZIXWFIfQiNnHuSWtiH1P7/mdB6l56aIfQ7CctAuFpFN/zCQdg1f4p?=
 =?us-ascii?Q?0GEEgGbvi6slq6DEgN/le6H+n2FEDLDH1+/UBH11YdPUGs7YGNMMnr0CFZiG?=
 =?us-ascii?Q?H3gD8kGewSkg/HbARFmqMzp08nl3RMZOV9jjRLjl4wQT8cVCc/CftNV0O2rG?=
 =?us-ascii?Q?oTtQBpFdqtZTJL9ydmLsXQfvJZBMjbNrO6+mcCatcbAwr4T3CAritS/i3+EE?=
 =?us-ascii?Q?2tBHo/RwQpy08ILfvUQgAeajHZ0d7+MOzmTX1o25utAabC1+TnA4O/0x8BA0?=
 =?us-ascii?Q?GMh8FAXkm9ldfG5yqxOtL4B8F6qic9uXG5hnmJsA839X8/XqCxbu3w5sl575?=
 =?us-ascii?Q?78iPcEuj0DOozFU+Z9AqreTuVnTh7nV70VIvDrsD2fuKnhSg3S7P506sMEdA?=
 =?us-ascii?Q?S2igCCjMNBKZnTgVV89Livb1Hww+t3OiqMaoMTxj0VQ3Mm8nLDG2M91ZH/Dq?=
 =?us-ascii?Q?mASa8eumZzIZMaRO5RFaeGbIKZ9agjdANUau7YSH70CInnHCmJ3gq2kKUKuH?=
 =?us-ascii?Q?tKCtOHrn6V0KKWmWweRRlmAWNe1+pWa4i3IegkjgzLIMrB35mMiN6tv1Xu26?=
 =?us-ascii?Q?csqr5P6QkUO3L6quFJzMTMQN+5/75BwsfJeZ3pJvCcko7xjt2VzdJHCsErOo?=
 =?us-ascii?Q?3/xhNRH/YSMwHnARgXP1fr5a2xh6eIv4uahBbre/JyDvWnI+ajvePwhmkMPv?=
 =?us-ascii?Q?bD9MXOG5OuX4Ze2sCwR2WTT9gMXqcHERpDCLp8jQxK8LeqS3RYioJCMves++?=
 =?us-ascii?Q?tTa7x+Fr5OWpw1HdjJhTP6eNoVTIKEiTmxgcaJQx460aOxlq5TAlGHgT2xj6?=
 =?us-ascii?Q?Wxbz4XjF6SXgzqlgdUBdNwAj1ORyXOqTVuzvGLwWzfKLa2YODyy+2FkTXAAv?=
 =?us-ascii?Q?l/qk7L6sZIpav4Za/GXK+ltwFEk670QhwgaFRVkVK/454hrTW8tfF/+VKuXO?=
 =?us-ascii?Q?Z5hapDCLpH++wpJObRXmY5nUKJWpGu6nGHWi2RbSND9yH5uC7zdccbVphK0v?=
 =?us-ascii?Q?1Z+koHt2a6hKtio9lNZuk2CDF8prwwtKjHLrbrpTLUW89Wcd4GovXkMCMBKV?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a75ef3f9-f00e-4628-83ff-08dab71bbaaf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:31:35.1505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YH5S83rttEBHUF7wist7yPscGs8uaxwYxx6L/q2xBJWD4Yp2qKjBJd298fwuDhwimm+F14b1ojHpgMIP3hrCZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: jAoTQSD_73LZFTBY5Swpwi3j2roViF4R
X-Proofpoint-ORIG-GUID: jAoTQSD_73LZFTBY5Swpwi3j2roViF4R
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit c7f87f3984cfa1e6d32806a715f35c5947ad9c09 upstream.

xlog_wait() on the CIL context can reference a freed context if the
waiter doesn't get scheduled before the CIL context is freed. This
can happen when a task is on the hard throttle and the CIL push
aborts due to a shutdown. This was detected by generic/019:

thread 1			thread 2

__xfs_trans_commit
 xfs_log_commit_cil
  <CIL size over hard throttle limit>
  xlog_wait
   schedule
				xlog_cil_push_work
				wake_up_all
				<shutdown aborts commit>
				xlog_cil_committed
				kmem_free

   remove_wait_queue
    spin_lock_irqsave --> UAF

Fix it by moving the wait queue to the CIL rather than keeping it in
in the CIL context that gets freed on push completion. Because the
wait queue is now independent of the CIL context and we might have
multiple contexts in flight at once, only wake the waiters on the
push throttle when the context we are pushing is over the hard
throttle size threshold.

Fixes: 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c  | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4a09d50e1368..550fd5de2404 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -673,7 +673,8 @@ xlog_cil_push(
 	/*
 	 * Wake up any background push waiters now this context is being pushed.
 	 */
-	wake_up_all(&ctx->push_wait);
+	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+		wake_up_all(&cil->xc_push_wait);
 
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
@@ -745,13 +746,12 @@ xlog_cil_push(
 
 	/*
 	 * initialise the new context and attach it to the CIL. Then attach
-	 * the current context to the CIL committing lsit so it can be found
+	 * the current context to the CIL committing list so it can be found
 	 * during log forces to extract the commit lsn of the sequence that
 	 * needs to be forced.
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
-	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -946,7 +946,7 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
 		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
-		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
 		return;
 	}
 
@@ -1222,12 +1222,12 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
+	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
-	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f231b7dfaeab..3a5d7fb09c43 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -247,7 +247,6 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
-	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -281,6 +280,7 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
+	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
 /*
-- 
2.35.1

