Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1294FCED3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347853AbiDLFUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347840AbiDLFT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDC34671;
        Mon, 11 Apr 2022 22:17:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BMmklJ006846;
        Tue, 12 Apr 2022 05:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=C7yqYlH/U412/eBU0f5DtObhR2ocTAS3AAYCVqSkxm9o20sTrOnItf8ag6YFjyAma430
 P9eQVdOqQu8Zq97i7nZlXOC84gp+CpWLCwjv8+Qz/M8Tg94CRCzc7QSyZ/bIHFjoZldH
 poqYV7P4A3kgq5GQnlR24HcwLk0Vxf6pcI9PGAUC5yyGtpQYZIM25odokLQOEdu9X0Tl
 AqqejrtHqU8ma6XkCMZlEKHToMKcyzZsNV3cGfoZR6klidFz6Jkg/i7Gkes2ziSoztWM
 1UseyMwVGDksdWJ6RzHxY7Au/JaqjMPjhEEy2mXKM3mxGVF2UbPEEHOBGoAKOB5leBCJ 4Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs5njj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5HIAC034872;
        Tue, 12 Apr 2022 05:17:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2sp1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gehihMklmMmiBdzHWK2nW49oFESaR8ua6LrigPM7K6AS9r6w0iqVknSJ/9qAs9tb07NGiCwjkC2oGX5OljgHY3ETIe0A2gJeiYnU4/NmF4xTbf12/StkWyWHfeQfg5405ig7EcwNJReYjFB/33+HEI3nHs5aTTlpIntjzxdU0A8+vcrLxGiElyMLhOsCU+EfNOttL6A24v5rBZwbX2+wCweOrub4p/a4Zrk4hTgq2LGvMmRBwcphQZMDMpyflL5JGqbfxFihxHPFKehrUfc0tGNf+5o/7FCGu+ZU8mqbc9Tn3PYzBC63Zp2MDPudf4nskFvqn6z/wUaf/gp4Hloxqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=kWk2Ql1KNP/0dl91CxOOKxqbpIjKRBuB6AkI3fleJO7GVib8zgxRE1OrH+CrWo7i8GcR31BacRnAYFaVs5O2oxdQuV3fk4HIJJ+I5n5RkWeDe9Huq7jHmbTJ+DIse6Jga8Cv1YhP4+W7RtEdJcShvsVMUMzvXFnj1CLvL/k8bAQBLdoKxTubIPyz5zRcU2mJgoNEDyQm/kvTFG117KjmzLEnsYs0Y8jXzv5M9m9idY0yCofjh/8ZiAaWwk1EK3+Vr90dywV2hJfnrNX+yfltyarc1fDn7uZXi2CAkmOUPUfel7DvDN2qsMvjAKHEYcvGXywVV/HKxvwQkEeWt3L8Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zfILGXASlYPIa/w4OJAu7wqk9O+xKx2AATdByT/LZg=;
 b=DzGotWXOk7pkzPlejUSOW+htU2wB4ekSyDrdtkanOqKM+Px9F6zZppAbouCmIZgHA/T2SkZQX0ohsLwuiVrGCqoRm5uWGzXgxFffykT2Ol4z8zVLgU7ARDlCmMIaJWTHQ4sj283w4BA+R/jxGoxeHwAaaO2j6ZQ9hsXPpIGGB0E=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:38 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:38 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 18/18 stable-5.15.y] mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
Date:   Tue, 12 Apr 2022 13:15:15 +0800
Message-Id: <440141ae160ed87665522c46dc6ebfdc400de198.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0153.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c89b78f-d469-4f91-4a22-08da1c43c2a0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB32565FFDFCB098DF6B70CA74E5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6diTArpV82DahRgaEsqgRVT6W5ZW+dJEENmIhJSb2uY+Cjymoe7BgxV73CTcz1zOe0wHjtDpHHsKSLLRl+U/Y0D+XHM/fZuqbziLJ8cumq5XhqMqw3Q7ccPbAmu7Z3K0KRnMMgkTydxLNJqK6TWcStIw0x0Ui08XssQYRJ797tFju6mnYVefqChb2ANuoeLPg2EBYUGithyZ3C76agmIYkSA6Svo5xj7mWo+N1hinSH/T1Zd0/zjYPutxKGVzu/ZJGI8k/TRjsWDcTMGSNKGQSc80eb1wXdm0leJ+AO6NPlt8yGIL/U+axtOpqPjd9lxcWKfYsmpF9bgJzPXmRDAci3PyjvMfqpmUThKe3vnKO7Nr+MJdKzEnHJqOLlJFxxWJ6aCPUkFA7Rcaz3JZhpWB/T/v0T0lCbU6O8XAS/Rd1CT2FV2maLwINUu5PZh9KNd6Zo5/qo/NDKmyFHRcwohoZJui0t47Hx3zCQynLcVrqbHtg38XvTVLRlme85A5YonttyX/BGFbczwKtdQ9Md6c/faBuqCrtmhUlaZxgSsEF5ALhbfzQX/9ZbghGH13czGWdGFdxnotyIqrjrAEP9fgnQItfyWZT14lFRN6VYT/QsC++zyWyfJRGADN9cBLPcwBZDz7V49iGLNNCGK1VTtxkijstctQgi7P381pOLVv8QWEQAoJkXwt6VUNhC6vxCZBruPz2TszdA00ciUdiC9ZBLIDsM6lz8obZeYi3qRFhg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(5660300002)(2906002)(83380400001)(6512007)(2616005)(66476007)(44832011)(107886003)(186003)(6506007)(6666004)(966005)(508600001)(66556008)(66946007)(6486002)(86362001)(54906003)(36756003)(8676002)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8O28c0Rht+q9CDpb4zxuQ3toVtSvndwVfdmwG3dVmJkVVD2jIrbc5vUHDyVJ?=
 =?us-ascii?Q?9dIPakGOpGfhoN4IexA9UPd8Gkrg0okrnE4UgVIrBR9SpcYBBOQEUUWacTyN?=
 =?us-ascii?Q?sI12jgUHRynoTqCCl55XiwZCPKROIBmHgpIx8PkfwTk+qH00hEH6/5T+wlL7?=
 =?us-ascii?Q?lvfAQfPWPMQI/SAz59dedjoROcWCJOj4vv4a+XIL/Jf4h9qn7jAUZchiQgP8?=
 =?us-ascii?Q?K4h/VekLA0XepRw9zpX8gFc770KD5htPefOfjJkRbVugjcqvw0NjJ7Mq8D9o?=
 =?us-ascii?Q?o06apwXFpBcnWbFhil09lwUzca1GXzhuUtYSF4RNERE60ai2W+VMzZTpVxI/?=
 =?us-ascii?Q?iAD/I2/2ZIbdagbD7IFQ2PbAj72q+zfv7E9LmghvgMnfpt4in+n0rLbyW7Dw?=
 =?us-ascii?Q?g9G+A8YTCLR9xHIxocaEsOiLid17kaxiY41szg5YuAn6qMtvICXDNyn1J03m?=
 =?us-ascii?Q?a5wCMvvJnQjOer61B5GDiMmwKCrZakp1RZvqP57Wmftap2EGjVXKHN4sGzQ3?=
 =?us-ascii?Q?WiKj/yjxiYkd0SzWh7sIqeKBW+O6XUGCeD97UdkcJJVd4QO8zzIGprS1A1Ml?=
 =?us-ascii?Q?JRyETmcQRmn5iJDJ2/m6D//xsRKYe+pIDAiVCnb7QAHvDE9JdesO3PUr0nhs?=
 =?us-ascii?Q?Ta4CgCTXca7cA3i1f8Z65mp0rDX5Fbcvy7qGcEKBinBHE5zilgcKzmdLCiaD?=
 =?us-ascii?Q?cKF8yvjAGatwbqqZIO/Eb5NFnkX1IF9jL5OCiZ0ermNY7WPBM5Q1IfG/9A3c?=
 =?us-ascii?Q?haHuG/hKKC64rlBshf5HrD0OhdpycFIVEWUk6WD7yWy2How8HTTydWnteCbO?=
 =?us-ascii?Q?wug6Vv3Elx4hmMR99lyel9BSuQT3PNSQEYDM40L2DOBlGPdFOlwljRb0KUpa?=
 =?us-ascii?Q?3V01wNxf0mjnz9cR5Oj1iO5urxKi/oYeZdzIow4UfqKlTSsI27+fwPND2jyf?=
 =?us-ascii?Q?aLq5fiNLfkiGZuy3nBXq0t6bfk1yqvJMtegMa/lwC6DM7gKVeT44TFfnZOEP?=
 =?us-ascii?Q?dULklPiuvoRxBDM4LV+FVmwm04PLkCIGolDqaGS6nY2Xy88k8svwrQtQz2Qa?=
 =?us-ascii?Q?vNoOuPr0Ns+EEECj+4FLvRNe/4+ze/dTWsKwjU4FZTGKPij7jWJCyenYI5AG?=
 =?us-ascii?Q?4GUMH3Nrv6zJvWkGGqsw/V02aXol7d3TA2YLEsi29gjsO0FY4iiwXbq+ihkw?=
 =?us-ascii?Q?eZSLxa9kxfeTKCAdlsqNCfWGLbDsUN6P9KeUfsapP7jKvNu1Gn7b7DfIYRmg?=
 =?us-ascii?Q?+Kk4t4h7baWb88ST6uQbdG8ODZMJHuomjyybmiOmaY/nSMLLLGtQSnj2fVx/?=
 =?us-ascii?Q?Eht8qLsUFFN+hP+Q/TOLwBfGNWoMN4vZVhQxs+FqJfnbqBrcoUCUlufU6i5D?=
 =?us-ascii?Q?+DfqajUGUBZRkhl1TY6hoVqalRhMDLgyjcewEo8aTXct/OMltEh1X70X3nru?=
 =?us-ascii?Q?wEsJcVCpgbibtP1SpMqUtZZKBL/wgvGN6cj4GKe++6rpK+Z+oW3QfFCkCeuA?=
 =?us-ascii?Q?rgJizK5DHViUvL0c3CCnGQ0xOJh7X4qsd0xxoT08aH5cFeriZJe1kHGmFM2K?=
 =?us-ascii?Q?vY682kWfrZvd5wJP0C4afNS6FOUWP48v2hGK7LrjGWwBttastmXJq/ryQEjE?=
 =?us-ascii?Q?Sj788ITkLVxa16WvG/TO1mCNsFe0wXHetC0x7Tp0Tli4Naz2p1l/2cQaQT9g?=
 =?us-ascii?Q?ssWlc+v9VPRh6XDdtfYZiuIwi2PZvgTV3vMk2XbQDbTvGx+Zp1HRsEtQeFsc?=
 =?us-ascii?Q?jmKGfJBhAzusJECO1k3STNHkZTmGMUAnrLS60xsPoT5/OvsyFvUl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c89b78f-d469-4f91-4a22-08da1c43c2a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:38.2048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOx/8vRW4xWb50alxy4OFXeVhDyWp2HrQx5HkFi8pkEtDLFFQGyTev/Htvqulsj395UjDRUNUGJNi1lwSszWgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: xkzsNb0KTPrrGVbojFK5GUaNL7moOVM5
X-Proofpoint-GUID: xkzsNb0KTPrrGVbojFK5GUaNL7moOVM5
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

