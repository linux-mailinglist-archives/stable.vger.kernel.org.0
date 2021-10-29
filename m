Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5898343F827
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 09:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhJ2Hx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 03:53:26 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:42156 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232236AbhJ2HxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 03:53:25 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T7d6kW009489;
        Fri, 29 Oct 2021 00:50:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=iTdPtfA5yOTqmSf49dRWyTNABMZJPhbUFD0O4bCzgBE=;
 b=IbgYVPLZF1mO6F0osw046Oh25aoNwhCZjJJa83cKcRcGTQ+y0SIFetZDVECSK2cOpwTo
 Mn6e39vUcAOOOM8tFBCwkbtGaOhIghuZ+Jw1ODjLVGBs/WCj6h+Bj5RGfSBuOF1I/b9A
 0D/sEP0vL/1/ujtOre9wQ0Ic68GjdZ4mzeKadDMiC4wo+g5WOhDwXPIimA5h6hGGHD1W
 Rpic+nFrknt1kXkiX1hb3D7VgFEQ3ADLof7ii57121IJFjFaqpdBItGIxq8mswCd9w+p
 /olPDZ3Ac/nO3Pp73wux0kiXhZDU7pPFiC1z4FltDLiGM325zICQ2ptvHdAFbo6ndeTV eA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bycjw9gn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 00:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ig6p0//FPg+E2AvV53godQ7yEo0m1AwjSAPfUqe9UHka/ekX6nERQtPrFJ/eb/q8QsUvvkqZ/McElovknjXiZH3W9M/xG6wjmNmCzXu0WkdJA0abxbjyUJ+/uc/Z3pUNZOrj5UrHJ07uj7x4OTTJGnsf2CDtRJ7q/VjO+CTe3H6OTJKzjRPWRt28PbYYWzurwBqRtoduyZn48AJcK1I8jYxIqcafGHZj6cbQkyVPW+aVQ45B+mjoIxYIGC8zQpRpuBVFpximH0JP5CdDCeszHqrLf12gSzfCbVVnIbNVZZxc1wla1Pqx54A4yz+xij7fgD/jgR6WisEGbpfFMqxHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTdPtfA5yOTqmSf49dRWyTNABMZJPhbUFD0O4bCzgBE=;
 b=mL5rF0c0CpZr4NDDozekxvv8xwMdCxSk7X7QZ7ODe7nYdD821YSemIRnNSQCeoX20u31zdB1ZlC9cRwUeX3Qaz5lC6WvOK0wLWsrd0hbeS4oXVA3Uwx1eg3AizMt6+PyFCxnXbG8iqa0GVknRZlDDO8hIbtGM/jDno2ABdJbLWzipMVQl8cWcB1u41x2/3MSEQkqQ02AomWAXVwOHb4h9Gftox5SIizZyLdHwJwuFkvjn+i2XnGI7jx1ZXeNuA/ZZKCT/gxQ4gN0aTzNL+egyy1Ro6VKG138y6ka50hnMp6lgKiHnpw/8sKrUMvkdK22E8fLeanKesQGaB593b2Wjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN6PR11MB2035.namprd11.prod.outlook.com (2603:10b6:404:3c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 07:50:53 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916%7]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 07:50:53 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 4.19 1/3] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Fri, 29 Oct 2021 10:50:25 +0300
Message-Id: <20211029075027.1910142-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
References: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0093.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::19) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR08CA0093.eurprd08.prod.outlook.com (2603:10a6:800:d3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 07:50:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cf01fc5-a32f-413b-4a70-08d99ab0d562
X-MS-TrafficTypeDiagnostic: BN6PR11MB2035:
X-Microsoft-Antispam-PRVS: <BN6PR11MB2035FD67DB8EBB9AB866C7D3FE879@BN6PR11MB2035.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0OhDrgJwo4C3UbPh8luTFwfLKdTz0M7KqjiLT09TqHuHVaFXxhOsNDA9rwNKSiZLZtwtibka6xVfFrsHzgv2vNev3AHWqbVbabO46vTMERMwLkZoJ6RTkDPcDk6ISBdZ6dLzwi3V7YdgoLi2wu2yhI+22Q4WZmptKi/UsTb3c17CMEu+Ow75UNzFy8I/aFr75DSR/UdCAQSZdHtfkB8gc+CwmQjrYXl59B+3moftY/OW+LXrrpTkNUCOprm0JuVcg2cNII8JBiuhDJAh3CvrIoWnII1r4OlkpxcQivt0jDWiFzrmDPnk1aQkfoNceMH+7OSc2JXPB33oFiJs8xWsR6SzdIkm7khlzVbaYjuCTvSS98a01Jyw1HzDzooQUI9/R0IlaOA/5wa1J5RRgvK0OElZIxEh+BDHphiiDrnPPtO2VAS6N0WGldasOUinhltJ6oQfqFuntK4TDb4EO5w/rXApPZdkFYJZjrzDK2rysLmbaTAUJSE4I+ujgxlA72fTi6u+i1V+eQgBBa+/GfEcS25kQJfCYYv/1xUPP2B99iGVcqPf8sr8jmHYK6gEsQFseO1fAkzS3XQysTaaBhnkMs7wOhPSd6dimk9zcC9yK8ahNEg5juqKlDB7BrOC98UzFgsrJ0njTUHg+LLwuciTn4Oq14eHZeEDAqxDh6Veh2zYoTh0Di96cqEp3PucpMKsAd+6a3tCx8xFFe9yD6tODA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(8936002)(186003)(38350700002)(2906002)(6666004)(38100700002)(4326008)(2616005)(44832011)(956004)(6512007)(6916009)(52116002)(1076003)(508600001)(86362001)(316002)(6506007)(66946007)(36756003)(66476007)(26005)(66556008)(5660300002)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/uMMWpWWClY8VR45/F8+n2vZlXkMk6VCAfOTaspHDJxP8YtVOGqpOsjv5zNB?=
 =?us-ascii?Q?ikb5GJPB9kR9eXaY7xCHDbiPwNQkNZ1qa2DgtJrT0qzTZJdQ900qZUgng249?=
 =?us-ascii?Q?RaNeWDGBdU2I7vDs5rUeglcmB/UJ52yK5UXaYe0U5XVOgF5ott1ueWvrLZtb?=
 =?us-ascii?Q?X4C2p9gegqzs+WTw88ylBADPPMhinONYj6sv9Q7idWsz+3AvMV7K5xkn39lK?=
 =?us-ascii?Q?SOyS9Ho70c2IG1d8VeB1J+zEhBy1y/EuelpAKr/5VqgNRQzUxdO8lGUm6Enu?=
 =?us-ascii?Q?E8QVxcUkhU6KcT+oL1jPgkaeConXV6uG1OvkVmHkpRPMdeQUghXZNNUNFhWA?=
 =?us-ascii?Q?19PzL45hL8G0EtB1TmGiX1DQw0nHRJsLcH/EAnTmuWlokC6mYiYGs7DozOYk?=
 =?us-ascii?Q?Atgae9Vj3v8qrJO8x0YcY/djG5BsDXF+xkfzX7cPd6y/n7ryYA291pr1DTdO?=
 =?us-ascii?Q?taDA7asVxxUe/oK0meja//unam8LpGlLb/LfzORC37GIOeVonxuodvn8PES+?=
 =?us-ascii?Q?CqaMORVXWclIEoZz3+MVh7xwno7cj/ZaQdAt2aWck3RW5p1TBXh/mth25/IL?=
 =?us-ascii?Q?WEJdVaTDUkOF6Yvq12vmr+QVN8MyBiewuFBdhJHmnr6bDZVFBXszDvO1fVqE?=
 =?us-ascii?Q?msqC8I/ayRDJhHiZoiBgQZt7dsG6pRbu8m5N6mt0RBqjAKbjF4zhsX7+587Q?=
 =?us-ascii?Q?a2h44Oz636JKUJvNTzqXAv7HZMStb42Yo0HTfaZnGDVIP9mIRISYXxV2UgU5?=
 =?us-ascii?Q?wtiRSDbOjVMEJI7VPdrBVydjyaUP2zr0yWyBXQeuuntyuVBbn7/uFhEvmv38?=
 =?us-ascii?Q?NJevRE2UM9eCKw1yIj26IXF9rNbBXyMzMbVnv9SLDtGo/agVUHO2J7E1qhFj?=
 =?us-ascii?Q?R3DfGsJ73PHO7LHS3/cBHLdm+Lp0gpgCZ1zbvTi1zpRUFrt2f1Ou2sFtANxm?=
 =?us-ascii?Q?09YngkNdKGDCmgyGir8X/yRO08B3YS+zEmlvFMNCUwnZdu8V3G3Yb5tJCOo8?=
 =?us-ascii?Q?BeaeSQdV06FCRsaU1zJTj9HNTgdZVWQ3e75M8VcfPp5L+oQN9PFOeVwsq7nB?=
 =?us-ascii?Q?sPsmHmkgaC43gPS1u8oZyc7zo1whCM45jG9JC3IUAZAkDA6/4Dmf742aLkyD?=
 =?us-ascii?Q?U5wF9qg2R5S2FIy7OULeXwXeLHSstigao2+Lm5GOlW3bNqVbXti9XXsc3k4d?=
 =?us-ascii?Q?REdOWQFsjva0+1tx2h3CfmtiI57HOXxyCkrLG7aCWVy2FPQSMnCGeBcfQX0+?=
 =?us-ascii?Q?ZGd+SztgZLALP7iMr9k4nejV/tm4qQcHvm5HPGielX3VwEuV0KWPRSZ19YSl?=
 =?us-ascii?Q?c6DZ1Uq/YjT7DCqnrmIVJjm2s+lF8ZwcAuO0Sr8TSxAb3qODP1IFntxhAKDH?=
 =?us-ascii?Q?sGDxK8rfAPf6mSzk0LKUZjlFfeVQ6Jn4toFBsLDEvtxxaEgOQ6JRTlTpkCPb?=
 =?us-ascii?Q?9lsrmV13YhxPUtzI1jyqw+5ZezDqx04azS6+fdhFUQMcKtr+KeEIkG81cxqX?=
 =?us-ascii?Q?rLqgkMJdbrt2YqjPMx8X31PbIkWSx//DQbTL+iLE2f8K5KADemCDCH5nfm1J?=
 =?us-ascii?Q?Tizi1P6QoHecxIhzpSEYHV65QaF0YiO/A33O0Fk4Xs2yW+ejCgDAtM1nuQiv?=
 =?us-ascii?Q?4ayaeS4jBiGSthkVJYpE8HSWZ51JdKu3xUplTVH1gcpqzyDPRE1KLa+7OHO2?=
 =?us-ascii?Q?4AgaFg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf01fc5-a32f-413b-4a70-08d99ab0d562
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 07:50:53.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIC8Ynwp6cyFgs5mMJKXVU86DgNxvF+nmULXP8L7QmxN4IjJuloRhvGU0iD1tSGZQip4DUpy7r4MUsl3OU4sprCTweSpOIDyc3tDO+FXXJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2035
X-Proofpoint-ORIG-GUID: stzeFgnCmljMPzoi8KsFoOD6xOe-wkDv
X-Proofpoint-GUID: stzeFgnCmljMPzoi8KsFoOD6xOe-wkDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=517 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290044
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
[OP: adjusted context for 4.19 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 730a15fc497c..b41d4acc57e6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -625,14 +625,14 @@ static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
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

