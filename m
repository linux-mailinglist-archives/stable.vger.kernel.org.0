Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B1843E78D
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJ1R7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 13:59:21 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:16246 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230350AbhJ1R7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 13:59:20 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SCbOUW009266
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 17:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=j5F1XfiRsqASILn4dEHRDNPuVQBNTLlp8E3V9t5Ht1s=;
 b=fNBDPhXIeJCnrXD2jFtx3BnQ0MqzEO2KaVH9cq+TQCS2HNPmcNVUMqYYl8hc0CB9Sga7
 lM2CAkXxaxuXVHExA8ujjm+eVH3auqlfd+PzdHQP/rK+6YOcl/VMUpmxBxpJwJxuRJLF
 6JbIOT2CEWkqFoka8oMjc/ADJhlywFXzSm5oz9NvAtc4hW/n+Abe8YJtnogcJqK+2kSd
 X+F7GjexDqDJBqRnNct2vvdmypEuoeMwz+rr5IRMFhByLejEhf4tbR3GryDSELGipIxS
 p6FWd/n7AHS0DAWBHKxfI+LvCnPsgB54v0rJMmRAgVjONfm20mCeK/QeR5y1mXDCIaSz 7Q== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-0064b401.pphosted.com with ESMTP id 3by93x15mg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 17:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ki7Q/mqvh0NusPvUMk9y+E4HX8hg9Pl+77bWAqX1nwLsMaboHg+7aWTmv/K0kSON2s6yhvZvK8xK9IZVGiLurIUGZuXikLKpMr2pK3qdHahg3IZJAA3Gh0gAzwaN3Wh2auxcQdKIWWya/kata9m6mrJ/SAoksZ+SAZP2E17+6avoPsxCToO8TV0iCZtwnGCZOi7RNBa+/7KMvGHHU+8G7x8HnbP26+tgs4bRExxngD8LKXVekoDlUrgEaWgL8ETuvpwvAi0OuaF/EiZAEDIwb47y6jZu/Fhxmd3S8wOsPwbbjKnb6f0Z7TzOiaLRcpKrvhQpMryw78bFiwcEiTWj/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5F1XfiRsqASILn4dEHRDNPuVQBNTLlp8E3V9t5Ht1s=;
 b=Qo47DIdaXExTG2LytB4pdTXrJULFYJFFebd6UMpruDXbv+U03P1u65glf5UvyY7hfsEeQbbHLV3HvvzRJS+LSw99A8ga3el24ZF5wtAqXHJ7JaihL69t1UgAC/ptnRNVI+GwdVAUVHQ3pnt3Bel8NgEasxKXm2fD7cISdeh1Mw8iEc8rp7gYqpd6olimqTIA7vcNNRGm02scSW8et1HCob08EfODjYavxz7gL4SAyoOZ3nLu7FSzK86qyManyTbT3EEu7of3Uix93JA9rgq0dhrC5VIFuQZTOgg7v1eqE4gapbjgNMh0oIOoQijXF126t6lzLa2t1I1vR/Gjy3wTHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2874.namprd11.prod.outlook.com (2603:10b6:5:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 17:56:52 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%6]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 17:56:52 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 2/2] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Thu, 28 Oct 2021 20:56:31 +0300
Message-Id: <20211028175631.1803277-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028175631.1803277-1-ovidiu.panait@windriver.com>
References: <20211028175631.1803277-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::35) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0101CA0067.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 17:56:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ca82648-a9ed-4fac-deb2-08d99a3c523a
X-MS-TrafficTypeDiagnostic: DM6PR11MB2874:
X-Microsoft-Antispam-PRVS: <DM6PR11MB2874C750EEE97C9FF856102EFE869@DM6PR11MB2874.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Waf5Lxs6rhdgSothZNLlzHt1cDYSVtZw3Wdk6UaIq/IpmTFmrieIeY2g6Mseil6qIsKNg+FIVhIQEAvOl7YEB+Hk7pkt4ajAPnw2+ba/66CiKAh81AjzUhV8Rp+blCiFfeysLIf5WFskb/bzBdRVTp0alkHeJycpziyoKRIumfgK83gX1PJCQgvKNf5AZHUEX4mCUM0xXTkj9paICMp9aTWnugALn9dISDaL8ehTNcARLOGHubQFHcTXk+6yQojadTilX9dUokSHy34+cEdvUc+YhhMkNHzD36UqGzDh5jU3WWkltShAVw5npOQKz29cUEEnSI+UKG2/o7Y7rK/yFVkYn8HwP2TbFcd3p1GjuM9BqzwMJqL0jBOUaCciiECzG1w8Q3qT7obMi770f5veO02ltkEzC8gp0wIhAM8gOuFGadh/lKZIeV3oEc6682ylGzvIY7ddakuBU4xGPOUQnMOYMyF78SiwaO3oPugFcCgdUR7Q3uul8maEheM/SvQRQl9rehH6LmiTnfhuhQEm6VMaWCfCpTjgpWpxbFtphOjK6/3wwcCr7S8LUyoa9NMcZnSxs28P/2VeahjnrQT4xQikMR3HJFAIplvsRNVMvwLWSrmMUXfJ6cUTIQRQ2D9uCTQDQFYLaHHBm7WYQWZvGbrUTE2MJOUYylRIjrsi7HshFP42jK56k1BKRntv72TJMOuwemX0i/ca8TCfzfAEQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8936002)(36756003)(66946007)(186003)(86362001)(6506007)(6916009)(44832011)(956004)(8676002)(1076003)(508600001)(66476007)(6666004)(6512007)(6486002)(316002)(38100700002)(26005)(2616005)(83380400001)(38350700002)(66556008)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/WLnicg1PPkm+dkeq4WmOjAkLyygmsx3KPxGIc1UkNCJuiqEQ8o372RX+ZR?=
 =?us-ascii?Q?TzCmuN5avkB8XM0TtseiNtJH4vsAoG1ZPx611nNuLJeCszfe1VQHIlO+8P2E?=
 =?us-ascii?Q?EvGtZDjQjuRrqV1CMwpGVUxhUCaQTnrzOerWRTuFr8PID+s0iR0KdKqiCsMc?=
 =?us-ascii?Q?kLJh8Drt0oXZSCxxuPe7tTYxzp71Y3+oKqlc6VAlW/d4nekvzKG5PLq8+Uax?=
 =?us-ascii?Q?x5tb0RWqo4FVkb3UEOCxx6AS3MQLFAxm/m+xIoRCtAxoSVj/6Ron8pXp/VME?=
 =?us-ascii?Q?xS+oCISK+M6Btoy2fyA/xUT6r0qeWGzQxPRwp1SkSuolVOdx37cJn1Br7uj4?=
 =?us-ascii?Q?u/2irTmPbA+C94hYrThxMfgNIAq68+23kYoqxHwkDtmKF3vsFYqXAQQQ6Bj5?=
 =?us-ascii?Q?CRRvcgcKmxKxHXWwDU1go3c1zxs0X6CI8GlLg9Xz6Uh0aukwmiKGGqVzyFF6?=
 =?us-ascii?Q?dcRGr07vi5kNZsPZccP3YZAhHSmZ25Ea3ARNQs4qiduzTiiVixy1aehg/RpU?=
 =?us-ascii?Q?31fWvrZwF71UObP2GzlC9iN/lFWXvKUHVSqb3f75/GLeUAwzvG9F9Meeiwpm?=
 =?us-ascii?Q?HSY3XlKw8y541/3umucAKUe7Ubg4AKP4Tvsied6+8pc4WsEyvliZ7pxZV9r4?=
 =?us-ascii?Q?UcDClGpoiEBygOu8VCFw/IyOO/FxlvHEqRVj8DblN+iULVmV7e7qOd0zsOpH?=
 =?us-ascii?Q?b6ZYkkm1H/knCXjF+Od3Vg/NVIBCpsKV1Mp/2rdYkNOlJENqMeAhdq4Xgdgo?=
 =?us-ascii?Q?d9uT5k6noIw1O3RRwU4fj8usyc8J7FXLIBu58fRJptgko+oPYN/OIO56ibiV?=
 =?us-ascii?Q?2XM2VsM5AGtB7AMiNdbEovl7CtlpY4w1sXio1jLis1Av1OrnM7/a7H9jI4Sl?=
 =?us-ascii?Q?mWyhElWNKwz+DQzuIbf5b17aCBWvyF2jJuQhV620XQm99ntsCVimKADLfYwM?=
 =?us-ascii?Q?2TXXuTpir83oJLh5Fz7rhR/C0Mq1wGJz3YVtGcDeSN58LQfiPn+xIYOZ8rcS?=
 =?us-ascii?Q?4s8mJ5AQYMwJQ4+InLJpqpZ0QlnPER//utvxXRuK0+pCNLU3dnHYXDnxMfVe?=
 =?us-ascii?Q?sMX3kCvZ9eCARvkQGpQBPY4TSmGu654U2aY/1viPwLzDEGLGrQfNRQ3ulRjA?=
 =?us-ascii?Q?GvrMlVFl72Izxr92Z57RhMjdJz5QAEn8Nu4HdiG3zBb/Z456J+ekox80MSmt?=
 =?us-ascii?Q?fYcp6RGQkZZgJrnnV9l58W3VHYN7c6hiyiV99II76vzM43ScvjCDAe2v+sj6?=
 =?us-ascii?Q?kRU4mt19ZH32pbm3do76iFz3x+pe0GATuQvSl3pciY/x6w1/DpdQoUnADSmr?=
 =?us-ascii?Q?K4DYiKXGaAu7N+xLkGdbjEWbeLt45EHtSJFpCsi1QXEh2Y6GbUIXP/17yJhY?=
 =?us-ascii?Q?lAxPYXO90zyPt0K/ZET21eE45sZvDygsgqeCKyfpfLgZOcpb+9334nf03xOW?=
 =?us-ascii?Q?lQ/LZ6AI16p3SI6/pYjZrwfPuXzAHThEaafPKFBCgW6xvKkUUeiL3l0sJYeG?=
 =?us-ascii?Q?RMv7vHZUWdQLnukftlV4ZihHd5XecmGyGBXMfW7MCkesufLV98gU1vbM1QI4?=
 =?us-ascii?Q?9Q9+30p20U3IZyg/2z12jeS+sB73HEMGR5uHO20LIRPhBKnMFuQpBdCL1BP3?=
 =?us-ascii?Q?ymQwSMOaRNRGDCzwmTg95If7pgvPR5tJuD/l+sLp8LLTQD3Omjh8H8vcBpeW?=
 =?us-ascii?Q?qlSEYw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca82648-a9ed-4fac-deb2-08d99a3c523a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 17:56:52.0559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzKhQ9LNTKLTOW3xcuRpZR/ho/UWhtdvKGW3C82iXKKbrHALxEEQGhauFQgXRcQc1UMVwqx3LVxolwfV5Pe78mEFubMRgBawKQ+SuyjWwP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2874
X-Proofpoint-GUID: qcHp6pub5wRMwDt7hD5L-eDl2dzEzXL4
X-Proofpoint-ORIG-GUID: qcHp6pub5wRMwDt7hD5L-eDl2dzEzXL4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=486 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6457378fe796815c973f631a1904e147d6ee33b1 upstream.

A group of security researchers brought to our attention
the weakness of hash function used in fnhe_hashfun().

Lets use siphash instead of Jenkins Hash, to considerably
reduce security risks.

Also remove the inline keyword, this really is distracting.

Fixes: d546c621542d ("ipv4: harden fnhe_hashfun()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: adjusted context for 5.4 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 539492998864..d1feec97fa06 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -631,14 +631,14 @@ static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 	kfree_rcu(oldest, rcu);
 }
 
-static inline u32 fnhe_hashfun(__be32 daddr)
+static u32 fnhe_hashfun(__be32 daddr)
 {
-	static u32 fnhe_hashrnd __read_mostly;
-	u32 hval;
+	static siphash_key_t fnhe_hash_key __read_mostly;
+	u64 hval;
 
-	net_get_random_once(&fnhe_hashrnd, sizeof(fnhe_hashrnd));
-	hval = jhash_1word((__force u32) daddr, fnhe_hashrnd);
-	return hash_32(hval, FNHE_HASH_SHIFT);
+	net_get_random_once(&fnhe_hash_key, sizeof(fnhe_hash_key));
+	hval = siphash_1u32((__force u32)daddr, &fnhe_hash_key);
+	return hash_64(hval, FNHE_HASH_SHIFT);
 }
 
 static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnhe)
-- 
2.25.1

