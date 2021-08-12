Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5203EA8FB
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhHLRB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:01:26 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:35290 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233901AbhHLRB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:01:26 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CFLX85028069;
        Thu, 12 Aug 2021 10:01:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=22JUZi+busK9gD1zI/M6JQ9ME3f19AzyGRuh9I3KKHU=;
 b=YtBuvkoLV2LldO/pWi/dxqU5oZHsnroScCcRmTIBOuciczSAuNls+nSTHYSJcDb4ITZH
 XF/rVYy8H7aUkzn3ic7BVVgy4aPIV1LU8Ju8tPjubb5K6tAcKil2t7572d1q2Sst4GYs
 DiAptGnqFwVBp7Hw4pw6EeXMh1YZsDKvlHNROIeF2vO/+spZa9eBtJ/4JSQ9OdUSyRb7
 bmdUO8/HIH0ly07EaBZ0eSYBsXDMEV10jqu2jfdg6bi7YXkh+H9XNk1qEqVVsBwPBzvh
 5UdUCXfzwbmf7yJ9bxB8fWSv+LFxz7EEXGJ2HNWslRYdvlBCxGit0zUofy08agpuZmba IQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ad4wug5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 10:01:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY0xaXAjjJgpgkDpObOUszzXEVV2eYSVnEmMqAf7qG7YTrV/Us2vDm5n+rWoUVQ6YMyA9wrFbwitPkoMlNPJEA4ycA51LVwf1GaQsyNRbuyK0Jo7HyIKEoKIdS7yRW1u12BpMdJRaudNUcL48fTb6cr2OggNMRqnSWLI7RMvTSMPTIAAjHyjPTGNw99uQAz7X+QQVgddqTTfBlPHt5k9qE8jGNRcBsO1uVB6VLebKOUh42EdeUtMwzIzfSby2+JQJo5fTaUgBsTkBBuxyzy10QOgxW3NbB/1eqpahwpJ1KjSYqpQDYY4JFdYaCzwQ/vxzYbgYvfZEGdTDX3wKwidPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22JUZi+busK9gD1zI/M6JQ9ME3f19AzyGRuh9I3KKHU=;
 b=mONOvqdoU5JyM6KAmj+EDUlp1Rxe1nd+bd2A/6rEHeJURxZkW789G3IwwSry17nCyx/VAUJJgJlAOEprRJWqmZfWbY+mDfLdA6gEU5o2+jSOnsUXg8ccRcwB+/3gNBUTkKKIfGnrWLaxkCbIVP/qwgO85fZYmqqusWRQ0vHvTSfG3djCQxvaO/ra1anTeNxLzUV/nXw5olb1oi6SbyzZvV6rb7WfAH0rXRj5gdH3IyWEB1zfCS2FFtDnVtx+6g/WfcE8ElN0cpitBBA4w8ydMHuQeAD8MeB6tuuhqdIv0hotthp+AgOAczobyNJNElpqm9eeDWMsRlH/99V7c6Jh9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2121.namprd11.prod.outlook.com (2603:10b6:4:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 12 Aug
 2021 17:00:58 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:00:58 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH 4.19 2/4] bpf: Do not mark insn as seen under speculative path verification
Date:   Thu, 12 Aug 2021 20:00:35 +0300
Message-Id: <20210812170037.2370387-3-ovidiu.panait@windriver.com>
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
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0251.eurprd07.prod.outlook.com (2603:10a6:803:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 12 Aug 2021 17:00:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b311455-bf97-4b57-2d27-08d95db2c16a
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2121:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB212132014E936116399C8EA7FEF99@DM5PR1101MB2121.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmOl0bugwdv3f6bEJLjN+tuaO7uvayO6ZxzORoNY86nam+0U/hyro13aptcNOWjV7boFVMkQ89rpfey0KRdnbDALunSSGHoKszqnKCfUGo8CUiDG1PDEGvA6RX2A8N2CeNER8otn5Gu4WX3SVZrsAa2apfRUHz+LmOASbE0G7OkCotux37UJAL6BhhvfnKpaZsAjwEosq1RywdcM/Cwe1RcCAgH3CL6UKgnFvmh1Mut2MstEk4c3x1k06f2aZ5arfQEFIOCI95FfKxiORhA2yoZBgBi4p/9vqHiGxiMLaKUo+lii4Z4RYHcNCB4ECt+AL7CkeKv7yZ2jEsntygSKg2eFcqGRa/WQpoWjNezarLrxF2c9UhNjkk66WDXiLhXAk4RuEu6jkP/mltNPovVMKU0Y3574WWLfBmRcLmKZXvkkI2A1M/2MPnfmfw/ffbtskMzxUvlMaErw1XlOUkh48Kx21Ayi4xN8ES+7uJXQExQyXC1N7wF1Zw9yNqn7Gic+Czsjcs4/W7z9v8lGOFvx21WB4JzOrhgo5ffOPnelNAft5C7UkWEfx5tJICb3fiip6tKc8rS7zho4Gj6jWNkhNbL7CJnIYnf3LWly1Q068T+6IA2bdH2BrBSxDpo5hrIK9lgwfCzr77N58cZeIEylDU9gqg3sKpwNjD7tAKWbkIIyr3hYroHSro5XpRFcRWuhwrz3gW+TaX2YfX8QGt7Zbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(15650500001)(508600001)(6916009)(66556008)(66476007)(8676002)(4326008)(83380400001)(86362001)(66946007)(6486002)(38100700002)(38350700002)(956004)(186003)(8936002)(2906002)(6506007)(52116002)(6512007)(36756003)(5660300002)(6666004)(450100002)(316002)(1076003)(44832011)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G3KDEMrVP94Bv/tmcUPUfs9b3/ghOUXLA7uFcWZOBK3YpWj0gqA5B5kRIMz8?=
 =?us-ascii?Q?G2Bp8RbkaYfKSjHc7ZWsWCnNYyulfo/MCPXOxV23K/34XlW1brFpPdNQtGGa?=
 =?us-ascii?Q?tlD5v51VTIDvcWB8KWW/XSma5dsyUM/GHUBsaMdZ8xoSznTpi93CNwWidW3T?=
 =?us-ascii?Q?o/SK3gCoJrxWzl1Owm4n2+CPaA2e/xdp68pNOzlQPn10xo7NoDDlkJtdMvPc?=
 =?us-ascii?Q?aWdJiCX1dW/VELPfehJ1F5Rjual1T7ONlSBwB2PW6ErEtLjaSPRao5wqr2z8?=
 =?us-ascii?Q?sc91NxusxKqpcEg5P3w/1fIg/5BuxuWF7gIAF/7svDEjzsjSEfCS+MY9MJaZ?=
 =?us-ascii?Q?FUR6TvPS91FwoLTKVFciEjFP7FgIvJSIL/6Fvnionhj/r0peLYd0GdXPwxuj?=
 =?us-ascii?Q?IqPeVfDIbBMvMAyyVnWir9PwyKuAWPGIOBC3RvNaTyKqRAUUcNzgUqKoybJV?=
 =?us-ascii?Q?Ubp+qM7mt7LizIAHH8hr12puUFSSYPU0B51Is9dfu8C8yq6Bn0fLXEJvr5qA?=
 =?us-ascii?Q?X3+gJHPJDcwlShaLkgFPn8ZNqXVOtS4MpKD5VklnsGwc3P2y4Tou2dYhsg/m?=
 =?us-ascii?Q?+gtszbjWuhVpYBVkx/uRMVrfwRQCivbO8mzoJ8ZFRiDQtnf1Fwdb518XuLmL?=
 =?us-ascii?Q?NLnT+6nxsiT2yZvzE+BFI1YqGwNEByP4y/3T4iN5Oj9JFNfYC7EjNvZJu89c?=
 =?us-ascii?Q?/4WFFKSa+C/Jui3nudbfOAIRLKMjTqKsYYBYlmwK/Jg+W2KJLM41pS2FaieZ?=
 =?us-ascii?Q?gGFx94/U9+OfNLJpNFFMfGgHkMMfiMw5vHsmP6QN/W4vQ/wWoHjHT6fLvz4b?=
 =?us-ascii?Q?oEQ8viq5cfDzW3jviFV7d0WToCk7G2KI2NS42U+B4sqOLzc1f9eHz2DlXcTY?=
 =?us-ascii?Q?LyGPbYYrE3/m1vrGEQcVQ2js69Udv1zbCz5cwTmPcuHHbXW1C8TTNHll5/pD?=
 =?us-ascii?Q?VzZh2Imjkk8eHLFkeb7nf2R1uSfOEMUl9kzrjwQnIuZW3owOjI6akKWO0E8M?=
 =?us-ascii?Q?VqWPUBYsl3clRt5ZTeaXPmNErqaEPL8l8M8/ZL0klgB5YSv0Ap6/S09EOBwN?=
 =?us-ascii?Q?FpEbDA+JazUt/mWlpKEuJqC+ZaZWWR9OT761ZHuDpkocS+SI2B3SS6nOXXI3?=
 =?us-ascii?Q?LWndBBU4TnVecBiRKvlQsoZo2Go0W+iXI/Za6eobT/beVFzMiMgW7QTqEWLi?=
 =?us-ascii?Q?LpsIXLCs6Akh9C3dPu/w4x9MC1mPEBOXZPCpWW/7EfMAloAWnAR3RbIruKG+?=
 =?us-ascii?Q?nEhAnpfqXyarP1ub/ZhcuS6HA/xNc4XUCcbIehynP5d/NVcy1N/XqzHTbGKy?=
 =?us-ascii?Q?LdM06FM8D2o5IxhGwIUOkuHW?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b311455-bf97-4b57-2d27-08d95db2c16a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:00:58.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 87e2mpb/5Eig2tio2psOM0crknqL0tK1bNXGdc5ktCXVHgTnGcw+lqVwT03GkVf9USqEFq/vbOOSErytI89zmPZpMTFXr4sm603j/V4E4SE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2121
X-Proofpoint-ORIG-GUID: 07ERtHoRlrBhnL0FiM_kQkg1OZ7gkLNC
X-Proofpoint-GUID: 07ERtHoRlrBhnL0FiM_kQkg1OZ7gkLNC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=730 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit fe9a5ca7e370e613a9a75a13008a3845ea759d6e upstream.

... in such circumstances, we do not want to mark the instruction as seen given
the goal is still to jmp-1 rewrite/sanitize dead code, if it is not reachable
from the non-speculative path verification. We do however want to verify it for
safety regardless.

With the patch as-is all the insns that have been marked as seen before the
patch will also be marked as seen after the patch (just with a potentially
different non-zero count). An upcoming patch will also verify paths that are
unreachable in the non-speculative domain, hence this extension is needed.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: - env->pass_cnt is not used in 4.19, so adjust sanitize_mark_insn_seen()
       to assign "true" instead
     - drop sanitize_insn_aux_data() comment changes, as the function is not
       present in 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 70cadee591f3..566eeee5e334 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2901,6 +2901,19 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	return !ret ? REASON_STACK : 0;
 }
 
+static void sanitize_mark_insn_seen(struct bpf_verifier_env *env)
+{
+	struct bpf_verifier_state *vstate = env->cur_state;
+
+	/* If we simulate paths under speculation, we don't update the
+	 * insn as 'seen' such that when we verify unreachable paths in
+	 * the non-speculative domain, sanitize_dead_code() can still
+	 * rewrite/sanitize them.
+	 */
+	if (!vstate->speculative)
+		env->insn_aux_data[env->insn_idx].seen = true;
+}
+
 static int sanitize_err(struct bpf_verifier_env *env,
 			const struct bpf_insn *insn, int reason,
 			const struct bpf_reg_state *off_reg,
@@ -5254,7 +5267,7 @@ static int do_check(struct bpf_verifier_env *env)
 		}
 
 		regs = cur_regs(env);
-		env->insn_aux_data[env->insn_idx].seen = true;
+		sanitize_mark_insn_seen(env);
 
 		if (class == BPF_ALU || class == BPF_ALU64) {
 			err = check_alu_op(env, insn);
@@ -5472,7 +5485,7 @@ static int do_check(struct bpf_verifier_env *env)
 					return err;
 
 				env->insn_idx++;
-				env->insn_aux_data[env->insn_idx].seen = true;
+				sanitize_mark_insn_seen(env);
 			} else {
 				verbose(env, "invalid BPF_LD mode\n");
 				return -EINVAL;
-- 
2.25.1

