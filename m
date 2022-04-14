Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB51501E4A
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiDNWbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347011AbiDNWbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:31:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F521C334E;
        Thu, 14 Apr 2022 15:29:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJsTXU008887;
        Thu, 14 Apr 2022 22:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=DwrdZQu0jlDMEJdjPDBxmVFgXoc2G+++c8YQtGyNNXuZBcru9oVl7Mxv48AWSQQq1/7s
 NzGm6u4+bxUIlaIe7+Z1IGMaDPo1D2n/Ay9NIWtIpI8Jbl8gCjlXogcnFvCrjb6Lu5XM
 1Yoc9QTNdw1026TC9lxpaC5O0ZXhIfiapHKNSrFe7KCFUIsmJHDXVo+tiXf88rVq8piT
 XOaYWPNMEg7qHnel9szsChqob1//t5kANtCT9hP83L23Fb4sei+DLDCfkddI/wE/508D
 JAxPsNwA0svBC6gSk+nbcFTwyCmfp8gtmLzT7X7/dPxxQaIcPAFm3FYImPh611/Eufop Ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2p3ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGVIr009355;
        Thu, 14 Apr 2022 22:29:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck15d90y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFcsw5PUF//Mvw0Kx9uEpcens5x1QPB/SoAUnOnLLkezKZAVWc5yZ+w29FCLcElUXodumCf4RaMPncxfe9e5BWtGYXopu2m93l+HsYxlemU0SUU1rqxeHlbprxfGZJRN8avEEV1+zrzjVNCCXrLLPc37CvsS5WeUIt+5+c9WS9hw9WtEuc56nUCcjfvynXP2ZNbQlMCtmJmnjFnSoReFycxn5+N51qTRs0hl4+JTyIOLUfiYQ7+beM8/A/LXjO6sa+UFg7oFitdPl4LXCkr0xThpleT+eSH7bwRIWVg9163c/UtdU1R/C2INti8VKlWh+sAYJTZEzuUQd27FukEZYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=G6byUOtMxnJhyFSSxQ7fZ9fSdAwOhdclOBUnfkWPM+QPyhtu2rnWNK9zPn3WagvLL0GrK1xciamGbe4M3BqIAuJ3tp3+yNohzk1MRXtPL3YDunE3GPB7QVYGkksvAOj+RmWtzlX44v8yhSi7x3nALd9PuCoqMpp3fONhb//o2/c7kiAP9LppXFBm29Q7dQmw4ebTrLEQ56pUNsJrTJ210b2pWxppyGNQvay+HbEhLbgcLBWzsgXj66d0l30zvJ8UKHL3h2llHA7uXRJEiyb95Tct1lI8tDcA6hoeiC45A5+YbAasGe1FqVQYUuEw38yeZQGVFrY0dzY6hs47Mky26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=lyj5Bcex6AD9wVp6L+CsjuvXQLBHz3KmBHbcH4gJXHXPKK4rkQlsX6aUW7Gp1LLF1NPfyF1PKN7D+l+xOLuMmofvmFIFPHXN/hhYMiC/ChCJuBiOJ4harrx+GtPbHoMuwkstIV2bg0OCqb/rfWbxgskPQ0ZS95HS+zp4DBgd29Q=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:11 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:11 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 01/18 stable-5.15.y] gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}
Date:   Fri, 15 Apr 2022 06:28:39 +0800
Message-Id: <92b6e65e73dd2764bef59e0e20b65143ab28914a.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:404:14::32) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aef494a-dc48-43a8-535e-08da1e66328e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20945E2E2E392E27E5F52D56E5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pVgzDvnPKMPeZvZbcu8r86HUl5P2qCW8WTQYmL9Xwl3cdSi1Df0bX5JK5dFxVj7gTEQZqHsDKJjIHsWPtNRHvHZtdRlpxBKaNgaX2Qc4kj/tKc+/MhQntrydSJoDFRPqKg0gORaMsALPC8TwCcjf+R8H1G0aJ+nk9V2Az2XUHObVgCF/vO3WJMzW96aGTHosZxdOezShLLZtXy+EVgKgx9Kcqe50xdoJB0Tjp0wzV8J/IQ8Sn0CQE/52CIHPBfqwbWl43UkygAlYHWJnj1df1fY8YUyzFo065ct/CC1SZGA2KR9tuLDQgUkYdeVBcLPdnSGptfPI9YPEDerslHNwNz1r7o0hO5X0C9ZL5PvXUI5vAA8Uc2KwnOBtzqmf5fQ6AVXXVLnAwy7kek/S1Tve9/GdccOyeDZgTMSChDfx4xzEpCymComlF87cbnAW0/aaSt1g7F8+k/DJ+LSzA5VnxcIdF4juVr+tVxWkQbrXrknigW1Lsxg05JU4YhaVtXyBL6Fm4dHSa8yK0u61w/bDfx2sAdhmTTis962NhZ6qsVT+Ot1TLk5OlfPLuBN7O8WJ7O7wDKJhqrkPn2BdIHQDTy98j9TZGZlT1hIsvaqgs7Obz3Q8FAkZGdMhf5Cn0vYDEyrqpmAD5itsUBhTiwKGHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(30864003)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v1cKlxzwIotKBeRf4bVdGa2G/f+3oAFddP+5qz/ymLGc9SRSCa8EpvrXOKtA?=
 =?us-ascii?Q?3DQu36ZSh5mMw/mos338CaA5jxgBd6armfbRraeoZvpZ7nZ1Jgkl6LqbTzYC?=
 =?us-ascii?Q?wgTbrt93WbogbPDP/LS7/xG/+j7zWecQY5BwxJcO6QIjt3QG+GWCJwFeQMDV?=
 =?us-ascii?Q?DIvuvQz274G8vw7rrlrbfs1dYxWeOHFNCm0Bik5u7DS/uPGsN5Mm9Y3sseFg?=
 =?us-ascii?Q?jVmZLvDjlz27BNAJWurJuJfwz/xyj88HRDNNterRqdX1WQ+PKrMu7jWloU6j?=
 =?us-ascii?Q?F3K3vwy8gUqrxME1CXCLYF/7rLoKTf48HImvv3mkUEYhdmmbymcO2CB7MEy7?=
 =?us-ascii?Q?ESIk4Fk91++Vj+5+t1AwAZp9CbKchgjWhpPgYzcPDfuNUj52Z5sEfyeg68/D?=
 =?us-ascii?Q?hJ+pQdGcPwHDDoHFrn8PgiYa2IA3igaVsE8glwdsCgYrOuNA0qp2JpuWFvJ6?=
 =?us-ascii?Q?6cv0KFrsH1VJriLMkXyezs/sBZpEy5+Gk+6yjBNbVf6gLDJzKH0RAhh08Boi?=
 =?us-ascii?Q?tYjKazV/ocrzP171TwOeCQFK9gFudQpn6vL/wLcB1Ys4cvcty9CqMJJUJm0h?=
 =?us-ascii?Q?aYYsolsnKBUGahKC9cqEfR0A1/b8ASVDrFC92Av1YninDaGSOktrEwoJPtX8?=
 =?us-ascii?Q?2AveZjNDVfkW2Pc83trf7PrchgbKMBLU1zFbeyXQACahIDDqCXX0ryZoJr6M?=
 =?us-ascii?Q?9irGEGhbRu9Yiaz6N+mfjgz6JZkPyIIVguW4wJxrf+4pIMMdDMA33Nr9l/wd?=
 =?us-ascii?Q?hcrnNhYC+kgF+Hku0kSHFo7nAIHWzdaFLXoZa10YRdwwjkK4p2WC4ssVqn7A?=
 =?us-ascii?Q?qoJG0llVNmooj4QQBH97zFS61VEB3sCQmilCcBXOl17DFzPzKKrWQLLXQx2Y?=
 =?us-ascii?Q?YuVmxvBNv4lByAglNRemgqIuPEsVcpuGK9Sp7MEgJkq4UYXz43XS95SNh7tJ?=
 =?us-ascii?Q?GP9glWUDFZY3fIT7RdFix/y50kzxXyDws5tHyG1wMZoG5EMtnrv7KixRIfwc?=
 =?us-ascii?Q?/bRnv1Lk93m+HIWMrB1DterSMIlppUIjRhbXJIYoIJF7XHpdh0UILqBF649l?=
 =?us-ascii?Q?4fl19ZGy2WieScslOZWn/6EEQNGrP3M+yJdfoBTa4QzaWEf1mGEtVoPsjH7M?=
 =?us-ascii?Q?sTqM6cjOIFsl0JMTnhDdG2A+vNtqqelZZOcbEJExbaaZSwjxgwlp0ajxocgs?=
 =?us-ascii?Q?x+y6R8q0GcTuQBBZEet2GiImThGpK9utY42/0QUyF4CukTNh6s1hKv8yIAJ0?=
 =?us-ascii?Q?if0ufnkaJ+iHmqWEtckzOPN8xP+KHGpViqhvZ8U46P/Cnp0Qh4BgUEmwb77X?=
 =?us-ascii?Q?eRPF+jx/ZCotX1QjrMHfUzpbFxvZuX9Z41ufntyylbsSOztifbpam4jTM+8b?=
 =?us-ascii?Q?HZgBgRaCb5OO3yJdXuxvYGvJ+qvVYzwuAeGI0W9L70wGo5PUQ35lRO07MIF/?=
 =?us-ascii?Q?fs5w+iYsCQkmD+6Bm7xqQ8rVhnfF3mahniLMp5oP++AI5nxdYaXz0yWl23Ci?=
 =?us-ascii?Q?azWxjRNt3QA2LIIeoyGyYhxwNuwfwrRjaaQrw8pOqUA4b1R8XzEnNZKTcW2x?=
 =?us-ascii?Q?FKD0RF/Q0v9zyzcnDzWKRiQ4PFTSsV6xSg5o8zvinPeySt+qsqbpycflMKl9?=
 =?us-ascii?Q?ph2IVPCwFaPQmiybIrTPTNlQFYJSHHBuzxaz862SWLO4ZXPuIKcDGCalqkLr?=
 =?us-ascii?Q?ytqkdvesDKOvk+NYE1TIAADNm1BOzJYz6lD3Odj1h5D8b8rpo7qPjyG2FfWz?=
 =?us-ascii?Q?gLarULw/6ldSGypni0q4wh6jTVxQWBvQw/EmkQhygJ4MOG9ro+E0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aef494a-dc48-43a8-535e-08da1e66328e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:11.1438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enG1u47Awzw3TPra7/55AiHwalYn+HHDKPiBWSuSm5cM8CpDAaKdM6/O174Qm9NU6hMWyiV66z4C2mdNjDa5rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: oSSv1eT5uTelYNasziBpfLJqUTEI-Ske
X-Proofpoint-GUID: oSSv1eT5uTelYNasziBpfLJqUTEI-Ske
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

commit bb523b406c849eef8f265a07cd7f320f1f177743 upstream

Turn fault_in_pages_{readable,writeable} into versions that return the
number of bytes not faulted in, similar to copy_to_user, instead of
returning a non-zero value when any of the requested pages couldn't be
faulted in.  This supports the existing users that require all pages to
be faulted in as well as new users that are happy if any pages can be
faulted in.

Rename the functions to fault_in_{readable,writeable} to make sure
this change doesn't silently break things.

Neither of these functions is entirely trivial and it doesn't seem
useful to inline them, so move them to mm/gup.c.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 arch/powerpc/kernel/kvm.c           |  3 +-
 arch/powerpc/kernel/signal_32.c     |  4 +-
 arch/powerpc/kernel/signal_64.c     |  2 +-
 arch/x86/kernel/fpu/signal.c        |  7 ++-
 drivers/gpu/drm/armada/armada_gem.c |  7 ++-
 fs/btrfs/ioctl.c                    |  5 +-
 include/linux/pagemap.h             | 57 ++---------------------
 lib/iov_iter.c                      | 10 ++--
 mm/filemap.c                        |  2 +-
 mm/gup.c                            | 72 +++++++++++++++++++++++++++++
 10 files changed, 93 insertions(+), 76 deletions(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index d89cf802d9aa..6568823cf306 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -669,7 +669,8 @@ static void __init kvm_use_magic_page(void)
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_readable((const char __user *)KVM_MAGIC_PAGE,
+			      sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index f2da879264bc..3e053e2fd6b6 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1048,7 +1048,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
 	if (new_ctx == NULL)
 		return 0;
 	if (!access_ok(new_ctx, ctx_size) ||
-	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
+	    fault_in_readable((char __user *)new_ctx, ctx_size))
 		return -EFAULT;
 
 	/*
@@ -1239,7 +1239,7 @@ SYSCALL_DEFINE3(debug_setcontext, struct ucontext __user *, ctx,
 #endif
 
 	if (!access_ok(ctx, sizeof(*ctx)) ||
-	    fault_in_pages_readable((u8 __user *)ctx, sizeof(*ctx)))
+	    fault_in_readable((char __user *)ctx, sizeof(*ctx)))
 		return -EFAULT;
 
 	/*
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index bb9c077ac132..d1e1fc0acbea 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -688,7 +688,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
 	if (new_ctx == NULL)
 		return 0;
 	if (!access_ok(new_ctx, ctx_size) ||
-	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
+	    fault_in_readable((char __user *)new_ctx, ctx_size))
 		return -EFAULT;
 
 	/*
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 831b25c5e705..7f71bd4dcd0d 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -205,7 +205,7 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+		if (!fault_in_writeable(buf_fx, fpu_user_xstate_size))
 			goto retry;
 		return -EFAULT;
 	}
@@ -278,10 +278,9 @@ static int restore_fpregs_from_user(void __user *buf, u64 xrestore,
 		if (ret != -EFAULT)
 			return -EINVAL;
 
-		ret = fault_in_pages_readable(buf, size);
-		if (!ret)
+		if (!fault_in_readable(buf, size))
 			goto retry;
-		return ret;
+		return -EFAULT;
 	}
 
 	/*
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 21909642ee4c..8fbb25913327 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -336,7 +336,7 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	struct drm_armada_gem_pwrite *args = data;
 	struct armada_gem_object *dobj;
 	char __user *ptr;
-	int ret;
+	int ret = 0;
 
 	DRM_DEBUG_DRIVER("handle %u off %u size %u ptr 0x%llx\n",
 		args->handle, args->offset, args->size, args->ptr);
@@ -349,9 +349,8 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	if (!access_ok(ptr, args->size))
 		return -EFAULT;
 
-	ret = fault_in_pages_readable(ptr, args->size);
-	if (ret)
-		return ret;
+	if (fault_in_readable(ptr, args->size))
+		return -EFAULT;
 
 	dobj = armada_gem_object_lookup(file, args->handle);
 	if (dobj == NULL)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6a863b3f6de0..bf53af8694f8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2258,9 +2258,8 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;
 
 	while (1) {
-		ret = fault_in_pages_writeable(ubuf + sk_offset,
-					       *buf_size - sk_offset);
-		if (ret)
+		ret = -EFAULT;
+		if (fault_in_writeable(ubuf + sk_offset, *buf_size - sk_offset))
 			break;
 
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 62db6b0176b9..9fe94f7a4f7e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -733,61 +733,10 @@ int wait_on_page_private_2_killable(struct page *page);
 extern void add_page_wait_queue(struct page *page, wait_queue_entry_t *waiter);
 
 /*
- * Fault everything in given userspace address range in.
+ * Fault in userspace address range.
  */
-static inline int fault_in_pages_writeable(char __user *uaddr, size_t size)
-{
-	char __user *end = uaddr + size - 1;
-
-	if (unlikely(size == 0))
-		return 0;
-
-	if (unlikely(uaddr > end))
-		return -EFAULT;
-	/*
-	 * Writing zeroes into userspace here is OK, because we know that if
-	 * the zero gets there, we'll be overwriting it.
-	 */
-	do {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			return -EFAULT;
-		uaddr += PAGE_SIZE;
-	} while (uaddr <= end);
-
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK))
-		return __put_user(0, end);
-
-	return 0;
-}
-
-static inline int fault_in_pages_readable(const char __user *uaddr, size_t size)
-{
-	volatile char c;
-	const char __user *end = uaddr + size - 1;
-
-	if (unlikely(size == 0))
-		return 0;
-
-	if (unlikely(uaddr > end))
-		return -EFAULT;
-
-	do {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			return -EFAULT;
-		uaddr += PAGE_SIZE;
-	} while (uaddr <= end);
-
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK)) {
-		return __get_user(c, end);
-	}
-
-	(void)c;
-	return 0;
-}
+size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c5b2f0f4b8a8..2e07a4b083ed 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -191,7 +191,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_writeable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_writeable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		from = kaddr + offset;
 
@@ -275,7 +275,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -447,13 +447,11 @@ int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
 			bytes = i->count;
 		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
 			size_t len = min(bytes, p->iov_len - skip);
-			int err;
 
 			if (unlikely(!len))
 				continue;
-			err = fault_in_pages_readable(p->iov_base + skip, len);
-			if (unlikely(err))
-				return err;
+			if (fault_in_readable(p->iov_base + skip, len))
+				return -EFAULT;
 			bytes -= len;
 		}
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index 1293c3409e42..d697b3446a4a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -90,7 +90,7 @@
  *      ->lock_page		(filemap_fault, access_process_vm)
  *
  *  ->i_rwsem			(generic_perform_write)
- *    ->mmap_lock		(fault_in_pages_readable->do_page_fault)
+ *    ->mmap_lock		(fault_in_readable->do_page_fault)
  *
  *  bdi->wb.list_lock
  *    sb_lock			(fs/fs-writeback.c)
diff --git a/mm/gup.c b/mm/gup.c
index 52f08e3177e9..e063cb2bb187 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1681,6 +1681,78 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 }
 #endif /* !CONFIG_MMU */
 
+/**
+ * fault_in_writeable - fault in userspace address range for writing
+ * @uaddr: start of address range
+ * @size: size of address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_writeable(char __user *uaddr, size_t size)
+{
+	char __user *start = uaddr, *end;
+
+	if (unlikely(size == 0))
+		return 0;
+	if (!PAGE_ALIGNED(uaddr)) {
+		if (unlikely(__put_user(0, uaddr) != 0))
+			return size;
+		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
+	}
+	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
+	if (unlikely(end < start))
+		end = NULL;
+	while (uaddr != end) {
+		if (unlikely(__put_user(0, uaddr) != 0))
+			goto out;
+		uaddr += PAGE_SIZE;
+	}
+
+out:
+	if (size > uaddr - start)
+		return size - (uaddr - start);
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_writeable);
+
+/**
+ * fault_in_readable - fault in userspace address range for reading
+ * @uaddr: start of user address range
+ * @size: size of user address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_readable(const char __user *uaddr, size_t size)
+{
+	const char __user *start = uaddr, *end;
+	volatile char c;
+
+	if (unlikely(size == 0))
+		return 0;
+	if (!PAGE_ALIGNED(uaddr)) {
+		if (unlikely(__get_user(c, uaddr) != 0))
+			return size;
+		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
+	}
+	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
+	if (unlikely(end < start))
+		end = NULL;
+	while (uaddr != end) {
+		if (unlikely(__get_user(c, uaddr) != 0))
+			goto out;
+		uaddr += PAGE_SIZE;
+	}
+
+out:
+	(void)c;
+	if (size > uaddr - start)
+		return size - (uaddr - start);
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_readable);
+
 /**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
-- 
2.33.1

