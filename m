Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD423EA8FF
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhHLRBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:01:34 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:27864 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234122AbhHLRBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:01:33 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CCk0Ki010817;
        Thu, 12 Aug 2021 17:01:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=8SX2RJnPWkuH/S9lNKQDu/SEjBtaWrphT62kmL0jXNg=;
 b=fb0QGKQsP84u8TScy43ZetLR/30O4Ci11HeFLeWQ6WMGjBa+6NPRYo7bXOmiZYADm6xl
 1jXeshknq2ace26KPUN/BBRTRCvYzJqLOW+J+XOnYtRYv4AyTQKp1YtEGhORROS64ILh
 lgj2m40heqGqUsH4CYLepxyurE3RXuP6Pkzl+db7U5MEXRHDRazsfcvyK7P2RszAhtc4
 HrybLWJ7QifOW9RxXzm63Zu5xexgM3qqi5/eHe6R6s1sYSRJ1t5EJyISbRd0HK7Yirt3
 ZYZkE9W8vB//KpjUB6EGOj0SwdMZzTQY7yW8Lr9xXoTgnDZtLG8Th1dZVDJxWt9+M6ag gQ== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by mx0a-0064b401.pphosted.com with ESMTP id 3acsen0jxg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 17:01:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4zXZE0N/uEi8eebv1MWK4t7jbNO+jsw7ouRDCoVZ50ABf734abXBRaexG7nlfDpXWwsxslBqfG3lOb3htvwPFXH9aSpzsmoEEKLfGYtfYs0RrKg8PFta5cvBrsp860rh4OVCbhCGfSH/nWTClROuJcssCYpRH7Urn3+r08Z5G1xeqEiYOgyhFzSUSMzT9t3nz6+py/axKoWfCWHLMTwSDRCHuLWSFaUACC/b9K6OdPkytY1LBVp8jEtTtSpwO0/MEuKl2EzLNN6Eb0qjCAay1SntgvqcqVI1CMRk/s6dmv3kBPz9kAN5ujCio3NsThKfD5oVlPNyIc1OXbHXWDkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SX2RJnPWkuH/S9lNKQDu/SEjBtaWrphT62kmL0jXNg=;
 b=bJ1yYA0dI1kt9+v8mPGdn5Rk1Pvpdbm7GCUAudRhmH4P6+4Qeaq52h0fjibApWkO4V9o3iYgNFpjgbAQj44rN4NiKfIGpBMLtwLR1Ka8di6I/wE2SfML9N6F9nxuuKTprlNi1THdnDv9UKIPuNXk4pQl9MUqTKhdMzQ5SuCw2uyVNdcOXO2cF7sX/KM+88PQkQNhl/QM+sr/rNxNf+H1uJP7h8d54VlQbdLH6VGfsmiptldvQW68ZHSZqzk1bJmdCy0+m3QQ99EUUU4QWetC7NHGgR2Bj0EfoTJ+/eeDOL1T7tMpnPxKes8SlY+9cW43O4ci/IEeQUaGh8TxLeMNLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1593.namprd11.prod.outlook.com (2603:10b6:4:6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.17; Thu, 12 Aug 2021 17:00:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:00:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH 4.19 3/4] bpf: Fix leakage under speculation on mispredicted branches
Date:   Thu, 12 Aug 2021 20:00:36 +0300
Message-Id: <20210812170037.2370387-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
References: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0251.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0251.eurprd07.prod.outlook.com (2603:10a6:803:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 12 Aug 2021 17:00:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a14d750-cef2-4c74-04b3-08d95db2c24b
X-MS-TrafficTypeDiagnostic: DM5PR11MB1593:
X-Microsoft-Antispam-PRVS: <DM5PR11MB15933BFEB0946BA371ECEA8CFEF99@DM5PR11MB1593.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYQvHyxAF2uA2TRNHuWclaIslScJKNcrFayOMFEITwKqwa1SOBIco2+462br9O477OCSJ5Kdd8z4J91zN8MRZTzOpDtP7j550OwRKe+JFaRU+HC9IS755M+KPrO07ruIBjLE0SS2Wz7LTJKSuW69LQ/AVotK6THZiuz5pZb2pAbMMeOwVHzxy2OVQAOmrAHMywdHmMVL3GPwNxg87miGuJAQdRG/72Z/kP3ktCsHvjZ6gLWu1yG2u/Y8E39hSHcIfATr/EEQegY5ooAkuEphdOgGDA12Tnm0i3rm4cVBbbyOGKka6LVMGHXqUgDgkb4lM9LULfZbMtuH7JMvGyGxCFLBIfrrPfSvpoY1Qy3jZLMCFqjjXtsRWon05KYR4QCosTwy8UQGm+v6tOiwXqhqHgLVGQ0SNqpg2LNMSLkXhsmQGQmBUgp4dVgA5JKv2JWwnziPM+D7nWN6HnpzxJ8vhwu2Z9bsvG+eT//QtaEWq+JkP8hvca7yJMqQX9sV3J51kqiftSnTz5pefSeBRBrSdm7iA4+Fhuw/WKQeKuuBpabH3ZG+UZ8M63P6HRvZZP7TsNgEs0Fku1uukYtHwd0Pxdn/2ZOmJOHM71xML263t2bvt9tW/LkYXzAZSqynDEBeqCZeTzfDb2yW54sNiXCP2C3T0zaHHgPZrPbEXo7rT9iUT70rK3F6rcI8fTx4BzUO5GfCDuYzAsyaeXOfHqLZvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(346002)(136003)(376002)(26005)(66476007)(66556008)(8676002)(44832011)(6666004)(316002)(86362001)(2616005)(8936002)(5660300002)(186003)(6506007)(52116002)(956004)(66946007)(6512007)(38100700002)(38350700002)(4326008)(450100002)(6916009)(83380400001)(6486002)(1076003)(36756003)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EfU0JpKGw6OHJr6+a/4EwJ67jUk1HqAmzgWirVjX0zmhlFShuyZhMZlpn8Yl?=
 =?us-ascii?Q?caN3mX86qZFdpJJAvoThzQ4TWyP5wCHO9497Rjxn/xFUTqPcjMbywNScsgti?=
 =?us-ascii?Q?D58Nv5FFnRPq1DMprZBh9MtbsNYp7hmU0AXvWMz9QgebpfAUra7T1K8bEWfn?=
 =?us-ascii?Q?9scrLqcBHp+FcO9rkjhQhXG4Tcn5L9WfVMgysRNAh7SddZFz3xCXkbtCHgAO?=
 =?us-ascii?Q?fU8iBXojgD6uawSSQCfk0v9w2Dnm7omeQxFQNdvjhYVILYJS0t4XHGKCZVGp?=
 =?us-ascii?Q?MET4utjsF0a9W+J3XNkgXvmPJyfQkH/ni2EBbiXc/brTopQrtx9/ssbN6Lyj?=
 =?us-ascii?Q?mstNGVA5XQZT61dCQHdrgorGbepUdjX/bK9Vvql/CN+noZsnpqf3MYChklIV?=
 =?us-ascii?Q?nwlDxYpTUrTEyOW5KFB/b8In3Zeek7kbB8XzVfdycUKDrbkvhSdnBek+j5oX?=
 =?us-ascii?Q?qcCU/Bbfyv+Ci3p1/cOyZuynOycyD10gJOiVqWVPvrohvGBuJj+3Q18e1S6s?=
 =?us-ascii?Q?BcQVp5K+e1nesOITJt+VGEvsM6e0Q4mHgj24pi0wYOKA+QTIFF5wSamM+NKx?=
 =?us-ascii?Q?bpYYNf2TMQE942qPmXPNaLr4zD/NG6jU6ITrAp4GMSemky3yDb8IyYlU2Zi0?=
 =?us-ascii?Q?7W5PMGsmm2suF/+aqDOV/gZquHwXLX4L8NabQQrByYKcIbT8mTUq2qZOnuyW?=
 =?us-ascii?Q?aSdgoDGeCJnWJh6QPxByqKXMaEqLCWYT6GcLq7yF9tYhvAisPbYZKXkmfT1x?=
 =?us-ascii?Q?36rOa/wl1TKBzIyAPQyePxBe1Cjt2G0ECvMCXB57s1MfjYz5SYPRgCFkST9b?=
 =?us-ascii?Q?3TfuroZsZMmMtPqeEFY4SbNiBRr7iAyyu4qHbB+TqH4XCPuJi3janO6P78o0?=
 =?us-ascii?Q?LwWAMAyLN+e0cH0XlL+rZTMEg2D0qIe/NhzTokZFGgSzv5zXcfSc2ixYdIms?=
 =?us-ascii?Q?sSOtM6pNmntoAiHPLqfnCOhq7nbC6WUr+G0vY9ZVV8F/eEPOyTfFkgKhgXKM?=
 =?us-ascii?Q?o8Wq7Bhq0nA0udgMgRka7nsM061oF5MSlrsxPS3MnF2wk4HUQxTHRI3G04cE?=
 =?us-ascii?Q?XpslS48TtdgISNHQNlXlsU+rE227Wi5kvc5aKjBWZB4U1UH+D93DIRbj1YjU?=
 =?us-ascii?Q?A3znzi0l10ypH6Ca9/SDrFKqTeFJlnktBk0Hr/9cyuA9Kitp2yR2WOkkVmpc?=
 =?us-ascii?Q?TA3pl4e1kG4FXpdr3pb8IUgx9dXXDmXJY9YHcp42Dv97waL1QA2donrZCexW?=
 =?us-ascii?Q?EuEnMdbYTwAJMAePIkjoaY9qH2G98SOFMTdpxaOo/UTvoZ3MjRYWW+6ThfBq?=
 =?us-ascii?Q?uA0ZSGU0WwSdeQMTTXpF8/i7?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a14d750-cef2-4c74-04b3-08d95db2c24b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:00:59.6387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjEYh1+5kngX86Jj5vdUHN7MdYUGPsVDkVeo0Fr5oc8c2AYD8grRHmv3OtGC3z+vPGQOPzJjCObOd4Mt8iChsPgzTfbH/jg2HxeRWrCrl5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1593
X-Proofpoint-GUID: V3cHWyzh-r08XuzA1OfLduljSXzdcIUs
X-Proofpoint-ORIG-GUID: V3cHWyzh-r08XuzA1OfLduljSXzdcIUs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 9183671af6dbf60a1219371d4ed73e23f43b49db upstream.

The verifier only enumerates valid control-flow paths and skips paths that
are unreachable in the non-speculative domain. And so it can miss issues
under speculative execution on mispredicted branches.

For example, a type confusion has been demonstrated with the following
crafted program:

  // r0 = pointer to a map array entry
  // r6 = pointer to readable stack slot
  // r9 = scalar controlled by attacker
  1: r0 = *(u64 *)(r0) // cache miss
  2: if r0 != 0x0 goto line 4
  3: r6 = r9
  4: if r0 != 0x1 goto line 6
  5: r9 = *(u8 *)(r6)
  6: // leak r9

Since line 3 runs iff r0 == 0 and line 5 runs iff r0 == 1, the verifier
concludes that the pointer dereference on line 5 is safe. But: if the
attacker trains both the branches to fall-through, such that the following
is speculatively executed ...

  r6 = r9
  r9 = *(u8 *)(r6)
  // leak r9

... then the program will dereference an attacker-controlled value and could
leak its content under speculative execution via side-channel. This requires
to mistrain the branch predictor, which can be rather tricky, because the
branches are mutually exclusive. However such training can be done at
congruent addresses in user space using different branches that are not
mutually exclusive. That is, by training branches in user space ...

  A:  if r0 != 0x0 goto line C
  B:  ...
  C:  if r0 != 0x0 goto line D
  D:  ...

... such that addresses A and C collide to the same CPU branch prediction
entries in the PHT (pattern history table) as those of the BPF program's
lines 2 and 4, respectively. A non-privileged attacker could simply brute
force such collisions in the PHT until observing the attack succeeding.

Alternative methods to mistrain the branch predictor are also possible that
avoid brute forcing the collisions in the PHT. A reliable attack has been
demonstrated, for example, using the following crafted program:

  // r0 = pointer to a [control] map array entry
  // r7 = *(u64 *)(r0 + 0), training/attack phase
  // r8 = *(u64 *)(r0 + 8), oob address
  // [...]
  // r0 = pointer to a [data] map array entry
  1: if r7 == 0x3 goto line 3
  2: r8 = r0
  // crafted sequence of conditional jumps to separate the conditional
  // branch in line 193 from the current execution flow
  3: if r0 != 0x0 goto line 5
  4: if r0 == 0x0 goto exit
  5: if r0 != 0x0 goto line 7
  6: if r0 == 0x0 goto exit
  [...]
  187: if r0 != 0x0 goto line 189
  188: if r0 == 0x0 goto exit
  // load any slowly-loaded value (due to cache miss in phase 3) ...
  189: r3 = *(u64 *)(r0 + 0x1200)
  // ... and turn it into known zero for verifier, while preserving slowly-
  // loaded dependency when executing:
  190: r3 &= 1
  191: r3 &= 2
  // speculatively bypassed phase dependency
  192: r7 += r3
  193: if r7 == 0x3 goto exit
  194: r4 = *(u8 *)(r8 + 0)
  // leak r4

As can be seen, in training phase (phase != 0x3), the condition in line 1
turns into false and therefore r8 with the oob address is overridden with
the valid map value address, which in line 194 we can read out without
issues. However, in attack phase, line 2 is skipped, and due to the cache
miss in line 189 where the map value is (zeroed and later) added to the
phase register, the condition in line 193 takes the fall-through path due
to prior branch predictor training, where under speculation, it'll load the
byte at oob address r8 (unknown scalar type at that point) which could then
be leaked via side-channel.

One way to mitigate these is to 'branch off' an unreachable path, meaning,
the current verification path keeps following the is_branch_taken() path
and we push the other branch to the verification stack. Given this is
unreachable from the non-speculative domain, this branch's vstate is
explicitly marked as speculative. This is needed for two reasons: i) if
this path is solely seen from speculative execution, then we later on still
want the dead code elimination to kick in in order to sanitize these
instructions with jmp-1s, and ii) to ensure that paths walked in the
non-speculative domain are not pruned from earlier walks of paths walked in
the speculative domain. Additionally, for robustness, we mark the registers
which have been part of the conditional as unknown in the speculative path
given there should be no assumptions made on their content.

The fix in here mitigates type confusion attacks described earlier due to
i) all code paths in the BPF program being explored and ii) existing
verifier logic already ensuring that given memory access instruction
references one specific data structure.

An alternative to this fix that has also been looked at in this scope was to
mark aux->alu_state at the jump instruction with a BPF_JMP_TAKEN state as
well as direction encoding (always-goto, always-fallthrough, unknown), such
that mixing of different always-* directions themselves as well as mixing of
always-* with unknown directions would cause a program rejection by the
verifier, e.g. programs with constructs like 'if ([...]) { x = 0; } else
{ x = 1; }' with subsequent 'if (x == 1) { [...] }'. For unprivileged, this
would result in only single direction always-* taken paths, and unknown taken
paths being allowed, such that the former could be patched from a conditional
jump to an unconditional jump (ja). Compared to this approach here, it would
have two downsides: i) valid programs that otherwise are not performing any
pointer arithmetic, etc, would potentially be rejected/broken, and ii) we are
required to turn off path pruning for unprivileged, where both can be avoided
in this work through pushing the invalid branch to the verification stack.

The issue was originally discovered by Adam and Ofek, and later independently
discovered and reported as a result of Benedict and Piotr's research work.

Fixes: b2157399cc98 ("bpf: prevent out-of-bounds speculation")
Reported-by: Adam Morrison <mad@cs.tau.ac.il>
Reported-by: Ofek Kirzner <ofekkir@gmail.com>
Reported-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: use allow_ptr_leaks instead of bypass_spec_v1]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 44 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 566eeee5e334..2bf83305e5ab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2812,6 +2812,27 @@ struct bpf_sanitize_info {
 	bool mask_to_left;
 };
 
+static struct bpf_verifier_state *
+sanitize_speculative_path(struct bpf_verifier_env *env,
+			  const struct bpf_insn *insn,
+			  u32 next_idx, u32 curr_idx)
+{
+	struct bpf_verifier_state *branch;
+	struct bpf_reg_state *regs;
+
+	branch = push_stack(env, next_idx, curr_idx, true);
+	if (branch && insn) {
+		regs = branch->frame[branch->curframe]->regs;
+		if (BPF_SRC(insn->code) == BPF_K) {
+			mark_reg_unknown(env, regs, insn->dst_reg);
+		} else if (BPF_SRC(insn->code) == BPF_X) {
+			mark_reg_unknown(env, regs, insn->dst_reg);
+			mark_reg_unknown(env, regs, insn->src_reg);
+		}
+	}
+	return branch;
+}
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
@@ -2895,7 +2916,8 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		tmp = *dst_reg;
 		*dst_reg = *ptr_reg;
 	}
-	ret = push_stack(env, env->insn_idx + 1, env->insn_idx, true);
+	ret = sanitize_speculative_path(env, NULL, env->insn_idx + 1,
+					env->insn_idx);
 	if (!ptr_is_dst_reg && ret)
 		*dst_reg = tmp;
 	return !ret ? REASON_STACK : 0;
@@ -4288,14 +4310,28 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		 tnum_is_const(src_reg->var_off))
 		pred = is_branch_taken(dst_reg, src_reg->var_off.value,
 				       opcode);
+
 	if (pred == 1) {
-		/* only follow the goto, ignore fall-through */
+		/* Only follow the goto, ignore fall-through. If needed, push
+		 * the fall-through branch for simulation under speculative
+		 * execution.
+		 */
+		if (!env->allow_ptr_leaks &&
+		    !sanitize_speculative_path(env, insn, *insn_idx + 1,
+					       *insn_idx))
+			return -EFAULT;
 		*insn_idx += insn->off;
 		return 0;
 	} else if (pred == 0) {
-		/* only follow fall-through branch, since
-		 * that's where the program will go
+		/* Only follow the fall-through branch, since that's where the
+		 * program will go. If needed, push the goto branch for
+		 * simulation under speculative execution.
 		 */
+		if (!env->allow_ptr_leaks &&
+		    !sanitize_speculative_path(env, insn,
+					       *insn_idx + insn->off + 1,
+					       *insn_idx))
+			return -EFAULT;
 		return 0;
 	}
 
-- 
2.25.1

