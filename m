Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C7B698CB2
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjBPGNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBPGNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:13:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF8232E45;
        Wed, 15 Feb 2023 22:13:39 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IrRu011337;
        Thu, 16 Feb 2023 05:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=auZO8X8RdZvuWWgGwAkkO17GwKP6V3dsmdbpQFC3kLQ=;
 b=Fs1pvwTngAPYbInK3GqEvcNV/iOIFCBXkZtuNAyS5c5ElPRBZLYtr09zHKH8Muh+Vyq5
 tHHXhct/Ki50BwNpOBAdzsme0fDAzCtMw+CRZoXVx68U3pBJN1UYi25TvDMa70rTjo7M
 8znghNhtZtYajr0t3tA7YMHjPqFVB2TSUysakRctCk7e4Gz98IWRpKVnAWMis6IbXaqd
 5ehzFP2TIdCbAwJDUKC2T8/J5ZMuRJ28QZl7N92wMU52luFg34j5sCjsuv+6mIsolvK1
 V+pNiYQsWUPjqLC+yEUgZP2yh/Sk3sYkhsPUy3CQOKOUw7NGkuuwjqc23g27IJq3r0xP Gw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xba80q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G4EvMY016791;
        Thu, 16 Feb 2023 05:21:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85vnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUYglXJSGYSiWLzkj2tPC3Ny2k9D2vx5k85j6ihzIRbe3qVNzW4JDGrmqpWVOMglm5GLpPTgrGnY23qWTJD6cuiacMg0HM/mvk9PlSZmQnB6o/hmWP6MnY86BWK62caKdcypEX7W4cgcMI7AT/A1tpbLWVxYuC29H+NtG2jzXPRyh/Wbn5+b7OW0xJ/ytdeGDA7Yq3uQq/TF8XmyZc+CTXCRxJup6EBLl9CuaqZVdEnZMFuu5muGnFVToEixUEVZMHeh0BAgrHBPq7mBKxVZpbxu61uafKXaVf5BpP8BXm84QGxUF7RGo/5USeAyldBPnoGYPcGO9xNpBV9BTPf/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auZO8X8RdZvuWWgGwAkkO17GwKP6V3dsmdbpQFC3kLQ=;
 b=ZuhIFUNWV/ti8/87mEje3i6PQTCXpCGhDI/wcqPCQgtTqBbvHkwTpUP/H8sehwvTBXvQqVS3pU+qjaZQvGS5vDy9S0sFBT5AtP5INyuSzbkNsL89rUud5I3TVE8NMnWG2tA/imKd4qEyCEeRU7O5QKjvRWns8YYPWcYbz87a7uQWLJqjioM6aaZhtyBYq4m8VQfoAoDpfMgWTappObny91i3P3DHowstGwwp93iJF2vZl02u6Pdq819XBHWm9UWtAwUoW6c1inyGIuZkW5qKEsCL5GBbphMifa6IB3ankxQVQfdsTREfEOzbKjce7Pqlls7bhAYGHtw/UQHJ+2OkLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auZO8X8RdZvuWWgGwAkkO17GwKP6V3dsmdbpQFC3kLQ=;
 b=W6kK/OliDO36wL0XHh5Webg+LajRVnxhbPJybUUCcwuiQ9EmQvE1mXezOK+q5cbURMV7DSJetr8Za+qmKNFVFOVARchWnKJ99RRpZ320tyvqdBe9AJMx11VjbPSjZQiYH4CivvjnhvL3kkawKPoBgSVbWRXj0zQfsifw9P3MxEw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 05/25] xfs: merge the ->log_item defer op into ->create_intent
Date:   Thu, 16 Feb 2023 10:49:59 +0530
Message-Id: <20230216052019.368896-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:404:15::28) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: f199e06f-09c9-4cb1-de40-08db0fdd9888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mBrzKCRAzOoWpNNX3zXMRCooLRRdRj0lt5ZJZojUZgbpj86QamGaATtVtO0qLj7ZlLXUOFXkcjxmPML/dXAKwIRl8rC/FNDXoNidjN3Y2UU11h1UdWgYGR/R4TL9uS9EXUj+j6FmiPTubGiqGkUCIHw1chHSL7JpU30f8yOOEGmAfkbeVKvkrs2rEHXH3sVwu/JVpgtJVhuj0wFPGGyZIe6Em0VJsCgyMVUNYBLZy8n9XOOIOh3IKULulyTILcXnpRtOqIej5DlBx4P0v4OiDZEUqAAJ7TFsQ96k1FMNljZTKNADUz5HViCsRKJ3iX6piGZpyVGeyz2kVa6lSgkT/C6gjx99fM/Jvb9PuO+ICT4LwDtmdG5N9VUWTAGDjzBjmilbVJY7Rl4xtfo4ipc1DaSu94QRauJ04w1FGh2KCxYg0jfo4CD/J+EVYi3//ARd3wv1V2+OlHBFoA3ae2pwDbtYa4pjWMOEHmRmp8qZ7YPZkEPy8HkL6cZKQzQJ/mvoQk1rdzUxmFGF25f2zCb1jrDUbWirg0BaZGoMDVDxzX+kNitZ9WGXMOOVZQLVbv5HQRYl2AZs8G1wAf7wUXPrJKkKr3z5yGo1Oye6NilAgfHCKQKQcILKJF5V9ZFOm4kx4gnJEYVCX0tgV3Q1mroJuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(30864003)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kQdoQqOCVf2+XcWljFQND8zIWQSPiidVvHRSrLRwXngwWkxloeNfWBFFHfDc?=
 =?us-ascii?Q?wMRdBmpXOPZ2cmsjQ4kq2RYhve+P3FDwITUP4Z0TW2xAavZQKsU/QpD7MuXZ?=
 =?us-ascii?Q?rZ9AiR+Ie2JIpro9AB6exYZqUCei+tIs3Mq7JDxcl+qrdqxptGaY7yyf78Ct?=
 =?us-ascii?Q?u4Jendew2/4XPjV3OBNpGVhS/zPozBThk5DCsYqhGei1OWHPwjdXxsFP9GTH?=
 =?us-ascii?Q?UzaSe/s+qVueVtqUfhsf/iybzC56914Q6uDB55FuUD7bnhH3smPGnSmv0uml?=
 =?us-ascii?Q?Z2+j3ugyPGdCR6VGVKkeAovXGly/dh0vDZoJ4OablgjnHN6oUTavAB7CiAzT?=
 =?us-ascii?Q?CvGjXbbxTuwK0xmnSlzl5WgZDfpWqh67MRZLMy8m0xBHiUaLrpAndHmLle1n?=
 =?us-ascii?Q?sv68v4eR/Uuap6y7LG3i/QGQBEjL5YgFbHWGj9F1Y0yOWVzqVmddom1Yh12A?=
 =?us-ascii?Q?3T8PoaGZs+KwFGWbhU7xw8YbxI0iK31dblKBLK+IxXMW70PXITIHQQo06h1v?=
 =?us-ascii?Q?agFe/UB+L/CMPfMOjfrgW31PsFeOZ1jzAvFXoKA75kD/15v9Iw2gVk1SBcG4?=
 =?us-ascii?Q?QSxQMn8TQzVB4uug+OPLb+kUIeOS9LDUrEhDlg1c9cEZk/l9YLATCC2PqCCH?=
 =?us-ascii?Q?K5jEYExRKx5tqsJg03HSn/A6awVZ4UexVtYrHYmOhaY3adaWv5Ik5gtzC5Ra?=
 =?us-ascii?Q?vXOqXhF/KHnL6X4r/TgfYq0T52huc/KRbaVXDfWnnqsN6dpBbXIZ97GvW1vj?=
 =?us-ascii?Q?cR+ckNAUee3lUixPODCvtHoMqQK0YoTyDmgdICDP5HRLt4K5eybictWOLGr2?=
 =?us-ascii?Q?k2d6dqMRqBfOXji+raNDJd5bjTQabndjemPWlok94svGAGKyxZudU5eVqWdd?=
 =?us-ascii?Q?kPKInGIMzv2JjdcySMWD43u2/1HhQG5O9Zazg9x2uFXxBSWLbHnjftmCGx4w?=
 =?us-ascii?Q?TO38SMZPRq82Cy1mOyrEcazeaHtjCGmK+mCJ9NlMi4fInTl7QLS25M8rKeCW?=
 =?us-ascii?Q?6qU8xEVeK/FFYnNMUjpCWIP2nrNpkx4xnMOApSzw+QQgid4eWj+P2UW5UuQK?=
 =?us-ascii?Q?oYDbDii5iAoqmbyiYAX+VXvJFotcms5M9eEtQFj7kJT86sK0H9J21RtGovOo?=
 =?us-ascii?Q?C8ZNQMXPLiqCI4mrf3sOen0faCXMyLr674Wfh0+tYVWegV5YpUanKLPt57x9?=
 =?us-ascii?Q?f08/IKsA+opZ8T2Nr/4OR3Zf0/0NeV5nBRJyNJuV5RWtzhCHWw1K216fF3Ug?=
 =?us-ascii?Q?m5ZxU3Pk+5D0+2bDodKVsC9L2WgpDpjN/KYFml0SgZqsMnImmJxwtpg8raSO?=
 =?us-ascii?Q?cvCotIkZG9Dfx74Zso04HSZrSKLNFZVvKHbC5chW/e4wcaTIUVJLCM+Mr4TI?=
 =?us-ascii?Q?YjcUAYiSaDJpbAGdB9HZzaau4gp8nREOUC+jhMeL3uVHx0FLyZ1rlW0Q5ohJ?=
 =?us-ascii?Q?C8TGuIpkiOa62Oo3zBihismWFqQhSS8nAPcS39j/1SUvBcG8mnf5ulzgKl8K?=
 =?us-ascii?Q?6BEg4q4KvwbVbiXJspH47ROYdfgVIg5qvXRM1HETNwdDRSM06pewHJbUsdjZ?=
 =?us-ascii?Q?cLnzPtQBAmivHBmSUpKJaJ/VrBSwp+fdh+y+0vpnkYbvJxfIEqYrYEldkZ2S?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VyqWdIxb62+tBL7pGbsJIFPPiXDbmQ7qsKQIN0Acx9AE5RQ4YkleJUaSvh+Glhq0YVK4fR49DNk3rRM6gFbSaOHO378KUbiBUDaP3bmeyfx3U+7GSYw4jJR6/ThZZHRB01Zt4r9e0q8gLu0yZK+quZhZmhSVv3u6LeK4lBDhtiebkr97+I8ecBXbpY1z3uy3+PuG+0jOcrS0dWtXMZK2uEVKnp3q2zdFBi17Oa+MOsTsSzJkvH54yhZoGCbDpNbY3Q9J8iF7akAMzvs7qwMc9sPljUVA3PY1HBnh4G42w6ekORxpiy7hx0l1NwmCZzIe5fQZiY2j5pMJbYfyvjywV//2NPZ4YotXfStb3GkmTQe88q9IPBY3h2JJT8QuDjGRow3pkgV1lw+aRP8yG/PoDgLFbUNUVqto+OOWFsposH1HhXq4jcyYK2dNdlTzcQF+CsxsNaGtdJXjg1zfMqkKog3oPYYIreEFjZiH8yQc21Uh7c8MjrASszbz98REVkWhWSuvMmSTF4NBa6Kv7AjOZLJ3A2CsH2CeeMwS2CZrMBbO9mQgvGhbGOwVmNJ5A/8LkWF/8JhLNEi096gyylgbihSPyjtOjhyA7GLGM1FRR3cGOxUQIfCsIlB7/deBVQb0QB1LRLMiHAnSnF50kA5c9Hy+VvGE4rWGR7Z6C9Hz5H9PAC1pcrgjtb6ju4AR1bBGOrgwNOryMntNNDcB1p6mF8/qcqIR3TCjRgyNrtdKC6vRZNQvWLL5YivkcXC6omLhbhTnZ2PY0uSt1/HNkUzGbVrNwKriFysQBquOXzoH1B49OZGQN9rSf33UxQt6Ebvb/eWrA4pMJkN1PXL9etXCnWUYN4Gkbz4OiTVM9DN0v59X8fDoiU5VdRqPr8VV3srR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f199e06f-09c9-4cb1-de40-08db0fdd9888
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:02.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxemeOAhyAp3QstICuWqc5GyDYVLBxdAahiK8+aGUGZi0OZHgpj/g/fYdgjY1muCdy49dZJBd6N1XPxo5euAoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: 7wJc0evFcKYEyIMt5YmE0ROZPYSNbPJ7
X-Proofpoint-GUID: 7wJc0evFcKYEyIMt5YmE0ROZPYSNbPJ7
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

commit c1f09188e8de0ae65433cb9c8ace4feb66359bcc upstream.

These are aways called together, and my merging them we reduce the amount
of indirect calls, improve type safety and in general clean up the code
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |  6 ++---
 fs/xfs/libxfs/xfs_defer.h  |  4 ++--
 fs/xfs/xfs_bmap_item.c     | 47 +++++++++++++++---------------------
 fs/xfs/xfs_extfree_item.c  | 49 ++++++++++++++++----------------------
 fs/xfs/xfs_refcount_item.c | 48 ++++++++++++++++---------------------
 fs/xfs/xfs_rmap_item.c     | 48 ++++++++++++++++---------------------
 6 files changed, 83 insertions(+), 119 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index a799cd61d85e..081380daa4b3 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -185,14 +185,12 @@ xfs_defer_create_intent(
 	bool				sort)
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
-	struct list_head		*li;
 
 	if (sort)
 		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
 
-	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
-	list_for_each(li, &dfp->dfp_work)
-		ops->log_item(tp, dfp->dfp_intent, li);
+	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+			dfp->dfp_count);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7c28d7608ac6..d6a4577c25b0 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -50,8 +50,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
 	int (*diff_items)(void *, struct list_head *, struct list_head *);
-	void *(*create_intent)(struct xfs_trans *, uint);
-	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
+	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
+			unsigned int count);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 243e5e0f82a3..b6f9aa73f000 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -278,27 +278,6 @@ xfs_bmap_update_diff_items(
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
-/* Get an BUI. */
-STATIC void *
-xfs_bmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_bui_log_item		*buip;
-
-	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
-	ASSERT(tp != NULL);
-
-	buip = xfs_bui_init(tp->t_mountp);
-	ASSERT(buip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &buip->bui_item);
-	return buip;
-}
-
 /* Set the map extent flags for this mapping. */
 static void
 xfs_trans_set_bmap_flags(
@@ -326,16 +305,12 @@ xfs_trans_set_bmap_flags(
 STATIC void
 xfs_bmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_bui_log_item		*buip,
+	struct xfs_bmap_intent		*bmap)
 {
-	struct xfs_bui_log_item		*buip = intent;
-	struct xfs_bmap_intent		*bmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
 
@@ -355,6 +330,23 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
+STATIC void *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_bmap_intent		*bmap;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+
+	xfs_trans_add_item(tp, &buip->bui_item);
+	list_for_each_entry(bmap, items, bi_list)
+		xfs_bmap_update_log_item(tp, buip, bmap);
+	return buip;
+}
+
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
@@ -419,7 +411,6 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
-	.log_item	= xfs_bmap_update_log_item,
 	.create_done	= xfs_bmap_update_create_done,
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d3ee862086fb..45bc0a88d942 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -412,41 +412,16 @@ xfs_extent_free_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
 }
 
-/* Get an EFI. */
-STATIC void *
-xfs_extent_free_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_efi_log_item		*efip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	efip = xfs_efi_init(tp->t_mountp, count);
-	ASSERT(efip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efip->efi_item);
-	return efip;
-}
-
 /* Log a free extent to the intent item. */
 STATIC void
 xfs_extent_free_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_efi_log_item		*efip,
+	struct xfs_extent_free_item	*free)
 {
-	struct xfs_efi_log_item		*efip = intent;
-	struct xfs_extent_free_item	*free;
 	uint				next_extent;
 	struct xfs_extent		*extp;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
 
@@ -462,6 +437,24 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
+STATIC void *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
+	struct xfs_extent_free_item	*free;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &efip->efi_item);
+	list_for_each_entry(free, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, free);
+	return efip;
+}
+
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
@@ -516,7 +509,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_extent_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
@@ -582,7 +574,6 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_agfl_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d5708d40ad87..254cbb808035 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -284,27 +284,6 @@ xfs_refcount_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
 }
 
-/* Get an CUI. */
-STATIC void *
-xfs_refcount_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	cuip = xfs_cui_init(tp->t_mountp, count);
-	ASSERT(cuip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &cuip->cui_item);
-	return cuip;
-}
-
 /* Set the phys extent flags for this reverse mapping. */
 static void
 xfs_trans_set_refcount_flags(
@@ -328,16 +307,12 @@ xfs_trans_set_refcount_flags(
 STATIC void
 xfs_refcount_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_cui_log_item		*cuip,
+	struct xfs_refcount_intent	*refc)
 {
-	struct xfs_cui_log_item		*cuip = intent;
-	struct xfs_refcount_intent	*refc;
 	uint				next_extent;
 	struct xfs_phys_extent		*ext;
 
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
 
@@ -354,6 +329,24 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
+STATIC void *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
+	struct xfs_refcount_intent	*refc;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	list_for_each_entry(refc, items, ri_list)
+		xfs_refcount_update_log_item(tp, cuip, refc);
+	return cuip;
+}
+
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
@@ -432,7 +425,6 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
-	.log_item	= xfs_refcount_update_log_item,
 	.create_done	= xfs_refcount_update_create_done,
 	.finish_item	= xfs_refcount_update_finish_item,
 	.finish_cleanup = xfs_refcount_update_finish_cleanup,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 02f84d9a511c..adcfbe171d11 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -352,41 +352,16 @@ xfs_rmap_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
 }
 
-/* Get an RUI. */
-STATIC void *
-xfs_rmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	ruip = xfs_rui_init(tp->t_mountp, count);
-	ASSERT(ruip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &ruip->rui_item);
-	return ruip;
-}
-
 /* Log rmap updates in the intent item. */
 STATIC void
 xfs_rmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_rui_log_item		*ruip,
+	struct xfs_rmap_intent		*rmap)
 {
-	struct xfs_rui_log_item		*ruip = intent;
-	struct xfs_rmap_intent		*rmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
 
@@ -406,6 +381,24 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
+STATIC void *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
+	struct xfs_rmap_intent		*rmap;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	list_for_each_entry(rmap, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, rmap);
+	return ruip;
+}
+
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
@@ -476,7 +469,6 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
-	.log_item	= xfs_rmap_update_log_item,
 	.create_done	= xfs_rmap_update_create_done,
 	.finish_item	= xfs_rmap_update_finish_item,
 	.finish_cleanup = xfs_rmap_update_finish_cleanup,
-- 
2.35.1

