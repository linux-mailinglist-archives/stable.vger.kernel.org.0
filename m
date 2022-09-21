Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C145BF448
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiIUDZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiIUDZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CAD32EE6;
        Tue, 20 Sep 2022 20:25:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28L3Ne3a019505;
        Wed, 21 Sep 2022 03:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=nuG+OODXZ9CLvQKEPTcXAZmPdnzT6PleEBET4aAjQEJ3EZH11Xgsqg6AeGg/ntBP35jb
 9nJvYDIjmmyWnUdIxoqvTy3r8ANuO5SIH8iBWXzCHTkZGVfB+UFsvBLOX2dlwU9kU6Lc
 A2NJfYyLGX1oTWnH972POp+8NGWrV9oPY36g4Xcrj/bGTiZRlic4c52HwJvQIG7bKaCD
 9M97+dzJb0/2aDP5eX3AnF7HFb4pe7sWHu4pyGv26DGld4XdDNpc1xN1BF05LdCcVRH3
 dh47TpQfZJSQ+TB/ZCmNGH4aewO/xR9kb+gSkObSFXC2orxVfQkkExZ1D9Ldl5knsESG VA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m90nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2BJPV035792;
        Wed, 21 Sep 2022 03:25:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d2yuy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJyhBmlO0kBKY9SB6FYAXyZNP0zZSNJzJBg7NDlGpLE8I8pf17GsJpay1jLkRaYT4kEtWsP4KmUMoB0H2/AA3Wj+DGUhk2Oijp3K/9zW+m16+/wFHHwZ1sVono8DvqjKavL84TzEr/BCobZCSpNxAB4Fi7pwYxneji7fjH1aEqCY74dOss/kBhAJ+isRYr3fDUEGH4Uf9apFh1Xl7fBa79v6ZE6ZeXb9iJlfonJoAlvaoQYqRFTqvJvIVPFk/uV1YIqCFmoJXwKrfqE/KwQtpnugAknNvSWDGqNJ/SRX1tOym02ciiYuEo4zdLAULGLTV1nVKiPZlNtVpugNfRrvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=XC/35MIMLE2K1UizWoAwwgDyd1eIAhEIMwqS2r4aRx05AU72fBgse5ImARoNCKFNPvYZFGRmUwKzijz+Rtfv7/Ql+fh2r8Sg07aSvfsm6hvf2wZVo264LhUAkM8S0zLxo1hSengzrA7p/BBFU0JPpNh6as5iaS3S7Um4/0b7rvmx/Sdv93+85Ifuf3jYv2eGrgXkZQGkCBEJlREZM5cfWGHyk3Ws8zBcofTyeNVlev4Fi17+Iod5BbTLfUUnQNMnUfHqpz5voTYEW24MDHypav6yoDvZv0q60DvOthsrlHtr4DJSmDjVBBym0ohm0DD9Ahvl1piaDBu+U0dS9xtmhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=rSqnXYIG2mqVHfEn2Me1A3yLjOrHdSx8Xg/NvtLqUuWgZVumg5r2Vl/h/+h6qkWENzPbTT8LSnZYluzxjcVLOue5UqQRiJvCKlWCQcCMmrf3qKftdgsfsPyiZQLP/qWDqSNe4gnKWIxEAAu1K3HX92noaZcP3pOYi5NYyPBNjiI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:22 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 12/17] xfs: fix some memory leaks in log recovery
Date:   Wed, 21 Sep 2022 08:53:47 +0530
Message-Id: <20220921032352.307699-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0163.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a2f350-7446-4bdd-7986-08da9b80ea9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AM4qvuFvfb+eFuZJD2Igzo06l07AV0lIDXe+elANGDCKDCly4OqZLlO0d3mrSbhiykDD7CcSYMaO5ZIb3pkRWLa3IpGc5bP4YgMeteh+VQJcZ9BrRsoxNdkDgdfH/6SAVbyJETVMph7ZKAmh8+6aDpyvBuKT+awF3Hp6hxPcgPiC+I4WWgE2KNpDNEYGkzFjYV97YDcyD9UiL1iMOvZ9myPGqzsX4TKBMBg1sAhFQu973wNkStRqtWNKmURNv/XL4+rSH8tDiMli30eGxttB/OA0z/UTz099GhMGZCHu3dAuSBxrbdfnWrSUbhyIIwgb7/O2kd0igh/BGxPMBlOZKZBRo2Nm8O+iNnXisUJogbRCxXiOdxGz/Z5Wpl52rR/JaeNdrHHsFKTRtnwpw5o1l+IFly5+iLKP5IhooUBVH+qtcLNliHWlWxKqU1lmLnN/KD2rAHYSmVH7xe1cEoIrJnmfkPVza07oWTnedVSV9sTcP2m7wCptHkHNm63EkpIa92QS2gb02aJnIPIMhQCkWMZhAGRIewPdCvoIBb8WRTI++vT1AvpgibRm0MFOZIfFh48iOFROd6Fl36o3BRVryOBD0ZG2ncW6US0NpiodLmltmYVZEf0XGyOD8Ayo5fXIeVQFstlTIACD+mbpE8aZRjwE9C2gPSMO8BbeEMCM49ZWPLJVQ1g/0K4ROVdW+rDt2asvPYM5rBQw1EGvNFO4lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ICoA9KwJAZxYFeUZpA5gv0klLn5xgUnY8SCeN9H8XQGXVIujb7j50SWmcw4I?=
 =?us-ascii?Q?ibsP2nzdt7FZ4VSobd9EM3TFZ68p6mJT55Aps9/uDwm2WPIvFHnCcIEdIHkS?=
 =?us-ascii?Q?wf21Y5VLlCh08Ik631NCF6xiyoiKdsC6RRx18Si7RizhfT4mzQdTrouRcS6N?=
 =?us-ascii?Q?nnzq7iDESKDh4wd1g+aTx166K4DTxBLkI+WHf8xUhn75jWXXPntl7ga271uW?=
 =?us-ascii?Q?7eYP7z5QOnhtATdWJ+AQjukZSPYJfNdtaJz3TPbf7khgUz8Aq55AAZ9kjPeA?=
 =?us-ascii?Q?eRjNP3f/rBBxj9dOLXljrQMZj6PB+Rw3SGpWgRWgyUVzdNk4D1uVPl3vXGdh?=
 =?us-ascii?Q?79qRwx4ci3uqDO6xxBszDd6lXg1+Wiz66w7DyV95TRLHEgkdA5gbSHIHvtpR?=
 =?us-ascii?Q?2pcX9sq00DTh/RlJT8sVHg4KmH+3sz5C9L3rUH2Wi4R4iGO5gjWKKWqyNvBA?=
 =?us-ascii?Q?Y8GrcsaIUdEj0GOe8Ige/3T/t+Pa1C6jJs/jXlkrxitiLQGG2JtHxBjEb0o+?=
 =?us-ascii?Q?sVLQdkgGq+QB5kz1S/kXszZro93pFLV+V5UpSsZDgQVn+8XrLy3BRv+ng8HG?=
 =?us-ascii?Q?MhI6aYivm06dvVXr9IEwwWU0Q+kzBUdFRDfFwTje97P7/xh3K1uEFDGceu43?=
 =?us-ascii?Q?0mPrF2oNDyjjsPH2V+3R2TGKzPi5Mv+fNAwsX4a6DM9Jv2aOSFimtOKFrQVX?=
 =?us-ascii?Q?qD6bYNZSlw+sZS1EjCFgOWGXbcfjEhuYIDT3bajO65kmnLnVwq2HI2ddnGzx?=
 =?us-ascii?Q?BpkS1lSZJ8jpaUuFcVYnVcErg6vAYcoodA0eOC2Lot5OPLwRUX3hX4c9hMAy?=
 =?us-ascii?Q?OvS3rSIgSV8XTvtjVR6PiP7ryVdl77IKYri98FrxYpH1QOXAMScghq/gHYVl?=
 =?us-ascii?Q?wGXTzYkm59vPp6SX15yNGsouZJLj3u3BmxSKCNNeg7z9h3ZMmZp6BzPsP2IT?=
 =?us-ascii?Q?CmwsiOfuGijadMHkXrL4CCMr+x2b9/VOvRdqBuQ89bP+FkAiiaM00JnBSXzQ?=
 =?us-ascii?Q?LQ46KZnKhR2bYEkL4gpYqLGiEGbSq8KaBFmBhYDrSo5xf5mfT1ZCrj6KwSam?=
 =?us-ascii?Q?Lj8BQnGJUZCcRSmcCwMdwqm+ZFacb8IVrwFdJYb/mqSkymamDjqI3Ee6vCZH?=
 =?us-ascii?Q?6GJWJYbdStx5aT12JpZdEqqDjy1fsMbszVw4TYrBZ36oCETJtBP0Vh9b3DDU?=
 =?us-ascii?Q?zLn2B9cVTaGq8LaDai5C6+cSTinWXlrUcLCoeM5W+IZaGBG9vLm8yl5XDLgM?=
 =?us-ascii?Q?RCLt4dhNKZT6XzseurQkqrBwL8ArRtY867NWWnNF9fUO4Jha2Ah8eP/QZac1?=
 =?us-ascii?Q?ZloBZ6y5MJxYibVzyY/Tztrw7vq1FVf5z7x09ycLw5txaKZb0mYm8n/JtqTD?=
 =?us-ascii?Q?KMeDoER3kAfNP+OZHqS8QLpl+RMEycMYpbJ4zNSH4pRNLSAWR5+4PxdTNgZz?=
 =?us-ascii?Q?+11CpU4dupwdww6meGumzrGQdYI/tiNkLQpFDegv0v8QyGWaAUkQ5NkItNi5?=
 =?us-ascii?Q?s73LkSQCGOsOyTXHmCV5hD6MjfLCmuW4hmEdNYiKp/whBaAMwpBq3YHeRozS?=
 =?us-ascii?Q?iRfco1sGDQhCJjmC4AMOnW01c6yATgMjZ0G4aU4cDYBWMhvGiVdfEHq6IR4B?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a2f350-7446-4bdd-7986-08da9b80ea9e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:22.2907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4svEAWc2yD6EjceoLtFe4unKKMZoOwxH2PKzVYfuI+nD9/0MaTUGSqcRUHXgawIVuN/KIHzqEWyzq9kt3ZUoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: Td32-YO_RzqpjmMzDmHcUMJDGMuWjuCE
X-Proofpoint-GUID: Td32-YO_RzqpjmMzDmHcUMJDGMuWjuCE
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

commit 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5 upstream.

Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
then bail out without freeing the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02f2147952b3..248101876e1e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1347,10 +1347,11 @@ xlog_find_tail(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
-		return error;
+		goto done;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto done;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -5318,7 +5319,8 @@ xlog_do_recovery_pass(
 			} else {
 				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
 						log->l_mp);
-				return -EFSCORRUPTED;
+				error = -EFSCORRUPTED;
+				goto bread_err1;
 			}
 		}
 
-- 
2.35.1

