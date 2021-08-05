Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FCC3E18CD
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhHEPyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:54:45 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:49512 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242509AbhHEPyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:54:44 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175Ex0KG011530;
        Thu, 5 Aug 2021 15:54:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=G4eAT1QX7/68lF7Iq23jbKj45whhoedMVpvnJRhvClI=;
 b=RVugGiNRzHLGBaZ2ggUxY4OGf7f3K5L9P0NVGrDNKv2J45+R4StSIOV+fwo+aqK+Z+C5
 RvtkpojCutKRByyqpCIDkvy+z/ew6MT+KCGhK+6uX7z8ts/+yVJdcTVvksUwSDhOA0rn
 E+E2VGaxB5H6+JE2bGbglyttD72gA84abYbZhkXR3EN7JBi+sE61vnH/bda7zElAVoBg
 ByNZnq30L3n0dfxeeSp01+gk30G2B2HscbZYbKtyjHpFIeXl2zoChz64vKPoz2SiqA7g
 HULJZO2xxzXH0gQeS9Pdk2IzYwamzNd0da1ZidUK0VExJ3Cpc0+D4EH9XIAOSY1Ng8e8 ZQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a8gny05bq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 15:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSs26j5+iZN81DPlZI7dV5RpXRvJYObYqKz4lFgmP1TPnGfyK9iLi53WUek8BScN0Ix7+0oYmlCMOoKtnAzHUS+KC9BUHEqByM6Umkn5YXFS6PtNg1DgEpbsS9LKlZe3Y9wrsdAIc5IFMexX/URUlfZQa4QDn+Ek3nfFIXWeRotiWgIQaB1tM5QQa0/rUorsqFaZqKiXbdVjGSC4+z5EbzqDtfyZvBYL36QwQWZ8FNuRSM+PaqxVf4nwwYzwYeZm06w9oS6zhWzFfDfD1mUp9H/GQKZ34lwOyqVBONrzFBXHR3L3yNZAamAiuez5KxgilGJ9U339TDtQroSdI/qz/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4eAT1QX7/68lF7Iq23jbKj45whhoedMVpvnJRhvClI=;
 b=LoCkLdSR7iLKbEo2909akHzJ8wzSt0Wepd+M/4mNIDCjAcHtx8VDd7JO8NpClT0THZAt8n1jSBfif+jF4C5+hWvOBKzO/+VgLsaFNXHaH7+vubxjK1Hs9YNip2CKlf8D46fR/VgGA6X76s7jgJ0IbE9w0avRdbbMdxeTBB4CkuXuuYdwmmhygzI0qEwDTZ9LIM5PmLOFCXxghIFxYlhawPfggkDwWUbiZfI0hOfmW80/upu9r8Ah8LtZzTMMgWFb4QCss1nZLwrC319vkbgdrH5ZzKWPLwYvfKPh9IHe5Ee55ILJqTmXhhB9vIavXwAfUKeitz2SZ33CJwmSZY3+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2204.namprd11.prod.outlook.com (2603:10b6:4:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Thu, 5 Aug
 2021 15:54:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:09 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 4/6] bpf: Test_verifier, add alu32 bounds tracking tests
Date:   Thu,  5 Aug 2021 18:53:41 +0300
Message-Id: <20210805155343.3618696-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
References: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0002.eurprd05.prod.outlook.com
 (2603:10a6:800:92::12) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:54:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0c102ae-5453-47a2-a3a2-08d9582942f3
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2204:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2204572230385FC1386DB901FEF29@DM5PR1101MB2204.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CSEKjmCkbCalCG5LPLSkjJar7QtN2ulfWtqOOvw4nHVYklXd65Bqi85AYDmLOCJnPwfOcVl9wHBKXkQNbE5hDL2h0xsvKE3rQJlVaryuy9gE3aMgYEu/mq2JMY/LW41M20TT+WNnWtTLFzTzHaFk5xWPNE90RLZiIjR7RNGjSjvokIFE1P6sg0bLLDqK9k0AbWC08gx7P7gjmGcG14ouUCpv29OA6kqNv/5nQDZLak4XMEX7NeQJv88+UaB07aggsds/c5pNNEqQTH9yhEUaj/9M7Xzsx7xd7+mC5FcxdTmNyr4JpK/dkj0/6zwRCPEwplX1f7vKDR5ifja8kCqmaKNopgbBhZUsm+jLOyr+t8W1CgxM5JAQKtxlQ6OQUD6xXJyFRert3DtTpfRaa3YRjpKtlMdQhzGuDRzFHn2zKU4uZh0+9OrVCnQ2GK+L4ww8RJYcrwds/0jsNGCa4lJxPkqLFv5tq6rY+NL7ewW1/iPCQqr2FPyiGcg5MXv6SdFAUMD2tScSRPJAUQYcokRA2eCuVDe0I/DQmXaAyN7XDb8RBxHYrjCyqthFlN8KXuaa9m2snycWJlV0stiAw0dO8yTW9D2/tqlHce9yBmyJNh/oGqL7o2pYk5k2GbxDmHdQG+o9HeI8IxxejU3UWAMQ1r3wjcpRBIsvbT8+7pjdAKj23oHk9EO0K0ny2JD6g75qrnkWl8fOIMRBbDnQdXVNHt9Byj+NoXdO5ZpRnumFmclvDMIwtop9VwFyHBZ/fY/JACECuktMFe2tVo0CY++qpTtftvtrFLc2dGge6FYZlwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(396003)(376002)(366004)(4326008)(2616005)(38350700002)(38100700002)(956004)(6916009)(66946007)(66476007)(6512007)(66556008)(316002)(6666004)(52116002)(86362001)(2906002)(5660300002)(8676002)(26005)(8936002)(186003)(1076003)(6506007)(44832011)(478600001)(36756003)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3Q0Q0j5QHsOep5fSHbb5/xchV/7eVQU076tmMqeWwGsU5ucsUbDeCAu3kVX?=
 =?us-ascii?Q?rm0KBSSgxFJjq6Ie1+XFWZ4YxPqGZs4ibXC2FNrj6ztqyCLudQq+Qi9EqJc5?=
 =?us-ascii?Q?lH+7v4+S6wpE8+lDTsWMMHdQ5a2k082EWhuksyltsBU77+1eFS5TXNGCxBt/?=
 =?us-ascii?Q?qVWS8TsZHKDouJ9B5QpcqBI70at7U3UGGqnOwMzLSsrzEipXGSLYbOLxDZ6f?=
 =?us-ascii?Q?cg8IDDi6lV5bqndohqpnR1y3feS6aWiYgRRgu0hzlOIhMP0ylWTeYCkhCDbq?=
 =?us-ascii?Q?V1qi1TEPB2t5ZIxEmUlG6oxcTa8ZxLiJqZ3/Fm8bxdj+XQzO6GhMkrJOV3TA?=
 =?us-ascii?Q?fEyoOkIdM4Z1tjRKciAhfCh4ydYVj8HqVXrCyMG12EP5vieBMO9xFCUAbg7S?=
 =?us-ascii?Q?nqMyar3K93XsscAvOH7cLpoloVY1keyvzQRIavxOevHUbvVKmpy5bE3KzGai?=
 =?us-ascii?Q?70UUGsQ76r9EAVfztRvCxBSPu2J4p28No3SkbGW/Pwx8AIKK/0honZ3/ENGX?=
 =?us-ascii?Q?/ogPkFJu4ptvvTEcJDFnkIynzfxG+jTo7CDiHqnoCu56Bm+JlmLmG1Slse1C?=
 =?us-ascii?Q?t43jikhOTAmQhU2ErGhYQ68wQdk1V9bPyWOvCkkcZbjcpD3thHs8zfSzONEy?=
 =?us-ascii?Q?c7zs9/YH1rKN1n9F3lsGsf5CkeUoSe0FZgMirh1RqEYlOjbBe1Vu8QqDNuN+?=
 =?us-ascii?Q?jrRIkgI1JPFJKXbqP+cN+uRfdnfjyl3uVB/fjyynWHK+rEfK6VuYP5DPhC/G?=
 =?us-ascii?Q?zCt0tSOrvUAJhH0kjETA0uQ7875kCu7oIRc9Ep/p/J6ihNy7poW6QAru8doO?=
 =?us-ascii?Q?DO0hpm+wxXV1HI0L7J1D3EbOFCR7HjbGpDhy6HG6oEDGrqKWR7UBmCWHAvjt?=
 =?us-ascii?Q?q27j1ZvIaFiTvr2gO7V69DtaT5+NXTqlho+V6QaKm3Kz1HfhD+w7+Krfoa6N?=
 =?us-ascii?Q?7sqh1jVUEInhbb5HZJbML85RrSg+B+b96VDLjWa2j2fnAbk5EFowBhsdL3ah?=
 =?us-ascii?Q?ItYNS2RjLD+ODmezb9Aq/Ze/y+M2Et3q3gKQpcsz4ueVOK7cSfpAWwRx/AJB?=
 =?us-ascii?Q?PWpEemDTjZrrbQbjqpt/ZxxkWlOHN0r1wqBMHB0AnR55lrkrb2cVG1rKZg5w?=
 =?us-ascii?Q?QLch3zqwlE4DV+lbyGvbYJ2o83+k6Zvge1n8YqbPdnHcgAOTF4sBQnbc48I8?=
 =?us-ascii?Q?v3/eKYijKYe7Iwd2v8fCg4S/+fZte+snWV81XUWzChYvL3rV/XmLkY6oaTmL?=
 =?us-ascii?Q?+D61ZdrXvObaOqYXIJstF1Qr80mRCRyvloiQKrG5GSD7lVodRsBEoznw3bIV?=
 =?us-ascii?Q?pcRiNygrSdf0Y2UH6j/gRU3J?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c102ae-5453-47a2-a3a2-08d9582942f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:09.1355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXAGHr1ViXnMXtKqAGoMeFqboTBpRdtLiV3GpdJSkXLxmVhRQ/k57sJ0+vPLCW8m+6O5uO5JM/yxZPcJyOXZcX+lRbGUyb3vo2zRTrbg6+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2204
X-Proofpoint-GUID: vV9leNOetGJress7o2l2EIUKjrTBTzxy
X-Proofpoint-ORIG-GUID: vV9leNOetGJress7o2l2EIUKjrTBTzxy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-05_05,2021-08-05_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 41f70fe0649dddf02046315dc566e06da5a2dc91 upstream

Its possible to have divergent ALU32 and ALU64 bounds when using JMP32
instructins and ALU64 arithmatic operations. Sometimes the clang will
even generate this code. Because the case is a bit tricky lets add
a specific test for it.

Here is  pseudocode asm version to illustrate the idea,

 1 r0 = 0xffffffff00000001;
 2 if w0 > 1 goto %l[fail];
 3 r0 += 1
 5 if w0 > 2 goto %l[fail]
 6 exit

The intent here is the verifier will fail the load if the 32bit bounds
are not tracked correctly through ALU64 op. Similarly we can check the
64bit bounds are correctly zero extended after ALU32 ops.

 1 r0 = 0xffffffff00000001;
 2 w0 += 1
 2 if r0 > 3 goto %l[fail];
 6 exit

The above will fail if we do not correctly zero extend 64bit bounds
after 32bit op.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158560430155.10843.514209255758200922.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index d55f476f2237..d8e5388c9ba7 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -506,3 +506,42 @@
 	.errstr = "map_value pointer and 1000000000000",
 	.result = REJECT
 },
+{
+	"bounds check mixed 32bit and 64bit arithmatic. test1",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_1, -1),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* r1 = 0xffffFFFF00000001 */
+	BPF_JMP32_IMM(BPF_JGT, BPF_REG_1, 1, 3),
+	/* check ALU64 op keeps 32bit bounds */
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	BPF_JMP32_IMM(BPF_JGT, BPF_REG_1, 2, 1),
+	BPF_JMP_A(1),
+	/* invalid ldx if bounds are lost above */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT
+},
+{
+	"bounds check mixed 32bit and 64bit arithmatic. test2",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_1, -1),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* r1 = 0xffffFFFF00000001 */
+	BPF_MOV64_IMM(BPF_REG_2, 3),
+	/* r1 = 0x2 */
+	BPF_ALU32_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* check ALU32 op zero extends 64bit bounds */
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_2, 1),
+	BPF_JMP_A(1),
+	/* invalid ldx if bounds are lost above */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT
+},
-- 
2.25.1

