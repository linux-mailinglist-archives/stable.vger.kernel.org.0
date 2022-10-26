Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FE460DB30
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiJZGaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiJZGaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E5224970;
        Tue, 25 Oct 2022 23:30:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nEj0013483;
        Wed, 26 Oct 2022 06:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=laglWZhUJgEY0DSDAP5AAl3xvn2qtfvmD+F0Fp6pQ3c=;
 b=SICxmu2IEWk9VKZOi5LrAVkOQHkpdLe9aEBUioFVhHTTMyw59dn0E9qwtLIGBdje6g8Q
 pB1+sMR12zRjLWteqpXDIW3wX9D+lx0K/EL8wL2pM9GSYaqCI9pRKbtE4kTOqMVOc6/c
 sgjGEMIyrunDp52XFsLrL7NFvtpnFyhz6Vvxn0yja/jNm6F5TzCmALf3gP99lO7yLTlx
 UqqMP+Ec2WoH5PGw1MPTtsNOUTTY1A1DX3K8puoX7C5cseA7egw2fOcbiVmEXuPka6cn
 IHPf19cFjkw/8hMC1T0hpommtQYKZtQO/B4AX3h4S2dcRqNKcb3vGPBEH5p4EOd1WgzW LA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84t5hj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q31XV5011081;
        Wed, 26 Oct 2022 06:30:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d8g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f91XEx3bZJNw31llfGIsx6LPxXqoepuLLlsCiFXjmgI/PqmA6UGq7ue+MYTPjwXojNIpBcUGqby269bVV9w5CIOa9IG/2k+h7p2g1ps5tpvmpTdGMcxxwWb+wcZuOyLikydWgmb8Pn2X4ie3dST+jcClLQ3qbPUQgpqhh6SDumi/kq6vpVb6Q3mpne3V5vYkxBWB2P8d3ilOAlZJXMcBQMObBXN0S3U98z7eQecTKsLApOG54T4luE0K7RwppZ+ui2OnKnU4ePZiZJsKBjfpXFbe7/+7WdlHLxSP+gH0kkgVRQkjShun+vvSraesgdMGdk8SOJuYi/miGTj376KVpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=laglWZhUJgEY0DSDAP5AAl3xvn2qtfvmD+F0Fp6pQ3c=;
 b=N+Zyp2sL1P/kFxpGygwrPoprYH2+ClNaFag3tiWwKa5F2PGkxptyRKiARtEMCx45vqMkXdHHnD/a0uq4hCf4DhtgAf2J4vRLnzo6YaMngQYSilgJB9h7ywTZzOmaL0jhDw4ZV/9uaQ+cbIT7tLzM5YwVadFwm05wFfcKtXVdbBbuVRbjKhaOrLzNVhgQ5/EQshaE1za+txrrBYU/n4IxgSlMifmY1SHfgmdgXKq+Rtw46sORWtNfZ/+32IaXA8YVy/RULVsQMS+s8HRuc3RMrd6+XMEE4u/o+jlgPgl9Wkh+myAFr24ybtnRN4ozIQsyqpVAYMDoFnwoytN9d+I3yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laglWZhUJgEY0DSDAP5AAl3xvn2qtfvmD+F0Fp6pQ3c=;
 b=F7C/lrAnTDw1++d555BlhObKPPmRdbU5dqg7GTWx7JnAabUdXdbQEFOHqzcadsOIxtOrbVQlNB6OgKy/y4/kC1n7Jg4gOA3zHnPSYu/mjZZTLfXA5lw4V68ie1Uo1ZqL5VrfswZBLwjzWOXDTce+5nlf45AGbvmFnQv7dcD15uI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:30:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 11/26] xfs: remove the xfs_dq_logitem_t typedef
Date:   Wed, 26 Oct 2022 11:58:28 +0530
Message-Id: <20221026062843.927600-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:404:a6::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f6b4f07-27b2-46c7-e82b-08dab71b82b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qhGsUnyyFawsWDP+0IMFZ/zbBF1sbUi3rdRLqkX6HnrapGSsGrF170GrKNLlurwB4SfZL8BBgSb1pALGXe4XblP1jxhh1wB3tQTGHyc9K3HB6jtWps/eUlRJUM4L/JirrBOBmjW66tiUEuuuDSsh9xNB/LlR04loAlciI9Myb3PWR6IFyZt0yjznWGbJCos9rIySXlQhgImt38LTE/KhDTMFf09H4payJatbYe+GssIBtm2wsAJZujy4iuHnKTJ06EnZU0aT3FQ0WaQEwkcd/ccFT+4X9A+dzKinFPfzaMeYAEhm+mkYcNoLsiZzqw9Fu3JqLbJV+w7NKWr3NjIjnrCyrlI4JcbBANrGr23U5U7FPAYvzZRNSEBZ+LVoRy8RSaDdHMbyi5StZp+9B3ieH1Eu5COrSkOye8pO0H6bwzFD3QxL1FKu3sE2gOcUTaeOZKo3HgHq50fYATOdhI8Dre3/84EjOtTNfMmXQ5yMomjgR4ZHvbTxr99sN2WiPN2OZt/n/tQ42vS36IQ4BtcRkW6odbuVg4mBMKxCEQ3P/LoCPEsYgIpkOwTDR0Iwu2GWlIdXgl4l0Y1lWjcb84Vyd82YJqmqWIfpDMTM8sUpo5bEwXq/CV26LLf9emAd64wbK/0TiAjl15jdfqM7CRIApbXhupIWaRLeKj4aIqN9Q2k0N++2nc7ooqSq5YRTByXwT+CZdCXCp62Nz6eY363KLNxnqYGfCWqZ4YZAyVs3G+E0QWrLBrYZy3Jf2SsvAji
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4isE49MnvEPQQWVOIVjpcD8N7iYYDlnz6JpeKnXSXZiRN3ZUz8Gl6R9ON5lF?=
 =?us-ascii?Q?DeHgH9oKJa9VyZv2uW9aszUq9PrJ27mIsEDOZcIzJv11L8kNNoUOmaog4hUq?=
 =?us-ascii?Q?DW3oEIy2ieaT1vqd9meJ9ejt0nOlVI1Ykk5oY2D3a5eyhJUypw+yXW1bfGjU?=
 =?us-ascii?Q?WBGJu2nsVNtgQvGDlOGhz/YhA4ewBnLcH2RiUoWV16Q/P/vlhCVebcF9/KXM?=
 =?us-ascii?Q?1k57P0uXdfa6EqYzu7LeaGEwc5UojZp4CVcHSiXLRz4ZvD976nZd9QB5EKAt?=
 =?us-ascii?Q?YE5zbrYKtPqxjSDdeD10C/SWMuRXfKBVQb/S1/r4Ldu5nHcqovzwbrJrLbZW?=
 =?us-ascii?Q?JWaFQerla4DHDblfG5y85r5hwZf9W7ELfn/XLySDoJ3kdAP2mfXnWzfSdOP0?=
 =?us-ascii?Q?EPRknwkALtvsMDTUex9XLO9bs+EUcBgtypysUYbkEwesZQmlkVAi7YicGHRx?=
 =?us-ascii?Q?83dYrZgSYRtPl087IQC2+lhbq5ZbFzXHeLn3V4t7GQtXcml4XstN4KqAMCvy?=
 =?us-ascii?Q?kSEQe3tvywYKHh4NcTN9ytYbK6L1muj5TiilNnDPWWJh2qJ5tQfJX7q5AKQx?=
 =?us-ascii?Q?IbyMbu+WC/SFH7JgN9MIr+guCa0IlpGcUtNwZHzupYUu5PunfG9XUWwctnFt?=
 =?us-ascii?Q?e5FACuj1b+oUnsIuDkfT9S5xxz0pmzv3/StGmThLmJMcUEdpT19tvQadhg5k?=
 =?us-ascii?Q?BSzuQfJcfBF2BRkLXst5DEBaFYJugHH+VyzXfElGzCnPDy9SuTL/QgJWx07m?=
 =?us-ascii?Q?vLWIbyHzoJ7E/47ZSUNz6tzuuhYWpp/7/CuaP4CnzZgqn2iqrG8Qr+96phzD?=
 =?us-ascii?Q?KC/vnLUq4zYxbg2YAbgEdrs6D4IfEP3FYxCd7z7SX0qkJqmogDhmt/YyBC3n?=
 =?us-ascii?Q?6nK4OrpLE4MCdeA6V3pRfoZdB8fgM2KYPjSM8tNeKo1/DZPecTYYruY9uUdC?=
 =?us-ascii?Q?V7kOgx7on3L4jLfn0rVJhIqvYwGwQijT3hjEplv7/IxpypMpCxdZU1kQK+C5?=
 =?us-ascii?Q?2dtgv5kBl+jeL83DgcMAb89DchGXI9v6kq5H4ee7aXO/lrTo3sgc9T11r5U5?=
 =?us-ascii?Q?tvPIgUrvYT0OnJfD2CAu0q00Fv2GC5IFf8DOv9dZhvVGmPsCHiRngIE39MVV?=
 =?us-ascii?Q?gbVbBgzWcRYPFxJaRMp9crM2sTQ2ZpVUloV5kGG1j7kNOFrYRtJ/tl1DnV7H?=
 =?us-ascii?Q?M81VUmv8OZgD7HccMNmFeQYtvzowY1jKP+Q7Woiv5QaxM8azgm2GB5oDtU4R?=
 =?us-ascii?Q?r9fdZIBqfS/dLsu5dgja5ds5w5HAi4I+Npi84dfmfTrs8FehhXDbQ9bIDr+1?=
 =?us-ascii?Q?sWEEYEG3x/PIYDCXIdUqmZuAfcCbBFxigS/wQ19jRhwFp29JyEiYJHqnzr0Y?=
 =?us-ascii?Q?a6LktsSb3WNH2PMl1uKJUuj53z7ORuTaWny7zRPkGYY5tEggfUd5Rt2lqimL?=
 =?us-ascii?Q?SEOtscOFg5T5SsSksq7XMW+zM5Dxd4ktglHwqGGM+E+DSsI1OsPFTyP4dLCd?=
 =?us-ascii?Q?nPFVRW0sFDesmnzgqPpusGvBASqMvhhK38bbxBiJYcvRK5SX4wZF1NG8Xdi8?=
 =?us-ascii?Q?QOMU4GlB6xzn8ILhPEWD88g1bcqBjHSTNbzZ0F+zRjqVo4tEfUtnKGVSqMnb?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6b4f07-27b2-46c7-e82b-08dab71b82b6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:01.3558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0468STD1A6ZzRv2qYYWkz6pM6N/QRxacwjUW2BSMd7GutkcF9TknHZXwkk16A1TBFR7Q2vqzs16XFGpRsSPWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: ReYW1l7WQW_4OgyruxAwwLj7GWMfSTdz
X-Proofpoint-GUID: ReYW1l7WQW_4OgyruxAwwLj7GWMfSTdz
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

commit fd8b81dbbb23d4a3508cfac83256b4f5e770941c upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_dquot.h      |  2 +-
 fs/xfs/xfs_dquot_item.h | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 193a7d3353f4..55c73f012762 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1018,7 +1018,7 @@ xfs_qm_dqflush_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
+	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
 	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 831e4270cf65..fe3e46df604b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -40,7 +40,7 @@ struct xfs_dquot {
 	xfs_fileoff_t		q_fileoffset;
 
 	struct xfs_disk_dquot	q_core;
-	xfs_dq_logitem_t	q_logitem;
+	struct xfs_dq_logitem	q_logitem;
 	/* total regular nblks used+reserved */
 	xfs_qcnt_t		q_res_bcount;
 	/* total inos allocd+reserved */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 1aed34ccdabc..3a64a7fd3b8a 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -11,11 +11,11 @@ struct xfs_trans;
 struct xfs_mount;
 struct xfs_qoff_logitem;
 
-typedef struct xfs_dq_logitem {
-	struct xfs_log_item	 qli_item;	   /* common portion */
-	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
-	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
-} xfs_dq_logitem_t;
+struct xfs_dq_logitem {
+	struct xfs_log_item	 qli_item;	/* common portion */
+	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
+	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
+};
 
 typedef struct xfs_qoff_logitem {
 	struct xfs_log_item	 qql_item;	/* common portion */
-- 
2.35.1

