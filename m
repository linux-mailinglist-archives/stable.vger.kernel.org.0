Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A528A5330B5
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiEXSzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiEXSzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:55:22 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFB55717A
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:55:19 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHWfDd005307;
        Tue, 24 May 2022 18:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=zDPYP0T2iw8IXh2xrFXtKoP5aSCEsUSCLqBWfqK4/RM=;
 b=jNThh9vmmgO/rAL5vfxXL4AhNv8Epz5RQnUbnfx/AjoM9TLPF50EfshRB3x7+Ug4FJWB
 R7KtzGg739joJuCsHlt6jpSGqzfOiHQwLMY5+D6fVkYRUutjGZcp3wACeV84wmoYl/8i
 X+ixPtwak/+t6KZTWaMhRXQuEEsOzzYIMM+iOs7ixudEKerHJJf+5FDd0eoXnJh2Tq/n
 3DkqT6DZhen9m8QEJAjK1mMUN6ze6v0Obh8NyGD1hjESI/MNvJU2nO+l8R7sZZcGMxuP
 RGQ/7T/Bdygm4vY/jcUVeIJ6XCr1uo3gms74hIraNcRVUWpefpsgrigN28GEGpS/ibvg KQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93ub01wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:54:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJHMbAoJpMTuYM/Zpb9VUhLV57tU9jlOnF/R1xWY1Q2V9vOWcNBrqyBYoNk06hx8q4Bk9J0wHK5RgpZIv7SKs0mx3RNeLl2cr0syjO4ebO4wQ8mT/PiqNV6+8noSamYUqBfrGnaszjAPOFPF+gpOIePacTMWfzfSTEnmcxBbc/OqaN+ePvlNK4lTxfoY5lsSUmntYL0V6jpK5FLjoTW0qMBKK6BWqFDkIbN37RpGtus7qYEWHSLQZyuGr6+mPHPPYFZnKyhFCEk7NCvecnskhNt8KRRvld4hVNfC8hyC1a/AkbsXwqMpUkuq/T6vF0SKEow0OdA8etB6hL+eX6uNiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDPYP0T2iw8IXh2xrFXtKoP5aSCEsUSCLqBWfqK4/RM=;
 b=TqfSXyG5ZBMmPBP/m63qrE2Vfza37o+KUYGfI5Ca3hbYXYl7a6SEjDqeRtB2aYzyICrR/owohpEBSviQ/Z9vG9Fa555uNPN8J9cPsc7+Gcd2yGfxvbtd3mcyMB7ki/2Vozg3GPsttdz+/NwBZ0k6ibrA/eWMGNUsDF0d2YQdIuo2zkS+EGCHXZLWvgdBMmbkApztU2i1BYj+WNl3uHTIAmGu23kp+R+1NY6LRNEdnARrPKLOXpTc0BYzYKyyW4i8p2s/fLpP1AQt3f++9m/7QIaBoqIKTzYxgS/IobZ/HgbWkiH/xLcq7Wg5HwrU4zjpbluqf+lF1vpekj75t0Nl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DM5PR11MB1819.namprd11.prod.outlook.com (2603:10b6:3:10a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:54:42 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:54:42 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 5.10 2/2] secure_seq: use the 64 bits of the siphash for port offset calculation
Date:   Tue, 24 May 2022 21:54:23 +0300
Message-Id: <20220524185423.23312-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524185423.23312-1-stefan.ghinea@windriver.com>
References: <20220524185423.23312-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0155.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::48) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f44861-e167-4d67-2a84-08da3db6dc93
X-MS-TrafficTypeDiagnostic: DM5PR11MB1819:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB1819E6A528564443FF18F4D7F2D79@DM5PR11MB1819.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xdmrzCsFVd/RyO1+w/dvsexVFH4lVs+e5DsmAHgI2WHmMv6AIZ0lLPX8E5Jd0OlryBw4PdIHq6CzJCMIleQOggfv+l0MBfUNG0/AqBdmcs6EtiU+gefPHWeEjH54qqcHoPJ/Vk03FFFhmRgMWipbXJ/kIkxuSmOX2a5EHns4HRSln/1XA9Er/gyT2H2m1mn6lwlGwamfWr+J9cSKO+QHIz2ibualdTRdHTCIK7BnCTcR6zgAW2R9OmHFB1sk7/TvYEECtiUqIKQci78/8AgcU52fyfulo9A362scoQTniOvRSr915+IzhgytNFDqciZqWRh4m1ksqogLe02d9IBB/vdX1AKxZMTaDT216jv/DHdDiit6T+030lYM0h3wXepZGUN9uxaKpgWtJctExDXjqIV+l68nLlaFUDh7bS3H/AvaflteY290Ka7g4ueK6Ii2CIz3NwmnSO/qsrszK+wPRonqI5uXkjFA66vZooO4s7LFWQ9l84mwJWgJBEt/UQkmtjZWUjsrvet+h6CifUx5hAKxbetGcNeU72wtqSx2HTcLWbdrptDkGtzex7dZusiwl+0D8NaT/yPv+jNAvoN2m14ifa50P9FMjcSAERxfv3RYZDUVh7QeRmEO7F2c8VPatippk60d9HpMXE96nPFuCuwaCeDUOhi5Y+YsvRQlguy+VlGrNNn4pSZfMyunhFbxngv0tc9uW2LPzVItPLAVuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6486002)(52116002)(83380400001)(86362001)(316002)(6916009)(508600001)(6512007)(6666004)(26005)(6506007)(38100700002)(1076003)(36756003)(38350700002)(44832011)(2906002)(5660300002)(66476007)(66556008)(66946007)(8936002)(7416002)(8676002)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LKRo7dqS8hhrUq9CuIpasiL0D2fEdm2/THpNEENwVje9YR6OdnWHOWCIeoav?=
 =?us-ascii?Q?z7SzZwmRQpBfNN36a2uquxenshKpz5JzTmNswZBdyCTe5+Oxrr5sAxZlxgDJ?=
 =?us-ascii?Q?WzwZ6cNtJwzSDbVFX2Kw4OVlZ6aGTNgvI85UGdAIIQb/WcC+hnuNOau2ZDPu?=
 =?us-ascii?Q?7NdXkxb3OVlWghmx7e/uKCR2TvuTah8K/aahFs7eHkqqcQ9ajuzzLY/WSs3I?=
 =?us-ascii?Q?rNft5o1mC3bW5J9r+ekIsIz0EB/r8wy6CMoa/iZv/Kvt0dQPV3Iq1LGqLRMx?=
 =?us-ascii?Q?mFQ8CQoIyWFqy2z0sZ+Gg3DyXYfq1RsJoiveu8fK+eqt6YMQL6dCGvZA+m3y?=
 =?us-ascii?Q?jS3CA0XZOErGboOxUFkjZqZlMZ+jv05EylmPMts31nd71uHY1iLx3OBBPx0m?=
 =?us-ascii?Q?LKPRmjS1BvKsshjEdUPhyvlQXY/a2AXYvElviVZDyt3qekjY42+VnEitKdSV?=
 =?us-ascii?Q?AjIOKK+5uaEaATDzYnK1odrfmfeKW0jOTjY+kwkyivFBAfyl5MuDsWntjubb?=
 =?us-ascii?Q?UVLpYuo/74edRxQjclWgJIHiT+DEGZP5I/aole02LDaYsFmthfHKLckzkBak?=
 =?us-ascii?Q?ioRqVUJxCgx+R4aK7RpFwiwsUmsY39io5NiVq9052tm/JjECXAwcuBsKHhIk?=
 =?us-ascii?Q?uOa5K7GxpkBzZREfr/moK0qc/YJC/HSaJl+1EGaSY5F8FyJdsdMAt1Jwv4FQ?=
 =?us-ascii?Q?ppv29J9XOc1iETA5pQ3QKysKMYEHvghIC9Q8GekjCgC+iZbQPoaKpUTAWeVv?=
 =?us-ascii?Q?e1nuYbyVt6c/SUOhhJhojdw3+ekpxbqPiZxltl5GLfz5obD0BKRar889QwBJ?=
 =?us-ascii?Q?Xmd6CvGdzmx37zQuN868KPT4qMlgNVWWi1wRGew99ewQ1uPFACcWmo3FrYTd?=
 =?us-ascii?Q?AM0aURvXvNkA9yG8Ee0ZFyyeHQ5dLZptekqoOjSIAPqXPqYHAkMuUjU+PfW1?=
 =?us-ascii?Q?hcZa9YS2GF29krUinxw0vxZGx0cr575bhAxZ9UFcEaXIf4sXi/BJoWDxvbBw?=
 =?us-ascii?Q?q3NZ0MMNQH00+ljDDg0L5tk3kGI7ow0XE8rFW9PelcbGzYpIh698uGxgOg1A?=
 =?us-ascii?Q?slYxQd5F58P7K0maN7JJYJzQdAyp2GKQ2s6QxRkUxQQ6PXjdQg7a6Bnhm0g8?=
 =?us-ascii?Q?4WFkn9bMwpWXoFrjr51vKJ9sV5YHbVRI0livDWAvdm7bpA7sivWYwE0meEXT?=
 =?us-ascii?Q?DFP8G/e3WVbwLmv7cv98hC0eCyYudJuSsMrOXQryz40i0mr2lzjWiupyi13a?=
 =?us-ascii?Q?cnU1qbmrqCe3feHK+sioHoDkoeS+diN0j+QQ/OYX3n4cAG4IjF2W9Us8uKXK?=
 =?us-ascii?Q?fzOEGIXMO5o57B+FMTeGYLcVO7xGDcTjcyVgw+scFX+k3cKCnShaJ34CXVBr?=
 =?us-ascii?Q?yIBDSIkSOWaxeUWs1b63hWJ32M6/cVKzkK5iYIx1zhFu0vUoTjJxy4oPdoIw?=
 =?us-ascii?Q?WECriOINsrTeeInL4CZTA4k3lvtOjH0/dgKBvjYXJFqECTaqqcUBT/pZc37P?=
 =?us-ascii?Q?OPPzQ64K4b0qs0w0eW5tBL4wjsuhe6Dxo9+4G0Eq9EPaNi1bc/Nw8vJnrjzY?=
 =?us-ascii?Q?qbJIhP23scV3kLh5VctHHl282+cp1HNAVsf5r0l/NmsKX2b0cFFRwHVKC2rq?=
 =?us-ascii?Q?+Ap8DZ7CBNA8tr0BzsFZy2qJQVWo5sgCAeq9oRe5AdgB4rpktDlmW6wfSvKA?=
 =?us-ascii?Q?1PiFA2f/iFb6W0fz/l4UUUBVL+ye9mTX81aEJUVeHvp9xjrrRXr3Mi826N3I?=
 =?us-ascii?Q?Dn4VjY/6MGawswKtM9dMDVaEMm8tABM=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f44861-e167-4d67-2a84-08da3db6dc93
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:54:42.2195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4B250Y0LUt6ARTAZf/z44/LVy/5bcGFkJfblC2dKvjlj24LtVH7C3bgH45hh3tsb+lYnU3nlt836u5rQhHUAhf/dQ1ACZTfmkCOILY9quGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1819
X-Proofpoint-ORIG-GUID: KlSUJlZHamRTWCmHwoF00KOuqV3kZce3
X-Proofpoint-GUID: KlSUJlZHamRTWCmHwoF00KOuqV3kZce3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index ca6a3ea9057e..d4d611064a76 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -419,7 +419,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
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
index b8a33c841846..7131cd1fb2ad 100644
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
@@ -146,7 +146,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 3beaf9e84cf2..44b524136f95 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -504,7 +504,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -734,7 +734,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -777,7 +777,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -854,7 +856,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 0a2e7f228391..40203255ed88 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -308,7 +308,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -320,7 +320,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
-- 
2.36.1

