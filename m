Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4640643E8D5
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJ1TMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 15:12:06 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:48006 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231169AbhJ1TMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 15:12:05 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SETjC5019753
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 12:09:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=hQalvQIrE3cvpQct55rneKHB7v+WiQLMSzSE9StTYnU=;
 b=FUD5Jmioulj196C+GMpsB0QSBRZf7mgAEaAnmiIomTyswUqwL1BlNO0/rrX3MugYtfGc
 qQNCdIFf3cijR6QMK8SVbMVwLzZe1ZvdDNJLn/5VWKepVaWARwM2Marv4AMwsYnVEHxv
 YJ1l+GwL8Gl3y+ZRcF1pktlFIDuFEn28oaU5MSys/qIfylFiiBKu2B5M9i8w1qDh9YgC
 aOdj6q9NpHfWah2x9LWbZmxNDczvfBQIBDX6HiyyA/M78/AuhuSyO/n0/HGn6tUdH7+7
 HRmajH70XuF3RXfVND1LFE54W/Y0Aoc3SZqtTUV/AcWZAmaG9poPfGdvZouMmg72yWUU Yg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3by9r1h56p-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 12:09:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E44Y3QWb7YA/IM6jSjjo1+CUYhO5Ja3QvCGGLqf5nXvvsrKnkzJ9HOy0F0L+0ztEvR32fJVyZdxxvz6+UAF+PI4bZ4mGGWKCZYIlC9dwANFI1Eg86BLR/eD+Jd9S6zDCsBG3IlQlDEST0aa/l6iQcNMA+3tAEwSbpKbTBBN8O5qzQoWEoqKVPRcGg2mc+TrWHF30d0TaZp/7NURZ/wnaJVJSpXu10So5GCjGz/ITxmg3VF+FiApufqrVr+SlCE6QPQ+MZzAIceqxaBcNFYPvDIr5tej2bJpQc1pl3/I5TJi4xYIK3EwcSqFoDqQn4mfpCXnGl5Z0fBh0KDaLiHC45g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQalvQIrE3cvpQct55rneKHB7v+WiQLMSzSE9StTYnU=;
 b=RpVWmc/RRBXAEqOhzDQDFnYgUFsY90oCrmRxskS8wVkkdEHtd1lNDss2WTRcztcJ7YKv58hn/vNrf5XE1vYrygkfxkWhlpMQjF1LGbly0gSGd1YPh9fao7MTmfIxt/jBOChacS8vK3yelWdfFVqY8jlB9XyOOU9YIZieckWBGPoxI8LjLjlHZpIkhCStlDq9BVaZgwiiYHXBiZXvPue48uRTAm48jOiRIAAQgULq8mBibSBWD/eckJHUE5/W5sWDkyNS/8C2RIDioxwtMn7k5WhvrKInbr6y0KE0E/cfDRg+/tvh2aZDVLpvayRiGl6prl51xyp3PkoszyUFFkpxWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3210.namprd11.prod.outlook.com (2603:10b6:5:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Thu, 28 Oct 2021 19:09:35 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%6]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 19:09:35 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 2/3] ipv6: use siphash in rt6_exception_hash()
Date:   Thu, 28 Oct 2021 22:09:00 +0300
Message-Id: <20211028190901.1839515-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
References: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0029.eurprd09.prod.outlook.com
 (2603:10a6:802:1::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0902CA0029.eurprd09.prod.outlook.com (2603:10a6:802:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 19:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7b4541b-5191-4537-d616-08d99a467a43
X-MS-TrafficTypeDiagnostic: DM6PR11MB3210:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3210A9D903E9970473A925A3FE869@DM6PR11MB3210.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhbYLSVJ/fnpaBK9rGApNboG96ISvY+j93GDGs7T2cWliLHd7rDMejcEvd796732xUiKRZa5wGDHttjLVJVwv7HaLc5fnJ06BMBLxLezZux4zW+S4fha87LirUetfJ0O7GBMcII6HU8SY5/yEBNzFOjP0n+U2100wEINhyeCuBrKAQSpS23kxPl0PQNIcv9nyBE2WZwsmFxiK7o3xR3F2cexS0Sad8TOXhHyys5lBFl01yDwJCONNUCGNVFCVpwQYamUxN1X9F3L9pdHQo3ZQEjcIvWvXJuv7h/jOrk5XE4U/0cGws3oL0/LfzIOKVETjg2pIzdh/reRalEjEYQcMjXfoClRebA+tJ99LsyNsNdLqg6+U25P4wxk+Hp6bp/20OXcSmbhKYu63LoZGz8v5oR+Wk1y7VaiiLekCrtaLjpaKfCMsyWf97UDobXOMJmemH5rmcmQIXo22JxHdrJlGuEM9n+PibcPJuli7tBQS49CobmLIIsA7FHLi7912p+yXfx98kZ5PGTpo3K6WHW0ktZ4AwqubcksPHCjKq2cfrzzzV8h1gt1XuctzqSKsJIVAUT0/JDXg5jgoWxAhbiMkcVgo9vzUA3sNU8XQ14hiCUKit+9O/d+g/3GUVgKPSb2es/f+Fw6wkcgX0uyCy+b1VlM9AjBRsZYrPMSBjcIFaWHI4a/hGycm9KlLS1NntjWDqpterTWJE/+ctdOQnB3HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66476007)(83380400001)(86362001)(8936002)(6506007)(66556008)(36756003)(38350700002)(38100700002)(316002)(6512007)(1076003)(2616005)(52116002)(66946007)(186003)(956004)(6486002)(26005)(6666004)(6916009)(44832011)(8676002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?75o3M2F3WqndUq/2oAlFlwhKt8oBKYBNj5XopFQZW25wLLhEDT+m+iIY1yHo?=
 =?us-ascii?Q?SFo33ATd4Askk+mtE7ghKmf0ujWXyPEAB75KrFRzHztS4XdIhAQN/mzDZ818?=
 =?us-ascii?Q?eCaSIP63ahB6I4XeANGnbCu6sLNJhhFWCjEpaOFonMHcdNbFPuFX9XgEagpi?=
 =?us-ascii?Q?AovWG71o8+57KvsG5YRxtBWJqwsOS/j6VrnWlNXyMmV+qVZgtSu+pGoSmnru?=
 =?us-ascii?Q?j2ZD+mOJCdXhbnWYy3O49Q4X3wKIYWX7ygoApjrScem/KrpTvch4RK8CX6hS?=
 =?us-ascii?Q?pR3BNHnPXYb0HGNT7Ivo2ang553FMUi6RP49DF+CgpvmRbzWXO366Cuvs4dm?=
 =?us-ascii?Q?MSXGP5pLnsc8SevDRGv/dxzF4jlAkNb/9lBv49Z4hI5khCuqnGvHs2EjUhD6?=
 =?us-ascii?Q?Bcr/DJxZTO6hQnpSF70OiekMytVTsid0LJ3t3Tv3EtXSY++tRHIwxHwg74N9?=
 =?us-ascii?Q?iNqA2Qw0j4uM5Zz6Qu7QWA0xVHASUZrKPgLU0N9RpEsrtCC1j2XEKXbowiwN?=
 =?us-ascii?Q?eQkhQL4nLNgoqcpEcnh0kytV7Yi1ajIlI5iIyUFiqMLlS8H732R75Lu2X6Fv?=
 =?us-ascii?Q?TXaUWuvvIofNX5uo4W2aX3liDDITG22hUDXns8u8pDRoskEnYsEIgHFrBsom?=
 =?us-ascii?Q?p7Q2kN6g5P5YM7Ihmu37tIXUzMLNf9dpgNmA73STNCzSVsPQKPkHw19KJ4Pc?=
 =?us-ascii?Q?gA+Dma/PKrpaHke2tljls1HHHdv43gKgSOEJnKEqd0nw4jYYswKbG+C+/75N?=
 =?us-ascii?Q?bd03YRm/tL12Z5p3dlELWmxF8TKR4B6wEiVkN038SlItyqpDAxK9lRYgl836?=
 =?us-ascii?Q?cocPFFhGhEvhgdepnuRELeU1YKUgJpY+Ab5da1E7lj7BdkgzuPGREZanjt9Z?=
 =?us-ascii?Q?TiPYoJqx+hSxM8HcF5fTzbvL6m3Z3eGLHZ1dbnfe/iLDeMApJnx1E6u6OyYp?=
 =?us-ascii?Q?nBu1/OCxjv9vCnXE/ii3qppan8lXo0aL6mt/nZdSicy0rfpqHqWKUbkoDNIE?=
 =?us-ascii?Q?Ia4q+XS4NL2r2JKtup/pxu/WGXk/nYiXGrb5mCL4W2gm6+g5brAReHtDsClZ?=
 =?us-ascii?Q?8njWmhpI97ozMc6xn+7cWU9XLEBhCtBTEQ1sftmKG3FyJ4LRb2avcuj6Hep7?=
 =?us-ascii?Q?JMBz3rs3LRRQWdVcIX4P5+Ld3Sudr4cS848qPJphGJVljEQ1pCPiUin2H6cI?=
 =?us-ascii?Q?3e81wBWWUQ/cpNiT+qzHJNGd9J5Yhcjh0wShrdOejdlBIn6H+2/kqBZC5BEn?=
 =?us-ascii?Q?zdDZ9LRJoELSxsvaWqwAupeo2gOtQ6vtzME6LcAV2H6Q+QTkLR60DBnx3xbh?=
 =?us-ascii?Q?YMMZ//73SU68B+n+qj673AoWuSWzyo0S/cfl5s1XdSRQISn4ArzPz27JPI1q?=
 =?us-ascii?Q?EQt2NhohtUoHouKk9qMUhRY16jk0DOd4RAJw88O64GfP0Sjpk6qPMEb6pKTZ?=
 =?us-ascii?Q?G4EkLY/20XO4bedtHAjeIfXvt8ZWaZrcwXNcvd+02sER8+/uNjruqqs6Q1EP?=
 =?us-ascii?Q?PQV5IO+ohuwABf1yVu4bbJ15EfzNxXzcq8rWtHYWmi58j44JANf/Vmlaw4zi?=
 =?us-ascii?Q?5FVjoms83WBLZKN3R0Jc7lqHIDqrcmb5D93Whj48Yp8vz5fv5Sz+AbXDww8J?=
 =?us-ascii?Q?/kWieU//Zv4tu2KGI+aSDTAmIsyL3CuHQlGw04sWaHXHdK7aPIYh0JI3ZmY1?=
 =?us-ascii?Q?VCif7A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b4541b-5191-4537-d616-08d99a467a43
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 19:09:34.0474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpMeeTVwJWCBczB8N4Rw/bbd5/xrDdTYBjt1KwLch9u6JlAiQ5t5uqVKf8SM8xbwbuxNme6irpfYG8zJha+EyaSvDHoJ4OQHYTBfkiPWVsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3210
X-Proofpoint-GUID: 1UqWDttzlMWmfnENjgVMiVB9QI6SGpRU
X-Proofpoint-ORIG-GUID: 1UqWDttzlMWmfnENjgVMiVB9QI6SGpRU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=797 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110280101
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

