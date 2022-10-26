Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9EE60DB1F
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiJZG3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiJZG3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB3A81117;
        Tue, 25 Oct 2022 23:29:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1ns9H018188;
        Wed, 26 Oct 2022 06:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jZdQBzRUMj12m7lYoQnh8mJxlGjNkgHEUHfvoyuIOh8=;
 b=Wd8bpdhzAvZkUqjHuY57j9sgAWMmmx09MiJVUkaVYCrS0OUziye7PkRXwJFb+xFs3fXT
 q0Hl3bBFPStQh1brqCNXNLQIOXHKfpck0bxUPzGWhtV0zTUjunUa0VeXpPQmlIYE3WHy
 S3NpXBlh628kLXzUS5+NWpm7VO+JWQsITA0hueNtGnOiL7ISkbb0LmE6tAMqb3nV2/YT
 18blySs5a/GLpSBxI/buRe2/p3zDr776zRCaWwt3hCBhUWuE3gm21GOUamUa1EtS+hBz
 g8/6ejnXFxfELuOZe62moci9/7rvBtdz3txJ2igI8EzZ4al+2X94RKTPVGWU9l+Ht9VE yA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e5ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q37949021975;
        Wed, 26 Oct 2022 06:29:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybpqe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIsulB5XhV0cOPlwEE6L/3lbsp7jXpFor01ZOn3mhoI4ugIO4lAwQT/W5Hhk5hvCyj/YlmBSe9bXaGT7g762my3OFSWAYkgYDM+yF+tzNiqMjJ9pI9razWPES5dk37LpG04YXq4K4JPAW2k+1TOOKk9l7cp9e6GKAxhJv+WxNRUyPzaoSZ3hatPG5ExcLLFjOQ6QL7Hv+GNCoO/ak1Ccas/wIZWSLFAZAlmGcffHsQ8eVN6sFKtxdsvM0lU8qcjzhFx6/pdBp+JJKyCyLA0UPXMi7awQHZzXyAiECv71/+JYh7dOPkW1jVLqOdW4ZWcRsoq0RHxl0g78V1AR8l4wFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZdQBzRUMj12m7lYoQnh8mJxlGjNkgHEUHfvoyuIOh8=;
 b=C4+s9NDP1i4b9q5iAH/4/uPDvF1bdFh3Lu+I0RnTN/i4M9R0HRn2+cVHNiBNpPfyEfLUxaugSKLO+PcqiN7DmRSg/35OUsZNPTUyr2sMXJ3xcT64FnDwAGrazdMaW+H4Dpf6RaDP5eYEvVFb3HoK/R37+S21DFHxYC3aJfUEgwZX3hz78zph5cmFWpSDMl7LLbus6+6RAnu57YelKFhaiOSvtbpxxVE7hB2bHtvId4yMh8pCPSCouJIKBiNknOpv8zfrMoGvwGUwwLX0zVyfhmavl3LvUpKDVKxmN3U5VPzCY69LM7+RWmLACjJujTByLnLrLXCOFA1MPmkzpjYEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZdQBzRUMj12m7lYoQnh8mJxlGjNkgHEUHfvoyuIOh8=;
 b=DrYgLfodevLJDBcS10HrytbLvutb78zp7iKEEsA+G7Mtz0yev1t39QGTuzXbP6Dc0XJ2LQ7G53kb9PMXQIIXGMX12LrJc+FoNSSXTRnQoejQTfafLn8xPNyijj36AjvjBs3xqvwcIL9ftnB8Bhw9EL0PnmK37Ushak4fhnPIsUM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 06:29:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 03/26] xfs: rework collapse range into an atomic operation
Date:   Wed, 26 Oct 2022 11:58:20 +0530
Message-Id: <20221026062843.927600-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0027.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ff6c64-07ba-4235-5c81-08dab71b6352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZk6GYFR2iyXbc6RK3ULF3mr+7spFanIn485HpcVRpCkY3NP/o7SsIiG9UiQ5zeB/0cfhlhOnYf9YVBsU0Vj4ohO8ttBp4O2LY9Zv5OzDgR++R+VuYywF1IxEsz9ynnVbEZmQ9JU6anU7Tk4ErhqUqMJyvsS4WiHWpcw/6Nua6elRaI7l53IoTRuIz7jO16+FNRJtJ3Bz9a8kGdbHBd/8ZFwd7zcAisErdKsGruSgC82uHjjqp06I9xNM/JMUSFCjCMKlWr2ItPkPl/XDRh79YFfEtPQ+LH+++KflaPFZC6SIKwXtceUaAAe+hAk0jE2Ghv9DQBbQgIpHxzI6edUNiGys8u7SQ/mi8F6raAdz/M7NKLvq4XSkLwU1UbnR7JMG/dyqj2cx3ty3JFz4OxDpfCCGGwf7rQwrKim/Hm61nIDi/6DNMUv5+VWJNCgU6SiXzlUIPfE0PePHkuo1lxquXbnbD/DkFLuMC+45TS1u8THhAe6mtBTSBvsYDjrEHz5Iktq0ElJOPEDRtwQycZ9unlolMwDLTwLWcT8tdQPUWYP16EHotq3v2sNhbGhvJMxe3GIerDd1UvPiN7BLRygVyB7ycBypu/CUEXOMP6c+XQABOtPeVYOIf7T1bQVZ3VJSbl5uZtOXAQhzKs/jWen2PWTYB1ekGfTpqm4MgHKecgsQ70o+FNs+CcRromOANEyrSGvHQRlmnYvHv0+9TGsbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(186003)(66556008)(41300700001)(478600001)(2616005)(66946007)(1076003)(66476007)(4326008)(2906002)(8676002)(38100700002)(83380400001)(86362001)(316002)(6486002)(6916009)(6512007)(6506007)(6666004)(8936002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JaBm3MB1wa0bSNpLje0o5mITXgfUleCVEcq+qTO3POfsyIqOt0Qlqx3hpqO5?=
 =?us-ascii?Q?H6+VcQBb/As/ZAzgquB2I7Qg7cBT6m+3mCebbNUUhLVLa6Xah1tIk7LdaQPH?=
 =?us-ascii?Q?Rhp43HHrAmOdp4YnHi6ILWRHH6MYDcP+5whqAilOSom4kTJ+Mm09Hr975ulj?=
 =?us-ascii?Q?i6MinFxl1vgB4jANaxtP500ViULiV7WmwJJYdfx+caVvcSlek5Dy95WsQ7KI?=
 =?us-ascii?Q?tOnyEhaZIvjpkPDGM89foau6KTXoraHuq7Uy28YPO9ZrnWpZmBZownrJa5wK?=
 =?us-ascii?Q?/jQ3yy6MQYj7pNk+t+ZSDcvhA0/ke9GOnRXxb9NrHIXIfisTLTUX/VbJ4c+R?=
 =?us-ascii?Q?WQj/VbVTuFAuLGBBl6Or1OEt6x3D/O9j7i07DUBg9N6map7WDdGZBM/UEWRo?=
 =?us-ascii?Q?SGy68DMuCtiofDsULMty2w72NQmmzv+0A3CmRAqQ6q/4Ji1CsoI3bRG/kvHr?=
 =?us-ascii?Q?ZpsPhWqJ2oI+bLJhxgyQctAApqAI8SBWGomXR8zCAqAK0dvkg4YnJXB5JW/7?=
 =?us-ascii?Q?srxigWpgZuZLPIKoE6ZBftOWEXh0kewigcUxrjee7vkmLTYtV6i8qnRxjRiN?=
 =?us-ascii?Q?CiKohsmJDdQ6Osl592mktVZzb/ohJhOkxDWMFrwo57deYzMC7exsR0rIKJiZ?=
 =?us-ascii?Q?sOBQGxGECSd/t661T+zI5bmzaGGm34TdEfYYrHya38TVSmTG702SUG/r3nBd?=
 =?us-ascii?Q?BGpAwKV8mlOsAeJ4vXOWvNfcOFmCIh681C/m9yXUWtnsyrm+HMTYIL1AyiFL?=
 =?us-ascii?Q?PW1B2t2ma1q3ri5Y1CxkwDk6GT2sOXZGTsdmYcetDxp+YFAGxiXutv7pCl4C?=
 =?us-ascii?Q?unUeZ5O1OAgelRlFejHqT6c6ZMXgLpp6Af6lf5fMzvfgR4HhXrhD+M/lssYJ?=
 =?us-ascii?Q?Zk/qA5mGUIbOhoW/yt48flk+3gRPALzqKCHXUaxYVyTk89NR0njqW+40VQOq?=
 =?us-ascii?Q?v1c1ZKnauhkZrGWXwYnU1ItuGaZwy8mFFfmuS4trGwYbuvTREQnz8sQ4IYnA?=
 =?us-ascii?Q?K7RtvmvlTr8TRxd5nNa0C+yy/WWt4zlVxbOyFSIycFEyGPCq4GyREeqA7a0k?=
 =?us-ascii?Q?ROGc9mV2qE7iJvI8RoQ6OXpafbdxAVeTuotFpG93rKUngk/5YhIn9vzywqsP?=
 =?us-ascii?Q?HCJt7pFUrgG+HgtlQrW+7CssKg4lSzc0s6i6cgllo3mRsy+XC+tYPEkqQum4?=
 =?us-ascii?Q?lBXWIUZzZVdccW6JkxMQagZ/6Oc5E0cc6Mqkb8QqrNJSv5yRvL3eQeho2HN8?=
 =?us-ascii?Q?TK3hV1XOS/5RWiyXt/tKU7WKtg7aLiSjj8CNstJtXPtTFSBbMfll7PIn0q2R?=
 =?us-ascii?Q?+Ipx6tk2WZz8DRk2eaogpcDqmwFuJYCyzzIYCFjjVoUjzez1K+PCg7Ff00JC?=
 =?us-ascii?Q?Lrs1QbLeGTlwa50a0wu1wkexK2BUs2hByKVdpkR2xryG4DDUdBlnAYMhAFZF?=
 =?us-ascii?Q?xzYSja9QN9qqgoYwd0iBSCqb2YHuLk4sEUwnJ87x0mzpQJWmfeGGCUFGoNgX?=
 =?us-ascii?Q?TZBf/IwmnpfOgojB/aCJviq9EklelC77UwGNwJULywRquUE7RtCfmJmqA+Dt?=
 =?us-ascii?Q?WBDn9ZC/5F6X/keaCJcXQHEWkq67MTf9y1RmXUwj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ff6c64-07ba-4235-5c81-08dab71b6352
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:08.6866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0+2iZYOvo/rlS4tzPn1ZEvfDW5nqzCpIleWKClZTbuQCCwT8MamkIsEeYj72+3Wv8ongkeAQpCcTt4BJBlXpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: Dw-Jm9VIlhUY-isxsB7dgK64MgLA_3sS
X-Proofpoint-ORIG-GUID: Dw-Jm9VIlhUY-isxsB7dgK64MgLA_3sS
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

commit 211683b21de959a647de74faedfdd8a5d189327e upstream.

The collapse range operation uses a unique transaction and ilock
cycle for the hole punch and each extent shift iteration of the
overall operation. While the hole punch is safe as a separate
operation due to the iolock, cycling the ilock after each extent
shift is risky w.r.t. concurrent operations, similar to insert range.

To avoid this problem, make collapse range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and finish dfops on each iteration to perform pending frees and roll
the transaction. Remove the unnecessary quota reservation as
collapse range can only ever merge extents (and thus remove extent
records and potentially free bmap blocks). The dfops call
automatically relogs the inode to keep it moving in the log. This
guarantees that nothing else can change the extent mapping of an
inode while a collapse range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 90c0f688d3b3..5b211cb8b579 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1237,7 +1237,6 @@ xfs_collapse_file_space(
 	int			error;
 	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
-	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	bool			done = false;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
@@ -1253,32 +1252,34 @@ xfs_collapse_file_space(
 	if (error)
 		return error;
 
-	while (!error && !done) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
-					&tp);
-		if (error)
-			break;
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+	if (error)
+		return error;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
-				ip->i_gdquot, ip->i_pdquot, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto out_trans_cancel;
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	while (!done) {
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
 				&done);
 		if (error)
 			goto out_trans_cancel;
+		if (done)
+			break;
 
-		error = xfs_trans_commit(tp);
+		/* finish any deferred frees and roll the transaction */
+		error = xfs_defer_finish(&tp);
+		if (error)
+			goto out_trans_cancel;
 	}
 
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

