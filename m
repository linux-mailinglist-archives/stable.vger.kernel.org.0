Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF415E8CE2
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiIXM7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiIXM7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:59:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED110FE19;
        Sat, 24 Sep 2022 05:59:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OBefWw030222;
        Sat, 24 Sep 2022 12:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=At6kFrAVBnbvJhEsLpWBz0hc+wWVWDa+8zN1VD/7Hgs87mb5R3CwAVThHX2qQDe7L5zb
 Lz5Pp5OEtbeIts2MTvM9Qv1f9Xgznw/wY0t0otY+TYkcRE3w/jY3T+rIu4EKMpIQIWV5
 HQiFMLwybXXHZXPJa0sFBy5xiCaqIsro2vN6J6fWL0NoQJVn6GQNNXuVJLhkeCGM0J5C
 hCUIQAb4xhTYafMoRRGJV1T5WtfkiuoRn+aEAcbDov/x3PQRckoz4rPV/WxYoeiZg9+P
 n8bYXdHo9yh4SsJodBbJn6MdvGHmuUiBdNgAI1DFcZtGxGZbKvrkdk/LyONhLYvgQDom Vg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssub8gjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d2s6036701;
        Sat, 24 Sep 2022 12:58:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s14d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BW9xcSRg01J+PHQ8Cl01O/QiofsO9bHSQfPHBVRUIxYcIyroG32x6kQdl/eeZ4LFWNHRhLy15LoPpe1zSwvXc0z9heuH+aL0r6WPOytXECc30wrrWfx9pBYxRsyl8W9G16UyotTW4QNtfqojXNwFBiCCjP2jtDdEgAA94+KQghqfs91GhjQBXzILcrbtd4WYEnSmQZrNhzwelaA+ZMjUdUzULZGelwgZfoJhMYboPkbPqUWvJuQpY/smtqwuzZy+dK1XxNLpxoLojE5r7lDjPqdej6JQWJlI/hCVdG9qg3i+3B4bNhZxBGXfU89CTmzTJ90hBKDW3QI6NavkIip6vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=GSkjT7/H4lWsnaU2yWVoGrvDLGpyHyQ1CCRg8VoZrIdr0GbQWckOnEdnGCCkPZuuzr+OofdogwSuW5KrzVpCr8Tp0ueGjpXkf34tZmfCtDqKgQSvTqz8pNSqZg7+JwykoU2yFV3LfGkGe1xJ0QfOo9Es5ESnCNDe7YXh48TN1UpsLhT8ZUlUooxP0pSfzjXVkopDeRIwgDMcWAll63GlrByIzTSxcrtJSvNbkkfxNx7piUjtexVFfbt7XSDgZ9JdoK2SZCDDIHmx7x+R8TyRGuw4LibePhxsivajn5IGYqCnFiQP9WvqKgraPSZiUAHl99ebghcnpukcWzm14fY9mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ag9RncpoVcywSr9KbfiCpt9Byd+/I1IVd3bbnoAnAs=;
 b=OLCQdfnL6qRlxiQl3jbdG5x26jMzyGwEjR7PO3NNiqHd2lXngY4ySGZobyoSRoLlCWV4nfkCgGqXZTWX+wJclrKyxbfzZEVCUdHUvyczbHxyRDS3pFmkVOacxFvjgi0DYO6Rn+z6UdIpGmqyzPW2kwyUsEMpcKhj9UciFJF6ZDw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:58:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 16/19] xfs: split the sunit parameter update into two parts
Date:   Sat, 24 Sep 2022 18:26:53 +0530
Message-Id: <20220924125656.101069-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0114.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 6beac056-1804-44e6-d241-08da9e2c8a8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RBYPDPzOaIyZBSSxncQbOahve8PznsBZaElY/hcwkxBAf6b7mUGnn9GtqXhtnuhOzzXYhfC5CQCRJU/6OgVOyGKOJuUjz0xqbI+x+hKr9FxSM/yAZQIhA2KYGbNFw0ksKZ8ghXa3x3x1lZhJR3Cq5wD7cIK/vZvxKDsfS8Offg+YCPHMoP+q5XFzB6UzylGhARd6nnvSP8fMgrKQA7stF4J+6Yeo2SwZb1Q7M61g78YgsTWuzIZat3SH3Fpo6P7x2eKIHEb/ryYzTguq3xmFFTWyOYbChLdwg+hbiLg7LO5Mnyg4HkgVCLCMVamTJIos4MFmMz9L3TfSqyYsKI6wtUAP4Q933O1Yk5rvo4tjb5iztU6l7QXqhK7+oPY6EpyPOjLq3wSYP9ODnGgNMoYvcLy6MPZ5cYEVl73s4rb4EQUJ8fXF+zgc5oj/MZfIwp3DWPws3uDjcRQ3DlA2kTURalNgtf+s03/TVXQcpMrLGhCwBSYiK5suooFV7vv1Y0y62JWAyIlRpjf4gXlNORGuGccmrdU1lHdgPkF6rOscem/JM5oVyyHRppcKxy3O4uW7ZuM8vqguLR+MubZyqYg+QsX2WGGwjx8IsuLyiwUgDU8LjqeIBOERFY3bVYGAEtDwFRiswQPCKamVfAEI88icS1MUhOARRnEFbfacPWwmIOpdnTfpI6X6E+2jAvphgV5+leIrAnoIktYu0lFQ1kZSPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(6666004)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(15650500001)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oBE0pjl4r6tDWuBFJ24AoHbovlTxbcrdDCeiY7LXO4hSJelFB08ubSCM2/5+?=
 =?us-ascii?Q?/HtQFp6BiwbZNAC/o4ylgFiIW9FeP5myz3uRIGXzZat/jp7q5Kf+pgdV0E14?=
 =?us-ascii?Q?AbZ2agXVHAVamAjorXvxSW+UieLicsS+y32nSwLGnDbQCPgNYNgFq5+0EEsT?=
 =?us-ascii?Q?r4g6APuyYa/3C+DsCKf30YMQnIaWYHO11eP+TePxaCUS6WisScuVWA6B8UGF?=
 =?us-ascii?Q?W/EGpywXSwFtTnH58PUM+XJnH/afqrgiIjfRBdprV0TTHeqJ5ZIXaDTmsdRX?=
 =?us-ascii?Q?HqyQYSk4Z9pDNKJH+MustvbRMn09irEWjmvFjqoIVyynQldyacHOnDxdBBCR?=
 =?us-ascii?Q?CE5d1Cu1ZGQvmtUI5S9Z56v6ES+wGS33SlmtHam/QrjNeHwLiVMA9WvcyBjg?=
 =?us-ascii?Q?g74KPb8HmQtqBodJ9Z5iX2ecVZFA3t+GbysiyPSJJy9k1yMmfLjtgNAXVv5a?=
 =?us-ascii?Q?KnN8/3z3h/v3n35FJ01ThIAcgsyj6WeZCPZjuP/fVr3k7PhQPsBol0grqc86?=
 =?us-ascii?Q?HqzPFyzhr4l8ko/ihaAcBHID8D8gI9oZjdRBHY/C+pi7NyjfBfo7yxCgpAff?=
 =?us-ascii?Q?iYNwoz7XWthVnNbDp5FWo6EekAnDXY702LfYEet5ZsgC32/P/FKpvFm/ogy1?=
 =?us-ascii?Q?C45ku9NPHWYXJ7RtwxtUG+Bv0aVAWiD4IAZ/JVIbsWY+OCQbE6aeS/gSVe1C?=
 =?us-ascii?Q?av2jgWhCF+yg/K3l7vAFA3QGaWay112JLqTY5grHavleoUtJdMtRnoDo1Hfc?=
 =?us-ascii?Q?n2Qj7Sei3rac9fymJY91E4zdwnOWiTsxcd2+Yl0IN0JDyR7sV2JZr8+s0ilT?=
 =?us-ascii?Q?bHMZuoV19SbzSCAmkxAHvE5wfW8bkSRHraPFdA/LUCHHsx3Mf93bpMAfEFQA?=
 =?us-ascii?Q?KCGKbROgrRHyRq2SYsUaNBlUYw1Hg4202NXYB5fEfXqcihGWtclAjJzI4tKN?=
 =?us-ascii?Q?eiEIaCkTOGBzHhKipW5Y2sc8GfKgRipMmsQ5vKikLoaGpvFj/jTPMtMLgPlk?=
 =?us-ascii?Q?o4NMOF2D42LFxlT6EfNkx47TKJr+OlHJFfQUzGsCrjteLRGt1dBX6PdbFwa7?=
 =?us-ascii?Q?gZP9zcJNup7U1gWcdEk2VzPCkR8FkJbW0kn4QxvDEln2IRto5LiNUm4j8it6?=
 =?us-ascii?Q?Bv4uQOfO3XIW/MZjqT8oAKEPPVrNPEU/jzcGjmW0G362PWwSf0ol/O6AeHDF?=
 =?us-ascii?Q?Gc/nYnMXu8toijQTCRYlvB7qZnb75sWClJnT82MkGf8KomvFImLhbrCQ2yhW?=
 =?us-ascii?Q?NSUIfuIZHkZwM439iF6b1+UBMLDVCPYXkBrSotq6NAbTUs4XxtNdJ2A8Kc5h?=
 =?us-ascii?Q?/HTx8cnmLf6tLFBiOFs+p29DtyEtTuxnxBtjpan8cSGdEpV9RpSzxwuEIqdE?=
 =?us-ascii?Q?mpvbxIW8ATlSclUswLNm8WXkMcLPtJQsH8oq+FJkxTxZdqZWMlaq7LcMz/A2?=
 =?us-ascii?Q?h0WuWeBqzNXZDsDVpBCrkhWpGBxFCfL5ChMoZM5Z3EXc2KN+7rRqdsC5foE+?=
 =?us-ascii?Q?r78P8N6hmUVwp4ztzw4lCquZT+MqbmB/EscBXDmWwDaV6CjcPMQhZB2GQJNU?=
 =?us-ascii?Q?temb2VcUFSqkkH5XCwPuQNJxiCXNiog6K+lo3aRAO7Su+2yGM4xSaaMd8tJG?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6beac056-1804-44e6-d241-08da9e2c8a8c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:56.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdRoUtGcFSvVYGEpNPpxt5yWgOL27ndfTEuqBngpIg4En7vDPO5dGAUE3PTeWOMjtnfKVYDbSfC9T+xKuKrYjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-GUID: yBD6z_IzvxInc_75MvYE60RHMfBNJDSr
X-Proofpoint-ORIG-GUID: yBD6z_IzvxInc_75MvYE60RHMfBNJDSr
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

commit 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e upstream.

If the administrator provided a sunit= mount option, we need to validate
the raw parameter, convert the mount option units (512b blocks) into the
internal unit (fs blocks), and then validate that the (now cooked)
parameter doesn't screw anything up on disk.  The incore inode geometry
computation can depend on the new sunit option, but a subsequent patch
will make validating the cooked value depends on the computed inode
geometry, so break the sunit update into two steps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.c | 123 ++++++++++++++++++++++++++-------------------
 1 file changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5a0ce0c2c4bb..5c2539e13a0b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,66 +365,76 @@ xfs_readsb(
 }
 
 /*
- * Update alignment values based on mount options and sb values
+ * If we were provided with new sunit/swidth values as mount options, make sure
+ * that they pass basic alignment and superblock feature checks, and convert
+ * them into the same units (FSB) that everything else expects.  This step
+ * /must/ be done before computing the inode geometry.
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_validate_new_dalign(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	if (mp->m_dalign == 0)
+		return 0;
 
-	if (mp->m_dalign) {
+	/*
+	 * If stripe unit and stripe width are not multiples
+	 * of the fs blocksize turn off alignment.
+	 */
+	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
+	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		xfs_warn(mp,
+	"alignment check failed: sunit/swidth vs. blocksize(%d)",
+			mp->m_sb.sb_blocksize);
+		return -EINVAL;
+	} else {
 		/*
-		 * If stripe unit and stripe width are not multiples
-		 * of the fs blocksize turn off alignment.
+		 * Convert the stripe unit and width to FSBs.
 		 */
-		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
-		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
+		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
 			xfs_warn(mp,
-		"alignment check failed: sunit/swidth vs. blocksize(%d)",
-				sbp->sb_blocksize);
+		"alignment check failed: sunit/swidth vs. agsize(%d)",
+				 mp->m_sb.sb_agblocks);
 			return -EINVAL;
-		} else {
-			/*
-			 * Convert the stripe unit and width to FSBs.
-			 */
-			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
-			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				xfs_warn(mp,
-			"alignment check failed: sunit/swidth vs. agsize(%d)",
-					 sbp->sb_agblocks);
-				return -EINVAL;
-			} else if (mp->m_dalign) {
-				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
-			} else {
-				xfs_warn(mp,
-			"alignment check failed: sunit(%d) less than bsize(%d)",
-					 mp->m_dalign, sbp->sb_blocksize);
-				return -EINVAL;
-			}
-		}
-
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
+		} else if (mp->m_dalign) {
+			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-	"cannot change alignment: superblock does not support data alignment");
+		"alignment check failed: sunit(%d) less than bsize(%d)",
+				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
+	}
+
+	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+		xfs_warn(mp,
+"cannot change alignment: superblock does not support data alignment");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Update alignment values based on mount options and sb values. */
+STATIC int
+xfs_update_alignment(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	if (mp->m_dalign) {
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -692,12 +702,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
+	 * If we were given new sunit/swidth options, do some basic validation
+	 * checks and convert the incore dalign and swidth values to the
+	 * same units (FSB) that everything else uses.  This /must/ happen
+	 * before computing the inode geometry.
 	 */
-	error = xfs_update_alignment(mp);
+	error = xfs_validate_new_dalign(mp);
 	if (error)
 		goto out;
 
@@ -708,6 +718,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-- 
2.35.1

