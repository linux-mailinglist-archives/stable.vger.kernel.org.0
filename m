Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D160DB24
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiJZG3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiJZG3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8C5A1B0;
        Tue, 25 Oct 2022 23:29:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nVkt030448;
        Wed, 26 Oct 2022 06:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4geLziDcMCIM2wjykWi7uqPe+448JJutxxTPdP4lXvE=;
 b=t7czbmLK/SwWfYZ9EyyW2zjExyjQuhqr2SDWz/RYMcE1FdXZuDLKxa9ucegs+s3RqQt3
 NlVh/kFkAg7BJjBpeSAguovxVntQ2y71K0b1+t2WkptgmK2J5I8SEfuneJNyqjTTJGIm
 4Un8EQKbgW/q9ltFS5xLZSrPmzKLXfslDjtIudcWBYX2JNx0u3nS+JbIWRVQcoY2+zfO
 QQzc+A5fENW8f61sxqQED0/QdCLIR67cOyT2jcuWGded1zZu7+Ji6GGejjtkrcl3ZarA
 K4EB6i2uZeJdr7G0mvSMZ06VpUsDWFBB6tk4LY6p69R0L1UKGJTj1X9f5lWowdRVq8M2 Rw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x229-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q336rM031838;
        Wed, 26 Oct 2022 06:29:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybe7cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGwuEJv8jbaTFFMt7FJzAZ48bUfEw2WDYw8EY5PtJwXCERvWLdcTdEqSsBGWAw/bPTVXYqMB/3HxiWf6xrkJTZkeR2IzSElm2tB6kccPQyMhUhDAa7IIHB909VNtC6mlezzGxGldrp5nF57qqxqGVlpmHL6ibD0SmmAs5tkpPLWMFVY25VhKa/ZSpqw8bAoL9DXYQ8NO5zMcI6jHuFmn6E/fPNsf1LB0LXmUWrzcCS6F6uwOX0S2rQyV7WzNiqNPYncGPtSNkfEkSukg21e3U/OJjCB+RxPsDlponwDJ3Z9xtol/MmN8wC3TbHc1nyYsC9VzKZyIfgPBQ++AOIpkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4geLziDcMCIM2wjykWi7uqPe+448JJutxxTPdP4lXvE=;
 b=arF8KSd1vBXVpq9ghTMgfmy7ntc9LkGhu7Zf5TfwSSFzMs3gBWlfveAGc9ceV0/vVFC2olLdcNpqy4/oKt+Ct2Q5XCMbvQFKyA3excvoDR4g6GZoMsY39ftt36TsH3CchBiwfm7V71YwkOWwn0j+OgeUKpdVBoEXI6y3CPHsiPqM718Uz67FecKIqC6AvomG2YQiLa0rRVRbB7RXDFK8+wvzW4SNc1+LPgZxXS0p9aAE/kCfKoPjTgrH8CThIndeEoJJVNd4Edjpftqw0en2eQEykbWjN0RxOwhYdSqaGySciQMZP7pHIGA9VNDixbkPGIaMGojlPa9nyaLCeufB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4geLziDcMCIM2wjykWi7uqPe+448JJutxxTPdP4lXvE=;
 b=DpjJcamh+teKb/BDYlwOKQTgPRXajeCb+eCp9qT+velW/k+KTCiDCv/FRDXrnK65Dk9Qhqr15y/oSnTPZlkUnC/fcZ4s53cIGOnH60WGEaZnGvYDdSwK7J77DobnXpvlL8xirf4f6yZvGaxa4wcZKM8CtvWe4r65hWkLx6YP4uU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:29:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 06/26] xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
Date:   Wed, 26 Oct 2022 11:58:23 +0530
Message-Id: <20221026062843.927600-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0195.jpnprd01.prod.outlook.com
 (2603:1096:400:2b0::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: bdbc8a85-d001-4281-26fd-08dab71b6dde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzU8lZ/ZhVLaOnfIiE9ydPLTODkpuFrGinu6erjWTBxD9SC3KZy3FI7tIJnZCd/q8F8Dl3dlf1yr3BosglZImM5/QPS3YCIvuxOxZFhuelkcUJPN1zu4FZJL5j9eGFwhpek+SL3QIxKKiimWub440+WCFDitsfKhtugss+lJAUKvevTkYplYYNQwCPuLNu4q+epdj8fbzxxo78jTSc4Li9yFMhe3+S7bYqBuikHc4aFHaqcnvR7Uecv0VQkakdEWWquWTCRGBTsv+qTumqDxF4iMr5eGJuZcA41E2eBsEulvgPWaLF7jxva8SsfQ7rFETZDjEF6/Afl0WFne3Wn19qHCTziBanqo9DHTbiuQGHlOsjaeDlvJbyGjPcTCPDgZ/iMwYMHXAHvOWt4ziNnzfXAR4lOzCW2IrL/4fx0E/Az7Mv/JZ5FFJUM0oVLIk8cNFzRjWC/4+rfA0jMjc64/hwE3GqoCLlCIYUOMEvpDinNtXg9w1/xwIyFpbq0N/p5KWtDg73GAMHHXH8DR8jkotZtzLrkbWEiN8qBjcjJyYVsmGAu2uokT4yDxbqpB9Ks9oXebzNYwlR1LiuuJxVyBSmD8TZ5mcz9H5XbpOYrTYN2IDA+jHjcVRAhQgNBTFBiUKs62pBxWEhcCvxwvocXil4Q/8wM2TAzfYGyua4GbSatWzyKJ1KgtpcAY/GQEIHQ76rHA9nrTX6wPRBadWh4BvhiagxayfaDxjVafNHxUlSQK1v6m4Ke5hY2sZ+61hzD7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jakwv6QL4bQdmHmfavzCkLzbroxWdyA5JeCNB2lYrGZzIST+vsdcbVLcrpdm?=
 =?us-ascii?Q?ErkfbKSYzPx+JO36qCZKZeTF+asDy4UDqTxb91azTMMlqQNfGIABEG6Suktv?=
 =?us-ascii?Q?yU9gijHi4U2GciWR5t8vFwZnN4/ymuIb0LuLWc4KeQRdNMM0YULTTfApm7wk?=
 =?us-ascii?Q?QTfTno/jLqyExlZwtYCw0ifvz6UZS0XFqfL3uYc+Gn1XiOu34G5vqBGRvWl3?=
 =?us-ascii?Q?qN1WIY9e8NZwXoo5II2vInE6fxHDyXSAkpVMKLfALYh6WBDenjVTKVDDkpgh?=
 =?us-ascii?Q?wWn3+k9dw7wnk/UtyaCwayzHgrwRvw2nCz5KzNKJG+r3QBmziDgCsihCcEao?=
 =?us-ascii?Q?PJPuL4RFhbGlZlVLrHbohhUCzpcFiXGLTrQpPWrDSr+61M9u50yR+reFSRId?=
 =?us-ascii?Q?X/9IBJ4TWc6EOW3e/c8gjGzFrVKUEsaibUACTX430hk2gNdWWhglCNpVnweK?=
 =?us-ascii?Q?oep+qe/W5X1Wy82s+vGeKbadDlAqbPKg3IogX3pdquRvb2wHwN5sE4muFVmT?=
 =?us-ascii?Q?po5FoP//JB4/g5NljTayqMrXzLbi/sLDaeBdTg98BF1q8+DlFOQo9C7tVmgZ?=
 =?us-ascii?Q?ZYI1hlEPCPxnFItcWEyG+B0xSey6kqWOYyfONff9bOMZ7Oq+EZrOK3dRheGP?=
 =?us-ascii?Q?JSXpjg+81lDrLSjWNNqaL1hWUU8+myAlafNYvL2czkJlx/DsPm/aI6U21135?=
 =?us-ascii?Q?yuy+bW6KCJ3IcEmcKG9w//qDnEGex/gC0PWgfA9C4EQXozmSIjVAL4puYFAD?=
 =?us-ascii?Q?v/9m+DgeypCslNjHtE+NhSVoFQLi4qPexY2M1QxgTMsnRwXhH+NEIwHgUPpT?=
 =?us-ascii?Q?IHYe36PgNzfiL2UqPH4wUzP863fkhGdeuPCngVeXB3sbXzawAXT34m3H+9pD?=
 =?us-ascii?Q?JIT7tmtTp7O+CmBDS8fQy4WHXILQUQ4WRvfSdYMscITXztGiTTLOiXl7x4lL?=
 =?us-ascii?Q?8Ncvo9LNWbgOaK6w+gWvyMPz0uHHYW9VENlZU1b5u5oQh1pekxbJ3v8918tb?=
 =?us-ascii?Q?Kigebb1gGFtDUboVVonKi1NMrwXESOy1h/BpVThoyX+bHYleOmkM3Bh7mvmW?=
 =?us-ascii?Q?OIr8vIL+esXb4SI0lFMi4D3LgtwYFgSHf/RHiOZptIigNrycJlWmkp/G+L69?=
 =?us-ascii?Q?RLLImzlFUMghju38txXQ7VxqpmtjgWVGURClTx8VIoCpQK15N446ITT0hGrR?=
 =?us-ascii?Q?CIltTlZV3lsTeTplU8MknkZAFvMQnm+t3uFGLknQPPXL0PX74oPqbehBD4OE?=
 =?us-ascii?Q?I1MwDP/tSwl4WbTDb9e2xMhi/vgBwPUSwejLehHdA9ZlGVb18fzf/skccvGm?=
 =?us-ascii?Q?moiUlgs9dclMkrIW+E63wM6K9+ls/HzQC8bZiZuouImt4Lx3UINPUDJkybZC?=
 =?us-ascii?Q?BknsTwkpxTkFEhsLkS2licAdbCByVaeOVbaE0mIueqSoVWWsoFYNIOGz6JMr?=
 =?us-ascii?Q?ungyaKjIFTUCS+8TG8fwnhKgy6Ijv6V6MsJ8t0rDuyHsF6jbiw7S1uJp46ox?=
 =?us-ascii?Q?Dzxx4eq43bssf0HXfyPUyeSTQgFTT6OyBgSE1KCAByDooDn8ljBFOkrO5ixE?=
 =?us-ascii?Q?n1eIZHUY8479c7/QB8wyxKUBPLba09Fc170EAq3hJJTx+JrJUnvpQ9WXZJKB?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbc8a85-d001-4281-26fd-08dab71b6dde
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:26.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un3lx7vc/CYsCbROJ7iAe4gvfdDTwFKmXSquG+5+bNNAMkrBse4yQ5BN14fVbkgI4UK2Lpi1U8z2TXVNiorXEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=961 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: DrUtxVc_g3GwnPYSohTBJwyrF5iSVzBM
X-Proofpoint-ORIG-GUID: DrUtxVc_g3GwnPYSohTBJwyrF5iSVzBM
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

commit ce99494c9699df58b31d0a839e957f86cd58c755 upstream.

xfs_verifier_error is supposed to be called on a corrupt metadata buffer
from within a buffer verifier function, whereas xfs_buf_mark_corrupt
is the function to be called when a piece of code has read a buffer and
catches something that a read verifier cannot.  The first function sets
b_error anticipating that the low level buffer handling code will see
the nonzero b_error and clear XBF_DONE on the buffer, whereas the second
function does not.

Since xfs_dir3_free_header_check examines fields in the dir free block
header that require more context than can be provided to read verifiers,
we must call xfs_buf_mark_corrupt when it finds a problem.

Switching the calls has a secondary effect that we no longer corrupt the
buffer state by setting b_error and leaving XBF_DONE set.  When /that/
happens, we'll trip over various state assertions (most commonly the
b_error check in xfs_buf_reverify) on a subsequent attempt to read the
buffer.

Fixes: bc1a09b8e334bf5f ("xfs: refactor verifier callers to print address of failing check")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 1c8a12f229b5..c8c3c3af539f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -208,7 +208,7 @@ __xfs_dir3_free_read(
 	/* Check things that we can't do in the verifier. */
 	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
 	if (fa) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
 		return -EFSCORRUPTED;
-- 
2.35.1

