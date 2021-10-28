Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FC543E8D6
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJ1TMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 15:12:06 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:46720 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230448AbhJ1TMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 15:12:05 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SETjC4019753
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 12:09:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=iTdPtfA5yOTqmSf49dRWyTNABMZJPhbUFD0O4bCzgBE=;
 b=X8dFX1pjCCZBYPixyNkI7HenfHml1PKRv2Mg9MYX+wj8O/TNLyjL8lSXyxZW3atb6WcF
 86Q5BTc6r//mJ4Nlaz/WdNrwqbR7LeT4qI++APzksbS/cCDgsXAPvu9OS0TtUyGFf+LW
 OhtJKGb2HRmHndiGg74DsLukVNjsr+9Y4z4oO+E9QMO5Pycx+fLeJ9tarq5/w3UU56YI
 ESHLwOY/G0g6XkAFrYD0iOY8b/ACyZ4dCL7r60qDvHfGCTvfK2qdDcm1u5JY7A9f2HQG
 cTSAcp2dW7rNSSS83b7qEgmI9ZisFKtft37jIzY62jfdY3wpitKs7En+X2llmb60bwpF Rw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3by9r1h56p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 12:09:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq5eG9oI8OFZQ1KRH5d1229TFFotItyfRtuTZ8tKHZSCRxFDqnW2TEEehYUeLwEhTZkooK8I3WTyyamGy3kGS7eVjtIFEEyQUuPlFwsNQBBDb76rlEEpFnWZeg/3yFrX2P6AcW29+8PfFPsbLCH0GT4JYK3u3BfNBTowqciYV1Qp3h6WHNqYotaJZjaalBh7Z/uNywgsd4r2jYd2xKCSc1O1MZ1nyKmwwB0aiI7UDbrVVuEdvzu2bIdlwW/oj63OjemTYkWYsv8plN3ry91c0tcQC9qniec3xg/4IcfRJGIcw8cEYKtQiAERUut5Z4PgmIB2oAiLMdx1Ifj/Z0FnFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTdPtfA5yOTqmSf49dRWyTNABMZJPhbUFD0O4bCzgBE=;
 b=lAGI8XqIgQvvjY2UxhtsPJBQp2WF5NFEX61zjWBNcoWJjV2WP2xpqrRc8pxNWNF+Ej5fZluBNx8/45/0krcZrF26Rpveckx1LuX/y+cIovswL3LSzLDa35dhAoCWg+H1KPv3tD2PAxuSyCWuTTwwW/fXc20Fzh2EmQqpI6I3D2iE5lOOzmCizAASEAn54ABzOlt2lHqRHkI8c+iu4/q0QLIr8mcsdXPYk2M3qf8bB2q66OTn21K5EnxwEdSjZL0feB5c1qHp+xubZ/te24k13zPDqQ7sAWSNJBKfio+OnGdiCxRkyNywvxf1L8FOroHqB9wWzZjs5/crTWv6vaG9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3210.namprd11.prod.outlook.com (2603:10b6:5:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Thu, 28 Oct 2021 19:09:33 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%6]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 19:09:33 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 1/3] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Thu, 28 Oct 2021 22:08:59 +0300
Message-Id: <20211028190901.1839515-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
References: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0029.eurprd09.prod.outlook.com
 (2603:10a6:802:1::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0902CA0029.eurprd09.prod.outlook.com (2603:10a6:802:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 19:09:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2ecc141-6817-4ee6-a405-08d99a4679c1
X-MS-TrafficTypeDiagnostic: DM6PR11MB3210:
X-Microsoft-Antispam-PRVS: <DM6PR11MB32105AA09A6A0EB66CE7B718FE869@DM6PR11MB3210.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPR7uyS/kW81fxxBZKps4t0jHRnjxmBwANfEUXeRlECtIIbAnDuZ65NufjipjaCVuMDXsk8TynnuJCMc1BoDS/Lqi3+tOesw15w/bAeVRckZcVLNnNVTuVMMwFsbYzk7TbsEnDQC7z0lixaAOaKI5lz/LEZN2K0SG72gS4JRSmrwBKmR75zgSh3cmusoFWBOzbW0ccCwakKRCRZ5+pzSMWhKBjk61z2sxEzlZ7tJbmr602TGC5/F4n0XeQi3iBD8vIz5b65LRrWBNXY7VW8szppc+rAfUs1cfVEklw195Skf6DFevh6bROVdrOiJMcvXjwFF3M/d9ifyeK/lYyR0F7/8aQYiYO+BVanc7cYl7WlWMk6kWJ9rHpB++OcsMPq2H8UH2OIJ1Cpptr9UZUw51GxyBxnMLHc82XpJv5e41YCEnwk1Stttu96WGPGB94N02f1muM9WgAtYVTp3yF+CClMbZXpXLBMxhTkqfbnuk9AumZVuQn5S41ReuMR6mPglc8bemOd2eMOytWoElZadSVnHgMOUD2CYrPxtnNyHMIzOnoxIcUBguugf7X4PdaqXOYwwr5rO8YUK07BrgkdWgVNfZCOJSAO4HqoPpIPGIbkcM+LDQ3D+ttfDRnDOKOj4PtUj53Z4uBXUV0AC1H6h7bjrtzkaom1yHkxxYCDRGDt1PVIifzxvEeE8os4w4P4rkCHLDvwitJOsNlDaiWJeuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66476007)(83380400001)(86362001)(8936002)(6506007)(66556008)(36756003)(38350700002)(38100700002)(316002)(6512007)(1076003)(2616005)(52116002)(66946007)(186003)(956004)(6486002)(26005)(6666004)(6916009)(44832011)(8676002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+reFDu5KQsAXvXq70pNcDwxe3b8mvRBQtmJS/vDMpz49TZxRgcYIt2dfcm9m?=
 =?us-ascii?Q?Wte6nwuHNLOFwt2jsDv2iwc5VHeW5zyeqrJzZM9/4WRNmoOdqWSlCTcib6EM?=
 =?us-ascii?Q?z3VEedcbfGfkAFMHdtkvb1k796uVf9nd5IGqPce7i0N4rAgXduuaQChLiyaz?=
 =?us-ascii?Q?cEKOd5BimRGNQTAsPLa9HDdjVhXW9RmRHFtrs04gu3MZt/9aTcfOTXSf97uB?=
 =?us-ascii?Q?UokYoadTqTSpDFob3TnSilN8ykIm6ba5rknIL0HQ2ysxgwpSxuFWxk64bZKY?=
 =?us-ascii?Q?JmrWqEZN/XfTJDh0Ot2GFhh9xJkar69usB2TUDgmSKlb8eKiL7m5ssW2ibuT?=
 =?us-ascii?Q?F4AYU36at6qbikDapp9g715nVLkN8e5AmYx4T+yuSfhR3YavNMi9PJREUKMM?=
 =?us-ascii?Q?QVHHyJdUIwtEfJNYHCiM9AasCkoO1w/vrhyJ2A4GZ2h8s3OtycOHRDONFkR3?=
 =?us-ascii?Q?3PL3ED+LGn+AQiOPF2k6OeMNNuzKZu3Vvgy6aHrDErvX1XAPTB/AGo8YgJBB?=
 =?us-ascii?Q?RARTPxrB6lf3mh0bRuaAWw630ETpb4jh1kjvcacL7i2TU3uIPEC8RHzk6owi?=
 =?us-ascii?Q?TAT4OX5JN4O9lCVIwwBVcJ5OKGHKsfsOvtMUI1ECkfJCbOQkYQkLN/y+cAeW?=
 =?us-ascii?Q?sQv6K8bHtyNEYWenDtX4qvpsIlCs9shaLaK78DAHus57EX0pfcO39ZpVgQjo?=
 =?us-ascii?Q?e09DWj/+152LNJL1uHJxNtIT3ug6pBBP2XNBv6059vO0f7xxNt8mHwgJMx7V?=
 =?us-ascii?Q?Jw0XxofzaGB3XFI6LeRXaVHGeFN77qzf/h1Aat3Kq75wps5SNgzukL7a+d5m?=
 =?us-ascii?Q?z3lA5iU/1hXJXWLDSC5lcmAJH9UGkzgqJsF4Lo39shOPgu21HUmiYAHRJo9s?=
 =?us-ascii?Q?kCVefBaXbp/92Lu2/2qjhUANzj+vqW9DwlHMiJYb4EzRhueA8fn1QaFERUgb?=
 =?us-ascii?Q?xn0ZcKrqTKN0G3uZSmRu3PstlflzuCkr1aBDd5oGLe2Pr4o7AgUkWKepdnpS?=
 =?us-ascii?Q?jfpzf+lkHCvlrPCTmNbHSiGXNtv/9uaqbIrkkjR1pZ0exuUoS5TUaZDuuYEI?=
 =?us-ascii?Q?VnDaL4XjyJLD3GuaSUAQrfnZVtnkBWA4VPpLVOXgSfssWuhg2fSuiJJOYZiT?=
 =?us-ascii?Q?165sKYBKFs7og07ONnMhP+or4j1BeFhhNeRYLR6xBMFyQAEXRen6+zgsxB2e?=
 =?us-ascii?Q?o+erIBvWpUVTKVzt/AmW9/GZgx0njWnapQGs6FS9upq0barB4YfKDWaGiQ7U?=
 =?us-ascii?Q?V9R9BaPh6qrXu4Y3pVIaadCH8/7iTb5w4ZTrZBQ2s+RwwmaYmV4J4Eudrhny?=
 =?us-ascii?Q?byNbkQZCzF6jwLMDz3hT6OrfuWvihhdMNCwbuvAMCK3abKvX6OI2ePN2p6FK?=
 =?us-ascii?Q?eCMm7WbpNUNVznBOp1spOYQZ3UcAu3unCUwQmFLwLdx9UjVy9I9dUDxINz/c?=
 =?us-ascii?Q?mjiT2ohJkFofYLSk4hOeKtmDH+CHZ6j1F4SNVc9XlMmi6qZJdTwv9O3GIvQV?=
 =?us-ascii?Q?u30g8GyJKAiyPH45jQESYgTn96/hQSjsG6+F2ZD0mfPOZ9ARPlkRUT7FlgXy?=
 =?us-ascii?Q?0kEZHkaUQa5URTJxHBakKqvczyGkqYd8WhquAmSCeXAhvEvs0HaKpy00lM0g?=
 =?us-ascii?Q?jk98NemDCTPf4mIQlOOC+jJSRVYsd03fi8SyKVzUSDaTgx1jj/SZ6ZehN2xi?=
 =?us-ascii?Q?vyjUog=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ecc141-6817-4ee6-a405-08d99a4679c1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 19:09:33.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Msc7T+b6tBIyVJ3CvD4dhtKCDzPWYvAWClr8kIXXABEJI7x3hWGcs/LgCkNr4o/svXGvPnHbfOtqy1mehYt4ii4odcBFF6DEUf6RZBE7dI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3210
X-Proofpoint-GUID: a4eGTiFZTfEidGBjU8EVJJs781CTX8ut
X-Proofpoint-ORIG-GUID: a4eGTiFZTfEidGBjU8EVJJs781CTX8ut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=453 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110280101
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

