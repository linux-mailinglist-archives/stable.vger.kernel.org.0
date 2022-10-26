Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4005960DB33
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiJZGa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiJZGaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F71D43153;
        Tue, 25 Oct 2022 23:30:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1naL5024687;
        Wed, 26 Oct 2022 06:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=AZu0EhsXBGlWYaGEE1gA6PINQ8S6xWDUsLAUBqNMraY=;
 b=XRMxdL5qSsbLyHah17TllG0v8BKNwCL8LxXjL+eYMDfNrhXW8XOgxweD1QnJ/SLUTDwe
 +FlsAdRJEMfXRnn6dHOFpsn0u9k9JDHpOkLzTEEkmkKnGYS8CrsAodZCUioLA2FneSRF
 vSy8fFi7g8gDnv6eqJevwKeFJ7j/+rqOFr60efVEAtd5H1jWBhZ92UjykJ4eFZfD8f1h
 4SswbFh5J3mHEnK+aYhiqbUzivxKfGM3blmJUWwYkUT/cF64gsNz/SMG1eZt8bivc/rr
 ui2ND/evZ+mygMWemKzLMTZM8w2Vvi4qrr5Lll2RljrrgjrX7o4f5TVaPYoFvwt7tMjx YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnbj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q34WFe011106;
        Wed, 26 Oct 2022 06:30:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d8xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwv9LfOn5SYoVSs98XmCaLLflO1Xk5NMWOAGEYoNYY7Nc3UzdS1AfpUb3fJ9FR6j9Ob2lbnf0qyCbVpi+sT6KDFVMvMfG9erBk6P5dH3SkRZCkmLVlwZPO1s7zo6G9z7rdHfK8eu7vObcCBDoUbQwQjazuOWoO4iTl0eaygkJ4/tbcrx1fbPOj0orO1M8sCG4IfSdBqy+ft5alRCG7zRSfJKcU6T+vr8YbR8Nmh65HDVkGqfPZ3RGZzPtYJ/9kMcF75k8Cmpif5UXe5YUtDGcolEa3rrHNibre0uMdRzXOZTC/IK7WjrqU0IOsirgzFHY2Sg9pe+yAbGSoKmrPxsgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZu0EhsXBGlWYaGEE1gA6PINQ8S6xWDUsLAUBqNMraY=;
 b=bffrt9DWjXvuiRU85QwU/OOV+Ug6C8kUDKyGB0jkjVCNE/HcX+v2ILVhoGsw8l9WkabjRVHjW54hFRq9NFRV4R/FFzKQfoCQyTbjTo/IuqNNaxYhWN17VDtdnO+fbufoS/li4u5vjlOSuX0YuByubCf20FTEWw23Jr59qRtitPy/31jz47yxXYoo1hMBMcC/gWhYZ33tx1BwS33a94XRd1C2R0ifvjWhXRzpMNXysvBscFUZ4lltzA0wP8PK5eJ5W5PM8LsSXgVYuAzhqQ6Iws0D0u7lZs6Y0+927DujC2HSFcIVCY7lUxuApEM1MQPq9EfsPBWalQKGRQPSKMHrLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZu0EhsXBGlWYaGEE1gA6PINQ8S6xWDUsLAUBqNMraY=;
 b=ogEOrQ/gS4LU5/yQU1zjbeXg6W9nTdzhDkoNY6YwoAtvHONXB/yYtqzDcyKbROZWat7RS/Qk7gLoWSbNEoXg86VuZVTr15moYd87/W9bN2sQHriuj85U7DL3IgcOXwLwD87bRc+5Hsj5CypYm50q/JsdF73IEBZ9QbFqSzRgTv8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:30:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 13/26] xfs: Replace function declaration by actual definition
Date:   Wed, 26 Oct 2022 11:58:30 +0530
Message-Id: <20221026062843.927600-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0024.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d32e82e-c31d-4d8a-d129-08dab71b8ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +D1qfQCoDZjSQ8j78snBXp5O5UEQICOiodnRCujIE1XxCsBkhSRvprTE+uF5WS831QsYHO5vcvPhblDzsOItKPk2yTEfJGB4b708z8u+d8UuldqXrKbCB/DBw4UznMkG26SEnaTnsUDUe74T/9DaBeCJ4GkNP5TUvOcbFk2XDu0+3tP09t4EUYWIcdN0Uad+3IT5JyjuLpVQt3act/AhUgE+5HPUWuKDECK90gW9R+oPVgUBnqXzfRlln38dm3F+iG1MBQo9pOMNYYZzE38xuTttAKUDBa1/CwGrPuhEBVp+j5JEQ6hveSw/QGTIvELyfBvJjkBU+Es61ZVx/iSWLwDOxVQcvyat9wWdrxy9fDAdbkaefakK+KKJQ9k3GwxBZRYB5NJjAYLtBulECVJ+MAP2+aeF5TftDu+pXQ8zWrqozYELmWvzaJQTVDw2/0rVLJttklwJOx8DLExGyW41C2HZ2vgbrlpiEaqVN6l5eahuvIDaax/eu/a64G0rQR6Cyz7174AkIW3nN9UX3wn534wJ1/MPlIM6w2FRB0qgy85avq9xMkxLuXz0Scrn04NnB6GaOAl+wAzfz7nMB5yen3Vo5cFuDqTy40MhketULOIkERY1b2qX0E4VPS7QBnsBKB/N4Jc9977RhveLbftq1ZZrynQ/i7M1ODWoZg4shtp5luOoIoAO0CCQ6qhlX76b8Ph/Ma+cNRTcjw/rmGfOkUzCr6aaIuhlrqBIeDphsiDbbORTcabgleIeZv9VSxqj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYzhH+QOh2Z05Ty/JVd7slX6S6f+ZtZOPv2/5xTac13uo+e9X7nC7fTW45Qs?=
 =?us-ascii?Q?brwbEQ7eNIlHk9FY3bF7nz0UEd4zsbNZRiO+n4ID2oQohTDfp0C2KhZQAcUX?=
 =?us-ascii?Q?9ZJ1JP+4mXNOqh8srwb5Ytz7WwzB/M+I1u4MkwmPtBxEwbjs7fvRwfO+u0ew?=
 =?us-ascii?Q?47axXS5CWqT9MSb+qB5VTX4ShI9m9GU/cxcnaE2Vc975wxn/KAuFiCNyWuoU?=
 =?us-ascii?Q?Y1Xnv02QsN1AictL9kwcNcp0dnjBcxWzv5XAXZ+6KAq2s9f9A8lz283uDq8A?=
 =?us-ascii?Q?B/e26rot1HoGCJqqHvdVClfB2H+0WThXcvHtKSK1rKSl6FgwMDv+ZC2fOq6e?=
 =?us-ascii?Q?80VQDTos2H5cEpwHUzvxzYiNaUjAscjyxtMm9ML/ITGOU/THtNhADHPGuma1?=
 =?us-ascii?Q?IQLniCYdaPl0oKbpkqYwTKIDz/bbPCiJBKmOx5gbVU2KNDif5yb1LMDF+HGB?=
 =?us-ascii?Q?d9SETYkllgIp2w4ztkS9nS3qeyM8pTDXgMS6OHJEo6qykFAFepPZV4V9EZa6?=
 =?us-ascii?Q?AwKEw9eYXqjFUburfO7WNa8RD6E4pegFo8UC8f+hENnc5NEYC2JG6fu0V7PQ?=
 =?us-ascii?Q?pu5qArzG4gJGnOA9ZVg/zu1FOz+I7+La37vapcQf6lpGd3UGSKdFG1tRDNDI?=
 =?us-ascii?Q?MuwKWcPQr+Eo0fdyzQSMsnte+efnxsoEmJqONdzI7kw4unuAre6rslhL145w?=
 =?us-ascii?Q?Gn2t7hyt5kkzribEjsZEviyaHVk3eunmsOjEG0YMBEKv1zBr7xbdpSdIUB1y?=
 =?us-ascii?Q?TYwbhRMtZcbmwrAFjCUKzdGY0UtXjVwP6Vdg8ZXHJQfrJPGLjvxzZ2SEhzho?=
 =?us-ascii?Q?W/+hoKgVez5ecCfRGWqoC5i3h5Zx1UKILztx3PVkAjKx8r68O/JyJQezN0G7?=
 =?us-ascii?Q?kwi5d9G7x8X3pLaSV1mTq79eBr0PqbRxL/FIbOrmQFrqy0e3+wuVPq72cicl?=
 =?us-ascii?Q?FYxmNBkDLNoy5RuO4oHm3YmO6khOnc6KkPtYlUNomaKqoNCrWPi+L3seWufo?=
 =?us-ascii?Q?T/fLcfjmCw38pm89tNMPiKYWatEgEfK9hiPFy/eBu73CM89ZQPHChRsZlSys?=
 =?us-ascii?Q?Dc01UN4IdwPxK7B8Ru1/28Kb3XRpP6kom4D6doifMSClzDsuH4Wq1sQAFA16?=
 =?us-ascii?Q?M0C8CUljjfG0J77x0Qri3QhHtQZAYO384PmHXBuRXwsTuNuXjAQZmmrR5otT?=
 =?us-ascii?Q?F0pjl7bS3VEMxrp8P/QAkJArhtxtrxjy7Nzk2hheJn/OZiTtsZnd6hwNcgr+?=
 =?us-ascii?Q?nQIKHJb7LVbIHdcc0ny0LQeG65411ptxN5rnd1X9WgZ7GokJjvRRzsSVkbRU?=
 =?us-ascii?Q?6MvXdDLZgkmf5DRKPOExE1r6Vx3hF2wEwGNp3sycQm4g3zmuEl8XMPxrKa+B?=
 =?us-ascii?Q?mcUCEd3VMQ70QZCOebJPHrNP6IQGZkW7W+mzlFYc0otGbKNJnOvFmmI/fAyQ?=
 =?us-ascii?Q?3EQKQA9OlQzGKmUxv3El8nJYa/CNZpm96hhlg05AN6b71WvaGhxggO2U3Rap?=
 =?us-ascii?Q?mTTuRl3pSW8bPtK3zUocqCUmf0oobbhOWLO33e85oomDRjjrNpazn7SwiGmt?=
 =?us-ascii?Q?7a1hlVHtA2pQYQxI0FkXIIbdaZy4uCJUaujw49wZpaXeqh/Kx0JxrYWxCLAc?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d32e82e-c31d-4d8a-d129-08dab71b8ab2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:14.7508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVtVGUutU25YMiN52w+mcLepbLMC8O1VopFdvJp8119l2Yd3iAfz73SgT/AkNyUg/FQDi1p8XCTTR6Z7lsOLbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: NmM64YEV89IJqqm2s8doMUk6p7C6xUJw
X-Proofpoint-GUID: NmM64YEV89IJqqm2s8doMUk6p7C6xUJw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit 1cc95e6f0d7cfd61c9d3c5cdd4e7345b173f764f upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix typo in subject line]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_qm_syscalls.c | 140 ++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e685b9ae90b9..1ea82764bf89 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,12 +19,72 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
-					struct xfs_qoff_logitem **qoffstartp,
-					uint flags);
-STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
-					struct xfs_qoff_logitem *startqoff,
-					uint flags);
+STATIC int
+xfs_qm_log_quotaoff(
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	**qoffstartp,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_qoff_logitem	*qoffi;
+
+	*qoffstartp = NULL;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
+	if (error)
+		goto out;
+
+	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
+	xfs_trans_log_quotaoff_item(tp, qoffi);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
+	spin_unlock(&mp->m_sb_lock);
+
+	xfs_log_sb(tp);
+
+	/*
+	 * We have to make sure that the transaction is secure on disk before we
+	 * return and actually stop quota accounting. So, make it synchronous.
+	 * We don't care about quotoff's performance.
+	 */
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out;
+
+	*qoffstartp = qoffi;
+out:
+	return error;
+}
+
+STATIC int
+xfs_qm_log_quotaoff_end(
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_qoff_logitem	*qoffi;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
+					flags & XFS_ALL_QUOTA_ACCT);
+	xfs_trans_log_quotaoff_item(tp, qoffi);
+
+	/*
+	 * We have to make sure that the transaction is secure on disk before we
+	 * return and actually stop quota accounting. So, make it synchronous.
+	 * We don't care about quotoff's performance.
+	 */
+	xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp);
+}
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -541,74 +601,6 @@ xfs_qm_scall_setqlim(
 	return error;
 }
 
-STATIC int
-xfs_qm_log_quotaoff_end(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
-					flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
-}
-
-
-STATIC int
-xfs_qm_log_quotaoff(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	**qoffstartp,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	*qoffstartp = NULL;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
-	if (error)
-		goto out;
-
-	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
-	spin_unlock(&mp->m_sb_lock);
-
-	xfs_log_sb(tp);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out;
-
-	*qoffstartp = qoffi;
-out:
-	return error;
-}
-
 /* Fill out the quota context. */
 static void
 xfs_qm_scall_getquota_fill_qc(
-- 
2.35.1

