Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB65330BD
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiEXS4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240491AbiEXS41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:56:27 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8121D1F60C
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:56:26 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHW1m6015450;
        Tue, 24 May 2022 18:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=N1MzYs0072L/b4ZWvjt6l8RDxoKz2FCjJBb4aBjSO24=;
 b=bx4uTtGRuP3aCPfk9u05ooXkjxt8+9ZTFFjthisGYJSSEgteNSyC42IHNcdIDJMCarjm
 w5AJInfklZXQJKOX/45gZ55hmEK+MZuBYgtFDvbibLaI51a7UM7u93YzBXm+xsanNVPX
 R/Yx8DOEz9IN9hLs/3ACq+m14Xpej8CIbh6UsyAuuGZ+Xt2GotyHawCdcfXh3WeJqnOU
 ui2sxVBTfE6oVPNlET2dlxEXG9sqQKd644yjBuduxiqmmYveoBoiJRaoyp3NGyyILafc
 GQJDwXQEREw8KiKxyoepw0FQ+uif4x2c7At0x4l80+9CNcCQST+KOWHDihYVD/Xhan5Z uA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93uar1yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:55:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uj4l/oHiuXgqRZA52yj4RqlKaPgUrH7aIl0d+tVcfYLgZ8hA4VCULM0s/QFbfxW5ERMcOvB6zZjJ4m/UOQSRAgkVvL6bc5OzuU5CQ7DfTNJWWAVXWk1cyRCiwN9SBtoPKuUjQUAyrkBdUu8dmlbYBJOOOKELTwx6vCpzAn14cmtjn57lWcffNsxDXUuanbD+O0qiAzwTbZwXI1w4aaQ9HNZnwFYG9X3Aznbt8jBX541sqeAlpm8BQuAfABw4R/ZcikDm0cfROUTsJUeSue++6tI9hk0DB6CNzLsR4Gda1MUym5FQKryN4/D1nCzu4BzVFreACYIwolD5wJNFQSDqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1MzYs0072L/b4ZWvjt6l8RDxoKz2FCjJBb4aBjSO24=;
 b=Z3Picfkl+rOIt0gWQ/7NVznke8soX3hK+z+iESUSKq0CVJo06WBjk9J2KNj1G2rJzzpXkmWjV4BV9tBe67Rvwf3uyuqlrMcZ9bPvoYKQFszBnuBa4JoYtPp3o9iZabgD8dP7DaijRntnC+/24RWxrCCSIo1QYBS8of2OYihWLEfG1v0nMBe71zN7BBEp6FYRNeHbQOsIHbDYEijo+FeUhKH3NafcO4Ug1Zb9nB3uGkxF4SnrsjaB3f9A88Aw8pzlDEB8XHYESFyolp96clzKvNFw4+6N32Ih00+grqXGdaCU4Xo8oKZxZY/4w5uKE8m0PsfDaoM+T+4ikPanmdKeMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BN6PR11MB1252.namprd11.prod.outlook.com (2603:10b6:404:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:55:57 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:55:57 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 4.14 2/2] secure_seq: use the 64 bits of the siphash for port offset calculation
Date:   Tue, 24 May 2022 21:55:39 +0300
Message-Id: <20220524185539.23950-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524185539.23950-1-stefan.ghinea@windriver.com>
References: <20220524185539.23950-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0030.eurprd08.prod.outlook.com
 (2603:10a6:803:104::43) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33d4a7ae-a064-4d49-a2cb-08da3db70963
X-MS-TrafficTypeDiagnostic: BN6PR11MB1252:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB12524A43EB3C0DE994A23F22F2D79@BN6PR11MB1252.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L4cJOUFCuZpEtJptN7IZdpwvC0Yq1GyLzl5QioHam3LcLXulzqVDIsVX69TFUuxRL7t/ep5FKNQbiHsGz30mdF20VtKQl2EF5zeAUORqNwl1ZwZaALu6cpxxbEGMGwEtXFmZPMtI64vmlFpZsprB8h9rmS3BjK9znC9K5+ApTB1CUJsFcv6RlLHFYD2ctaNjg2X9IBP5J1mqfNJcRSKoQPh6XP9sMeERkhDmuiHBJ1sqK9yPZFmnoG/A5zrA0aF3KSvbtHrYsq2+hJqkDY2//5iaCwb6u24gg3Ap9skG+pNv3mtHZ83OpoxBtNDDdDnAqy+X8nJQdUJOdFHDA7z4tSvXFk3ZP5dsKoB424eF+WfW/Q5u0kpb1PRG4ZzeQUMhpn7GCZt7EI4TPjFb8lW+hWghuneNB0SnD6xSg8CGn9whAUSGBIh1Yb6uE9XKHsAcKtBE4pSOCiPW11Iw0Xn7OQFQigS/knkqbnDz8uJNPq2lSdtzV5Q83ArF2iQH7LPzPAim6wRGMLn9rtSKD7xBVLb8hSnxMHsHBob5IAHxWA15FTwSZ+YExvoyV/NnTND3tHla4r7G0HdrkniV3VffYP/jjFqU26LU7aA/Mxk8HEQQp7R3ZNLAn8F+DNJEfgGIstU7+uG6dGw/UOKmUTNu4G0DsLTfRvn3X9Vz/ehdngG1cHDyB/KN5LVcCyzfwAO+R8ubFJAefBQ2ACAovopaJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2616005)(1076003)(2906002)(38350700002)(316002)(186003)(38100700002)(83380400001)(52116002)(36756003)(44832011)(4326008)(26005)(5660300002)(7416002)(8676002)(8936002)(66476007)(66946007)(66556008)(508600001)(6506007)(6666004)(6512007)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iMdLkW0y1CidtH48Sk8eu2G0Aw5UXLsit855KaLpg1sIzO+xQ3JhvnyXw+3j?=
 =?us-ascii?Q?x4hwou94yezVzVYwGkzKEbz3uA+a0VlBMvez7ED+Fcr9fmHuoY+SRFa2VYIa?=
 =?us-ascii?Q?vERGmJfGpCVZcWIlzg+dihha03QM9qyvxvCj5TwTLlyMrWsR2xdjNjuR8wM+?=
 =?us-ascii?Q?Nbof8oT4qs9rLQA/0Y5VOhAPl2A9UPUUbWH1ntL0ly900YHKlVUQ6cdpbcHT?=
 =?us-ascii?Q?EGjbCbPgw4+8L2XpKVqb8qHa7JEo31tXTgA9bAP80PM6n2O/UEiArS18hfRj?=
 =?us-ascii?Q?EkOzFm1DbGw7gyWnzp1xV1hxF0YYQ7KnD4ILi7L51dn3WVdAX49/w40xEZdb?=
 =?us-ascii?Q?edlx7JQ8Hw1w9MwtDoqrqhQfdRhZ+CW0NPl6/BKGImf+Oxz1nhzatr8KNvhU?=
 =?us-ascii?Q?XoUQ1nmw8kbfwal4UeXvM0IVmkhuMbxOr94QMFh6MIjzNeUnPjM8ymH8cjdx?=
 =?us-ascii?Q?Hs/Dq9eDi3AntbKc2xjkeOlS9Zi+4XARPTA3EjkkflPekBI1bkspyJ2Fd5zb?=
 =?us-ascii?Q?9/2v4eTmjhl2OijIBzARfvLzPDDLXCaMeYdU2Pbfel59FyvG22LqMtdfhr+w?=
 =?us-ascii?Q?RiqFK/bpIw3F74Q8CbIRw3DXSxNn4eXjGsaE0jxj0rMkxzVKzCw6cyOAYcw+?=
 =?us-ascii?Q?1/LTHpZqtYQYnLyk8RvPStVOP0W6s0fTUwLxQ92e2JvOV1LwPAmGJihn7f3Y?=
 =?us-ascii?Q?HwDUNFyFCCV8iOdY8kFo0UlSKzX9TlDsDGZwYtrezbi8yZRC0y4Dony7W3rm?=
 =?us-ascii?Q?J6fJRvHav1mJ/i2uKJ2DpxwdGLDW36THm1lBd3qbgsiDeg8ycB+OhbVufpQ+?=
 =?us-ascii?Q?nTxovDG/ZbQChCNOf4ddjUKG5SbqiSQRn8RSs2+ONAg2rQXoBDSHAnscoShC?=
 =?us-ascii?Q?oub6/OU+Y24XdGyH+NqKV8VJD3fscb9H7hC+DOwGy2LC4pHdslxhrDSWvaBZ?=
 =?us-ascii?Q?e+mHxL00x7ifnWZyiIvp5XwyDKHX+NC9u5+7yfFmX39Sbr+BHAAI3TT725rT?=
 =?us-ascii?Q?hJQoFbt1L+oEHRB7S9oCdeXPzw7gk0Tq1oMhQhLMkqrGenxaqbstUg0O0jBq?=
 =?us-ascii?Q?NuqqSFll0k0IozTYqJxT9bDzNEfw4F+HneBfSgc6zwVaBZAMrxqxQ+WACrHm?=
 =?us-ascii?Q?93l9q/irfbqy21iTXT09iD6sVoSqPd5YZyA/zkjLdbm5lwzCoJBhOeIpe4Zh?=
 =?us-ascii?Q?uDJHu2+b8s99v1tcJTFqf9j/5p9Ijc2zvOWUxAnC2IccHjBY4eK9N19yFraq?=
 =?us-ascii?Q?xH/7UtfGY7vwCRcOmbI6US4MQ6OXl9+SVUOUTahGatiusC1Z5lzjmiA4tGLg?=
 =?us-ascii?Q?/B7plCGK7Q3GwyrbyKJCTFL1cmP+UQbODk+v+D7xXwOcIuAlptyGm0ldQxTa?=
 =?us-ascii?Q?6ALTRcc0cAZJDGMFbbE6a1OZ/x6iOS7f04EkZkifthjC2tJLwPiHSLa+lj20?=
 =?us-ascii?Q?smsYIq6CdrDiCZPuhUg8JHi05Nkkrxl1kqn6w8J7yBcmxfGs/XexBjdwpI8a?=
 =?us-ascii?Q?c8lofCkoIiGb5QsVwJKF1DN1GD81V3MkswBrXALjjVodQhxM66oXKf9f6Fr1?=
 =?us-ascii?Q?g8s/FLlwP/L+tzg7qAoZD+L6W2ZSaYtjSwrscmEXsTtvNpTTVohE9QrABIyi?=
 =?us-ascii?Q?tLCTs2S29ZQBrJwmiNS2FbHIquSX82PdLV2avH0D8zzVZJaqeQrDtZPOU13d?=
 =?us-ascii?Q?V7dXb1KNrP8xV04+XonNA69JXJA+xmRIvQ40jLWqBIqyAa+AM6u0Hp0DfVCK?=
 =?us-ascii?Q?BsZPZRGsAl7JvR4unC7pYuc69EP1T7pUlmx32payYQ9UdDIYy5Z7?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d4a7ae-a064-4d49-a2cb-08da3db70963
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:55:57.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00ieK9YcN6Rm7ZbR6ECuJ9y1jyjlw2m+oTdocHe+3ivrX2WZyvX9j9CIXcW9KGU7bGnRjT/SsRCjLeg79al/CSe4PV5B97if8T+TJzH6kJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1252
X-Proofpoint-GUID: dAga3_2_OGpeA1CzQQ4JIV-BBEV7aGNk
X-Proofpoint-ORIG-GUID: dAga3_2_OGpeA1CzQQ4JIV-BBEV7aGNk
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
index e5f4d2711404..e079478bf5c9 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -390,7 +390,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
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
index 17683aea8a35..4aaae9220908 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -96,7 +96,7 @@ u32 secure_tcpv6_seq(const __be32 *saddr, const __be32 *daddr,
 }
 EXPORT_SYMBOL(secure_tcpv6_seq);
 
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport)
 {
 	const struct {
@@ -145,7 +145,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 	return seq_scale(hash);
 }
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 0bc6549c38b1..1ebad5a024a7 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -389,7 +389,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -599,7 +599,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -639,7 +639,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -715,7 +717,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 24a21979d7df..7d83ab627b09 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -248,7 +248,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -260,7 +260,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
-- 
2.36.1

