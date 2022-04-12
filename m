Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687F24FCEC5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244698AbiDLFTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiDLFTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3903465E;
        Mon, 11 Apr 2022 22:16:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1uPaZ022836;
        Tue, 12 Apr 2022 05:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=cHbpYj2KhbGLLB7tOig2Tn+237Iwt7nkFAIlNwrccuQLq/UiRGqWmiUciR8MUt1y5wJW
 c9STwQX24WcD4LxWf/GeleAq1f5zkmXPnq63Jj/L2Ig/43i8St9qVCVv+9sLEifI7lDG
 SWCFGhX7RprIYov5pgo62E9BQcSFdi0EfKEDLpHKWL4OXUELNtAxZ/Vcgq0se4g8Xv1h
 RG/l3gN72NLw6Qoy8eThX4/y5VxmpuRw0uYFeJpLChjoZuyOOayKFGFOHfKPDjZhv0Os
 bF0sN4x8qd/zeEaoKFjcT3VwFJ8lCzPCPUYkvX2ehze4ff8a/xDWIF928KFfK4i3Gzd+ rQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd5g3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GD6U034260;
        Tue, 12 Apr 2022 05:16:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9h01up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAclwg5uqpd0Rw/jtthmX6ycyAc0E3gk+d0LMpax/KdEN54l4DI/1XrJKX/PSlxj+gcqL8RllHwOEem0acXKyFe5v1dn1zVE412Mfq0Ya4lQVGt6NAVIuwOtOBhrTui9w/65TOfi9ps2Tk+MXz9KL1vDZ1xRZJLbP32x6eiBY/1oS10nSV+UI74SSdtoIc3FCtkocqp7mr1r0i7OR7265qPzPPfLKTaE+1mnG5F/V9Ial5HAEcT1yY4N1aUnLmAHks+QyyTXVfKcj+0CaHpJByjc342SH6WiIH/JaDucyXYxNmqXTbF/7ebswpWhZK22U9AjOZAFluYKu3tl90toAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=DQBh8fRTQbmXwz9E2qGvo/EOTAGMW9+F5IRFkuJNjZ3pkvFTRVywvcb9vVSEoYWS0V8w959mWVAP9iQnZJIZKgoLOBXkZGnbneTuHLMVkUcVRiF7MkVMbryxRj+QWEmvLk4r1bypcRhrUoxwH5yTTjQHjHGm+CNfIXWA0n8AzRRCpRY9YBvBzjSlNKCfoaU28PI7PO/yrRZdpa/RIZWlAQcViwsmTisq1AZ/ScQOrfg48MRckRR9avZQDAKEdM17xioEZTHoBbmBuMclNb1mxN4pLwNWyGr9iWTarIgaEvVnbtKpSM+zkV2Rqo+D70B9CtEQGfyklRDaz9V9KQQX6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=TTR5drFtYAWarIXBHU0c7R7rn1cgerJ9PYSl7ZzLEEi7AOINxWrccQ0Q+cO/33USNeXDoFvf6nHu0C/fw64KgLoDUDV1BmhjDlDyFx3PgKahZPx2iETXspHWVvzBVD3GLMSH+2eNWiBowMhdtiBdVzYGHf1MdU9bHSEKBCsxxHQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:45 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:45 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 10/18 stable-5.15.y] iomap: Support partial direct I/O on user copy failures
Date:   Tue, 12 Apr 2022 13:15:07 +0800
Message-Id: <451ed8b0f123d904914701e938f8613c594931cf.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0051.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::20)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f2a25e9-6dc6-4496-cc53-08da1c43a2fd
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329F532AC766B720E8F9208E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O1AvYmo4HaP7XdcGV9zbN7dTnNHcCFgAP/GVGGZlCuuVYn7KlOzk0AODvzMgbS/mlrrDiiny3iuulAVNlUcjwXvXglHWxHC14RCaBQr2MPyZcL32hG/EY2t7RNBoc6vyZUsmerdJwcX/QZK+koRyCmVytSNECx+d7d+oJu9qFooL/4tYmDRYttjkPeBQ1o2R586/dXwGx3KVdu878V2UNx/jCLpL0krY1W0vBSObIk2YCSjLrxRXI9YiPnOVsJk+7BebHuvAWU/B8uBTycoKciViYYUBzxejnmOPDPqcBK+PTngetunjYlCu7sI26CG5+nLwzKpgLEmKhVl79Km/N92O/pr9UmFgtxppt8pTEXfE3e2bER2tgcj2pfWWo/6NCABC5+JmgBLcThWbXcEYa57YpHOC7AN7CU0KAJMag6i/pM4NL4xBo80Tsu2M3BMsL5eLKdtU/thS5hN2KMGQ/ooyERtl2ZLnKeUYyzYDXEehld1cLoNH0L4zbQF64uGtsxf3b/O/SBrZ9hmxV3361D+5lll26uYolc3B07G68aUsfTGVga937XvQ1aUYAWkU+gxmtShDz7pKGhINhCXIllfUXJCUpE+mclhLdrsK9h4lqhECymRgzBvwMmjBZnkyLGd8StueUrekoxYhymLTdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pNAaBRKyg21d8EVyFpsaZQsBaLzuAwnGARStyjv7FgVneanrgney0qjp8ItR?=
 =?us-ascii?Q?LTP2DYfUxKMt6jFqU4sXKgsAtuLDYJ4uOKar5LNU9QLqmU2NGlYganHk+xHC?=
 =?us-ascii?Q?+MgtstWE5/T6TlmlLIBhAd+VBOHBiOJcGIUbQC27xk/vLHOXQEfNSiXS93FT?=
 =?us-ascii?Q?e80UQsZ02ZsU3Rb5lH+xRag3ADePFzXlmorrixX9JHEHvry3HVGULr+BwIOs?=
 =?us-ascii?Q?s1MMbKxyEG2vKU41gBiZHwZ067ddn6TnlG/giZQvqQAolcGLs8Z69JMq04MO?=
 =?us-ascii?Q?sRDkZ3hNz9GIX4l3DhT45EL6LTEygvvp9TzuNo48pkjmy8uR02luLkLDqPkL?=
 =?us-ascii?Q?kzWff3+WDrSvgj/gjnJElPKVMxs9SraIlhOWO2O9Y+AVPwYtMY34G0AfSpPK?=
 =?us-ascii?Q?cCVjizoTTA7rcSGO4E4DEAaJT68tO8pkvvT+YlOAhJq9aUMXzIk/X/xKh9Yn?=
 =?us-ascii?Q?8+qPzpHpqA1xdFdVAn4oTEcSkvM3i0PRHpbcYThW8LRuWMNXC5zJf54S9Tk/?=
 =?us-ascii?Q?yF7FJn3ype6ZxGrsJjBGYYOGyA8+9s+5pkIcNzIFbheAKmlIe7Zm8yBQJTQt?=
 =?us-ascii?Q?g9iga7Te6MGBPExLCej+owl3aF60TovcT6nXXYjxYcqOUNeUVvLx4o03YS8i?=
 =?us-ascii?Q?dRQ9zIPVCzv4CuyQUC7adELQpjph4O2rwC6T/McE37u6x297kQTJlbG0/bT/?=
 =?us-ascii?Q?N09o6oQmRLEa/9zlOp16/9pJKGJnmeq9oHRrLxcxhCQMyTYmIRVkONTVlLEe?=
 =?us-ascii?Q?s3iWiE6uq7wpNXJ9/kgV/BOCNTByUfR3xj93lK9fT4Ja3b+G7/ql7Tlgfax0?=
 =?us-ascii?Q?P8AIxd1gp0Y8/JNWbUXiXeauZA5TO8cFkyHE/X9X+GXiWEcih03IdMkhj8PK?=
 =?us-ascii?Q?DgfNDP6eA1f2NWdhSWdGP9QzzkhqZDY+s1TOSVxaNrlkep4xFUwABlscOgFM?=
 =?us-ascii?Q?QDKg7AJ9fuqIElw+ja5R94xxC+hmCHwILHV1Os0zfv9pmSjUcwZ+gLNfPp8b?=
 =?us-ascii?Q?vSCHLGlShZ9vyJ/bPCDOWEjvwFa5j9yNQRqwWFmiNqxRb3+roC/x6YOtN2sh?=
 =?us-ascii?Q?ulPb3hqT+TvUczuxrrnKRQuhyb1DtyXvQRBiTzOLi4OXK2EYUMxZTsUqoFFx?=
 =?us-ascii?Q?XL0+C+3hK7IfO0gwC5ja9QyDbB83vdZzhOppKgaby5pHYzilyUR41bw4guxU?=
 =?us-ascii?Q?0SQO7vPWBsvkD2lr2tPIk38Vub0gncjMWO3l5TKBjavRhrDlGweeAShuqVO9?=
 =?us-ascii?Q?diKV4m5/8hYrydC0AOGKT5RuQkQQ48spn48gE4SpFqLZHMlwevx9ZMBkK1OC?=
 =?us-ascii?Q?LvJ36/RmmxsnRHInB8cEkHO+ooZjFURcTo+gWJT4QRA+kuzbyRP/z5cWnbJN?=
 =?us-ascii?Q?5pZC/71RKJ6bR26+l/EFtAzELQmtRdQg4DurTNELKNQ9pgWGy1Kx83Lvz5e1?=
 =?us-ascii?Q?FKXl7yTC/Exp9Z7XOClbJ1SAKw/Wv2lDVgC4kv050smU7nuHnZDZtPTXJI6N?=
 =?us-ascii?Q?SxqeZc0lMu24qoDGmgzMQhJsnVU7PM1fBi5kgKiyMrtsk8c9uK6crbnWyVzQ?=
 =?us-ascii?Q?PU+xJx2K1F5+rXzOhvw/VwpMcOeqIjAGN2gDRChfqtdkym/ja+vf7KLGTqUF?=
 =?us-ascii?Q?Lvj1CkmLHSJs7X3uY5r8GL0purr5Lb0Z9gTWxr6TZNZ0iSO8OJMvJ1YCIhj6?=
 =?us-ascii?Q?ao5ez0n6fePXtVD4T34pgU3R8FMWBarZOmVcHsvRwG+pjwG27DHnSt7Hwax5?=
 =?us-ascii?Q?RPEtRNSz30H/T67bfPzDbdMJgWN2r6cBGZRveod3aXqY6k7gtmNf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2a25e9-6dc6-4496-cc53-08da1c43a2fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:45.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tz7rJJJjPc1+LIun5RmrHTNMhpHQDnUu5xabxthiLTHpG8SIyvEMMoR90/Z/bZ86WgaqaKejQKVfvV0MVgs0og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: ETIfpkJmEliTNu9DyGxmdqRRz3I0tyie
X-Proofpoint-GUID: ETIfpkJmEliTNu9DyGxmdqRRz3I0tyie
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 97308f8b0d867e9ef59528cd97f0db55ffdf5651 upstream

In iomap_dio_rw, when iomap_apply returns an -EFAULT error and the
IOMAP_DIO_PARTIAL flag is set, complete the request synchronously and
return a partial result.  This allows the caller to deal with the page
fault and retry the remainder of the request.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/iomap/direct-io.c  | 6 ++++++
 include/linux/iomap.h | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index a2a368e824c0..a434fb7887b2 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -581,6 +581,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == READ && iomi.pos >= dio->i_size)
 		iov_iter_revert(iter, iomi.pos - dio->i_size);
 
+	if (ret == -EFAULT && dio->size && (dio_flags & IOMAP_DIO_PARTIAL)) {
+		if (!(iocb->ki_flags & IOCB_NOWAIT))
+			wait_for_completion = true;
+		ret = 0;
+	}
+
 	/* magic error code to fall back to buffered I/O */
 	if (ret == -ENOTBLK) {
 		wait_for_completion = true;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 24f8489583ca..2a213b0d1e1f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -330,6 +330,13 @@ struct iomap_dio_ops {
   */
 #define IOMAP_DIO_OVERWRITE_ONLY	(1 << 1)
 
+/*
+ * When a page fault occurs, return a partial synchronous result and allow
+ * the caller to retry the rest of the operation after dealing with the page
+ * fault.
+ */
+#define IOMAP_DIO_PARTIAL		(1 << 2)
+
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags);
-- 
2.33.1

