Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757DD4F0095
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354319AbiDBK36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354317AbiDBK35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788D41AA4AB;
        Sat,  2 Apr 2022 03:28:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2322rwHf018854;
        Sat, 2 Apr 2022 10:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=FGT41RxIKCNRTupgYFbB3aFTvlVks/54Obi4b/0GgJvBqL/OwbN2vxHbasM/c2Td+bxj
 0/975RQr9DKDcJCtQsTWYJAyeqBL430FYdNC5F1vSH3uUExEhBuVAX7GJ1jYdt7DWHLl
 QjIECYgZmEYXo7/Kc8GLbLhUu7BgCheF5gN7J7/z1RMo/gUliV468BnHsSbM6FZleJ4n
 qh3KCT2PYp0+kmtquk8lYqZR1sraM2aoxgT6bOJeseeu+x0j6Nt2tu+8Tgrr4IfEtxuD
 7mg6CCOFpv25QdoRFh/1qWAggWd105rfiwzxD24PR25uXJlmAt3Cn0k+Sn/jI6LBtMGm DA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3sgb0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232ALcXU024459;
        Sat, 2 Apr 2022 10:28:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xcnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhRNW/Kzuzb21C9WIuiM7AUnAZwdbArMey6pr+oQPF9AjOhupuFyE/dlEGdrRt/I7cbhTy0Dy5kdVFFWu15MejOtAgI0OHou+2mjQTdWMZ9Sd1nb3dg8UvbwfUAOoNd5Md1h7uLxiraAO96THFt2I9XIaPKceyg0HYiOqgQ2M+wbMbKjZpXCRPPrbA+RjCL/INlKOkIqG5mlXnKnsYRagLdH1HL5CPhvFrMlP6wfnZrPCDSYoyEiagip5Kwk82ghSscnwV3E5KEQn/gRRN1QVfe66tZiUu98plsiwkTWIYzndpC/Us8+e9Md/7V/vpugtcDS1z5ZhhETmLAMfKKUNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=MBom38NTESPe3hCSIzUjORd6Mf+cYM33v8uJuWMe/I2uj0p1YoHdbv31awaWYkv704Min8+v3JipvIbpz/0cM6kr93u9HHzF8ePg7Gu1KvdnsPcbzmZUSY/BBghiGtNCdBO4LuYlcD/Rh6SVESEGbecz2sy5gg7PFlzMKwm5fR7aJb5g/0sBA08d2CbPY8s5YfrlGO7EMKAXS1Sv5a6h729VTaxDQp+ip37OvqqiQQJ0tXWDfsd1sswGeiKkNfK+K406tMEvzSxu6N9RuWWlxCV4Qz7D8q7LCMp+aU/8CGm5OM9EhHvZkyWQ5nv+snMf7waAPRsttaZEK8+tR2WqNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uzLC0RNS5lLuWjzCZuI4dVyBqgt1uGnSMgLjZYLMFE=;
 b=nOnbmINcFB+P1Xa9iSa/WoM3Jp4PxYmC6Ey5LfuBWJWSW8JEvH8+L4Nj8fZWUec1pAnKBXqaz7fSX7P3+aVbkEQ49LYnLu5QwlQCyPimbIXPapNNePx25dVwhm7JPeEb//aIfgwVpIKZQVvs3AnmLRuXDrUH+7fxdUBsrTInUwg=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:28:01 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:28:01 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 14/17 stable-5.15.y] iov_iter: Introduce nofault flag to disable page faults
Date:   Sat,  2 Apr 2022 18:25:51 +0800
Message-Id: <2a866656f6fea1026c1387f20fd965906146dcd3.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:3:18::22) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 846315f9-6999-4441-aab8-08da149376db
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB304909EB3ACE7568D45CCDFCE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3h1INZClVA1T8dkQnIW01BX/vH9HyFEaIFyb/JveWJ5vsEXoVW8AiUVthufsavzEew+FlWlofLw92gD32h+GG57Hqr22axxU9RoC1urcD1HFAdGGFdtj+4bBbQvJ4AwzwqoqztYbdrL5FicHX7V30rJVuW0W6o9eNLoBJM95IA1z/Pp5ZFwbgNe1JfAs+JmPKfZsWlJK7+ei+veTQOVJxC/ot3XAfPSOou7W550POIVlYhK2IpMX6RTujNSEW/AhwXnyXJqC7FwRp+b935zVbL8qgPTepuNC8l3mXKW33RppIdKOhRyY2QNzrBv6ksUp3c8Y3jUdrCqHTTwUvUnFp8CCj3Y/JH0deGA1Gx/YJVtgf9Dcpuhkpf9/qdmRAU5R9kbQjZ7N25LEIwfNEki4W5UTitAjtk5Zr09TIZXECLgiZgT5sUs31ycahbfB/IAFjLOnHT7VF5zu3hryDu3Wf6hfuIFPWdSX8ZF47gyeDQkbvXLUm5OQKoBaksX4CNDhpsmOL8vgCwn4FCf8jwFtjPcCEkFmZrgpVrMKrwbslrhSglzYIPG6AN+Xl7LwnFSHJIvXYxpAijeFrnXPuvLZcvbGk9J8hwroTlimSmIM3hWwkTJeY59HRpsD6jgmwERI1XekD/fRAkyxUBy0i79UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y2BA5pN2/fgJ0mfguYry6Vn5RuZthdWIu5AzDupyoO0RfwjXAuq4r3TaomQo?=
 =?us-ascii?Q?jsqZoQEYwfFt45hqIT8h0HHveCGqjsCWAPtbwyU63gkeFvUmGRABJ5worndC?=
 =?us-ascii?Q?/W1ZgBSgwvGuu0rD21dzJ+pV6dnT/AXSVkFtysh/SJk78CYEN5attMDjVKvG?=
 =?us-ascii?Q?9fqn+ohTVU/xUvUVFw9BZvHqbNJrHh5xFtVfahakl4qxj6BTmaT3qXl+kl6G?=
 =?us-ascii?Q?7RdLVf1s30+wUK/m0geHrjXAx6XGmPGeffRwYZvyuAPVM1IQJ7ek+YixZIdp?=
 =?us-ascii?Q?aO+rvQF9w3SIxtw9RODZvfNui1JfgCIOXCRNNS9s+WmxZ1vUYmcjGaEbx4ig?=
 =?us-ascii?Q?STfTQeZSlggpXlUAM5pK64RDNuEFmzzIqmVYlKuNaS7Yxz/ZyLNAI+TndUfi?=
 =?us-ascii?Q?Pgj8XTFgp8tvdkrS6BjV3eiCUDG4550gssDizHcv/HPChSaW6ubcLRHIAio2?=
 =?us-ascii?Q?DQbTuUCMg+vH1lsmbKgeF7u8972eZzjE0Qqr6MJY1mVvyHLtZqd8LX2CxZbV?=
 =?us-ascii?Q?s/28wtvmHRnx58iH0ebURtYUqHPvQy5SpQ7NY3QM2F3yH6DuWCp7ErSqGijy?=
 =?us-ascii?Q?W6mCO5nwEEijopenj9dkQIaRbhWD/HNYtOQTuPlNfmBCUTauYhXXPZBOXiDe?=
 =?us-ascii?Q?nz3NQcWSZFC3SQ8xr1F/Zb+4IT97NS26uzA+vUYU5C+mO95FlCd8APWV5ybl?=
 =?us-ascii?Q?ywrsJYKZ1jIJlT58dDZX0k3NmwWxuySgO3JpK9IGzjVW8wwntFoVWhO4+5d6?=
 =?us-ascii?Q?HMTAID0ZjEU9VrEq2aNZf+hAdJ8RgTarTLNexqPmzfX/QwX0RjEWxvT9/T37?=
 =?us-ascii?Q?2ulTSA1LkSpIxWaguDSDF4Y8/49NFuN1mhzBsJ/+3BesQ1Cs+39xb2xeJEnA?=
 =?us-ascii?Q?R2SkXFdr5tdU0nyHhI2rVEnUJwofI5XQuHtlXUAzyRL6y6nEGp0Tuq2CRyJU?=
 =?us-ascii?Q?3xSIQEe5HzKTYDkzmgoaTo3uolKO1adc+H+e7b9hAKRCpzQioTLrBoBZvEn/?=
 =?us-ascii?Q?PpQMo46UoBdeXbafqazAWbmOtgEcVfShlRQLMFx9UuyGm6O6Kvi2GsiiQB/I?=
 =?us-ascii?Q?2LsCWPi3C1oUsuK2Xhx2+s6gkIdHTOTh3lWYoemlr7nJxdaK2q5BdSR6HJ2Y?=
 =?us-ascii?Q?c8wVVSTwTFme99fQZ8OVnAuxtYgUuHw1wOjYBSIPlRUktbjVgRVR4pLKS3ws?=
 =?us-ascii?Q?/X8OIx0ZY3F3Zlu+Kwg5mlPUQlwsHsdqlIfxhSCUk65Tp0rwCmT5CP0K9hOy?=
 =?us-ascii?Q?9kovNLunNuqsc7VRSZoZD8XzXRtIHAqLU+ngjeuoYJMHjH8PbPzLvjhVbXpg?=
 =?us-ascii?Q?pB47/0KKFjmcuYCJQqFZzZA7PfCzL1VQRzqlIQf9TOJTOsBqHSfuIrV1loI8?=
 =?us-ascii?Q?PxUCmFXaZuBzQmbA4wGP4cdO7YBd+uP6GH+7XtjKvAhzRkcZbaYfH3PZL4pF?=
 =?us-ascii?Q?byacydXiRAMGrqNw2MXH8UypHTZSJZUeRpWX55aBjq1uisRjBnUPMkTHcCEq?=
 =?us-ascii?Q?ygk5I1KXYXXa1oFqedY20OrTt9rPf6F1chR7UOos57tTqXfwWqtge2tPRkPz?=
 =?us-ascii?Q?z6X+QLgQOmKsoYg3nWRuY7tBIb47jHFwxioiW50EPgYNNUE/ci4Z9zEPPfKU?=
 =?us-ascii?Q?qGCKFkilZafIql011bqGCCvoLnKyChOv7cYC5Ntxvvz4+a3LxJcrC1nTQ3bh?=
 =?us-ascii?Q?hYHc9lP55XmU9xWYn18ABMFdEpCW4ANnWaH12cVltlBDtgWL9aKoxuNk4kls?=
 =?us-ascii?Q?uEJ4qOZe9MDGIeB2+L3ejpFl413CqVM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 846315f9-6999-4441-aab8-08da149376db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:28:01.4139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQkqpYKq1zcz/tBpBZNH1/WTzHKDNq03fWCEc2cGE2ZdZTraGI+aS0TR8vf71v2QeVykDd1FB5WW6Qr6XL+OOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: cK_CmZEdsN1Lag4GMFYsBfIiq42GcUx4
X-Proofpoint-GUID: cK_CmZEdsN1Lag4GMFYsBfIiq42GcUx4
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

