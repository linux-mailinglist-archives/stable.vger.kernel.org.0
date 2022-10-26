Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F1460DB23
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiJZG3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiJZG3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01930C64;
        Tue, 25 Oct 2022 23:29:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nQqM030372;
        Wed, 26 Oct 2022 06:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=dEvIrjhmCC0lYyPS4woWX7pYOSXBBMZMTgztOIxPhHw=;
 b=SxxjaZbPD4hNJtHRtsIcV9rKCixxUnXRE51nhCVVO0stDNnSRIzFKuO1AMOSdHVjoZb1
 JfCzmy2D3m80QsjS1Uf7IKEKcJ727UpVooG952mjDWO3eU3+8QxsHt4us+4gOBLRGHwv
 V5E8ojp77rS3hh4MPmC2orku5Y8rMSnRU3B3Pkg/4BwqGQMlS3STlfiute8LbEcdKsky
 2cudpMU2R1d9+ZUxm6qdfK6+XlXBnFXAIZa6caYqP67wGSTxpwowegj7iKNTAALD3/iN
 FbNOdvEzgHsUBsjBIEY7WNbB5n6OnL/EqFDWn3MxMRJKSus8CPOl0TiRTtt1UzNvmd6C Tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x226-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q37APL017253;
        Wed, 26 Oct 2022 06:29:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5mwju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0epNaveLbLU9Ev8KdtxYPqzTnDUee9UIq1XyRrubv2aFzu68h7D4pR4PQ0eq4mONkRDZe7MqiJ83Flqa5HXg+HnhjMyUNbN7jEUo7R73yZ2nBlPvJ0dbLBiSHfTMZvFNqGBLpImfLa3imvAefrehRtXjKVrXN+B0HRMcfyuPuurjbSfDo5ezoy/IlSfw4p2A4ffGoc/T5HvxL0lG0s2w7QKjRtzAmAaPHCIti9OMlqrC6Vf1buQv2ro5SZMOExTUnBRJMffRf4L30iaoBDalU9hxD0PkGWOVocBJJ5HFDqwmT0NL/FXZY5lqdiNFdC5/w7SsjW97eUvPxCeA26HoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEvIrjhmCC0lYyPS4woWX7pYOSXBBMZMTgztOIxPhHw=;
 b=JEu2A85FEyCoOnp+zHA7gttslyYN+JXOB2dJYqorU+CBeZYOl/y+1P9BgDsD6NXj53jfxBKIecZBCGSVhTyCM9c6zcKA5HpBcd8gAuRN6t6BFurxz5ObrJ4DYTY2adKV14TQon1GG7hrklTBpOd13iE6B0JFJlM7t6KwNsvn2GYjumEfObptEeOSc8IR4Fkc/SuS/3qDUTGhgD88ra5OjWcjc/bd4pGtlPy3Ex7Lc2pVl27oQdK8KTpjHQedRbOSRYSdZjBEYWDCFJyoZKoIr7Fg5uqzEZdGi0HOAxxHS7WVd8farjkExGuhTH1EI4K+pY+wcAETD2D+jTZQ2FjGcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEvIrjhmCC0lYyPS4woWX7pYOSXBBMZMTgztOIxPhHw=;
 b=MphHJr9cOjAYYwOk7/M/i+8H9PvEP5wj4HF+WAlfxe9UIfCUUAjfLQuSyp3NbbzvP+g3zV70RYYcQAFmPhD+k4zYRBCzlLMcBuZoOIgsaz8b1oiB495eZxEMiV7eldF6QfIw4jibOYYQeg0hQ1pDlsEQXJVHPCDn/D08YTguRFs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 06:29:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 05/26] xfs: xfs_buf_corruption_error should take __this_address
Date:   Wed, 26 Oct 2022 11:58:22 +0530
Message-Id: <20221026062843.927600-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0009.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 1103078d-3ade-46e0-1487-08dab71b6a99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Em7CFEO1yetBJzNbhKKF0n3k1n0pdm7pcNMl0OEv6FEu1akEETo5RUtV4Bgr/L6ODG3CFtMai5gl3lNOexs7Nf8pGkXny9FNOLx/wDBgup5oDxqSDeUMkIc0c5/u+5/m7HF2B7YIGmhLbkPa4IGUUIiuYwxcX8eTclqnmCkm0vQ8sxvMRsTPiV6ZUO0D5SWP9DNRMqBMJsaRJ4AQ7aK3N1o1rnzO+9gSDpalTX6prSbZk7zic35eSc/5LOASJ4DAsoEUw1Af7EO8dQIkBKeTS6MGcX4Bs83fNDh3Nx/artORhSB+hiW2IH+K5j6QKaidpSDxOagTeggY7hhehRUBvjyQe6fOISkvA52V7H5rYaG7FU166DU62NVOxVgurF2euJL26eXAZgPzL5Dwzvb1HRefRzBSHN2Sc95dkEs4g7F8hApvvshtCQQRpeypLnVOYFX+K6TxPbfDKq+Yflf4EAzp3nvGWp+96DnExZVC23udbuyXI57DVBXNNmoRKR1WD8nL66KYcj5sgUQvTkqRLQbRA+zMFn1oX0ixwroisApK/A5fIOpPwKLqaUT2S+KaRq7QjJg7RV26meSTvojQyVerqj1PWhF097jHzNihNbAPTDMfr2N/XnnjXYbjJvIpX7Q9px55iM+G9JlHRKSdnsKR6zL2FmSSjSU1VUMqMiu6tcg9TtLsJZ3evlXXdqH+u7K0Gv98uWcw58jSRm8nDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(186003)(66556008)(41300700001)(478600001)(2616005)(66946007)(1076003)(66476007)(4326008)(2906002)(8676002)(38100700002)(83380400001)(86362001)(316002)(6486002)(6916009)(6512007)(6506007)(8936002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lQ4VFKnuVxuviAAl0kKALJMnK+Q5mooOL7xFoe34WxEpRPEL0tSMYVPeVyPo?=
 =?us-ascii?Q?jQWhXCk4I47b3DZrbxx+DTm0F7vkuKm2Dxxbkxfj8QsV5FK/SrzEGPeJAMbT?=
 =?us-ascii?Q?khdsOeVGWRyb3pb0wtoMiZnDPfH6QuDsrAdVfjOY/fbdiQLpmqkxTcAQtAAQ?=
 =?us-ascii?Q?4S5hBclcccgF1rA3G+zyP4q0/Ppd8hlRdAk3H05FRKRg6/IXybrOZQr1TRn8?=
 =?us-ascii?Q?rE3gTS66lumuKPZY8HdfdoxzPHAbQFrvYMh973Xwt+cfxRDyTGY2L2Tr1mkq?=
 =?us-ascii?Q?OUlJlPM0cF9U9ZuyZNReVf0dlPPH8riaCD7yIwzhoHsRjdJCofj/z+mpi9i6?=
 =?us-ascii?Q?qnTkuMlHell4ZihvcJCpcAwhQA916+sPwKYQTMw20A7mgpeoZ1VlVKw685JB?=
 =?us-ascii?Q?thuQ99lO+Zgje7ve1Q0f8XLeXTHy4VSvMeWhYpRn/B5XMUUuumLpc0/0cBR3?=
 =?us-ascii?Q?collDIJiBr6Ah2VxugDFQH592RL5+rJ/fJ/VMtioVfv1kxNV6RU/fG/WE93m?=
 =?us-ascii?Q?70E3twm8OJlqJr9u/QD37JRLV5the8LpCPdVduOIOXUd+epPrbVSjDA9M5gx?=
 =?us-ascii?Q?lMp5fwzg1GhesWI14jYvchXn2QZg9iRuxN9kbCXsK8AlauJVx97AXmiIC7tX?=
 =?us-ascii?Q?hC/BQLzuLkRo6ni1VAtnri4aiV/7bEzSmYGIyxAAGJPi+pazotNd8tncXfOi?=
 =?us-ascii?Q?dbIUtGMLwNqbyZZVA98f/k5dDcMmAClUnFdmXSyndM/QZ+Cpa+V3qLm3W3Yo?=
 =?us-ascii?Q?fbFufYDVx8diGkZtKvmnSaJrPYVtIplYNu1/LzvQJmkJWjNZxvmaBvTTCZfE?=
 =?us-ascii?Q?b4n8f/NI3ycIp01TvSiwWrC7bTrTqDUK9kAzmSxTeBKXoPoH1DsqfhImfVyy?=
 =?us-ascii?Q?I07Y/2cGmgNW+zxpR82dXUMb1e0tDi+etkeVeXERHxBt0YZl7+yr8FkahW5g?=
 =?us-ascii?Q?Y8mlDyi2rWuAsOyDhNm1L+L++v3WDWE09MtNzB+8hXElPdaWTbQ2yEm76ak7?=
 =?us-ascii?Q?0GDd8nJuGCEJdFtFMvj9+9mCAfLLhssihENBQQBYT5Cgc1d3c/XfEUu68ZXH?=
 =?us-ascii?Q?AxSdVhv48/VnycYfWt167dA/gQQWkOXzpdHdUV6XH3L1qi98wEItXTD0E2lE?=
 =?us-ascii?Q?bwVfwYXIV1M3Hb36zO1Ks4AtlUqdsIcazXVQqjCVPbbl63/7XqrXUOQ09kMo?=
 =?us-ascii?Q?BMv8Rnj5E4YfysnAr+sAYLGkvPES39KZMr2G0H9Nvj/F0Jy5EInYQHb11ama?=
 =?us-ascii?Q?3htFYoR7ts6Bvyglx5y5/lSqjDP+PG2Qi38/1BjNNVT8qfW2YOangYqbvpTm?=
 =?us-ascii?Q?3bE/Rcp+e+HoPcGcTtSrltrby0R2X1qnax5yqojipEWjsjQ0IOm0bq4i//7g?=
 =?us-ascii?Q?ZtlBZ9vmorBFAHmtl3peb/Ot9Kim0gZpfcZO29SH8l3haNge4bxUbiDhSWYV?=
 =?us-ascii?Q?lX6sve2VcPixE8iH6CU8s4Gc4Gqtbqu6ZjDxAi6Fg3jgu7wZBIsIlZsb5idJ?=
 =?us-ascii?Q?pNf1E8CfQuzkxwN0kFQ0ogDJnuLVIaPzQ9RtSFizgdFZMOqlhSE4FAZHBmF7?=
 =?us-ascii?Q?uL84AN5PQjgwu+5mI73HMscWbYaDW4HALd47y5RTOCMDJD1sOtBWzbuwXV3G?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1103078d-3ade-46e0-1487-08dab71b6a99
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:20.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRb5kDOM3VPrueF7pjZOjlMd6uFY+N2unaFysDjBc76hufpS4a8XvNpkn6ugPmU+awiT1fK631OW4jgKyFyttg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260036
X-Proofpoint-GUID: KljJvCi51mruatka03hkIaQYpEWabE7E
X-Proofpoint-ORIG-GUID: KljJvCi51mruatka03hkIaQYpEWabE7E
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

commit e83cf875d67a6cb9ddfaa8b45d2fa93d12b5c66f upstream.

Add a xfs_failaddr_t parameter to this function so that callers can
potentially pass in (and therefore report) the exact point in the code
where we decided that a metadata buffer was corrupt.  This enables us to
wire it up to checking functions that have to run outside of verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_buf.c   | 2 +-
 fs/xfs/xfs_error.c | 5 +++--
 fs/xfs/xfs_error.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 948824d044b3..4f18457aae2a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1564,7 +1564,7 @@ __xfs_buf_mark_corrupt(
 {
 	ASSERT(bp->b_flags & XBF_DONE);
 
-	xfs_buf_corruption_error(bp);
+	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b32c47c20e8a..e9acd58248f9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -350,13 +350,14 @@ xfs_corruption_error(
  */
 void
 xfs_buf_corruption_error(
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 
 	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
 		  "Metadata corruption detected at %pS, %s block 0x%llx",
-		  __return_address, bp->b_ops->name, bp->b_bn);
+		  fa, bp->b_ops->name, bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index c319379f7d1a..c6bb7d7a2161 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,7 +15,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
-void xfs_buf_corruption_error(struct xfs_buf *bp);
+void xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
-- 
2.35.1

