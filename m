Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225A460DB49
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiJZGbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJZGbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668DC9E6AA;
        Tue, 25 Oct 2022 23:31:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nJv9013900;
        Wed, 26 Oct 2022 06:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=sOdiRY/MX0q8piX0oTDPicwy5Iibe43049eHzFygcoA=;
 b=kkbSVK7Sw7oSEsScbx3EvuJb4fqZ8kYZj18D23+daRES1Pq8BTVUsnGS3t9rVCTG+hn4
 Dp3yYqfY159LGQK3Go9d6HbCX9yvX3Z2rLWqHa9sKeA3aFkoUq0R4dDu+T19C2ek1oOT
 8hfanTNfVj6Lt9GozA7uwEOuYnxOac47AIGBcXfWKDNhAjsXJcn81dVLiBnYUxHcjPNu
 3rDCtOeaF9ml8pggRNxtq1RKluMdE3j62K6crDIJJpK909n7inm5E4ve+AUklj1zqsam
 Zpzz785lsrlrx2sz+gu5uyPXmbt4zCV399670S1DC1RPxEdxrx5IqaTCgJSby16Mms3p mg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84t5hmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2urYl017724;
        Wed, 26 Oct 2022 06:31:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5myta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oelv65ao+W6yqSzKys7/qNElCBorIkSBvJY6Zw3+ba0+zJ/erky5FMbSMlqa8r42g/OoM5srW4tT5CfoBjTJG8Y41mcN6Uit4KHaNKpSt0cErXRqGqjkkoxLubFVh0Us9Z0B9YAxhuAsHiv0hOvNrlh2VI32Qv2ndHEw5eYx84IU44R4OzYYkdR8uS2pd1bgCNVC4LIcIJcOhVIIX9mKViF4hyy4wfj7vywpQq3sBzfsIue72eIEd1TDIyNGsknsbciZ3Q0RJny8mA+pFY/eqeLWm+MoVOq2LvrbWy7zPih4gK41fH/32qQtnRYCsa2tPbrGiSktNQCTXoxleGYrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOdiRY/MX0q8piX0oTDPicwy5Iibe43049eHzFygcoA=;
 b=ezgaYTTUIktNkoHKv4+IWyrMen7UVzX7daJHbS//Kz0W+9ifza8OBYCa43B06ljlvQKEM7pfwBtjD4/XQ5krlcwz321cxkgZf+/kTjGZ1DcnPwWL9jQdntf9H+exVEVQ8PCj6dGKs6RcV9LaX+CXgaE2MjbFoevu3EKTFeUv3CnCrbeWdLeVZ9pd/lE3h+Q+UrP8zHlGyWQvz1AZuXYjvtVV1l1rpqI+XAXQebn6uP7/zvGPENafmx26VaODLIMrE5yYWbFfBHRd3rlL5E0Z+iq5GFyfYDff7dUkmfUPVygnhszSrtXsMrN09am9ihevIpYocKa0WsmAq/vYOo6p1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOdiRY/MX0q8piX0oTDPicwy5Iibe43049eHzFygcoA=;
 b=zK76PRnXNtB4NaOha8/pjEOqUKMxTYAcRFd3GP4VTbMaxDdeOCtQvwtGpxB4lD8LmQHgsAEd5XbQDFyXnX+k4uacp6fIhIRZDLeogkTpvymims+egbGIVyN6n/G3QiRdgII48gvXsADfD2D+dn8PEdjSypr6lVIoPBEczqIv6Pk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:31:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:31:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 24/26] xfs: reflink should force the log out if mounted with wsync
Date:   Wed, 26 Oct 2022 11:58:41 +0530
Message-Id: <20221026062843.927600-25-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0002.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e809e0-0836-490e-35d2-08dab71bb370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tqt4t9c9irNuVhXCAvmQ2SD1/hXC3zVsc/hDWIAlrKntWEFec8VFfWL4yeLUqX9sR8OAwv9keRLYE7eORSYFHM0L3UJsGsNehY9/+P7An5gTEB99rIUqlMbputKESJol6/B0nhyJ/+DM6YUcQRQD6c+2pg5M7d09SiU371DgpT9j5TIyPAKOxzAQgymIFsG+l9zZjQPhZhtsIFpzCrx5Td8qsUbYbXyzAXxLPjdxSEO6WoFGowZqAry8il2OCWFqC6VLQ+aVr322QkecDkpIicXT/i3qtwJpcEzXBpgeoasYXXeTSlpsyGy0b/kkuXLAbWrNEFzTZCDsRVNtVAY+jt+hjLE2AZ+7YlErKGkImoy3QW9YJvskFYCDgc4lHPwYTBYDlQsCEiOSa8hKAz2o0aG3rJ1xXjeDRrF82wgGm8HMGHesJB2lzVBbHOeQLEHY1RnBJiKd9KJmti5icae1/R31C05inc+lc3sS/ey1f1ek3AQ38iUl4vhpstMG0X3hlnbt+oD25shQlz4v7s5C8cMZfYHvWLhpTwUTpL+PhySS+oB9j2CTWOzk+eUIFGYDR83JZGk0Z8OFI8+W9iBzSo3IvqKMPWWLtZv8IA/XPJdK9QlJBsem+Dkxwuou+l7aMGgl7tDXOGuXE2rDWE7CAiXyzvqq6ZSpCf+N6XwdaQMEHZ8BkeMk+st5ky8mBWi5u+g44ItIv4l9vj2jI6rnAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQ5TXcVAnZbtZc7pSm4dvJa4QGHWTmWsKVuSu4u+KsR3KLpYVP+taeTE3p7Q?=
 =?us-ascii?Q?Pn5hiV7d5UE71ws8aYWgR6HAXr7ZK/p5hzqehFHzuiHtP1L06SBjXR5B6nEH?=
 =?us-ascii?Q?u5817Cx6UBL6lFm39L1CCzBNWrXd/6cc+sRt/0kIffV5jxBE5/6bWClL8zu+?=
 =?us-ascii?Q?UMVGWUAH58SEfk9xyFMwdh+ss76NRbHe0UKvMPhnRxpJqzJG90CA8JtJziLv?=
 =?us-ascii?Q?qPGIJkSZKMUE0JrIn5bGMYB9rXPOxFJC1k5qHblCK3PjiTcu2h3rPqRiNomP?=
 =?us-ascii?Q?s1VWPh0yf62aH35kKeXMpgJpzbQseWDFRk6htzGpWYPQWLt5Kuy85sfvOHwC?=
 =?us-ascii?Q?pd601EfCX3Ru5SI+XE5VPgZxMxpwPvc/OL5fwvciZUoNYI0sE/6s/rHDOC10?=
 =?us-ascii?Q?Xjw1A0JaS8yMLwM6t0hx9rMpQqJcN1jBUh1AuShhL3+5Hd/2+y5fwQ8C/8GZ?=
 =?us-ascii?Q?q9z2T8EFFHQ0W1qnCOHDULbAPb+ctQGP8rvojgxoa+XW8osSkiwSB8toF4Vu?=
 =?us-ascii?Q?W7fOamReNcxsMsMfvLF++eueR4obLTOcz0zKj+6Jy4jp/+D4i68T45qaNhJd?=
 =?us-ascii?Q?KtKNX2SdXetPosN/WA0xR5kJbsPwEt0Jkj/ADDheKwv+HuqKOg2LPJ1wzzFq?=
 =?us-ascii?Q?demFzzkWsohCU+XD4ddpA3qGUsZT1jPC5q3hsca+EPIdH/UtSStaM0aAQg1k?=
 =?us-ascii?Q?P2zRKZQSTkI6dxbbHZrsAGgUbWtlFS7k/UymqKk4dCMy+WP/pFRYYBj6kN5j?=
 =?us-ascii?Q?8j88ysQ1f7WL/FfxZrsCKxOkutH7gW6TjIIo8FTbTIBODnSPY6XwDVLfwhAE?=
 =?us-ascii?Q?dGTWiDShw+q+bpZw0Xatbx/zWddrkf5UCUg1t7XJTsotuRJYjXhYqjvNS16Y?=
 =?us-ascii?Q?0zB4K51+rf6uuPbOCoYhLIclY5FB50gl+uEptPOfCI+xykCColaTRe73qRI3?=
 =?us-ascii?Q?MiPk9dqDLIxQiXaX1qLvzJj86g9vdmaFcE2c8eLPJPbB3G+Rv5IgYXqEMW0r?=
 =?us-ascii?Q?f+9i3NjIum6EFtplAQjBL3VMqejNiakt+XimdasXRTynsHiu1FJXaxH9arUP?=
 =?us-ascii?Q?BKVdikLbiiDogE8v4Q+OsA+tTEi2zb13bvPG5MgDZpnR4fxamOonFIfi6u0s?=
 =?us-ascii?Q?Jjaq7IorZqIjb1nj+SHDfNkKbqXaP8Tfh1D3nrb6xNcS98ovnbD+k6DmxUT7?=
 =?us-ascii?Q?HUJLHcwNdTCQvHNY+sNoNrDCH7okBchqhos3j7lVX888pWXvIG51g0ABwZe7?=
 =?us-ascii?Q?PCebxjO4IwPGhxVXKcXECxWALXUeyHHg1mbT9Xw4RGCJEJ4mcZD7xyzNQWkv?=
 =?us-ascii?Q?8tb7TZmEDm89BZZagMki7sKnXjuv7Saeo1k9UB8w+oMuQlm8lp4KYesBKcZA?=
 =?us-ascii?Q?hKK217MPs17h22CU5i4u+IuZl2cQVq2fVizgpw8R8U57NiyvG63dSyDECm9b?=
 =?us-ascii?Q?w7iCsyFsa31OIIaEa33x06kgz/j1nLnsvd24/KVzyC89VeViOe7ieuXFNbAT?=
 =?us-ascii?Q?uDkoTM2Ka/F0o2IBF3z+cQYETDpWosuhtIXFWInWE3Fo8WJRv/73duIfbkjB?=
 =?us-ascii?Q?Jc0juWz9OQdmPO5Fy2qjTUV2kx5PA+iWoBlEGg00ebiAmLCXT34ucNcvvEmN?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e809e0-0836-490e-35d2-08dab71bb370
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:31:23.0852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOkEqZYg/vU2x3tPz5JvStCpmPH80Et3xGgUjluHo8xdi1ERBvUNt8DvWzosQa9fXA+R0D9ecEQlrN785Oj6VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: 6ORNt4UX_DhMla8oFdeUMxp5n7u_ae0B
X-Proofpoint-GUID: 6ORNt4UX_DhMla8oFdeUMxp5n7u_ae0B
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

commit 5833112df7e9a306af9af09c60127b92ed723962 upstream.

Reflink should force the log out to disk if the filesystem was mounted
with wsync, the same as most other operations in xfs.

[Note: XFS_MOUNT_WSYNC is set when the admin mounts the filesystem
with either the 'wsync' or 'sync' mount options, which effectively means
that we're classifying reflink/dedupe as IO operations and making them
synchronous when required.]

Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
[darrick: add more to the changelog]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ec955b18ea50..cbca91b4b5b8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1044,7 +1044,11 @@ xfs_file_remap_range(
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
+	if (ret)
+		goto out_unlock;
 
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
-- 
2.35.1

