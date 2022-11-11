Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F29D625234
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiKKELY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiKKELX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:11:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555041BEB7;
        Thu, 10 Nov 2022 20:11:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB42hZC028775;
        Fri, 11 Nov 2022 04:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tIO1v2V0sOwtgZ7WCTh5OXsP5zqjDVlwudqk9CXEXpg=;
 b=1Ev3OHtSENjvXdblSvFVv34NdDoYefvFXEaTOQfdfFJyFiDuVGthhHG/WQyEAzLHtOHW
 6LHSkoY8dcYMoZ9gEFr+P19xqHMSKMQ4tXPhVZ6N/h7eHqe7uz4tO0KeWphFVaW2CaFK
 EZx1KycItY67ME4Kk8Uf6YBJtkQ7Phf6TDfbmpLYNnzHKHIuaXOrNpmyV9GCdqBwPBE/
 BqabsexcXZA+k9KCcAkQ5QGG3C2XKRarjfMXuiyKMxoSMS2ilmRWuF3FTREmP7TX6aHd
 s0mW6I8431lZBZalm3xRIRJB+aOFUypX+AVFmIPDkMsC66fZ5K15h6VB0tPtgRoh8K9j cA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksf0x80g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:11:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB368Es019786;
        Fri, 11 Nov 2022 04:11:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqm12ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:11:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGwJ3VrU3NOXEe460uxQR0E9dQDerGpvlPrUoTd7t3XQm5/jRFvZ0OP4N5Fgb3DHJEbh6jBpshMRxawXmhg7A53nOB1NHwbYhfoYGcbQ2W81WiZqVw4fKScjstRQ1Ctt3Adladsu4q0jn1ry9DNUWIoxyC52JFcxPVaAk1IwzL/I/GsdmDbRA58yjkbq4STYXUT5967pDOAn0OiR71Pjr7FBf5/3W+FpmZMRWJP8NtpfStN8FJO4VUAuX0knBOX/YAJxC06RgoVmcMlHGG9gUNXXdR9dmoS9LL5lgvYGGYzvmi8Jioe1qA90ntkeeKeDSLbDDPr1BiziCWVrqQe9gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIO1v2V0sOwtgZ7WCTh5OXsP5zqjDVlwudqk9CXEXpg=;
 b=CI8LSUBv71dkKBVBE2TRxhtPvoQ60uValTVFVG3q8zhukWxCR6wIi3QYWPxEYyFSaFh8ViLER62cbvQy5utOK40qrbXqsL5nedOob6eXIVjpWzhrAqSsU0CwNPS3eXS7fhW1mUUFr7iWw1wAE8pcaQ0D/kJb005JYCq+YiSh42OQYTjiuYwuQA6NnZGNCdHWv+//p1qnoqBzZz7M7Uk9Duc1V+DP67QGs7OrWpbLq0m3gEFJ/hzHWaiHm23xwcuvvXFWsh9l38Tu9+LPtATv6eaQ5pVv4+V8UjQe5C2yniRqsoSYkEUb4Y9/YUZ+UxFpeaPai9rr0qJCXOusdH74Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIO1v2V0sOwtgZ7WCTh5OXsP5zqjDVlwudqk9CXEXpg=;
 b=ruyqrWp+vchf2cX2iXM+Skp3NUX2YKJ/XDH6PnNMUxs1PmcrnJ1Ex4of4wScNDykT77NiYQR/CgcOnmErqj/FMG4t4pvHEQiwZ9pTU0X4qViWMsFujxawgUAbe3trS14EPyvTMkHSIHO/5b3/itJAVg5t4Gf0rlugdwpTx0ns5g=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:11:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:11:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 6/6] xfs: drain the buf delwri queue before xfsaild idles
Date:   Fri, 11 Nov 2022 09:40:25 +0530
Message-Id: <20221111041025.87704-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:404:e2::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c2dd76c-0de8-4dd4-a7f5-08dac39ac327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D2LxvMkoVRHPqfHSODbzzEhwz+7jbynWsCca1LrraWHpi+wGi27NlK/f5sFkBm3wmLU7rHAfquq8UhMw489pwkMvtrJXWDzEBj+UB+sMbUFzEManE6s7idt1tQPqkXcIBScgTZJC8vugEC7kdgF2LR8/fpiuY7yHeUieYpqy+d2arIPU8EQ8+zOc6AKsi1dSEfH01c7p+rA9cXCD8vi/9kTmhhc3ctpnbeXnN85nYrbS1t3A2t7WFJRSAHhAuEeaNM1fMjmoXNQxQRSLa1Ape0aTiNd0TV6zgAzZygVF4c1kMpQDfuQp/UmTQ9fIKm3IdYxAvnDRWnnXT2LUkugtnM/GdJARsWhXTZhEH24zJyl5kFb8DRwZu9yWLIQxr8Xx71LqGPsdYS8WHjpYOo2oQGg4POKxQsLGbzFRNt37rtGzxHujb80jUv6KCTjWNsuxuydEr+VFBD/Cddo1Pob/SKVdLSuYBumBRPsTpXmZbg0yYb9lcgCVXocsx+78Q704/IrO2vQOq6l2Luy3W18f26PAS0/1Xgm8MT5H3bdGF5nagq+J94APB1sQlM4csDFjT9Fd3znhBF9v/hFIn0NJUdZ970IivTp1AsbkFbTleqb38jSTZZ0iSc0D+1AxREIf86RDxvRc8Lx+pJlBh/XcBl0NnA63KlV5vSg7kpEdm7q2dU19be148nl/bkuqI1zC/x8AzGPwv8bnvkyUx0VCJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(316002)(2906002)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9lEH5N87IbLrbUm4jxYB0K6n1aib1jmWiiYY4v7G+YZlQTt8k41YCAb8s+nG?=
 =?us-ascii?Q?NkkDB1aweWtmT2+dBf+QwK1KC0XUB1hOeeT8joMp72HJJ0KOUh/nsG3dcsqr?=
 =?us-ascii?Q?H0WlivJ+hOq7SkMcHeMVPA1i/58PwW4zd7RuA+8LTI86f8w+O1RlZINcz15w?=
 =?us-ascii?Q?02A5YHV33c3ZygVsbphIsMF3Eeb2+lJGn82k4a1vWAolD9nlEVy46YxDHB6B?=
 =?us-ascii?Q?5zSAiKazOY3LXbqibf44e3F++uoK8otP3LEt9ChJiylb+b4jbElDQC/+CU5H?=
 =?us-ascii?Q?/fp9DWtk4NUgzA3IEYfs+haJ/36IRUGe6KUH+xphqTOnz2wQJmFnF1na9iQL?=
 =?us-ascii?Q?bJbyQwTSI1nDTxbB2lrzzVy84qkaKWLMi7CmcYa0AMjyNNsK2/v28BUUTvNg?=
 =?us-ascii?Q?Rn7HGsCE2Y/Nl8P/yy0ssVHnqGK4F4+19uHVFUAdE5AQmQc70X6VZxoMo2EQ?=
 =?us-ascii?Q?+7KRLn8G5aMJs1hhdjJrfSge7wSAOEW6mMhqmj3/w5UP9ccMwKqxjI+r/+jn?=
 =?us-ascii?Q?vjcH+kTodTVe4KCspp+5QDqDWDokFhFfz5fA19//zi4rU02eyp9HINPjY5OZ?=
 =?us-ascii?Q?M76v8g3RgPR0B9TI4++XcB8XtG8vz5nPdNRtqzEbNK7ilELwPlTt7J7SFs+N?=
 =?us-ascii?Q?6tWQ6k5yU/IBnyYadDLuKqO1UNTPnYo0/lSWZZQ0xH1ElbYzu1yBluUEhyg8?=
 =?us-ascii?Q?LG7aOaGYKPnEISf1fwZt6grPv0yvB0JHJtir+ODmvwL0/e2gzym26GmDUwfo?=
 =?us-ascii?Q?xQM5s2iEbX7hpFkKTmwx14XQfP3Ya3UzwzaRMFEMEzMDsJAnpeFVf4HZlxcW?=
 =?us-ascii?Q?F7MQ8o3yitaxhiR5jjQVl7Ym40j3hnBzobqo8JO2187L2qwTbbWRX8x6ihwY?=
 =?us-ascii?Q?6vM2QQxTaNCnA1u0+/YY4EKGjAHJ1HwMEsNICsihqacoE8cOIPs5JXSTg+gz?=
 =?us-ascii?Q?bJOY2kC+SRePWKrLyguSsgxbDoWdMgSsKsXIH1giH6GitDGx3mEjJT5iuBq+?=
 =?us-ascii?Q?vqPAyQDz2huFv8MvPZ/KALpwhqBj+oaescmF8gfUdV3za/ySKU26Vwy8BXMi?=
 =?us-ascii?Q?0ATEtLrn4DGtt4gvZzbs1eSF0qbUbINcewj+PhP0qjnd6wpAy//0gDCsaAll?=
 =?us-ascii?Q?K0Wu+lIrwoL8Dk/7lEjR3uEluwo0rY6fPI47Mv3eTNr2axISstYjPVuoWuHk?=
 =?us-ascii?Q?DtY/bWw7yJPryPb6BnvJcO7QKWEmRSNe5ha+gnhHLKnOfbe2IlHF4cneQyMB?=
 =?us-ascii?Q?Tw93kSg6xmIVM5KALsIa+bL1ZlQj143HjdZweeNs3XlYJoAzfHNWmmoJNUaX?=
 =?us-ascii?Q?Bq2pD///pyQlu8iZReFiG3dZf0NkWLBkun4oIQ1IB+B42Nbg0o5P6BLEjzqX?=
 =?us-ascii?Q?/hTLhqC8mPMYZi4iriYY9ycU+XuISCoBxfVbXyZSS+ERrpKeCFdI3tM253cm?=
 =?us-ascii?Q?bJ55gUNVan1Oij0fDoRJho5tx9/jAjDUGxT/VErnlJswj/jw2kvCNaLo7/W/?=
 =?us-ascii?Q?8zuWxQE8a3Bnkc4SXc4K6fW9fnAEbjOtVg1rr1kS2kUCmv1KM8XVOBquOTom?=
 =?us-ascii?Q?aOvx9oKOcaOUHuFGCAuAtDmaO/INubCBYS1bRSp0E1d6kFAeSLK7q1BelA/g?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2dd76c-0de8-4dd4-a7f5-08dac39ac327
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:11:09.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ko7J+HXf8MLB+H96Ijjsvu71ZQ2QO5j7xsgrZOM0xz1DFmzDqHD/h4b5YVsJ6ZQ9V9Wps+EX4u4mfQ2mlc4ABg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-GUID: jQ8Ej--hwCGNO1HbtpCh2EZQIfPnHdgo
X-Proofpoint-ORIG-GUID: jQ8Ej--hwCGNO1HbtpCh2EZQIfPnHdgo
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

commit f376b45e861d8b7b34bf0eceeecfdd00dbe65cde upstream.

xfsaild is racy with respect to transaction abort and shutdown in
that the task can idle or exit with an empty AIL but buffers still
on the delwri queue. This was partly addressed by cancelling the
delwri queue before the task exits to prevent memory leaks, but it's
also possible for xfsaild to empty and idle with buffers on the
delwri queue. For example, a transaction that pins a buffer that
also happens to sit on the AIL delwri queue will explicitly remove
the associated log item from the AIL if the transaction aborts. The
side effect of this is an unmount hang in xfs_wait_buftarg() as the
associated buffers remain held by the delwri queue indefinitely.
This is reproduced on repeated runs of generic/531 with an fs format
(-mrmapbt=1 -bsize=1k) that happens to also reproduce transaction
aborts.

Update xfsaild to not idle until both the AIL and associated delwri
queue are empty and update the push code to continue delwri queue
submission attempts even when the AIL is empty. This allows the AIL
to eventually release aborted buffers stranded on the delwri queue
when they are unlocked by the associated transaction. This should
have no significant effect on normal runtime behavior because the
xfsaild currently idles only when the AIL is empty and in practice
the AIL is rarely empty with a populated delwri queue. The items
must be AIL resident to land in the queue in the first place and
generally aren't removed until writeback completes.

Note that the pre-existing delwri queue cancel logic in the exit
path is retained because task stop is external, could technically
come at any point, and xfsaild is still responsible to release its
buffer references before it exits.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index af782a7de21a..a41ba155d3a3 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -402,16 +402,10 @@ xfsaild_push(
 	target = ailp->ail_target;
 	ailp->ail_target_prev = target;
 
+	/* we're done if the AIL is empty or our push has reached the end */
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
-	if (!lip) {
-		/*
-		 * If the AIL is empty or our push has reached the end we are
-		 * done now.
-		 */
-		xfs_trans_ail_cursor_done(&cur);
-		spin_unlock(&ailp->ail_lock);
+	if (!lip)
 		goto out_done;
-	}
 
 	XFS_STATS_INC(mp, xs_push_ail);
 
@@ -493,6 +487,8 @@ xfsaild_push(
 			break;
 		lsn = lip->li_lsn;
 	}
+
+out_done:
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 
@@ -500,7 +496,6 @@ xfsaild_push(
 		ailp->ail_log_flush++;
 
 	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
-out_done:
 		/*
 		 * We reached the target or the AIL is empty, so wait a bit
 		 * longer for I/O to complete and remove pushed items from the
@@ -592,7 +587,8 @@ xfsaild(
 		 */
 		smp_rmb();
 		if (!xfs_ail_min(ailp) &&
-		    ailp->ail_target == ailp->ail_target_prev) {
+		    ailp->ail_target == ailp->ail_target_prev &&
+		    list_empty(&ailp->ail_buf_list)) {
 			spin_unlock(&ailp->ail_lock);
 			freezable_schedule();
 			tout = 0;
-- 
2.35.1

