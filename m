Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D75E8CE1
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiIXM66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiIXM65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37BD10F70A;
        Sat, 24 Sep 2022 05:58:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OChRam000786;
        Sat, 24 Sep 2022 12:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=oB4n2xqYOEbQ7E8WjGBhNJQL+rlI+QnebNnN3xwE+Km7kbqdc024xu2EnKH2+f1jL7uH
 TsYVTmqIuz1MDKWpp4NC4smfBmP0PJJ3wwJ2TUpIiQYY4kIdGzGvygRuFzslAupcgQbP
 O0BaYw2/yRUdxDzA4v4T1sAydmzz2te5loYFMw/+Y8aJYPosF8Z8S+a4hAoa4/NUckrZ
 QPOap60CvsVgLd2XYlzpLigHksytS9fP+eBcqv7PjRpurDnikEbu8GutkjVkAQFEqXXZ
 2Z1OzOJ4tkxBTf79f8oFJGK7diygSELIkFoYUzP+eqNMosUoVQBXBGopvzsKl52H1P/j 5w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrw8h3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4dm7H021284;
        Sat, 24 Sep 2022 12:58:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gthw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZRHkTFOExbm7TPzmhAcPDjD8JWscyiR9mMVn8YjgsefgAVYo6gwGpE3+sVJL4tZ82M87p30YmQYhoo2CYakdIN8SWbqvq9oKbp9iMgZ8UuTbysbSAB9nk8JqWqZvtf6++3o6fBPhz2zltKUWjpz255zBw3Ag0Y2gjnfkA9hWdHcYth74RIkkwZTgyrQLKQU/vGy8HxDpLTr28H4QqWN8OKxa0n382VkyLQ0mCmeEMIvn93/r7rV6TE52baprwNBv6nN2tZF4tH6Sx1X4SO27u3ZnwTEy3jaNPwXzCHy9t27dHSINcjWMj+W4CbojPiJiYtEPUf63IxgRtsHATu79A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=cnLa+8J7xNOd5US6pY4UbNDKzOzxJYsfwNx2LnSOxrCR2l4Yp0ElRiBzgYWjh+JDSp9k3AEQO4AaC73oXL4tpn+6M0wOGS6VYf8e1LHNzSIRi/hvOcAtviXViKHAMl3X93vlHAqALOV3Qr0nDBfkpZAAIlJf+63dSPnmOfaKUDs0NZhwouVv5tY2oUMgdPG2xuuF+LcAJT7o36uU4dHPBzivoBFsQApNnHHUQ8GyErd5auUSsdEVdXrbONGCYEnI521QOOecZLUa8vfoGyOz4Ke1D4gvLm0RJT/pdoW8LEJIsmIFf5/Ru0XoQM/LpG6Hh/WGZ4ESO8DyHvWi4Enn3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=uV+amUAY4pyE01V7nVGk6taQr/ZsTrBBv8hkDb+4TrQBxYkcQS+jnBucf6dNkUq/TYFLrdqcqsT/ZwWQdLxBbO/SEbHgNw/u5mlisaJOmZbasKgis2aP1xnWtNCzYmgbFH34ULje3pyo0teG48a6k4h7coQscgyLl7zh4fW8ff8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:58:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 15/19] xfs: refactor agfl length computation function
Date:   Sat, 24 Sep 2022 18:26:52 +0530
Message-Id: <20220924125656.101069-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:404:e2::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 039f23a4-a6fe-40b6-2f06-08da9e2c8697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKO07fc3QneZtk0MK30Pc0Us9jiaJqiJKfTlO43EqpURRqvqGyHhO58GLyQAX7KCLSCjVxjh4V45Ihz28+2E23OEl0e/XOhokMtypOwS08ONsj6On+GEIXMK+DejqIKlNuH31ZXIcjPGCc2VT1xC69tomi5E1L9xI+JRAqe8nVLr5JbgwZxPWpRKq0RnrRCLvBevgersYhq7YXnKTi9LLACURbBYRpXiPq3gqbeD+U0ilUhc1QGcUHQCIYDu3EdBG/CSQNlgNjZHV1ULpKdOq1DeZWwf9RgXa3DwySj5Dd9Jlm1w924dm43GhcpbY2kAd6A76+CGmganth2z41haSN3z97yNbA5/abf0andIKaVxMYt4E7RXD3UguhqDiTrryPCQ74Pfo2RWR8VAGhDBi553Q+ut+Vo6x3AXIS6xVvpj3ChavyKmMFehAcIY8DNwn+PEG9BlZgrMCqbP3ATtA02oQHCuNfVOmQhLmcNoiCwGWwVl5jfaI/DZ4pRzkP+PE6DtMZXH5hE+G1HawYInSnLr9HO3m+GAi6lkzVbVRJF2LqvTAjfGpL7aI0cE75Gah5YsEuRGm+daWIXoRTCiWuhxtw3PaVfnUYfCYb/5f4oInDMApBU4OIeU4tZ17YyswxWP46vR5E03xR4tztj2RI11YbpNJ5fJ5MCzGFeSJKQUMBkzazLSISDBW9XVV8cJgV/cmEf/m12HUR5gSHqdlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hA68iItJfSP2N8OOewjWAwLqhbJZ4V3OvjMtBjZCs8gBRAeaEOv1UchHBYaL?=
 =?us-ascii?Q?M+SVZspAcmr8RggQTNh0OpeZHHKKs4zybuDSGMWtglv+/BNTAT+nOTi7QUZr?=
 =?us-ascii?Q?SFpZwIuM6KOZWbcyLwY+GskW3c1i+cgji4UY9kcpl3gEuod4T4RnFrq8lYQp?=
 =?us-ascii?Q?knxICKgrSKMDWEgC4WoW6/yVu5DTgiFyYE8jQwhfmxlwcKW+YCKumrmMBJrY?=
 =?us-ascii?Q?sj+qeLrR9nkylXzldivazsLbOOTlbdicXyzg591GJR4q3EQjYA9dU8e/p/Oa?=
 =?us-ascii?Q?nktNy3YUDa+tx0uoO02YNv/qr5/X1ucnjpt5A+l4iOBNDfPbJ7Oa0jvA+76r?=
 =?us-ascii?Q?kQ2tm3Z7YLMtiWE9Bp18TzaJUbBS25vlaWz1ViiEu+ASkTnipBLu+qzLt/Bd?=
 =?us-ascii?Q?OGrGZ02YWSyN3fS0UTwzPs8jc0Q2/aogKMx9qLIUbZplo88SmnFPiwjM6ES2?=
 =?us-ascii?Q?cDio9C4k24LhZahRPQ+/KLumUuPIva324rg9w06ztDtdJCtsZCutNmZH2vAt?=
 =?us-ascii?Q?M8IJi28e+k1eIkvDdqAjTxukegL6sWWBHiV2XfPsc3SK5j/vt5ssnUmhhSI5?=
 =?us-ascii?Q?TVN9gl2VU1Yl+c0xW6vOfopvgNQ/32tMjHMs4JC43XJVujcKzd95popWmey9?=
 =?us-ascii?Q?1l1AoIKW0/LJaSSl/IFdanUW3y2tncC17i6OzOYAoJwTEugCuPJ/dBSZ7e8N?=
 =?us-ascii?Q?c5+ATdusxE7Kyu4md9MMuwZmGVXCdPqo+grh7cWxKCZ+49rU0Czh1MsCKq+V?=
 =?us-ascii?Q?ALpepCn+hQZAypjksp1b+nRYRmabqPx80HBqBQQxqfikfW8N/WMugdmOIggd?=
 =?us-ascii?Q?Z0oafinhh7lyp/dwxEeYcbGSQ/Q4vDd5qcca716+fRM/epcFLOLDLZmMyd7M?=
 =?us-ascii?Q?F27LLcc2t6DwZJgfZ8tj/Dr4erzuPMk7PuG/rAY7Rf68ZzcgXD1U7us6dxfu?=
 =?us-ascii?Q?STNqXZttu2J+5r9yNcPX6XvrWvFTTLEmn+abJly88kbjFipepswV/yLvq5qP?=
 =?us-ascii?Q?x/VCauRkk8R+h8AXVYEwxfXYBJKbgJDrNi7ZS5+RHuaKxnIyEhrfSSHPXZHZ?=
 =?us-ascii?Q?blb6IIyuPqPb2l8Hjj19fdMwJoqWjW9EuFmsTaiMQZKwCADQ0yZsy1PMerDk?=
 =?us-ascii?Q?Lru3Eb96NVT66Iovvx3NEXICzTQOKMQXWbMGQx50EWTBD466yVamxuhj3k1g?=
 =?us-ascii?Q?ZCFj+nCtcpgqY00XWI+8se6IVr3ywsh2DOC7+p7ot7H0xju7JtsqDoXx8QTS?=
 =?us-ascii?Q?uqmtF9dIssBkt0/lwdlGrhvKAa/Th0LsfKaR8hV5fCyPmFuILVYqv07wo77l?=
 =?us-ascii?Q?2CeUUk5NQl/QgwbbL+UO3L0RiqJQOjYKKq1LZ+4GdHTJJ3+eNmkoCDwykstK?=
 =?us-ascii?Q?PjDwNsAB6gdPm4cPjwWwb7yQ6QA5/PposyKB8wpWcgM3S0GJ6wB3jLPfMYl4?=
 =?us-ascii?Q?7Nm79XnR9B0sci2LM89D2XfbAgpl/KBH7HnPcAR+XKlLUAWDX5I6J4l187CW?=
 =?us-ascii?Q?t500jevmQezydif6+eE97lGv9Mx9Auaw7lFdKS6cR1S4ru596g4TEWQIcDI7?=
 =?us-ascii?Q?3gzeh6Fc9qImdlno9B2Lw8MfY3hEiVS/z5psFIOJu0uPyW5UPXAGqwQtVKhl?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039f23a4-a6fe-40b6-2f06-08da9e2c8697
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:50.1100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55Tm2fwnLHXrUhu9jaZJTblKIZL+dSO2IfDXBOurozpqXPneZapy076aWjOgjWtc2r/hUGW5G3aCqrn/8tC9PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-ORIG-GUID: f4DKo21OB3PurwNjMdtLeXlVbLQ45pH8
X-Proofpoint-GUID: f4DKo21OB3PurwNjMdtLeXlVbLQ45pH8
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

commit 1cac233cfe71f21e069705a4930c18e48d897be6 upstream.

Refactor xfs_alloc_min_freelist to accept a NULL @pag argument, in which
case it returns the largest possible minimum length.  This will be used
in an upcoming patch to compute the length of the AGFL at mkfs time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f1cdf5fbaa71..084d39d8856b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1998,24 +1998,32 @@ xfs_alloc_longest_free_extent(
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
 }
 
+/*
+ * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
+ * return the largest possible minimum length.
+ */
 unsigned int
 xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag)
 {
+	/* AG btrees have at least 1 level. */
+	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
+	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
 	unsigned int		min_free;
 
+	ASSERT(mp->m_ag_maxlevels > 0);
+
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
+	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
+	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		min_free += min_t(unsigned int,
-				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
-				  mp->m_rmap_maxlevels);
+		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
+						mp->m_rmap_maxlevels);
 
 	return min_free;
 }
-- 
2.35.1

