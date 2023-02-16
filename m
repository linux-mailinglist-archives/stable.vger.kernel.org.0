Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C459698BD1
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjBPFYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjBPFXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:23:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA22B4C6C7;
        Wed, 15 Feb 2023 21:22:36 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2InVE031808;
        Thu, 16 Feb 2023 05:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CDzIi6h3WbmYGSyUYBH5xk7tSJ1ttrBJg1EKOIlZsf8=;
 b=L2Fqoi2mgxttQpzJc06mis8otZ4Qk/PI4H38lfwxJkFoq3cLE55zDiCrdwgmLYKoIcqy
 zubfhZct6z6tFLTa48bO3t/qxjXhbnPKCuiQp/H9xS9s+49Qj6VUBcPZtheps4+CUAfw
 xNYmj01lRO3cSpd87eiuvMVtzQf8HbumZllKY1x1l2BMKFio1kWRkiKYbSviQNZMRA7Q
 IT3VmmaHIU0LvtTjFF4jGErsnp7L5ZUmmsFPiXR20dAi8/m8OW/CvM5IVGBSRIFvMhYf
 uABV3uZhP9z4dBeYeqTiy4Vz1q9AQmvfdjalc5t1Hq665QiRyshJgjt5Ub+94pygKIBm CA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2mtj6kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G3DxIU015121;
        Thu, 16 Feb 2023 05:21:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84abh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsuGBXzN7PnXibhqVI/0GjXVLTfwmIQdF+AVGM/UPctnNphIVc5gaXO90kmd6ZVl4CihKDt0pcvjPqt0ghs5XL/ab5q7Od9FYlPrAdIaUtFfaQoRI/C7pB9dqVx+Atro63MtfNSeTgHvsWmkUhQG/LNAoFSfbtaxtBjkeKESFQloia8jeib2qMG9qefjvuU/dzhlumAn/eytRbMPp1rbWedeaLjhgE/AXFJAZNv7E6zPJ6BZaN61xdcgcB3sFn1tBPlQuy2hdRVK/2K+4ddY+gKI8RWC8EECKzx/RqnZRjhFSmtD+AicJ7xZSIRe8FJJyGPKatl1teFUUwtDXLRQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDzIi6h3WbmYGSyUYBH5xk7tSJ1ttrBJg1EKOIlZsf8=;
 b=DdyexUkSToGUQovuTt/4G9e8w94rOgv8SeStfdUiQao1nGKd6GShm/VO+HrMgSvI+fUHetIg7TkcJURq7YTdGyPq+ag3Mzu5HEdOBZoqx6Vs8QNFy2+rKlqNTzmE89PljVt2e3ibXUD4A/DMVmSdC9vg19uQ0G7uYKqmKqnot3THC6IbDyKtsVR/9DsfAw5EutrUkLxw8t5X+urkxlrEiHAzZoh12PEgRwcbMiNHTgm3Hzy+BxNQaEQZ0DW3cziEcQg+7+FDxZjziOwlJyo5p71wIJSXP1D+Thufkt8ICB16wESonCCK744xB2l4UZwI05TlBmCiUf/5AXpB61sBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDzIi6h3WbmYGSyUYBH5xk7tSJ1ttrBJg1EKOIlZsf8=;
 b=gEkiMBm70ZJo8ciBr66TyKNiB8nCXTE6W8N5Ou42s9hIA8hgaWigL34WFl9/MiJpacuRoF++1/dosGjlOZC+Nppsr5G4Q1i2cuKpuc/l4FU0jm/RQVxNLg+Nu8ljV+VmQGPLthNTizuk2sFXC0frj+xb8OlWG7c48s3oWBiR2eo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:16 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 07/25] xfs: turn dfp_intent into a xfs_log_item
Date:   Thu, 16 Feb 2023 10:50:01 +0530
Message-Id: <20230216052019.368896-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0128.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: f4fe2fa7-753f-4d0b-6088-08db0fdda08f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQRML/Y34GWxWj65VJlTZ4v27NoLE+ZFLdY2fPcncNtbB8g809sk4Vv/2CTBkvs8p5hb9D9CFCF0vBKapy9tk2y0vvCv99IYY5K2pcoxhngGUMU7lQv6k4lLfGxGcHoUH8wTE3TGywkg7eGVAPDaCunIeRuZF6kFQHcda7TlTtB+rWtlgegGR+1Mnz/xBVVai/rGGY34Zk0v8BzCZRPrUfGXp/ly3FWfZpFtU6sINegqKaZW4G9oW0EGQ9uVO6/FMazZQAZFnR/W+J0R5ZonQ18Vb1omY7ECMT5Vuv2fH7D3EAX1cfjRvkI2VMb3XEnGidh1fl4CC3PxxDsly8Zw345LGVxBbpGvMgL5uOl7Ekm1axqMB+KjOgqBM3qGe+QgwSve86zac3c0ZtT7hob3LMIIYfo9cBy1Q0URVtnt58+hU1i0KP+nKliHH90N1Fheag1fPAEl7tQVY3M5FjGmM6YQhBu78uQXB1pk36imzKRlKScb4I54iCPb2EpQag6u0r5CBKJJr5ybZml/QynPa/vINWWrMSWNsBJuE5FdpezDDNmkufcBjQLr/3OHtFmzmtYHzTPaIG/n1yzVI2BcyiuRl2hIUF0Lh0Gh4vPC9VqJoNdQA3CVLUCsoO8LsyPGWMskCdp+PoTFxjiQQzw9Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cp/OpUaQov7avCARlBCDCCiRJS225pzqyV3Vebd1e88gMyCdewJWij0gNk1H?=
 =?us-ascii?Q?QHJPbl7WXw8/ZituNitJFxL2xtuXdihMH22iUJM1j2uULyoHtaLZqXI9Mhc5?=
 =?us-ascii?Q?rw2JOGbI80DWnism7J2fuIvFfa2ULRofnry4SYMIhyoirs9BGcnnncgvwR0C?=
 =?us-ascii?Q?AI4Uv+Di/iC/HQtjIrALvPmrLScT6WxEATNezTUGR9DlhTyN3wZlL9Ic9b/w?=
 =?us-ascii?Q?idDgtflJTVosupBpKu5YzPfEiyvbc39HzQw90s8FMD88imCYBCoWwF4rjUQi?=
 =?us-ascii?Q?kGVtLSROV1xPmgSPEJ9thKXqPEJFfE6S3h4J6enJtV+qXUN4p2itNBxovuwe?=
 =?us-ascii?Q?xw8ubHDWnthw5eo3JCVVF4o9DKSgijNo52BNCHU6o18wcoNqZys67z3zrEux?=
 =?us-ascii?Q?cuFs/0hRHmRKINmqt/Hu7QRoHrLU1J9BQwiAnyy3tLKvVoAXjhG/NfhZNxt6?=
 =?us-ascii?Q?1bUg3Qhbipux7uenq1u00pfDKBDL+Opj37jzoUZ97fsUSeLrVJYc1QLTxWVo?=
 =?us-ascii?Q?wlD+AFvIUMLaf1dkm+UXVRNzxEuwMRuqNyxi5EVnCjOv3paE7b4cb7NdwkTW?=
 =?us-ascii?Q?QYf5F07kPxIg+DRy5kVIMfEu7mGj40zNd5Jq6isXccwyMEBFRLyOAMyEEWzz?=
 =?us-ascii?Q?aShs/0Jarcu+FngxlwuhyrCraqED7r9hL+hgT7dgjWNplE1U6/+vfMED+iRE?=
 =?us-ascii?Q?O4RXwpM6MA5dbIMizLDeQdtRLT4VPvCMj1a+LCKBVbYHiwXci47DU3dkj5ml?=
 =?us-ascii?Q?2dIx9qZnEYy0eBicwhhvp4oKzeiH5+963T5FDnnGy2nJZ8pkDJi5uANgSU9f?=
 =?us-ascii?Q?HlxuKcRqhYgbJCEDqXv28uMjUYJVvE6+ZCoZJxt5GY5g/jCSOnFf+Z//ycNv?=
 =?us-ascii?Q?5s+3O2lQOolknqN7pLsgcFOhUm/bnlq0JovYrdfkuibIU3zu4LDz29WEOnOc?=
 =?us-ascii?Q?aTFBFuZGQKB7SVPo3qP6JCwefhZ7pOkALcf0D7QOk8srskXa62xVxhgIdjQx?=
 =?us-ascii?Q?/cRhfoBXfMW3yeJqQmG4eqtmC6F6JSEY7csz6XSui5evHS83BZe1KOCL60QZ?=
 =?us-ascii?Q?lBIFqPVqoYIlIqBlg4pjJSHUjB8z9eSrlr6E84l7RJtXkv5sgpaZ2HuJ7jvv?=
 =?us-ascii?Q?KtZm24ZUknVWaIpmN1MGMsdRZqxWn3L0GLU9+rjglgsFA3W/agxmaKVbEzXH?=
 =?us-ascii?Q?+jDf5WQl/5yIvepskK+rinhdaqAq1PLkuOfIVYvm83XW9YXGg/xlV+Fs25KE?=
 =?us-ascii?Q?P6pY0oDyPwPQGw0ILPPQCjDYhlOX3Ux1/9iIfrtRNbsoajgsYTYxepgYch7Q?=
 =?us-ascii?Q?kuGL1SMc10k4GYoEx0/xQbmQ9ODN5c1hxjbQtR522kjcaaggNyOo+ynJZsgn?=
 =?us-ascii?Q?z77HfjKmltbgMcbxWB5Xo1nl1g+8z+tahow70EvcRQpX83Z/bXm0UCbcThTw?=
 =?us-ascii?Q?FL02xl0b2Vz5NxHrb1keGhj0v59G/AYfyS2T1lgVQQFDttZuRmP4ximW6x0a?=
 =?us-ascii?Q?HF/+QeQA17hFbKNQRVMW9qSt5GAln6JW9fnfyPoY/LMFiv+UwJNVGE/Ivs1i?=
 =?us-ascii?Q?af6msgwFBSeDolliK5miggw04kQMKBSMtvUk0n6vvqGYQISBIPhx7IzFeO9i?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gFswVU3nTmh5viE2G+hRPT0nj4UiF2EpjwczArTqba+AZnzDcadmmGAXdGEZcrZ97ljz36O9edFsyLTG8vlrTuAcig/QXWlgXF3bo1hz2N+pLMp+dZxP3Ki50OjkcHi8DTbTS7taa/fH9TU+gZrXUuvz0IYm4Z5FI9vosJUTKSqL0qToNuZUmUhS2Oeu93Z+6Y0q1OqWQYP0wFQSyGCqkeNvVbNehSu40DGeRBGHkjrOefE46cZHF8NSc4e9Ria1t9TWWoIBUuJb6Ky+Opkv36TTm6h3x+UB+mnmLaPD8uAV0oGTKc84UcAF1xVyjmg9IzVJR4SwwjD0gV++igR0Y6itCQKl8Vmo0BlqrN0fYsvnDjNLVeK+4geNOh/wZtt2MZ5NcNFoLtWXvZHyZnMyV8ZBXVvKsFThdLHe+cnlFpt+dfUuol0MunxY6WJFwAbbk/spVP7HfXniFCB/y/vY8sVNERCpRHs1Oe1V6cKYBxNeqICS1cWTPWTQZHs109ZSMKWti0fEv2r6yNQlRg6CCAdvnLsFv0FAjT6kQzo6EUtLgj7ySXjwzPFQcySk0V4OTiMejAeGh4Lw5p7cSkGLCYAmThwFVMkfL30o/vfagjVUsSrIpKypmUZmZyu0GDOOnYgHKsKwEiYqdJ02Hjr0uBkYrnZlCcbNhhQFMuuDdOLDQiBQpVju1XvC+5wVigPhejdQp1O2Ut5m63IL26/sb+7ftqhi5qmN20Jgvesqdn9nGqd26XAZ9KOIJX1nsXNxPIv4KQDClQABB59EYe0NgJill8UkCb69d/WfYoAbrkpNXcO5FaNaihfOMerRbkWRlPAJ4SfCcv8hKwkkfSN/JOJWWIhPGG8T2qAxyy1T50frYzdnd+6pgs9YFx1km2Mr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4fe2fa7-753f-4d0b-6088-08db0fdda08f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:15.9934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDGQamT9jhNr2lIdiq6ugX03qJF2B4PoERYplF/6ZOhGhyLg1r9MvbVDfe5Dy4N8snsnIDlbzAwxaU0X49nrkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: 1mOlTHlQAXvQ9Zjngl1ZSI1rHtqtxX4V
X-Proofpoint-ORIG-GUID: 1mOlTHlQAXvQ9Zjngl1ZSI1rHtqtxX4V
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 13a8333339072b8654c1d2c75550ee9f41ee15de upstream.

All defer op instance place their own extension of the log item into
the dfp_intent field.  Replace that with a xfs_log_item to improve type
safety and make the code easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.h  | 11 ++++++-----
 fs/xfs/xfs_bmap_item.c     | 12 ++++++------
 fs/xfs/xfs_extfree_item.c  | 12 ++++++------
 fs/xfs/xfs_refcount_item.c | 12 ++++++------
 fs/xfs/xfs_rmap_item.c     | 12 ++++++------
 5 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 660f5c3821d6..7b6cc3808a91 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -28,7 +28,7 @@ enum xfs_defer_ops_type {
 struct xfs_defer_pending {
 	struct list_head		dfp_list;	/* pending items */
 	struct list_head		dfp_work;	/* work items */
-	void				*dfp_intent;	/* log intent item */
+	struct xfs_log_item		*dfp_intent;	/* log intent item */
 	void				*dfp_done;	/* log done item */
 	unsigned int			dfp_count;	/* # extent items */
 	enum xfs_defer_ops_type		dfp_type;
@@ -43,14 +43,15 @@ void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
-	void (*abort_intent)(void *);
-	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
+	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
+			struct list_head *items, unsigned int count, bool sort);
+	void (*abort_intent)(struct xfs_log_item *intent);
+	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
+			unsigned int count);
 	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f1d1fee01198..f4d5c5d661ea 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -330,7 +330,7 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -348,17 +348,17 @@ xfs_bmap_update_create_intent(
 		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
-	return buip;
+	return &buip->bui_item;
 }
 
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_bud(tp, intent);
+	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -394,9 +394,9 @@ xfs_bmap_update_finish_item(
 /* Abort all pending BUIs. */
 STATIC void
 xfs_bmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_bui_release(intent);
+	xfs_bui_release(BUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6667344eda9d..a9316fdb3bb4 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -437,7 +437,7 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -455,17 +455,17 @@ xfs_extent_free_create_intent(
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
-	return efip;
+	return &efip->efi_item;
 }
 
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_efd(tp, intent, count);
+	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 }
 
 /* Process a free extent. */
@@ -491,9 +491,9 @@ xfs_extent_free_finish_item(
 /* Abort all pending EFIs. */
 STATIC void
 xfs_extent_free_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_efi_release(intent);
+	xfs_efi_release(EFI_ITEM(intent));
 }
 
 /* Cancel a free extent. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2941b9379843..a8d6864d58e6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -329,7 +329,7 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -347,17 +347,17 @@ xfs_refcount_update_create_intent(
 		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
-	return cuip;
+	return &cuip->cui_item;
 }
 
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_cud(tp, intent);
+	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
 }
 
 /* Process a deferred refcount update. */
@@ -407,9 +407,9 @@ xfs_refcount_update_finish_cleanup(
 /* Abort all pending CUIs. */
 STATIC void
 xfs_refcount_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_cui_release(intent);
+	xfs_cui_release(CUI_ITEM(intent));
 }
 
 /* Cancel a deferred refcount update. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2867bb6d17be..70d58557d779 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -381,7 +381,7 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -399,17 +399,17 @@ xfs_rmap_update_create_intent(
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
-	return ruip;
+	return &ruip->rui_item;
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_rud(tp, intent);
+	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -451,9 +451,9 @@ xfs_rmap_update_finish_cleanup(
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item	*intent)
 {
-	xfs_rui_release(intent);
+	xfs_rui_release(RUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
-- 
2.35.1

