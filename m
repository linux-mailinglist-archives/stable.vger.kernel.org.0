Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C98060DB1D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiJZG3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiJZG3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C07D8111F;
        Tue, 25 Oct 2022 23:29:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1ncWG024731;
        Wed, 26 Oct 2022 06:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Z7PTaza7wdB2aNoNRBP5aaPMA9zmPa6w+sXq7X7AEoE=;
 b=nJ4R9eYDgmtHzmLZyAQY5pBbOWeTsvju1eGD4M6P7C6rsj9fHkzryVXsBp+9h36QR+i3
 68ree2zMj9aSH2gZiPni/zXClWrfav3T9eZToYbvoOwclmkUC5psVjytcRzhYcyGtq82
 HcqlEe3YVkGf3Nq4bB6kKWr7Nro+WtVl2IjXuuWhUg74i+TcN3riNgK928PigWKUCmDe
 USxsUOn36dKSWv8l3pPo2Ye3QgjivjV1E64TbCyepkG8OmbCJiKtDduMlBQPQdgHJvQT
 Z3R2dQS2m1JwBBuF/We2Hz71HhTyFo+Wwh2bgQ0C5hfIEJqwIjZZP3PxgmQnAMCMjPFn Mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnbfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q6A6jW013363;
        Wed, 26 Oct 2022 06:29:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6yb716j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1htDHE4wx21GqmGA34elXlpywtWZXwLqi3HLM/Fve5XKf0Dxogt3FfSuxp/WqaTJhqgi05LCd+i4Occ0Ruq2NFC+aTRs5CAr4pnR+ChkkMqtnqsOQny3ORgpNH5LJB94AM4vKLXODm7XNIlK6iAHNznFm5jBLDgbpvUuUtsZjMbk6oeRRqhj0V8LAmsUPFs9RilUtN4kOoor4Mh2bw+Fs8u+NGC80HiwdM1CYOv0x9sLDDjaNyP43BGYH+MPLOl0L1b8g0fDrr4XumC/0MUtco3+Dy0gCMkM+S9Bf3iNu2/Bw1ckAbUv+Ppv9cF408AU+VfSZuRGxx9AnF6ufoI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7PTaza7wdB2aNoNRBP5aaPMA9zmPa6w+sXq7X7AEoE=;
 b=nbm0Ye9aiNyw/GkW33y6jfLXue6d2Q74ysYtyjv+sHIzt+8SeE9UKogQjjBM3nWZelESyHdvsXy22BP9dJvDHY8mYGkFw673zp2vNSvafPdXaV8O6507kEpoXDIP20ip6ICwNMxTmp38Q84f4fB10WoRHFute4fipCsL8HVUcNaj0VBstVkQ9Ws0jVC5wNjf5Dmxns1sVkz69x5b83erA4YSR6zJg1wkYFCqNTcw6WrqHX5hkWDkoDzfQh0I8T2H3c2lAv6Mc9cLKs/TtNPtrFgQXtuQ4PO4bXrNfcRJxHoYsBm+jeODop0yDPs1pK2wCMTiu2c9pjjHC9+29H3y7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7PTaza7wdB2aNoNRBP5aaPMA9zmPa6w+sXq7X7AEoE=;
 b=O9YnyAOqZ9kLdo68dfgcRW7sdNB5kueg1/T2qwNaOl0mjybQGh5y844ScobFqBuVKzos90kjNBAW+HIu2ezkk+8rU+ea2S+48r4NVHJLQtMDLyM6MuYe/QWJxHPKlaPoJ69qABSuUY5bausJH073anO6v3Ve3vYkMicaPYXlQ/k=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 06:29:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 02/26] xfs: rework insert range into an atomic operation
Date:   Wed, 26 Oct 2022 11:58:19 +0530
Message-Id: <20221026062843.927600-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:404:56::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 744d8e40-8cbf-40e6-9ee1-08dab71b5fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Tri2OpulOXmbxu1JQFeWLNi+VBpoutCh4wGhOOwQMF6wSOhVV6Or45QDhwyQpNnO9DaLVVK3BQYZezUp0AfDCoipdh2dG9/2eDgF4ygyO5VJAdSUIIGv7z+Ev2o4iIZB4oAovj7+JXB/yNpueIhVu8I2kTGQVCK15CcO4K8vc+HRv++ruYFSuQaXwzMMFNx6kIJJIlU6xyNBf+IjPBMDSRsfA/VPWA71XkF/OPm9JJ7nOrjsZiNRa8EupQxM20buwQvflhLOpSsX13DA7E7hsFWYtg/WEx8wKRvFDnzkyfEaQRtMIMZcMQ23C3VVa16ke9SE9BrI11UHdlvdxOsyPIZJ9E41Sg0W/P3zZKMoiUqywgt8k/AvYLaFZwbcb3kM7KRfnuDjSKtwq+VgDJyl/QDky8Iei/GJBmfM1x6KWTv3jMQ2Bdmm96dTF99tE1GzSgZwAz7Ske6pEgb7ufQzNSJmX+8fg4PBSoV89aVa5VWhTrVLuC4SD88TTMkZkCqhc7U6CHO9ehYffqhNOww2m1lo7CuMs4dnmvMUDHuOTHumoSHdfjcdTBhNTrKi2s/n2OgoCWF05JjhGrvosFgpsHiOpo+CVI5Ifzypk0htupnNFjpVvkIe7jNrB/dy6twLhY/PNn5ngA+jlIWMCYDjWBg+BgSvLiztYYIjoR6CvbqZu700LPZ6V2xG6+OLt5dR7RGvwOYwGflxWFHRAj/MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(186003)(66556008)(41300700001)(478600001)(2616005)(66946007)(1076003)(66476007)(4326008)(2906002)(8676002)(38100700002)(83380400001)(86362001)(316002)(6486002)(6916009)(6512007)(6506007)(6666004)(8936002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3gOKLtSrqxkSBM4blwjL+kRrZtUwTJZyj0HvKXWPlufZwGI3IJ3NFyPKM27c?=
 =?us-ascii?Q?Rqk1pGDuR3g+m2RmPD9VW/vKenc2Mf9c4iBFskx88SyLaesoEnvfAjqfIF/E?=
 =?us-ascii?Q?jrUfTy7UTt3w3u4Tf4mj1IqfQ8WsR6jjMmDi4Oj0Rh7HdP67UXQ8lLMUs6d8?=
 =?us-ascii?Q?mEgsvWtLdeETffuTEn3+IwhvP2ZUAftyDLAUyjlECWEV5VpBq87ldtEVUFbs?=
 =?us-ascii?Q?AX+rj77EsoPRNK2Bc+s0cpzIpHVUQyklskRMQCHB41e17hPq9oHQooIisbBf?=
 =?us-ascii?Q?Ul0ldFhVTVhqnRd3vp8WhtSI7YpqIcyRMvT2G1zUZbLIZZBYZL8cnU4ha+n0?=
 =?us-ascii?Q?nwHVDXy9Ok+4IjGdzpO+RaAgRoxQgNCq7GOJs06jKbsnjua9TM+r6D1O8PE3?=
 =?us-ascii?Q?FCCZ+WRbrd1KDjF1JRZrsIQx+KtgGIAQeQvcnG254ZwyjbT9YRxrnj1gdRV/?=
 =?us-ascii?Q?GxR0qU4GmaWF6zyvB7dNIH+WcNWROYlvm8sr5CZi710GKfGjTuluu4FmrXBW?=
 =?us-ascii?Q?ZhmAwfZGC87jX55hjljzkltG73iZgRXYnLYDFUShCd0FZ27wSXnYqjsnZLgj?=
 =?us-ascii?Q?s+OBHIlVEDiKv6IsoCbUVZCZ6ilMoCeUPA6gFHwkfCGbOZBGDsFeLsdUdKpv?=
 =?us-ascii?Q?aimqCiPN8KRKgBTkyAJnRgXhURpu3lPjQxtFDzXIrIaXugcJS0fcujpq5nz1?=
 =?us-ascii?Q?XziralzmD82fKmMCGLnX7LgUZXr6lRwAS2Eau6HD3JD31Ki5WQ4KEhqCWhkv?=
 =?us-ascii?Q?350Tjo8ip5mwbKbH2sq9PYOS5xOsMFlM5KGiFnQ98kl3WEpN6ZhtIWcGauSG?=
 =?us-ascii?Q?fWJ73OnT4klIW6xMeTw0WgOZwgMWnP2whXZpTNdbYzi633aWV4FZyd6ZMke6?=
 =?us-ascii?Q?v3ICgAfRuK6Yo9umZzjKELDjCI06bvH6lZrKvvyImNeA2DItRyev/DhqOhzD?=
 =?us-ascii?Q?OdS3SdMKi0QOnXtg6Gf2SSQk/mqZcnGX/iRvUocolT9KzTm4ls+MZFG7/moh?=
 =?us-ascii?Q?+8ceq2KSgEKln6h0qNlNDhnlT3ukPbWtz+fiudEusxV98Q8B+TLzQFdSmTMk?=
 =?us-ascii?Q?/B3T0oNPaf3gmChaFuJqtTjBlsbgbmSOr67lvg9wWZgDqgvHCxyeawwEgGQT?=
 =?us-ascii?Q?sLSHWkXouC63sXtyYE99Qe99XuVEPppYbfdSsiiFVm13HxmJq7ksGmHzIwmx?=
 =?us-ascii?Q?6JCDLOqcYzzfobq2Qo/6gfUO6yNbE6WH7qAlxzuuQgyfaUcBtwJcn17IcDn8?=
 =?us-ascii?Q?mHPBY4F75+En9UPZEbd2cNObe4/fZqu4iOmOyk8Y68+CchNMxchJeanrJYu8?=
 =?us-ascii?Q?dv7GJmRqKGIop6xhoo8jNvUx8pKV+iLXgMuM4PQkNT2D1OAad/JmcnY9ACT7?=
 =?us-ascii?Q?u0Hq/3b8Kl7WWt9ht2zvroL8r4OrLItdL9GpVzMyO2ASm+Il8prHSut2+BeE?=
 =?us-ascii?Q?gFfZ/PtmsxJHiRPlFdWem+aczk0sSoN6b7y2SOTUsNfuYTUYOksICbH/2/95?=
 =?us-ascii?Q?pYTKOYUrXYekrG950JwVRTF1NJrD1xdXzo+Dsbzv55KG4rQVSxuW7yTMKjAH?=
 =?us-ascii?Q?K+VAc+5z9Efz+6/zweVaxqH89rstJdaS1nz+JvfY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744d8e40-8cbf-40e6-9ee1-08dab71b5fd3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:02.7144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZK4NUIALg6NeAiEVAia4iFdQvIkFJP8tFWQALKopxM6IKYL26wKe1iBj5spSFFzEh8eujCZV1wGyBQYWBu0CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: OZ3776P1WaFo4B3Zt4w_dSGSjhkNqkTy
X-Proofpoint-GUID: OZ3776P1WaFo4B3Zt4w_dSGSjhkNqkTy
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

commit dd87f87d87fa4359a54e7b44549742f579e3e805 upstream.

The insert range operation uses a unique transaction and ilock cycle
for the extent split and each extent shift iteration of the overall
operation. While this works, it is risks racing with other
operations in subtle ways such as COW writeback modifying an extent
tree in the middle of a shift operation.

To avoid this problem, make insert range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and relog the inode to keep it moving in the log. This guarantees
that nothing else can change the extent mapping of an inode while
an insert range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e52ecc5f12c1..90c0f688d3b3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1321,47 +1321,41 @@ xfs_insert_file_space(
 	if (error)
 		return error;
 
-	/*
-	 * The extent shifting code works on extent granularity. So, if stop_fsb
-	 * is not the starting block of extent, we need to split the extent at
-	 * stop_fsb.
-	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * The extent shifting code works on extent granularity. So, if stop_fsb
+	 * is not the starting block of extent, we need to split the extent at
+	 * stop_fsb.
+	 */
 	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_trans_commit(tp);
-	if (error)
-		return error;
-
-	while (!error && !done) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
-					&tp);
+	do {
+		error = xfs_trans_roll_inode(&tp, ip);
 		if (error)
-			break;
+			goto out_trans_cancel;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb);
 		if (error)
 			goto out_trans_cancel;
+	} while (!done);
 
-		error = xfs_trans_commit(tp);
-	}
-
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.35.1

