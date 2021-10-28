Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC7C43E78C
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ1R7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 13:59:21 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:15296 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhJ1R7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 13:59:20 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SCbOUV009266
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 17:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=tUKiAJhV2+LQlJY+31C4yIWoC1XBAYS0rGx0gBzDDM8=;
 b=CZOSsX6NFBWTtbNlCwRVfq3BUqxQmHpXpcathxBVcyxg7jd7qqYOpyLVxIOh/pUMkEvQ
 jiXL05EGUBZOK2FERe8feBZVfoZWCQzrJBUeLz3yIR/qNk7LExOMbhKkW4Hgg7L2d+EI
 1p00UV4xB0Yx2zQ7kE0/OT7baR1zQwh7uJwrxprRrcb2rjE6bjVKBU2NWhpsKXf+AAhq
 ky7/rfhHaoF1luLPXXuNdNa1TdP4MjLd7a0T6moV6q/xoZPRspELCMmD8exw5p6lAeA+
 XUtQYGSgsdZC3kfijtMUxKCrsGuT/zb5OCwu4mVFhQaMmHVTkIfS04oEoMP1fjdokAOi 7w== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-0064b401.pphosted.com with ESMTP id 3by93x15mg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 17:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E95AKt4Xk0SbY2zP8CQPUOnfQPq7bQb41aEwvvo5QVyRLOZpSA3T/Gs3ZJ1X7luw/UqGFKwGkJeem9AN1gKGS+S9yeKsx2osZtau9eXVNU2APIWynrmK4L40IeFArSP8u0IN/oIAI4kPBs61Q7s5nvPwexpXmFaP56gARsB/KogDoffBnA7jqOUVHnjiQxX3UcCbQQmSz2XNr2xcDzdnU1olDUfwKr3JVsdotpLakXZaNS86NJ+pa68Rhy7SNLc8VsvrV6FJVfiaAAytqqDLCUjZe+MSMprQ9/Q+CAcfxt0O5hU6eT76ilWlqm0EPTwKrwfCEshBQN7YciQ/W6nYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUKiAJhV2+LQlJY+31C4yIWoC1XBAYS0rGx0gBzDDM8=;
 b=CFNir8QW0rkSs1DKDyXd0eNR1I+zXoxlczueDINq4+kk9NoXTD1SNnst+P/wFRCycKvdgcRy1ZClTAcfO6au1j9IxXS0mbjPPo7xyHZ0fMeFWY5OT0Ge7w9hPH5xhLZlfEDmTo/8zsUCUpADQ9nFCoS4nrKPs7Vt1/NNpj7MUl3t1gVS1bL65wrmNHjvxDUjZHK0tpr1asrGp4hJyfOBIKnGrJrae/xEHb/cOPC/dqVU8DVg26ywhsfNeKu16kmTZOsXDKukaUUWkutlP0jOzi1wSOE97Mc7s03Vloa9m7t9+xZdo2DWKotjedaIYSfgNFdyoFM9t9SBEETDk7DJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2874.namprd11.prod.outlook.com (2603:10b6:5:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 17:56:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%6]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 17:56:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 1/2] ipv6: use siphash in rt6_exception_hash()
Date:   Thu, 28 Oct 2021 20:56:30 +0300
Message-Id: <20211028175631.1803277-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028175631.1803277-1-ovidiu.panait@windriver.com>
References: <20211028175631.1803277-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::35) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0101CA0067.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 17:56:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07cd73dc-e034-4be3-d531-08d99a3c518d
X-MS-TrafficTypeDiagnostic: DM6PR11MB2874:
X-Microsoft-Antispam-PRVS: <DM6PR11MB28746C97C7C716D57C4D8BBAFE869@DM6PR11MB2874.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S41ivOpP/FGeJUsn+58WKcEeUUs0N6yBN3WSfbiEVKb1GZKtZ/XBMCdrliRAs2jM/wF8HDMLZm6UwwWpixnslVDjoYwINAoI1dynaDJuq10Qy+x38ZdptEyVfBDYu6ScUUULu9IbKTEOq9obRuIv1tPswNw8445c9mMQ+KuKvZwlNgaMAMXxrhSm+5RokYiIOBjfGEex58APsAL6j+azci0tzjwWriWLpP1vIOqnNkwjb8Y3+lsZg84O5S6YDPEcAzFCY4d896h2Bb7tnw6rJV+f0gyjCv/21o3EfoiKXBm7vZaVMgampbS2nNiOFyzQUS4Kra1WNuaVdD4k9/K6awLLhtO08Xh4+N8fwyrsiG+0UvoqZHFVf/f/Ddv3niKEDP+HRS/XX0f+sn6jpYqGxjMldypYMDM1YhumArtcYL1kMVFFREMyS0QN2Fck6Ns56YLFdm9IllIRXBbRt0L4KdHRrEKbDQWEMwBtFXEsJhUEeOtXHQmeQumfakwEXwMdcig/8pP3Quc2bQLLCp9SGwCDSaZ36r1OijBQtUgvDzeFHk/O1Aa+DAlzttjVLXPSyf7Ki5wyISJ2UZhp9Ivb5wPpgaPZzIfQKGpb7SWTefeUSybj3pELRSFT963jgzykOxJ03vH/ivf/B0rawXs7NktuHtBmNx5EitgoRCjvRu5KXln7CCuCjS3O92DHPRP/YUuK+JcIZ2QSs/hWvCpz+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8936002)(36756003)(66946007)(186003)(86362001)(6506007)(6916009)(44832011)(956004)(8676002)(1076003)(508600001)(66476007)(6666004)(6512007)(6486002)(316002)(38100700002)(26005)(2616005)(83380400001)(38350700002)(66556008)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hd3k27Sjv7LNCp97B4jvMPKfBhFDHDRNmq8Yp5lDaTYfWJHKuUH6+Uj8Uu+Y?=
 =?us-ascii?Q?aPaiJgOEhKVL1wx06Q/PkdewX1lGH2u7voSFXEDpgsMASutf6zlT56Cv12ox?=
 =?us-ascii?Q?g8SGHNf36vdI8SQXEB/HSSOibAFrMMK+CHbXWNoP9XuL3bYFOVGj76mr9Ly9?=
 =?us-ascii?Q?gmkapAOyrRAZuiiLDs/57hgmKLx4twDA9FmFych55B3rlgxfRjAbWzhM2CEl?=
 =?us-ascii?Q?msjrMwVMdZ/eb4eIx4qjqa5gGnMgxpkUGkpDtyJqk0c09G+LGWF8rdIgTEVw?=
 =?us-ascii?Q?IEuqnGxaOo5gm2rTi/UPM7ToGRCccdfksnIQlzv3eAtmw7aAkHYniNbZS+pW?=
 =?us-ascii?Q?vO/KM52XYaEj34K7JqSzj2E1YekC6WHBKkwuFKpSFyvaCBTbWwcaPqn0jAyJ?=
 =?us-ascii?Q?Q6dZMewowWTvmFYV9oSci/CTKV+dOgD6Jvpa0ZNwFWcqBzkGePKeJFDc1zJn?=
 =?us-ascii?Q?yl4O7V8NyqMd+OATty7JtpWL9+mOAdZptvK9sdwJQovSIve4zIEpgb6osnBK?=
 =?us-ascii?Q?2b34ze+WU1f8RA7Jw5cnDDFK8o9CW8UznGIDfuKI2KnT1fgZQpCywp+vF26K?=
 =?us-ascii?Q?HLH2UuTIA7XmelmLLaja4jEAiAmj5Ly2UKxMM+i3UvgTeQfl9bR78QHOiD+u?=
 =?us-ascii?Q?7aA20pW01X5/ZeNWyxD7iJKQgrV2dDi1B97Lx1lBPEaClJR/c+DbD2hRody7?=
 =?us-ascii?Q?IDkRgqBbmvc5qkeed/3jJR6CyQyE/CGz87rKYp5FKV5MFr78JUySOoClUOE2?=
 =?us-ascii?Q?MbPF9UjUHsqB1sT4WhrSgWfn9Ub6IKOL0C2pYwdPLv2JihqtIHz/WO6zmcC+?=
 =?us-ascii?Q?ZEveV5FVuhMK3XeCTJ5BqBwF5Z8nfawT4bO+rDO50dHbp5dIBZC93dLCnN2i?=
 =?us-ascii?Q?fLccHmgTzTUZMsNmbWNZFXGun5jfwDthiehymbf/1UlJY0OdS63nxtoRHKC1?=
 =?us-ascii?Q?MAb44WN+M1bBRao9m/60M0pj1m+tMmL/OQvqOwn5f2MdMLuKI5vLMvyeNnVq?=
 =?us-ascii?Q?ghpaDSTLGwDDwNKCIk+iLULTYVKWGvcMgyhQwcAsSmBBNtjRdn50RqRClQnT?=
 =?us-ascii?Q?up3DULy1Kp0nY1MR3gHEw5/J3liiVgLaQ0LNBhrtox/Jq9GI+77h9E36ex4P?=
 =?us-ascii?Q?N+7w8fS8HWZzfn223ACnAwgn3JI0H50YGtkzyBIXUtTU2xBqeJnMjOP9f/gY?=
 =?us-ascii?Q?VZK5U2slcthirFiRH/gpcmlnittpCE2wF4HnH+PItH7IVIi93UuB3/N8UTFR?=
 =?us-ascii?Q?utH14/YW8+X8SE6dxmuC3WtxDsd+OoHt6A/qT17KNfKiIVNdK8yq94dgzU9C?=
 =?us-ascii?Q?tj3c8G2Mh9RD1ZSVlqVQpPubYC+92BHhKz3yvWgDiVzdEY/tW7WuVPkI3crJ?=
 =?us-ascii?Q?wUL9juoqBtlGBUvzn5bzT7Cq1RxMt8wzEBEabnhFXWUQR9n6F+ys4ANurzE5?=
 =?us-ascii?Q?YZYEVmCxxFCAtbw+Y3ma6HjUwZwMgnb7fyCKaNsTEolTyo2jE5xiPWkRi2dd?=
 =?us-ascii?Q?2LR39zegi+v5Ovu87WgZTXVePnw934bWmgbpzFUltAc9TWd8l6AMe7IeVGaH?=
 =?us-ascii?Q?5/OZLSqpNXOe18/pSVT7FZH6U3w1KA/pN6eypO+X2KztJqb7CGl4tVwIqWFj?=
 =?us-ascii?Q?xSvgWvFLf1l4DSkDzy/Xfs40wimHWESowu2j//aGZXK3I+d5FO2dz5ytUaOI?=
 =?us-ascii?Q?lYg0PA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cd73dc-e034-4be3-d531-08d99a3c518d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 17:56:50.8960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G91bA4imQoWKE+tjlZeJsgKA+6yffWJcNuLBnZibPOghnwF7NuPZhS7/w1Dm6EbemJHXnSOiM4xRjsaPuwqRFvyCCE/RiAF7CcQcVg+s7NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2874
X-Proofpoint-GUID: pFZw3lCzej_FH5HUPq6sdo5H9mdV4TS6
X-Proofpoint-ORIG-GUID: pFZw3lCzej_FH5HUPq6sdo5H9mdV4TS6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=896 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280095
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
[OP: adjusted context for 5.4 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv6/route.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3fb259c20546..daa876c6ae8d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -41,6 +41,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/net_namespace.h>
 #include <net/snmp.h>
 #include <net/ipv6.h>
@@ -1502,17 +1503,24 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
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

