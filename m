Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76253E0659
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhHDRKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:06 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:54426 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhHDRKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:06 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174FpFA0032119;
        Wed, 4 Aug 2021 10:09:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=aXcxMyDJSosRqAEaCT/j/f/lysjhVGr4WJ7WDZYRKCI=;
 b=cpZ7uBdkuHx4MFICvxkwBJhCEvz44WjPmx7+POggWYbjwq8+d5AATKjN/9rqg2I1+a4m
 0D9mvTa7xT6ALZlajHx1tw58JWEWPadF9pDHSznNDPQyNikjLvlxnln+bQ3q98PQXWyX
 kPUIRRRtODajLHLdf5F3X5HVXXUcSvIgRnYtkP+DcuQ/Jvr2LfpS6+chr+uLCnx0h6FB
 OLPdf92Hg/MstCMcYrKx+9Ag/6D6BCHIOoHGRT+D26WNG+Mak1pvrPDIAoxWKhYvq3zl
 kFE0XQsY+jvyzuPweet9DYf75OVT1k+adj7AFUfM6cK1OjjMQ0wkjiY5qLtnZFffOy9O qA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7vt6r425-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 10:09:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeyaZFabI6c0l47Ky9hrDKjr2jFEZPdovmmiJphMhmXauwKQZnN1Iy1UkGokSBLbw7d4UKRl2amxdteLZVT5bpLLpW4u9Zl+wSxzyX89FyE2tnhkMZeZ/xjrIh4/jUY51wukujtKGvs3Rc+wt/N+8Pfh+8UyFhSKo0pJLPSHr6DTNbGYBnipagUE/4VbmaQtUY4A7KYsE019JcOcc6iu8ihyvZYYHrInfJ+YV1ZCIANONeEavYqu7enrxdkX89j+aK3QIbjJLkpTuFK919VEm7O/SbHOB/wSgC9DfUMOgsAMfaQD/zFNDv6E2COOjFVxYNwTlSWBAbCQQnRwSGfqlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXcxMyDJSosRqAEaCT/j/f/lysjhVGr4WJ7WDZYRKCI=;
 b=WqD64ytxcHqoSPTaHOhOo+djLFVtfBQr6El6b/P+Cx72JFdR5E5didvOS+kZZ2RCkVGcl0Oyih1IadW5p5mrfILBvVhlyjjvTSs0VVr0EvtDJhuhRuXaVAvKWZdUMZOal4NIVZPTqcvee371ZycyQBgd7O228abFsJ9oZYo8Q3NBWjALrlIDhcgRVXqaEW2SJdYpmiB3vJHMxdsXXrzugLn0gUvmsIhMwoCDtKHRGlWl7LaHran5XpsrUvzTNsazFjvcqFetu55mhy06Gu4XloSgfRq3K50CRsajf9I7EDonwT+5z1jRg6A/5fUYSflyaYdMf8l5ofkJoev4zUoFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1834.namprd11.prod.outlook.com (2603:10b6:3:113::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 17:09:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 5/6] bpf, selftests: Adjust few selftest outcomes wrt unreachable code
Date:   Wed,  4 Aug 2021 20:09:16 +0300
Message-Id: <20210804170917.3842969-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
References: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0033.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce8713bd-8e5e-4536-2c6f-08d9576aa509
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1834C879641D4B8F51BB6A3CFEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QerGUCj4jjmzL3JPakA3pWieXvsgI3ppip8RMbJFQD0Mzvpv/FG/CpQu7scHjSg/F+wvheZzgY5G8R6ouR7zFCfa9NUsLW7HYcBHolhXe/jXOLhkQK1YDdPheBUYgZnVS5VOVczpp2DpIQufZjhkxKnd5hjCOoCX2PzDLlts7FtN1NqnOcYGYoNYLYSuYWda1n64T2At8LSpWqrKWc882YwF1zUEpUIqGuOW36V1J17U66sQ/vMP830DNnpYVPDg4dLKdX2OVI30DxG+tdoo8Qo1MYFW2YON8xbtOo2wSr1XDm86shgzATieda1Z0MmrWg9bZd/tps/n5wzT5FzMzevwLgrKw/3j7/czOyvwhRhQbXMArTXFKJGI6IvbApp85h3TZoY9sqMWZ4iRO7We2UHDgeGbL+K9o19di2u848yrD2tho3wPaMh7UoIy3neIywEh482sKZbcReGe7RgjsLGReNISJv4j27lzISW5GxvzLfiXEBWbuEDx+huUcFXLQABIEdZJjnyhr3FdrLx6YvRg1LazlrUweRnBVo9Eynm+k4/D6WFrozibn44Yj5FqAV8IdPZiaog8em8WBAvUy58oj8eljCL2KD+Nprc8X/WiRlOqdDek1MFmoONky34D2q0twd/6qgS8YRQaVyzEX0gYZF+CwBNO6/Lt/wqJwocSM/joIHgsIbJbn/FIKZAgaEsUVr4b7APWuq67gu6vrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AMheorELXcqZmcQ5HeHnUHMCYQs0lLzk648HkRddbL8ZUT5X2Zgdjz/qHEie?=
 =?us-ascii?Q?oMe7CE7AxdphB4QnoB5CUgR6lSovTVN5m40M9bXgUmbkaOMn/lYu5OMgFhbQ?=
 =?us-ascii?Q?Z+sFP612pgUGk0bQHn6Dy52K16UTZdkn022a9l6WDwR8pVItqiSfwvDLIQAy?=
 =?us-ascii?Q?EVCrIEwAIV5qnYo/ITOy5dqk1hNmKeo+u4T6fAdILsVna3av8w2vDH2KxetO?=
 =?us-ascii?Q?ZBeRtoe4y5jaDYYFp/nE0tzmXnwZ4xQiHLKRjHnvCWDle55q7p60KH0yN2R0?=
 =?us-ascii?Q?B45EvQV7sil8/wfEx70/xz0X5SxYtLfPH7Jzrf/MI6Yxkj5N9L1r2VMiu3TT?=
 =?us-ascii?Q?NTlFwR95FRtDXn3RVWRLBpCAiV7sOKDfpjRKlskDgEWTgbG2DjixTYTuEn1n?=
 =?us-ascii?Q?acRDE3Yv5WJ1vf4hhUibRNexnjYniOvbXc6KfbBz/PHL6eEk2ojysYxHJvkk?=
 =?us-ascii?Q?z3J1+5gF/eimH5vwkZeRmiIzOjuZrpN24UKoxGl56oTjEE4l2P+sf0WpIbn4?=
 =?us-ascii?Q?TWjyGifJhnqcZxaeUu+34jUxychql3E8/sovIzkzrtjSa34Zl38EPVBWTZ3l?=
 =?us-ascii?Q?lDzfe/2AwoRG5iA0HXepZIBK+ktPdB6WTzdtsSERh6sjyqJqFGMnPzndx6EV?=
 =?us-ascii?Q?BNVHkoXF1vSWRGuF9UR7wWrj8wr3RKVBqbh15I9Dw5XAUysvStYnk++pMq5y?=
 =?us-ascii?Q?lK67lEU6cBeUfvKYmGnNSX3GAJn8uNfIaJRfULZtu4YhiEQtny7jZ+GTHuSe?=
 =?us-ascii?Q?imbzz58nmKnepqB83urkdAoKM5i7zfY1wdymLR3kDEEhibljqvmcyFuVPr9i?=
 =?us-ascii?Q?Vy7PHKLa70iGLm/1+HVMdvRXIfDEIU5qc4dZh4rddIY9JGiX14yGr/1pxSRJ?=
 =?us-ascii?Q?YvE2Giq7+TF1fu/gtO0t91ryJ0++c4Qz9pWNGHtsO9Rc/YGcF8B4aixco/U1?=
 =?us-ascii?Q?p5HwRlOy6VocmnfBCQgAyz/U2I+r8uUlPdp3xcGxCO+kI2EGsSdkzbTH3oAj?=
 =?us-ascii?Q?hNKYAACqq4TvfHcM76C4nYvWPPOMjGnRIdcXM0z/xRRbupWxrp24rsULT21q?=
 =?us-ascii?Q?cUSOZMAmU0E7lvBZyRoJj0BzKrDMitrVA3D28cpzajeNzYFh5yf2Nzf58k0Y?=
 =?us-ascii?Q?RIz6TpZV1vWwaN+/GN9iLzZ2Jnq6Qr8oThAvDLRCuKeedT3am1SprW7jI/3m?=
 =?us-ascii?Q?8I6n0GbxH67OdPNmxMs7pO8AqyVLq1x6sodBO0G/QWMoZhDn9BQfey2BzyWb?=
 =?us-ascii?Q?62Ls1MIdV9cH1C4hT0k4iktJDBdmZ6+9uV13X+Lm4j4qz+PCLuMRUH3mRmVV?=
 =?us-ascii?Q?SkVWRAxNZPSwq2oae0UtvCJZ?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8713bd-8e5e-4536-2c6f-08d9576aa509
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:39.9206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KtNmr5M3XnRl+JxcxqvI3oqz8uyDYwDvbUXbAyZY8N90+L6BmDN/11p0ccbyA/7OBIRYZLAlpYh/1jQMRPuuGvo93MzQrQswF/bhosA9Ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-GUID: BrabddEy2zpJyp21LH7AB6UN0kdJcSV5
X-Proofpoint-ORIG-GUID: BrabddEy2zpJyp21LH7AB6UN0kdJcSV5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 973377ffe8148180b2651825b92ae91988141b05 upstream

In almost all cases from test_verifier that have been changed in here, we've
had an unreachable path with a load from a register which has an invalid
address on purpose. This was basically to make sure that we never walk this
path and to have the verifier complain if it would otherwise. Change it to
match on the right error for unprivileged given we now test these paths
under speculative execution.

There's one case where we match on exact # of insns_processed. Due to the
extra path, this will of course mismatch on unprivileged. Thus, restrict the
test->insn_processed check to privileged-only.

In one other case, we result in a 'pointer comparison prohibited' error. This
is similarly due to verifying an 'invalid' branch where we end up with a value
pointer on one side of the comparison.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c   |  2 +-
 tools/testing/selftests/bpf/verifier/and.c    |  2 ++
 tools/testing/selftests/bpf/verifier/bounds.c | 14 ++++++++++++
 .../selftests/bpf/verifier/dead_code.c        |  2 ++
 tools/testing/selftests/bpf/verifier/jmp32.c  | 22 +++++++++++++++++++
 tools/testing/selftests/bpf/verifier/jset.c   | 10 +++++----
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 ++
 .../selftests/bpf/verifier/value_ptr_arith.c  |  7 +++---
 8 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9be395d9dc64..a4c55fcb0e7b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1036,7 +1036,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		}
 	}
 
-	if (test->insn_processed) {
+	if (!unpriv && test->insn_processed) {
 		uint32_t insn_processed;
 		char *proc;
 
diff --git a/tools/testing/selftests/bpf/verifier/and.c b/tools/testing/selftests/bpf/verifier/and.c
index ca8fdb1b3f01..7d7ebee5cc7a 100644
--- a/tools/testing/selftests/bpf/verifier/and.c
+++ b/tools/testing/selftests/bpf/verifier/and.c
@@ -61,6 +61,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R1 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0
 },
diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 8a1caf46ffbc..e061e8799ce2 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -508,6 +508,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -528,6 +530,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -569,6 +573,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -589,6 +595,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -609,6 +617,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -674,6 +684,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -695,6 +707,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/dead_code.c b/tools/testing/selftests/bpf/verifier/dead_code.c
index 5cf361d8eb1c..721ec9391be5 100644
--- a/tools/testing/selftests/bpf/verifier/dead_code.c
+++ b/tools/testing/selftests/bpf/verifier/dead_code.c
@@ -8,6 +8,8 @@
 	BPF_JMP_IMM(BPF_JGE, BPF_REG_0, 10, -4),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 7,
 },
diff --git a/tools/testing/selftests/bpf/verifier/jmp32.c b/tools/testing/selftests/bpf/verifier/jmp32.c
index bd5cae4a7f73..1c857b2fbdf0 100644
--- a/tools/testing/selftests/bpf/verifier/jmp32.c
+++ b/tools/testing/selftests/bpf/verifier/jmp32.c
@@ -87,6 +87,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -150,6 +152,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -213,6 +217,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -280,6 +286,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -348,6 +356,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -416,6 +426,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -484,6 +496,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -552,6 +566,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -620,6 +636,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -688,6 +706,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -756,6 +776,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
diff --git a/tools/testing/selftests/bpf/verifier/jset.c b/tools/testing/selftests/bpf/verifier/jset.c
index 8dcd4e0383d5..11fc68da735e 100644
--- a/tools/testing/selftests/bpf/verifier/jset.c
+++ b/tools/testing/selftests/bpf/verifier/jset.c
@@ -82,8 +82,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.retval_unpriv = 1,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.retval = 1,
 	.result = ACCEPT,
 },
@@ -141,7 +141,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -162,6 +163,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/unpriv.c b/tools/testing/selftests/bpf/verifier/unpriv.c
index c7854d784a5d..9dfb68c8c78d 100644
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -419,6 +419,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R7 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 7ae2859d495c..a3e593ddfafc 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -120,7 +120,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
+	.errstr_unpriv = "R2 pointer comparison prohibited",
 	.retval = 0,
 },
 {
@@ -159,7 +159,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	// fake-dead code; targeted from branch A to
-	// prevent dead code sanitization
+	// prevent dead code sanitization, rejected
+	// via branch B however
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
@@ -167,7 +168,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
 	.retval = 0,
 },
 {
-- 
2.25.1

