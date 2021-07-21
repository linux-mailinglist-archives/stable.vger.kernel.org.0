Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914223D166F
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbhGURxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 13:53:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9062 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230208AbhGURxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 13:53:18 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16LIWklT008439;
        Wed, 21 Jul 2021 18:33:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8pW+inlNHaYM8+hMzkLjqMex8Oqc0Kw17KUdUSmnGpo=;
 b=TO7nBdNGi749Hp7rQHwpdDVWVW62fVU7mcyBduZsdYtK1TTnWEtLnKAQ2N8naNoaHvf8
 cP55VFTJaxalbwRK90iIR08VC+fQZEn05qid9vWyzL4YiiaDKw4j0pjF2jUSDYb3gMQA
 Mq4gSvHdS5po1oJt03KKGpKCIB/+zL70fdWrTt+W3IByOf9SmcKThGbCGeeT77ACv7ic
 F63xuiWSVzLxJDIgKq37+2tpPUd1Ik2Ivo9z6BXn3n4jq/PWmK21jXvQDqEA/Rfh3iwC
 AwgIJ4SyESF2glfZSto2En1zalnQs2pxksrihIAgprynO9guSP7LSNr16dpq8haqUt8l GQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8pW+inlNHaYM8+hMzkLjqMex8Oqc0Kw17KUdUSmnGpo=;
 b=MHEZe+bddBbOzH0+mcg7LTdNrjkOEVvBqUAS+bPeIPag3pSQTGk12HG3P2qMW2kHQbdO
 ukmMFX1irp6xgzUDVQ8aDnjoivcSl2SXpF/n5KzkMA5VEp1ZFMHFQcvQ/GpgqyEopG8J
 0rS60FKK052e5LUbChGBE7o42bvia2sXflNgUBg1xJkT/ToytlySM9ZTCpWjmFJKZlWI
 7/IcqxwyC7NaGD/9D4pfePv3LxB85VPaQ681gOYfAWREGmxPDcEw4ItnJgDZzYOj5R8p
 uzDHClL5IT9R65hCiSmh6UswlGu0DbC+2eb+tK++n3rdtIwk8gFLBy9Y+MtNGAHbwbxC hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39wvr8bju6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 18:33:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16LIUapx117162;
        Wed, 21 Jul 2021 18:33:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 39umb3a96n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 18:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgaOr+8YHunx1eW0mTUPK4qhQx0QBDXpF6jYxI1jVZOsOZN/qq0difORk9jGkTcRXWcRlWMinBZiJ5mMVNSbno9hVqtYma+5ri5yHJ+bWCE1H28LEVhgiOhdNA4vL645JwRdDMCQOO0DeI471YlqzIFh9mkcbx/LfRKzw0+IQu5AHleTfQEwAmBxi+0O4pgeesddaJ36++1ymYW/DZPaseHDKBzT4pC8yj5IR3LSdcyggmZeJawIZjLEwu5R3WfAV031GlHGkENI6er6WR9hVp/u1evGD7EHfpKpZkZje6GoAMVuw3E8/Ux/ZiuIuxBWreiejSzghxWjxgFIhQazHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pW+inlNHaYM8+hMzkLjqMex8Oqc0Kw17KUdUSmnGpo=;
 b=npzd9fG5DVb6m0NfaoH8jOCKaXMRwVQa9nfhaO3KHDiVsmvsg+jgj004kVnODp1PxzJyrG8GKYaLVDqMZqGtDx+0A1C21cNdOA9VV41ZVJOsKOF734fsgosHVhVzCFHVImbkg3JOJSM6pnElfPutCZoso1jmZQaa7Wi9qy2Ya0k84v1OU9ea6R2pqY/8C4pBLqCTfC1xZWnFeg8YSqgAYGVCUJNt5Zlh2gVvF5dMPEv0UIM1GFU0De2+WOc4aj13uq5gSCKkjVvGAHdmk5bXnlLRMTSNeN5PXkNvx7zYUZhaEAPiqyDSLHKyzARYjPSZ7O1IU/iznnM0j0Qg+JiTtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pW+inlNHaYM8+hMzkLjqMex8Oqc0Kw17KUdUSmnGpo=;
 b=ubcVrO8Mb7McHHUY1WpI8YcXrQA8pMkokV2MuRRws+qsgLBRPvafRRqgwsR2ppVpbpvZ6nw3pTqRqk2y1RMAdoXKtEVXNbCgk3lAjdyOPWhjmK8Zy5jQjvMRfWZE8d4DVW1fDHAgFBrraWZARCOQVnbbG7t7vdDeQ6GyStPd3/8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB3810.namprd10.prod.outlook.com (2603:10b6:a03:1fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Wed, 21 Jul
 2021 18:33:42 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 18:33:42 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Dennis Camera <bugs+kernel.org@dtnr.ch>, stable@vger.kernel.org
Subject: [PATCH] hugetlbfs: fix mount mode command line processing
Date:   Wed, 21 Jul 2021 11:33:26 -0700
Message-Id: <20210721183326.102716-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::35) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by SJ0PR03CA0300.namprd03.prod.outlook.com (2603:10b6:a03:39e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Wed, 21 Jul 2021 18:33:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04c03f11-73e1-43dd-3b6a-08d94c761113
X-MS-TrafficTypeDiagnostic: BY5PR10MB3810:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB381048EDD712DC2BF449BEF5E2E39@BY5PR10MB3810.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OSZV2BUuGv0b7B36WAn6DRmKrvT3bh2PUEgZPEiFx4nmHe/T3cVqbyV3OEiPFTA1O6cgs6FxjnBPvf2DYYXyKmHfXjwC1VzCNA4m+gxUA+G43aGR/7Q9QaxXt+Nh1UJS2ui+8BjTR/fBcJyBg+JRTVILgQ7Urow7w5NnMwXF0VTH0uVTrxdWa8DvXvUqBU8mHPs4o+eP+yAKIhpePGyunOtXQU5JkRyWUmtXe8ZbVvbopV07oAhRzOE2/jWSaaRGGhyahO83HYSo/cxNzSqiXONIw08tADOUqj1tSsh+lUlkLQX5bwDX3J4SN7sf4vQcNrizcbVkfzNcnu7sJuRxdqDi6JXXavclhajXv/gVCIVz8WApkARw6b4B58lFtbCS3TAcpjWr5BI2HkvoUUMV1B1yOTv/4K6o0S/KOQAUJnbA6ofy8DlY1y3HWUG49j/2y+VASXV6YHpTgT55ow0YeCMHTzD2MgQnSpV9P+2lBGQAu7iSjNIsukXNk3aNrCeeO7ebklXYni1G6gd6QYXR9ap3Ys1mhxRWBsdbFCrgaw6949ZXrL8DfdcGDEhjHZhnmEJ4o+PbvP69qnh6L0VKDtSKiDN4eoHwR7DtXyeJ5PXQN15SC5rvUnJrwXshzd1VNdClRRRfswGi3zVCF4h78FFEg+lTttRR5Q5A5zRgSCiHKwnz3ZUX5jucsNURdLgj46F5g6Vn2Zw3Mi06uTEYNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(26005)(1076003)(38350700002)(38100700002)(508600001)(4326008)(44832011)(66476007)(6666004)(83380400001)(66556008)(7696005)(86362001)(316002)(2906002)(8936002)(52116002)(54906003)(5660300002)(6486002)(2616005)(8676002)(36756003)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f0JW8R0chIOhNp7ftxMXDQ3d5ftC4XtjpaMrvVJx0aHTTd7FZjpL18rMtirA?=
 =?us-ascii?Q?Cz9Rdb5fVMc3ThVL+c2ZRcttJNbk7i4qwuv8rGijWj54lZjdbx+GCfFmgMBg?=
 =?us-ascii?Q?fRZkSWH05dseZ5QnJJSPk/AIL9ufOL1qB378oQhAC/tl/w0xHORZqWpnh6dc?=
 =?us-ascii?Q?6o4Fd8UPUuVYDbd1fVgiJr1r0HhtZVUNmh70vvwxwqSZWhCEdTbKLTTtfT2F?=
 =?us-ascii?Q?fSm3RdDvvbc6owsB29d1J5xZtLc5m3iE9yXsA2qySGHzGlcZyLpWiMflLUdQ?=
 =?us-ascii?Q?41goqyoq4EjhL5OsdDVAblH2OKxy3TmzUI0TOeGzTVDHuVkbgQMGHKGZW6j+?=
 =?us-ascii?Q?LM7UBx9pwb5uydg0MPDQcQtUbPP1PW72JuLNhe5m4vByaKIAmR6+dZ+8rzmv?=
 =?us-ascii?Q?my/1aB8tYYYUrWMDMix/5y/5T8kkzj8bd/74UEla4DxmwR2YYQQqsgpyhkTk?=
 =?us-ascii?Q?nbzkWYSbLKTeXe/ceudyRS6dP/2YaMz7XmRVZXLAwnXbrGhLvgFIHRIBTI3Z?=
 =?us-ascii?Q?/GXdDBbwHO4RcAbEtGn7ojSWO1HXnGNIRncmSufW3Na/WZl89dOEZHwgRbuv?=
 =?us-ascii?Q?rriBtoI8vLWZRQO9N52nsOen7+6QM8p6zaWKEO76FHA/cinUqZak9VAnXlnc?=
 =?us-ascii?Q?MN2S2vDxobSQ3bw3mEquZL+Zj1cBMPvwOJaXyFb5j/d/ydos5LMlDZOYhuFx?=
 =?us-ascii?Q?bol0oI/Eqh7JxE68ASB6y76u1iMIjOKbN9xQmE3IktbhlMx9l+ck4CD0zYGp?=
 =?us-ascii?Q?0ZV4n78T+K+4BFReD4w1QPCCd5R7AYudDnhIGwpf0PmtmSZcEikb4rCtAhtz?=
 =?us-ascii?Q?jCfFoY15dqPg2t/FT+/V9Qnf1fu8E9IJsd0nxRzyXD12mpsz8bjcu0nPpwpY?=
 =?us-ascii?Q?e7MHjJWRQw4SoxeN7mZDtsgAcx4xLBj9t4I1cxIxXrThR6iY8XXpZV74o1j/?=
 =?us-ascii?Q?gdYZaCJinQ+UNjgEsWLftCuCPxTRkmISMVkfUNlfpO9PjmwMd8hI//Rbx75N?=
 =?us-ascii?Q?e3vop/FqPA7I+A5hBnnjxl1wlmOWTEWP+K6P7Dmbg6YrqquTv229Sk6OJ6ua?=
 =?us-ascii?Q?FcNw68i/A9VcyyPqVA2FVKupDcSRqeR5ldX40PQsNby31DmjKCprwD0+HCES?=
 =?us-ascii?Q?EFxit79vito7pwQwnktlaJYYoM5fHw6xVYcaPBvCo1dvAhJAhjN8i/x1IIIb?=
 =?us-ascii?Q?y/LXG/82veCBxHm0Gxj7RgCjv5+0J3SxbFHueBukzVhMcxuBIERlAve14Y+s?=
 =?us-ascii?Q?/Rta7csySWK6HFtc+3GYwmCse0NIrqLdoRnE9FmEXkm/iXrgZYVD0jSBLZA9?=
 =?us-ascii?Q?QGFR+wN0K6XspJnFkprvN1zr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c03f11-73e1-43dd-3b6a-08d94c761113
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 18:33:42.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J76Bj9k1p3DpV1w770nEyvyYp9eAt7v8H9lkhgSXRytR74CKWeXfZEvuVKDgP5Vu7mOj+1wxTqKJsHnnz3KtrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3810
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210109
X-Proofpoint-GUID: EF7fkJvjWaBv4q8IezCFRuQ9ZoyX8AGf
X-Proofpoint-ORIG-GUID: EF7fkJvjWaBv4q8IezCFRuQ9ZoyX8AGf
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing
of the mount mode string was changed from match_octal() to fsparam_u32.
This changed existing behavior as match_octal does not require octal
values to have a '0' prefix, but fsparam_u32 does.

Use fsparam_u32oct which provides the same behavior as match_octal.

Reported-by: Dennis Camera <bugs+kernel.org@dtnr.ch>
Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
CC: <stable@vger.kernel.org>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 926eeb9bf4eb..cdfb1ae78a3f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -77,7 +77,7 @@ enum hugetlb_param {
 static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 	fsparam_u32   ("gid",		Opt_gid),
 	fsparam_string("min_size",	Opt_min_size),
-	fsparam_u32   ("mode",		Opt_mode),
+	fsparam_u32oct("mode",		Opt_mode),
 	fsparam_string("nr_inodes",	Opt_nr_inodes),
 	fsparam_string("pagesize",	Opt_pagesize),
 	fsparam_string("size",		Opt_size),
-- 
2.31.1

