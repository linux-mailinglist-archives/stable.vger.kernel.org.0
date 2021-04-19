Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6903364193
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhDSMXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:23:05 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:58587 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238722AbhDSMXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 08:23:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9A1691940CA1;
        Mon, 19 Apr 2021 08:22:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 19 Apr 2021 08:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sJW0qh
        6T2GTuEdIpqK7pPRH1RSGG5u00A2X96flDFUM=; b=gqwWfRgUFbZgcxTS9awpzE
        pzB/3gee55gau7i+JLxoelPzDraCVs+ZAkl6A+N8+UbORhvWEXLA2lIbvXONU2sS
        3F0I8cTUvk/WouAUOAWTLkEoKXb4QU6UdbGxEuOly8rbGvmbv8awQRI6/QmAf5FJ
        Hmz/v3g5CsdLNLx3/bfipa4hatiMhLDwpBO0gyLbL7IkPKRJOxzd56ScXjvd1H7B
        SZsyvIwvmK4x52EWrK8bbVzhmp20amXB9VrJ/NgEXDT76irlXhIceAcaGKejSCMd
        eN391joBQgNm1O0ilcWS5y70zh7CXaXGRZ+7irbtOJD8QQNwrP+JNR69+rXHxIRg
        ==
X-ME-Sender: <xms:C3Z9YMbQ0dNchqTvFuLVzwC23ge1JyOyX1Nl2nHDbr0d66vpy_4TLA>
    <xme:C3Z9YMrRbuuGEZ-MeuZR7R3HuXykhd30W4A3G6yaH_lJh81OXMr0YIEwyz-63DArr
    mdJRAAtUnTSFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:C3Z9YIpudjnzYhHL-SGcARjrJ1lE4IwczsV2uV4BxOGL0VBR_C60cQ>
    <xmx:C3Z9YO0CPqa79V1oLRgriPqhfqRBCc11H-G0JkMpp0evoVQMRDH5Yw>
    <xmx:C3Z9YPB1Xt9R3_Mb9Yi3ZFex7Wh35zyc86ZoqE6NPiBoXH1CmqNO6g>
    <xmx:C3Z9YMt2u4k-O5RFnBi3NitgtgxBy5fWmZUO35piCUdsggl2JWWTuQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5EA8108005B;
        Mon, 19 Apr 2021 08:22:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Tighten speculative pointer arithmetic mask" failed to apply to 5.10-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, benedict.schlueter@rub.de,
        john.fastabend@gmail.com, piotras@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Apr 2021 14:22:32 +0200
Message-ID: <1618834952206183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7fedb63a8307dda0ec3b8969a3b233a1dd7ea8e0 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 24 Mar 2021 10:38:26 +0100
Subject: [PATCH] bpf: Tighten speculative pointer arithmetic mask

This work tightens the offset mask we use for unprivileged pointer arithmetic
in order to mitigate a corner case reported by Piotr and Benedict where in
the speculative domain it is possible to advance, for example, the map value
pointer by up to value_size-1 out-of-bounds in order to leak kernel memory
via side-channel to user space.

Before this change, the computed ptr_limit for retrieve_ptr_limit() helper
represents largest valid distance when moving pointer to the right or left
which is then fed as aux->alu_limit to generate masking instructions against
the offset register. After the change, the derived aux->alu_limit represents
the largest potential value of the offset register which we mask against which
is just a narrower subset of the former limit.

For minimal complexity, we call sanitize_ptr_alu() from 2 observation points
in adjust_ptr_min_max_vals(), that is, before and after the simulated alu
operation. In the first step, we retieve the alu_state and alu_limit before
the operation as well as we branch-off a verifier path and push it to the
verification stack as we did before which checks the dst_reg under truncation,
in other words, when the speculative domain would attempt to move the pointer
out-of-bounds.

In the second step, we retrieve the new alu_limit and calculate the absolute
distance between both. Moreover, we commit the alu_state and final alu_limit
via update_alu_sanitation_state() to the env's instruction aux data, and bail
out from there if there is a mismatch due to coming from different verification
paths with different states.

Reported-by: Piotr Krysiuk <piotras@gmail.com>
Reported-by: Benedict Schlueter <benedict.schlueter@rub.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Benedict Schlueter <benedict.schlueter@rub.de>

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e41b6326e3e6..0399ac092b36 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5871,7 +5871,7 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off, max = 0, ptr_limit = 0;
+	u32 max = 0, ptr_limit = 0;
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
@@ -5880,26 +5880,18 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
-		 * left direction, see BPF_REG_FP.
+		 * left direction, see BPF_REG_FP. Also, unknown scalar
+		 * offset where we would need to deal with min/max bounds is
+		 * currently prohibited for unprivileged.
 		 */
 		max = MAX_BPF_STACK + mask_to_left;
-		/* Indirect variable offset stack access is prohibited in
-		 * unprivileged mode so it's not handled here.
-		 */
-		off = ptr_reg->off + ptr_reg->var_off.value;
-		if (mask_to_left)
-			ptr_limit = MAX_BPF_STACK + off;
-		else
-			ptr_limit = -off - 1;
+		ptr_limit = -(ptr_reg->var_off.value + ptr_reg->off);
 		break;
 	case PTR_TO_MAP_VALUE:
 		max = ptr_reg->map_ptr->value_size;
-		if (mask_to_left) {
-			ptr_limit = ptr_reg->umax_value + ptr_reg->off;
-		} else {
-			off = ptr_reg->smin_value + ptr_reg->off;
-			ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
-		}
+		ptr_limit = (mask_to_left ?
+			     ptr_reg->smin_value :
+			     ptr_reg->umax_value) + ptr_reg->off;
 		break;
 	default:
 		return REASON_TYPE;
@@ -5954,10 +5946,12 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
 			    const struct bpf_reg_state *off_reg,
-			    struct bpf_reg_state *dst_reg)
+			    struct bpf_reg_state *dst_reg,
+			    struct bpf_insn_aux_data *tmp_aux,
+			    const bool commit_window)
 {
+	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
-	struct bpf_insn_aux_data *aux = cur_aux(env);
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
@@ -5976,18 +5970,33 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	if (vstate->speculative)
 		goto do_sim;
 
-	alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
-	alu_state |= ptr_is_dst_reg ?
-		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
-
 	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
+	if (commit_window) {
+		/* In commit phase we narrow the masking window based on
+		 * the observed pointer move after the simulated operation.
+		 */
+		alu_state = tmp_aux->alu_state;
+		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
+	} else {
+		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
+		alu_state |= ptr_is_dst_reg ?
+			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
+	}
+
 	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
 	if (err < 0)
 		return err;
 do_sim:
+	/* If we're in commit phase, we're done here given we already
+	 * pushed the truncated dst_reg into the speculative verification
+	 * stack.
+	 */
+	if (commit_window)
+		return 0;
+
 	/* Simulate and find potential out-of-bounds access under
 	 * speculative execution from truncation as a result of
 	 * masking when off was not within expected range. If off
@@ -6130,6 +6139,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
+	struct bpf_insn_aux_data tmp_aux = {};
 	u8 opcode = BPF_OP(insn->code);
 	u32 dst = insn->dst_reg;
 	int ret;
@@ -6196,12 +6206,15 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	/* pointer types do not carry 32-bit bounds at the moment. */
 	__mark_reg32_unbounded(dst_reg);
 
-	switch (opcode) {
-	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
+	if (sanitize_needed(opcode)) {
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
+				       &tmp_aux, false);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+	}
 
+	switch (opcode) {
+	case BPF_ADD:
 		/* We can take a fixed offset as long as it doesn't overflow
 		 * the s32 'off' field
 		 */
@@ -6252,10 +6265,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0)
-			return sanitize_err(env, insn, ret, off_reg, dst_reg);
-
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
@@ -6338,6 +6347,12 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
 		return -EACCES;
+	if (sanitize_needed(opcode)) {
+		ret = sanitize_ptr_alu(env, insn, dst_reg, off_reg, dst_reg,
+				       &tmp_aux, true);
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+	}
 
 	return 0;
 }

