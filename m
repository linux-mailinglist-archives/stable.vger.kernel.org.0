Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACD760DB3F
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJZGbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJZGa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF32836EA;
        Tue, 25 Oct 2022 23:30:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nQql030372;
        Wed, 26 Oct 2022 06:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tvQT97mwKXAG3qEpqkQf8PyOnwa6+1aICe+SmpYulYI=;
 b=sf3bHUbcr5EneI8uCgKhAU0XDI/qGWjFPLhWP13Fam00OOgsa3JzyD7EfIE7/azfJBtD
 n6t86GL5i6G081GZyizgUm6xnzF1IPnx8KFXI7Q3kqH2Z08fwSmHzJYGBQADokarSsvw
 ZKCH00z2h7z60KBM7gmDmBAk0wQ+mthcy3sW1uQ4nrHQDExf4jnDyX5Y0KVAuCH2aGF5
 +wVJ0UBtiIBxlUz7wRmjGT+b6gfjFCxhD7NsIXyUQXZmTdp74cgCEJcGOAG/D6ktF6l+
 BIWrDhJS7ROB6xyvfEG6B0X4QjFzVP5tf5b0P+Jy2/OJqsHmQw0ViZnzpXEueqkJVKhI 5w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x24w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2Sajj013253;
        Wed, 26 Oct 2022 06:30:52 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6yb732w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+uDDqbrR9u2AFdgu0AbQFroXhFPAr4r//SQamOZssyh+IBMYPZno8jmXxGEiQknTPmlyC84MAhVuyEnJFeGUplTPnZx1vUByeG3oave5uJllNFtuKi7vaFVKpH5i9yw1CP7syvSVjzOPkR0aP07YH88Nc1WvCRGmMdj/9+ncsmW7ZQNXjxpZYAYdS7iiMET94YwEI7NZ7blDbSdaCiWGGiAtQAPFP2lX0CZvOcZ6uPiKwUvhwzXuHyzEMIZxqzYBG3HPk3rKtTRtVltwXgNpCfs6EYvD0kDpuExN3y5whcqVmiy+z7vQu8XJJP1+XDOuaEbLnjT6FE1ixjQpVr2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvQT97mwKXAG3qEpqkQf8PyOnwa6+1aICe+SmpYulYI=;
 b=B7R20wzEdvrhtmhCwp+yAsG10Jl+UyFUqg+gqMBVyTT5g3M/S0oMFsbjffLeYExv6q7+eLrITV+V56qD2NDX1OxjWVTFmlUDi/V/EVf+DGp/K0Q+BFBgTrhJ6sKh2cHxQJq+n4gD+mlnSq6DG7HExjlmvETfePvTl3hGzNm2+ZIu64VF71vNo5MAWXUDCYXwH58/ztaLF26WNxFEQ75ZgmCf9WbAESKyZXjVaNCgamENKyl5mABn5riTxstwttSWUCaXd0SRRaJRfjXR0SUQfcKFwEFl60+nbwgCR5mIGWNCOZf7Qo8ZinkCs2w5sTZX86MoBj9iD4+KQkrGrsuSRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvQT97mwKXAG3qEpqkQf8PyOnwa6+1aICe+SmpYulYI=;
 b=B8e8NIIv+5hNUI5M9pJLo0HvFiLiYRhnoSwKTPD9OKVcvskzeFNnH7fRwzyRSS56mB5NmE5RJGwGErCPoD4uEYi5ai6N1jLiK+BEDtnIi1ohCnzEjP3peFcik4VZnCEFhYy71HAE6rx6of2E0n6+Eav6yBHzumU/0p07YSG9Xjs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:30:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 19/26] xfs: factor common AIL item deletion code
Date:   Wed, 26 Oct 2022 11:58:36 +0530
Message-Id: <20221026062843.927600-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: f31a3192-5b98-4e02-72a7-08dab71ba029
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9LyPvhwGVFuecnPD1lMRqm11SdyodduhCJ2jQiRy+0Hq5TWLZKy3mrUXNCMAhSY/eZdOwfIcZbHN1VznnqJ9KUG+7jL/m/yFsni0uqXQcEkT2CKKQvrfhx1HQM38SZO2cSfDqjTJMFomz6e4LQoWiYwhjfhp6PVaV7rDB2IQqvQ6fUur4HSw+4g++ZhFa6NxaZMjRaf2jfOnPUpr9A6q40JrNRSYglEzqCyAPzPygVxnhGCRPr4m21lARTCA7DWwOoflbWKYQ+qyLmebZp/IeQGknxoh0LUIBjrbenL8F4r8xs3OQCrmGqx14vrAZwfLDsv7fWLebA4aEAJNIqDxEoMITpcAvhaKNZtwnRguz2Kmr3oe13i+dbqypabyEVySnGZ+lW9/i2jJ9VgJMVomYQk1AnNoucw+f+VzfQRT/lYeZdCo9CLTe0+AEq7aZr5+0VXLW4ZHYJL+rLZdxTfzHKnInWTw/k8bBUcLq2//EMg7zEtdPET7JEHYAxJachBXUEFUX5za3qovLVbkwhvZMqtHNHBn0mY5aSdaPV+TG/CUnTwAHp0hG/yhdEwhBHrqoSVt1qI46LMTwNncEvIMOmJHYqr5DqCQ63sqVpQ5cKPL47ApTbmJx9yRD086UFg9m15n3A0IhVML6T5TrHZuBC9g/Paxxgs0hsXpWuwmd8i3D2dEJNEGiZaa+7oGpC29/VT9R4QIyGPGIFSef6VZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DNi3QGeYtn597WG4XVAphofYcpPGkqGThSBTGMDihSLFvqrkFYt6ja/yHRNP?=
 =?us-ascii?Q?Awr6PNf97ghXVwtFBjv/wXjJmMwU5asGer631EcPKifmIUHsXTwrH0je8zO+?=
 =?us-ascii?Q?Bhr+5VB/+lOnMtsO2YxjI11irkUkTF1vcIDcQo41PGXgdzAbSGDlSdJMIMuI?=
 =?us-ascii?Q?CjEV+2xzZig6FnIWpVc2MqBy9FJhVjNs1ZpaJEOsTHmhhso8FO035HGmkE0u?=
 =?us-ascii?Q?6skc59yWztiIQYsxbl/1SdzLJNe3CBRN6eChjqPVR0uOTBNNZYNNNE1VSKQi?=
 =?us-ascii?Q?rLsuJcaoF+D7IvH2oMUZiZqDqrjtEEtCuwm09zK0uIDw22SZZ+KHB6j5B/sa?=
 =?us-ascii?Q?yMr3On/0ZV1iB2Ujpm3u7lmLfusOqGZy+jJvoB8RG8DUe8+Jwjo8wU76Zk5e?=
 =?us-ascii?Q?jdmPRPK3f7Iub+5l6uKrWVYb6wryw5ggg1a2SBkYf8V2cOr6088yehjA0pW8?=
 =?us-ascii?Q?YsAgB0pXRB8Vjf+/RyvW5SqmhoN5hdsUpCLOE+Y9Xedo9mI1j7hCUoHpaVHt?=
 =?us-ascii?Q?ATHFO5ZXENy6k5zBC6gYRf2CgjIAF0ikJsoBTTHW/oA8J50zqGBKoOFGTmmI?=
 =?us-ascii?Q?pSoBu5T3O6CsMW5ZGthJV42eRjUTV93C3gFZieRA0SH8YzQbh5l+yHq3U5xP?=
 =?us-ascii?Q?syctOAuUJ/Ru4nmip7MFGoSlfu3cwb6jrAyhemuII9etj9Dd4+4h0PpX6B+W?=
 =?us-ascii?Q?1l36ieryCKrO1gJMNw3xfqllSmYFLgMdrvOamVKlosDIKA1GawQKym/C4ZqV?=
 =?us-ascii?Q?+pENfWJ3qTZtTjm2EMd2bGwimWqs63Qly5nfrhabXveNpRK8/b4bkkvagoSn?=
 =?us-ascii?Q?kxLVr4wnFUzsnMB3PEw2xfbyuF+oDcPU+5ZEYNCNkz+7B1Lm5ruMVY+mFImn?=
 =?us-ascii?Q?7zPMKhqRCHbEBcdK5KMThbxS0Bg1olcLdSU6XL1WmAK/LtHcVSj6G/wnYEW2?=
 =?us-ascii?Q?e1ROXXCyWwn+7gKDdKBzrsYQhbcxffQSBB8NMiaJNJ7+Iv69KSjUz5a196aY?=
 =?us-ascii?Q?u5xvb9s9/JzVkLrhyQC8npf26JJqHSKdgLl9IUCEvEQeBu/1DvG+168wTQ06?=
 =?us-ascii?Q?k/HSaVcXkClHGWjj8UBcN5iKVM4MpbTzb2meJsg6P2jAGu/L7neT1D6KlWQf?=
 =?us-ascii?Q?JfIt/OBZDQfWgpBODgfEoexVpuNsjcnptU28Exy7lJrk4/K9OyfTcTjccAK3?=
 =?us-ascii?Q?8hcpJ/kb3n/3nJAbUJ9aAXN0oKKHs/Q+11sBdwSarTk23uwdY1/GBgGX1qPN?=
 =?us-ascii?Q?ulyZzo6OwuufJX34t21YOu6vSZpBAON2ewW7cWyd34Sraj4NKAjq8qN/zKjg?=
 =?us-ascii?Q?OoUpObfn/c4mX8QytPPhpmC+zRf2lxIHDpi0hY9Pl6cBMB8zFK/sfT0iRYVS?=
 =?us-ascii?Q?tRA/AnW/WMS4hLUvuM8Jy56KKBGC1scLNCUQJySvCxtxNFs+AjdFAHktEczE?=
 =?us-ascii?Q?LLzFWvb7y8fz7uXozPEnv44KwzBbcZCk6krPZB8PFo+QGk7UMa4zDX3155C9?=
 =?us-ascii?Q?BbF7LxXbeaz+18mrm5FdwaHM125CF4ow6UlbCh0sNWamF9UnAJZt827KKxz4?=
 =?us-ascii?Q?Hd9kDKgsM36A8D+LwnIwLnLFonDq8hcvgM+doR4tK1TZjw3LA4VcN644KTbf?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31a3192-5b98-4e02-72a7-08dab71ba029
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:50.8229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5HP+nJSJOx70x5NHU9y1+/Jp7V+xuSKn45RlukULTh7b9h3xJ5MA/WiSkEs7hOMg7SAOz1InQV0HIf0rL/RaRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: MLRFa2E2QtlpZdmFzyIITH13gmcHjSm7
X-Proofpoint-ORIG-GUID: MLRFa2E2QtlpZdmFzyIITH13gmcHjSm7
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

commit 4165994ac9672d91134675caa6de3645a9ace6c8 upstream.

Factor the common AIL deletion code that does all the wakeups into a
helper so we only have one copy of this somewhat tricky code to
interface with all the wakeups necessary when the LSN of the log
tail changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode_item.c | 12 +----------
 fs/xfs/xfs_trans_ail.c  | 48 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h |  4 +++-
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 726aa3bfd6e8..a3243a9fa77c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -744,17 +744,7 @@ xfs_iflush_done(
 				xfs_clear_li_failed(blip);
 			}
 		}
-
-		if (mlip_changed) {
-			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
-				xlog_assign_tail_lsn_locked(ailp->ail_mount);
-			if (list_empty(&ailp->ail_head))
-				wake_up_all(&ailp->ail_empty);
-		}
-		spin_unlock(&ailp->ail_lock);
-
-		if (mlip_changed)
-			xfs_log_space_wake(ailp->ail_mount);
+		xfs_ail_update_finish(ailp, mlip_changed);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 812108f6cc89..effcd0d079b6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -680,6 +680,27 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+void
+xfs_ail_update_finish(
+	struct xfs_ail		*ailp,
+	bool			do_tail_update) __releases(ailp->ail_lock)
+{
+	struct xfs_mount	*mp = ailp->ail_mount;
+
+	if (!do_tail_update) {
+		spin_unlock(&ailp->ail_lock);
+		return;
+	}
+
+	if (!XFS_FORCED_SHUTDOWN(mp))
+		xlog_assign_tail_lsn_locked(mp);
+
+	if (list_empty(&ailp->ail_head))
+		wake_up_all(&ailp->ail_empty);
+	spin_unlock(&ailp->ail_lock);
+	xfs_log_space_wake(mp);
+}
+
 /*
  * xfs_trans_ail_update - bulk AIL insertion operation.
  *
@@ -739,15 +760,7 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
-	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
-			xlog_assign_tail_lsn_locked(ailp->ail_mount);
-		spin_unlock(&ailp->ail_lock);
-
-		xfs_log_space_wake(ailp->ail_mount);
-	} else {
-		spin_unlock(&ailp->ail_lock);
-	}
+	xfs_ail_update_finish(ailp, mlip_changed);
 }
 
 bool
@@ -791,10 +804,10 @@ void
 xfs_trans_ail_delete(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip,
-	int			shutdown_type) __releases(ailp->ail_lock)
+	int			shutdown_type)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
-	bool			mlip_changed;
+	bool			need_update;
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
@@ -807,17 +820,8 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	mlip_changed = xfs_ail_delete_one(ailp, lip);
-	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(mp))
-			xlog_assign_tail_lsn_locked(mp);
-		if (list_empty(&ailp->ail_head))
-			wake_up_all(&ailp->ail_empty);
-	}
-
-	spin_unlock(&ailp->ail_lock);
-	if (mlip_changed)
-		xfs_log_space_wake(ailp->ail_mount);
+	need_update = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, need_update);
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 2e073c1c4614..64ffa746730e 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -92,8 +92,10 @@ xfs_trans_ail_update(
 }
 
 bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
+			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
-		int shutdown_type) __releases(ailp->ail_lock);
+		int shutdown_type);
 
 static inline void
 xfs_trans_ail_remove(
-- 
2.35.1

