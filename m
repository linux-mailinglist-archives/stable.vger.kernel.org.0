Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF564501E70
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345494AbiDNWc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347198AbiDNWcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99025C4E33;
        Thu, 14 Apr 2022 15:30:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJT05L028178;
        Thu, 14 Apr 2022 22:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=SuLLAqGzkVEgnC9Uurr+MdSPiuqqhV34kPT76gMnqjWdsp4O11z1yq/sfXsyoWyp5VyQ
 vj028xS1obzehGDkqm9lIA/Ul00Gf42RdEVKFCHlPflSrQg7o+DJ5DoZ5eV3h4IAuFAb
 Dqq55RlElzk/k/aNIKQiuSYMYmzW9akHzsx91EBvM1UDX4fQTyADKwKunbOF6IY8qFRN
 PPcqngN8pORLFQQIun6OSXPIgooKDofibDpQtsDBy+TWd95m52DeC+TAtn21Ovt4WTMm
 EFKe5bRbV0D7fkPvNNVwadfOw1TruYSglyBYrxaB0K0sqxIKnxt91UeoSkCbuwkNshEJ +w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb21a5m00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGOMX008406;
        Thu, 14 Apr 2022 22:30:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9m6kew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+b7d+hVY8h/BpOYpzYs/E8sR+0XaVwbxZnWk5sVRvHi8ch7dtYeJlhr2EPs18rXeocbDcgbKvq87pC9zgsTRMZhXUcOWLiOmucSOEX4pREY+yNhCoqPSNkYg2Oxcsqdy68we2efJS0UIbWEp/oVBqCSwcVdBlOpYG4c+bO74t5+fv0Tyw8dnVYG66feFLKjzA2aH60eRrO8l7mQ6dqhyqqgF5LtXdeI/zolItCo8OBRwQUqHuPfPLdA7ymtrj4xrrpc75F/VAelIca7KGHu9e8e9OiYwONoD300Hh+PXzxFyuC2OEgK7eCb321IqgmYKGfvldZQdfcnoSjWF8HoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=eiy/eoelalPKuz6A7uU3IUopirF9khWKh5DHLMVGasaUjWnRyRsT16UN+6O+mQv0Xi8u6n5zQA7xY0DZmpXxhR0/r13JCiN3s7z+wy/rArBdZ5DC8iGH0RovcjS4L0f0K0+hfaek1DVUQyYrH3y0oV6wWc7wYGbShgJZXHXEhaAAeyGGRg/IUfavwoGmmqAqImV4f3iel4O0n2Vjtd0X8Q/49ArwdWwPfN8fTvGS0Z0+QfU2iIpUFYZSXH9vEzTO/qa+MzBZqnIe0qnQEicxYKZAz4YObnqABrI6l8+1g+zs74n/nx7ACdXzZzYMtoOgo1+UpJEnvVcaFDLqucf9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuGfyFsPlSPlWrwhw45+9Dc4WjbxgSWTpY2S28+blls=;
 b=D+ct7rQOimVnvzY6tspf4+1yyorXEW83vHrYCvwy3r2WHaCJgDJhtplBUrFZJchnCyWd2GP1NvftbpFEARwF5H8INTZpYLuUUYLFjNk/LUyZNxrfMdS5MdzYSkdo/IAyeadGMFEOhpt8aLrEf4mP+LDvWy2kAS3c+EorUkltFRU=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:30:13 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:13 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 10/18 stable-5.15.y] iomap: Fix iomap_dio_rw return value for user copies
Date:   Fri, 15 Apr 2022 06:28:48 +0800
Message-Id: <63440885619fdfa1a520a9528e38207311f44f2a.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::29)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99cfbcb6-e2e4-46c8-da33-08da1e6657d6
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20943C2B18A437E42EC71D96E5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HrSQ03uu+TSpdPKDsaBwvpu446g6bxZFZ78fg3v6yb8ytW4jFwUFSTueJMf+76Ntv8KjPG9OSL35bKCZVY6ghqcSmUa+PjIkeFKSWVK5p4Ju3naHeE4ldKkAJxgU/+MoQJ9rnktK9zA3yVpL/+xWwZSlbb7CUmmC2JBkGvQPFq61p0/pfbWIEk+WA0qPhx5w5xk2xjehTGP4KkiNZD1CGIJs0EGOmjaz1OVRmm75LtgHK1z91VkXmw6TLpUtZmwWqxbhV00DayopplUxtLbZZt/QPiA6xBDEvYFa4FAp4rxBNu87MSgpRflj8rMEVA6wrFQXHE5/4CI4vs+2jASe4eQA5Lg1hTcN/MjHZewtOvWASMH1Sla+1jOhxaFaI0iGUuO5/rjlwkS08r+D3okCFuHii1lbUC+3pLnuhVUPYlh0aKdqFdAn9HBYqvsGldXIhpB2SzWV7k9TvTVcLZ7LCN5DIs3fyegs4KwX1Qd9zf0x0iLllSHHeshuy3l8dZh90syLGrjs3yeaX83Fe3CaJ9JiwTFHB+3cgfkZRU9db5ucdH212TrleYqjycx69vS0hoD0+rN8LmAxkqiCTriHPhEzyTVfESaeWCXvKJchW1wLq9vnU8DjSmgclLEjZqJTjBtG6Pk5jb7fDqJkewdJIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hgQBOZYtV8NuBjLhcTQe1ivIZoC5RTDbCm3JaFjhp7wW/ljNLSh3aWtPBvea?=
 =?us-ascii?Q?MRoEVv+hNL2uDicCYxtlFf0wrggAbX1tEgVkeydFp1FVTguOfVWuxSDqZTbq?=
 =?us-ascii?Q?N54pEvT81ohVFG57+fh4e7pEPLoEHLbdGNm+UQfxjXPPWXWJ7/aG0ZTZd/Tn?=
 =?us-ascii?Q?tLJgaLhjnC4S47WK9Elh56jEEbW5oDdl/7fnaZCXusPNzS0QTh3hKFh1dv8v?=
 =?us-ascii?Q?qYBAf05QaKGywY/EdB2zRjXhUZfErVfC6hXvOSMnnlibX+s1v6hpZNsR4n7E?=
 =?us-ascii?Q?4b0ql/+nq/3j/IDku4JPjDnJaCg0p/FNzPUh0ldbuzkLRvnkUeldn559NWRH?=
 =?us-ascii?Q?1RJBfAL++e5BsWVE8qhPfLYzWCvrtguZdveZ1cM1F7U03glRoWHqluGQR50g?=
 =?us-ascii?Q?52gVJh7Xl+iQYwV9uhRom13NYbT3DcyijnXCYYsGB8SQiuRbFjjUySDpKUOU?=
 =?us-ascii?Q?KDnREYd+5MYaWYDyabadRyfQ33AEzo42CjAJBsjOh/eg7b7HUgBygNK1c2BZ?=
 =?us-ascii?Q?98SWIluACHIwQ5RKHnQ6hJqEAQVMMfYxlXbPXw9cKbAAlkkLPP1qONSpjwpG?=
 =?us-ascii?Q?FLgH8sY0adbyByFJYNhN3bVi0+ldM2ODrfwS/5JdPe7CScosPFW6MnrBpHi7?=
 =?us-ascii?Q?pMGSe9GeK2Xf4/dUUrakWtnRVjzanzv2TUCzwIKRgx+OTY3WNAk0KcvJ3fUn?=
 =?us-ascii?Q?pzPoyVFYOEPYvTv6vjK/qr7xcEr1fmREqKGTsLb7w7xjJz4JeyFaErnV03Tx?=
 =?us-ascii?Q?dQqSB6/JMEEDU/830+/hvtidyAaWxnhgSEnKSJEhP1tyHulaclnV/XM92iQx?=
 =?us-ascii?Q?pP41WK5Y4qmgPA0wgworYfm1NTCzprd/W8K+ofYlphBFZjnDZFfB/vBrrT6X?=
 =?us-ascii?Q?XXgOawouUfOECglkkTD8HtV1cdXMCJ4D/DtjdziWP1jXoROgQSUUB+I5nLWm?=
 =?us-ascii?Q?t4jDLUlPhmdiqmrPz1r48W1wiCBAaOR5jTRgsa441urFeyvopd4yjjXuJVTY?=
 =?us-ascii?Q?uGGfeAHuqSMHKx6+FD/vi30Om5vPL+yWoQUiSHZZKhixHQMNvv5j1pgZLer/?=
 =?us-ascii?Q?unQaBYmu3arlX0nyDOvBWVVhfUe2tz9aSjE1nf7UNcVVLQpM3YFSa0Ih6yUe?=
 =?us-ascii?Q?WY6lLkOazGJqW2Ddv010TZvDmkgFgrc18bVhALBey+UBY4Qz3WRoYgbpPNOj?=
 =?us-ascii?Q?Ts/LP6bQEFViKRni8E2lGQ+uYpTGrQCpkgWD9JZlZAF2rbq0GwQmJVCNtAET?=
 =?us-ascii?Q?KRZyRG5KHlILzZ/EhRJ8p6S5FDiUii9a6YmV84pGiDIdfSdnucg2tHixQ5Bc?=
 =?us-ascii?Q?hD84Q6jSCIhhYRrxlap6qjjAOf7MZovRNGUmrc4oxkzuOA+37utnb1/zLCS4?=
 =?us-ascii?Q?jqg22e08Gmtwhx6vg8W0TSPkxBkRgJtWyZRNRr8kCfownQzxq8LkccpZuUkn?=
 =?us-ascii?Q?oFhnz1QhLFbbFzpcOinXKkHbZGULrTNgdxaX0fiq5psMKl+bK3O9VaNGzyLn?=
 =?us-ascii?Q?WDz5MiHirDZ7w4wi8PQSTgq8LhKjsQ4vSilv8NGKNXi9AnW+uqu+OGGvmuJA?=
 =?us-ascii?Q?7oQhaOQB5Na2iQ6Cr9p6Nru7NuTc3/XpbhRR5vLFNs55OHD51bSOGIBSvuCu?=
 =?us-ascii?Q?JcbVvrREy+PK84asXLT3m15xlXlSuwk7vv0p9eKqCFYak6M82c4+iK0APDHe?=
 =?us-ascii?Q?WGtR64JuowzeHl4YNzMTVnv49K1Tg+CmQXz0h19d0/zMvt3xMXXViLsruFh2?=
 =?us-ascii?Q?309pM7xfph4XvHu4NjG4bQZfLHD1cfA/GS2yqct+e5GNpebjzDPL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cfbcb6-e2e4-46c8-da33-08da1e6657d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:13.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIycPGLST8T9IOApfQeCUC88JqzJfUonxBlw/mNEdYyXUhrEFVGqibzMbs1h352Tmat9UpKBqnK6UA+lMJL0oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-GUID: K2JQ_mdeEdXTXu4XCSp-bRX2LlUsAVXm
X-Proofpoint-ORIG-GUID: K2JQ_mdeEdXTXu4XCSp-bRX2LlUsAVXm
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

commit 42c498c18a94eed79896c50871889af52fa0822e upstream

When a user copy fails in one of the helpers of iomap_dio_rw, fail with
-EFAULT instead of returning 0.  This matches what iomap_dio_bio_actor
returns when it gets an -EFAULT from bio_iov_iter_get_pages.  With these
changes, iomap_dio_actor now consistently fails with -EFAULT when a user
page cannot be faulted in.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/iomap/direct-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4ecd255e0511..a2a368e824c0 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -371,6 +371,8 @@ static loff_t iomap_dio_hole_iter(const struct iomap_iter *iter,
 	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
 
 	dio->size += length;
+	if (!length)
+		return -EFAULT;
 	return length;
 }
 
@@ -402,6 +404,8 @@ static loff_t iomap_dio_inline_iter(const struct iomap_iter *iomi,
 		copied = copy_to_iter(inline_data, length, iter);
 	}
 	dio->size += copied;
+	if (!copied)
+		return -EFAULT;
 	return copied;
 }
 
-- 
2.33.1

