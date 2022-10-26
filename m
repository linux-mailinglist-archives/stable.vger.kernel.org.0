Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B04460DB41
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiJZGbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiJZGbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495528A1CB;
        Tue, 25 Oct 2022 23:31:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nFTs013699;
        Wed, 26 Oct 2022 06:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JrXKkUmxVHaPEkFFh48ZrH51Yr9psUizxhiXFkwjZ0A=;
 b=u8tmmLtADIass48SGHQi3xZmV22Ftdg4P1nUYna+PS/EkmLZqAq4dJ23FwYfweZX2oER
 vTYGJWJcJ1rcG/ueER7QsLNA57SOKgW1Z8nP4Dp3JJ5omDo7eSfRzyoOEKPug9EDGOai
 JzyW4HkoZG5J6ZH59UadEMXB3uM4vz8CNs5oWSQG65IagvldFsUgo1ATqrhp8DYfBsKX
 ESd4+LKefcrJu0EgIppVVcV0qm5LmwcEP0WDkkh30sialoSBYyia+nTka+sptEEkgPik
 QnuhuveuDs9VtuFSYT4c5soEOh6n+VgDo3znuAGJnlewv2+XzIH8xcQPO919QqCHnVNx Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84t5hm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2wgBq017877;
        Wed, 26 Oct 2022 06:30:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5myaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXIXBTy1WMzKwRB57l/X3vj67yv54OV3dopCnN0E10MOiMEk7A1TksHCfkCQh6nJS3wvAZRQ4kSGsne+a3uciTSk8LgzaUeQpeSO1dBXy5FzYBPaGHR1GYDIuoAJZMw8UHyY6XVJ0Jj3yiHq8oMcGk14y281VLIHGMPZ8nm3ajMewh76Ci/+XHAGpcZqjOXJFTPRCmvT6czrvReU/S+i8RGZTIn2x25TgC+AO4FWyh7cApovezKeSHEE+ClVGHicgRk0NvBFvNZXVFHvl6Sp12J0/7CIVoLqvo2ENyuPOfkV+0HjLKlBy/+Bwp3GjCvungdxfCAmbBLunYfzW7Zz3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrXKkUmxVHaPEkFFh48ZrH51Yr9psUizxhiXFkwjZ0A=;
 b=ICuxqeev5WyVOkjl/dGcsCdrWJGNzUY7h/gJWW/tpTNtFmlta98+0GKirxxUh3jLj4hgH10wAh4Ldfytf6T60eSn6S2mY25E9jxKP155TL5uvbZ724ocuwOjlu6lmFHhT3CRCtEs/7ufJpFwsO8dc+EQs+c5CRTWff2G28Mc7IxkE6Kmn4Mizg0hzgeEO/O1svNf4O0TteMpYizcMuR1eLEx8/uA8cHcKVvc4LeL7in4yywSGPiyo6QsRIscCj3SU3cMCClBUzH/EBsiErWLHsGIv4J9+10hBgnXtTBShItJPBXXzqt6AvVVhDShnA8EeQwmsaO1jHmtuzgrVeEqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrXKkUmxVHaPEkFFh48ZrH51Yr9psUizxhiXFkwjZ0A=;
 b=x6h1fst5SKP/wWbMX0GyoldgPJRaCqFaH5JE62Xn+/N36bxU49ITc6lURRk+CaWBdIo6jm0jV9nRttNZD9eTiVN4kOEMBNiUYDIttyuPnpEpzZSS8yRBjvetjsg8gXMWw/95Pc5uYOb2VE7i3CuV1UR27PsLDs12PclqCdZFgjw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:30:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 20/26] xfs: tail updates only need to occur when LSN changes
Date:   Wed, 26 Oct 2022 11:58:37 +0530
Message-Id: <20221026062843.927600-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d06e210-f565-4620-61d0-08dab71ba421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Co1rZUfCHz3MfKxot42jiVGy1jryelm/v/+mcSHDzVM3iElRXmKx1gqOv98+anShHopnfuvn31fUt/pNQFfuLpliQHIFWg+0qid0cB0gK8Txp9IH/hQL3PD7Y2LLQ1PBNYAX6bJdkzu52enIyg2kW4XGgcTSewPhi0UswmA2pjouDNniImpMKIDbLMVVn+sllkslITDfjZwAYJ3IQk5byCd3sF5npr1oHLo9xNT3GUgegjJJO9Mr3mKFM3wnR59pQTqaPKLZIZLKJjeh8IUQrYR/ZWg2K95NUNWZfk/NeXgZJJMjV0Vq6FteYiVsPqf0U37m/VMJIS4CJQMpMKG6gyNgFNptIL0xqcyk2FQs4WupovjFhfa9TdegWm1PWWe5NVxwGgjqUfcWmZgN+zLJGR0wRRowqHwA7LnZE3fSHkWVC3/pFit0U3i/S9BgwM5AUvN8kKxaV9MepIlpnfkJRxYznsW+q70bPGcmTWgneY2MOkucQ6tGKk5X8Sbweh64HBqH7QengxQI1yhQftF75NOaqn43KnEuSzNlpNHnXI3EcgjdquVJzh6Cc8/L7GOnUlDIRucIDnJ1SiVMk0+bEzvOJOBv4KnIUYKDwNEOu4c40XggJLlmDaTP0eIPLzef9dgQFu7rD7TdUEF+5S9B6chtLz6zjOOMkDn49GyUHRK7Bh0ANNIev1pluX9IsUlN9mChFN3ir3Ao1j9UrYLuRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(15650500001)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEfDgNacc2yT/O+xWyrB4DxWxi0nqJdK7nAl//GpQAIWiFBboil5u5Lfng9W?=
 =?us-ascii?Q?RQd09GgctQgwUB9LGN7anWgHREqaWI2QTixxR7ggRLfq0o8uUPiSiH1XJH31?=
 =?us-ascii?Q?P3s9ZGRPgqxJzn/8ODRDdmdihSf6HL6GigHmb82m1iyRoo6cKEnoMB/hNgsk?=
 =?us-ascii?Q?yKote+U4lun7nvtvcT5f6jmt1vg3NygOfkRD3Pmalpy1nJEBeWtWh/XfcxJl?=
 =?us-ascii?Q?ZudpNJqUHEYuX4fDwKN4oAGpBt4nR/f5o150RmR8BBqaLQgi5zlRRPbnnq4l?=
 =?us-ascii?Q?SgSxxUM5hFTMxmjJg/8WgMtVSUVAGvcGvuaZNjh7AfcM/BzOHXKAgxHs1AWV?=
 =?us-ascii?Q?UPMf32p4CVOwNQ0kAu/Yglp/zOx9CSGshafTaNMC4RnR+apjZi6mdENBYWOG?=
 =?us-ascii?Q?ZExrIn8vC1DSj6CSu3hMZZE502+4tu3RBTnSH+cdmV7AEswMOtmYf4g6PsJz?=
 =?us-ascii?Q?YwwHd5u+oDZcJhfYAhkekGwmIhYd/Y/U/dRc/r4Tq/BXinZzLvuJqAAMMl1f?=
 =?us-ascii?Q?sGuNUDNzmfsUop8FOdlN2kZ99sd2czjVh68+bt6sS6Brl7qcK5ktva0jchWg?=
 =?us-ascii?Q?njHTXPQpc1FyykDtFRoCyQpVAvb+9m9EycbUb7boCogGGcmZtCgdFtn7mXtT?=
 =?us-ascii?Q?Qoxwt/GP3IuuttRyClI+i9Dl7zWjVTPhn6r2mcGmZ7JwLf97Zec3VYQhhgW4?=
 =?us-ascii?Q?cxd+n2Ihm3e3W6SVM9AQAm0lYGPp5dl8FkJwhXvc8l/55qs3IxjcG/6mbq1k?=
 =?us-ascii?Q?wZ6kNCuPkE84h60mXTlydwaHRUj4agkiWPb8T16/TBQViqJqFUBDphD57Byy?=
 =?us-ascii?Q?ogOPqnyELSjnaVahZaZJK6zECgiWUfAWxOOMHRefpXmO2iPWMcfUTZXbtnN7?=
 =?us-ascii?Q?PZJghzQHScepizApbdgl5gJjQiwUwUGjuCJiQlBdyEty38VcC8pLNl4oTgDO?=
 =?us-ascii?Q?bCONKjXmylAZIJe9xpwWpe86EUzX61PP5jSJtKQcBZmJc08ps1GEM3ERXnU2?=
 =?us-ascii?Q?a6+5AlMBPHqjM5pXGgg71Orm8JHiy2eU67jYqSwjKCa0MKMhRcbbX0xprXMz?=
 =?us-ascii?Q?j3CcTYirANKqWb2YyB0PanXzoVttd6TTgvX0gDtjoy5WUcd1S8lVeSr3Ypdt?=
 =?us-ascii?Q?tDWXEI52gwWEhb/ldQvcSbXVLkdW2Qe1su+YykCn9Mz9I24jqJazY1VfxxaS?=
 =?us-ascii?Q?symcvjEA2D4w3PcAZ1J99ZTbQ9oOE0Ff8kPQRfGSH16CuKkjnsbAdcSLhNNK?=
 =?us-ascii?Q?q+m0oJAMAi8lBXI5jJ74v7dhAthz/4/6oWURXVQi3nWgyhbBt8pRpRN0T/rE?=
 =?us-ascii?Q?tN7/aPJvHipvVScIFnKDKmgpVgKcptwr2fEMeYbnw0JLes+h0CjCIVbSOlSO?=
 =?us-ascii?Q?Cx/Ta8ZaCe1pMHdRAMNkuF8L45TQWfu1rD33ipZ5UCUB+Pv97JU77WH3l8HR?=
 =?us-ascii?Q?lrC8bjxkF9OITdB2PLQjLFbUT0w7AN82qzyRbgsJgDZkFCPRRfdw5k83N3Bu?=
 =?us-ascii?Q?6fjakUiM8hy/BZoN+hk9PVXxxqEyB15wSa0XRJnzebIAjwe2nII1L6BXCE+y?=
 =?us-ascii?Q?Ltp22zY6ODShq/OuSeCmvO7Kl6TOpcil5DPpr0znWZ0iAMfnqI3bipRHL5Da?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d06e210-f565-4620-61d0-08dab71ba421
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:57.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcUq/EZMjVXoaYiHWDbSXtmBmMzrpXKXQLG6nnLe4Xsl4wTXDL546xmS4GLvoVJw7YnMbdub3FbejnxWB4Er6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: Q2So1gD5YkYWmloVVObZGMRN6fw72PjO
X-Proofpoint-GUID: Q2So1gD5YkYWmloVVObZGMRN6fw72PjO
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

commit 8eb807bd839938b45bf7a97f0568d2a845ba6929 upstream.

We currently wake anything waiting on the log tail to move whenever
the log item at the tail of the log is removed. Historically this
was fine behaviour because there were very few items at any given
LSN. But with delayed logging, there may be thousands of items at
any given LSN, and we can't move the tail until they are all gone.

Hence if we are removing them in near tail-first order, we might be
waking up processes waiting on the tail LSN to change (e.g. log
space waiters) repeatedly without them being able to make progress.
This also occurs with the new sync push waiters, and can result in
thousands of spurious wakeups every second when under heavy direct
reclaim pressure.

To fix this, check that the tail LSN has actually changed on the
AIL before triggering wakeups. This will reduce the number of
spurious wakeups when doing bulk AIL removal and make this code much
more efficient.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode_item.c | 18 ++++++++++----
 fs/xfs/xfs_trans_ail.c  | 52 ++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_trans_priv.h |  4 ++--
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a3243a9fa77c..76a60526af94 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -732,19 +732,27 @@ xfs_iflush_done(
 	 * holding the lock before removing the inode from the AIL.
 	 */
 	if (need_ail) {
-		bool			mlip_changed = false;
+		xfs_lsn_t	tail_lsn = 0;
 
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
 		list_for_each_entry(blip, &tmp, li_bio_list) {
 			if (INODE_ITEM(blip)->ili_logged &&
-			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
-				mlip_changed |= xfs_ail_delete_one(ailp, blip);
-			else {
+			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
+				/*
+				 * xfs_ail_update_finish() only cares about the
+				 * lsn of the first tail item removed, any
+				 * others will be at the same or higher lsn so
+				 * we just ignore them.
+				 */
+				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
+				if (!tail_lsn && lsn)
+					tail_lsn = lsn;
+			} else {
 				xfs_clear_li_failed(blip);
 			}
 		}
-		xfs_ail_update_finish(ailp, mlip_changed);
+		xfs_ail_update_finish(ailp, tail_lsn);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index effcd0d079b6..af782a7de21a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -108,17 +108,25 @@ xfs_ail_next(
  * We need the AIL lock in order to get a coherent read of the lsn of the last
  * item in the AIL.
  */
+static xfs_lsn_t
+__xfs_ail_min_lsn(
+	struct xfs_ail		*ailp)
+{
+	struct xfs_log_item	*lip = xfs_ail_min(ailp);
+
+	if (lip)
+		return lip->li_lsn;
+	return 0;
+}
+
 xfs_lsn_t
 xfs_ail_min_lsn(
 	struct xfs_ail		*ailp)
 {
-	xfs_lsn_t		lsn = 0;
-	struct xfs_log_item	*lip;
+	xfs_lsn_t		lsn;
 
 	spin_lock(&ailp->ail_lock);
-	lip = xfs_ail_min(ailp);
-	if (lip)
-		lsn = lip->li_lsn;
+	lsn = __xfs_ail_min_lsn(ailp);
 	spin_unlock(&ailp->ail_lock);
 
 	return lsn;
@@ -683,11 +691,12 @@ xfs_ail_push_all_sync(
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
-	bool			do_tail_update) __releases(ailp->ail_lock)
+	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
 
-	if (!do_tail_update) {
+	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
+	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
 		spin_unlock(&ailp->ail_lock);
 		return;
 	}
@@ -732,7 +741,7 @@ xfs_trans_ail_update_bulk(
 	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
 {
 	struct xfs_log_item	*mlip;
-	int			mlip_changed = 0;
+	xfs_lsn_t		tail_lsn = 0;
 	int			i;
 	LIST_HEAD(tmp);
 
@@ -747,9 +756,10 @@ xfs_trans_ail_update_bulk(
 				continue;
 
 			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
+			if (mlip == lip && !tail_lsn)
+				tail_lsn = lip->li_lsn;
+
 			xfs_ail_delete(ailp, lip);
-			if (mlip == lip)
-				mlip_changed = 1;
 		} else {
 			trace_xfs_ail_insert(lip, 0, lsn);
 		}
@@ -760,15 +770,23 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
-	xfs_ail_update_finish(ailp, mlip_changed);
+	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
-bool
+/*
+ * Delete one log item from the AIL.
+ *
+ * If this item was at the tail of the AIL, return the LSN of the log item so
+ * that we can use it to check if the LSN of the tail of the log has moved
+ * when finishing up the AIL delete process in xfs_ail_update_finish().
+ */
+xfs_lsn_t
 xfs_ail_delete_one(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
 {
 	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
+	xfs_lsn_t		lsn = lip->li_lsn;
 
 	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
 	xfs_ail_delete(ailp, lip);
@@ -776,7 +794,9 @@ xfs_ail_delete_one(
 	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
 	lip->li_lsn = 0;
 
-	return mlip == lip;
+	if (mlip == lip)
+		return lsn;
+	return 0;
 }
 
 /**
@@ -807,7 +827,7 @@ xfs_trans_ail_delete(
 	int			shutdown_type)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
-	bool			need_update;
+	xfs_lsn_t		tail_lsn;
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
@@ -820,8 +840,8 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	need_update = xfs_ail_delete_one(ailp, lip);
-	xfs_ail_update_finish(ailp, need_update);
+	tail_lsn = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 64ffa746730e..35655eac01a6 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -91,8 +91,8 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
 }
 
-bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
-void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
+xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
 			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
 		int shutdown_type);
-- 
2.35.1

