Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E00C327FAB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhCANhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:37:51 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40255 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235804AbhCANhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:37:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8A1DD1941DC0;
        Mon,  1 Mar 2021 08:36:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=V/TTJg
        Q8DGazjs0pwIlV3mwnJBLTjBMG/0fmNXawWx0=; b=lT4e3Rs/XXDuvww0N/Yk79
        HaJmZD/bdHyEY8kvmf+mpGymmi/riUVDhs13rXVT5ZOss6dQsJxFyk1xhn1aq+P8
        vjiuJAIHO3wyNZVvA+GAeE0ewV5G7FfSxkNso970A79+767pNZdoake5YORuMNXz
        sVnRLUxmabx47jzo/3NCyY8PkrZT0ZGNHvvZglUhQBYdsDgh+ZqBgDKVcPGOwIC7
        ZtFO7T+cfY1wwdtx11YbKx8W15zqkIfZBcBSUaWeJUNpchvM8HR7+kwFTH+7CUpX
        rPNkr3gc7cpI63NReGnbgDGENK3VtLwdu/Y3mYBhYNyROIke/ePYOwWSCcbfGXMQ
        ==
X-ME-Sender: <xms:6-08YADK95rkVtr9zLgzV63CQtau44NCtVzRBynVLGFs2UG_7G3K-g>
    <xme:6-08YCge8xrB1JWKvpP3K7kxRSS5BqytPxDuWnI6wxniPuIu38GFXTdWGavq7l31d
    rZr8trH-_oWYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeevuedukeegheeitdfhfefgvedvteethedvieehheduge
    dtvdevgfdtieehkeeuheenucffohhmrghinhepvghnthhrhidrshgsnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6-08YDkf3FrUjie4I5ibdTjG-OS97BsawCWU-fNKh9MmgUMJE2aS8A>
    <xmx:6-08YGztNe-bEyw6i4BNP2N7M9YDO8zyZ0vo7JjhjqqL7Ll4e4cWEw>
    <xmx:6-08YFTjGBHtByPdncCQ--bGufD8KVJ27_md9xAanDWOHp3trtXqOQ>
    <xmx:6-08YAeHVW1Rh5op0VGnAbAY1NqiZIn_3PYrMud9LTv6O6rmFX8emw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 325591080064;
        Mon,  1 Mar 2021 08:36:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390: add stack for machine check handler" failed to apply to 5.11-stable tree
To:     svens@linux.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:36:41 +0100
Message-ID: <161460580114277@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b61b1595124a1694501105e5dd488de0c0c6bc2a Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Wed, 3 Feb 2021 09:02:51 +0100
Subject: [PATCH] s390: add stack for machine check handler

The previous code used the normal kernel stack for machine checks.
This is problematic when a machine check interrupts a system call
or interrupt handler right at the beginning where registers are set up.

Assume system_call is interrupted at the first instruction and a machine
check is triggered. The machine check handler is called, checks the PSW
to see whether it is coming from user space, notices that it is already
in kernel mode but %r15 still contains the user space stack. This would
lead to a kernel crash.

There are basically two ways of fixing that: Either using the 'critical
cleanup' approach which compares the address in the PSW to see whether
it is already at a point where the stack has been set up, or use an extra
stack for the machine check handler.

For simplicity, we will go with the second approach and allocate an extra
stack. This adds some memory overhead for large systems, but usually large
system have plenty of memory so this isn't really a concern. But it keeps
the mchk stack setup simple and less error prone.

Fixes: 0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Cc: <stable@kernel.org> # v5.8+
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 4d65c8e4e6d0..22bceeeba4bc 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -107,16 +107,15 @@ struct lowcore {
 	__u64	async_stack;			/* 0x0350 */
 	__u64	nodat_stack;			/* 0x0358 */
 	__u64	restart_stack;			/* 0x0360 */
-
+	__u64	mcck_stack;			/* 0x0368 */
 	/* Restart function and parameter. */
-	__u64	restart_fn;			/* 0x0368 */
-	__u64	restart_data;			/* 0x0370 */
-	__u64	restart_source;			/* 0x0378 */
+	__u64	restart_fn;			/* 0x0370 */
+	__u64	restart_data;			/* 0x0378 */
+	__u64	restart_source;			/* 0x0380 */
 
 	/* Address space pointer. */
-	__u64	kernel_asce;			/* 0x0380 */
-	__u64	user_asce;			/* 0x0388 */
-	__u8	pad_0x0390[0x0398-0x0390];	/* 0x0390 */
+	__u64	kernel_asce;			/* 0x0388 */
+	__u64	user_asce;			/* 0x0390 */
 
 	/*
 	 * The lpp and current_pid fields form a
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index d22bb28ef50c..15e637728a4b 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -118,6 +118,7 @@ int main(void)
 	OFFSET(__LC_ASYNC_STACK, lowcore, async_stack);
 	OFFSET(__LC_NODAT_STACK, lowcore, nodat_stack);
 	OFFSET(__LC_RESTART_STACK, lowcore, restart_stack);
+	OFFSET(__LC_MCCK_STACK, lowcore, mcck_stack);
 	OFFSET(__LC_RESTART_FN, lowcore, restart_fn);
 	OFFSET(__LC_RESTART_DATA, lowcore, restart_data);
 	OFFSET(__LC_RESTART_SOURCE, lowcore, restart_source);
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index ed5acf95235f..f7953bb17558 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -70,6 +70,8 @@ _LPP_OFFSET	= __LC_LPP
 	je	\oklabel
 	clg	%r14,__LC_ASYNC_STACK
 	je	\oklabel
+	clg	%r14,__LC_MCCK_STACK
+	je	\oklabel
 	clg	%r14,__LC_NODAT_STACK
 	je	\oklabel
 	clg	%r14,__LC_RESTART_STACK
@@ -548,20 +550,16 @@ ENTRY(mcck_int_handler)
 	jhe	.Lmcck_stack
 	lghi	%r11,__LC_GPREGS_SAVE_AREA+64	# inside critical section, do cleanup
 	brasl	%r14,.Lcleanup_sie
-.Lmcck_stack:
 #endif
-	CHECK_STACK __LC_GPREGS_SAVE_AREA+64
-	lgr	%r11,%r15
-	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
-	stg	%r11,__SF_BACKCHAIN(%r15)
-	j	5f
+	j	.Lmcck_stack
 .Lmcck_user:
 	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
+.Lmcck_stack:
+	lg	%r15,__LC_MCCK_STACK
+.Lmcck_skip:
+	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	lctlg	%c1,%c1,__LC_KERNEL_ASCE
-	lg	%r15,__LC_KERNEL_STACK
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
-5:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
-.Lmcck_skip:
 	lghi	%r14,__LC_GPREGS_SAVE_AREA+64
 	stmg	%r0,%r7,__PT_R0(%r11)
 	# clear user controlled registers to prevent speculative use
@@ -602,7 +600,6 @@ ENTRY(mcck_int_handler)
 
 .Lmcck_panic:
 	lg	%r15,__LC_NODAT_STACK
-	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	j	.Lmcck_skip
 ENDPROC(mcck_int_handler)
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 6b004940c4dc..60da976eee6f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -338,7 +338,7 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-static int __init async_stack_realloc(void)
+static int __init stack_realloc(void)
 {
 	unsigned long old, new;
 
@@ -348,9 +348,16 @@ static int __init async_stack_realloc(void)
 		panic("Couldn't allocate async stack");
 	WRITE_ONCE(S390_lowcore.async_stack, new + STACK_INIT_OFFSET);
 	free_pages(old, THREAD_SIZE_ORDER);
+
+	old = S390_lowcore.mcck_stack - STACK_INIT_OFFSET;
+	new = stack_alloc();
+	if (!new)
+		panic("Couldn't allocate machine check stack");
+	WRITE_ONCE(S390_lowcore.mcck_stack, new + STACK_INIT_OFFSET);
+	memblock_free(old, THREAD_SIZE);
 	return 0;
 }
-early_initcall(async_stack_realloc);
+early_initcall(stack_realloc);
 
 void __init arch_call_rest_init(void)
 {
@@ -372,6 +379,7 @@ void __init arch_call_rest_init(void)
 static void __init setup_lowcore_dat_off(void)
 {
 	unsigned long int_psw_mask = PSW_KERNEL_BITS;
+	unsigned long mcck_stack;
 	struct lowcore *lc;
 
 	if (IS_ENABLED(CONFIG_KASAN))
@@ -439,6 +447,12 @@ static void __init setup_lowcore_dat_off(void)
 	lc->restart_data = 0;
 	lc->restart_source = -1UL;
 
+	mcck_stack = (unsigned long)memblock_alloc(THREAD_SIZE, THREAD_SIZE);
+	if (!mcck_stack)
+		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
+		      __func__, THREAD_SIZE, THREAD_SIZE);
+	lc->mcck_stack = mcck_stack + STACK_INIT_OFFSET;
+
 	/* Setup absolute zero lowcore */
 	mem_assign_absolute(S390_lowcore.restart_stack, lc->restart_stack);
 	mem_assign_absolute(S390_lowcore.restart_fn, lc->restart_fn);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index c5abbb94ac6e..e299892440b6 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -189,7 +189,7 @@ static void pcpu_ec_call(struct pcpu *pcpu, int ec_bit)
 
 static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 {
-	unsigned long async_stack, nodat_stack;
+	unsigned long async_stack, nodat_stack, mcck_stack;
 	struct lowcore *lc;
 
 	if (pcpu != &pcpu_devices[0]) {
@@ -202,13 +202,15 @@ static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 		nodat_stack = pcpu->lowcore->nodat_stack - STACK_INIT_OFFSET;
 	}
 	async_stack = stack_alloc();
-	if (!async_stack)
-		goto out;
+	mcck_stack = stack_alloc();
+	if (!async_stack || !mcck_stack)
+		goto out_stack;
 	lc = pcpu->lowcore;
 	memcpy(lc, &S390_lowcore, 512);
 	memset((char *) lc + 512, 0, sizeof(*lc) - 512);
 	lc->async_stack = async_stack + STACK_INIT_OFFSET;
 	lc->nodat_stack = nodat_stack + STACK_INIT_OFFSET;
+	lc->mcck_stack = mcck_stack + STACK_INIT_OFFSET;
 	lc->cpu_nr = cpu;
 	lc->spinlock_lockval = arch_spin_lockval(cpu);
 	lc->spinlock_index = 0;
@@ -216,12 +218,13 @@ static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 	lc->return_lpswe = gen_lpswe(__LC_RETURN_PSW);
 	lc->return_mcck_lpswe = gen_lpswe(__LC_RETURN_MCCK_PSW);
 	if (nmi_alloc_per_cpu(lc))
-		goto out_async;
+		goto out_stack;
 	lowcore_ptr[cpu] = lc;
 	pcpu_sigp_retry(pcpu, SIGP_SET_PREFIX, (u32)(unsigned long) lc);
 	return 0;
 
-out_async:
+out_stack:
+	stack_free(mcck_stack);
 	stack_free(async_stack);
 out:
 	if (pcpu != &pcpu_devices[0]) {
@@ -233,16 +236,18 @@ static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 
 static void pcpu_free_lowcore(struct pcpu *pcpu)
 {
-	unsigned long async_stack, nodat_stack, lowcore;
+	unsigned long async_stack, nodat_stack, mcck_stack, lowcore;
 
 	nodat_stack = pcpu->lowcore->nodat_stack - STACK_INIT_OFFSET;
 	async_stack = pcpu->lowcore->async_stack - STACK_INIT_OFFSET;
+	mcck_stack = pcpu->lowcore->mcck_stack - STACK_INIT_OFFSET;
 	lowcore = (unsigned long) pcpu->lowcore;
 
 	pcpu_sigp_retry(pcpu, SIGP_SET_PREFIX, 0);
 	lowcore_ptr[pcpu - pcpu_devices] = NULL;
 	nmi_free_per_cpu(pcpu->lowcore);
 	stack_free(async_stack);
+	stack_free(mcck_stack);
 	if (pcpu == &pcpu_devices[0])
 		return;
 	free_pages(nodat_stack, THREAD_SIZE_ORDER);

