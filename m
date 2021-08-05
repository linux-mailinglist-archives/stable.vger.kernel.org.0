Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9633E18D5
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbhHEPzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:55:07 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:19002 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242655AbhHEPzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:55:06 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175Ex0KF011530;
        Thu, 5 Aug 2021 15:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=/mGwi6NzSI7Tlkb12OCPR1UbWMIF+pdtna90Yctou+U=;
 b=LH6mz1SnkxZ/QIIxInbCL1wECxrfQlbqaCdOrv25FkIrB6291+fbTjdWPDj/RlWhkUEd
 MEmr6YKRoxNk3cQeab/Dp1YVc3YzsnxY0tc7KMfT3FflJJX/w7EeUSxd4BuwgWvVky8q
 cYaTUZRop79X3V2IhsUvwk6ltpLKLKqjk0CPSJ4mByX6hSGkEbsdIt3QEw32oGKsQgu2
 4cNWSbmgmUS1oGbuoXdo6x5NXkNTMoSm/4+mujEje5uguM2OPLzlKGWDAg5PeqJJHNr9
 o+yTA+C/smE88NSg4DjkGBfA8zbvTMb5eQJhSMcrNAew5jcjEALUguDY37e7tkx6XRGY Qg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a8gny05bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 15:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGz98YHxKAU+HSymaJhySJl5GQjzfzKNzPgUcS12FwSoG375YvC1BqvKv4sIguSgXd5LkQRcw66s5A6eweLeW6dQPy3MJfagO0MnvscR4P2idZb8L0BlsdoU+X8/Wb5B472ZckTKUqdFFWAUnaICv7w9OlnNKeTnzB1eGZmOUmUVGg88hkZILz2bCcsA8hpROQQg1IQDWcayRXxJzQ4xbtG1u7YZIQLLikPwwNKUeF8VIKPmyRhpzttx/+sb3CBko4iQL/vy6OUl2+Z7QiK9yFibSMKYJUDL1o9jv5067nQxSmvqdL5QbLlnKL1Rjss6g0nEaCEWE9bT7sLXm+GezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mGwi6NzSI7Tlkb12OCPR1UbWMIF+pdtna90Yctou+U=;
 b=BgUcKYYNAt3LN4qNf+vg39URroUzz9Ea20NiydUrobFhOEBveVe9ZmnH041GelMYfkxWnOghZ1aP7P8zSkID0W8ATdTSKIfwSIZlP+94rXxuR5ZZCIc7jDMDXlBepTH05N0eKT0H1jEA+hr6b7CCx4vjworQXYnv1VUedeaUNTGrJ77wI1klc/6gA2EObte0HpWzcdFHTG1bJVIyExe8FwDQXnUmtRsoploJ9njfsL5SrAV6KmONEiuni0ufS/Kzzb8IRdGvp4X2qDbF7SWBkFcXI2wK+Y8NDySDw/alJZBm3Ql+5uTHAQn1ShOdLn8eoTMmoGUcu+5RsfnjpD1yhw==
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
 2021 15:54:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:07 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 3/6] bpf: Fix leakage under speculation on mispredicted branches
Date:   Thu,  5 Aug 2021 18:53:40 +0300
Message-Id: <20210805155343.3618696-4-ovidiu.panait@windriver.com>
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
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:54:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d02204dd-30aa-4841-e0c8-08d9582941d5
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2204:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB220473828E0F2BA5C1C30915FEF29@DM5PR1101MB2204.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjyfOm5Mf8qdo5jKYGEXY8jQnBfsjWcbGJuAk/foOuqSNl5JVJ+ruvPlf27I19J3HCbUIVLPoYzeTwTxC97OYOQuJhfnN1wwG39U/E5TQv3yBY6zHjO7JrMgS8VfRoY+wovOEFLbpsgHsM9HP2SGsL+W1z+bTnJSoLyGwZbKgWcd/Drt09kzU8XTK8XrB9oIci9tMLCJw2KX+KHIwMhi3G7bfUpOmqU0DXCVO7ycNHjV84gDusx5GvysexPRlpNEksQ6jh7rZVyAjrXp8S+WB69lhvCceRmHIcYr2mrRTsk5Ki5huj3Mnwj55uPHb0vlu46u3d4RogiuXOVUeIiprDXG7298ZHwnkPDFkAh/f//3Shf6B5AocVL93MnJNbziIv48TvBYE7ImpKtEUQ4beo6JkKdjs2VTHmqCVSyhfQ4DH7G6PLjDNqKEQqXPVyUQmRiKM+74VsYKjbxIs2udu+w88nv8HpZwXctTwrE8BxUXsjxK517ymhf2Zob8sGYo1QWdDtoLXFJxSjVkjNexNcw8UCb0AH678jPxs/z+hvT8MFA9a6pIcFN9/Vgpk5t4Vvu/HhOS10AzEemV/9jX/9Yx8ATFY4z/6IyohcFK25LnnLl6H/KfDsOUPjXPfistYlvlAAcARwG9GNQul9SuEqzTRrTQvT4U/3IrZMEpkNUDEbeXIUyBPlTwww2XsVG1eunVC4gBcInrJyX+3nWpgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(396003)(376002)(366004)(4326008)(2616005)(38350700002)(38100700002)(956004)(6916009)(66946007)(66476007)(6512007)(66556008)(316002)(6666004)(52116002)(86362001)(2906002)(5660300002)(8676002)(26005)(8936002)(83380400001)(186003)(1076003)(6506007)(44832011)(478600001)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7f4RRnj6U1/wRtzODEck8ymAS0svlHYHHgjN27eL5IJzafSuw00KznfuWuNx?=
 =?us-ascii?Q?LOKZ80OyqLqhY43X/MYXag9g/vLv5CGfZPThSiAii7m7itW1obJz/XZtJyKm?=
 =?us-ascii?Q?yzoOBmeRbMH0XcufdkNjp276N+rt0MFJWZNkz59UteIhkZwdj1GyiSD2196T?=
 =?us-ascii?Q?fMC4ZgXEt+pEJFYewwYnlTa2yExcR7Hi3DlElzFbCYM7emaEqnVin1z0mfYO?=
 =?us-ascii?Q?sF7/ivi7y/mnbBTaTK0moljudwRNAmh7FPeiYTig3c63k8TOi7UHcWyUEn2Q?=
 =?us-ascii?Q?TtIvs5NfaJ45DirdvD3RtbRNYFYFucfnDPOM70o931hXV9ui0dTJqedAg487?=
 =?us-ascii?Q?fb3TTXMd/WdXq+x31p9fapvzaDBr3PnikBctsmdvRJed3e2zo8Xp7Onf5X+l?=
 =?us-ascii?Q?uwxcUvwVQTwSRBqwp09lQr8qcPt1gpZY2SQSDs+DdR4/LcGkH9F0i7620xtH?=
 =?us-ascii?Q?cSxta942svreWa+G9O2HkgkCT0PobZExLs671PN7ZIBfwgBgeDKSz678Bb0l?=
 =?us-ascii?Q?ot2P3sllumipGMnEmv/R2i8mRLMb/1zeOfurWZM/yTOlPebN4L6PfpURItxR?=
 =?us-ascii?Q?xlHlh3an87ntRLRUwyzCCKuLhMXcdIiU6gK35rFGQvU6efM4aDCcLqmbF7Bk?=
 =?us-ascii?Q?sq4yYcdNoCV2/3dOeY2ySsqThf+JD/OYN05AY8SInABkb2HcnAMZsEzU3QOf?=
 =?us-ascii?Q?p7mlO6Cwj9QgpA+n7uu3AmO9DWEp2+7wnJ026EpdWTy04rMTHyRISAbfZlTb?=
 =?us-ascii?Q?GVL57NDlcBAZrfpOaw0AOw7bD13U/KhsgxWl8gHkWNg0fjVdS2b8OQVqj+j9?=
 =?us-ascii?Q?zYOQ8TVH/UZ3NJBcUlOC36ibGVTZHyLuTcO0dN8Rrk5uCJ0f8K0YndLLAkLb?=
 =?us-ascii?Q?7LrwW09Ho39Yq4EfuoUv3Hs9CGNxh7XjUwJvZXST7wT+RfujDM0Lhla5lUUU?=
 =?us-ascii?Q?VLHPf+th6fy2RK4PpcNM5KIhckgqlFyO6v+KEP01NF0JhtWrIsZrqAo9DsDm?=
 =?us-ascii?Q?QZEBymStWfRu4BIqDJ0rUAOWoRMBbI4dl1thPdVtDhYw9pmoTA454v4A7vWv?=
 =?us-ascii?Q?ol6wLWJA5oSJlnmuWSHM7po4fN2QK7d4KkaYm02kvalwoRrm2B6AMmilyuuE?=
 =?us-ascii?Q?0MD0bomj5Y4+GfDySHsdtrj9Yg2DyQH+XZBMh/BWmZpz8KWSaSrCXpbtqv9D?=
 =?us-ascii?Q?RpvAsxqfZQmBBPUifoGodrL9dNmv0ufxhEQX5ItVBCRC5KTmT0FTRIAI9eVS?=
 =?us-ascii?Q?tExqCeTNrtf0RmguLkFoNzS0f44eRexl1BQ4YB9DayS/SN9M0t4TMhj1lUgU?=
 =?us-ascii?Q?NiBTCN312kv0EZZpHvNHsv8r?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02204dd-30aa-4841-e0c8-08d9582941d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:07.2648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11qPx8aWWswb/6TOOtf9cqg6+cpCm4WRqH1LZwcYCT8zAfYVAmqrQ68QJAfQvPnmMxye1HCA43TkMFoz07Oc5nK/f1usDKlFOYJCqvJ9fFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2204
X-Proofpoint-GUID: bTiTn142HcJEZqbywwHQpg_7zk0cRjMW
X-Proofpoint-ORIG-GUID: bTiTn142HcJEZqbywwHQpg_7zk0cRjMW
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit 9183671af6dbf60a1219371d4ed73e23f43b49db upstream

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
index 02a04a30070b..52c2b11a0b47 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4346,6 +4346,27 @@ struct bpf_sanitize_info {
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
@@ -4429,7 +4450,8 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		tmp = *dst_reg;
 		*dst_reg = *ptr_reg;
 	}
-	ret = push_stack(env, env->insn_idx + 1, env->insn_idx, true);
+	ret = sanitize_speculative_path(env, NULL, env->insn_idx + 1,
+					env->insn_idx);
 	if (!ptr_is_dst_reg && ret)
 		*dst_reg = tmp;
 	return !ret ? REASON_STACK : 0;
@@ -6079,14 +6101,28 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		if (err)
 			return err;
 	}
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

