Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D634F4019
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiDEMgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383728AbiDEM0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 08:26:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1A292D22;
        Tue,  5 Apr 2022 04:33:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235AcFTd012570;
        Tue, 5 Apr 2022 11:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=UHc3bwLelWXJW8fqzj6bnN/4QyFO17dUXsS78hUZnIlzvfh6LPx3hORByAXUbCEQjlyw
 5uKwExuRk5hBV2+rpJiAvOHugP+YZuQB60sHoOZQuU63c+ydoF27Zy8DrbibpTCy6oxQ
 Nbn0YITQAIAsGM72rThshg480yoSH21xQ9Hkg0caLCL+EryZsa9Gk2LKacf8DC+hDUOB
 +bCMjMCgyqwKJrv8jw70NMvhTGMsKRlgfQ4hUDYBOU0nR5klOySpFZvlVHOucvNplp9E
 8HXIZ2sE9uhvCu41qh9nbYgo63kkSMHgDYzBk7ebKjYG+KHtEEtcn3IJ2Z/9zEfabaav 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcdpkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:33:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235BVbv2039284;
        Tue, 5 Apr 2022 11:33:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx3mm5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:33:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3hY/LEzxc8GNnaT46IwU7KbPVhdtUsULwCx5d9HJ1e/Kxk5T5N6shL2c2TxaBI1JkzsXRoZvfeMsvyKVJcf4SDcFalf3wBnQ1g0V7Ej/9twghyPwCzwxqi5vJB86FdmWdPADZeTQaBZ00JdzezNLRj+UNTiBIA3z92BhgdysrVbVvwa6r2qGR/pTa4Z9yIpF85DMJNji84YJo3Pad160GCpgP6Z/zDABpeWiMMoJBowv/FkwDlHqfVVLywchQmkSHkBigtWXTwwlcASNZ4BUYIK07nMK1GRc9XVU7Ih+PN0wxv9KPIXPpQ/lf/TFb1cG82XTauxK0YfR70hAZzR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=gL+G11/8IWLT4KzzmkA/2E1IKEHLYAW39Pf1xmdNZBion7JX1Vbo8aRHlAtNWT3er5b67Y01BQTPkyKdXSjTAxaZ9+AjFGmWA8XIw6tqfJez0lSKQNi6qTVzZHEQoIYJudesxnKfAkK8Rju1bJHfUg8gOwRfuROohye/iUaSviTmjWl6ESEwZkd82AuhHMbpe14FS3q+E9NTgegjRjh5+yasg8wOlQNbr10dQCrR4KT/AniFNn46UoIdP/fLov50xGVVN6L4Nh4eHIsg77f+Rz4HQomZm+Jd6DL9hk2WH0iw6SeecsKVmPSDhwsEAGwxOBQ4kQVsnHzGg0DYDgIg/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=dC2NjuZooBzIJ8k68cbT/VDN4zNoIuhkfS15mMXNxpFyryZ5VH1WJm7N5KQjqi9Yd0VtFlBxNQGcAURIqfWo+me8mT7g8K6B6huRbX18mkPNcwE9mvg4hGq4mbD63dgF6jbydFKqWFYuekKvyHnomfk2NGffBndGImEoUc4xEPg=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MN2PR10MB3952.namprd10.prod.outlook.com (2603:10b6:208:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 11:33:38 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 11:33:38 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/2 stable-5.15.y] mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
Date:   Tue,  5 Apr 2022 19:33:12 +0800
Message-Id: <d3516c342876dece090e52b9d6858938bcfaa1f1.1649154880.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649154880.git.anand.jain@oracle.com>
References: <cover.1649154880.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::22)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25b75646-c829-4237-8da7-08da16f82069
X-MS-TrafficTypeDiagnostic: MN2PR10MB3952:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB39524EF6F77D651C1B60C48FE5E49@MN2PR10MB3952.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWrn0CA06crLfa+hUqPlIsl/m6LzNL9hlA/YLHhXlAG/HqGiCXpnjcYkg3ovZ7PCosFGgYh+nNRqEmoT47QcVuZqAYzxKm95lDI6JTeTmkSU54jG8EBdi3cSUBqVBcu/MmipOLN7lqAOvPEmOXkaN0g6aM8mpXEhnOSg2S/o6LuoaLN10sz2OGPIrkTLZGsJIyT2AEFwVOEmfdSRfSpwR0PUeeHCKQVGnmfIoM0mt9lVAj3PASfgsLuZeIXY8POJhWLdJeEs/RDAgWZ09US+guAYq2sjJuIozRQedjKVSxxFy5RTLC7wIqBkC7ET/HpVvWz2B5ZWIXH8fbUvhHCydMAhRrctpTQ+2PU4NkUABGPoYX7IK1zG5FS84uu+uFB6fUnhJ6Is1qlRoXhQAqdGMBNPiwuHleYYkRIov+hPuXh4SDVx79BKYpmon58WCAG3m+gTIKVkWvpz3YSl8xOwdEb+FJbbbL8fWhds3bGytcXub6FGu9EDsTWw9mGEAhtBTlNWdujOQWbAFwUZKypp3P6iP6qFHsQqPXZISsFabeh3JP67ts6VgSAsDbuk4oRc07RqxCk9WeozN6OMiy3XuxJp8IE+UlASazThYlpTF9fSfGHTQ57e5CDDDSNSbEAUbYiMvRddujr+ljm5s9FG7HYbOUuyRiGRMPhlMOZ6vCBMVWV8/PBhQDU5c8MW16l01SGG6VT+OImItFX6/ildWMn0C9gQzKEJnH+vW1CdR1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(83380400001)(66476007)(508600001)(4326008)(316002)(6486002)(6506007)(86362001)(66946007)(66556008)(6512007)(6666004)(8676002)(966005)(6916009)(2616005)(107886003)(186003)(44832011)(36756003)(26005)(2906002)(8936002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NjS/G++nNDWX14VVeKcUHQueNosBQWasJ2hxac9Ro1voqTX8GHf6pI/fvTKM?=
 =?us-ascii?Q?FCro1yHGpy5hAnPgW7QGN9+GQWGKo5m+Sig1UFDhaPUbtnmAQx1g/h9pj76d?=
 =?us-ascii?Q?d8bsa1e5Acz9EILnFeKdYLi2gQdtzI556wsuoWV/oCiOi8YzcSEjhSPEx2xK?=
 =?us-ascii?Q?0UXS+GeGpNcZZaYkZ23bIU8IUfubsS97kV/oV65TJpnP6d7L/mEsmNd0PRud?=
 =?us-ascii?Q?PTU/3Z8LxuKFw5f0b7LqRUWaRJf+8QDIlmyP4l83ePbwB19npgxovUZrhwpQ?=
 =?us-ascii?Q?8SUd5zX1i5aOyQozOi8+RQdk900xCyN/l7X3p8JjkHCgESz5rh5jCG+eOUhj?=
 =?us-ascii?Q?2oTtW+h28vD61E545T3EGwta7ABSVvuxgecNIR+Qi8trI9XmyHjBIBcb6ySP?=
 =?us-ascii?Q?t+extFSOXVIgTo6NvLqStk+NwlZWU1aaiXbwCJBjJPb91qIOIe+0Zxe/XVxQ?=
 =?us-ascii?Q?vHCNjz9qf2kjkYIYcoa6FV5nU298DbwXtXMhOdqWaKF9JRC+xOAMQY/PIZYc?=
 =?us-ascii?Q?BV1oIa9fBDaIgYt51CkXdKSDR8+qm4HdTbXkecnKzRTTwg4XYYY42jYMSneH?=
 =?us-ascii?Q?9W2tvvUgqnlY05zU13QNz65RJwQgHXvVG0dTNNQNITB3XCoSS1g0AmfniKOj?=
 =?us-ascii?Q?VafgijqkAp7QWYUrqtIWJRTxun5wg1FAPkBya3ZlxYSvURHHsl28Ehk0bD1b?=
 =?us-ascii?Q?+ScaKTj4CiBvEm1SCxBmSZhbdKzCGQl16nupI7SMWZH3K3u/8mmhgQGfuNcH?=
 =?us-ascii?Q?p8J2GSE5eGBiLywONBhKNa4p45fx/JOiYOo+BImGfNebPda3bhJJr5KMw2e/?=
 =?us-ascii?Q?6xFJe9Iburn219shXtmCll+vIFPi01v+GFh5WoE1NvLQl0pAUzRMmB2NmXuA?=
 =?us-ascii?Q?INfVWk+Y8YirnTxzulaWYGI1a6xbZ+/e0JQtPfkeBr+T6y4EtcKzdJOLJR8Y?=
 =?us-ascii?Q?orrU5TgbjRDBU7fyil5O9uw3iHCjiB+Z2T1qPPKjMRqyGu3PC6uxY+dRhEa5?=
 =?us-ascii?Q?EF16xCHXfd81XI0xYxaMOoHj/Ejf6x/6YEfjpBidp+2qA96eGZiASXM2Y5g1?=
 =?us-ascii?Q?MHPVgzSCa7kYDyCJqzS/50xivWXRIS3zLqGB0n15g4D8Pi2kkIKBWOHbxvQh?=
 =?us-ascii?Q?bbKvK7dumcturDp/iZMV4wzyvveP2huvog6zMAtdiEZw1mlanKzJtyWuD0ZX?=
 =?us-ascii?Q?H+wJnQjkOe0UaP+7JTIP6Lu1GLBSytQ80qFKECd131VH+SsCt7hYoL8wZZo8?=
 =?us-ascii?Q?V9Uvlz2AYNrgdL4FeU36xQJKO6jWmwH0v3H708fFVNtoMqO4RpszSiFn5lOH?=
 =?us-ascii?Q?WlhtfrXPeoJznnkIU/XMdTFJyTwLifQlf7rmPvibcwNAJNJRa5kmSf7BaSlN?=
 =?us-ascii?Q?xkc31ME3YN95y7FfqbqBj+o6o0FpfQnR5efd+MRrBrWo8wb9IZNZxNeOBAHL?=
 =?us-ascii?Q?SwWeKd4d9g4RegL7HIax/NDZRcDn8ArsPHgLp3GrJZroY+VM/4EDtA9+ssdG?=
 =?us-ascii?Q?9YWtATnC6COToGK3OU47JEeseJRu0cMhn5e6a0jtXJMtJXVHIM8goD/gVcWP?=
 =?us-ascii?Q?DRMp1MFqTgK4G6cKa8HTj41EIo+nnX0mwUoJBWSqIA0Gs4I0KnWoYk2T9dWp?=
 =?us-ascii?Q?9Fl7ZI9VNcvTks9GyycQ+a0+T0OU03w8xUrqF6ZaGd+XUwpI3za6FQDDsQ6j?=
 =?us-ascii?Q?oyal2Twzr+02rz5rnUE9XQysAnl3OorGkmTyv6UysTbD+fGfusoQpu++VJID?=
 =?us-ascii?Q?/xX32Ejzn5EZulO9Wn1O5qYGyWJwGHY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b75646-c829-4237-8da7-08da16f82069
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 11:33:38.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Upe2qEkGb3/ina6IdRB75+4JTfPBAIqknyj4s6XVDmHLiqhqCid86wx5O4B+9AtNyhZXGiP3ARaXJxwERZWGZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3952
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_02:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050068
X-Proofpoint-ORIG-GUID: f-uofV678nXxIokp7SEKQi4I8tKlVjtr
X-Proofpoint-GUID: f-uofV678nXxIokp7SEKQi4I8tKlVjtr
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

