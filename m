Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934D95330C6
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbiEXS6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiEXS4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:56:02 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EDB91
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:56:00 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHWfDe005307;
        Tue, 24 May 2022 18:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=ouon1bs/3QsSx2rwytKJlifVHi1xHRB73upyLuNR2Vw=;
 b=NkDcS3xSSixpo0t0VHx0HBLgAC3CLg6NVa+8Hj86b5XnxzDRtCz4wrS/EgUmWr18lTqX
 QQc698i+TP8y55bzkwiFX4jXtOHKmlhzR2DBuaKB/AOik52m6RRK8HSZN3dsdNNa1ojW
 KUEounMLpcQ5AOt4zjLSS7spe+EA8c1czd3bUxrF1qwjJRxjeV1bTy4qI9CRrADJr7ZI
 TLBcDBKMOPdKglscIY6qj2Nj17yPnXFocMqt35Dfxhwc9zKPM2PZHIGKOg4V7ex/1OcP
 fZ/bfr+6+XTc9XAZdNY6lqpYWXmcjhpXsgjFlBkr2aJlaBWMs8bjj+UQMWpf+kqUg4cw lQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93ub01xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7ZlBMAvQKjutgiNOaZp3mGJFi5gT2f+LmsG3/uuQx8urGhJossB20OM/EvXNah2sgeB3U8w7/HbOaT1vWhhuzje30iJW/tBHENs+H5PMICJK0hQ+pfMylXVhCG2MgN3q7C5NdTtKTLGxM4SehIsnEPsNSTujPs9VicI3BDK+a6ofMlFbpuWeW2z2gkY76rVD2B1zjDRi+wPcw5WIipoTYlX5d4dOD98bVZrcvvxXgrsmq3iRYKUNwG0nTQnH5QL2Ud5WRD0SJJ+7lkwL5BDwV9n+BVzBI8YIZkyf/HYh2fi4TXQ2T/RD9d0bd3bFBjpnOzPQ545YEZSc+8+hBGoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ouon1bs/3QsSx2rwytKJlifVHi1xHRB73upyLuNR2Vw=;
 b=auazj5QIZN90I2RTzUxJxtElI7nkmkkRElNLPGBr2421szWILpR/2kjG/V0gJwZMAepr9BvU3L8wWhtulAv08+1V1SRHrWPAZqcRXhVNRDJlN/L1sMepV5MaBkAOVv8DZVYhCAYzvbaU3l3+E4wNzRfwDNv4fi+74Mhlu6oiOMjflDMdojXmSyaTgLzsyw00ejD3siiYCKBXoI9oE5UUWyR9ZceUV67kI5e5jAP+5bMvXoQgRxw8KVTKQi/eil6xwzdyaRlJqEP57PKCUwbSERyr1EE53JiEwcn5388NsrI1fdGG/7DGrgQ+uGxEAmFvf6nTlcKxyN6/mIRoxWme8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DM5PR11MB1819.namprd11.prod.outlook.com (2603:10b6:3:10a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:55:32 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:55:32 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 4.19 2/2] secure_seq: use the 64 bits of the siphash for port offset calculation
Date:   Tue, 24 May 2022 21:55:15 +0300
Message-Id: <20220524185515.23617-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524185515.23617-1-stefan.ghinea@windriver.com>
References: <20220524185515.23617-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0072.eurprd09.prod.outlook.com
 (2603:10a6:802:29::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70db2135-5cb8-4154-6ed8-08da3db6fa4b
X-MS-TrafficTypeDiagnostic: DM5PR11MB1819:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB18197CFC6E4805D6DABFC6D3F2D79@DM5PR11MB1819.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZN7SXtfvl+cWH0js5zhz3Jf/+LCWGWjzUOfCiNCsnOISQQweOVYY2RZ2xZ8oEpqLKiEXg+kG53CN1jALDY0R6JKFucMcgRGeelUA38txduxjoKVf6mo+Z5DlEYkjoOH278SuRtvlI7f84+qn43xNlzNhAzY8Kyqldisftruknt+AbE4RFUtCcni6MWmAux8vaxA3j3PTWWJ93/V2u+Wi3sWZZSc14ioR/dL8XagVrKu5ifbSKFdpho3/aTOZFLba8F9pZ5kmGtMZoWcuYcIhCs/nKinlnLenNxQDuxg/H0sjnEUSL1D1gE5pshOyTTDB5WYEzaMfq7h7J6cyVTdIvekMjNrBkauvw1C/qyY9Dk50qmWfaXYTJ5iMK0SK4OypRnGHo2jlg9FD/svQKE0QHS6lmxWEGxl0Yxab3L6VQo5SoII5195NO2ZX5eS62IFv3vGG9GTDo3mP7RSaY+lrkADkm5pGdCJ13xRokZ0sx26jkRVkXt8KzVAs5fioeFdjTJ/YCUkFUrVMUXnq7t5coEE7Pht7yFTWYkhYJcfs8T5SDs0eO0Suwn6s7G6b4gKbLltYWBBfMHqlfus2+Bmr5lH3ugQq0O2NDYTdaD+MclgbR47bJDMnqZn6UAuuzJ+AtLk3nT5L65q9YCOPNBSRY3uV78LBK2hHgNSp9joYzdVKboNJFiYl2v7gWtM3IQNPZfi4cTTTWqx5b/dG6qa1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6486002)(52116002)(83380400001)(86362001)(316002)(6916009)(508600001)(6512007)(6666004)(26005)(6506007)(38100700002)(1076003)(36756003)(38350700002)(44832011)(2906002)(5660300002)(66476007)(66556008)(66946007)(8936002)(7416002)(8676002)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZVaN8Xuj19vnUNJ4xsI3BEv9nwFU4o/lhS8j//sV1Dz1WwtL+Xgnf9ftXSEP?=
 =?us-ascii?Q?0TCCU6Rr8QyklMJPsRdUdCtoyVaDYtRglEfoImRWWKH0FSQUnXSvljfLoHUm?=
 =?us-ascii?Q?ym5lbcHrR9pqdRFODW2LSSk8n8jb6nbelOi/YKS/YXIwbgaDTYHBcnuCoITJ?=
 =?us-ascii?Q?keWZVKa8T3UVitKuGc2Xr5cYZ5EUi+55wtfXQoE/s5y/OmVbmFMXJ8zVPzfx?=
 =?us-ascii?Q?eGIq9fdhbFmH0SRFy9YYqyfLpngrG84Knk/M2qxKuHb+qJ9fTLDi70+KYpgw?=
 =?us-ascii?Q?hdqETLHQB91Kn5prxxEiVwST5PXw5DsPIjQ3QyXd4FY1wa2YytBLT2MKmg8P?=
 =?us-ascii?Q?IxYhaZOisDPbC+YLR+kP09PT8bmFSuLu9Nv0VE+/kJLGTfRU5JN52yOTXo89?=
 =?us-ascii?Q?nO3syOgC4MnKEcdkMpilS/iCwepwy2n4sGb5+xvhhGBGNRBHbrjKih0i3FRb?=
 =?us-ascii?Q?6o+H3yHJrqYboeQ5cC+fkSZD19rpNrbHBo99vjA3HW4D9MffiIYA8Ra5GnHA?=
 =?us-ascii?Q?9d6tVWezVzNUf7nMHHle5Rl3rLeEsT/8II7pvB89JHZcqG7byPHpjrw93Ma0?=
 =?us-ascii?Q?mcANwD1+vYYT3KJveyLMCSVbCOw0KDqfKnH1OCOS7ca4DNTDUaty4QaetSiO?=
 =?us-ascii?Q?3FnOqte0ggJNYlUvNUYZoHQ8rBUdUo0feE6XVSYU5fg4x418LdG5t/3vQOYd?=
 =?us-ascii?Q?8ZBoE/Wr2fqhzpKdP4NgtKVu27eMCIeTU6yORyVPitgrQsOLCdEYZLOx8rmf?=
 =?us-ascii?Q?/eqMdcLp3Fi7VbUGt9at2bDOkcAuo0tZF8XH8mR5Kg/MfXWGPC2JtiWRgJ3E?=
 =?us-ascii?Q?joUXqWYdA+7gOi89PTOwSQeaAhCBpRabkQc/Mk5uwPYi0DEluezTaN/qEdqR?=
 =?us-ascii?Q?/kd0O2smK37+CMFqULGih1/cA0BhcPQ9NnFdlyAk3pc5BMT2+tTlzri/5hHg?=
 =?us-ascii?Q?3CXCtgwZX0LAyJz4C2Vz5vGXR/OndrByc7E787qNvqtjd/7yis33lAJLW2H3?=
 =?us-ascii?Q?+ezmYmQV87RGYY1cI2XNAEXMytad2pOP3SRdlwRQn9UsAAaeqEvD+sFuHP0A?=
 =?us-ascii?Q?iXud8vmbpzmNBVwXRXNtvSShqiXxiwWu+qEeC/PVsGxpjrRi0j64flAL7Lnw?=
 =?us-ascii?Q?AA3HPpAlISEcXTadq/FbCHaaoyVA+uqJ7fNSPoc0WiCa9+WiXZ7yUF6nWHB0?=
 =?us-ascii?Q?qVWgNwGus4AK8hCRZFvUz87RX/ccm3jlJfKnnjukEx1VRXkaB4r8DI8mF2Sn?=
 =?us-ascii?Q?7x3ORYUpJi06/XzY1LtfZ8yCl49529Pu3DKkSnC1e3zrAr48xsxD8KL1Jamy?=
 =?us-ascii?Q?lScSYgFqxtd47zRS0l9ceNX6VKjEg1138FoYJz7P/mnaMw7hyAvqBPhlUTTf?=
 =?us-ascii?Q?90/r9k91oBIIfr0xwca0y7lovBQZjCPCajOd/MBE1l5ea8TgkXTV/u0CFeB6?=
 =?us-ascii?Q?+BkkjndSzQn5DL7SBVi6bbuwz2z1xfjyOMqtpJ83/UCMAkQixpUh1Ddeojbg?=
 =?us-ascii?Q?hvSa5iOvyNiR/MRbZQ6gKezsm9nMtsgcdIY38i4hE2HPJI/Wb8/+nAnZOpRB?=
 =?us-ascii?Q?/KHhaSYd00pGQF9WrkKr5Lf0792XkF+MTZQFXOrf7vDvOzyzHB9sIwldLcx1?=
 =?us-ascii?Q?uScB9qcrPA20pX3Nyhb9SSpx+KK17u3IauYUrEd900eZ9HXY8n1wAg8hhww6?=
 =?us-ascii?Q?V4JFfcqxs95gVAv3b19w9wG0wJzAMHD4IKXuwRGuVAwWnutlXz4KtgbKrpkT?=
 =?us-ascii?Q?9i6gKof74eiJfhwYlC64qMTasuOYenUmIS1hTC9ldPh2Yd0geSC/?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70db2135-5cb8-4154-6ed8-08da3db6fa4b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:55:32.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDbKcoonevcdwvfgm3CEOFoovi9aiyGyy32n2Cs4nPh3M540UEh8QBPZmm77sgJDDmUI1mt8w8FZggBeCcKVkJqlo3vVYJJOEyjFoINRFqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1819
X-Proofpoint-ORIG-GUID: XKVhB1AR6067X_KwhORXTZpB9WNsP6wk
X-Proofpoint-GUID: XKVhB1AR6067X_KwhORXTZpB9WNsP6wk
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
index fa5fe23ca6aa..2d04f3e06de1 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -407,7 +407,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
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
index 3a8128341e6a..6fd25279bee9 100644
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
index da9537ab3b98..0a8aec3f37cc 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -507,7 +507,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -726,7 +726,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -766,7 +766,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
+	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset %= remaining;
+
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -842,7 +844,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index d9e2575dad94..d8391921363f 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -311,7 +311,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -323,7 +323,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
-- 
2.36.1

