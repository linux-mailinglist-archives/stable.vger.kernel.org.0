Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF9E6424A0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 09:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiLEIbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 03:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiLEIbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 03:31:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F4215FFE
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 00:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2592BB80BA7
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 08:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3F1C433D7;
        Mon,  5 Dec 2022 08:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670229103;
        bh=tsxl4sdGZPdL3ibF9AdZ0ZGibBECa9ke3sVJSs/6wPo=;
        h=Subject:To:Cc:From:Date:From;
        b=tPHqw61/out5/pMM5wmEpXNo4g4lz1D38LrCE3b7sUm3OYWzcjKNYiU9yfdtYXxi0
         f0ZHS4aanSoko18lqLAKhk17SMQ5IgH3QMl7YH2KNjW3rgci7rUlOCLrH64/PDPdKm
         yk7ZbMc5ZvMrtyjIYduV4Tp8FTdugwP5LjuPVUVk=
Subject: FAILED: patch "[PATCH] powerpc/bpf/32: Fix Oops on tail call tests" failed to apply to 5.15-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        naveen.n.rao@linux.vnet.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Dec 2022 09:31:39 +0100
Message-ID: <1670229099131100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

89d21e259a94 ("powerpc/bpf/32: Fix Oops on tail call tests")
49c3af43e65f ("powerpc/bpf: Simplify bpf_to_ppc() and adopt it for powerpc64")
3a3fc9bf1039 ("powerpc64/bpf: Store temp registers' bpf to ppc mapping")
036d559c0bde ("powerpc/bpf: Use _Rn macros for GPRs")
576a6c3a00c1 ("powerpc/bpf: Move bpf_jit64.h into bpf_jit_comp64.c")
7b187dcdb5d3 ("powerpc/bpf: Cleanup bpf_jit.h")
794abc08d75e ("powerpc64/bpf: Get rid of PPC_BPF_[LL|STL|STLU] macros")
391c271f4deb ("powerpc64/bpf: Convert some of the uses of PPC_BPF_[LL|STL] to PPC_BPF_[LD|STD]")
feb6307289d8 ("powerpc64/bpf: Optimize instruction sequence used for function calls")
43d636f8b4fd ("powerpc64/bpf elfv1: Do not load TOC before calling functions")
b10cb163c4b3 ("powerpc64/bpf elfv2: Setup kernel TOC in r2 on entry")
1d4866d5652f ("powerpc64/bpf: Use r12 for constant blinding")
c2067f7f8883 ("powerpc64/bpf: Do not save/restore LR on each call to bpf_stf_barrier()")
0ffdbce6f4a8 ("powerpc/bpf: Handle large branch ranges with BPF_EXIT")
bafb5898de5d ("powerpc/bpf: Emit a single branch instruction for known short branch ranges")
a8936569a07b ("powerpc/bpf: Always reallocate BPF_REG_5, BPF_REG_AX and TMP_REG when possible")
3f5f766d5f7f ("powerpc64/bpf: Limit 'ldbrx' to processors compliant with ISA v2.06")
f9320c49993c ("powerpc/bpf: Update ldimm64 instructions during extra pass")
29ec39fcf11e ("Merge tag 'powerpc-5.17-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89d21e259a94f7d5582ec675aa445f5a79f347e4 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Thu, 24 Nov 2022 09:37:27 +0100
Subject: [PATCH] powerpc/bpf/32: Fix Oops on tail call tests

test_bpf tail call tests end up as:

  test_bpf: #0 Tail call leaf jited:1 85 PASS
  test_bpf: #1 Tail call 2 jited:1 111 PASS
  test_bpf: #2 Tail call 3 jited:1 145 PASS
  test_bpf: #3 Tail call 4 jited:1 170 PASS
  test_bpf: #4 Tail call load/store leaf jited:1 190 PASS
  test_bpf: #5 Tail call load/store jited:1
  BUG: Unable to handle kernel data access on write at 0xf1b4e000
  Faulting instruction address: 0xbe86b710
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=4K MMU=Hash PowerMac
  Modules linked in: test_bpf(+)
  CPU: 0 PID: 97 Comm: insmod Not tainted 6.1.0-rc4+ #195
  Hardware name: PowerMac3,1 750CL 0x87210 PowerMac
  NIP:  be86b710 LR: be857e88 CTR: be86b704
  REGS: f1b4df20 TRAP: 0300   Not tainted  (6.1.0-rc4+)
  MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 28008242  XER: 00000000
  DAR: f1b4e000 DSISR: 42000000
  GPR00: 00000001 f1b4dfe0 c11d2280 00000000 00000000 00000000 00000002 00000000
  GPR08: f1b4e000 be86b704 f1b4e000 00000000 00000000 100d816a f2440000 fe73baa8
  GPR16: f2458000 00000000 c1941ae4 f1fe2248 00000045 c0de0000 f2458030 00000000
  GPR24: 000003e8 0000000f f2458000 f1b4dc90 3e584b46 00000000 f24466a0 c1941a00
  NIP [be86b710] 0xbe86b710
  LR [be857e88] __run_one+0xec/0x264 [test_bpf]
  Call Trace:
  [f1b4dfe0] [00000002] 0x2 (unreliable)
  Instruction dump:
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  ---[ end trace 0000000000000000 ]---

This is a tentative to write above the stack. The problem is encoutered
with tests added by commit 38608ee7b690 ("bpf, tests: Add load store
test case for tail call")

This happens because tail call is done to a BPF prog with a different
stack_depth. At the time being, the stack is kept as is when the caller
tail calls its callee. But at exit, the callee restores the stack based
on its own properties. Therefore here, at each run, r1 is erroneously
increased by 32 - 16 = 16 bytes.

This was done that way in order to pass the tail call count from caller
to callee through the stack. As powerpc32 doesn't have a red zone in
the stack, it was necessary the maintain the stack as is for the tail
call. But it was not anticipated that the BPF frame size could be
different.

Let's take a new approach. Use register r4 to carry the tail call count
during the tail call, and save it into the stack at function entry if
required. This means the input parameter must be in r3, which is more
correct as it is a 32 bits parameter, then tail call better match with
normal BPF function entry, the down side being that we move that input
parameter back and forth between r3 and r4. That can be optimised later.

Doing that also has the advantage of maximising the common parts between
tail calls and a normal function exit.

With the fix, tail call tests are now successfull:

  test_bpf: #0 Tail call leaf jited:1 53 PASS
  test_bpf: #1 Tail call 2 jited:1 115 PASS
  test_bpf: #2 Tail call 3 jited:1 154 PASS
  test_bpf: #3 Tail call 4 jited:1 165 PASS
  test_bpf: #4 Tail call load/store leaf jited:1 101 PASS
  test_bpf: #5 Tail call load/store jited:1 141 PASS
  test_bpf: #6 Tail call error path, max count reached jited:1 994 PASS
  test_bpf: #7 Tail call count preserved across function calls jited:1 140975 PASS
  test_bpf: #8 Tail call error path, NULL target jited:1 110 PASS
  test_bpf: #9 Tail call error path, index out of range jited:1 69 PASS
  test_bpf: test_tail_calls: Summary: 10 PASSED, 0 FAILED, [10/10 JIT'ed]

Suggested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Fixes: 51c66ad849a7 ("powerpc/bpf: Implement extended BPF on PPC32")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/757acccb7fbfc78efa42dcf3c974b46678198905.1669278887.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 43f1c76d48ce..a379b0ce19ff 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -113,23 +113,19 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 {
 	int i;
 
-	/* First arg comes in as a 32 bits pointer. */
-	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
-	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
+	/* Initialize tail_call_cnt, to be skipped if we do tail calls. */
+	EMIT(PPC_RAW_LI(_R4, 0));
+
+#define BPF_TAILCALL_PROLOGUE_SIZE	4
+
 	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
 
-	/*
-	 * Initialize tail_call_cnt in stack frame if we do tail calls.
-	 * Otherwise, put in NOPs so that it can be skipped when we are
-	 * invoked through a tail call.
-	 */
 	if (ctx->seen & SEEN_TAILCALL)
-		EMIT(PPC_RAW_STW(bpf_to_ppc(BPF_REG_1) - 1, _R1,
-				 bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
-	else
-		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_STW(_R4, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
 
-#define BPF_TAILCALL_PROLOGUE_SIZE	16
+	/* First arg comes in as a 32 bits pointer. */
+	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
+	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
 
 	/*
 	 * We need a stack frame, but we don't necessarily need to
@@ -170,24 +166,24 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 	for (i = BPF_PPC_NVR_MIN; i <= 31; i++)
 		if (bpf_is_seen_register(ctx, i))
 			EMIT(PPC_RAW_LWZ(i, _R1, bpf_jit_stack_offsetof(ctx, i)));
-}
-
-void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
-{
-	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_0)));
-
-	bpf_jit_emit_common_epilogue(image, ctx);
-
-	/* Tear down our stack frame */
 
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
 
+	/* Tear down our stack frame */
 	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
 
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_MTLR(_R0));
 
+}
+
+void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
+{
+	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_0)));
+
+	bpf_jit_emit_common_epilogue(image, ctx);
+
 	EMIT(PPC_RAW_BLR());
 }
 
@@ -244,7 +240,6 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
 	EMIT(PPC_RAW_ADD(_R3, _R3, b2p_bpf_array));
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_array, ptrs)));
-	EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
 
 	/*
 	 * if (prog == NULL)
@@ -255,19 +250,14 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 
 	/* goto *(prog->bpf_func + prologue_size); */
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_prog, bpf_func)));
-
-	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
-
 	EMIT(PPC_RAW_ADDIC(_R3, _R3, BPF_TAILCALL_PROLOGUE_SIZE));
-
-	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_MTLR(_R0));
-
 	EMIT(PPC_RAW_MTCTR(_R3));
 
 	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_1)));
 
+	/* Put tail_call_cnt in r4 */
+	EMIT(PPC_RAW_MR(_R4, _R0));
+
 	/* tear restore NVRs, ... */
 	bpf_jit_emit_common_epilogue(image, ctx);
 

