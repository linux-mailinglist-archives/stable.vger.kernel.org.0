Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEA25E8CE4
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiIXM7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiIXM7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:59:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0F410F70A;
        Sat, 24 Sep 2022 05:59:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OBf06i030381;
        Sat, 24 Sep 2022 12:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=VIdv8uATPvNiNzjhi6PNVDA6vYw2YxsGka4wCEozLSeA04Fjm3DWcbe84e9fEyzkliCg
 pqLwJb+ku8cYzvjBTEGXd09c7aiuxEqRiX1kZPFWPr6BkOX5qNJmJFFihPh9/UgQM6ni
 4FJkkJQKTM22zvU3O8s6euI8Mv/IJ/iilIW9zrX3uNrV4a6asYEX9Lc4o0ta0W3HW1tp
 5myucsYefpnWNq6i2Wk62dhRPRU47EYSrfknTYUqVMEGHfSHMnfej+9eiTta4RtCWauZ
 slD03FRThU/xTqDHoHQEvZMsUveiDXKgAcXuQTw0qAoSVwkJOZkvvlI7BCdep3NYQNv5 0g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssub8gjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:59:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d937002826;
        Sat, 24 Sep 2022 12:59:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s6p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:59:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8Se+KbcPYCvGFCq1RjuFDPaw7MEmJcYUFbnc8KIg5u3rkOjwjAtJlrY12AVGx1u8GVD5NFxp/A0VotyoV2Tp6Z/QtnVgSf/lA61V3fW9kWij9VU4d89wq1jGsaBM0kxl3JzLBBtdo/QDrDYg3T0BGpSwUb39rFAibzrVBVkZGYKdmBOd/1F1F3ZPomJFvGFePvLzzYZ4qRif7duRfwWe3+cpC0Ooe9s5GX+bGIqJuif2eGJWfSNnleH5+ThaJEw9DZxC4GOtMqiI1Phmux2L69JAFTMV/ol7akRB0lVU7P+zMCUYhwFAwv7tVVNP+8MC53eQRzasOUxWf84gpRi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=GFjsue3y16F0xPlbCMFuabme64FGnuZgGcvi9BvXul47eTAKkhI7Mq31Gj85HtC36A+5hdatYg/HENAw3sywXxsiTW3ipD96IOp24UbAAiHXn+9dFQvySEYSPgYW7YyGpz+8ZTtfTRcpwJUw3/tObGMIdJdRQlv7KBep8Un02z5/JfVjF9IO0xcMwEjLKurmU534IKpqhcIXPNk2KXEAxroixn+n7RKMDrIHXQXQYabRfpRK+av5wHLzYZtEGIDmwNYtCDRasss2NgqzJpzRDv7uxEfetj7eEncOREmlYUUiqzIkRzIUIDU290aLh1D2Nl4yV35oiDtBiytoAAi7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=NEHORQi1TpOqTp4MuglW3aQwvDIftOAofeL8LkqG+ebKuj4lEKBggzdFlvbJjHYaDQqUrsv4+28WAmo1eFR2naULWi+E/AF3T+4SRAOnmEUYMYYKpjkXjv0wa5iqxWV/IztjWNAr7EfBkTXkjvmY3wD8Ve2rKTQw0BoTXo7CCN4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM6PR10MB4233.namprd10.prod.outlook.com (2603:10b6:5:213::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sat, 24 Sep
 2022 12:59:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:59:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 17/19] xfs: don't commit sunit/swidth updates to disk if that would cause repair failures
Date:   Sat, 24 Sep 2022 18:26:54 +0530
Message-Id: <20220924125656.101069-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0012.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM6PR10MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: 66a97367-8d46-4e67-b346-08da9e2c8ecc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmQu7l8ynXO2y1Q3MrChVlLwXwoSWjjA6SkMLq8sCDP4f28RY+TrFytRjGFtpFQYh2jsL8TRh2i2Sd6beuAXv8Z9Her5mHDAlJ2El7TL9I79cfBK4kxFC8rDQxHctjucvwZJmIeUsrtp9TKiOjBOPcnFAQpl4amdBYOG+ipCOLpa4JcPvU0O20Sh34LUi7I+28XI4Pr6nC2G7ncReWyr6xcgT9ww9UvzwWZ23arvcE4KNHoJgMRk9LFmdvWFxZFirwVbb3OQCphYui2iF16S19EUcg5/6wMhbHFLnVjcsPUV98ou1WJ3UpEjpVuHihzEegcU4mEiN1u/jwsuSipxzxZzNjfknAWfZ3bQeulQiXbeIiKVgHz2YyDptINqNd9+/YA+1RKmmYj1hH3/u7p0hs0MucM0RPhC/hCDKWVl1ZivA4Vg5AY0U5Wt5YXnqpisBV9QWNzWkF/khZhDylXpgePLxx2b/3hgCWCk1EVeWCcuTgbM5067Ovb2U6LC3fvkjpyXhfO8SNnj39Vt0YsNVzdzszFayXwa1ZY+nG0DYq/tVBLNj33McqnAK0M95Fg1+U+mriHc1rLafGFLnS35D2G5j7q+XL57CWRgyWjDm6Tg1XHAHbaTaloq4uBE0WiJ4Wg0FB+d9/ami28GAWzHKvAZn4A1Mb2gbbu0DyZHBwor9/qCD697Y3pBJ3YmnEirgHtYozdN0pM+x2npO1ndFxXzQTpYkWwZavDEqruXtt0cXIJAo6vH/y8RG9AwvuJyWS9dGXb9N+4ZMEcDOKLh7fAMg1zwyVEhFKsZdn9kJlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(2906002)(15650500001)(38100700002)(5660300002)(316002)(66556008)(6512007)(26005)(66476007)(2616005)(66946007)(478600001)(966005)(6486002)(6666004)(6916009)(6506007)(8936002)(1076003)(4326008)(8676002)(186003)(41300700001)(83380400001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOFc51lLY4QiN62suVEbJYoni7HJLTdZuw1TYIGe3F+vvMQ/GrDOsi/u5DlO?=
 =?us-ascii?Q?63W5nRhvFbHbkAfHDvt2g3rNtWyaa6TQk4QLjGfjDyIVZWq9yE0HDhn21vFP?=
 =?us-ascii?Q?IvBFrZ80ubmaPC6RjR9AQ6bOyfPQlFy2WxPJxT4KVOetpTK6DnvaS6PeHLa9?=
 =?us-ascii?Q?G3vWcdrXjYTJ0uhXAO1lwMOD0SsgehWNCf3I3dU4CbW04E2xtJ7YG+BNjez0?=
 =?us-ascii?Q?nssPtwvoJ8ig0VfRo0M0PhBpq5Z6WW/ECPv+XHyqGoNnvkt51lunHt1N1E3b?=
 =?us-ascii?Q?BEOocFyrozeah9sYVeo1ztjs9H3QuRdynnLD0WdWaAbBoAb0l0LTbxreQp2S?=
 =?us-ascii?Q?q+2wX3XV7e2F0/gMZex7gul7IClLs6MG21C06zcnG/BjhHnH/tmLE6aQh2oq?=
 =?us-ascii?Q?9Pj9Th1EEfEQwdUgDnBjmlob4TPifxdOQGnn8zCJyfiAQ4q38QRxUpZSJMY5?=
 =?us-ascii?Q?eJmovqNGxD9CiOlFMwQsoBX4eTV7ZapfVhL2LuSGaxMjhdcmRJcZC5sSBqQI?=
 =?us-ascii?Q?t6YdN4Dkv8wiDIu1Pzxxzx10rpbXPUsImyL2RULDP+u6jlinhm97Nit4B4yD?=
 =?us-ascii?Q?tY8oqlwv+CTx2U5G6xdXfFhvV/b8ilyDHjrMdhrxl3qhMzYHxSWMCUR/obxW?=
 =?us-ascii?Q?6jAc5WFGSvSHIgfzxSjqZgSDSZj94i8l+t7EggmjLElB8Ay0oUqAdCSC25Kk?=
 =?us-ascii?Q?xNfDxAGPL6kUAOLsPBtbE12KoG3jQfLtm4Hrb9XIXnRjYcULOmm9Xnbb9awz?=
 =?us-ascii?Q?W1ekzxLi3/yfbGn9DG73a+WWxTD3dOn5GrL8z0NxcuPZex3Ky5gxNtZt6PG/?=
 =?us-ascii?Q?bzpBRi5O7Arokgs0QoZYPH260e4/ki8k47+YeWcpx2ucYuywA2g1ZkJA+qJi?=
 =?us-ascii?Q?t8B1y4S+ahmM2XISMDlLB0RyQXQcunaHjn7Fc1a+a9vI3LA8ayE9fqTyMSgX?=
 =?us-ascii?Q?6Lo84A5QsFbCBRG2XygK3DEsnEgIf7KuHgi1AarGDv5+87auupNqLesphAZD?=
 =?us-ascii?Q?VQ8SYic9wLaTLd+Qy+MAooU41U7+WY+kh9GdkzdEQF8t9FX37qZH27G8WD2O?=
 =?us-ascii?Q?QWnFRoRfcbZjA2nBH+C2A5Mrb6CPtU0rgigd1w51xnQo7KyOSpCs9z4ovFF8?=
 =?us-ascii?Q?7GTZ5d2txUFkYt3K6Z3Q8ZjGBuw7xu79Rjd4nuz6wl3DPp0w+tSir5ABw11T?=
 =?us-ascii?Q?1f5LH94a7zmFnK/CA845CfH7afGFUJLSH59SPkWop1hNaigYe5aFc4Ufbk8b?=
 =?us-ascii?Q?o33JJF/kQI9prHD9pDhYqqbLRtN3I9qeLH17uoSgPUpP72Hvl2HSQonnnjTc?=
 =?us-ascii?Q?JraEDkjNB72WJnswn176S3PK98Dy4QcD9w5RKOjHt5J7A8oyMjmhT3qSOXAt?=
 =?us-ascii?Q?jllNi6o2CdTsdODeYFuyqD9bTI/gp1s0Mb1A/33PkYVRtt5Jgea4EEPveqdM?=
 =?us-ascii?Q?+HS33bbsICSEsvnUd1svJ1RYB8UJjqs5CjJSs8G76/Vxv7AVWLu6ahz/I3c2?=
 =?us-ascii?Q?gZNarylLFF8ZrukyNH5uWzzxzvucK9HNrTeo+7y4CD1K8EiBxSjzHA4vMZeO?=
 =?us-ascii?Q?Vu4mgJVUFtpfipcWKG07xMeuLhHlNFoPxksn/pHf4yic390/ebKhGKXbkrOv?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a97367-8d46-4e67-b346-08da9e2c8ecc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:59:03.8812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kToawyivSqU759OvNQ3XRt4gWw2rlyFzs6G/GxDREd82nsfrO9CDvJq/K+J8WkuuepTSnfLWM+A33bU8zvMP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4233
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240098
X-Proofpoint-GUID: kXVSLweceOTM5SuuYSJt52FYyeeqO_Zh
X-Proofpoint-ORIG-GUID: kXVSLweceOTM5SuuYSJt52FYyeeqO_Zh
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

commit 13eaec4b2adf2657b8167b67e27c97cc7314d923 upstream.

Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
and swidth values could cause xfs_repair to fail loudly.  The problem
here is that repair calculates the where mkfs should have allocated the
root inode, based on the superblock geometry.  The allocation decisions
depend on sunit, which means that we really can't go updating sunit if
it would lead to a subsequent repair failure on an otherwise correct
filesystem.

Port from xfs_repair some code that computes the location of the root
inode and teach mount to skip the ondisk update if it would cause
problems for repair.  Along the way we'll update the documentation,
provide a function for computing the minimum AGFL size instead of
open-coding it, and cut down some indenting in the mount code.

Note that we allow the mount to proceed (and new allocations will
reflect this new geometry) because we've never screened this kind of
thing before.  We'll have to wait for a new future incompat feature to
enforce correct behavior, alas.

Note that the geometry reporting always uses the superblock values, not
the incore ones, so that is what xfs_info and xfs_growfs will report.

[1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d

Reported-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 64 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  1 +
 fs/xfs/xfs_mount.c         | 45 ++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h         | 21 +++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 443cf33f6666..c3e0c2f61be4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2854,3 +2854,67 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/* Compute the location of the root directory inode that is laid out by mkfs. */
+xfs_ino_t
+xfs_ialloc_calc_rootino(
+	struct xfs_mount	*mp,
+	int			sunit)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agblock_t		first_bno;
+
+	/*
+	 * Pre-calculate the geometry of AG 0.  We know what it looks like
+	 * because libxfs knows how to create allocation groups now.
+	 *
+	 * first_bno is the first block in which mkfs could possibly have
+	 * allocated the root directory inode, once we factor in the metadata
+	 * that mkfs formats before it.  Namely, the four AG headers...
+	 */
+	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+
+	/* ...the two free space btree roots... */
+	first_bno += 2;
+
+	/* ...the inode btree root... */
+	first_bno += 1;
+
+	/* ...the initial AGFL... */
+	first_bno += xfs_alloc_min_freelist(mp, NULL);
+
+	/* ...the free inode btree root... */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reverse mapping btree root... */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reference count btree... */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		first_bno++;
+
+	/*
+	 * ...and the log, if it is allocated in the first allocation group.
+	 *
+	 * This can happen with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
+		 first_bno += mp->m_sb.sb_logblocks;
+
+	/*
+	 * Now round first_bno up to whatever allocation alignment is given
+	 * by the filesystem or was passed in.
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
+		first_bno = roundup(first_bno, sunit);
+	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+			mp->m_sb.sb_inoalignmt > 1)
+		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
+
+	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..72b3468b97b1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5c2539e13a0b..bbcf48a625b2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -31,7 +31,7 @@
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
 #include "xfs_health.h"
-
+#include "xfs_trace.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -364,6 +364,42 @@ xfs_readsb(
 	return error;
 }
 
+/*
+ * If the sunit/swidth change would move the precomputed root inode value, we
+ * must reject the ondisk change because repair will stumble over that.
+ * However, we allow the mount to proceed because we never rejected this
+ * combination before.  Returns true to update the sb, false otherwise.
+ */
+static inline int
+xfs_check_new_dalign(
+	struct xfs_mount	*mp,
+	int			new_dalign,
+	bool			*update_sb)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_ino_t		calc_ino;
+
+	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
+	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
+
+	if (sbp->sb_rootino == calc_ino) {
+		*update_sb = true;
+		return 0;
+	}
+
+	xfs_warn(mp,
+"Cannot change stripe alignment; would require moving root inode.");
+
+	/*
+	 * XXX: Next time we add a new incompat feature, this should start
+	 * returning -EINVAL to fail the mount.  Until then, spit out a warning
+	 * that we're ignoring the administrator's instructions.
+	 */
+	xfs_warn(mp, "Skipping superblock stripe alignment update.");
+	*update_sb = false;
+	return 0;
+}
+
 /*
  * If we were provided with new sunit/swidth values as mount options, make sure
  * that they pass basic alignment and superblock feature checks, and convert
@@ -424,10 +460,17 @@ xfs_update_alignment(
 	struct xfs_sb		*sbp = &mp->m_sb;
 
 	if (mp->m_dalign) {
+		bool		update_sb;
+		int		error;
+
 		if (sbp->sb_unit == mp->m_dalign &&
 		    sbp->sb_width == mp->m_swidth)
 			return 0;
 
+		error = xfs_check_new_dalign(mp, mp->m_dalign, &update_sb);
+		if (error || !update_sb)
+			return error;
+
 		sbp->sb_unit = mp->m_dalign;
 		sbp->sb_width = mp->m_swidth;
 		mp->m_update_sb = true;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275ed430..ffb398c1de69 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3609,6 +3609,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
+TRACE_EVENT(xfs_check_new_dalign,
+	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
+	TP_ARGS(mp, new_dalign, calc_rootino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, new_dalign)
+		__field(xfs_ino_t, sb_rootino)
+		__field(xfs_ino_t, calc_rootino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->new_dalign = new_dalign;
+		__entry->sb_rootino = mp->m_sb.sb_rootino;
+		__entry->calc_rootino = calc_rootino;
+	),
+	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->new_dalign, __entry->sb_rootino,
+		  __entry->calc_rootino)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.35.1

