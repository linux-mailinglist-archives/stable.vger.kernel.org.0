Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9620462522D
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKKELJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKKELG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:11:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36B71BE93;
        Thu, 10 Nov 2022 20:10:54 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB42CxB024269;
        Fri, 11 Nov 2022 04:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PDhhPVuzo0+iDA/lh+tTtzZE8gw5yoo3hhcTl6z6kqc=;
 b=mQGFuZNttPaLWSgFqoaqwtY7eyPEykwfWXue2RZRtRIzv/OAO5+/kbV1vIJHx0X7vtWe
 lgKPMWvtLXTgNe6BIdL039OrP0iK3IbtTcAskhzu0JCXSbirrSN9SLn9pzbxY2kM+ME6
 3ruxUdO8gYptHbkvoe1cqstobV+NaiCv0ZsnO3m+p+VznE5fZtZLZISj7rjasMSHv4l/
 iHLlUMqoY14nmS/MewWq2D1qJQK5K7kB9G4FMxoRohTTNqRV2VkaM/d+ehSMCrFsVfas
 ps2qk86bWCqSCjhd7ynEejmXHiNgJQ51/Sz6gHuSNiTm+b/GYo+XC6heM8gbG7gXtnyD KQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksf0wr0c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB2Wo9F009687;
        Fri, 11 Nov 2022 04:10:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5whty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+tERz16gb19MNHes1Dt6CRgZSrtwls9/ljf/zVaydTNN1UN4kbp2/hHVjfJL7LKNT1Xz4PeRUw8swrv2jOcsiscceCaAyGJRCWrBhyCqc1eLnINPwvufzOQGvWm4GuE2jABGTt6C1Tw4K3gSl55zcLL2EpmnS5al9So1ssQMCyBqUiqRNfIfOGzlyScaD80phXcCHFHazN7tDEd0yvEopg/yt7WsBPzwxZ6q/ZZY64A/jhGKV7bPVrCPn43r6x95aYsjMiFvrWdn/OqwmqV+Ns3GLMym/TXLNaLMdgloW4CV5YQ8gcFedUNIs6IDhTuN4plGw07ltK6j6iw5m6uIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDhhPVuzo0+iDA/lh+tTtzZE8gw5yoo3hhcTl6z6kqc=;
 b=S9o8kNPGHZ83AddGBj7JU7oaZedsgMcSzDbf+MB4w4pxKdpsIjk7FeNRo5HUxwKq3ZaJO+XgXsf7KhVhVPmfTvp62c7nvEilASKZUx5ak5itO4APFpCRsOY/SeDXFvAddy3b+jeZrIXBnV8rkwJmWMAT9xjDrCyo3zwjdSFma5UjATlw8v28MR90tn7ZUde3orDzF9R3lcwsxeeFR25JXRzO30U7bhZ8QRku2NHN5EgxqqO74HzoEJBUFMvxW9mIjoKZeCMPTg4wYDNSlHsQyhvwS+fu5M187qUejxtkaBfJQyh/Vni6KT2Re984TMRyGfvyZq/cjFiavbhqHN/AYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDhhPVuzo0+iDA/lh+tTtzZE8gw5yoo3hhcTl6z6kqc=;
 b=utssy7TnLyaMMaTkN7GRWyx622OsXO6gg0Q/bmVKeMmhbBmWNY/X9+zhuyyuEUlPQK/31HQMJ7afLJzaSpLcsuz1ZoOH8YPyJ2FxhD7BprL5Y8byDsIGcfUrxeRDgI1N7S58X8RnotYux1rY6CEAbHlrdT1kHgj5P8tbIYKh5NY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:10:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:10:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 2/6] xfs: rename xfs_bmap_is_real_extent to is_written_extent
Date:   Fri, 11 Nov 2022 09:40:21 +0530
Message-Id: <20221111041025.87704-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0035.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: 6491a903-9be3-4719-1ce3-08dac39ab3d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjh+EsHYNOQkKn3rSBDn56c5bLEKpAEmVbfMOXful0Z9uARtn2EyOAhBeEnypt4A1SKCWVqhb2DMKKpidOQ+Py4LRtaZnzMCc2/dkUFEATz/Cmg+JI29zfHwMwiZCwRjgX2Jt+aYANwpLIDR/b0G1US+Iwt7qtCkaaICsO4g/Ysm2zzV6DneBg+TNGdJXTrAg2xx9f7sPVD50aUK8FHmnKKx3qL4uDYoITqN0+5Cq2GMZ/z/PZbxOF+WotN430nWJlno6v66GIpx4zQaf2EOzbidz9xemxBDjHRXH8Wd4s189RjWVkJtU0MTULHYy4/ZqdAAvqNUovMjl2rcKqFVgHk3mONB5RmwZ6HkWKEqRsBz/5SO6FJJJnvJbVSPknPNXFPpK2x9ngeWpm1kPfg2VF1f2UnydNG8rtiIe7KuEQeAkp0LQYXFXMHgA0umRyT0lmZ/p0Ipss1JOa4RSR58Egu4PT/XrQJPeIHi5EUwkEI++rlc0k0/UfbnAJWdPYkS6RxnDevqSH37BwfZKmqcKuvywkyyCgiHYLUPGPsAXHp262UC5fNG9PPuDu6XB6Bg0aMoxQMEc1UOM4nCl53tBnrI1FAjoqqLW0woww+l7qOaAHvIG7MkWVs4PzQuo6huDaEfF81ezG/hGpFt3vLwGcgu+EzwI4lR/MogKQncZdxwO2AqjBc7Ohe4YhJY+6qxG6BVaMKE5WHmuLtG7GFWPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(316002)(2906002)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Tc374/W14t6NexMSZ5Tf9nOL6n3VZkxcowrWM7XYSG88NxLG6NPfxTUeiJX?=
 =?us-ascii?Q?fLLWk8ztVmmHxd1qvqKt57r4T0Hpea/+1HgAnLGuPfH25B7Lj7QS8WxyQPsa?=
 =?us-ascii?Q?UKWwPliMs7ABhnm5s49qGwZFssAvdvcCk8L98xpidTFygVtIlaA72w/wno/E?=
 =?us-ascii?Q?XKZ+4xTltGo6+cx6NHWc67oU6Mr9Q8FwoFoqXNkaUEgfta3ZpaAIMOCIbqHd?=
 =?us-ascii?Q?nLhrJpoCQYL8h7JVUdjKpeKMNaka7LpGrojHUuvI2JgWRS/gpvr5H8VDhfKy?=
 =?us-ascii?Q?bSqaRDGyYH0ZlOlbNFef+ro8XVREsnlbyhDEfioKqhzbvhDilu34yjePMXAQ?=
 =?us-ascii?Q?NdX8/lTQqupMDf6D50U07UU/4kHy+vGr3kR84GiD9yaDuFtQjaCOExPkcr64?=
 =?us-ascii?Q?MmDS5oVJhKoTcaawEokiDTReZXrmG7bAHSQiT7Vw4XVAJWWXok3aIeTZiXau?=
 =?us-ascii?Q?fPv/Nmv2pfqlltDnH5pbRPNbMX9TMOezJjtgCXW9jLFmnR8yX1f3QASWil5U?=
 =?us-ascii?Q?Ims8b1+DMhXj3IFfzMDXT7JO+5r3VM3CSINrIcUqA2YDm2JidvbsTcor8ABH?=
 =?us-ascii?Q?QaRSweXfLaYJpgk/4VPdgyKPj5dNHGOR/pltx4Zc4+UIwO2NSqkcxAxQD/3b?=
 =?us-ascii?Q?IcyYVqFYMsAEJ/S3fa+A8l8kaPv4QQWlKPf1fKc1ZpH9EBztGuS0LFsrDHo/?=
 =?us-ascii?Q?n4WCwzZxhi1PABSfwiKuENPr7kAqt3zRN65E9qDl5mmnvfJwv+RAc+igqSZh?=
 =?us-ascii?Q?pVcsK0d2BeMOzFJPIigvfTwzr0PS/hz/+HrN0guqRfvd4TVHmWDdkp3hHciO?=
 =?us-ascii?Q?PyKffe+RWwOPvWJIrwB670cOCUn3HT2V3GyaxMOFAlKcDHSpOL1s/YJsFdgX?=
 =?us-ascii?Q?y293IenNCaxrYP0bfx85hIdcvkBWJgimskpKoKtN9RQYv6A5Qh1tj37B8O0l?=
 =?us-ascii?Q?fkh4ziFPToOash/ljHeJsRigOhL4KzvtZUmTMSkc5/e/JXyrdftrrrc5TBdt?=
 =?us-ascii?Q?di6jXzL6Yct+dJ5Cdilz4AvUEIMfkny9Me0XY5OeszSqIRt/06pHg4o5cRjy?=
 =?us-ascii?Q?QlA3XIDKEQFqr+YRTW03oP1wqzIeVfR/ADanTWM9GibxQESncQtUpF/ubW+q?=
 =?us-ascii?Q?u1v8MWf7fQUncJLZevuykG8LrbIkAbFovwn+PKQjgAKhFb7pWhq/aPKszsaK?=
 =?us-ascii?Q?vGC5v3z+dpKYGPMLMQ0LA9PtcUCsxEXdiNl4VAavXhWYsiZcIlyeZpSjgh1y?=
 =?us-ascii?Q?5UY7EYJ9eIdTqDhm8Ti/0k/Vb13Aua09Ijl1wQw2U3s4NXX0qnv3alR97KjV?=
 =?us-ascii?Q?PBkidKZT5MG+d8MNvYD7ESO3bnTDLzNrkfqHH9egvKqLPFeUJtyTcYzeN6fA?=
 =?us-ascii?Q?WJk9fnhOL3qR2TVtuZoCk/Gclrt3KtUxRWeS93LT5D+O48bN6qLn07hVXAly?=
 =?us-ascii?Q?aKrdOIl7Iwbb5F5uYWCsqs8ehTSMLns9WXsj4HLb1yviVvYaiT370PflARV2?=
 =?us-ascii?Q?PD4rrZc5zGrtljeTW6ukaTFFWyQSYqwMrrkRSBMVAn/5G4H5wdHa+iqI8RAt?=
 =?us-ascii?Q?hSAQN6WCGab49CWV/jr5BysbuDpvJTx/5+rMD1PX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6491a903-9be3-4719-1ce3-08dac39ab3d5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:10:43.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiNaXV0BhQCQ98wjt/Tjt8iDvC9/uD5Fe5xGJHIcdzcelkuA6NRCpH+QNzKkDaoHiyXdpenwwvONOEdlPpWOFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-GUID: evF2C0Q4_hbExxcGFyow2y1yEswpdLDO
X-Proofpoint-ORIG-GUID: evF2C0Q4_hbExxcGFyow2y1yEswpdLDO
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

commit 877f58f53684f14ca3202640f70592bf44890924 upstream.

[ Slightly modify fs/xfs/libxfs/xfs_rtbitmap.c & fs/xfs/xfs_reflink.c to
  resolve merge conflict ]

The name of this predicate is a little misleading -- it decides if the
extent mapping is allocated and written.  Change the name to be more
direct, as we're going to add a new predicate in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h     | 2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 fs/xfs/xfs_reflink.c         | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 640dcc036ea9..b5363c6c88af 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -163,7 +163,7 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
 	return irec->br_state != XFS_EXT_UNWRITTEN &&
 		irec->br_startblock != HOLESTARTBLOCK &&
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 85f123b3dfcc..cf99e4cab627 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+	if (nmap == 0 || !xfs_bmap_is_written_extent(&map)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index dfbf3f8f1ec8..77b7ace04ffd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -181,7 +181,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
+	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
@@ -657,7 +657,7 @@ xfs_reflink_end_cow_extent(
 	 * preallocations can leak into the range we are called upon, and we
 	 * need to skip them.
 	 */
-	if (!xfs_bmap_is_real_extent(&got)) {
+	if (!xfs_bmap_is_written_extent(&got)) {
 		*end_fsb = del.br_startoff;
 		goto out_cancel;
 	}
@@ -998,7 +998,7 @@ xfs_reflink_remap_extent(
 	xfs_off_t		new_isize)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_real_extent(irec);
+	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
 	unsigned int		resblks;
 	struct xfs_bmbt_irec	uirec;
@@ -1427,7 +1427,7 @@ xfs_reflink_dirty_extents(
 			goto out;
 		if (nmaps == 0)
 			break;
-		if (!xfs_bmap_is_real_extent(&map[0]))
+		if (!xfs_bmap_is_written_extent(&map[0]))
 			goto next;
 
 		map[1] = map[0];
-- 
2.35.1

