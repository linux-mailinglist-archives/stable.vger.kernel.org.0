Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBD4D60A0
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348314AbiCKLdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348282AbiCKLcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:32:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DABE1BA92B;
        Fri, 11 Mar 2022 03:31:50 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BAUeRS026237;
        Fri, 11 Mar 2022 11:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=l9usY8zpgsndqi++rsG7DhqyaCrOyDcGgXp3J38awkg=;
 b=t4Jio8I/amkNTHkKMcecoRqATFYKmS2V0qmnfKWj7FmLn0sbjDGyfXfCu+E/JfQJlp80
 ICiZhJhzpn+8vF3R7HEitYLGMRsc/iIdaaW5xi/VXcXhBuigvD4OiGsg8x/vWC9q8gaj
 fhl5FMPpACkO8mcWcR0gDPmYBjMWQ5DtS/iSmXboTemiDwQgblN8wY1TKsCWUHd8vPgv
 pZOTFmIbttgCOcT5YmenXwch82zznbBG67zZ5LD0L/mbDXVfNshaXJ9Hj1VfQWsEU3lz
 TN4hy4jNT8EVAnX3+cThQTi184rS9Oauweh5YYLFUHcw4yV1NjL9FwDnqjPk2clbWO3C eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsrvfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:31:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BBHEhb192256;
        Fri, 11 Mar 2022 11:30:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3envvp36tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:30:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJPUGRixPCjWmS5dFS/HdVb6pW+VQLB6C6rx6o8eM/ht0aDuEZJxwCuopPVa8yjG21ZceCo193YrcravcPZFO7jmukJSwBHdM5jZNOAfKF6kMAZ4H2EP9Ktq1eFienmurocoDMGV4Xxcqkv8zI+uz0QuhaZLyLHDw8QS62Vy4uQJGqO7WbqzR7SBWdeXeDSdPmP8DdJDcCveMY5qo2lfD5NJmPnJuvJ2cWWk8fL0lj7hf+j1x++vrbJsT/hmy5WXaUrEmqOELlxfaJm8gN1lqbV7Q7YuhRQqutrS1QI8RJSLhYr4c0A4wz3VC8ENVfMkvOA8rxDmqtB4s7Hy3OsSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9usY8zpgsndqi++rsG7DhqyaCrOyDcGgXp3J38awkg=;
 b=kgr2YLL6y/XgvEjoAACxR35kRWkprqYxStbm1Rw9H9/QWqvZYbCZ2uVJO/2Pjbc30bRU2f7TDXt2GOAol4O5d4OnHvA4TIIrgjKCsPundaPjV+cpAz2ihj5lHICiol1O2XRUtkQfHl+oKc3647r0NMkNYr1WtQlymnji3N/shwKw0B3AuyjAF9K2RwMUkTH4KX9nnDAaLZaDR2rdnPe5ytnNCNU2LiclgKaTqx2tv3U9Po5KWUbMf6+iBnRLNhDljN+BatQ66+5JXrX1rOS8qv99kVUgLqeJFnH+BfKA9K0PjVHSWIWFmI5735pz2s4610UP9AahfXjcF0OLJONafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9usY8zpgsndqi++rsG7DhqyaCrOyDcGgXp3J38awkg=;
 b=K/yGOpYSNJYroOp3LT88Lx+TBFT4XHxU8lazB7S9eIQxN9lUhoqxq1Tvvo4BYU/jE0pR0sgMHQurn4Iqzdrm5U/zquPpRASyRffoKosn8pt5iSaLnrF1IN66ImDwKpueF2SUSP4KowWD4nyv5jTBgOUJHQ252HTeJ9HgW30xH6w=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CY4PR10MB1430.namprd10.prod.outlook.com (2603:10b6:903:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 11:30:17 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb%9]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 11:30:17 +0000
From:   Liam Merwick <liam.merwick@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, bp@alien8.de, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, krish.sadhukhan@oracle.com,
        liam.merwick@oracle.com
Subject: [PATCH 5.4 3/4] x86/mm/pat: Don't flush cache if hardware enforces cache coherency across encryption domnains
Date:   Fri, 11 Mar 2022 11:29:26 +0000
Message-Id: <20220311112927.8400-4-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220311112927.8400-1-liam.merwick@oracle.com>
References: <20220311112927.8400-1-liam.merwick@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::7) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17770c70-6016-4fd5-c8ab-08da035284ba
X-MS-TrafficTypeDiagnostic: CY4PR10MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1430774C4729339C0871644CE80C9@CY4PR10MB1430.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQwTL6NtW0kPANXnShp9nA7GkcFHjBEuq8u2UktzrVCit9LuXgjDuurnilskMDvLI8uQFCzi/TV0Lb48YgXslC3ayzby30xLl01upz9OXgM1Hj7Mola/1mGQwcV6N8UTJWHtoD5HjCuZu03L2VSQFl3bQ+e0YEYhKAUDFEZTH3q2m9BdjCFSYoCtHMm7Ab4G+NQLev6Cz+IXOUzO56B3yKMJGi34DzY1TuEvCbiEhPIXg8PjnPSoaRBiUd9f6M5+P36qG+r5s+AZAk3ErWPv74ME5Mq46F4goH786NT8J4bvAk3nwc6qP4LyKzboIXjiG6PxgOWvTrdic32MgzG9iGpOgjeoSR7vSfG9zYUSNaWpDcjMHUOLIFgSggWj29P0zyAALHdDGRk2IdygeRzPFIkJm/AoVcwfSFMDv3bII90CWuU6iq7BC29pdv9MwmnVCUMRp9M7v1oIZILU2bwLTiIJdVT7/+s6pbn5Sn4r3DOWxNOu1kz2FzqaeEYexUxSMMjeZmx3jt/X/preGZmU6pjR4fnIIEG49VnsAc3UTSHNyhTn5sxUlBm0M9PVTWLwGs2WuiMcTzuUnibYminaAcriDPdhtjsJwyiUj/MRirOKE9JAyYOf8xCM96ta6Bt5iedFeVY7xZ71OrTArRfdKpnQV+PWuQ9pGxdKtKX/8fQYdZX1nPe5xf/hMG1+FZezNAqmRdHZt9qydBXd/hwt0WJMRe9IFUEanwtuRuEfh5JFl7MbUF/KrHcQctOa/vPltm+sqq2q1vfy9cG7hMLLmkspNvtOHn1okFkcf/csFXI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(4326008)(6666004)(5660300002)(8676002)(66556008)(66476007)(66946007)(508600001)(44832011)(316002)(52116002)(6512007)(6506007)(38350700002)(966005)(6486002)(107886003)(86362001)(1076003)(186003)(26005)(2616005)(36756003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QJq+TQnGwlLXErmiRkz4iyfAbYwfZJYllpc7nNO7KQoMFG30tH+TQSdS0veO?=
 =?us-ascii?Q?XCXK/JmpejKam7YuAV+utC17CCz71ypdL5JOF2W7epY5c4UdT1BdrDwNZ+ku?=
 =?us-ascii?Q?BaLmxmKJ+9ER+dlCBwDFRxIqPMCCyiYosZmO4Fs4rBazFWu2d3lFTU4byszF?=
 =?us-ascii?Q?QVe1ukwu/s2VoCbhFp2gLIdIZ/gwh4FVcDKzW8KsmbXsvJqtLkJgrvno6ARU?=
 =?us-ascii?Q?Y35ngpXCyYQgqRvsaSiWwlt/CSMKcxcEwoYlet85UgV/DvY7BCiH8Y9hGX3C?=
 =?us-ascii?Q?X+9OA2FlVK0OkZt2XCy1gPsjFesSVbBnsHP/HovKxTMhHxt9fwoOpN9bQ6z6?=
 =?us-ascii?Q?7XNmIw69mQpaPws58tGp0VY+6iBOmD2ERGPK4zUiyd0xiKb944qypN2x0El4?=
 =?us-ascii?Q?zBX5TM0Nc0LvytQW3HpZQx8S6MHEVjeAE3WYBJZh6839l9ATn/I39mJWenvU?=
 =?us-ascii?Q?VSEOarIKlkyYVSFKQWSzH7UznjR0CORVXh1W0yk7XR4cvLaHHoWi/AABHFmn?=
 =?us-ascii?Q?agl0lZ6nY2xYdFt1nP6W8ppHQ89D47+cUsKMrgVOUz+xWb6RZB1W9MtOojkg?=
 =?us-ascii?Q?pqQkGpebP30hHi65zrh3ppCqlhhdIRTA/XCa2n4w7OCiv5OrzS4OBkkLlQ3c?=
 =?us-ascii?Q?GRKm2Opw4Eon+TfkFCHeDak9ClNYgExeQS84E/JFkLxrb1MjVVpBerVWOc3s?=
 =?us-ascii?Q?6Fmsx3fDevte7fwgCAI4u/3dwhGmJgMxUuBhwE4fF7GR/YKg/c8ZchtYkrRt?=
 =?us-ascii?Q?yaAl9lbE0VjeZ50y0Q5QAdQL6M02dBObVhUU96S/99JFO5t8TCKjN9XmyQHU?=
 =?us-ascii?Q?O11bYQNrAvtDY8tP5DY8flYlx/f4QJDijAcPC04HVU+tdadqS/jzYvFTLGMX?=
 =?us-ascii?Q?OG2UKVvbPGyVHaZ8G1R8MRLvErp2+dLMni+yXG8eB8K7sxMn66BqvgNwXsqR?=
 =?us-ascii?Q?ST9kDtFsEudVF6oIZaCMMEljmmvB/bXmmTGygIb+lAmLIpH7D5YTpcKP+80b?=
 =?us-ascii?Q?ZvVLIgG+mAdnCNXgqUqE8ZUM6gf6YtKF3VAc7GO7DiyfcuW7dySmDZzo2O87?=
 =?us-ascii?Q?UxduD/8TpUag1c6NJzTRVcm5lo1l/m8XVba3i+AbRY+LYuHLIjYwvYBTqn5j?=
 =?us-ascii?Q?KnVscHpcvLqwavj0/YB/4Jj+OwweGFYNGCDRns9b4+yBgPQgpoCXgvMUfVvZ?=
 =?us-ascii?Q?9mbffZVmy3989BRsZivmbtqArbSCwyfHJb5h3enEEe0blYGXqQ+kfcjDZxkL?=
 =?us-ascii?Q?IjZiTMmOEN9aKQJTQL2AJbthEk0NS3qF0QlRru/B4wKEFvE+osDe+oo2Iwrx?=
 =?us-ascii?Q?HFQDo0KP+fhBBjROBGJGSRI0hwht6AaoGkONsLuH0RuZqbgqLN1Y/LROl4Wf?=
 =?us-ascii?Q?HGd+K6ElUXiNgVnNkSZJSzWSxmo1RpTsOGxFYlYG/b2Lke9Lw4KM4elxTtI3?=
 =?us-ascii?Q?0fS/L6czjKf8tun1r+iyq/wAwt3tBKMyn6l8vQMKdWnQ0ERFxjV65HmiI9Ys?=
 =?us-ascii?Q?mcwxUwHeNoBn6ctHrh40WmVfZoGUB3OynQuyeKSqQ2ZZbjLXRZD6fqkqMlb6?=
 =?us-ascii?Q?6ClQhg6apMR/Gh3HHH5yzCACKPdwsdhHC21zyZq2eiNE4EEuP6Wqk6Uecios?=
 =?us-ascii?Q?uxgEfXaM1pMviD5bvTAB5C8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17770c70-6016-4fd5-c8ab-08da035284ba
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 11:30:17.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JwaBQiU4rW0XvKU5uRm1Il9bNTs/Zi3UwzPib3hrwnn7Wanx8xqak5Dh7odS18I1PE94PepnuBdQ0BFsy9ggg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1430
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110055
X-Proofpoint-GUID: EO9kJN-RBLY62hdUooQlLsP000CP1eO8
X-Proofpoint-ORIG-GUID: EO9kJN-RBLY62hdUooQlLsP000CP1eO8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

commit 75d1cc0e05af579301ce4e49cf6399be4b4e6e76 upstream.

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page is enforced. In such a
system, it is not required for software to flush the page from all CPU
caches in the system prior to changing the value of the C-bit for the
page. So check that bit before flushing the cache.

 [ bp: Massage commit message. ]

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200917212038.5090-3-krish.sadhukhan@oracle.com
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 281e584cfe39..d61313f5c5b9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1967,7 +1967,7 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	/*
 	 * Before changing the encryption attribute, we need to flush caches.
 	 */
-	cpa_flush(&cpa, 1);
+	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
 
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
-- 
2.27.0

