Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958EB43FEC1
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhJ2O5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:57:13 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:45006 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhJ2O5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:57:12 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TE7Yvj004274
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:54:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=4yRf0ClJo9nF5KsSYjgiDdbQ8067s95UWFboLJodCJE=;
 b=VAmqS2vDYWjHDgoM5x2iMurBGoQ9LapulJrEJNUUryobZWKnO/vBXHt8sKfmoGcSEJBY
 gc1EpCCx9o8c08W8K3vf11foiDeXqj/jCfFLMVvFIimDn3s4MqXCz3UsQi4e15HnL+9U
 tuUNqbvGc8jAOPVIlSSdhIDnL2jEKG9xnV2WsUMjvDNnOAChVzy2RmEcYVGjtV1RXWX5
 gpYyuEN+UxrRc9PcUHWgJnISNzxKivd3G1Z+5eRZCdmzfRGE/g4kTikiQaK48+ywoLWO
 tkirDlz+SVTt2TAjKielD6SyHN5X75KZvE1Hbww4qD/leijZh6ZvMuY/JVqL8WIL8Pa6 NQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3c0jekr128-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:54:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnWbArLDlG99LU/fh6T9XBYzr9CMWjVMAVIY4yl8PvcGlAcbFqQiGeSCQQbzJgVtfd1qgQr3JKAAYF99vARjofYXWSWsWWKve/upQvzxgdIoQI9X+8RCpcpXnRi3ohWKQW8xodzQGjF+hQcSJ4PwP5/Sx8gmXGShoegVHkS0XpIgO+qGZItMIHUjZT4iq9mvXN4M3+/oTJ9NNJjBV7LZPS+Xult13B634vn0G34KXk5JuLPP40f8tJUrMBNtgkqmIVSGOzUr+vBPCF+/Yo+X0LuoTuAdcx2MWWPfTrVZHwj7K5ADDhWM6flVvzXIBOOO3E/Geocqt3X/pb9jKph/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yRf0ClJo9nF5KsSYjgiDdbQ8067s95UWFboLJodCJE=;
 b=cA1kRWu2OTCoYdGNVAI9gJc5bWrRMNqoKTm69gimdOY0wsLoVC7n/lfIf6qy1TgsTupvBHN0+moeAA5NZR4L4EaE8etfD7FzSgLm+M7ktaHkc8f3nSc/GKxCT/BobBxN+GZhJeXu2NHP9ennVGTj4eEB700av8dkpcrkv7jjetQglH9SrryxbvdvcsEBD6Yom1102ePLWCQg6WDsdcR2X8ug+3Q2OJ48DGJVYB7o7L33edBYpztkBzxMrE+U1txjqP9q9s1xiFZJVftOypa/5WwN3oIBt6FBEkAEf8jIebAKc7C4Gxq3a4R+CQlt2+Ahzid3txApMQFBAFF6uWhaSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2618.namprd11.prod.outlook.com (2603:10b6:5:c0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 14:54:41 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::6daa:43c4:6ef3:a6d3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::6daa:43c4:6ef3:a6d3%3]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 14:54:41 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 1/1] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Fri, 29 Oct 2021 17:54:18 +0300
Message-Id: <20211029145418.1888144-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029145418.1888144-1-ovidiu.panait@windriver.com>
References: <20211029145418.1888144-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0008.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0302CA0008.eurprd03.prod.outlook.com (2603:10a6:800:e9::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 14:54:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfdb9d38-bf33-4b0f-e0fa-08d99aec09ab
X-MS-TrafficTypeDiagnostic: DM6PR11MB2618:
X-Microsoft-Antispam-PRVS: <DM6PR11MB261802DBE42F7C5007D5FA38FE879@DM6PR11MB2618.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RMPNChHb8ecBVY6U3FXXT5A9upJyOkyUPkzoGcV4Y2cNCWBO9D5zCqjpuQ1VianlroCTuq3atNyGcrKTrNzdwXUSCHRHd81dXj2Vqu+G/R+kRfEpqWypCMOJ3uD3jZX3vc8KtcnbMaOZl2p3aW9dvecBIs8v8MvRxrQgoisE5W9pXrgxfOzyB15tGEAay8v9AFsVgiuHp1+gk78LyYoQwH6tr2VeAaGVQz8Rwwv1n1UFURXfz8Mn098M/DCUzFIBSJIvAQErhgkfWSSmmuFBVf1DY7ZjVMCvR0legIJBiOyHkKNYTHb1Xrf33+ueYrEAuqe3qlmgx5lhe9vzK5/beH+5/S9CptoxCfQ6pIlzY04az8mqhNqcj8qDHhKKhmD6o7MXlgoZIQTab5D8i8RhV0hOjCELcxMKv6yZ0Bl1mo57e5d2VySEvsOFPEQytwWCbbD7Eo8TlxXI/cJaCggwBfvGq3cDZuDoll2Rv/qSeTeGgOvT6MfQP0KP9Ar1U69Pm7S8fGyrN1qgj+EnaQVjVq6Pu1yoFQWoVUoZVMmE/WmYfaQaKTnP1GtNxScLD6fyKuxr1yfpl9slm1fCd50PUm9zDUMInAPGa9mNgiq6EN67h928SxHxKCEtZOjgEDMAR33xrixp8l/MnWUnJcYeXvJ9JrAjF2liz4itVf5n0ffyqQ4EjtibWnV0hoqYINoBHJu7UZ7bKHinPKypXTrW4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66946007)(2616005)(66476007)(66556008)(2906002)(956004)(6486002)(5660300002)(316002)(6666004)(6512007)(1076003)(8676002)(44832011)(38100700002)(6916009)(36756003)(8936002)(83380400001)(86362001)(6506007)(26005)(186003)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ylBVtRnT5tNc2XtV/3fBVc5Gydic0CWVyLQYoej6w5oYAg134oO+zwnjt/nE?=
 =?us-ascii?Q?LvA6MG5/zLvecrLrusSHWtJ7JGzY6MQjyAEQsxjkF+xw+XCMJTPhJsN8wro9?=
 =?us-ascii?Q?/VGQm7sUSuS65/d1ax4gJi4DhhvmMIpZA4LI9vGSwrfHx69C24o3Jnx3rfk0?=
 =?us-ascii?Q?g6pw90RhNg2Xnq21zgcuayjXTzMhqHLLA0eYnDiV4TBNOa6YnBtwrjIf10Xp?=
 =?us-ascii?Q?LUmBG5wqr+WTzMcqxxWXynWOO6UXJno68N0Ngk8wwY7o9gkdKenWEPzm4pIy?=
 =?us-ascii?Q?qjAMoUvWB2YaNSpSsbRYNfgjmg8IdPx9kUu0x3jEW1JkS7j/iIip4L90YP8L?=
 =?us-ascii?Q?Xk99AhK73eVwseAjei7wLpYv7s5+VGzkB/r5WRdFmSO1/+HnX5J7PxjaVYmf?=
 =?us-ascii?Q?YBW2P16Mmjfw+w7Pa9qymYe1TATgAzeaCwhaAq7zmHTAoTIBYxLtC+BRs1v7?=
 =?us-ascii?Q?mVzISTnYeOAQBfELesCXFT+DBNe4KwnTAAQiBsxBrh9Md3+spt6dqPsQFbnX?=
 =?us-ascii?Q?JTgg9slZMvPLAdMCw8kmOetZiaoV9MLAmeUPmB5b+DZqY7p1o7sIwZIF6BLH?=
 =?us-ascii?Q?fPNWF1hJKQQuAYggVLvAAKoV7Pucj5gTLNP6sxmb/Mzbo0oV2SEUzg/AYhw0?=
 =?us-ascii?Q?4w6x+8N8Zv6RdKvo+7+oevjJDuirZVxji9ha9pljCN29PGXzMczYM/grYxgR?=
 =?us-ascii?Q?a5shiHDCMKZAhGU72b3skdbfbFK7OWvniKz+d9CwlfFjVnTtJ/LTZb1aom8Z?=
 =?us-ascii?Q?O7f2x2EDLPy/lRXddhIojMqocnsBv7/ruQwA3/m9CBPI0cTnoCk0dNWZDnMv?=
 =?us-ascii?Q?gQVnlJrU0YnLGZpCqkYxBVrdCS8oEj6bV39ZP4J3UA8cNb+q/dR2LpqESlFJ?=
 =?us-ascii?Q?pRDDr4PRPDTnhRHbDeFq6PlQTCrzM1ARftjvFVSvZAjcrbNCqo6xabbipO7C?=
 =?us-ascii?Q?9XpBrJGtFrdOIe34cbrqPRcy0hb5WsqPdoQf94vOT7qMMzdlWJYK+RKkEVrJ?=
 =?us-ascii?Q?IInnp+MKZC7NOrdpLe7n3oN5r0lWOW5XT3DVQ9Fjvunrh5KljmagnZm5GVre?=
 =?us-ascii?Q?cBfNPwGPvbsbKJOc5yXw8eCsjr8azjocCJ1C5+iArpUquYMoASuFZ8Eqlkh+?=
 =?us-ascii?Q?YdXl9M8ZWdndEzup5oJPXvZhOADJfheacIS2G6/LvYwXZXsBiTpxM0ZTK4WV?=
 =?us-ascii?Q?rBLpyqC5mfj/pcc/58wJU/Zb/YlwovF92UhS1LamqQcbSmb7e2bk+rrEWwVW?=
 =?us-ascii?Q?vWu7APChjeYVk1LavLlWkQAAd76hRGiF8F0y5gjzSjAzn6Yypcf0yoYmOdui?=
 =?us-ascii?Q?RMbNW466e82NC44k4Mq1Eq488RCL1L7uKVfxokXajN6PD2t14O3kL26ZdT9U?=
 =?us-ascii?Q?qiEOI5ySPxiNkLbO7xK654hc4JkwXTTgWwzbVTODN6PF6SvhReHSNgslK1+b?=
 =?us-ascii?Q?8cSVzxd12xtbwF4xfiWsR6aw2+xT07xB860wo/EVj+TZ45YquR6AbKk4Y72t?=
 =?us-ascii?Q?lE7d+7hUe1iRVTxfi8SXMqz8bn/hi1vKa60DBfUOmjlqquWexWq/OCAKvhqZ?=
 =?us-ascii?Q?8uxb96xjVYYmbxnC4dwwq5F9oRYXYaAf3NSWXSAJiEk9in2ta0aqeeBxmSZN?=
 =?us-ascii?Q?x1jxHc8g1Igp+fgY/SKYAyLg2s8n0iwQzvzH2pSVHDWMRGPlIe4Jw5UNpUew?=
 =?us-ascii?Q?Ue5czA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfdb9d38-bf33-4b0f-e0fa-08d99aec09ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 14:54:41.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxwYhSrTdVOxAojj02PtwNwjx2zQoe5q2mYR8keJvt+m8tbfeK0fW17cVqbHYrC798iJBMDHNtNfniO90fXrhqV6qK6pvJHzjr22ZLAtRXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2618
X-Proofpoint-ORIG-GUID: fVAvhIS4HzVEerOc4Genmuf6ffBT_VU3
X-Proofpoint-GUID: fVAvhIS4HzVEerOc4Genmuf6ffBT_VU3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=452 bulkscore=0 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290085
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
[OP: adjusted context for 4.14 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d67d424be919..34cf572cc5dc 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -640,14 +640,14 @@ static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
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

