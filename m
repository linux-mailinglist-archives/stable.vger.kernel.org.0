Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5CE61EA08
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKGEED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiKGEEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:04:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603F5B7E5;
        Sun,  6 Nov 2022 20:04:01 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A72xsUf014980;
        Mon, 7 Nov 2022 04:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Oib8+GXTqsLC5PQTejiVvNOsWgTcQRoIfdJHrWAybzg=;
 b=uf1rdMURGrVhGQj1nbpnFS8d5pKfys7jvECwa+upQcLkbbIMuc9AsIhicfWU0EaQ5hfl
 HZ1Eiesyhr9xfxO5jQuAbzittLQAvtXJ5McWiLG1TgDbRTlR7Sqr72uv1ko5wwVcheeX
 ROokukziSOvRme6tJVrz5gt18LatH2eP7QnaxIhZJpccub1WCqNSNQ1FodEOzvTXHh0t
 xgRwDbmskntkE30wRf0dcm2UizTynXzH89xjQfZVm9ty4xAhp2d0giyefJo8gnQ9qMmd
 OsCIqe4UuqnYl2micuBnAcGS43HuhAW0TYwQEeJQp8weakSfFyr1c3e9jCDMcnyTeMJ9 Tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj2ebk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6LQFdA024375;
        Mon, 7 Nov 2022 04:03:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsbv6g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbY2qq8K3dle4xt/vwZReLdRrZ29wYzXpasC2dbgARdjjX2XFXdGU+reK9dTj9T6cH14+jy8yEwz+Ib5iELvz8M1lyhbxNVI6HCDVYh3Arqw8WE2igay8nnL76QzRaukKVCiIlYRP53ggIvwEHVwF4EwldycvTCBsJtJalYSFhZsU42gXaFBExjtBd1yAHN6de/BjIrd/XfFPLWLZZsSrF07TWh/M6Qfk5Vc0J40ow+B8Bf+LN/2Kbm2uqmcfq4GAGBV8o45hSQlyb/cWert8M6+CpR/PgCGCaqrm+hIuN37PtU/CHOBzV9RmJDCI1hnxEujZhZ+0FO3KexKPBJz9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oib8+GXTqsLC5PQTejiVvNOsWgTcQRoIfdJHrWAybzg=;
 b=b6PANhZz+/MxFTs2lB3QVo8IpZXXWVTP1ARJw/5POapE6jzoXC5E3f98FTy/04bnlC4jJM7IEPK/67Qef+33bID7PQNky1sLggUQe6DbT0Q/WDZNhkSlzV3skKby9krd5ixFuAOnCe/f2cy6Amgxct5CeapuLb55hDRf6Li5Vut6vPPlcZlbIGEGvEJGBn4sSiYzzjzd+0UubH1dQqvp+mHhX5jgOUmeWYxkG8OzcRQmu6/a24peCqsURBr/pO+7/HXN4dzGh8hGe3EGf2gFxqHfjdZqY5/W2X8I491xDDgsuw2lkqN3yjNq2ZYAzrJV2x8skS8pH5JgfLWxFqgcmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oib8+GXTqsLC5PQTejiVvNOsWgTcQRoIfdJHrWAybzg=;
 b=doDGjTJLVk2zMcfm2Acu2+MXdqoYToAWkISwPawRKj3BmU9bZw8/ZfPnqqvxWwVVHnvjc67G74y6b+PTcq/935BvFAd41kz4H10byjC2qjTK1BI7PAjJ7ViRLBeJ4HNiqtyR2EXtfHTFIIHkwqvJcAxMhkPl465X0u4tj4QhpMk=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:03:54 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:03:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 3/6] xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()
Date:   Mon,  7 Nov 2022 09:33:24 +0530
Message-Id: <20221107040327.132719-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::32)
 To PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: f5246e86-dab7-422c-6713-08dac0751607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mi9xtMQdVi9gBy+7ksKhXZjEHoYh62uDEGa7Ihiem8INMVkHMAC4zCE+7lGRay59+tSfhWUHDjKardDuXGuQhQBmkVZ3E3EmG0gjmfGnphjlrmhq6IJHhJKRYCUjspRYpvTaYUqesZTNmGp2gpIBsMDk7rvV+23wR0/GXEuVQpyTbDGqLyYh8iQ67z0MokfQzOKzPoH16VkIsqn+p0o5Gvz+0CsFtNnWtkhhRoF0ivMsFjqUfXUTKDNIkNzfRicKEaxjjT9SrgDJ8lVgZpR7gbBxkqJ+gQT+Ns9o9wot6g/00EHdu5X8yadc35lmnQnDiPeCCOhux3WpKIS0gOPSjF2bqFuhbLrLGNVpC8JuRW/VxicSZD7/mH3Sp+pawiGzNdGVR5WCa2MRgV2PRXuWvmOJNuKtr+S8FhK9GfqIdsyUcUKaXmjLHnjCOodePFml3j5rTvtnz38DE5StgyozevgQ40xBiXB3rarpy8GScMiY277SVet45hcUB8fYusatzpRtYlWt+nYU7Dcf/4eJOspZSuC2rgpVZ6B17Lj7EOYk9PFA0SY7KKAnJ06KjgzsYcuDe9hiMK21Ging8OYElp/wwYTeNNEQrlKHa3IAyW7JcSkWyxS4Cd0S4McEiO7XaniY39ltYqhlnuMkrPZL90ennSipi4D4TIA+k+QTtFpB133s6r61vwho9XmGXncFXqdR/ATqlsovSD/YNujyNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(2906002)(478600001)(6916009)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NGplnsYXvtX2SRxERGKbzx8G3Jh0dJiweGNRzi/WWQ9co482BEKZufk+bxVz?=
 =?us-ascii?Q?Lx5oFNIhEcWpgkTnmDQTzt1ikbCneI8j3gfq5FdlrTVencgY4tq/J95P4Nms?=
 =?us-ascii?Q?/wOiuc4sXl88q98DV9AoyRKg9POs06XlCgqbOQVPpVAmeCmUQZLsLoRRu37P?=
 =?us-ascii?Q?hunpkpcmupOfefwWWhDU8N1oyjfw5E583RuaC+FWZvD6dVMkp7tP8zfa581y?=
 =?us-ascii?Q?PDlQxXtjJjeCzvC9fohkQPROZA0qOO6O/oKeElPSypokGy06zcglErJhrloU?=
 =?us-ascii?Q?MnE19q00h5YGSbk3tSjsuZOKs8kBOeHlvfeVjoYgoXDrhJ+fjcCKyCR4tLLg?=
 =?us-ascii?Q?WKDcldyXEgd9NzoYnpvkjUHTjz9KZYSNfIUl+uoDpswpcdGLawqh6dqKpqnR?=
 =?us-ascii?Q?3iKJ/BXY8cTNTlSUKIKBqCKgaegQfL2IdjxsLLC3vnpXRSCeFnMIYAzB+tVZ?=
 =?us-ascii?Q?1+A1VmznESGFu7GqXm1Jk45IBX0ey2R17kcIKbq9K1eO9fBcwxGG5yP6udWZ?=
 =?us-ascii?Q?xfAdt5lRLDOYqu/6f6pS3FBAtj80b7dxgIzisLOu8NN5eTN6mrwcTSW9zhpJ?=
 =?us-ascii?Q?0ccYEbRhcyMlLOzGT+V9M4FmZk/JGnwmFaeXOOxDROMPQEiMH3OtVJX84ve0?=
 =?us-ascii?Q?Ki+255KGuPMLmiUeCqhUCtgZWBhXOss1OeC0+SrIOzEaRp8nxgp4Bl92SxvL?=
 =?us-ascii?Q?YaOZSFJOUf+pL0VKbnRg44YXWE8BwrfC2oce3R/XFNbWv62nQ/GQDcayGpoa?=
 =?us-ascii?Q?/yO0fOTAXKxxwG5xRcFBbF3ECYxoFuX5XPV3eNjHDOkbyj+k1CejwzUTQ+h0?=
 =?us-ascii?Q?qy1MUDksjfMNYowJ7ii74T+cb+dUVptqjbXZmOpLWJ5OgV/h6QmaZ7gdtf4p?=
 =?us-ascii?Q?qM8P2FdBStucS1fD/M1QcaAYz3CkAeMLlwfKnsEigoF2eBIwF0ZBM6yb8iz+?=
 =?us-ascii?Q?0ZpNkBD84v1vggYdSi+DFhWQt2VSAG38qWyg3Uc1yrCI5PlQH/QIZzWgYkqe?=
 =?us-ascii?Q?A2ff2p0HplsKJ8MLmOADJrLqCpPCVE7mtJOPGjOX/xG60drJCU0tYerUUHJl?=
 =?us-ascii?Q?noBey0I40uh/GrHmAUQ8zHRsL/nrt/d/x99nZZZpVIdclL1cvOXPVy1TqeKN?=
 =?us-ascii?Q?J85oQVlOOv7UDc4vbyeg8FG2gA27SsFNEAz+woenBP2I1VhBo7TBPTam3bG9?=
 =?us-ascii?Q?9KaPZathW4jagH6O5AJznDEA9+qEiUQgCeHAsV9p5c3FQUJlq1GiCzjxkCq4?=
 =?us-ascii?Q?8UHLg0fEQMXgxUSo5ZnCA8REx8EdIWl/vDSRGCkU2GGShnWOifqEhUxH0O3k?=
 =?us-ascii?Q?o+rrrIPHuPDb+nKZxXHuTuxiECFHA2EkoXNkBpyNi9+QmH2UU4lCjBi+sl4E?=
 =?us-ascii?Q?/lt3GWhLIMitAaWqSeYcECxqsmbT++BEJW8eSWJnM5k4DsItSrO8v9BKZp8K?=
 =?us-ascii?Q?ar6RlOdM2H/NXAVrR5sxxhwiAEqjnpng+5Q6LenHLJ9lftyNjBTaqMecEMVK?=
 =?us-ascii?Q?jF1xkheR8Tx0kPP/4B6Zb7+5r2hklBtBE/cumhJZeb3ulFe8tVltQhxwbyjs?=
 =?us-ascii?Q?U/wVlBAQUw55MPczsPbX1V8QrHsQUJFP9pC7tqmK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5246e86-dab7-422c-6713-08dac0751607
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:03:54.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7nfRkniHsf0xwv/ShB6uhZXZ68p5n5BAtezAU38Ndsjhmv1p5VUutRDUkzA43FcezVX7YPqKxGyO8vfXVfs1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-GUID: XrVddvCMOQ1tnSMCJz5_G39ppXLXb6np
X-Proofpoint-ORIG-GUID: XrVddvCMOQ1tnSMCJz5_G39ppXLXb6np
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

From: Dave Chinner <dchinner@redhat.com>

commit dc3ffbb14060c943469d5e12900db3a60bc3fa64 upstream.

The error handling in xfs_trans_unreserve_and_mod_sb() is largely
incorrect - rolling back the changes in the transaction if only one
counter underruns makes all the other counters incorrect. We still
allow the change to proceed and committing the transaction, except
now we have multiple incorrect counters instead of a single
underflow.

Further, we don't actually report the error to the caller, so this
is completely silent except on debug kernels that will assert on
failure before we even get to the rollback code.  Hence this error
handling is broken, untested, and largely unnecessary complexity.

Just remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans.c | 163 ++++++---------------------------------------
 1 file changed, 20 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b32a66452d44..2ba9f071c5e9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -532,57 +532,9 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-STATIC int
-xfs_sb_mod8(
-	uint8_t			*field,
-	int8_t			delta)
-{
-	int8_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod32(
-	uint32_t		*field,
-	int32_t			delta)
-{
-	int32_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod64(
-	uint64_t		*field,
-	int64_t			delta)
-{
-	int64_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
- * and apply superblock counter changes to the in-core superblock.  The
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
+ * apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
@@ -627,20 +579,17 @@ xfs_trans_unreserve_and_mod_sb(
 	/* apply the per-cpu counters */
 	if (blkdelta) {
 		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		if (error)
-			goto out;
+		ASSERT(!error);
 	}
 
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
-		if (error)
-			goto out_undo_fdblocks;
+		ASSERT(!error);
 	}
 
 	if (ifreedelta) {
 		error = xfs_mod_ifree(mp, ifreedelta);
-		if (error)
-			goto out_undo_icount;
+		ASSERT(!error);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
@@ -648,95 +597,23 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
-	if (rtxdelta) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
-		if (error)
-			goto out_undo_ifree;
-	}
-
-	if (tp->t_dblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
-		if (error)
-			goto out_undo_frextents;
-	}
-	if (tp->t_agcount_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
-		if (error)
-			goto out_undo_dblocks;
-	}
-	if (tp->t_imaxpct_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
-		if (error)
-			goto out_undo_agcount;
-	}
-	if (tp->t_rextsize_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
-				     tp->t_rextsize_delta);
-		if (error)
-			goto out_undo_imaxpct;
-	}
-	if (tp->t_rbmblocks_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
-				     tp->t_rbmblocks_delta);
-		if (error)
-			goto out_undo_rextsize;
-	}
-	if (tp->t_rblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
-		if (error)
-			goto out_undo_rbmblocks;
-	}
-	if (tp->t_rextents_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
-				     tp->t_rextents_delta);
-		if (error)
-			goto out_undo_rblocks;
-	}
-	if (tp->t_rextslog_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
-				     tp->t_rextslog_delta);
-		if (error)
-			goto out_undo_rextents;
-	}
+	mp->m_sb.sb_frextents += rtxdelta;
+	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
+	mp->m_sb.sb_agcount += tp->t_agcount_delta;
+	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
+	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
+	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
+	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
+	mp->m_sb.sb_rextents += tp->t_rextents_delta;
+	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
 	spin_unlock(&mp->m_sb_lock);
-	return;
 
-out_undo_rextents:
-	if (tp->t_rextents_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
-out_undo_rblocks:
-	if (tp->t_rblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
-out_undo_rbmblocks:
-	if (tp->t_rbmblocks_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
-out_undo_rextsize:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
-out_undo_imaxpct:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
-out_undo_agcount:
-	if (tp->t_agcount_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
-out_undo_dblocks:
-	if (tp->t_dblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
-out_undo_frextents:
-	if (rtxdelta)
-		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
-out_undo_ifree:
-	spin_unlock(&mp->m_sb_lock);
-	if (ifreedelta)
-		xfs_mod_ifree(mp, -ifreedelta);
-out_undo_icount:
-	if (idelta)
-		xfs_mod_icount(mp, -idelta);
-out_undo_fdblocks:
-	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
-out:
-	ASSERT(error == 0);
+	/*
+	 * Debug checks outside of the spinlock so they don't lock up the
+	 * machine if they fail.
+	 */
+	ASSERT(mp->m_sb.sb_imax_pct >= 0);
+	ASSERT(mp->m_sb.sb_rextslog >= 0);
 	return;
 }
 
-- 
2.35.1

