Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523B85BF45C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiIUDZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiIUDZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1BE25EBC;
        Tue, 20 Sep 2022 20:25:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO683019481;
        Wed, 21 Sep 2022 03:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=sS1PpxcroAjcxa4hu0C1L2z/MwlxkkaE1QXyAY3J0F/klfiIMxaGk7YU8fPtpZpp+eqp
 por8ojtVnHcU9iVc/ZoTz7wFyY/89jkpu3Gi/mVkvzI8el4soRS919g3cENuMgJgTBny
 SkNbrRgMEY1Of3rzQ2jElNGzQGBFRTWhZ9m4lcnpg9g423A3mNaH3kVI//DRkHMe/eV1
 iN4hv4fco0qG1VhFHvsHlh9R38jPIceT0ox93Lk1yucrdgMlnkXZslosp3zbZH1XNeW/
 w/p/h44Y0I48yiThmCPakBzi/HoSHWmcEOiujyP3feN+jNY3TirDdM61lkKJeADDxWq0 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m90nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2Gp8u009939;
        Wed, 21 Sep 2022 03:25:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c9p64t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGUotHHcXuIGQNJEXn3TxXwu2uHgUbMzL5sqV1bYRDCNZGR5tQ7ODjWCsILvN+/z6wTHBgnNEu3GmNnL1HUGLF+1PqHJW+arH/rfXi/SW7Y4sqSeXfe0FwlIwJVOTq6ttS5Mg92L3vwdf2V56QBl+8rshtHSB02Ellac/YyN+JW8kk1PTp6BFbR7jYrSdQh8qlZigbZWChRSJsc2Fl6PYcOlPiFn0NdlSxGxlRWjDXRE4jkQ4irJ2ooDq64t2uDCDdgFbTMz+A4M6UBrmMAXd18H2cj6OaGy/n4iEElfYMBtCMCLIq0m6kNAUxClOMyHN9uTC6wLSg4SlrtwlHAFVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=gXO2aWNXz2tBNuFKFT/A35mhdiCVtD13IRrd+tpZRShypwoLM0z3Ba1hV9dyi2QV3mVSfL6cw0LDVmADUAJzokLv1fo5uY4jC55dMeJj0t6UJ06qZ4FqKQ0EZJjrF+2mifd4qvEgDskeq1kYBnHWaSC5ehc8MHMYj/NWt53Fpe4PdI5V2PXuZYsEnhpw7o+A8glv9WA3AkXAaDxgwB+tWO9EwqVcwqCp0VHoKa2HKxiRpa3B5dLeB07nGct9AfxFPN18E+LoXgxQXeL7mYwtYEBlqqmFdKl7eAQ+YDw738GYpBGX0Ar94UrgvUiN2nYpwetgIe9vHjyBk1sOs6LOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS/JPWPekvz9NXFP05O5/jYdkuqbnHN4DIlrt2cBhzI=;
 b=bUVdjub83HjEIrpLsN3neziczExGHSshWxxAw5Gm6RwnBugOADEztUZAjlDKYxegDmGYMD/uKNPDNGaVRJU8MdTnH6FlYfkpB/I34N5Tabac/gJ95pUUmfgttX9tb9kmiPCcxXZSvEcFH1IiUSwLOyvNsV++Ob0Xk8klRdRxzJQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 13/17] xfs: stabilize insert range start boundary to avoid COW writeback race
Date:   Wed, 21 Sep 2022 08:53:48 +0530
Message-Id: <20220921032352.307699-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0153.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ddc61ae-c16e-4393-ac12-08da9b80eeb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dq0a55gzkqO0rfaeLaw+CvrwWxwSsqNwGCI9BaX/OuEBdgwEOsG052Zxbsyj038gnYtvR8quWBzyBg3lA9hhCctaOKdXkM67hooLd22X9ERe8u3OuhIh3CQX6Y65fyScCWfqvui4HmX8uUCygc05HyEntFrdPirE7P8gBEeU/JhjQEkiXgOo0YKlRqn1xIK5dbq0x5MA4DhVEK9gE76nfqVv8xEhrR39JGhM5CuOj00Ew732VIbo39U7gwUcbqu2zqS0LLiKt6ySqj/5iOK04/EdzBseSOmp8gG5CEYLmQV68QxtNJLLViA65piHrVRMC0y+1EMvS9vfvISPQ/M6Zcl5Nq7vPsFDHmqWfJdPzVyq+7tgi5NwH2i27OeI/+mmGUMrP+vwamIwB0mSVdZdu0JYSnBfkxKMYFD864baZpKLhKxykMGBcQ9xxzBWaHnJWu845tsUJJkxsAq9KptamCjjAaCz5VvhbrdfKk35dNVR9Lf5lXb6H4mIGC5+dQ9RRgfNbwj/P6P0I/nGo9aiu39+0i5uHxjV0tsfX1qbEmPodh/C32fD3Vp+irccunWvRbGnWu7XFFwK+BgI7KLKDVUYAzAmLGKrBrmjSFv7uQnzErdJt84wpUsARZ7kIqxMKXpLYWWR37aYW2iZ+iv5yQ3r7EFP0saYVWv3DwaZmM76bZDweD09AsQzPMbmBNDFZuRPjABChGxQBSNXdLIHOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XbVQ5NrZEQPSmTWgASws0caJj18HEeTWKRITPIT/ktakviuTEVuYsHBRjDz1?=
 =?us-ascii?Q?UlV6HwTVGy+mO4F0yz/7AgI0UqrYqSwZibbQi184w1Y8ECOH+idYSNEfs6o9?=
 =?us-ascii?Q?gfdcMmYvv084VbxUqJfq+wirWaoUf2crtJnPFFhyVdfx0enUFFc5BOVRiTcm?=
 =?us-ascii?Q?f5AzKwt2u5AC/3EsAak3z7bCD3dgmvrZKlTGWzqm23cSpP9hjxlUR3ciyGRi?=
 =?us-ascii?Q?3kYAzxDg7O84kTJLtQ5iwd21QFhvLWGjPAMfJsYFJMubHB/5b9uvdwWCrc7+?=
 =?us-ascii?Q?owslum7Blh/B14WO3s7d7mmCm0FBgRtTtCKIojL/sook+bCqikC3pYvjplFd?=
 =?us-ascii?Q?ZTJOOV4a16XOYjPf2zHLUc03QJI30z+V+A0jZvKAe2AgfHP0H79TwSJ5JEkI?=
 =?us-ascii?Q?cqdfIgGROEricwTja8XJKEYWpET9iTmo7+ORYeocP8jQ1PsQY9W+a4wd+j08?=
 =?us-ascii?Q?YXUORC1OV1nP7ZrKgXfS+fgcy1ooln7rcSUp/GA1tsSzXwD4x5JtwY/Nkm+f?=
 =?us-ascii?Q?W2dLbFwNRnAPRAdkYDiYYI346hsB5+UDRHU7WLfYaQMsuipmV3bKpo8ljNiP?=
 =?us-ascii?Q?+74kAAerNCCz6oPib6nK7aQI9f9GhukSVJxLd9Lx1rwcRoHd/EdzXzcVgDPd?=
 =?us-ascii?Q?4eFOeLjp/GSd4pf5wP/YVUMuv2q6xOhDiYE2BJZpyMJHj7KVuoTxhW/4B47v?=
 =?us-ascii?Q?fhhSbaG0FVev9KPQs/3EjFs5S05lcregFlhwcj1nhpUWexwgIRelT0DJ5/+P?=
 =?us-ascii?Q?8xc8WLPB4QNEuOf946iMITb1/XHfZbqu9tPvABVpUFVijo33nQz9zZH3MAqv?=
 =?us-ascii?Q?uyt3UzAAu2x0rZIjF3aqrzFmXsNpXOskPw4gk68mIUIhZAlz1269YwI6u7Pd?=
 =?us-ascii?Q?NPSqb2T8hcdTYwvDIAUNynHMM9dozwnqmtZMC5o1DegyPeENxNSUti356YFc?=
 =?us-ascii?Q?FD9ZKNR/nkjkRwMrmc/Qprv+GhBbyJIfKxvsMUAF7bPn7YlVabVUwq+SkGGE?=
 =?us-ascii?Q?72NDT5DyaiIoqESseVt6dW2dRiI/prpLNK18C+l6UlqH1NeO8OHAsoa8ruvq?=
 =?us-ascii?Q?xZKU+M4a0A05vd45PE9kn00n0kDhcvOC+XtLrhTJ3MAsTpH01UMUWgSH/T23?=
 =?us-ascii?Q?w8CD7+iLnbEQwjCyTorT+cGmqzVdfTBbaCArFgF+R+qufZr/WOGv+8D62prE?=
 =?us-ascii?Q?sbU1dS1L/Q/Uoccc/8FR1nEk9sHQfzxlgbf89eOe7NFi0YnLUWTB+UWUYzzm?=
 =?us-ascii?Q?6fRkCDAiHIxgyl/alFETZBCVmvFRIupZfeN2CcxoVWc1kaxbrHYonLJpPWmH?=
 =?us-ascii?Q?xTXiYdG2faJAhmfRONMPutE+E7NGeXNegLYcGQOPBLIk7Moh6mPmSB2m3NID?=
 =?us-ascii?Q?P0u1HHIKqMk9TUUXY7RjdhR5fAZuj6WnyZZ6HZ7C3pPfzbIqht0SN4NXbtyw?=
 =?us-ascii?Q?cJ+mzg75dqpcJ28MTFxOuGIrMqtdMru6tric2HGNvZ0M+o/i9FdKO9T3CF76?=
 =?us-ascii?Q?fVAD4GuukemCwptR/7M3d/eyyOjKbir8YP+os+kUDFX60kpzbxyv28BWPMk7?=
 =?us-ascii?Q?Rk3DmP9bHgFTYE9b41sq6Bv5mAkil/AQIpqCyEveJsZNRHfBZkSTd4bvZiiu?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddc61ae-c16e-4393-ac12-08da9b80eeb0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:29.1052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFOOtB66XHk1+QK4MaiQ5XT6YDXkzKXUNbA8vTa1zPXUodjnq730CgWK0ybgDsi61UD/YqZkX73+TLY0mKvilg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: gKSXOX6-7fjW2fzYVCH3VciYi2fT0gCC
X-Proofpoint-GUID: gKSXOX6-7fjW2fzYVCH3VciYi2fT0gCC
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

commit d0c2204135a0cdbc607c94c481cf1ccb2f659aa7 upstream.

generic/522 (fsx) occasionally fails with a file corruption due to
an insert range operation. The primary characteristic of the
corruption is a misplaced insert range operation that differs from
the requested target offset. The reason for this behavior is a race
between the extent shift sequence of an insert range and a COW
writeback completion that causes a front merge with the first extent
in the shift.

The shift preparation function flushes and unmaps from the target
offset of the operation to the end of the file to ensure no
modifications can be made and page cache is invalidated before file
data is shifted. An insert range operation then splits the extent at
the target offset, if necessary, and begins to shift the start
offset of each extent starting from the end of the file to the start
offset. The shift sequence operates at extent level and so depends
on the preparation sequence to guarantee no changes can be made to
the target range during the shift. If the block immediately prior to
the target offset was dirty and shared, however, it can undergo
writeback and move from the COW fork to the data fork at any point
during the shift. If the block is contiguous with the block at the
start offset of the insert range, it can front merge and alter the
start offset of the extent. Once the shift sequence reaches the
target offset, it shifts based on the latest start offset and
silently changes the target offset of the operation and corrupts the
file.

To address this problem, update the shift preparation code to
stabilize the start boundary along with the full range of the
insert. Also update the existing corruption check to fail if any
extent is shifted with a start offset behind the target offset of
the insert range. This prevents insert from racing with COW
writeback completion and fails loudly in the event of an unexpected
extent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e7fa611887ad..8d035842fe51 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5876,7 +5876,7 @@ xfs_bmap_insert_extents(
 	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
 				del_cursor);
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+	if (stop_fsb > got.br_startoff) {
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d6d78e127625..113bed28bc31 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1167,6 +1167,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
 	/*
@@ -1179,6 +1180,17 @@ xfs_prepare_shift(
 			return error;
 	}
 
+	/*
+	 * Shift operations must stabilize the start block offset boundary along
+	 * with the full range of the operation. If we don't, a COW writeback
+	 * completion could race with an insert, front merge with the start
+	 * extent (after split) during the shift and corrupt the file. Start
+	 * with the block just prior to the start to stabilize the boundary.
+	 */
+	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
+	if (offset)
+		offset -= (1 << mp->m_sb.sb_blocklog);
+
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
-- 
2.35.1

