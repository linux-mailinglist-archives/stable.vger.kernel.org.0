Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624A260DB4B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJZGbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJZGbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FEDA3AB3;
        Tue, 25 Oct 2022 23:31:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q5jTUa002596;
        Wed, 26 Oct 2022 06:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CGQnHw7geJ+a6cpWNSBDrSXBGi0uFrDXB3XivYRrllk=;
 b=1QltGGBp5PUpjGQlxyVxzAN5VoH4A1zhvrpIDHxRzSrjOGBPbPfVGWYCG47ceUqSemn6
 c/En+CxIWFlgnY00mFBSC+nE1z7yPlDn4Mf16vI8M3jhoRWPVU0jAcRuz2V/WohaVyUI
 Q1rzzaoSRoEKLSqH58BXChUo1hKng3YDwYgVGAsC21R4jJq7d3j5cOSkc4HvqamCt0rx
 VO85UK2IMGTErb0QE/iZegBPeZOYyrXqcfWI6H4L+T10KPRIU7lFkq+sbMG0F89svg/e
 5d1Vbz/Hnob+9N79Mib8NkTy4a0in/OuZcbgmEFf+HoJxrXiZzNQFQe5NFayRKsVYnGo bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnbmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q30D95031852;
        Wed, 26 Oct 2022 06:31:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybe9tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZfLIzlbTspgxg+LTo6/v9BJWSsXAnZNWlzN43UXbV5eeOcqRc67BbG1IHj9Knw3qtUB9JHKoGshPh0iVSaYxSF6tF/AGv7pETnyBBLNVqjx+raPLHMC1eZIu6SNtKzJD0lFzIOv2yOcamUmj2+ixaH4+uvcehkGyK3Ug16AKzkVNCYaVmb+3GuUTVafK3XABjXf5W+5yWX6KZMXsNEDzB7OAoFyAIODjzcZghHC9uB4r2ct0zdk8sltHhO4EBNM9jjdvKI998MyHKrycOu++Es7TpYqK+k0oRK7hRY/v+KIQ3aHuC0E18Nca2L+hBRehkbblA1sS0R83AqMzaBGLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGQnHw7geJ+a6cpWNSBDrSXBGi0uFrDXB3XivYRrllk=;
 b=kEy/RT5EYaGCqN/ET9gyFIxKVvHL5kSyfUAZ1GwMXnov19yguiR/Hunw49qrjD47TWoNvYcTHaghDQsuL/sW/4LR5nbjATxaYdh4UuXHTFi5Oad8MNpyIL1kbcFnrWjgnZzd6sBMX/XcNBYE8XBm9qLsQhFVo0qOfUyu/6GOjmwtTz+lB6FdFxbqYuuD0BApMhP8Ca4TYKQb4NjZxM2Ps9eUdPyXmFEEeh4EJ1bzCqs3tJH4pDQ0RUSBL/nq605evL6GKeYHUK3OKMFKaQw99H4ombwZ6bQ9tmCViHPGd1WCCO3RlgZmBSwG3900U8bgWxmgDRDmIoBzcMHGTQfhpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGQnHw7geJ+a6cpWNSBDrSXBGi0uFrDXB3XivYRrllk=;
 b=h53cr55vzZcFhgIz52IQGCWqbq2o/9uyVH9ka1alB+ukpz3vjY33lmws2eBkVHjhSc0+n6JAam5wiS9esZvYBMyt+ZsJsENf1rkoEBV0gN+y/A4a2m1n7jQ5Xx+9louno2qLhxQaUKzt1hYgPegXRxtK2yXx+NCdto9Ngdkrqi4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:31:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:31:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 25/26] xfs: move inode flush to the sync workqueue
Date:   Wed, 26 Oct 2022 11:58:42 +0530
Message-Id: <20221026062843.927600-26-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0039.apcprd06.prod.outlook.com
 (2603:1096:404:2e::27) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e3cf583-9ff6-4a36-be06-08dab71bb778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqX4G0LpHuxTF8iXXqj2xVvLjuz+Lvk3oaa5sMt2SyRUcvfedeEOczNTpKVybhOFsjxQfVYLDLQbstw+ZYffDcDM1rTEzYdPTOj/mL/CL8bgpMCVv+eJAl+AcZpNnWC6bOhapT+VR8UMa2Dk0FtNYw0+QA5ML9cnYeAz/QC61pK6irJHT/J7RlHeK7mcLZdU+A2Z68ogD6dlgX2NOSy/oxsfY64a9GZhZHTLHSMHDyr1ee90Z/WAUS/nqENw9l0RpG9H10UfDr/tY565lf8XM8N++3qsG4CFpt8lgQfM7mQWFrZfOX2OR5xxuJwZjzCzKDwmyMjZkzhjz6U5L7lCXVrWcnh/Tw0Mj01au45a4YP62UGU8QB8H1w7QUEf0bNIzJ/vq19BfuioZ+KoABgeRPPzGMElL2QEGrE2KLsTC4YbJj34Nkde0E7nlvcVWY9v5KBMCCPjzfyztSkWegeej22svK2gHBaSmCflDB1keqw6HZtb/wQFi15KNXIOx86oaY7YWPUmtsvvPJfAwMtJUOfq5K7YrfH0j42PFSs2gvY+H5eQ9JK/Ks2yPCKLLPudNEZKGOOxCoUZ9QtEnJK1mRNosEEaywNydaeoYzBgSnuESY6YBi+nJt0a9pu9RhWGYC2d/Nc4bajhOdFbfIBwiFJQ9O61tbrmmMYGgcOW25/E+XmTyiAFNLdg/KlnF0Yd2i5Nb6t6Bd2pySYP3HmYBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gpq1pMQMAx2pnYsR1WZf1ga9XsYxyXIEPVly5GjaR7L9FaJiVNExxVhWR/WJ?=
 =?us-ascii?Q?2gpSjRuQU252drIPvgPHpvrUIjN5V506G3sa4C4TAAL/KjGZPw8/YwmTfEg+?=
 =?us-ascii?Q?JQqXcRKjDxSPY0Nw0O9bYzSe3McVBkwZ2LsW8+KpcxpfzPeWBkVSfBBx/2Iz?=
 =?us-ascii?Q?8gE7EBL2u9TOqN3O0PlkBNxbxfrtIxK9iQLKVAia0zLffcfrSsZx0CxlCdXA?=
 =?us-ascii?Q?2VT7eEsYPKzp+T1cYyGo6GKMow1TdkU3pozONcaXvcLObD+ojH0obWD7ci0o?=
 =?us-ascii?Q?lT7mpNoGmO1qLvZBJ5i4vXqOzIyTYQeY/0Mi4HGWjNmyXrLIhCfHzKne89eG?=
 =?us-ascii?Q?M7g4QG6xHiVYEBNpZkyDpjIM+TBVHg/1z7qVRvdnjMBipoByI6u2fK09pCwx?=
 =?us-ascii?Q?6RbUBOymrQtgw7Z9BgK4Hnh9UWncfZVaNM0ZOCrY4wa6QmXok/wJQKiSDj6R?=
 =?us-ascii?Q?UzZnLu/LluWIgFVjevNXIBlmgNkpAt6mPAblJ5YRSysnTt9hK3UFYhWUEy6u?=
 =?us-ascii?Q?vPkzrzHA9CeNOdVQLAJcTgU6YpHY4E2nOJydJqQh41vaQCrTaheUX5cqVaEC?=
 =?us-ascii?Q?TCgFF7T8RIuL/g1OrB8Il7BJdqmhMAKgcU8yhEj62odztHbULq8PU9l1ZxF2?=
 =?us-ascii?Q?bSUohkhzmlOsvQKm31qChrm8QOJEQtcbRqwAy31AwD+lScLV6MdnnHxpmA6j?=
 =?us-ascii?Q?ye9XfCaI5PU44/C7Jr45W1K/fG9a23e8ULvQu7Dn9nTnCKhc4lKoU4086iqr?=
 =?us-ascii?Q?usPPVagJvJ94gbBxlvwjZ+k82eIh99BeoIgetYV099FDHfY2kew0yOPNUbI6?=
 =?us-ascii?Q?UxZ0VlK3R3A3nbUoJgTJwAy2O2vRhgxw/yuwBiWHy44Pe7dYEK4OyvFCLS2C?=
 =?us-ascii?Q?FWOArwDtVw7wr17KzdFwbrtg9erK4hUkIS+daTaaxsGuuZ+2+JN0UTkxrui5?=
 =?us-ascii?Q?rMKKMfCMwquKMQtyhVQV0DbIQ489lg9oyWe6AbhmaJ17F8pPG5en101gDCGi?=
 =?us-ascii?Q?8WWmmefVzi8V5KbmJk4D2nN2qaGDYCzBYmJHypPgYuIKYFiDhwftPbjtw+Ey?=
 =?us-ascii?Q?7SLNaB2Vqh20UFf+KdPBx7v/W2Px7Eyvlfut9QT5F9Sej5arqTHltmJI3yzm?=
 =?us-ascii?Q?O8dRSvjcxlDrIibeg6723PyG1WSaQp6+ljbUeI5N96iwmW8CjiceBvJFSMMS?=
 =?us-ascii?Q?fYGWSmS5AdT8VbsR991gAMS1AeTofPSLIjiZoW/WSdnQro3mbveju8b2SLDS?=
 =?us-ascii?Q?bjPeCOeRKn9OkIzwucigWt2rrJAnZhyFq0uXXLjwpDYgQk2xPdr8ufG59gxl?=
 =?us-ascii?Q?QQkCmVeK0HE5m1DIX63QNLXHRpdeMbpiKomSFScEGZwB90NVotKyGaWGhCm7?=
 =?us-ascii?Q?sG6u2LJklUS3Lbc6UCP5cV8rCeXav8iPv4RYr03AfYzCdd6Fe+9OhZySbDj7?=
 =?us-ascii?Q?S0G1JcQEIKY+XF78l9KvPp8UIhpyF8s5Ge4wKYGlVs+KeVYtNUMMEyPS2o61?=
 =?us-ascii?Q?XN92Ofx75e8E5qyvnVSdtjUg0uhXo2UVDAhllEzEh2A/aaL7F5Zx2NsOhuYh?=
 =?us-ascii?Q?09YoHzwCMnRiwduYgMqTpDexKT6v8HR3tQ+8YuTepzDFTpGULSiDsx1c5QYI?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3cf583-9ff6-4a36-be06-08dab71bb778
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:31:29.8520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmMF/ulbaengavdoHLdXZDCIfNfOW70voK3qwM/uNzU0iAAvDexa4yNJACy13bUPRJJP1m8ZWhrtucLrI0Hgzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: o7BcYcc5zCvN8CL3UmGRFuJn51CDCvvq
X-Proofpoint-GUID: o7BcYcc5zCvN8CL3UmGRFuJn51CDCvvq
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

commit f0f7a674d4df1510d8ca050a669e1420cf7d7fab upstream.

[ Modify fs/xfs/xfs_super.c to include the changes at locations suitable for
 5.4-lts kernel ]

Move the inode dirty data flushing to a workqueue so that multiple
threads can take advantage of a single thread's flushing work.  The
ratelimiting technique used in bdd4ee4 was not successful, because
threads that skipped the inode flush scan due to ratelimiting would
ENOSPC early, which caused occasional (but noticeable) changes in
behavior and sporadic fstest regressions.

Therefore, make all the writer threads wait on a single inode flush,
which eliminates both the stampeding hordes of flushers and the small
window in which a write could fail with ENOSPC because it lost the
ratelimit race after even another thread freed space.

Fixes: c6425702f21e ("xfs: ratelimit inode flush on buffered write ENOSPC")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.h |  5 +++++
 fs/xfs/xfs_super.c | 28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fdb60e09a9c5..ca7e0c656cee 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -179,6 +179,11 @@ typedef struct xfs_mount {
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 
+	/*
+	 * Workqueue item so that we can coalesce multiple inode flush attempts
+	 * into a single flush.
+	 */
+	struct work_struct	m_flush_inodes_work;
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a3a54a0fbffe..2429acbfb132 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -840,6 +840,20 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
+static void
+xfs_flush_inodes_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(work, struct xfs_mount,
+						   m_flush_inodes_work);
+	struct super_block	*sb = mp->m_super;
+
+	if (down_read_trylock(&sb->s_umount)) {
+		sync_inodes_sb(sb);
+		up_read(&sb->s_umount);
+	}
+}
+
 /*
  * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
  * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
@@ -850,12 +864,15 @@ void
 xfs_flush_inodes(
 	struct xfs_mount	*mp)
 {
-	struct super_block	*sb = mp->m_super;
+	/*
+	 * If flush_work() returns true then that means we waited for a flush
+	 * which was already in progress.  Don't bother running another scan.
+	 */
+	if (flush_work(&mp->m_flush_inodes_work))
+		return;
 
-	if (down_read_trylock(&sb->s_umount)) {
-		sync_inodes_sb(sb);
-		up_read(&sb->s_umount);
-	}
+	queue_work(mp->m_sync_workqueue, &mp->m_flush_inodes_work);
+	flush_work(&mp->m_flush_inodes_work);
 }
 
 /* Catch misguided souls that try to use this interface on XFS */
@@ -1532,6 +1549,7 @@ xfs_mount_alloc(
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
-- 
2.35.1

