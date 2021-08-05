Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5783E18D3
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbhHEPyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:54:50 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:10636 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242533AbhHEPyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:54:49 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175DmQql022022;
        Thu, 5 Aug 2021 08:54:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=p0Klk/qRshMyCt+0KA1h9mJQvMOs4I4kxBn2yHwaHCU=;
 b=ACgP0m2SoezMUsx+Kg/1s438sfpCC3rruM+Oq6q27wK5kyTMnFhIwBsXTmFDGKjJ62e1
 bUGRjWPzKRJyIdubs05aMTCddt5r9TBfMs7vqxXK6XrjPelMJGYtpq33Ro4ZtJox/5JB
 fNXsVr3ByOnqL11Crx8ZGdtVHR8LrnYt28AkPw5VbIiOHkCBIUn95d/SWZ/SPXcK3+ZA
 avI4UOmBjFHEiwK2+68UKqKLKV/e/yDUU0pjZFAqsJQMy4Rd2hWNEiWwz/Zn4bxBbx73
 sWV+NEKK7Cdo+85LPNjh+FIImNNGrC8eW3PzhiezkrFeBxiwW52YsJo4hGFbUlB7m0Dm XA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a800vrrbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 08:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWBFj4iDsjjznkelj9n7i9Pigvq/IgCzDlPvTGzXRmlcqsLbUKTwuu7Duag+LeTrJngTQjEUGcRK902ONDzdQ8lfl3p5gktAno86Ijk6rxcINhGL89PoJyGPrLPHt0b7z2n4ITBIwk9is9Aq9eFuZqY8zR6bauyfkFX2Z6A2BPS/lsZzsIeveplLgud6nUTbiqG87Zp0+93BQ0IY9DQIAKAhSw/SVQ3DmW+7+Am9vJZEoEMcXsFtDvOIuI/cFHhoirK958KSYXgxE6QrGsNi64tC9F/A3LX+zuMgdKP0+EK6a66nebYYcE81CVEAbMAs88AjrdEHulDaGFXE79tEzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0Klk/qRshMyCt+0KA1h9mJQvMOs4I4kxBn2yHwaHCU=;
 b=WPi7kBmd6kjx+tteGEzSFXC9TZVYycGMAEViRM/GnusJodonYRrtn7dstxahoahJU/V9iHvI3zgAIn2SRU5tHv7xVOJAD+ZFn1PZyzKhlElyAhvUf3u/V1drGGpO0xxvTjV6cNocpT0cbPURXzf5Chto8G5oz75c3c8ey+btYNQdmCcimiHz9qbNL/M5epXgWTmjT6If1FN4BA0VOpF07hhx/SKPD2KkxbB5lfM0TVjvlotRmJzXbrRc/6aEwFVpEKji9ZJNgN0yygR3n9/H1vUa+WSrQdG++lY+p+ASbxHHk1w5QkK8RBsJJTJ9PvAReuSrURa3X268Z3HVBeLIrg==
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
 2021 15:54:13 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:13 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 6/6] bpf, selftests: Adjust few selftest outcomes wrt unreachable code
Date:   Thu,  5 Aug 2021 18:53:43 +0300
Message-Id: <20210805155343.3618696-7-ovidiu.panait@windriver.com>
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
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:54:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a71ae07d-b031-4e36-949d-08d958294538
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2204:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2204ADBAE376862C4E0B4F34FEF29@DM5PR1101MB2204.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMF7Ih9dR/VRVzlOVPz7Pq34LTV385zgO3oCJsEzzFhjGp4KAhfPwKaXnvXtr9EdtM3oP50JJaAwBqBKrDvvHthci72OEwpcWXSDQgR0/6KfQ5384hOgvQNvWaSnWNmarVc7vd+crGNP2Hw6/nT96Ujjqc+lKx34kEUeyWivegjYkb62+/vBFFjDLFoJKxgGmH3bT8Q+8bnE08cScZPyAaLmYIr1NX+5d1fC6869qCjWH0RkfCG1+pbhFstjy6+wtq77+UB12UnQiX00aLxFjTba8l82RT2D06gsu6DJ/j2jMP276PLy/tGXKxUu9Z7UmbHK42Sn/1N7K14pkU+UNV2odHMqKQrr4BDPN3ScP9lbDiGJojSQtWmpSv4NB/gJccmSfZx7hLjYosw4XNjkKHpatgiYRuTUFa+HqRs/6URj8nAZyiiibTDYRTHnANZV/JPBUwaREbqNrZMKJ44CaWbBXBYWus7qCsZsbtRp6vsrOrF23AZ1lyYa0n9iVqGs37hkT87ZhLaE01Xq10zFOKS0bvlcsA8Vxhmu/dPXzre+609UfnQwKeDnGte8mqxs9OfhGvgzRYeFwoSzqdjqG1och1EzqHBO5n2MCizz4b7AIWgk1t6KFdkQFfTgLK8KzPhq1Qm+HTtIHKF8yQsn7sQWePYsL0u1cLXcaEjZ5rx2zUDkrO1+LBpbuOvGmjZiEfNxkCiP+pauQlTWN8GtXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(396003)(376002)(366004)(4326008)(2616005)(38350700002)(38100700002)(956004)(6916009)(66946007)(66476007)(6512007)(66556008)(316002)(6666004)(52116002)(86362001)(2906002)(5660300002)(8676002)(26005)(8936002)(83380400001)(186003)(1076003)(6506007)(44832011)(478600001)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4FUuXMmp0R+o3Po+EJQinod/2DSC0TGpqxPQngAspNH5vSYcMeXTXyvCY5Vu?=
 =?us-ascii?Q?wM7ewCsuWYzl9v2FXjR34G/S4Ud9xi+9NRcxR6VIA51kMbFZ/ncs/mkPI59r?=
 =?us-ascii?Q?PQPBLDZYLmwl8sQzjg9ilmfYHCME+AtEB1zJjJt6baebIX2W5NJZsM1HfXPt?=
 =?us-ascii?Q?hlYBopkHi03zUpKdIUoKDnMHn5PTkPN71gFe+2XReR20Pw8VFtxpxjp8RqBy?=
 =?us-ascii?Q?OQZk4MoMUe4pOVeHqHgjEiqU2UjnFIFO8U80ROwU69qu3FRYFtafTps6KRq/?=
 =?us-ascii?Q?P5N7mnMW0cXKPcuPu2B6NpDooCmnN1pkl5t1ZPae2eyKGDIPsxpLNqumQw2u?=
 =?us-ascii?Q?T4IzQBTe//ZTbsYXApD0HmW3/wOOI7iqIDCzhqtMJYbMlZ8wICC1AKQcGyq8?=
 =?us-ascii?Q?3DK8FqKSckQ5U5FSmGHQEciThtqjn6bcX+Tx9s0fov0bCoQywcszH2+W895T?=
 =?us-ascii?Q?shMOInlC3uPRUnbnRUe56aEmweLTppyt5biNTGuwt7mRIy/1X8jaW9V/KTfC?=
 =?us-ascii?Q?+W1GCVKPxqMlEqDPGx+TW0B3sBHxxuUlylfeLmrfyXG7lx5zUQwc3nNdOgoQ?=
 =?us-ascii?Q?i7PwHoRUUtkvDOJ2eaXu+sNqGWhkPFWrkoERucAmnYAdcSV+uB2w7f4Innjd?=
 =?us-ascii?Q?pblHvPPmvmVSTdiL+JTjyIX6ShphLp62CG2fagM7FQ/2hGkthZRFYm1npkZe?=
 =?us-ascii?Q?/nHT/6wH01Xnf+dJ7rOtbCYuZKPBfUBO1ge2wxQ4Hct9esIMwAVTLtQMhcQN?=
 =?us-ascii?Q?ksld4WBEKtQywKq0kG/f9LZg21Gpq4K4TOsASIP7mO/7tcf/B1WDPp2kXuAt?=
 =?us-ascii?Q?M/lB2aOTzNL1i0PBd4ispoOaVG9wD7dm4CxwNbYIAOGFHMrnpSPM2SQrJSiO?=
 =?us-ascii?Q?svp9AUVbvnkLB2Rc5ruIsr/oPPrjqU97D6FYE0OGXH65G6ubZts7M+1DUvWY?=
 =?us-ascii?Q?7maEcXogG95NXJA4I3r7WK8/2/HTBVeXCj3aMHGrneORdZjkJt/l6Y6FqUXm?=
 =?us-ascii?Q?YLKgtUJ3LxF+1kD/X0DIjYEELMJ9Nx3pV5Pld4WCoSmV33Udsomk7Cmke0LD?=
 =?us-ascii?Q?FIa0jyeirKXTDXFW6vQgkRFCdUDq7qa60XDQXMggHXUL1fb2uz2hjNy4GF5P?=
 =?us-ascii?Q?wtf5tF/ipm9WrfzHEaok4jvYx3HfgGr46YPRvXdd0BfgahyfOeNx4zWfOdXh?=
 =?us-ascii?Q?g/45MkcfQzvv5UxLD7ncEHsbQqnKpkhT3E5reCmSvMDyrC0K8omebCsa+T+V?=
 =?us-ascii?Q?+J2zaOCh7IYfTJsHX7NPt8nOg75F/yUlzueEteIj3x8SDYgRutuMonDkWO84?=
 =?us-ascii?Q?ldZ1fj7ZyoCz1IkBOfw3Vg9w?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71ae07d-b031-4e36-949d-08d958294538
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:13.1419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Y4iJNoENgZK6s5aEJLz++Yx81jgUo+Ro03+5bdpbVlKIMVIuBHk20079RVVDwv3XiP/qpjyxPi2KUgElBkCOax7yT3Z/AabwJ8HWOvyVCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2204
X-Proofpoint-ORIG-GUID: 3rqEK7h9jonCeUG5GazLPR-fE0BFwqhU
X-Proofpoint-GUID: 3rqEK7h9jonCeUG5GazLPR-fE0BFwqhU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-05_05,2021-08-05_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050097
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
[OP: ignore changes to tests that do not exist in 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c   |  2 +-
 tools/testing/selftests/bpf/verifier/bounds.c |  4 ++++
 .../selftests/bpf/verifier/dead_code.c        |  2 ++
 tools/testing/selftests/bpf/verifier/jmp32.c  | 22 +++++++++++++++++++
 tools/testing/selftests/bpf/verifier/jset.c   | 10 +++++----
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 ++
 .../selftests/bpf/verifier/value_ptr_arith.c  |  7 +++---
 7 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index d27fd929abb9..43224c5ec1e9 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -980,7 +980,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		}
 	}
 
-	if (test->insn_processed) {
+	if (!unpriv && test->insn_processed) {
 		uint32_t insn_processed;
 		char *proc;
 
diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index c42ce135786a..92c02e4a1b62 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -523,6 +523,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -543,6 +545,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/dead_code.c b/tools/testing/selftests/bpf/verifier/dead_code.c
index 50a8a63be4ac..a7e60a773da6 100644
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
index f0961c58581e..f2fabf6ebc61 100644
--- a/tools/testing/selftests/bpf/verifier/jmp32.c
+++ b/tools/testing/selftests/bpf/verifier/jmp32.c
@@ -72,6 +72,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -135,6 +137,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -198,6 +202,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -265,6 +271,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -333,6 +341,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -401,6 +411,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -469,6 +481,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -537,6 +551,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -605,6 +621,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -673,6 +691,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -741,6 +761,8 @@
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
index c3f6f650deb7..593f5b586e87 100644
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -418,6 +418,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R7 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index f9c91b95080e..188ac92c56d1 100644
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

