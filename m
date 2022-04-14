Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F3C501E67
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347118AbiDNWdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiDNWdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79461C4E36;
        Thu, 14 Apr 2022 15:30:48 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EIrgU7031505;
        Thu, 14 Apr 2022 22:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=DIlRl+J+Ng4MBRFCGYV+2tc36qeXG1xvV9Pmwp/eR4GHnobgWa5ZlPXi9+eicB3rROEZ
 Jq5i1SVg/dqc4pwHRji4iuEhozOpvVhQS4/4rG5oTZjysU//WB2UpLoxQvv+S/c5XJjM
 yxxwRuvErpFkvSkdrywvLGVPdJuw2wC4KOdQyMdK/xNj5C3KmT+OZcCdQbkB9aeBo6l2
 AmD0O0D9opjnFMEl5ZsyKefEMUNGZMGaBilTQXSXThRUHR0ufh++/LlvThO3oKNJ6iC9
 7rVfcEo3otquDXruNbhet4lde5/0GPyvaDLnnFi3Awy5fSI7FlMTRuPBrvz5rhE/gG5v 1A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse6xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGOBa008378;
        Thu, 14 Apr 2022 22:30:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9m6ktp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hqm6VSyVdVRNmTaLLQ4nXPEuE3L+5h07JDRPW+AwxihuWzGw3upJhQklGWqxIM1Mh7DZT3UujNt6g8Vv+KFpmQgMoM7aifFUfiBp3RKdYHaGXaxR+uzGI404d9z1q4xv2lIfsSOi7uRD1YrpS8wMZBf5gfSkxZuqeJiOIp3He0uCvIxcq9B9C17QZsCl3pXR4F3ag91QOZvjU9nFHGFva/jDLut7T2EtLGP9U+dC+CyK3pZ4LYfJCANoI3A5AhgUrYEapJbkuwvY3wwXP0ZN3pWCRv7Cuihp+SlprMqf1CNwjIBlh2ku+zHu4zuKcG0ySqEmQRfCWJ96yFfuFAGUrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=efGFlmuMtYnAYMEnrnQRTt46oAWyr9I+vXoaJUFh2fjkOUqMJGz8AFAg6y902/wQbX9POnO/mH5JZqO4YyVrcRPyASTWU3akQ886fZ0/ruhBOCl1UJ8edCCqgYS5KxYi/o9SX5ZrKAAgGWtRLbCy4G+jnCkLbb4E5i+ScreOVhjS+gPawNcCiQcCuuuWNhNIsNDCrnlQm2skdLdW2HxqFEN0TUGzG+IRPMYU4hxq6dU1n2CJNag1ofEeUJDmGmYGwrYThM8R1NTrB0gVYAoFyhTMMkFPH3ykG6qIrxaV0W0IkE4hFMidOSMtp/E64CPBDN+wiz8ppeDkHrSiYBH94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=yqx5RJNENscXPAgq9y4Bc9m9PTydcWW+k3KFDzbma5n6GhC/lGFaCYeCHsc6XvbcUAJAa2PTVjcVsKUtyoOhye1RgWideyaAL9R9LcKoqMR5DepvhiDMxDoQJ75g5CuHXaxrJ0q2DL3RBhL6np4fy3/gePtw47h0iA0CG1P9cNE=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:43 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:43 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 14/18 stable-5.15.y] iov_iter: Introduce nofault flag to disable page faults
Date:   Fri, 15 Apr 2022 06:28:52 +0800
Message-Id: <56bf354a8e9c5f2d3d9482c90510d4ff0890d996.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95032659-72b9-48fb-69c3-08da1e66699a
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB557241EED102A4A43E5D84E8E5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5teGwCZcciu9NjAIagH4tp+u8NLU34Qhn4QJNE8qhnNbocPwGO+kxWsz2KQV3OHSIooa8E6+E5gc3TB7gigpqetOEbNNczOTfWR2wZkWVxi0j4YVrpgK6adrZ1iXN2GfRn3LRUKR3SLAHamEn8F7ql5elZCVfIznSaltXE7zyFz4qUyNaYjL/xi6EvtNG6gr65OqZ2AUYApXVipu8QOf4ClRPVoFJivKSn963ZMiX5lFxTaKOX0HpFDshH4ILn7CcrSlOPOf+R0+XuBgiMQxugBsQM7EVH5HFX+ZwAGt2pQPCRIBZ3/y7iO1xpBOEreD1ZF3+Eyokf2oLOORW8csgFpmvSDLuOUqnyQ48Yzc2HbmvI/xM1jUHhEfFIammBlCVyuFbQ02bDMliyTmkgbNH5dyuKujOWm5CAQUAGW4IaAqNcwblyDxYgWy6cmTGrAH1ANrYOUX1Kc+SrhZ7vpfNbua34VovlERBvqK3YR1CzDmjtecIzZcGuFgSRel+IjSvkremwNYlmLJNb7tZkvfQHh9Y5PziwjFGpHmpz1efuePGTF7PxrrJm43ISNABfp5vvlUe+jFoI35vWKRLVjglApvHY6KWgws4L9WSW5eMdrlD7CXDoZ8Ivwx/DhvIdboMXvc9ZO++2YaC91+mGZMRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IfGQprZlSs/aNh8z2WbNOPcvktDAAfYn2WwUK8c4DrqW9ONgovZ5nAociOOx?=
 =?us-ascii?Q?QSf2kCpYEklYiXoKzMsevNrI5IATNEZJKxzn4rOGXW1lNC3I2IR0pqc3Dqy/?=
 =?us-ascii?Q?4bucij+pavExy0m5QqZLnCp3pl9QrAJn/Z3HTPty+/RjE4RJS1gxATpQGE2I?=
 =?us-ascii?Q?0XbrA0nfb9CQRNvjJNRwKO+/tBLK33HyoRAHU7HVgjpDPZhBmcvqViz/m6Y2?=
 =?us-ascii?Q?kaOqx/HhNruYdRM0Ii0n5qVeRe6AgbUPjWjsMmkoHAmuiojtboWVjoQxj2JU?=
 =?us-ascii?Q?Vpddfq2Pcmn6CtG+VYEozEgIlV6NP732AhskQndIDa5cKbRzJR6vUrtfBu8e?=
 =?us-ascii?Q?NtRGdoOuu8d5klDFjJTqPpc+4vFgnV/+zwwNo+WiISmpUQJN0V1BJxA3BI5G?=
 =?us-ascii?Q?CQCmLYAscgXMu6jy7cYfjLkGU4js8f5fmLDWbcnc/8+ePOE+EiAGBzT4iCLp?=
 =?us-ascii?Q?KmrT85lCMr5aTizyue7oc0r+I+O+VmIvbkpkZWPaF/oN31gKj6ceKA8R5tLj?=
 =?us-ascii?Q?yOvsTCLorkmdvPH9jRbBeIGX1PzH0RWSKR5dRTwr4tN7bVLD3GfZErVR7kwb?=
 =?us-ascii?Q?zbCQnXigJ82RGcT1iNRBhD61W/cgyVjw30vtl1wIGIgWLcp6nAeC6SrE9Hjh?=
 =?us-ascii?Q?wh0jjLSaw4RDiKJ8OhJ0mlqY5YOfP8lMRzZwatVTyXG4fIYOlXswoE6mjK9V?=
 =?us-ascii?Q?do55U3+Td+XAD4WsHCNwqo8R+WxsmCl0u3WT1SOpE3HORdg6mFIrFWshUwM2?=
 =?us-ascii?Q?fPbjF6q38gIY1Y4je1O+mOH78e6wE7sek/4w9Yw28iIAURnQXiVBToP/8jFe?=
 =?us-ascii?Q?QtTaXv6HLYK1KLbSYKgpv2G0Vswyyr5Naf7IYFkGbgmiGiJMciylotxKv4B1?=
 =?us-ascii?Q?fxLKyCwpMexZMoljfSFTO2BJDCcMcWZze4Nf3MFce8ypxRqcz1OdWwEBZKdq?=
 =?us-ascii?Q?N+RQXI0WtrUOZWESQm4A65sArukNTY5Wu29WfMXFgUj3gXLyLZu9hL8GPVH8?=
 =?us-ascii?Q?22LtS9vfd1C6FV41dg1Iixr+aMQorxelHSEtVNggvlMvQMms00wJKOlqqkXh?=
 =?us-ascii?Q?QM1ZyO91d27LyXRouhkBjGL6hVRX1xDlFemC04RzTUhJftHu/pD0JhEUTC5p?=
 =?us-ascii?Q?qGiXpBc/EwQzHOIu5l0e8ajhnRIwU4E2i6V2IxhCaTvJiTs5HblbUc2cb9bx?=
 =?us-ascii?Q?9pI/CCywY1x+4Ug+UtOXkyYRFdLyxHk7WDxpY17cH/iw8Qa5gwz82K5EcxPL?=
 =?us-ascii?Q?WUuhOnvnkr3outo9n42fD8gj8a2MUli2/lajUojijiLvmxSBd1/FBj1b5o1z?=
 =?us-ascii?Q?StaypeBTaSovKccxxTp7wcQvvumaGKHmM6BTRaeoO4OVcwQFKcCMJZQkKRvx?=
 =?us-ascii?Q?PyfaScYh+prpkdckGQby6aV6KtqHGe7BLHRixNVDt6oxkAVwMiBTKqUFElwh?=
 =?us-ascii?Q?rFhKr9hfgPyoqvfQJOEXdtO56whRncGJ8y1zuxQKWArio0pBnzLrYQN9+2oo?=
 =?us-ascii?Q?5D9ylAWZJklBZXR2NNfd8eUgECiqTOWNpl2osyo33tnB9LFWOLoxHyEC5bgz?=
 =?us-ascii?Q?hXJ261vLtLgwwtFO3qBa6FApKB1+r+30eKl5JCO+EKFMkI3YsMu6HbnlintW?=
 =?us-ascii?Q?TwkW6Dmz2ZmvNsnubEvQ8eBIcomTA1Kgh9wx/OD1qZBFxKRrmSVFWCB38sDm?=
 =?us-ascii?Q?Y1JAt9s1mnD5tZxUHD9XqesoZrW/7/31bpugcUwHxS8/g8cEg4yVSmp7ygPA?=
 =?us-ascii?Q?SmPngU0JU3zVCDExZNn2N/ivFsK9C652Kish7CWGPGVQpNkMXHua?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95032659-72b9-48fb-69c3-08da1e66699a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:43.6070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwgKEdA2JNG/ngVpFQxUWh3r5Eugz1+WIFZGVd01ZR4YMMueDj0K+elWr+jGRwWAuJUtxu8EjV6nUQYrTA20pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: idmyAuWGrQ3t12Y4uvMEXcE1Y1KPG0H5
X-Proofpoint-GUID: idmyAuWGrQ3t12Y4uvMEXcE1Y1KPG0H5
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

commit 3337ab08d08b1a375f88471d9c8b1cac968cb054 upstream

Introduce a new nofault flag to indicate to iov_iter_get_pages not to
fault in user pages.

This is implemented by passing the FOLL_NOFAULT flag to get_user_pages,
which causes get_user_pages to fail when it would otherwise fault in a
page. We'll use the ->nofault flag to prevent iomap_dio_rw from faulting
in pages when page faults are not allowed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/linux/uio.h |  1 +
 lib/iov_iter.c      | 20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 25d1c24fd829..6350354f97e9 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -35,6 +35,7 @@ struct iov_iter_state {
 
 struct iov_iter {
 	u8 iter_type;
+	bool nofault;
 	bool data_source;
 	size_t iov_offset;
 	size_t count;
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index b137da9afd7a..6d146f77601d 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -514,6 +514,7 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 	WARN_ON(direction & ~(READ | WRITE));
 	*i = (struct iov_iter) {
 		.iter_type = ITER_IOVEC,
+		.nofault = false,
 		.data_source = direction,
 		.iov = iov,
 		.nr_segs = nr_segs,
@@ -1529,13 +1530,17 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 		return 0;
 
 	if (likely(iter_is_iovec(i))) {
+		unsigned int gup_flags = 0;
 		unsigned long addr;
 
+		if (iov_iter_rw(i) != WRITE)
+			gup_flags |= FOLL_WRITE;
+		if (i->nofault)
+			gup_flags |= FOLL_NOFAULT;
+
 		addr = first_iovec_segment(i, &len, start, maxsize, maxpages);
 		n = DIV_ROUND_UP(len, PAGE_SIZE);
-		res = get_user_pages_fast(addr, n,
-				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0,
-				pages);
+		res = get_user_pages_fast(addr, n, gup_flags, pages);
 		if (unlikely(res <= 0))
 			return res;
 		return (res == n ? len : res * PAGE_SIZE) - *start;
@@ -1651,15 +1656,20 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		return 0;
 
 	if (likely(iter_is_iovec(i))) {
+		unsigned int gup_flags = 0;
 		unsigned long addr;
 
+		if (iov_iter_rw(i) != WRITE)
+			gup_flags |= FOLL_WRITE;
+		if (i->nofault)
+			gup_flags |= FOLL_NOFAULT;
+
 		addr = first_iovec_segment(i, &len, start, maxsize, ~0U);
 		n = DIV_ROUND_UP(len, PAGE_SIZE);
 		p = get_pages_array(n);
 		if (!p)
 			return -ENOMEM;
-		res = get_user_pages_fast(addr, n,
-				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0, p);
+		res = get_user_pages_fast(addr, n, gup_flags, p);
 		if (unlikely(res <= 0)) {
 			kvfree(p);
 			*pages = NULL;
-- 
2.33.1

