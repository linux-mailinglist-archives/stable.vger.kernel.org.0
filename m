Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E159D698CC3
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBPGXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjBPGXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:23:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C543A0BC;
        Wed, 15 Feb 2023 22:23:19 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2Jcl1000725;
        Thu, 16 Feb 2023 05:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KwZ02qIToTCXTa8CLongtSjCYx5Ca1nrdNUSkiKtB7Y=;
 b=e8tgUI5Mvlji2M2qinOtm0DV6YdVBi2LKWidFqouWBwUxirW/+tOQiT6juiwFmEO4Vz0
 UdkziAjBQuENlzLFkyjrmJOgwZUP9yeWAwO2r+/gYEsZfnSC6f2/QMSn/u3QQ2FRCAmI
 F4AGU8pQCNmGOg5Od9B4Q61pCxcm7DhH8j25oj/yI1vd96mIpJo2dgKfnNlBtob1+wO+
 wByRrO2VO7zk7VFSXP3j+n06fHMFdBptxWQXlCPH1zWR8qUARxD6nrS3BRDXv6+NNUTJ
 XWI06bJ+iqoNuDYRGvf8H4KJep8SRc9hC/TrM6adt7ibMxVrdwV/CikJ9ttXLe78pqkn og== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3ju26rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2Xr4D024622;
        Thu, 16 Feb 2023 05:21:25 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8mxfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuK1BJwS4UfcpEVn4pwwkI+I/wDkSl7Qa1FRVs7AqN3TE3G0ZAvXcVH4v5uWkRCTGg1ODrFDZr0cwhq6vBHK2ibrZlzCjxjuq2AElYbH3FrDozUWRR4DDSYiS6u6NZR/+uVA1YeZ4rkK7QYUMpyEPJP8zkbIIey2kT81hWj1XWnjsdAw/glRjdXSJts/LaEeilwZ9MYjmLQGtfJfZkyLFEvojDng0Vupi0wc5+MBJOkNY8/I9bXPZC+EZIDIjCvs/4QAuCG0LdEn8P4S7QPOglgt3IOva4Rixkq6sjzGc9lsPUxLszL0kXu7g2HhbMRQKCupZ8UL/QEz1ypzHlU3Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwZ02qIToTCXTa8CLongtSjCYx5Ca1nrdNUSkiKtB7Y=;
 b=LPX/i6NnUayIU9NmW+qJW9JiwI1zU86sqKBXcXdwQZzvMcGPhX/MbQQAUriUUZ45CEjqo3tgRuXmiwBhrfhJjh8kjOyR27XoJl2r+x6pkXvA5sPvJiE5xCHAa0Pa3WQPNhTTKreP87LyTLcLwCHvoFYx6EHZmkJoc88mJJ1rz7hJEr+G2988SJcreF+y5S96d31EP9LoPwglcG8Ig2iBPNfWPFsv/Vw9Vh7slfvmnUpe6isSJE8MnNRQUplvy4zY5JQ9Utk7Vr7zW3hCzarb1A1nKpnMn6BtyCTzxyAW+8rd7m0dgaCb5lHYCmRuTuqkUjSiS9GXUm5Dcnlz54quHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwZ02qIToTCXTa8CLongtSjCYx5Ca1nrdNUSkiKtB7Y=;
 b=H2/CfPYWfupuedi81r7riK6mYM9N83rLHy61kXHNGgE1uwWdWWzLaGQjaY+QEzBENLfmSg95zHRGY+Cx+kDpGDF+FcqtPytF9nKYlpl0ItheXkyi4hXrrz96wjLG0anXmguMzqspKjWn+jk25f4bYW9J/Qq7jaHHItB1Q8v0SDc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 08/25] xfs: refactor xfs_defer_finish_noroll
Date:   Thu, 16 Feb 2023 10:50:02 +0530
Message-Id: <20230216052019.368896-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0134.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: e63c2be1-799f-4172-74b8-08db0fdda4b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pfgGUBL3oDGOxFEOD178zfGIo2FLoAznfYrUEUotvrCAhhlkQGUIKmP2xYlRlxCvvKxo/NUBmUuf0T5nVoN5TGEScfvC0BuK4LnQgQTdvYgbzuzN/3GPff79P103Y8sUw/+HgnCDFqEXkXPVFd9K2TBivc5XVnY+oawIeRm1MiI1gR0fqDmyrq8jEk6uJGXMBaOonw/9r2NZChbTZQWYTrdyGvizmYgNNEaZA9SIZjlWFfaNw3LgKmvb8kBXmYd0Je1OnLL5l1Cekibzw5oh2Q13KXNth78OV2ZqqvoonRV+duJEkO5j8ACRRXA0w4hYOJX93J96+XAZv/GmN6xplQNak0Qg45jy6ELLi+EbCvpLOasARpGH0EV7E3PrWF987OcuXgIMp+bZR376FAZxLaa1TOkM8+ICLOUe38ZwKfvzQt/jv1Fm7V7I631uORFCyq4cNbWrnnogNTTZGhBjrDpOm15vcn+Ks/kBWuoTjEOLbpYq73ovWGISOb67zna/N14UHHmNQvS1u1DAzuSnDR0QtjIEhIqvbVNzD+JgbvBFQbU9iEpK5e0Z8Kzqb6KHU7QcLosj8s32haDJakHTTsI/LqLh1TRO44JK/Y4/oMUahbH4LTaO33Uh+AZoG6TeazoEBsSEpkv2HOccmm2Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mMyGmiHhN6NQJs2r2k1tZRQCSoBypHGcEM7Glg4yLHBeJ54wq1HORhVrS8oH?=
 =?us-ascii?Q?XDp4GJenU4JKK5ldbRtYA1Sf0O5O6qMNX0lboKJek7ekqwJ1xqikYGT9xt5o?=
 =?us-ascii?Q?TL4elVilYb1Lmkb5EbNh+sKSeAvPp8Ub5RExJKjxCwdGai/1j0jo38VGGUB6?=
 =?us-ascii?Q?YZHN1KJA6YJsL055XQFMBUOqiSq0lNcf0SNFGX4b4uyDoX3teUrurvKiWX64?=
 =?us-ascii?Q?lHvtmGbdyI1U7vedfPYIdwg1F0UGU/GQWtfUMXbs51qNC1IinTLhoi4P5m4T?=
 =?us-ascii?Q?7iBhSeRgBYlTCWrK6AkqZhDoLnneKx1m21aq+0rj5blNib14CbTI9ZyO1KuO?=
 =?us-ascii?Q?rUOv2Nr6O4GRMUOHtGOtBq5YGfOsydaZAsxwklmINXwWG56udtUiBOEVkDjp?=
 =?us-ascii?Q?KsdUNUW4bQaPpgLDsYSm6Au7L1aXRZ9UJP5n1Mn0fRTHDQOtCOFflyJuSDI7?=
 =?us-ascii?Q?whUKiICy6YL37Bx7emHEC1kvMJ2PIXMQNCu0rH0gYFoMXwdXGQQ08cFJaY8Q?=
 =?us-ascii?Q?7h6EslHdxP++fGMOipqDDwy2512KAhaRpZdQFbBDmjsvMoAwF+X31N8nikRC?=
 =?us-ascii?Q?RYpKYQzPRKx3xz8RnQLFyaLFJDJrg7pkBbTX7cjQy0tLtJJaK0Z3GzskDcvz?=
 =?us-ascii?Q?wKc7Q2YFzFuqavp4Cd4mzWYx43LbSApl9DoLydFVfIeok3OyJthBR7Uojaps?=
 =?us-ascii?Q?1q3K7Xnto+OTT1xSYrZQF6tq0SkhutXFUhEfufCrgzk2RJeYG/H4AEgQOJZF?=
 =?us-ascii?Q?jPL7n7R3n0HSGyEhGvQxFY3dCgmkpzBHlSmqqImX+WNT1p7U9q4aRHbGEeub?=
 =?us-ascii?Q?O3UeNsMxESLbfpWTb3+M1cftFf1nGJ/aR1YwAfz0wxefqMfcY3r8OfDDzmWY?=
 =?us-ascii?Q?Bi9/8HxQHptM1pS1xFqYRkRduQneKg6EICx31++pCcMa2PfhdXCutGQoeN9I?=
 =?us-ascii?Q?IgZKsBN+7rCmKnInMN0uEk/Za1jMB2y1p5NOfv366RTzQi4H//132B/pvUGl?=
 =?us-ascii?Q?lYOa7TCNhkV6+zipCBwlM5UoDXiuusJ4UcLhOL6OinXyIS0vdXPs4WDypPhj?=
 =?us-ascii?Q?wUvh+a2tkd+Z+VgbjPX8GNg5uyVC0GxuRiiXeRZRTI0JOXKacpZ5VkHI1gh8?=
 =?us-ascii?Q?hnQbUCJR++LP58R8167QnIcVlkemL9C2ZVeGAxZ43zreFjuFY05jsurn2Azu?=
 =?us-ascii?Q?MNh9lz+bZedyxL5xDAZ0hnNzcLyVzGQMwbIj9CCDf3X/VxtP5+4Kgj+Pohlp?=
 =?us-ascii?Q?9N0rZOmKq2eIjeyBiCgKQLKhItawBPHKgNcSuyOk0GD245vFzgpeK/AAXHID?=
 =?us-ascii?Q?sd4IzVxiFuMVjJN7jNHU2ki3QgdiDCvtW4jaz6sVaMJpyTLWgrvV1gT4Uklh?=
 =?us-ascii?Q?W9op1jI9TAjCeF0dbezlKCktVnZK77jVEZaRdfPDcmK3BqeWqzjkg8X1raBh?=
 =?us-ascii?Q?b9DFH3CZGFIlLarzLkxmohTk8GP97iKyXFq94rX/jbqLcnK/ddeA+KbIcTFw?=
 =?us-ascii?Q?x0R/q+THJJi5l2kSMbJHgqnyTwSoWPoNjnTi1UuGDiVe50+LbQNxYErJp+5Q?=
 =?us-ascii?Q?NLiFfFk9zOyPnxXB7gGXhAT4gWSvPcK2U5/14i71SASpRulN9nQJWrdSoiST?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0EwplfwSBS0dfQra9b70KxV1zCr4PXLxvIupL8XPxtzN5zy4w6N3VHLkUxtjZlyedFdJ//x6Ba7DaxYXXAUoPlqfzoUqG78LiZflrVW9GoHv29xgqLT0x+F4dLzUy+fuQKUsEUnqStGCzwN92m5Zowvg8wfe50luNClkNoK6gPVQqjQ7sA4Ix5WD4IRrc/6udL+QoyV1SzNTFuHrJHOUFec+qW8/WY5RZNvXOis4rGuV6BVW3RGOtkZQLSeJ9NcSWeYvhrMDRg8QpmzNDMTx8V2BNLCVuBpyJrRJLNe/tG/UFy2naIA6Lc/Qe4zXiH0rBqfqNoHrcm3UMxNA13WGoo0/R9RzvVdlE2ztEM0QxS5Hh3IKjWDegpb39+Hb4EdfC61vRMyVltkfdVDoRs/XFrEq/ftHRLQigXXm/ofP3Rg3etEUR9O93dQWMDmXWtLhDqRlZQpH/MC4WiAjRLoUcyJovsSw+9GuJVDSwbfhdSVu+ujTYIpnPteaiHxFCQyNelg9lzW7yu3h3kH4wBvAUG10oRvISjzwBAbHE0gyIg1dmwCuOOAeWtaU+8SLLg2TwD6txYQ/UHvSVXSKZuxREE3cfKNYneplLDwu/bGQtCtLjLSii8SHy/Aftg+WiTD+c7524lkvMBkY2mWwa+zCjkChbhQ4uqcaNIzXyeg8EdiOTkHO5erzlt5NYE6z+QkOVk/LzOR2UjH3YksPNdbnlKVhchcqhL1JfCiLm7N0yfoS9H/aCDR8ahkzw/U8l5Hv/T01MG5J58SYjXhDVzfmPhX+ix+4NRT74rQrLHVQHhKKeB/QAEWg5Hezpd29lfTK26ygMG+KRcZhuf76jRkVEnGAFCpLg7PE282dTNCcYwQS9+bm7UtmhLMaC8YT6tso
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e63c2be1-799f-4172-74b8-08db0fdda4b4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:23.0723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72mgkvGlT2Ti0NCz1Wm58faGEqwA+8sOkj/donba9qyt4ga7v3Z/uLIIwnrqHqlQwpyxtSZOdeUzI/7K7KZ2Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: YpPBx4iRRbAavyhaqyRpv7r-NhCY6B9G
X-Proofpoint-GUID: YpPBx4iRRbAavyhaqyRpv7r-NhCY6B9G
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit bb47d79750f1a68a75d4c7defc2da934ba31de14 upstream.

Split out a helper that operates on a single xfs_defer_pending structure
to untangle the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 128 ++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f5a3c5262933..ad7ed5f39d04 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -359,6 +359,53 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Log an intent-done item for the first pending intent, and finish the work
+ * items.
+ */
+static int
+xfs_defer_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	void				*state = NULL;
+	struct list_head		*li, *n;
+	int				error;
+
+	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
+
+	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	list_for_each_safe(li, n, &dfp->dfp_work) {
+		list_del(li);
+		dfp->dfp_count--;
+		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
+		if (error == -EAGAIN) {
+			/*
+			 * Caller wants a fresh transaction; put the work item
+			 * back on the list and log a new log intent item to
+			 * replace the old one.  See "Requesting a Fresh
+			 * Transaction while Finishing Deferred Work" above.
+			 */
+			list_add(li, &dfp->dfp_work);
+			dfp->dfp_count++;
+			dfp->dfp_done = NULL;
+			xfs_defer_create_intent(tp, dfp, false);
+		}
+
+		if (error)
+			goto out;
+	}
+
+	/* Done with the dfp, free it. */
+	list_del(&dfp->dfp_list);
+	kmem_free(dfp);
+out:
+	if (ops->finish_cleanup)
+		ops->finish_cleanup(tp, state, error);
+	return error;
+}
+
 /*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
@@ -372,11 +419,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp;
-	struct list_head		*li;
-	struct list_head		*n;
-	void				*state;
 	int				error = 0;
-	const struct xfs_defer_op_type	*ops;
 	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -385,83 +428,30 @@ xfs_defer_finish_noroll(
 
 	/* Until we run out of pending work to finish... */
 	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
-		/* log intents and pull in intake items */
 		xfs_defer_create_intents(*tp);
 		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
 
-		/*
-		 * Roll the transaction.
-		 */
 		error = xfs_defer_trans_roll(tp);
 		if (error)
-			goto out;
+			goto out_shutdown;
 
-		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
-		dfp->dfp_done = ops->create_done(*tp, dfp->dfp_intent,
-				dfp->dfp_count);
-
-		/* Finish the work items. */
-		state = NULL;
-		list_for_each_safe(li, n, &dfp->dfp_work) {
-			list_del(li);
-			dfp->dfp_count--;
-			error = ops->finish_item(*tp, li, dfp->dfp_done,
-					&state);
-			if (error == -EAGAIN) {
-				/*
-				 * Caller wants a fresh transaction;
-				 * put the work item back on the list
-				 * and jump out.
-				 */
-				list_add(li, &dfp->dfp_work);
-				dfp->dfp_count++;
-				break;
-			} else if (error) {
-				/*
-				 * Clean up after ourselves and jump out.
-				 * xfs_defer_cancel will take care of freeing
-				 * all these lists and stuff.
-				 */
-				if (ops->finish_cleanup)
-					ops->finish_cleanup(*tp, state, error);
-				goto out;
-			}
-		}
-		if (error == -EAGAIN) {
-			/*
-			 * Caller wants a fresh transaction, so log a new log
-			 * intent item to replace the old one and roll the
-			 * transaction.  See "Requesting a Fresh Transaction
-			 * while Finishing Deferred Work" above.
-			 */
-			dfp->dfp_done = NULL;
-			xfs_defer_create_intent(*tp, dfp, false);
-		} else {
-			/* Done with the dfp, free it. */
-			list_del(&dfp->dfp_list);
-			kmem_free(dfp);
-		}
-
-		if (ops->finish_cleanup)
-			ops->finish_cleanup(*tp, state, error);
-	}
-
-out:
-	if (error) {
-		xfs_defer_trans_abort(*tp, &dop_pending);
-		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
-		trace_xfs_defer_finish_error(*tp, error);
-		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
-		xfs_defer_cancel(*tp);
-		return error;
+		error = xfs_defer_finish_one(*tp, dfp);
+		if (error && error != -EAGAIN)
+			goto out_shutdown;
 	}
 
 	trace_xfs_defer_finish_done(*tp, _RET_IP_);
 	return 0;
+
+out_shutdown:
+	xfs_defer_trans_abort(*tp, &dop_pending);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+	trace_xfs_defer_finish_error(*tp, error);
+	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	xfs_defer_cancel(*tp);
+	return error;
 }
 
 int
-- 
2.35.1

