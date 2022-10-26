Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCE660DB26
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiJZG3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiJZG3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5B365CC;
        Tue, 25 Oct 2022 23:29:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1naKt024687;
        Wed, 26 Oct 2022 06:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hGeajXiJmzJw+C0wcLKSWZWKF7gzty0zx76vtcdM3kE=;
 b=GdUCZ+yE0dM1CEvhJloDbULlO0lCIgToupZf9UvEYtt2qIGG9a35Tiy/dxHGJKFVLTco
 fkcDG9ua9LI2tBry7QUh2/N9d7LhWWeDO2L0v1erB9gn8QChqWTjIvea833xa05dej2W
 Q0R9DhkOAxffYPEEjbAB3GwXzW5MSCC/DmYQ4d3EqF+BkbntWSTYYVAwcsyA8he/8aR2
 PyLqbfCLtZhh3I0SVIzJYEqIFrI1yqE99+WLNA29vmlLm62bHFlbntM54gnC7BRoC+wr
 z5Em9paiZFXr6k2s4MWfeZ9n9aPiv4nIInAPjwEooYEpEC1rljAjYP9brVU6ABCcx6Di +A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnbgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2nxLq022012;
        Wed, 26 Oct 2022 06:29:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybpqpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY0Bkl3/kRFUEA2mZUk5TyjlnjRG8H1nqdO3iRvOOUooKrR1ZwfHkHI+iFuo1kzPmjsK2ysdVL5CfhslgquImaUerOd2kRrk4V3PH1rwDRQl9b4VHldnTaYvy0hfDls0FrFZqiVbJfpQ4kT6ylFVbzrqbJp3umir14JZgf6wV2r2MMQYdDWaZUh3fMV++FeN4rwlF12gF0UTkAwRAf4EMhUFGJ2XKFcRBEpXggVgod+QyL1Nb/NS2n0ivIFz3aRLxADuBgNLMj7e9WKhROHuafzMuwV1M77hDvFUkAvZw0FI9Mvv15Pppol5UmlW1w1Zw5LZB4vkHy+2jQfnge1ZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGeajXiJmzJw+C0wcLKSWZWKF7gzty0zx76vtcdM3kE=;
 b=je2vmycjzCGHGrWXuKEz4wWF6tpZYFFFDcB9TdIWC/eiG7mVh7AwBEO+IQlUpppW9iGZlhT137KdgABzh+Rsyw2XwO/e3auUa/h6he5rlKH1fwxxJQyEx88FK/wwTZRLeh3KoRthiVnuRRXQnKEpg/9+6diOSyTFkZGHjjdjWZuuhBnkXC8YyGX2VabLi1OWXRs7cAnNaMz5HTEW40pvjNrAWy6OcDxUPD6SX+j2/RgpgZNr97tJCqZpBkem1G7HV+z2o9bZ9GRwHHTVU6g65noVu9xPTNxSgQ/+JWN4tpMs5XsF+knbyDkSVm+38yX7foq9iMgybUrzgbKw/wA9GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGeajXiJmzJw+C0wcLKSWZWKF7gzty0zx76vtcdM3kE=;
 b=DKLp8LhIEFuHvqAU2UQQ9oaRgtjJOPosm75pWLGh6oK68Z8o3KwnM+U3czeGbS8Ur+MJ1D06nseGl1M3813Lc6oTFRJ0uViFgnv9+7K7S+Tz/NHfSCiY5pN62CWv8dAWjsdAiVN1b4HkD9Yqz1ytQyoF0bJGwDbIIqN68lxIIAM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:29:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 07/26] xfs: check owner of dir3 data blocks
Date:   Wed, 26 Oct 2022 11:58:24 +0530
Message-Id: <20221026062843.927600-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 0581b569-fb03-4e7c-4051-08dab71b7161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKz6rwTzCgbGKP0ucGqahOA47/5IhXxpexC5qewAUYZlqOaCA3mWTRbAPvEmmUJa/gT7NT+3PjHhw/xn7zjkJ23Tut+9pSr4a1SXnn37fpuoRG6ZCKiTHkb6Su6InfAEqyrHn4Am11IRkEoqDiUwEUr+IQtW6Fble6p42dDIXweKNJQBAtwZLQEkRWeqyVtdQdZHbyLhUOUfj+Y8sqoIDqDyhTa035IuCAS9w6K8mIXJvN/jJG70+/YtLQxZ4D3Mm88fx7hJMuC52CUUDsvhW8/Uod8BNVG0eRPArBLItGkKCvNYUuElFsIDXC6pWRUVds1/TJFRwmVHj+xicjWcwa5M4dHsrCjV3LF8AwijlPoacmbxDHZejsOyII9IC4WZ+j+J0Pk+fZD1G3oIOGFJcJqJAAiJW380TH2iwq2yCDX1aj7hTGPw2VyFRBr6sykSz5o/yj6ghE+5kkrYetb49mkKOFwdO1/NcNUOvs44DKSLmPNV6CmGk0ICAe58DSiXQ819/8BaCzQrChkIUHQNkeSNJuu0ustgvjd49TcqaQcmioOKg/0dsOGHTz9nVLNgKKBL0DqKtHtDzeqjT+AbXreeFRJS70Jnib1GvqipdQgFBdKK6Cgo9mbyIJnekFTTVLzpls08NjUqkD02jPKE/f/oMfxW7PL9ROj2aPbi0wjSsiO90hEtCOdJX97qJU/KN6LhRIepqFryG+GsgY2Dq31nroy+6Kc7nXfaaogsxPwoTrytl1yqmYNiOoD1xtfd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/et3PfXC5s+1/cYCo0xb7IH3JBw9F/5lzifKn7bbA1PJVttdqE5TtUYpLgJA?=
 =?us-ascii?Q?la5xbqdq/uy72cFlgNbUpQdqkGr6/WT43WcvB78M58g4OhwRQ5K1fLH+59mW?=
 =?us-ascii?Q?38ptkkj+Tlq1MVthvgSFuiEruSh9FwMLIXDiVnXJztCj1r9EdS4DnhxDOi/R?=
 =?us-ascii?Q?UuliDlzhGhZ7Zi9Qk2qgv64niZ681h4Vfe2Oh8kt1/jj3Qh2jZXBlChe1DIe?=
 =?us-ascii?Q?9iEAV2+XQYdMI+aQIPI5wvbe4TJjan/u1BFF7hscDMllsGg6l4MlR7Dix9RF?=
 =?us-ascii?Q?DHj6wUxtX3aQdPt78nBouQdrekJs5C41stTfc8qIuP8YN8vyWZVhi/Y+8PRf?=
 =?us-ascii?Q?QhxxMPUtollfb7kNB48cLQs16nU5UBriQBt2rqJlPSjEcicEKdMlV24vxKKM?=
 =?us-ascii?Q?F9lQFnc9xyCou6wqHcyH5ldPiPkvH7j8/M5eDkoLFlLGqraTyJvauLeaJwdT?=
 =?us-ascii?Q?wBdcjchxSxcuv0KcDvP3ueTpnKJSQwyvoUmhvxXcq1gWS4CoUkrtoGeSHI14?=
 =?us-ascii?Q?O0fsST5T2zejNE35B8Y1Du6hkMGKMVvH5Mni1rSOQieHq8oLfJOIksjm1DOt?=
 =?us-ascii?Q?mplKB2JzU4kAf5xh+uvTxmJNTFTc42uojZiBMa/xJto4K+2gvQNydPmLf0kS?=
 =?us-ascii?Q?P0BosTh1mBPISzatdavL2ztY+X3HSX1FclIuNffzrqD4nK62WWm6oJxL0Aiw?=
 =?us-ascii?Q?Fef84tV1fC1PgYvbStVxOOBkxIv6SDpYhL4djlbVXfahHD93bPCkL3eceMVT?=
 =?us-ascii?Q?9Xt2zp9Hs6dcd5wFClusFaDdqIWHlFD2NMYaLDCST51TP0LaMR0LbWyz++Mv?=
 =?us-ascii?Q?CfGceJAI5reLquAcHoCn/JpvBZmjGx7CX6EqYqrxXBoHRVmouroVGhm2yoJW?=
 =?us-ascii?Q?bgWdjQL8iVS1zNNp3fKBy+4yn0yRmlU2f40ExgdXc0TXO9aQZEaom7sNkJJ/?=
 =?us-ascii?Q?9EF7z9e/3cqO5+T/2xAJeDdglx7bhQeDqooGOJ7VxIXTgpBU1cCFE6vZNtkN?=
 =?us-ascii?Q?08jGY5bgs3QIJO67Fn5E/httw0OWV2GGUtLmqvDfRER7ZBzA2Webeluh7H9Y?=
 =?us-ascii?Q?yjS6fP4FWi95zQ5OtSIvv9ntmhYTSQIhKoQk7L6ZEtpceImGd6ja+BlZTT9Y?=
 =?us-ascii?Q?wgEWuy3qygiEWbeZvDRjd23OOYG30YNKmG+9v+WZEL7Ft4Yqn0xNO9XltyMR?=
 =?us-ascii?Q?fmuBrylZsApvBxClA9DooceLaXnyYVXYjyUa5KZFQGpKdnMdGZwSXtkeXM+1?=
 =?us-ascii?Q?UQj6UolhC8bsmPL8Ov4fLDdvl3pNK2XTCKclu9OPlUy+ulBDdH5Nqq6Zf19d?=
 =?us-ascii?Q?8mn5Pf7Re+qrZAQfuhZtmqEevhIH/9bvX9jGPjIH1Nvv+ZUYWop7zdcsKNpA?=
 =?us-ascii?Q?2zfPWFx78NIJcqrYAj0ofM/U9SrRdVJsx6GJw40uSsyXbjaxWgCsK3/3Ccr6?=
 =?us-ascii?Q?rgD42N6/TgExVW7lO5k5s38ur0kgESVGdP7AinE3WPjM13o8ZgymxlXm1jY4?=
 =?us-ascii?Q?ddKQjU+u65dPe1EtOO7nQoEnKeaggDk769bYONz2K/rjUBIMCVADy5h5stbb?=
 =?us-ascii?Q?jaHbCsoCkp7bAEL/5riRIGf/I3aAYbyamiij9Rlzz0MxfGZpcNMg6yxIwyFW?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0581b569-fb03-4e7c-4051-08dab71b7161
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:32.2575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfdQSvUCvXbC/J17jaDht8kvuL7CYrwxPNcMty++G+rXeRceSVpt61dBkp/EgaVkUWIRQFjjA9u5LJIWY4xsxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: iT6twhD0T63pdQbx6X5-wRS4JsHtaTVw
X-Proofpoint-GUID: iT6twhD0T63pdQbx6X5-wRS4JsHtaTVw
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

commit a10c21ed5d5241d11cf1d5a4556730840572900b upstream.

[Slightly edit xfs_dir3_data_read() to work with existing mapped_bno argument instead
of flag values introduced in later kernels]

Check the owner field of dir3 data block headers.  If it's corrupt,
release the buffer and return EFSCORRUPTED.  All callers handle this
properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c79be4c3153..2d92bcd8c801 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -348,6 +348,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_data_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
 
 int
 xfs_dir3_data_read(
@@ -357,12 +373,24 @@ xfs_dir3_data_read(
 	xfs_daddr_t		mapped_bno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
-	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_data_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
 
-- 
2.35.1

