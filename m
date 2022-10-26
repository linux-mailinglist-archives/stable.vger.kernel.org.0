Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A570960DB3D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiJZGaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJZGay (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6317E7B1C0;
        Tue, 25 Oct 2022 23:30:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1ns9c018188;
        Wed, 26 Oct 2022 06:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=a88sNMO9jVtT2VZKHh12YeklY+tx4d17Rw198CGCP7w=;
 b=nTaJZhBtpa9p6HB32XYIAxHn+lWbWkos+ffsCws2o1m9KHUnjm62COU2DcYy0fMiOfzS
 F1DYXb8zIdyaHiKGnsYxehFi7We9nhCCk4f4EMyOxOgxvA9mTDg42PlXtwXBFJ4GalHG
 K60RpRcGscF7CfeDIA5gj6oq8n5no8Fee+cMAEbJJpmfEi6Q6VdNySiSgGncvtXtLw7l
 2H1+4ah1vv82MTmTSuldc27kd9Y0Ab/7ryqOR9NP87lX6bB+5T83qjW5DXRvxdQN2rCF
 Id0rVVu7M/H9Z2eVo8VI4vliQjf7Owl3Xt+7fsf6w6MdMayv26/ZwSxvRN2sFxZrJthU Xg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e62m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q30Kq8013261;
        Wed, 26 Oct 2022 06:30:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6yb72x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmWBhnS7c1xd+qKX7wi7XbpvFxTo8RHQ793jb19XuVB5L9546RoKw9YDdpf7jW/G00jTbQXG/Ojgw+dOCEjIkkJZcPWNsXLOa+HVLbRrXNJq1RXd9bSwGNQoAaYEJr7ZxPOH+wzWAdwaDIf9JOny7s7fdA9wplNVP1Mo899azwH/zvDoQ4KdONFHKYfg0Tg0+UnJBOL2kfcJJz56yRfOEqOz06nDeOa9r855xok4RBOH9DMjwOPYjtXb7XarO/xWONFTvc0c8z2KI09Eqj+bKTueW5BTiMiQFhJqT/GfJg0/yz9eqiqBwPYxh989HCNt2IQm/oE2NtcgYvAmUQ4JGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a88sNMO9jVtT2VZKHh12YeklY+tx4d17Rw198CGCP7w=;
 b=JodOOGEeKpIbaltigt4m33OepwxfC8WyXcUdXSXe5NKhWdsP8gTrDoq31UlseF3+bftZdKCtUerJ8G6ck9lDKmtLv2iMT6zyBBbKRmcp2410a8RFeuBCG+6o3GwG7hIdfcOcfx3/iLWGAcIechwE3acaMtMAjYq40VZTW/a3b/Lva+3pwm5BBUeGyAh8798ZVvsylW53IGKwzumtBXBsGVg5ZuQh6BmNdZylIBEPvuDkC7WuB+tEVgvoz/6hxsDYuMHUZLOIJ0Dd8oAX+Tr0bTLVAK8gJHXXrl/pawsoHrlICf5+zTP2/mBMHNV70gnoL/3F+m/OWaoPLhmf+36zxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a88sNMO9jVtT2VZKHh12YeklY+tx4d17Rw198CGCP7w=;
 b=KQLwkIvthl+ZVRpdPNP5jvuflFOjuGk+wbZWJ6l8Cu19nUt+zmeof7w/gSEK13RqMC4rAHhUOcPn1tV32SpxOdWrhRnzyuAKci2ppVVWKHbdQSvizidHrvD2so70Gwum3UEfJu/iFZAUZTrbr52o+ygHiGmYqD3d3//kANUHAv0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:30:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 18/26] xfs: Throttle commits on delayed background CIL push
Date:   Wed, 26 Oct 2022 11:58:35 +0530
Message-Id: <20221026062843.927600-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a932ca-b247-4212-113e-08dab71b9c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OtRU63qvCHqw3nQkHoI01UyfjFA1zKcGvMghYqMouWYVw7W+FzdjkwpVMhrdK/atqwLN4TWuAzc5D8TUdc8bv47O0MqGPMBH+InjdBGytSS72fCCx75GFsZKmAedb32Okrz6My4BctQzSx3tGqGU9K8bwdeEStMQH55ZH3soHPji1WBrAp3DAxIU58KUr/wdEPJMKTF2xItiPVKRFwO4V0K4GRfkvncOP2VKqbp4dNU2rob6uQwP9BkZufAxWdbLNjIbt6RKc6IGY6/SoeYa/Hil8sSQJFd4cFg0LO/jQPL7KXm31g99+qYDu0oslqjn27dgi+rwsqRBUVn9UT4hBHyzlqFUACptRYfmCfTvfUoy7z36wHFiVMg/hVKY4zrZh8SNtz3G11FNkY2PH4Q0HK92W1HpbiLerGqmJMW6tzAjkeLbrE3efgFpZwIrlDVy3+D1sP8b8m3KCfJFEN7U5QQnL93JUraBSkQ2vsYQSuL7BqbDm8nL8JjO+MIQ8AyX1++8IegNQ8ZxiF65Qk4b7ljxC/UY08eCXGnWMX9LnwFVKp2C7SkGFNWBthktHbhlBlO4577ooCbCfT7lE4EU9Szz9lArzzKNLk9D9SQBrRzPM1+phk79OLvTYc36dZJ5YYDRzoCtm2M6WiOgvMcyh3NNeTk9pdkuvJkUCxgDcQ8Mdla7/p1qLDAnAy9ewHsj1i56/oraClwOSsRiQjQPnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WDdOYdALoCrfmckf8bHKCZSH+k5Pu75PTBSYlbAbj/BeEonlvMrrh7WVaQ5q?=
 =?us-ascii?Q?cNwoPc34oZw5d1kAYrbhrusaN8zoEMWTXXcZaqGhGNLOsWHunEtFu3RAUOfC?=
 =?us-ascii?Q?TOwl9uJCwj51aV5MXPwzwo38Mc+/JG9d5s5dmAHcbnOaIU9+vIKDwwACWFjz?=
 =?us-ascii?Q?wh6hkDzdx4bs+tlxJ2GiJUsK+utBzdf63Y0aSxjKblvPfghEvXRM/rH2n9rA?=
 =?us-ascii?Q?zy26Z38iNaqUULHNSehyKYoLO6SLdIk0hwaNzmLr7qQCq875iFDY5akCKifu?=
 =?us-ascii?Q?TsJgXDt1C5Eps7hGQ7czyaibxwhhOxxPw4LGUI6gtDh6J6Q3F0shWfihh0LT?=
 =?us-ascii?Q?htF8ny2JsjfvzC8RvBCDHnoRdQiZt+vNmdb2BO5ssVxCqahvYxQuXUNLFw8X?=
 =?us-ascii?Q?6DoOEFtQavBuGt+P3WaOk8OjNW0iSsjHE63l+Id/EVuIEy5iekQ3DvhUa2ri?=
 =?us-ascii?Q?OyRNhG3FIk8LUHKBucFbBzNSKNtJFjxQdIBwyvFLl/7XxKrdDaTe5hk2Hmz3?=
 =?us-ascii?Q?3SI87NfAy6tzAuu5IPt5Izdnz1Zw1Qw13oHgaXh9livQNFwq8YghsxEI0Us4?=
 =?us-ascii?Q?QPeoCLbpIvxGOC0Y8BuCRrP/mnD/3ByiYaryoqOWVNv+1meat6KYCw8egWop?=
 =?us-ascii?Q?81baTS9TAncNZNeKCkgTMkffZx/fdlgPWMEvzmay+5YxW6dff6t5OiT0FRzg?=
 =?us-ascii?Q?IBUkfGL94tby4PRX/AXYlbsflhtSEkOXqRA9Pl64rGue1LCfSJGl4bb+H2uz?=
 =?us-ascii?Q?uD5SbDJmIWc+zKMQbOdhu+mtBBLTjM9kCd1Beht2y+6Oxay5arGiXoucl5Fq?=
 =?us-ascii?Q?Hl7M/QO7kOKX9R01TAT+5ypsokKVMlwsuDK1xQHjWe3X8JQz+DqHuli3HkDg?=
 =?us-ascii?Q?BvStR+njFoctGdX9ze/dMh0V6QPsSg/gGqwf9GOQ7wl/4ZHqVrrs013kSQ/o?=
 =?us-ascii?Q?SkHiB4K8Rt8C9HeSKvvu2FBxu+Nnd4SeZGSOIyJVM8aotVowFDcuOiJAH7/2?=
 =?us-ascii?Q?21QoiLKB4y+UrN4O55r4kdx+Fxjpyp2hQUWVjIDI6AgEL1nagsg4OQ7zlzM6?=
 =?us-ascii?Q?V36Ms4t6BB+kHnRY0E/zYGzKVZvjYBxCpHkgx9IrH/xOhyytROUOyZLCWmbb?=
 =?us-ascii?Q?HuSI/gBFfrx3mteG4Wz1Ag3xU/U9H/0jKxTHO6xgpm2s+7FcKMdqIDupAPbE?=
 =?us-ascii?Q?wdgRng4pGuepqxHaf0aEC93g/51UqpbfFtPpGWC2cKcXBMPIJsuWuT7hY/2v?=
 =?us-ascii?Q?OgSPnuLt5xOe2NPz4d1Kteg53iBe1hHqtGHso8QB9mIHvS4Kqirc3FPS/ZOq?=
 =?us-ascii?Q?XlQkBJ5MiYgTiFs2MoDcMfSfDtixqmQj9Ppceuz8yjrNNsUjdggce9a4X2Te?=
 =?us-ascii?Q?b7lSvHgzXmmpyLF6l0SZpqxSiZrsO59WJZ9R2k5LezihLo3AQOCs51KayAjf?=
 =?us-ascii?Q?vQXOw94d6yc+o9C0ig5KBziigpZn4tiGu7VbH6qLUEajRAmwu0sQ0TjTDdCD?=
 =?us-ascii?Q?wcfqv4XHgkyXqtLFUsonpCj1ApQgmZmh5Bvm3XrvVwOLvFLmU6tKAl1inHCh?=
 =?us-ascii?Q?u9lYnEbb9ITFAyubeZPy7hogyxs+MVmpf+p1xOGhuocYPpiM5SYiRlqmXGNL?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a932ca-b247-4212-113e-08dab71b9c36
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:44.1791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43YDxswYOTtrwzCiqFgGdcen1aoy+JXOSg6kuyQsVRM7ckEqQnCat+zRemiIQOiuQNsBIfsZuA96h4oO+wAv2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: 865nyakOY5DZ0omty1I4N-xdaFN29hU-
X-Proofpoint-ORIG-GUID: 865nyakOY5DZ0omty1I4N-xdaFN29hU-
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

commit 0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b upstream.

In certain situations the background CIL push can be indefinitely
delayed. While we have workarounds from the obvious cases now, it
doesn't solve the underlying issue. This issue is that there is no
upper limit on the CIL where we will either force or wait for
a background push to start, hence allowing the CIL to grow without
bound until it consumes all log space.

To fix this, add a new wait queue to the CIL which allows background
pushes to wait for the CIL context to be switched out. This happens
when the push starts, so it will allow us to block incoming
transaction commit completion until the push has started. This will
only affect processes that are running modifications, and only when
the CIL threshold has been significantly overrun.

This has no apparent impact on performance, and doesn't even trigger
until over 45 million inodes had been created in a 16-way fsmark
test on a 2GB log. That was limiting at 64MB of log space used, so
the active CIL size is only about 3% of the total log in that case.
The concurrent removal of those files did not trigger the background
sleep at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c  | 37 +++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_log_priv.h | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_trace.h    |  1 +
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ef652abd112c..4a09d50e1368 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -670,6 +670,11 @@ xlog_cil_push(
 	push_seq = cil->xc_push_seq;
 	ASSERT(push_seq <= ctx->sequence);
 
+	/*
+	 * Wake up any background push waiters now this context is being pushed.
+	 */
+	wake_up_all(&ctx->push_wait);
+
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
 	 * move on to a new sequence number and so we have to be able to push
@@ -746,6 +751,7 @@ xlog_cil_push(
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
+	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -900,7 +906,7 @@ xlog_cil_push_work(
  */
 static void
 xlog_cil_push_background(
-	struct xlog	*log)
+	struct xlog	*log) __releases(cil->xc_ctx_lock)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 
@@ -914,14 +920,36 @@ xlog_cil_push_background(
 	 * don't do a background push if we haven't used up all the
 	 * space available yet.
 	 */
-	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+		up_read(&cil->xc_ctx_lock);
 		return;
+	}
 
 	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
 		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	}
+
+	/*
+	 * Drop the context lock now, we can't hold that if we need to sleep
+	 * because we are over the blocking threshold. The push_lock is still
+	 * held, so blocking threshold sleep/wakeup is still correctly
+	 * serialised here.
+	 */
+	up_read(&cil->xc_ctx_lock);
+
+	/*
+	 * If we are well over the space limit, throttle the work that is being
+	 * done until the push work on this context has begun.
+	 */
+	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
+		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
+		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		return;
+	}
+
 	spin_unlock(&cil->xc_push_lock);
 
 }
@@ -1038,9 +1066,9 @@ xfs_log_commit_cil(
 		if (lip->li_ops->iop_committing)
 			lip->li_ops->iop_committing(lip, xc_commit_lsn);
 	}
-	xlog_cil_push_background(log);
 
-	up_read(&cil->xc_ctx_lock);
+	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
+	xlog_cil_push_background(log);
 }
 
 /*
@@ -1199,6 +1227,7 @@ xlog_cil_init(
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
+	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index a3cc8a9a16d9..f231b7dfaeab 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -247,6 +247,7 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
+	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -344,10 +345,33 @@ struct xfs_cil {
  *   buffer window (32MB) as measurements have shown this to be roughly the
  *   point of diminishing performance increases under highly concurrent
  *   modification workloads.
+ *
+ * To prevent the CIL from overflowing upper commit size bounds, we introduce a
+ * new threshold at which we block committing transactions until the background
+ * CIL commit commences and switches to a new context. While this is not a hard
+ * limit, it forces the process committing a transaction to the CIL to block and
+ * yeild the CPU, giving the CIL push work a chance to be scheduled and start
+ * work. This prevents a process running lots of transactions from overfilling
+ * the CIL because it is not yielding the CPU. We set the blocking limit at
+ * twice the background push space threshold so we keep in line with the AIL
+ * push thresholds.
+ *
+ * Note: this is not a -hard- limit as blocking is applied after the transaction
+ * is inserted into the CIL and the push has been triggered. It is largely a
+ * throttling mechanism that allows the CIL push to be scheduled and run. A hard
+ * limit will be difficult to implement without introducing global serialisation
+ * in the CIL commit fast path, and it's not at all clear that we actually need
+ * such hard limits given the ~7 years we've run without a hard limit before
+ * finding the first situation where a checkpoint size overflow actually
+ * occurred. Hence the simple throttle, and an ASSERT check to tell us that
+ * we've overrun the max size.
  */
 #define XLOG_CIL_SPACE_LIMIT(log)	\
 	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
 
+#define XLOG_CIL_BLOCKING_SPACE_LIMIT(log)	\
+	(XLOG_CIL_SPACE_LIMIT(log) * 2)
+
 /*
  * ticket grant locks, queues and accounting have their own cachlines
  * as these are quite hot and can be operated on concurrently.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ffb398c1de69..b5d4ca60145a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1011,6 +1011,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
-- 
2.35.1

