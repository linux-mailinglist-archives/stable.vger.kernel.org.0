Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33849501E71
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbiDNWdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347214AbiDNWdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFE5C55A9;
        Thu, 14 Apr 2022 15:31:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23ELRUOi001710;
        Thu, 14 Apr 2022 22:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=xGm141X5ORNOWlahahcMKFwVYYj6JXXRT2iVDZoGil95YaAyvruFNkWfTiUS2HTp6jr/
 haO961PbMJaD9EeQMfCUhYIi68b7GYlglQmeBEShdh22VTetNmWHLpT1G9XeP3cOPUTT
 dbmPqa0tjGxtE9SuW89MmF5b8uvDxSuQI900MNuvkbuY1URNp3E/ywLnGK5jR4+VRUdF
 rkuxOsnaIrsZwrXQzdTqK3GYwRJ7s+dNChrbwihiX5cV9krG5pdKaqj3U6yRyLJpHHqk
 lLoLHlaPeMHfXuQCfKe4pD39vklgRJnZG5ymAVnxWaTk8+9duqUPcBSkNR4T82dVGxJv pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2p3wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:31:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMFrdO006467;
        Thu, 14 Apr 2022 22:31:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5p5tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:31:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWhvZQM5WHxCn2xMBF4A2d/dQSjBtZ53jGGt2neTstkQ9iPqbgXCciRBCHkaL7qCJF62uiM8J0AkWk48LwHkmF0JUt1oq1BmmPb17iCr8Ys0wWtH9dJzN8I0sz7HVWhfFSIpn/GwAMfIqvV9a1XxY7fFIvKNPsE06D8y30Aa56O1BKSptVftVJawBQYNHZPRx7wZpKKHySV6i43UYNssBy7Httz8P9Q7zjh0McQZDofX8/ZraQIwRG9GNBdxNHX2CtcRl4vFgfjxmFSu79yqzUxetI9dKmGh3bSWtAG1c7RX5jvZdoD8XBDzT6ulTZAtUEeu09akwwgOI64VyEgStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=gGkl0p3b9KXfQLwBpgegiiLokY0DXzi4uW67tGbd9Q0+3FRhcVH7qNuhPucQ+c7VmL5phILekNXftAEsTi/xoPFODkM3cX/dTPFiZMjRbbiCjrFX2F6lsrVGDQMTYrd9KmRJC2B/uZxwMX8n+3R1mxBmqZf431p9GjMNI+t2o+Kazom8TpxTICsUrSR0JgsATVMVahTh5llI2tO0zsqLXLGfVX9qLSS434TIV/2TqJPjSgMJdYY8B+Ag0r1QfXy5ZhLSTrPnD0ek0ytaWLZ0uIqZdtMW6KM2Sqjd8Ew/Ih4Gxx4j4YKdNttf8Ptb6XFuu8LqEAQOw9WoDaVPyITOgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=yNq9qLDjUzAHvkBxDJijbb9Q++zFvktU+vnGQxEV5WyVfOmpGvVP02ZzQQGMjI+ycHHYmHMRt/MYZ/CeOl86uwqqJ+ZvLGEVN/VTBxbHh+FEryc5RYhg65N3RvllNqP9Bs7KnfI2HCOcSOb7SqYYty4YXephlWB6tlA5rOdbu7c=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:31:07 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:31:07 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 18/18 stable-5.15.y] mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
Date:   Fri, 15 Apr 2022 06:28:56 +0800
Message-Id: <f0f656eec295ba30808cdaaaf7e8187b7fae162e.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0007.apcprd03.prod.outlook.com
 (2603:1096:404:14::19) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e144686a-0e39-4213-362b-08da1e667817
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5572DCE230DD85501629C66EE5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhec0CZDk0DOomx1GzZFTv1fiVo333IFOW8badi/XfAkS4HaisrRnVXPvkHGVJuCQ4zDhRzapkiRIFDBiGk37F2mg2GA1aLAfGSXTS1Qp9QEPni1pU1DS3U5LA4mVJ6Ti80l0YnCrwLVSqwY1YZhA9Ubh8HZ41KHY3FuenMCEAwlbQ2Z/HOjyLdBDLF8atXIi1jPWX7QCpgrU70gHu9A5i/MvHTIWF0KboMF4IfRrrb07jz6Jrjed/qzPm7ovX7G/jE6C89UgJ9hmLN35m9jbWPGCrkttoIzL5ZkvDaTvBAStQAwXmFvES0QrabSSWwmXqeGx133wbfruuNqu/fS6Lo/KJByZgjq55Ygqa7IBd5bUVFTOS/iV0jmuCdUD1kavTvHpYSRIhHkDyrV/cDpAYLzGmD0caYPUUAbdYolkBwyq8/PZQ2cQK8jBa2ECjTKOEKv7qQPu2+L51H55YtWqbmbG5OSAyeZO3lsSQViPfD4lyIpZsa/NQeQpEz7zt3AtSGB+val9jkVsnWl132dB+pRI0zcCxvhuIbXE4Up48imr+C2sFBtg9aJ0II+vuCfdx6pDdZ824tOZxQIOc8Zt4TQDCoqlKfQRsyqWwDaoll/9JcWPzawlL1xy5WKZBV+Mcx4b3bRWpaZVTJGbdCNxNnGvW8oIazR1ClE+pvR4ni4wB/r3o6ORTPvq5az8P387zCCcSBiw0JS/dpsgrkf4YOuMDmjuzc9crgIA7xD7io=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(966005)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YmNFKm3GvpYvom9n/PCUh++09Zps7ARfksqJ3MTn9ig6J9AXrNzew6zQDD03?=
 =?us-ascii?Q?5TdfjnWrMqKV07TCjv0fiiEatNWDEutzYVGhtcw207NLu06iEuISf+CNdC8C?=
 =?us-ascii?Q?prXK0cW36tyhD25wZbdeT13zLhlx4CO2OBoigvO/nisrgpWfS9N+NqDbbA+2?=
 =?us-ascii?Q?+PSLS4/3hZdFaZfR2BP6xgyptFQeVGHZoo/6udljU32zti6sg+Nuntj/HmHS?=
 =?us-ascii?Q?CZEMQl4eLhMBeAu/XWKf17JUt6szGr9u3NnXXzqwJ9PflR93Y7RNYJOjhpnW?=
 =?us-ascii?Q?CSvAkrDwR6EsqvPwB+BSJeKUcnHzRinaAPjkdzAn0LvhkdJ1cpDy3IZY5snt?=
 =?us-ascii?Q?IPtE/1ctRwyjzluALhO9MPcwhLgwFC+KSoqVUfIXcjOC/vrr//bwyPMjiEbc?=
 =?us-ascii?Q?dvuKANOl/6rhXqVZBrgmGgy5mDXqoaj7H0BdG0ZmkvVpt43Jy5qvZNQS4gwA?=
 =?us-ascii?Q?KRBnSyoZsJQBIqNcYcY0xBRjHL3/By4a9b+18sGEZoZVLC7mLiaAWSQgR9fL?=
 =?us-ascii?Q?+gppqqKYzCdA0S6D3FyCp7s1fSRy+oLDgO+dgNlEizzZnk2nBhM2fbEQV1YJ?=
 =?us-ascii?Q?MrTw0Pon7dF0Tu079Ae8Nr0GGgA7Rjg+yrGArkFkh6ckNzopvQmM2KlCTS2P?=
 =?us-ascii?Q?FM1C1dkK8VeaUUJyZZ44Yp10YDy/1/UeOJf2W1qUGoJeTKgpWFKmRzL/hzbB?=
 =?us-ascii?Q?HWL01gxJ2706X9fDnFDKotLuaJ5i+7GkxIZJHFJHAnLvK3vTLDK6ZLV6+AT5?=
 =?us-ascii?Q?whHnPY4tYSuYAOO3lGeLgV8a/65GNB3jprBlEHunr/4dF7gONKkjv5RqP5Zy?=
 =?us-ascii?Q?+x8guKJQL0Da7F5cD9uKnh1ZUsgQ8hF36Xij7oagishxCOexw0EwTRgsy9ez?=
 =?us-ascii?Q?2XM9v78EFz6jiQb15A6l+8xD7++ZpXmKrcqNw4vdDiZH9wS2j54COKTlvzvg?=
 =?us-ascii?Q?Rywa8IYxzPMaqAV/iaF7J0kcbR3eypq5CEcELTniX3jHCgrxIFQuzwZGGAHB?=
 =?us-ascii?Q?Jz6h/7LVnZrGu2GNpJmty5mCXyCEWZahaQiybu+3wAJRD0zA0k7bj7uSm/Pr?=
 =?us-ascii?Q?B0iryW1awQ0Kjlxf6MTo2xgnlZ0fcuK0T5f9TNh1DopOGJ2STpsS6+NTvoiL?=
 =?us-ascii?Q?sI8xLA7jb80dkSEWkWjBIeDy4j72ORClI33wGoHTIlFXVZUvo4z20KN2CbiS?=
 =?us-ascii?Q?gPhuyC93c5+QsKw9G83sjM8HuJQlyWyu2nS+yQKdLByGMYDv+UaqrALGAT3X?=
 =?us-ascii?Q?+T9FkpOOCoX1+X3TpEPBK3Du6esSfZRQexTCJTLSeOUB7rWmxBL6g0C9N9+D?=
 =?us-ascii?Q?OUqKY8bfgvyVHAUtm1I8bfD5mDeQsAobjkG01caSpeMCc6SpYHdBI6KGq3u9?=
 =?us-ascii?Q?hYgnHZRc3yRQnbC8McC7wYj5HaUGtEB6oaH/Hd6WWgLM/lg3A+tFJ5EJPpG4?=
 =?us-ascii?Q?tOYRvZFwALF9o1RNLfXHNs6YVffoL0MVUopT7fX4h/sdhwra/JKXMoLjGGcD?=
 =?us-ascii?Q?jPvfuwib38kg75i/AIM2l8aCEUaywLsESJldIC8Y/O9jeLs4u9/JfAFnQWZO?=
 =?us-ascii?Q?6gbb5qiXNh4GiKbhHtz4hbtvL+pA9oLNHfn3/PDKBrwMAluu13WGclEl/kH9?=
 =?us-ascii?Q?eeEMM4+BuJT5QR1ohtCbkE4y2aSNU9RMCtwnfZ/cw/l6grN2iFRGwXQFxzms?=
 =?us-ascii?Q?o3KsA+R6TyUQDbTGOssamX4IjcI0mstCyMp1INDc2QB1shMq1+gT6LEJJbH2?=
 =?us-ascii?Q?QHwNT1Oq/8hWWrl3DYgN/6ZKM8DRwV7ogmtDQNsWUEC9FH9cVvb+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e144686a-0e39-4213-362b-08da1e667817
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:31:07.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdZ1ugUpRyWtfTVdD5HBLyERyADDfM4pWBwhUsa4lE6MPodRCCPnEbYfEnT9lcVpTBwmTUv6qhWaR/6wcjspSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: D9IzGa18VGcwBKRFnz00RdpxB0TcXx8S
X-Proofpoint-GUID: D9IzGa18VGcwBKRFnz00RdpxB0TcXx8S
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fe673d3f5bf1fc50cdc4b754831db91a2ec10126 upstream

Instead of using GUP, make fault_in_safe_writeable() actually force a
'handle_mm_fault()' using the same fixup_user_fault() machinery that
futexes already use.

Using the GUP machinery meant that fault_in_safe_writeable() did not do
everything that a real fault would do, ranging from not auto-expanding
the stack segment, to not updating accessed or dirty flags in the page
tables (GUP sets those flags on the pages themselves).

The latter causes problems on architectures (like s390) that do accessed
bit handling in software, which meant that fault_in_safe_writeable()
didn't actually do all the fault handling it needed to, and trying to
access the user address afterwards would still cause faults.

Reported-and-tested-by: Andreas Gruenbacher <agruenba@redhat.com>
Fixes: cdd591fc86e3 ("iov_iter: Introduce fault_in_iov_iter_writeable")
Link: https://lore.kernel.org/all/CAHc6FU5nP+nziNGG0JAF1FUx-GV7kKFvM7aZuU_XD2_1v4vnvg@mail.gmail.com/
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mm/gup.c | 57 +++++++++++++++++++-------------------------------------
 1 file changed, 19 insertions(+), 38 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index a4c6affe6df3..ba2ab7a223f8 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1723,11 +1723,11 @@ EXPORT_SYMBOL(fault_in_writeable);
  * @uaddr: start of address range
  * @size: length of address range
  *
- * Faults in an address range using get_user_pages, i.e., without triggering
- * hardware page faults.  This is primarily useful when we already know that
- * some or all of the pages in the address range aren't in memory.
+ * Faults in an address range for writing.  This is primarily useful when we
+ * already know that some or all of the pages in the address range aren't in
+ * memory.
  *
- * Other than fault_in_writeable(), this function is non-destructive.
+ * Unlike fault_in_writeable(), this function is non-destructive.
  *
  * Note that we don't pin or otherwise hold the pages referenced that we fault
  * in.  There's no guarantee that they'll stay in memory for any duration of
@@ -1738,46 +1738,27 @@ EXPORT_SYMBOL(fault_in_writeable);
  */
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 {
-	unsigned long start = (unsigned long)untagged_addr(uaddr);
-	unsigned long end, nstart, nend;
+	unsigned long start = (unsigned long)uaddr, end;
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = NULL;
-	int locked = 0;
+	bool unlocked = false;
 
-	nstart = start & PAGE_MASK;
+	if (unlikely(size == 0))
+		return 0;
 	end = PAGE_ALIGN(start + size);
-	if (end < nstart)
+	if (end < start)
 		end = 0;
-	for (; nstart != end; nstart = nend) {
-		unsigned long nr_pages;
-		long ret;
 
-		if (!locked) {
-			locked = 1;
-			mmap_read_lock(mm);
-			vma = find_vma(mm, nstart);
-		} else if (nstart >= vma->vm_end)
-			vma = vma->vm_next;
-		if (!vma || vma->vm_start >= end)
-			break;
-		nend = end ? min(end, vma->vm_end) : vma->vm_end;
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
-			continue;
-		if (nstart < vma->vm_start)
-			nstart = vma->vm_start;
-		nr_pages = (nend - nstart) / PAGE_SIZE;
-		ret = __get_user_pages_locked(mm, nstart, nr_pages,
-					      NULL, NULL, &locked,
-					      FOLL_TOUCH | FOLL_WRITE);
-		if (ret <= 0)
+	mmap_read_lock(mm);
+	do {
+		if (fixup_user_fault(mm, start, FAULT_FLAG_WRITE, &unlocked))
 			break;
-		nend = nstart + ret * PAGE_SIZE;
-	}
-	if (locked)
-		mmap_read_unlock(mm);
-	if (nstart == end)
-		return 0;
-	return size - min_t(size_t, nstart - start, size);
+		start = (start + PAGE_SIZE) & PAGE_MASK;
+	} while (start != end);
+	mmap_read_unlock(mm);
+
+	if (size > (unsigned long)uaddr - start)
+		return size - ((unsigned long)uaddr - start);
+	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
 
-- 
2.33.1

