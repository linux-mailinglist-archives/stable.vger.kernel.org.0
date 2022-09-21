Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBDC5BF456
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiIUDZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIUDZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71FA31DCF;
        Tue, 20 Sep 2022 20:25:18 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLOQW6000842;
        Wed, 21 Sep 2022 03:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=HjdYsLUhhptbXZylq3RALHidshnHTq1kKRLbWl8qjSPgkLmN1vY1MrtZ9PtH7NeUpNd2
 sB7rx5xIEwK6cLjVF/K9GwWRa7UvmgSA/w41aNxBnT3db7rDZNGQcl41lj19eJ9Xt3GM
 VIRGqkzRCA/Jb8AtAQEepzR17Og5raHcXS+vaVxVDr17V6vcquE8tb3c4Z77uiiD2u3w
 4pu6LxaiqrmrsFZLXUUHCDaZPKDcycry2K/Hx/PlhxaeJwmET3AT1YoFwC5SWZjVTAL3
 R882+IqCpI+egMjfhkKM2KNjPvtqtwRoA9E5Z9jg4kGu+1RypH0lLkL/zOgkmBee5jPj Mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rgwmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L1aBtO035762;
        Wed, 21 Sep 2022 03:25:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d2yuty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdAXse7XHjmyys1yztYF7aw8/0YyqOFPuWZFn7L9Utb3bLYp35IbU4BAYMjnkHrwZnBHoc7ju0H2vr6JVG3eaUu/SyMzYnp6ToBtutdB9OZD3TXq7nLD0fTirpkDqlczO2xoCZ3qYaheCkZZXw1UuO6hioVE1Hqwh76HOF2m8N/G8Du2DWW8iHhuoQ4qq8itlm3I6lmWzGT80hqeBQJ8bIUwnnTetnnirNNVe9ml+9qdKs/tLc34sAWbVtY9I4hdNKJPWJIWQB4jd+FUnqfFntcBeGIO690s5NqsCeggSSVvC+cn1ME2pyED+ZVWvnMbU+DpJAYp0Ih32hQgwl5igQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=iJlWBVRHRQPYmxcx110plciSsLSMGlcbzF96hp0DShiZamvkyMB2gAfefAH6l5Cpt7Zww9aLjVqHsfgdMjIzRszIvSoyIndYtl6INLzfLD+4HtZGdDJmESX4cJ4/1hrwc3s5Xnjk53IGFt2TLOKVuXwpOBagj/kQSOl1NEb4HW3E+AdZKUhJDbzaX0RYr0A0ahaFi5miJADUgcvqjRXcdyWboUlIlhGBvqL15M9XSFEbrq8VIWyJ0LplmlQnyN7/easJqlccz3e8SC+XiZTJaVp0LGufhnvRqaFulcoae5vldioxf1RMmkctAYuGbid+D8DrHntVaDpvXDUUiXyaVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=m4u8Y9/5bpEabBLq4MTI52mQrZRKYS7t70WXY1t6rWw+Ozmq70KsmwFSsYW5tDWry+BKRYFmuSyt0CVrPqPpmbhY499/jcPKxjfVXUuO+vahBCsjA9y386iir7gJhzvEp0wc9GwNtKl1gt3U+uWzqwYEiJ2LFQj0sXGvnkd5f7U=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 10/17] xfs: constify the buffer pointer arguments to error functions
Date:   Wed, 21 Sep 2022 08:53:45 +0530
Message-Id: <20220921032352.307699-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0128.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6fd231-9b60-44bc-da2d-08da9b80e2fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJ16MUh7VrvGRZizV2U+dMSmgbit3sLnlt1PT/7nsmKYCD3K5+xsz00ccsCtxOb5LEeM3EU8jKBD5QAyVCL5q6+pDqSsvddBxxi8u6DgyjWCQaaDjhlE1RURz4/VrcEqgy3oCxsEbcABhyAqDO51BR1yX8uJGmb5K5bRbWl5ZOvPW4wG6nh/VSEbdprm3ylBYU/6fJ5exaA/MCE0eVH62U6DZufb6SE7K+keXppMfFdkwNy+2Osl+n7JOS+q880/1BmkUAIZuy+c+JWuOJuOGx1BgmR6ExdGGCmuxWhhJ/XBDZYsaUEfWYdfqig43orQf/RAPxqSt3PYwbaObCcUmz8Ss7OqrLikf+jFgwsQzj9Aju2z8M6X6q/5yjmjRUwwg6170gjYmMiaJFDsfkQSj2+yvxi/DnX/NA7xSx93ptwiQXB8p4DpD0C7XlNfTv+boIRVMifBsS9SfFw2w1GSS0cwRCBeaCkR4OwSN98AT8I+Z6ckG36wNr9sRjijoh1c6BYvX89OI4BidN2hEVc0F2ODHL/l6hzbLjRUo0uBmjEIuPcljqrfcSRFjJalkKnH9wQceHg2diINOzJVB3+BoXA0PGibFd8M+g0N+nSqXxt882J6eQyCMDWE/3HJYiWcmr5+nX2Nc6fyyHtj14+HbCIzf+o1674vohIf3VKphBS5VjCKknjqYN/RYK7xYhQSFwaLgf4N7n2u4WkVLATVWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iibT3rq36TUVbuLsyH7rAXaptBrxGzDzKTMdVJuZG+6b9+aiGdZY18v7oOyd?=
 =?us-ascii?Q?JbsDDp8a6Ub5wev8G4NDWdvLpUVATm2ZQg0cJiQMTt13TiynmHHa2+kLiiPK?=
 =?us-ascii?Q?7HWF4SiWX+dIUoU+DWbK9FqI+EtbuisZBJU5jEE690G21N+GSomMtQZl3tVQ?=
 =?us-ascii?Q?T+g6J8MjYA70MvEu64YlDOT35HAR0DmRf9LaL/JiCi/lQU9vi1mxRg+oM8Ai?=
 =?us-ascii?Q?zt4o0gkkFLEMAaNDCu1cmTLTyluKw1dRnCVcG36sDygsbcp2ZlzDxxNYDjhR?=
 =?us-ascii?Q?7B2SUJiN7SMAx/Z658mD8pYbI7RBDUdAMr5IVwgXADtkp/Nzc3YFjn1qM0cC?=
 =?us-ascii?Q?PGxMeIEk9QixgRtXocvai1QR+bcEKx6NUQOTE9wvpoXKbNT9UjYgdK2c2vtV?=
 =?us-ascii?Q?208/FnfXeSHhsZORTvzQyCTbl5VHwsuNPabSWgwCax53E1Un+S6wMiScJDtW?=
 =?us-ascii?Q?NuRxdWHUN06GrxYaT376VSbTcQkmUT5YfF7QE9FAHLs/63zrAfggNqHYg/UR?=
 =?us-ascii?Q?zmQVgaQGuQLdisI22jcUCYwu1CyarUyM0/K7eiuPblONFhK5XO6Fj4m2xXVy?=
 =?us-ascii?Q?MD30mJZoK62uni/Cmu/zEW5A1Hxx375Q4rdYl8se/LFFeunacBIzsGFr6ViM?=
 =?us-ascii?Q?rEjxNKcUk9kvdZTi/miftcIDQCsNpvWiq3fwWIJVLV4Ccrn7Mgypz36faUfb?=
 =?us-ascii?Q?ZqUg2hxY6p87D9ZAKXU1ltinnq2JhZJ4kfq+O0GpY7W0OEppre9s16Lb1E5c?=
 =?us-ascii?Q?FtBaoJGzHc2Bqw97A6IKENUv/pJ4y+0DeosQeyY9q527/YwA3mw/EtszrEEe?=
 =?us-ascii?Q?njhLu+gPa8FptfTwVYJkSoUAjJx/l+U1ZB5Lv+EM+k9WWb0bMtVmlBN60Bxo?=
 =?us-ascii?Q?feYZcQ6HACxYJU2TmubICsRhMTOkd1IicSOjHPUanjdqrrVOfQudFiA9XTRx?=
 =?us-ascii?Q?8od+aWHomltzZV2XgRhH5V3E1H2Et1IB4PU6F3vDJms5c1kfCI/I3MU60I6S?=
 =?us-ascii?Q?XC4h8b47+HXZIToYo23rYYBMomIT9tbHerbFnO5s4b+5AVo50ffDAQLabXiC?=
 =?us-ascii?Q?20DfteQqp04lVhHUTTNW7l17An+P1gLMPXqK19NkgwuE9DCXTLLqEpcTm16q?=
 =?us-ascii?Q?zwLcell33SnGMz4ZbmuB6L6sVUzQ40ReyKYn6mv+c/hWGcMo+CaaX0L17e3D?=
 =?us-ascii?Q?eHAjrg+43IRugw77+gCdYQ7KxnKQtkGLxkiJHHHAz8KKP6SwPwJVDkRjMo72?=
 =?us-ascii?Q?9IeA/CYfxktoz0Q7sZd17N8IfBLcJ4txLGgeyG1iKxpiVa56RJnqtNzmao9A?=
 =?us-ascii?Q?tNsh+7MdfxVm6Boo2Ph4yfqMO7hoMbKWVroXN4rWfwHzksqDwJZghlPBWP8U?=
 =?us-ascii?Q?j+N3EDPVnbsEelzXNKBOoASACd7lrdkjwOM2emHky/18ROPLVbwPfrW9e+d8?=
 =?us-ascii?Q?LLnvj8XlYKsI+tudYVRv+LGDbeJZ1OMQVRebyoqj3JWSSUnpgqzeUQ+96j0e?=
 =?us-ascii?Q?ef7DDgj7X6FF758pEcPv871D26XRe2fZh49B9RtD+Zuf1QfmWkFDZTHWHaLO?=
 =?us-ascii?Q?D95D/B/KbX7lYUokSkdOJjo2FkZI8JaQ6EpiGhGhMhzchZY3cFNc+hBN+FBR?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6fd231-9b60-44bc-da2d-08da9b80e2fc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:09.4874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hX1VDZAsIwaHjK5ja45y/UJhgjzdzR3aQZvkgzcnsqlaEqD6pvvfS0rUyTlOuRnt4AobyReI+ehE7qZLHakH1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: ifuHA-DKAtlba15SSSkOsd3VNOt9GhBN
X-Proofpoint-ORIG-GUID: ifuHA-DKAtlba15SSSkOsd3VNOt9GhBN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d243b89a611e83dc97ce7102419360677a664076 upstream.

Some of the xfs error message functions take a pointer to a buffer that
will be dumped to the system log.  The logging functions don't change
the contents, so constify all the parameters.  This enables the next
patch to ensure that we log bad metadata when we encounter it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_error.c   | 6 +++---
 fs/xfs/xfs_error.h   | 6 +++---
 fs/xfs/xfs_message.c | 2 +-
 fs/xfs/xfs_message.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..0b156cc88108 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -329,7 +329,7 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
@@ -350,7 +350,7 @@ xfs_buf_verifier_error(
 	struct xfs_buf		*bp,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
@@ -402,7 +402,7 @@ xfs_inode_verifier_error(
 	struct xfs_inode	*ip,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 602aa7d62b66..e6a22cfb542f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -12,16 +12,16 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *buf, size_t bufsize,
+			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..c57e8ad39712 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line)
 }
 
 void
-xfs_hex_dump(void *p, int length)
+xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 34447dca97d1..7f040b04b739 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -60,6 +60,6 @@ do {									\
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-extern void xfs_hex_dump(void *p, int length);
+extern void xfs_hex_dump(const void *p, int length);
 
 #endif	/* __XFS_MESSAGE_H */
-- 
2.35.1

