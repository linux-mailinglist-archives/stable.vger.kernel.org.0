Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA6240978A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244813AbhIMPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:48 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:19948 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243442AbhIMPhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:43 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWk6w015226;
        Mon, 13 Sep 2021 08:36:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=NuRu3UCefk0Jyy4wdd0FEaxa4z0YsiqeP6omQFMuK1Q=;
 b=Kj7FpF1C+MgNDYmA9jd7tLQqxjmZOcz7z1+TzoMpmd2vpjHe9qG36F7Mvh3yuWxauAeI
 jll7ShW66CutHZ/rE8ryayKgdiuGLb8/p6v9T6lzX4KidFDIBfPjmroHJmSbb2AHm7sm
 +1dpJF18W/7hztsRtqP3s8uCUyS4RVGPcdB21TDMAO+xeUojjrd84ejE0hSaV9tHxfgN
 PeTSZq+ScWQyMm8WCk4Z+JTWdr/rxaV963ROFdEKbwKbj4wgk0rX6hSnLGCEcnvKIGNu
 vIiJ/ZN0wYbCR1Anr8TMMITaSEf/f2f3ehk1Bfp11wgwJG5GaYpuWXqRQJyEtYFYH3Rm rQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:36:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEvJfsYdvBAZ23omM8q8rVu55CdJJf0zeCTCtaClPiB0kgcL2PzWrtG5uziAD7DWqUBLqWTogbaJHOSe1zKRQjV+IbEyYEbUGSANVMmr6qb4RJn5vo26sJjhZ0IX5q1un4lFme1aCofNNI1FA97llkPr5ocQVEYN1apufU+fxniEHjvFj3Z3jGvRvfTNmqbFaYjbdsWbgU4Dq39cUqbRYIvieYc07xF0QfQYYcgLL1HRKD2Hsi+nJDPENQKN0ar7qzN7/UFfDDuTq1yUADcvjBzxbA+w9QRNOJPNakNu5uy3W08ADLuE6YSPE4grUhOA9c5ugOjzLX73KbjOqv6FAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NuRu3UCefk0Jyy4wdd0FEaxa4z0YsiqeP6omQFMuK1Q=;
 b=E3ctcBdpVjq2gRjvmlsrOvcu3sMGoXXu0HKZTPdgaZagHLk6tIMqIPB1y/Ue4UrLLE4p7nSKPEN9ESJ51OIxhbvQXqKZI8DynPrs7J6yZI397L/1MdGn5b9aP48uOcQ5Me8KvDX33XSmwHzE/TYa9KAVC1V/BcxKpuaXLrKgZJJaRY1xTjClAXmglzpdJu8cB5RDgTYVJ1avPLGdlooAT9pLViyGtTEvEhLuJWjLXpsfnaxEtQ0kZL3y6h2tNB4S9Z8EPYR0DobYYG/MDlYdDLx2Zvb+zhMher+vBUBSjctPbTEO/zqgJ8mtlOL+oWa0nVNKLE1QBOLUAEanWV9Pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2201.namprd11.prod.outlook.com (2603:10b6:4:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 15:36:12 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:12 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 13/13] bpf: Fix pointer arithmetic mask tightening under state pruning
Date:   Mon, 13 Sep 2021 18:35:37 +0300
Message-Id: <20210913153537.2162465-14-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e081432-63b1-4e87-8d31-08d976cc3776
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2201:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2201338CFE52BF34C347F6F6FED99@DM5PR1101MB2201.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0OoMv3N1Q9pSwPCjLY6t6Fi0Udfbv6rRNkM9/0iIyRhCHjffhygfaBjxLGF3yg5aWN+ieYxea7746qdCrEy895nkhNzpaNC3yMUNn0olzFM81o1GhELZBY5HETGjkHzC227+ytnTXzd44uw5QONj7FblGwwbKYNJZMwk5rjNIUlt8kRvtkd6zqscNVBWzsRbJtHYGOqH+iMgmTAJL6uckorSmy0J68jGRR+vMNRtuX4UhEDOqsPnbgSIunxqWwC1lwqaTcGOL0jgs1u+BTxirIMDUxy03jkdm38VzqfDslAcTt70dEe0mDe/OYu3jEafERDW0n6zj/m/Smeo/Ds9V5RjiZpCiHSGIp9eNu0nzu8ozlHZ2GtAjgSJ1+qHrDcNCuYSvqwFUBgmoed1//XV3SN1d64d/mcEUfjqxIBTyvBsFS8WS/2x+uN53MafssFrnS4QF4bBwF69IGoGZn84rj89+tSgY1bkCfmG1Qe4owsiXe4PpAwAOGQH7NiF9Mma8QWvhvNOf+dhJkV4DgjUifREeYLtzOMLqGfMgqqboKfN0rJ8QUI6USxkcYanNteo7iCGcPrg1BOIB1JD/vJiO/FIMihbGZG0PFQBgwQLYW46hYvpj7/6PgWrdF1WTbOz0j7og4/jAkxQUeBzUABy3g6XUt9w8bX0tZ8WpG0It4Zwl9raERctz6OdeZTHU+VB0qkU571HmM7yHJIEpsvauA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(52116002)(6916009)(316002)(6486002)(38350700002)(6666004)(86362001)(5660300002)(2616005)(4326008)(8936002)(26005)(38100700002)(6512007)(6506007)(956004)(83380400001)(478600001)(1076003)(36756003)(186003)(44832011)(66476007)(2906002)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zw4NCBjO/AhLt5t+MpGiWHYcB4Dd57CWuIgpcSIuywmwRf8Cw9Q6e+e0K7vH?=
 =?us-ascii?Q?saSvDTwBAkylbAFnB4MtU4sWn/KEtaqOHORG5ATd+EC+BHNj2ILidtjfkhjW?=
 =?us-ascii?Q?a8k9Y2MiYJwtKp0tmSOogIVAvnPszRVSwyXe8dZotC1Y8oi5o66bBw7sXiCN?=
 =?us-ascii?Q?PbUID2Z7K73gdFekac/ShH/Ti6FjAZ2dTbhfCmV7DPnMwPoosZIy+T/8JzKX?=
 =?us-ascii?Q?7JcT7k4e8wvdKCtMR9eWY00TiUxmhFQNPKCCD+CkO//zP+XZmyAMt4jRhX5v?=
 =?us-ascii?Q?36FBfLu1HMBCbBkcdsJu1BrmrwcFSjbinBwGKpjrc0h4CA5+NViP/HZ50JY8?=
 =?us-ascii?Q?MNjiBQXXxWEVQw3PJcwNbWu/I0/rSUaWVkcv7hyV+Imff0MX17+HfUdJ2lLe?=
 =?us-ascii?Q?iJBSAiC65npTOYgmmW88Lrr2Y7F/CCTLZv1/PZ+E2y/l2V5bLKQjBoIYFv6V?=
 =?us-ascii?Q?bZVqCN/bxhdqQaZvS13pHHh+/zozcYoxTfuf2D8KauP15Q+SRQyz3/s3bzFK?=
 =?us-ascii?Q?TQ4c9MMKOZUGai1cAL3pAUv/D9usE52AKHCSgi69VdVmj6D2f+WmUYbFh34W?=
 =?us-ascii?Q?M/F/S/zzShUmyWOkxDt6fRpMSekOWOoxEFX8ohKPOheOuBvdyWt55XlvwhV3?=
 =?us-ascii?Q?BwfAWc81RVxhfoDOYrKZL4R2McJb0pagYXOhmmqKnCB7EWsCwEpdFfBTj0ry?=
 =?us-ascii?Q?ZZ7jSMt6/cFE2ben753X23PZmn5h8e4CI2NH/7AMvQ+Z1ykY9Tj+JMH84a/I?=
 =?us-ascii?Q?wStRUBcpD8lkfFAUo7+qHl3EVFppV5TaXV0FToIz/ZwSAEJaKF/aaywNsVwX?=
 =?us-ascii?Q?GWhpTK6YfMfGjFzG303GWJhey/kHqzgj2Iz6gjAYDjqkdGqgo+JeEpeO/jHs?=
 =?us-ascii?Q?yLD+Vvaytf+fjrjjfFBZLudLG3GK/es5sfH5629bVpQdhG22OSDqNmCWbWYH?=
 =?us-ascii?Q?Iqh/Udi4g5aLjfyh0lc0zJMvVhD0/nrxzfX1v8IXwLkK2oBv5R9QcPWtklDz?=
 =?us-ascii?Q?K+qC4WYaENi6IfmQdE/wJJEyvExdLU7cdNA+jW8PeENNG2j9NWTYyfnh7D7V?=
 =?us-ascii?Q?7ek7jDl05ef5t9qctERLBAe29eZKEoIgC21PZnEN4UX4qcoQKfnBdPduuM4T?=
 =?us-ascii?Q?YP+Tr4Jy1hnIG4voCfaGzIlm1VHHvCxl+h79yrno3yyB3lA9PPElgaI5lwfz?=
 =?us-ascii?Q?WYMcDY7r1NwQfjRGIeWXbsSTCxduYu84jhy/YsagMXnSdEbFOtkjpa27sN24?=
 =?us-ascii?Q?dttHZGP3L5XsyMABP+FKbblXNy6oRBBnGBYCJhAqUglC2rV8DkW9zCYvyF3h?=
 =?us-ascii?Q?+yXZU1a076hLxoarJlN8cUz4?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e081432-63b1-4e87-8d31-08d976cc3776
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:12.7161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FRV1GkhIFT/E40yaidbP6PebyCJi8jDlZU+Ry5AiMtZ8uYU4SKP4eNG1EuqcjY9Ioj4FUuLr2FxKUv1urhxK4XUeEc7OLyZwH0GZVYtUuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2201
X-Proofpoint-ORIG-GUID: jnoRgR64AQH3lqfbyDzNTa1pc2Fu2aBQ
X-Proofpoint-GUID: jnoRgR64AQH3lqfbyDzNTa1pc2Fu2aBQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=766 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit e042aa532c84d18ff13291d00620502ce7a38dda upstream.

In 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask") we
narrowed the offset mask for unprivileged pointer arithmetic in order to
mitigate a corner case where in the speculative domain it is possible to
advance, for example, the map value pointer by up to value_size-1 out-of-
bounds in order to leak kernel memory via side-channel to user space.

The verifier's state pruning for scalars leaves one corner case open
where in the first verification path R_x holds an unknown scalar with an
aux->alu_limit of e.g. 7, and in a second verification path that same
register R_x, here denoted as R_x', holds an unknown scalar which has
tighter bounds and would thus satisfy range_within(R_x, R_x') as well as
tnum_in(R_x, R_x') for state pruning, yielding an aux->alu_limit of 3:
Given the second path fits the register constraints for pruning, the final
generated mask from aux->alu_limit will remain at 7. While technically
not wrong for the non-speculative domain, it would however be possible
to craft similar cases where the mask would be too wide as in 7fedb63a8307.

One way to fix it is to detect the presence of unknown scalar map pointer
arithmetic and force a deeper search on unknown scalars to ensure that
we do not run into a masking mismatch.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 729c65b320d4..4acd06cca703 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -215,6 +215,7 @@ struct bpf_verifier_env {
 	struct bpf_map *used_maps[MAX_USED_MAPS]; /* array of map's used by eBPF program */
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
+	bool explore_alu_limits;
 	bool allow_ptr_leaks;
 	bool seen_direct_write;
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 883fb762d93c..9a671f604ebf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2871,6 +2871,12 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
 		alu_state |= ptr_is_dst_reg ?
 			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
+
+		/* Limit pruning on unknown scalars to enable deep search for
+		 * potential masking differences from other program paths.
+		 */
+		if (!off_is_imm)
+			env->explore_alu_limits = true;
 	}
 
 	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
@@ -4813,8 +4819,8 @@ static bool check_ids(u32 old_id, u32 cur_id, struct bpf_id_pair *idmap)
 }
 
 /* Returns true if (rold safe implies rcur safe) */
-static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct bpf_id_pair *idmap)
+static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
+		    struct bpf_reg_state *rcur, struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -4840,6 +4846,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 		return false;
 	switch (rold->type) {
 	case SCALAR_VALUE:
+		if (env->explore_alu_limits)
+			return false;
 		if (rcur->type == SCALAR_VALUE) {
 			/* new val must satisfy old val knowledge */
 			return range_within(rold, rcur) &&
@@ -4916,9 +4924,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	return false;
 }
 
-static bool stacksafe(struct bpf_func_state *old,
-		      struct bpf_func_state *cur,
-		      struct bpf_id_pair *idmap)
+static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
+		      struct bpf_func_state *cur, struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -4960,9 +4967,8 @@ static bool stacksafe(struct bpf_func_state *old,
 			continue;
 		if (old->stack[spi].slot_type[0] != STACK_SPILL)
 			continue;
-		if (!regsafe(&old->stack[spi].spilled_ptr,
-			     &cur->stack[spi].spilled_ptr,
-			     idmap))
+		if (!regsafe(env, &old->stack[spi].spilled_ptr,
+			     &cur->stack[spi].spilled_ptr, idmap))
 			/* when explored and current stack slot are both storing
 			 * spilled registers, check that stored pointers types
 			 * are the same as well.
@@ -5011,10 +5017,11 @@ static bool func_states_equal(struct bpf_verifier_env *env, struct bpf_func_stat
 
 	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
 	for (i = 0; i < MAX_BPF_REG; i++)
-		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+		if (!regsafe(env, &old->regs[i], &cur->regs[i],
+			     env->idmap_scratch))
 			return false;
 
-	if (!stacksafe(old, cur, env->idmap_scratch))
+	if (!stacksafe(env, old, cur, env->idmap_scratch))
 		return false;
 
 	return true;
-- 
2.25.1

