Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4015330B6
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiEXSzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiEXSzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:55:25 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD175717A
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:55:24 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHVfNP012370;
        Tue, 24 May 2022 11:54:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=MBXp0LvgNWFEKUW8rPkPK0b+qwLHGw1WxgxgbNJQXdI=;
 b=FNuzLShHP/WXwQl5chh4nhKEKngkfE0WlXdQ8tqimYaBL7GNFfCSZ1fbSgD4MBChhkoc
 JKjArdD7zKWoW4M4hRJbVX3S7He6nQgyulPJNjH+cAzU29+ZinXD5Qa7MehAV2wqYYWf
 KHmJEQ1Lu8T1Y1R1XaaRKaXXFL8bi1FF7UYe38sKoHRjeKT+1Rl1K9RNzbbCVtWGsEXd
 05pBDvSXHZgBfbCdNmg18IvBZnIDFB4/yEZp9odo/bDdyw+ukfBxF/hMMuhkHF7rmGMz
 O3FO+p2ACNFrrOF1VFsPohKVJHWk2ig+HtpzzJ3rXDT7qfpuKaRN0dgr34CVGibfNsLO CQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93u9r1w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 11:54:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyJ9kHmKGoUrZc3k63mQdTGkfi3NuclUmkpKeFP9o3a4wicqdJ4qxqd6M7shBmQnp9ny7O8rmzYyUcW3lg+R9tO+Pd7szOkDgEJPAjmO1HHR/Crc5bKtrfBE8iIRqPRQ0/54QK8+RbvGWv8RtRbobCsyriNJqaaqECapNq3tyzFLpMrLh7FJ4VTUYgP7gQRYVFi0Hr7oETwADe/Sdb26I4tRubo0fynaZNdgwQaM4RMDPcsK0vMIvR7XJXVbLxnF0NElNV/m2mB1j1oncHBgSZ5AFfyyvRjXTkqGv0a7GM//XiCqxUlJOBGLaAVE5710S5b0jgy4zqAKrMek1kxBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBXp0LvgNWFEKUW8rPkPK0b+qwLHGw1WxgxgbNJQXdI=;
 b=n/11V6iWJDeyLqOoxIwnD4rLEUi7ANlbljQ8s1ud+pqkEEYb5ula6q6ChmYPy4XpaKk9iGfCeZug9TYOvNoF/vR5gWeH7RvZ20r4X/LmfSmEVWHwEKT3nMQt+ywRoTZtiM0c7PLqvMuiqdWu4Ly207KLqegUKsybWjbyesc9z72I8fwEjJQXKk1g1AqrQhARWg611Y17qnMJx1LTFvdeYI+2T+sPwLLV2WJvL0l63ZahIaNfdNAoCiWM7q50RA+6O7W/fh3IefXjQaE7oSadHg/PBCifqoQyw1a++EohphDr/+d7Yy6VOXg1TeVWfkdxRjXUyuy7/AYstGZmRPCHTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by MN2PR11MB4613.namprd11.prod.outlook.com (2603:10b6:208:26d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 24 May
 2022 18:54:39 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:54:39 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 5.10 1/2] tcp: change source port randomizarion at connect() time
Date:   Tue, 24 May 2022 21:54:22 +0300
Message-Id: <20220524185423.23312-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0155.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::48) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7eec309-5d86-40f2-663f-08da3db6dad5
X-MS-TrafficTypeDiagnostic: MN2PR11MB4613:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB4613A70830C8F85B04D69322F2D79@MN2PR11MB4613.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HOx6AK3FQ7sH5iFgVpI1717l+YDAZEMSvwCIiO9p1FJOOEn3segR7uhc+VRirI8b9J5H0tmxLZEZXePVWi4QjV1qQomPXm3znEiFGWKe719guUNVF2HOf22V0a/XPzZohpCgoE5vLcXTO7pDxx6MwKeLNCEYLliH/1XtuhjizpAo/nKMJ1TgxMmu2ZsmfdCRkGR3JoUZoL5NIZhj8GMFS+29sWPnyqGHX6prLPRhZL0irwZK/mapT6WrI0xkLo6PAOZ5llodSF59flS0mLYRj1NE2LxMnF/3gQpoTmDx0cUmHy+8c9xBc1hbBXA775foMcaEeeL4dV0VH2QX7zi1KG8x767Aox1kwKi+gng/Tlj045B+WK+dNEqjV3m4OqrIqFlFnRfH8q2/ItlAehqD6sKjsnkkNgyR3jrgefoDKStEYoiYVu+RG4WDHge3Yrgsp3kn0VhHEfN9ATYRw+TYzvsvyNySDfA2GK6d8gqRR5cTWA4I7KsZ30g0+/AGjV5IoC5MuW0+/Uf85G1v/qWC+n6n8bH5tWLpKJkkTQAf5/LgjpjBAJdR4vQTlkWQcMcqSBhFVQ0S2OkXtq8HEqEFsIriVyQjTG50xmynRbRaPxu5gLVTjh5wHmwIv7YED3F4G4AH7gl8dZdtQWVZiDQe/8xEqTtOxNNDHlctspZ6hYTQRWZ0YYDC4S0+Mc8o8QdttxCF9cowHFedRWVYFuaUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(83380400001)(38100700002)(8676002)(52116002)(316002)(4326008)(38350700002)(1076003)(66946007)(66476007)(66556008)(186003)(86362001)(2616005)(6506007)(7416002)(6512007)(508600001)(26005)(66574015)(6486002)(44832011)(6666004)(2906002)(8936002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dt7QZ6G3VvHTY17jfMsbrhB4YBYg9/2kQU5hOulFMRGnmFT9XhNYcHTFr7Im?=
 =?us-ascii?Q?OCJY9uM43MQo7GrGAUhax3fgxel8r0mOjbpPqiRUsL/sAiTaZB09qDGUjA/4?=
 =?us-ascii?Q?m8/+fDsF1R0baQ1FDCFE1bekSieO5Z2YzyZuMraRKt6zmEkgIl8w5PhNP7zg?=
 =?us-ascii?Q?7v4DVTa7d4HzcBn0avufTredW7oe/Yeb9l7bogig11mXdgcKduaQ/3StaiSa?=
 =?us-ascii?Q?mO0122yunJdf1v03cgxM02y7xGXHAbw3AQ9yFrMKp1y+YpKalTMXRsQlC0hF?=
 =?us-ascii?Q?Lk7XAFQ+6v7fnLqBupRZ0Z0lT5JVWKWUamGuXippm5pE3z2LiDvL7YpRsSmc?=
 =?us-ascii?Q?zFh8OecTJT235EHf1tdAhnjaj2NjknhScqz38gmREzKnmD8JNlyivPFrPAb5?=
 =?us-ascii?Q?H3n0x7dY5r4Bd0Yg4Q2Vel8w/GT/rO5B5zKMrlRoJr8XUaTSKE4Qut/qCIx6?=
 =?us-ascii?Q?pZU5teYgASwHTVH7s7ah4N2ZRD2rZLvL0YpZ+2juqXA7ew77zxacbHby0f5w?=
 =?us-ascii?Q?zfAdGJ6dPtBkDb+IdNI7fAm3+CnUT6W6Ab5bLfyoiF4faKe5xvyI2heQBnkr?=
 =?us-ascii?Q?BJTjXIEU17fzWWtpTBKnto5QFc0/2tGH4WnhmLOM2IdaRzA4LURCIOlSvKTO?=
 =?us-ascii?Q?AR7yfkp9cMP9ZVvP9QmamNQ8T1pIPck1fB+RqyhoFnZkYhmRrE89kKbG1y7v?=
 =?us-ascii?Q?ePZkMl33e7sfop9hdbaYA+FGamu2IsxQXdYNTPCGrW/54re3aWohdWOdsrkc?=
 =?us-ascii?Q?+Be5vBChdmhD7z5fG5h/tQPV2/j8sTE6M4SkURB2KatlWhdNNl5JZzV4LWpJ?=
 =?us-ascii?Q?Pl69E1lo98J+dHLsRzzwzMSqMLxvaolzhFwJLiynXYXPW6dYsvbAYxNhFCGj?=
 =?us-ascii?Q?XCunzYn+nXjf9cgRQvqyf0a0jnHAiaTTGwTuJPJqn4m2CMgfFRxOlWDteglA?=
 =?us-ascii?Q?TyI1my1oDLKm7Sh0V0Ht8m+cKMuwQ6fB3FGU/PLPZXmgcnIspQzwSLsCcfgY?=
 =?us-ascii?Q?m69tDZBsBKFojGTzBwwx6PO4rN1tIWA+NB9G8PewqdJP28e2IBBz7kwYIz/G?=
 =?us-ascii?Q?TCYhOFXOOzchWq/TYauUFF1w2ONPKGYjBLP9ExD8bXNhLArrOGsa7ppx3wwA?=
 =?us-ascii?Q?3+Df2K9W0cp+/wINkAbgBFIx4rhR80Kie7jVBJKN2ZnoptsNcjE0yc9YQ3a3?=
 =?us-ascii?Q?0u3IQ/xMOmjELKAf4FUPMBKiyAdCf0tv74QUaXQqT3sGsVwtzEHDsVrtAoPY?=
 =?us-ascii?Q?HAMyVPBXJv3Pwme5W49qtNMSQ2AV8IhWxMs/JkSslrPq2bbsVEW6P/T06H4P?=
 =?us-ascii?Q?IbtuWps9tcgOq0JYaYkPFgRvmAJp/fTjwvxsn1/bWljiJefOTaujR7UULwG4?=
 =?us-ascii?Q?ap5Y/dzPh3qC6cbHCCBIEnWcJen0f6CQgxM1jdSSwhfIDMYboN6432Xos4zy?=
 =?us-ascii?Q?Kr1TEi+KxMXQ/fYi6+3zBMM6s71u+alfCUbFO1HqKbuL+78bOTc0PazTWdEF?=
 =?us-ascii?Q?d+idWg7A3+2/E0xqV/OU79vR/tqp4k387zUsV0GGJwterAMiIixvT00VZq5K?=
 =?us-ascii?Q?I8Zv783NOoMHFBcmtuDu0Tn7QpF70Ppx0ZEywheAxn8ox/+vm5mmaThXE31e?=
 =?us-ascii?Q?c+BJGx+uk82ODibXlVZAgQmU7CxHqlXEA0tUl81rxxyn3EmBBRX9CNTze/iy?=
 =?us-ascii?Q?HmE4k9+LFcxHzm1ToLHIleGqmZ6rbuc+kOtESHFPILBWSrfm8JVXdzoQSrfo?=
 =?us-ascii?Q?WNe53AJ5zR2wi9jOcqky1p/YnYmMLho=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7eec309-5d86-40f2-663f-08da3db6dad5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:54:39.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHg7qQImQFk1KXZMI23VBlsT0e4bQFfkMRBRl0s/5LbfoXaORH6gVyfSyJ3ib28aoECzdGWG9i50xJhALAkneR15VGEYtOdp1d8lJ9WcnK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4613
X-Proofpoint-GUID: V0Y_OwqjxHG2fhTsWhW6sT7WMGty_Md7
X-Proofpoint-ORIG-GUID: V0Y_OwqjxHG2fhTsWhW6sT7WMGty_Md7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

From: Eric Dumazet <edumazet@google.com>

commit 190cc82489f46f9d88e73c81a47e14f80a791e1a upstream

RFC 6056 (Recommendations for Transport-Protocol Port Randomization)
provides good summary of why source selection needs extra care.

David Dworken reminded us that linux implements Algorithm 3
as described in RFC 6056 3.3.3

Quoting David :
   In the context of the web, this creates an interesting info leak where
   websites can count how many TCP connections a user's computer is
   establishing over time. For example, this allows a website to count
   exactly how many subresources a third party website loaded.
   This also allows:
   - Distinguishing between different users behind a VPN based on
       distinct source port ranges.
   - Tracking users over time across multiple networks.
   - Covert communication channels between different browsers/browser
       profiles running on the same computer
   - Tracking what applications are running on a computer based on
       the pattern of how fast source ports are getting incremented.

Section 3.3.4 describes an enhancement, that reduces
attackers ability to use the basic information currently
stored into the shared 'u32 hint'.

This change also decreases collision rate when
multiple applications need to connect() to
different destinations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Dworken <ddworken@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 net/ipv4/inet_hashtables.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 915b8e1bd9ef..3beaf9e84cf2 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -722,6 +722,17 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
+/* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
+ * Note that we use 32bit integers (vs RFC 'short integers')
+ * because 2^16 is not a multiple of num_ephemeral and this
+ * property might be used by clever attacker.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
+ * we use 256 instead to really give more isolation and
+ * privacy, this only consumes 1 KB of kernel memory.
+ */
+#define INET_TABLE_PERTURB_SHIFT 8
+static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		struct sock *sk, u32 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
@@ -735,8 +746,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
 	int l3mdev;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -763,7 +774,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	offset = (hint + port_offset) % remaining;
+	net_get_random_once(table_perturb, sizeof(table_perturb));
+	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+
+	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -817,7 +831,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
-- 
2.36.1

