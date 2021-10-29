Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FB743F829
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 09:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhJ2Hx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 03:53:26 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:42524 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232244AbhJ2HxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 03:53:25 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T7d6kY009489;
        Fri, 29 Oct 2021 00:50:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=hQalvQIrE3cvpQct55rneKHB7v+WiQLMSzSE9StTYnU=;
 b=HQmqd45NMdmenbZ7OFdDRfdMKwJbZHYSh9WTNT7hN+ojbrMSfWP4XqmD4q1C3jzZLpl2
 o99XayL01051drDy7FcdRhJJvXdO8QTa6pGEQrjZMSUU+GBeWSEn/PfW39IMjgmWq76j
 MMDTGBlELmtNX/EuSIWS/52fXe01DUtXhVyH2sMKe+sGQNCpSloCOV1Q70T9tRyS2Rur
 oBJ79F9YS6Hvr8cmRnx9m5iVFsgDQZ00I5ku+/g3LogQIjDwY9oqJitFbXLudq+ESpir
 bi/u6qn9b5Al9cOYsfuYpSUouH2HSbzfVFQ2JCQNe4k6YnsquzOCztKGh4sX+xWA27OU Mw== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bycjw9gn5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 00:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEWowHwHd+pygCD58s6V5sz4dnWC4J/+cF5+KGOsNNXobtvIxt2m+s/692PTdqsHePQZS97zfAo7evIM7RQrb6wVkAbaAcPZoW/INpf0/hztKlIzp10Dt62+P+Se/0pa5sarSxrIGFYxxv6JvcYksHJTG4xHXv++AuxGICz7qiU2AayBotgaYXVPEzPh404mDDPjMaM6lkR1khr3JKADQqtI7pg1hbf9anGk6uGn3ENQywmHu/RyiZdhKUuIDQ1Ym0y2qU/H6SoPC1722aqZ3aYkFQXmmIvqkNw2Jl2HBUWL1vbmhox9os0vSRWDN2gax9qiikfLYMTh2nxPd+rcSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQalvQIrE3cvpQct55rneKHB7v+WiQLMSzSE9StTYnU=;
 b=HXcr25EgjqUMWHLIGHaCTKubPDHboTHLhGWe0OUdjYIwbb53gXbKE2gCijAwE5AMorH+jhRDUWyo8/ZLpJzhbwt1s4/cdbsGkHSESIECPNCOHmCP5uw888PerH97QLyVrvv9YU4mviv/WIk93axESsnAm/+tdrj5UN2vbtsABS52cxjyU/MrHiWslzrNJu+ASZIknRefhHNV9oI84c3hnHiYrERhEQtlvqMqW31zA0ty2CyF2OzoPpOnoE3WrBLB9b/yywk9TTy4oBpfTalsEXemgabvA7zBvutnhqMckdSVPoeBiXxlqvH+Ez9mIGgV4fNcDNQ5qMCwlxy5o4c6rw==
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
 2021 07:50:54 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916%7]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 07:50:54 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 4.19 2/3] ipv6: use siphash in rt6_exception_hash()
Date:   Fri, 29 Oct 2021 10:50:26 +0300
Message-Id: <20211029075027.1910142-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
References: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0093.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::19) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR08CA0093.eurprd08.prod.outlook.com (2603:10a6:800:d3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 07:50:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d98efdb-dc7d-4245-057d-08d99ab0d5f7
X-MS-TrafficTypeDiagnostic: BN6PR11MB2035:
X-Microsoft-Antispam-PRVS: <BN6PR11MB2035FEB954E995F7370C23C3FE879@BN6PR11MB2035.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvgDkmFrQOkFMXqo0NUZeZ0PpCtrU/Sky083GJ87tcu5nD1kQRFTXYgC2+/02K3Xe8c76v2aitZP8OmGHhvHgv2etFh1a3d/xe/uJsdDe0EWIsuG8s7ASHuS1KOYtizU1WnTgXnonVaTvGL+XcMiD9BXXRpQGNytNXvFic7hh7FhzgCAOKFDC9v3wXTlw+/aKeBT/jgI25/rv2LJtkz9WUmltOasBkoAYsoFj5K4WwcrdM9+2qibeDKRWpeT3y7U0airttEYrV6gAp544y8KiQHmMR42iTLO/QQ51UBSH6qOvob/4njovyUbWTsQ4azN/H5VOIWX+tnn60bhqkTPjvitQYasXzEpAf+l/aeXr4D+y8SVVfxFZh5ABfDmtAJugtczwKH9djusyZjHfNVjgSAASwY7C8S8RpalZpdYhgyT2P3Ap67lAYBq64Js0TDUaPffV6+8uJN5TW59W11/+vm/E8X8c3zTf2ZlTh3YUrKm0QcszQjyJtt5fFoAc2uqTdI59qt2Z57ine3bV4u6FF9HrsRDPX9su1ImFKq05eSOFHuVn4ufHBwlHJTgWxUWkfuK+GYi7jzpq1NTNEjt4LXODe4lb5bTDt6yqHxLTIXPpmQoEq9wWz9w2dcx/Sb4d/HLN6vhv6jrUKsfEZS3yk9liA5qdXyjHRcVa2ZsjI6WjDktNbJ9kHV7WzMVE3lST8xdRKeCAEd5PYx+pD7GGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(8936002)(186003)(38350700002)(2906002)(6666004)(38100700002)(4326008)(2616005)(44832011)(956004)(6512007)(6916009)(52116002)(1076003)(508600001)(86362001)(316002)(6506007)(66946007)(36756003)(66476007)(26005)(66556008)(5660300002)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IT6dsjXxWgKlxeZX7EjCZ4ckg3vF1bRaBOJBz8OC99dXDwRGUis28v3P+y9N?=
 =?us-ascii?Q?8nj8mU8ITXkqI6DKUEVN1mlnj+JRlo4ZCshmCKKF0aIAX8PYdk/x6iJymwN3?=
 =?us-ascii?Q?5klNVs95Kw8HxQl2apQNgsAVIvUWO6oLqzG3RXaABguZ2tj2E6uC7Hoej1zC?=
 =?us-ascii?Q?xXvkKxou0EqScZFIz2HX7PKcEyOA7HsGg34ZAJGZ5rAh5vOAbvA/kdfa3kr5?=
 =?us-ascii?Q?J+qW03v1yJYo8ZyV5hbu5+oUPwN96jqfVJCkN71kwbmmyrfMaCVXEZp+7/MT?=
 =?us-ascii?Q?AxgJMIwn2iUW0vFId+iUWry0lLtVWLFRwLAjHLcer0ju+D1u/MdHLFmQFI2m?=
 =?us-ascii?Q?gacASmaR0KFC5tHvAJLFSTXOVJQxAa6UgRtRj0bQGFWjR3StJpfYxfh9iKp0?=
 =?us-ascii?Q?fOzn5FSbcvQs91n2xbeTbK0ZA/Yk3UkbEhW8DcW/26IJcWWiupElp5oYIxG0?=
 =?us-ascii?Q?ghDWqHwZ5DgqQt6BrKya1ctySPnJTyWoczudk4yjSxHzz5GqB9Hk9uxjEm4c?=
 =?us-ascii?Q?6YOzUL4ks/JgfxvXd8LulVfT3snaEO5GGfZq4/cB0XcSnxcvRNQ+STdbK/yc?=
 =?us-ascii?Q?Ivg818Yfw3BKHe9el5uYPnryfRBFhq3vaf7pTFa86533eiA4imj+xiZpDA2L?=
 =?us-ascii?Q?apyHiFg6wtonySjP81/9LICFxqdlOBoJ0QWu86bYW5flcQsetuagvKTPhY9n?=
 =?us-ascii?Q?EcqqsWZWV83CGcyHaTUI6VIsqWIvBfwuu3tOw17QtO8OVtofySxzOw903K8l?=
 =?us-ascii?Q?axeXKvjcTKC4FyNJ8XgLWpPXZq4LmRUrGxWgSvSSpw3R3hAtsyagmw+SJSiH?=
 =?us-ascii?Q?OdzUKEOZWK/RGFzGvBkLhqRHh3fElXeZAdG206ikmlVtTwyo/C+dEgPb2smI?=
 =?us-ascii?Q?/Eo8V7Pqivd2KS32U03x8BX3prU0ugQxQn2+sMdMVil+pW/4E0jxxc1giP6s?=
 =?us-ascii?Q?WkovQfRwNF3SaMu+sqP63ItPt4RRks9g8Cg4nD0I0JRJEcNvJ+o3gvwt2zFf?=
 =?us-ascii?Q?z38vUYs2XT5ovaMvwIqIf4omCpYlVLqLyquXMSlvO2kOA+dyRIc9NLMAr0Vq?=
 =?us-ascii?Q?HAaB45E3IgTKKHLm7IOMAOG6Sy93poF+hnI4GhC2l4L25btOK5HWq65rM+vI?=
 =?us-ascii?Q?RlUvkTfLomTcCFNQOuQMWuqmTaZTIVgcv5UkqsSv/d5jf1KBZa81XQRvkS9c?=
 =?us-ascii?Q?u0Z9CoviugKtQgwcsevYJPeivgcb1ZbytCMIG8/Kv/ICwM5xGmtaxFk9yqKf?=
 =?us-ascii?Q?OdMCLrxJvrtrNcMLApfxEswgnPGKHmR6NfKM1laDHq2ZGGBuNc2mKSwMu24u?=
 =?us-ascii?Q?FFo0hUNpgC+RLMSRpmFhgjwTRQfCTkqTwkjoAuP1IX3LZvLNOVL1UeSRBXLI?=
 =?us-ascii?Q?h9kq2u1hiUnBd8RLk8zuYDkN4uSOcaR44kgcDt/gyAcpXDM/r0KyTea0tpZj?=
 =?us-ascii?Q?u2tBHLJKTRqDGQvUu1eWJKuikmWqHyi/WQj1goVKDA+M8YsipcNeBL/dIxXi?=
 =?us-ascii?Q?Q0b9gcuKkeXSu51YfsRf1/A5h6PFtqpkEN+42UqtRGv3vZUXQqtDUavDYAXR?=
 =?us-ascii?Q?k6HM/VSt9X3b1lWpW6+FCiKNyM752hsY+IqsGe6KqP6nWaLgV1q0O5UYevw4?=
 =?us-ascii?Q?sUntTwj/cLnElF+6RIXiZK7eJfhHeWGCUm6WqPgD3sclyhrPZhxstOSDK6ve?=
 =?us-ascii?Q?3kC9vg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d98efdb-dc7d-4245-057d-08d99ab0d5f7
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 07:50:54.6045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DNBc2zzmAmN+5+PSXdXYHdQRL1UxqHku/lgoJE28FmCVHGZA3QSfH5Xgeiy7AiKLHxi7laMSoAgqYF5ou+o4sx7c8V7E1TLpC5rXD/P2fU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2035
X-Proofpoint-ORIG-GUID: Vos7Q-52dZyQz65OK2i4JWBvOZUik8bm
X-Proofpoint-GUID: Vos7Q-52dZyQz65OK2i4JWBvOZUik8bm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=862 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290044
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 4785305c05b25a242e5314cc821f54ade4c18810 upstream.

A group of security researchers brought to our attention
the weakness of hash function used in rt6_exception_hash()

Lets use siphash instead of Jenkins Hash, to considerably
reduce security risks.

Following patch deals with IPv4.

Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Wei Wang <weiwan@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Acked-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: adjusted context for 4.19 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv6/route.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f884739a0c1c..9bc806a4ded6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -45,6 +45,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/net_namespace.h>
 #include <net/snmp.h>
 #include <net/ipv6.h>
@@ -1337,17 +1338,24 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
 static u32 rt6_exception_hash(const struct in6_addr *dst,
 			      const struct in6_addr *src)
 {
-	static u32 seed __read_mostly;
-	u32 val;
+	static siphash_key_t rt6_exception_key __read_mostly;
+	struct {
+		struct in6_addr dst;
+		struct in6_addr src;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.dst = *dst,
+	};
+	u64 val;
 
-	net_get_random_once(&seed, sizeof(seed));
-	val = jhash(dst, sizeof(*dst), seed);
+	net_get_random_once(&rt6_exception_key, sizeof(rt6_exception_key));
 
 #ifdef CONFIG_IPV6_SUBTREES
 	if (src)
-		val = jhash(src, sizeof(*src), val);
+		combined.src = *src;
 #endif
-	return hash_32(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
+	val = siphash(&combined, sizeof(combined), &rt6_exception_key);
+
+	return hash_64(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
 }
 
 /* Helper function to find the cached rt in the hash table
-- 
2.25.1

