Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C185330B9
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiEXSzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240491AbiEXSzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:55:37 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C16757B14
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:55:35 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHW1m3015450;
        Tue, 24 May 2022 18:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=ZoAhEspwi5G7THsRQrh2Gc9st8ODwnXhBmf8lMYdxGI=;
 b=mTq5MCCfsrIBxNQSOPIr9YpK05sud7uOgRBx2+DfC0U/DFLwdVqqg7z6YQ5ihvz1bg4f
 YtOWt4HmO84MSOxyc1BktP1xK9D+PLJa/Cg1tZIJHaBB8t+UQm3AT8m4ORcp9cOU4M4M
 zW/NcMYFaef0Q5qtLCSRMIboKp0a4wbvLncFQCm7VDwBUE1qrpmXDPbMiF+/+lm3/ymQ
 xq9p5r8KEnsmPTOANUQBXwI5BXPMTyuIe1lB0HXtaHIZ/1OjnD6zDW4ehoSHsIjHElEq
 /Ako/jMdC0+Z6r3CJ0RPyJDeZarRFJRvF66Au1x0ezVRW6akaCMy7gPQ5k834ftTRauW /A== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93uar1xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:55:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5QWQKCH+QNBiv+9ACTanAuOyfF/NbZfEZqvE/rYhqbH9+IPq56Cp1jEbxZcT7nL0TuI+YdJMIAMNXITn1PA/u+ZN6Qd8stGXeuKt0XINN88tft42vjswG3G/fNBsEU7ukD4VTits3OQaQeAm1x4rpkMxJu/WpK+ufo5cNV+gnrxGQQmhTmScM9JgbXTrPaZfKxudEezQ1QkWEabcLyBzRwL1GPe25VVJtW+UOne34ZlT4NL9XeVNuu5RHfqS3nmzm9UG9C6sJiQvUJ59EUGncQkHjsh62fA8jvYjhg8RLj5+XF/kFSEqicxgkGb0DljJQhvogx41xrtSDSOn7AkvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoAhEspwi5G7THsRQrh2Gc9st8ODwnXhBmf8lMYdxGI=;
 b=htpslgdrFW1aUPH5lq8pdKYPbYzXzTPD8pGGYbVEPO6inDyHUtVcOnEKk6uPsju7yBEh6p0wPGmFH0usvAxoZ99/sKtsNtUW1RxToX/aCP0SLwfjggaCtuMfODclD4RIPVBYh2PQbckFcok23PJdQ2LZVwoZjHKS5TV5UpMkLsHFsm+OmoFKyktxPQmVjLLfmvGZ74wfGw0WIGlhSRt+Ccpcq8HGTXw0SRSnvZWrtHouEpH5l9gVMrQh0/iEi3ed8LiEThpA0RlrivTMdKsutl+gGXDw03mbgusJTpB/dIML8aeKeHit6efkbwIHgzTr0PjSfp62u6mfyzRNBdZ6aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DM5PR11MB1819.namprd11.prod.outlook.com (2603:10b6:3:10a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:55:07 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:55:07 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 5.4 2/2] secure_seq: use the 64 bits of the siphash for port offset calculation
Date:   Tue, 24 May 2022 21:54:49 +0300
Message-Id: <20220524185449.23519-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524185449.23519-1-stefan.ghinea@windriver.com>
References: <20220524185449.23519-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0162.eurprd09.prod.outlook.com
 (2603:10a6:800:120::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2473ebd-f3ae-4aa2-614a-08da3db6eb4d
X-MS-TrafficTypeDiagnostic: DM5PR11MB1819:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB181976419AA41E184CDE1A18F2D79@DM5PR11MB1819.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8wDKjsSts4TLmCn4X6GtL/J6SLzLB7Ce4LMOdvCvfqbGEfmfcKQmhlZgOTCF5zLEgyLTWpGFn4fQ3QK7Lqk5qfh74wgmgZJRtRyCUNb0V/wy0vgNzVBAeopbj8NB+pW1QismX2gveB4Xqy98can8JdxV3kLXcpLm7BIy3WRV2017CP0911RFQzPWR6+cLHfrSQepQXodrEcvM3fPsZLnukRvh/e7ETN7QA5UgTcTqXPYgJWnOIj24jY21Krgr6Q/7RBjssF//v/KGrYOXeXVfbfSRQGTnXrpMc+G07ZDzplzfxIVnUaWdDJ14+kRp5M5gZhEeAD6tBzv6WxibFU0lXH3qxpbAF28LiGy9apX4rVGiNJKWz6Xv6EhEJY/J0kZ5dVUhS5bUC4ntNtvU2w/DTpd6ddacqrWpzXoTSIWNL2GPSWndPf83Zk7NjzHzvhddvTl3+II23cEtXwWnCFKanAUlVYceaZAzBEuSoO+jdSsCUpIqBj6sCZqKNHQkIUQ5LLLOISFDHjaNGSuzQiIde4zQyaQBNnckX61nua7ry2TrgPxrm5LEKJWT/pRAZbz9C0ow5w+Zd8tkMRPmRiYbJvBTD8sZpwrLo3N//GLeLYYSW9HFnR/bI212LZzEiwanZcsddmEf+tHSvzr2Q6JXiKfKAED+Ogs3kGr7UrUm0kSto1Dhr8zfbAXYqurfBPlFNOBMGAWGlBesxHuq0/+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6486002)(52116002)(83380400001)(86362001)(316002)(6916009)(508600001)(6512007)(6666004)(26005)(6506007)(38100700002)(1076003)(36756003)(38350700002)(44832011)(2906002)(5660300002)(66476007)(66556008)(66946007)(8936002)(7416002)(8676002)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ADQxwQCZCVJQzbUtBZIffOky0r3Aqvd90k/QuIr24+UT4fwBa5kQJzzLhMNH?=
 =?us-ascii?Q?zwCkDdLVehbgPrCgdchPTsAh5UGRv/s4gPp3fyH+FSW6pOVNHANjFjt4nR+W?=
 =?us-ascii?Q?XYivWmu427RyKHywIPuVknDxLhoT2BZUu5dXZLeDi9/lYbWzOiTW6/rQ5MT9?=
 =?us-ascii?Q?Kswwv7/rjCfAe1KFyWlL40beR8hB/4giszvN209JnnFWmvL7z+EGPYPTkdT6?=
 =?us-ascii?Q?yKd58sM6mFrXQtZ08RmjQQo3fHSbb3exScIrzyyFSXoxcz5ugafAKotj0LGs?=
 =?us-ascii?Q?Q+V8X0e4pPrbWpRR35JupoDb6q7V/5v2y+kymh5+GkVefzFkkNqBjkXSwoyb?=
 =?us-ascii?Q?1cxMCsLyaMyuAEdGlS1+8PNxItrvalFGHx4nxiJSRBnQjIzVZUSmtThkv0+H?=
 =?us-ascii?Q?o5gno76WT2j3+Vfga7doKl8isaDDmQVxF3rzZGWmFr0+hwBC2UofN4SqP8nv?=
 =?us-ascii?Q?HD0rsetYYjKvDSusFih0XyE5a9CJeARO+RmhxXY43PNDKM8yHQTnQEJvA37X?=
 =?us-ascii?Q?ipCfkECNKJXiU3Ukh7z5SwRXnu2iPtJFRLPCV0KZwu8FyYXdqdcZWuqJwvHK?=
 =?us-ascii?Q?W3okwqFAqdHphQi+hhBSeT43GIG68oyCbmgFAkbhiUQ+Cn5e2rtVIAmwUzin?=
 =?us-ascii?Q?ieNRhlbhZS4Em0RcMkJpTLQRx4NCGcnQjL1qOrSACsYwvkWY5YhLa+gV7je/?=
 =?us-ascii?Q?lJTfMhpVmr6TluCi+FlKVIcjZPxq9x2me9+fwCzbNw3q2NQmrllFz33YpetN?=
 =?us-ascii?Q?TAecb2OhsxSUUjCpgHE/Qm4g9knFm5wa3LJtQUSC5p9yqr9It9Nh4X/sS24H?=
 =?us-ascii?Q?kg5fcYerp49PlbDTF42zyn5Ptej7mG1s5k9ZgdyXyq5zg4RuAkjAcyix/Ube?=
 =?us-ascii?Q?I5jZGAR1WouCRAcAv6CJmcHGz7WeFOtqnEPxThdg7+4yv4B9hgX4nrULwVs0?=
 =?us-ascii?Q?sXOIlCbTv1Nw3C2gPnDwqemNMpE8U1lOKxdIr2oCJlaqLpm3eEv+FVcF62Mq?=
 =?us-ascii?Q?M9XWP0ShTdkqkBGWqqjalqdI0z2Cyd5Bm2KEyQCjkFq8TKpJBFntbptcAjmV?=
 =?us-ascii?Q?uaF7/EHID7cJyzMf6wAxaKRbH/kX8B1bZMUjJmC8N9Z9yWbw8np7hvvu9cJ2?=
 =?us-ascii?Q?rPePyK1n2Lb2RhjJWeo/SsLzMzLYJge+fpTWU52q8jKEyf6I/Jv7ma72nMAg?=
 =?us-ascii?Q?3ze0WXBNNLojOQlyPIMUfeAh8o8uICYHOMcWdNR30j4cNYVfr0/XGpbFHmO2?=
 =?us-ascii?Q?6m36yklhfbayIy/KIZlnQMFbPFQBJNjItUJRyp73MsGCheVhi1fVf7uMTrNF?=
 =?us-ascii?Q?GvCGcxAWnsReUHfH77ASL37Q8osYxr+pnvavmKjVsUHHEBdzSH+W/i7LlEzC?=
 =?us-ascii?Q?fnMR/9X6RFbfetJJqC1dYrdDXLy7iuVbP8I8iOGEXaLyLQlGaMshcbzi6KA1?=
 =?us-ascii?Q?uBI8r7IeU+6HDkB21x88t6iY+6DJDOUnmVHNoGtIhoDHV/tIvwms/51DC9eO?=
 =?us-ascii?Q?9N78JrKqhoigElx+s7dpbBcYotDZ7fVQd7b62eipMQRPSMDI4s3n9VOsl2WT?=
 =?us-ascii?Q?izz7NiLMvj31RyUmhikLg+EdC/Ds+Mr4XophmicxZpWUUrwnoFV4pyhQJ5dU?=
 =?us-ascii?Q?Iw6L8RHLBlVNyHlNuzesa4MnHUDlhoY1iJzNTBBbfyN6jeWQEaLgJzXajUuR?=
 =?us-ascii?Q?a1EUVmdJJtvxolciVTWexCK8h8vbrB1PAtA1TLn7j+8c3RzR0mpBBoWte8D/?=
 =?us-ascii?Q?TydSRQd5xH/z6AQOc1FGJupDUuTul9nRMUzN4gQioj0uNoMjqliU?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2473ebd-f3ae-4aa2-614a-08da3db6eb4d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:55:06.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSXqxjdxrH0PTmkLDEOGaQE3oXaTBL/CI+sbrFqzfH3gOnqMSX7O9MhMfaJ8HSi58lOCvj0M/6tHzCStN5Kp6c0l6aMbwPcmwFgm0qC83c4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1819
X-Proofpoint-GUID: 26PQ4zYe3HPmBGWBNHcygAHF1ULLUuep
X-Proofpoint-ORIG-GUID: 26PQ4zYe3HPmBGWBNHcygAHF1ULLUuep
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240093
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit b2d057560b8107c633b39aabe517ff9d93f285e3 upstream

SipHash replaced MD5 in secure_ipv{4,6}_port_ephemeral() via commit
7cd23e5300c1 ("secure_seq: use SipHash in place of MD5"), but the output
remained truncated to 32-bit only. In order to exploit more bits from the
hash, let's make the functions return the full 64-bit of siphash_3u32().
We also make sure the port offset calculation in __inet_hash_connect()
remains done on 32-bit to avoid the need for div_u64_rem() and an extra
cost on 32-bit systems.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[SG: Adjusted context]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 include/net/inet_hashtables.h |  2 +-
 include/net/secure_seq.h      |  4 ++--
 net/core/secure_seq.c         |  4 ++--
 net/ipv4/inet_hashtables.c    | 10 ++++++----
 net/ipv6/inet6_hashtables.c   |  4 ++--
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index a1869a678944..a186c245a6f4 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -420,7 +420,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
 }
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-			struct sock *sk, u32 port_offset,
+			struct sock *sk, u64 port_offset,
 			int (*check_established)(struct inet_timewait_death_row *,
 						 struct sock *, __u16,
 						 struct inet_timewait_sock **));
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index d7d2495f83c2..dac91aa38c5a 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -4,8 +4,8 @@
 
 #include <linux/types.h>
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
 u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 		   __be16 sport, __be16 dport);
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 2f9796a1a63f..a1867c65ac63 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -97,7 +97,7 @@ u32 secure_tcpv6_seq(const __be32 *saddr, const __be32 *daddr,
 }
 EXPORT_SYMBOL(secure_tcpv6_seq);
 
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport)
 {
 	const struct {
@@ -147,7 +147,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index dbfcefc264d6..959f4f0c8546 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -464,7 +464,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -683,7 +683,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -726,7 +726,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -803,7 +805,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index ab12e00f6bff..528c78bc920e 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -262,7 +262,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -274,7 +274,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
-- 
2.36.1

