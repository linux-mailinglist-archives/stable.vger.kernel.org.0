Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333215E8CD5
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiIXM6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiIXM6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA7210E5D7;
        Sat, 24 Sep 2022 05:58:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3RYGm003592;
        Sat, 24 Sep 2022 12:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=x9rwfdzaHH3Xx9mCAFtfWhxqPy2qVFw0fQsmXwrZJoWIdl3Xlzfox7zuB7SnGH3ZbA5q
 IxHSuC5QYj4avZled4AM59T2vDXQMdljgFjelVtrgfURdw5iPplBVoXFcBJXKbG7xpJ7
 gps+2Jy134JLCiYdsdCXeuRjGXV69S0M0R1QFnzcds4piOxby1P1+DuzpYO4Ck97WFBo
 tW7FQuEHhvTzP+vCcP9bX9v7IBSEEAK6juGB9xxv2sgg1yFQqihjFIBI526KbbkSNiBj
 tCGNwAc++e3z8A57Its+wNGxhlTKhvGFKKYZg5mt8Rt3ITFl0nQKVSPgsAbRtqnFz+o5 8A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kgg2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:17 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d34i036740;
        Sat, 24 Sep 2022 12:58:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s0wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHhJ35iHm4loQDnr6glIxN+RxBrRh9P+jv07d4x9bAFzsk8t+qHm/usWgw6G+jp4puBtfWfE30Vx1Ge3znZVXPF28ZFeDtxtl/TfaaXkeclaY2/Dk/+9HC+J8pXnM73LZDZ/xjIq5gyBHy3evfGgYwZMHuYYyjcAzhgFPx0aysPfwjBdOSaSIG6un6BPo9gbiS75ybmbO8Zi8drt793XAsfOAn7KFmXBJEHZIqyOllcuyWmYBb6QtXZr4V7QRMRiAKlkjmxeIzfxjEM2b7DNS6tsofMS+x/UdovLagdH4ba8GPRQm+AJeb2Ld5MbfpvIqJ/sIGurPjtyveqti4kiHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=cnfIYA3102xNpj9jBCUvNcoN6x7hKtO3Ey0RY4dQGRFbNw7e4jwWq8mtjspYNFUr4cV5yzwaoNRR6mlcRFuOLhc52Se/UsCk5dwzbwSTe/NT/Pl5EaIDTL7IIpIndJo6N+9EwxK5WVhc586hGVCdVrHBzLrZf2LdwbrgJIFtiBhiJi1/20LYIdHHFQiQVK1rncq4uj5y4kx60fe/ZNLDLEZvm5pWTjlfcgLN3jiNxzQJj+4IpjFVhgO7yQ++mKVS+7/hvZhj/K2dDLuuM162K2efMYWVDUdRvk0hyEo2YG/urcylz6faY/jlaTfJ36vOql71AOvUZnDH5hUy3yaDmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=v8JExQZBP9J3R5g9RHQP2xJGXY37/kz8kpxQVrjda5QG3/5OYT6PzeBQX/6WJiaXmT3Ka4+SaPgzNKUoMPRssOMba8Xd9PE8jmSS3RFLzK2WeadduVmgaPQyq5/NcbXAlvz/gGCXz7KTNjyasR5ZE2nZRi7Ot9IxfxDRzW4rv8Y=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:58:15 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 10/19] xfs: constify the buffer pointer arguments to error functions
Date:   Sat, 24 Sep 2022 18:26:47 +0530
Message-Id: <20220924125656.101069-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0026.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: d5070d91-4edf-4647-a982-08da9e2c71a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFbMuROETLmSkFHeQKhqyBfxD0Ss0NrJYeTevE/QKAoIlAEzFZlTWsxdSH77lajA/iSdKPT760xBnQZEyek6bFyWx5HPddwZyOKsKSOgQ6FkbpaoaxxXicbjZ/VRI/WSX4foj2wMHS4b9EWHF6p/EjKEDW3RS9ssG4iJkxxFbMRwmxPhV2X+4g7rBedE3XFID2KTnc+Yqt8x/4ScbyGgLvm63cCTywjg2i1nVipiZZKU/1L0b+Un1+OKd8Pc36QHrgqZzke5te+14idphs2KnymQeSdhrfCwe/hDsGCQOcqHVxZ29p6wS7WxesXX9ubKWWqRtJ+gXj5SJ3EF1uEyYOelH/Uqmbg6VkqPKES3QGH3LK07hibjD03g7/JhgjjmEtRFfdddEhHsibTgx8sMXNhj8t2iEqbSzODJDc5KeYX6LiJghE30j/CXzLCg7AJK/r4OU4SPDEsI98CQU/OM7WdlJFt4ldrHjEnXavdr6cB6tqYs2WysBood0SKyjrmbyHvf9iCDOHT/3w34Wn0JspRkykO35aKOfmAnmsXdYUGPowiZNDKy4Sx6bh+MRGd6dkXScB2sDjJqdLoB7wXMonw324jvOss5xgI06GbJZvqo3mEuhXBqxi5CLMt7ahbhe40x4/OiVGih6UDoSKySB6hYj8VHDcy5Xslcbg2clfRrn8RKDQZqzn2OOQNbsF6c746u5ZOlJRChI5Yj2XmbkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/bSKKPjCLsF1V06NZyxdWLTJwBH1PIRd4Zyx38bTZrV1x04NE4s8wU0tPqM4?=
 =?us-ascii?Q?LKXBclY4c9RqfGPBWpYvIqQRnbF5FZ4bN+QpVQyBqtCLJwsa8l6oEJjR3RMB?=
 =?us-ascii?Q?JffID8VQ3Fpz5LgPTRrBAcXJw8Rcv/FnILOSkSZgXQk2l/u/oTVxGJ6HDJ1P?=
 =?us-ascii?Q?5K+pAxibgM7pBNXkb1dG46o6STXqfdmYkSNfJgmDXHjWTa9fYN5rZCRVTEKM?=
 =?us-ascii?Q?I3Cbv5HJe7wazhmhYzq5drGzof6kPKXT97aKHyHIgWqZyGaV9y9zNWegLA9R?=
 =?us-ascii?Q?sNELxEpAeZkbQAw8lCYbzFUvSNkmtK8bwIBltyzD6o6MCiueleEj5NqYOK/b?=
 =?us-ascii?Q?Y9QdUW0YEbI1jysPphJrBn7d5iye/AeC+oweO9nVqJkvneD4Z8Nmf78aQtmw?=
 =?us-ascii?Q?1zbdqx+9GytTIx9F3tvRXN0Gxol1MFbLkFZyKzWNZzTN65sjMXtObgJIs1+O?=
 =?us-ascii?Q?22mHJOcyPk3ULk35t4RaDtuIR5upLhGssNZVPBJRhgPqNqW8ZRdSW8ppt177?=
 =?us-ascii?Q?YyvB7oNUGgxqhR1Kx5c1jVPxeduNuYSYGdmwS743g/J3AmNCxBzNYssRrEIU?=
 =?us-ascii?Q?Mfou4KFpGF1SJDZa2ffWTmyK8KnfSDuHSOUAPk3/jQlzB+hVu84by/7um96y?=
 =?us-ascii?Q?Ifo4u+ScI1noiJNYe3SCNDbVhAeF1B71MRtwqvt0deZBN+5SBQIiFvNtkuLi?=
 =?us-ascii?Q?bUht3w2N9uMPaddlREbKgVk0kLCMFtOvPjGI/c1beds1H7YD++IUXrfRcCQK?=
 =?us-ascii?Q?gClWVwL3rGYPK1c1eH3xys4vvbP+oOtaJvOUChnyHpcdfD7lAhwFT6D0czHa?=
 =?us-ascii?Q?aTyvojFtGjUBXLPZp3brTxhUpuWYIMgwfJb77ydiiodzAXbwQfmJDZ95J16I?=
 =?us-ascii?Q?wl23PYG5D16mlO8RnGkskaETZoExrBB2UXSvecn6981RhA069VLpqAt9yuuz?=
 =?us-ascii?Q?RBJwvtVtTvHIZZgk+4jcXJPTcyP98nZG1ObZM6PdC0JmnWTTo8X9MCOx4MLx?=
 =?us-ascii?Q?B73DnG0/QB8TVkYh6iIwh3I2o0c2eR/4r8szuAd3hrPdNqvLgl3hBJCpsydi?=
 =?us-ascii?Q?aFgw6jIYToc3ZgE0eFIV3DuXnzeu7/VTEaAjYRgggou50/U/olVyO4R7FSs/?=
 =?us-ascii?Q?4pyXfzNeLxjatD4yguHt6xdE1AieealG92q/u90LNoEw6CAobdTqBe+26rYs?=
 =?us-ascii?Q?zCaDxGh7jEsrcXIAPqhc2f5Yz718GL7VC6YiX52kCEoiixpDhjM3LcrxqFwO?=
 =?us-ascii?Q?0NQH9N/u1hlIzF/uOMpC7vKayNVSYK9qv4wJJyRgz7NDlJeo6E1GvrzYuccO?=
 =?us-ascii?Q?I+APmkoov3fRSFcJJC51tn6Zh/AmOEx4fw0IM1bdPq5rByNv/e9HTrGo727y?=
 =?us-ascii?Q?uKs6Q60go83tcgdRKYYFgbLknpEtiVEs/oeAk1V0DDi4lKXuXDiagt6qcKNc?=
 =?us-ascii?Q?KnUBbW7jPKxIdrqMVkm9xuc18dIqcAZeKii9leUTtn3+5NoCCbyFblZaXLST?=
 =?us-ascii?Q?cqNSjsdW2dXAClJAjJZxjmL/c66XODKm9SNCYX375SI78+Qo9KHCvZu6Q2FA?=
 =?us-ascii?Q?HQD18cWaPVp+JwVBk1U+cM78eZuTsS+eKgnk67DxNUZ7W/+H5Yc+mnqGN+Is?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5070d91-4edf-4647-a982-08da9e2c71a9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:15.1071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXPE7dydNf5gmmqj9QIl3ZWCXMKK5lU9D5AmvpOPXDqk5nU3r4E3dWaSfW63rT4RUvSQk8spcYG9lg5D6guMxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-GUID: RUB1dQhJxepSihqbD2Vi0mmY1uh3PLvw
X-Proofpoint-ORIG-GUID: RUB1dQhJxepSihqbD2Vi0mmY1uh3PLvw
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

commit d243b89a611e83dc97ce7102419360677a664076 upstream.

Some of the xfs error message functions take a pointer to a buffer that
will be dumped to the system log.  The logging functions don't change
the contents, so constify all the parameters.  This enables the next
patch to ensure that we log bad metadata when we encounter it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_error.c   | 6 +++---
 fs/xfs/xfs_error.h   | 6 +++---
 fs/xfs/xfs_message.c | 2 +-
 fs/xfs/xfs_message.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..0b156cc88108 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -329,7 +329,7 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
@@ -350,7 +350,7 @@ xfs_buf_verifier_error(
 	struct xfs_buf		*bp,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
@@ -402,7 +402,7 @@ xfs_inode_verifier_error(
 	struct xfs_inode	*ip,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 602aa7d62b66..e6a22cfb542f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -12,16 +12,16 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *buf, size_t bufsize,
+			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..c57e8ad39712 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line)
 }
 
 void
-xfs_hex_dump(void *p, int length)
+xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 34447dca97d1..7f040b04b739 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -60,6 +60,6 @@ do {									\
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-extern void xfs_hex_dump(void *p, int length);
+extern void xfs_hex_dump(const void *p, int length);
 
 #endif	/* __XFS_MESSAGE_H */
-- 
2.35.1

