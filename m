Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE65BF466
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIUD0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiIUD0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:26:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1926F7E802;
        Tue, 20 Sep 2022 20:26:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28L3P0dE019186;
        Wed, 21 Sep 2022 03:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=PKempKwVuHYKw+6hm0LU34inmRXwWpBcYCfrrS/yNOofoUtX33Vk3A8GZXIF+i3vkojj
 +jFdJcIygDfWl/RCJR3iTjUnOyBpbjIy8f69kUcrcEWW55ocyHyK7cR208oPjzipF4oC
 EkwaY4Zn5wsAF07AeBgWXbMy6lxw1bt1uTS63ari4cQ8g9KZiJt0oZlDS83OB5Ed0il3
 WufBCPVrwYUzmlUYB0X419hOPGzJCHKU4fIl04sDaeHXskMEjDwilJwQZCQAzpxQsTmE
 tpfUTUDeqxTL4Yfq/TlAx8DP31L73rxEarg+DCIYQ0Ii7yYCoPLETpn7oM8XPN6Ltl0H Tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6sth4sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:26:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2OsHp025522;
        Wed, 21 Sep 2022 03:25:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39ee9yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUUzwk1YLSu+S066a3IMoOs2wHEMdFTmQ/BALCOGiopn2Ye6ovpLZOXLy2A3chtxQxxOG37xo91NOfSfMo6qsfBXYMeLlghSjNE73YxAoL2ZJgzPNC+dO8wsLWxLCQDRN57PGuQdjj1hVAOUdLbT84WQxJXS/ESYq1kVUYtXCEF1yAeONFDLDCFO02rpLQDcgjbqrFL9qba6cR5DiUandIuyw7rxvhCWuV2EFGwjFy1kO7qUlpxyhWXADUrpjEXwKLZI/3Ul8r8LZQX9B5TC2+MmIwk1hBbkgSYXtRXeQ802KlK/kUgxyE7j1AKFkr952X32I1zBjZ0DipoBAkGQiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=OF3H+rhKI3dUpIfuxV9H4z7kgiPObN83j3X8kxjsr0OCC5sDAa/DZc9Ad4pgK7Yp6JP3BvLT/FWNA+2pYevLBhctgCuqwZK67xZEa/atu+BW92neE2v9SkjdY/e1P/rxVZNIpL0x9ZUVfIzCYTmvYuEOD+jKkYrq/FwCMm9qkh+ai7/qKs8lYcQ4K/qAjVXy74ESEIYyJ0f//59IE/m9hR2KuwxFeh5qzv5+otkwGyVsQ+PGVNRuW4mzxVXBvTQoVzDhRTYsKwEQUbtXyGx4Ky+N+7zYIMXm/E/2fiw3smqrNx+9mB7Pj2Xj5flb+aLM5AOEZoCeBezDg/qdMrZu0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=VZb6xwSJOyRQNHjefdzQf286uGYFuz7fQf7x7CKT6Agh67miiHDiKxus+PyEolPMgxOxbApIrfEkC3yX+oHVRzNlQ6sZ/tyavG+ZcdbO1sCIREQfOHnj9wRm6YYmoQRZn90L8Jsd1HRaPAChveOpiqL1EqFVVY5OeUPyXkgJeJQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 17/17] xfs: don't commit sunit/swidth updates to disk if that would cause repair failures
Date:   Wed, 21 Sep 2022 08:53:52 +0530
Message-Id: <20220921032352.307699-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0108.apcprd02.prod.outlook.com
 (2603:1096:4:92::24) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: d82e0b24-8518-4136-afe7-08da9b80ffa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CPj8rMI0UM7wv19xmbEd+Q2MmpPWGVdg+/E1QJHVFOhpKoYdnvS9ehYzSlwJC4FyUyxz1mqEw11mFjfYTkZsTd8dSfDFR47rumadzdHNmPf/CsaPuRLm3hFGxx8jij+0oWhh7J06zzB6qUb7L06lxwmfTZ/lETDtD6F6d2AA8G33GkbCDI6ZwvYb1aAJJIC+CgYnKB7PDmrMkgiOKboy4iXB01/vebQItsedpazzhhEfD+UB9ttB3LxR/LnbxTEY3kwG9+Nkw53fL5mZmKU99n2WFvSBO8dyJ5LUNvsJgPPb1vpgJMTZ0jHfNkb092mo4jdI1aSRJbg/eUyC0UDrF5D9+IpkAd56SKkiOnFviyg9VZJPuKJyry2QqEHr+hVMvE0Tx5EEeAaMOiYcD3XzTPMxWIfAqT40SpqxWyKe5xxzCFh8kJeqfEMU4vj9FYcZQjQPQVhDj1N4YryW0HeNuA/efqO+3sArCHsTH2sTVMejL5KMqBX/sYEP+eKApf+nKeDYggjwMPCRGDuPhRCO/kr9k/GuK0aCNdv2FK4D1ZflUR5ZB6A43t5rQl9VS5lhsO/eMikEM2qNXEtql9pWMcqg4pUB/1NwgWGrC5JnUA0ygqU+0/pSZBHi8A5PcPI5481Hh+5e79gHkTcl6XxlNpaQuoQnfcdDL0xCQL26vzcrDVBqGdf4PBXydiOtVJDFlzTdzQgVHAzO/AylJRYfaK4I+VbdTLEHFyUyuOTnDTAC3AlIgUNCwllhXmhs9Q8qOzB5zfKINsHvrZDQ6RhEm3gj+Ezn8oEmkz7chyQpLI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(15650500001)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003)(966005)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sV5ghd6VggxmFQZwqUjEzdoILGg+z2penkLa8oBe7bZuEaYTogToXvft8Gez?=
 =?us-ascii?Q?YxwUKgVx94E8XsyQI/yeytTj6lSIA1PqJ5cVKJMKvK5QIH6rrKPNbiLSfPh6?=
 =?us-ascii?Q?M+6PHLFcgm945m0x8McXV1Y/7HFnU5+Mw6ygVTtWEVZoauqB8qpidkLr5dW5?=
 =?us-ascii?Q?/Zc3XldhnaSH5SbsKIglLO7wdjsy6rnRm1CdXEGQxwE5JVF3EkVerId+iw7x?=
 =?us-ascii?Q?tBf50L/fGE8PDzByBy2Leho/PMCVxDWZd6+4OU7/DuOr2/Nlpz38vI9SdSX1?=
 =?us-ascii?Q?fSDMTca8e9VUcrOK4gmCEcGCg7A2g8Ou4vk/ixP26S9f/PIq/qak2kFwTICw?=
 =?us-ascii?Q?/by4IzTTGdbfnnvPVt+ULdtsKUafWvRwjnhx71gmDcFxFLJN9x5zDZUVqIcE?=
 =?us-ascii?Q?06IQXozPZJQOMn2TdyAaNfCSLIP02HkaSZciyvc2FINMWSRWAxEN5QclgCSz?=
 =?us-ascii?Q?7tXmAjowdh4zObax4cyuV5s8zAQadzL2qw2/HwEXXR2EpAtgb+XPOLYJliSm?=
 =?us-ascii?Q?e2hbj8NMILsWiZ0Z8JDjaoUnoky8HAhwUBwUH/+olulVk0oZvd1Anm+gz8CG?=
 =?us-ascii?Q?IDlEpyhpQJl+UAH/rx6bjfhgODwSPCZlI0W4994oz/S/kq+eUm5uWmjyrG7N?=
 =?us-ascii?Q?8K440hRuU3Dm+PFKGpTuDJebFaoNTzwpFVEhKHOlHbd3n4aER8pPexuFBJFE?=
 =?us-ascii?Q?6mzlleVtJBvDPj+cNGIWiW5RspvjOENiD2FwFG0Q+j8B5A8Mj66eQlASVZ/b?=
 =?us-ascii?Q?qTB8W+vHDSP1XmKT0L0LfVzBbu/GXhvVP6xgzHgqOPd2o1F/y3MCUCeLNx8v?=
 =?us-ascii?Q?ulAnj39mx/5+vnEGNy3nHMvlo0kbMYqzCzqebTSGZ8KDG0fxZSpbDN2geFox?=
 =?us-ascii?Q?xI5fFo9cv+P+beBtKuNmeAy/j4Qh2fHwwwp+dE12kNk9JAArYDsy+NSA8NId?=
 =?us-ascii?Q?S7BLSEYvr7QQ4fCWFvh1Fm0HNB/HQQlkdOWF0YDvtB1BOdkC3Due6vQDXICk?=
 =?us-ascii?Q?dSMkgw6/7VRVZhRdXv9xpyguMvK/sWLcF3UbseechOJabYhmoV1VCvbDX2+Y?=
 =?us-ascii?Q?XWposEtzH2mATl57P8yBjoY5rYNpARZsuuQ1/aCiXjWJPXhdJEOw+ngJ6/aS?=
 =?us-ascii?Q?BNBxken4Zy08oCvQxI1KgAw27zP9HDO6i1V8nLjD7Gcx7Age81JMzx2ha9gI?=
 =?us-ascii?Q?WJIzjPWNxZjmXuIS1BAqCtXIZMqOO4MX7W/wmVWx7gVJ7YIyELvX4WdBX+HO?=
 =?us-ascii?Q?ylhlGMhw4ZZdXAGQ5MgF1PIl7yjEcC4LVVLz+MkXE+ieXp2D99T5+U5Sidol?=
 =?us-ascii?Q?r1Vgs6a+41G0wRspO6vETyYrfrlh/phYeHYY4c7rMx5Bx3DCSWwlgiXMa1wN?=
 =?us-ascii?Q?qrH1ag5iYQ+I0ymv2SbiZThbT0bPYecOJDYsXbKQnFuHG2vFk8YMjIVHNTj0?=
 =?us-ascii?Q?Z7mqGGRSLg/9evZg8RrgGdRN5e1LhENtsbuU0c9HAj59xyqzyryeyDR0uJ6b?=
 =?us-ascii?Q?R8pl4EcykX04bSbPCHXKzb04mDr97pSUbDeuNb/upQuRNp9XzLkefuaPSrme?=
 =?us-ascii?Q?a1wOoJofdzR3834leU7IriL5HhJE7IJMDXqdGcF9Jsfa7WA+BvoVYHAWQsOb?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82e0b24-8518-4136-afe7-08da9b80ffa0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:57.5999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWdKtYVsBHj8trurBaP67/p522/q4uYhHq1O4sW0taxD+efDSMXdDCmKsn2vdDPwMgtdJFj/RrO6mfwBQocUGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: CXgA2pDl4hd2buKXaCEsBBojy6ixTfnV
X-Proofpoint-ORIG-GUID: CXgA2pDl4hd2buKXaCEsBBojy6ixTfnV
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

