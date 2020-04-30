Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B6F1BF8F6
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgD3NK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:10:27 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46633 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgD3NK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 09:10:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7527B99B;
        Thu, 30 Apr 2020 09:10:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 30 Apr 2020 09:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3TjlXp
        5BDzNDYe0UEvi+yEHCwsSh4P4bO3nljFrkpdQ=; b=jiyhWTOi9+lPUJbA5btnI4
        FeYm9Ejq6f6tXy4TZ1HPa4eIqErwtpE4GCTAlwErkQpYwNA3AEmiIhjSoXbSM5Fs
        +b2SElIyaMshiJ/YGFPC5X1q3YLx+nOJCefrT3e8AzL+d0QPFQnzbDSKlXvA8r0o
        FbBkc+dMU8YQlJPVSBGkehQz1P1jbd4hWf06QZfJlF6PymlBy8aHn8O6EfYx77I2
        V8r19HAMIZT/FkrlHz94+uF149w+9WYf210p4XSvEpesPpWaS//30OzOQFHQUqHK
        zGTkc8XoPlVY7x5X+x/yb70nLmX130vqcGIGHYqeztvQaMccRpD2U9FH8wXajVgw
        ==
X-ME-Sender: <xms:Qc6qXl79M0CSjRsp9ETDjuNZtY9IbU-yUFUqgiPRNjDyXt78ok47hA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Qs6qXgAbslwrJNL6mRZVfl1O1gOr7bNpnRvEfASkmbcsbs9QC17DxA>
    <xmx:Qs6qXprovAiJQedLmPrd44xB5uUaRhy3Ml1xszmn5TtCxE72MMdJag>
    <xmx:Qs6qXuTlCzoKUZjsBg_QYL796Fyux-OpAjCP_kdMwombHLg2iI-xlA>
    <xmx:Qs6qXlvZB4m9Aglp3ErjFod66PzJwQQDBvxkOmI0yrgZPbupvsO_nYl9rkU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF5BF3280063;
        Thu, 30 Apr 2020 09:10:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Forbid XADD on spilled pointers for unprivileged users" failed to apply to 4.4-stable tree
To:     jannh@google.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Apr 2020 15:10:12 +0200
Message-ID: <1588252212228216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e7e63cbb023976d828cdb22422606bf77baa8a9 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Fri, 17 Apr 2020 02:00:06 +0200
Subject: [PATCH] bpf: Forbid XADD on spilled pointers for unprivileged users

When check_xadd() verifies an XADD operation on a pointer to a stack slot
containing a spilled pointer, check_stack_read() verifies that the read,
which is part of XADD, is valid. However, since the placeholder value -1 is
passed as `value_regno`, check_stack_read() can only return a binary
decision and can't return the type of the value that was read. The intent
here is to verify whether the value read from the stack slot may be used as
a SCALAR_VALUE; but since check_stack_read() doesn't check the type, and
the type information is lost when check_stack_read() returns, this is not
enforced, and a malicious user can abuse XADD to leak spilled kernel
pointers.

Fix it by letting check_stack_read() verify that the value is usable as a
SCALAR_VALUE if no type information is passed to the caller.

To be able to use __is_pointer_value() in check_stack_read(), move it up.

Fix up the expected unprivileged error message for a BPF selftest that,
until now, assumed that unprivileged users can use XADD on stack-spilled
pointers. This also gives us a test for the behavior introduced in this
patch for free.

In theory, this could also be fixed by forbidding XADD on stack spills
entirely, since XADD is a locked operation (for operations on memory with
concurrency) and there can't be any concurrency on the BPF stack; but
Alexei has said that he wants to keep XADD on stack slots working to avoid
changes to the test suite [1].

The following BPF program demonstrates how to leak a BPF map pointer as an
unprivileged user using this bug:

    // r7 = map_pointer
    BPF_LD_MAP_FD(BPF_REG_7, small_map),
    // r8 = launder(map_pointer)
    BPF_STX_MEM(BPF_DW, BPF_REG_FP, BPF_REG_7, -8),
    BPF_MOV64_IMM(BPF_REG_1, 0),
    ((struct bpf_insn) {
      .code  = BPF_STX | BPF_DW | BPF_XADD,
      .dst_reg = BPF_REG_FP,
      .src_reg = BPF_REG_1,
      .off = -8
    }),
    BPF_LDX_MEM(BPF_DW, BPF_REG_8, BPF_REG_FP, -8),

    // store r8 into map
    BPF_MOV64_REG(BPF_REG_ARG1, BPF_REG_7),
    BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_FP),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, -4),
    BPF_ST_MEM(BPF_W, BPF_REG_ARG2, 0, 0),
    BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
    BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
    BPF_EXIT_INSN(),
    BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_8, 0),

    BPF_MOV64_IMM(BPF_REG_0, 0),
    BPF_EXIT_INSN()

[1] https://lore.kernel.org/bpf/20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com/

Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200417000007.10734-1-jannh@google.com

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 38cfcf701eeb..9e92d3d5ffd1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2118,6 +2118,15 @@ static bool register_is_const(struct bpf_reg_state *reg)
 	return reg->type == SCALAR_VALUE && tnum_is_const(reg->var_off);
 }
 
+static bool __is_pointer_value(bool allow_ptr_leaks,
+			       const struct bpf_reg_state *reg)
+{
+	if (allow_ptr_leaks)
+		return false;
+
+	return reg->type != SCALAR_VALUE;
+}
+
 static void save_register_state(struct bpf_func_state *state,
 				int spi, struct bpf_reg_state *reg)
 {
@@ -2308,6 +2317,16 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			 * which resets stack/reg liveness for state transitions
 			 */
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
+		} else if (__is_pointer_value(env->allow_ptr_leaks, reg)) {
+			/* If value_regno==-1, the caller is asking us whether
+			 * it is acceptable to use this value as a SCALAR_VALUE
+			 * (e.g. for XADD).
+			 * We must not allow unprivileged callers to do that
+			 * with spilled pointers.
+			 */
+			verbose(env, "leaking pointer from stack off %d\n",
+				off);
+			return -EACCES;
 		}
 		mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
 	} else {
@@ -2673,15 +2692,6 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	return -EACCES;
 }
 
-static bool __is_pointer_value(bool allow_ptr_leaks,
-			       const struct bpf_reg_state *reg)
-{
-	if (allow_ptr_leaks)
-		return false;
-
-	return reg->type != SCALAR_VALUE;
-}
-
 static struct bpf_reg_state *reg_state(struct bpf_verifier_env *env, int regno)
 {
 	return cur_regs(env) + regno;
diff --git a/tools/testing/selftests/bpf/verifier/value_illegal_alu.c b/tools/testing/selftests/bpf/verifier/value_illegal_alu.c
index 7f6c232cd842..ed1c2cea1dea 100644
--- a/tools/testing/selftests/bpf/verifier/value_illegal_alu.c
+++ b/tools/testing/selftests/bpf/verifier/value_illegal_alu.c
@@ -88,6 +88,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_48b = { 3 },
+	.errstr_unpriv = "leaking pointer from stack off -8",
 	.errstr = "R0 invalid mem access 'inv'",
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,

