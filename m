Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2605634C4B0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 09:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhC2HQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 03:16:20 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46217 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhC2HPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 03:15:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9D9971940B6F;
        Mon, 29 Mar 2021 03:15:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Mar 2021 03:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3bgQUW
        3eVc/0R5SO+sFTDXN6AUQLIrb9UYZ2lujEAIU=; b=wMVuknk5iPmXnTO3vDWe5U
        kh88bcQBvWn0PGs+5Kfw18iPcpdyfbPU1m7G3QeiOCXdVcNcGTqp6UzanBlxQk1A
        aZjDNkxTZJicAzM4X0nBFFeeGULHVw3aX5x4SwieEHwzx2slFBWuj1X2Ekldv7sY
        7e0/BPlhCg2nB0JthxFz8aowVqlXU6/NNiWCQe6YL4tbtx+2aztRnd6X1cRdR0Wk
        oyuT7u83roRMb3uTJ7VU54JxJdJ1/2UnCd7mW/NFwCDNZTVCiYZn8uWWhfFr7IV4
        BYlPTKp0AJZ/+cbVXfJZJIyBQo3G/YJ6Ec98LOc6MPgGF3OLFIcihjvat5LZ/9Xg
        ==
X-ME-Sender: <xms:qH5hYHEf5S6Wkbqf6k0q0Q9sQPjwwXVY88mMHzvEC_Dg3etBFWSE8A>
    <xme:qH5hYEUF8BM7w8Re99RtyTFSqUTCXWoe82lLkIOCjKl_CFq2LXPdAZal9YUXZmpPf
    Fy_6N-QUiJ9vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehjedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qH5hYJKU6sqJ1xMmwdQxayXWimk7AYqK73H6mVQGGiWOCJkP-uszjA>
    <xmx:qH5hYFHa1_7pcrJn8LnQON7irCPgM84qVBQ2el7kcNfzF5fAUAXrcQ>
    <xmx:qH5hYNV-_CxwvxQNvFbKAk9AO_lJouv8u6aGJ-7j8alA5iIDK0dvAg>
    <xmx:qH5hYKix5vt12AJFD_ctNCMuIYUyqAvX4I9vEGODPn4nzUNOyya5EQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED76C24005A;
        Mon, 29 Mar 2021 03:15:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Fix fexit trampoline." failed to apply to 5.10-stable tree
To:     ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        paulmck@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 09:15:49 +0200
Message-ID: <161700214959187@kroah.com>
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

From e21aa341785c679dd409c8cb71f864c00fe6c463 Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Tue, 16 Mar 2021 14:00:07 -0700
Subject: [PATCH] bpf: Fix fexit trampoline.

The fexit/fmod_ret programs can be attached to kernel functions that can sleep.
The synchronize_rcu_tasks() will not wait for such tasks to complete.
In such case the trampoline image will be freed and when the task
wakes up the return IP will point to freed memory causing the crash.
Solve this by adding percpu_ref_get/put for the duration of trampoline
and separate trampoline vs its image life times.
The "half page" optimization has to be removed, since
first_half->second_half->first_half transition cannot be guaranteed to
complete in deterministic time. Every trampoline update becomes a new image.
The image with fmod_ret or fexit progs will be freed via percpu_ref_kill and
call_rcu_tasks. Together they will wait for the original function and
trampoline asm to complete. The trampoline is patched from nop to jmp to skip
fexit progs. They are freed independently from the trampoline. The image with
fentry progs only will be freed via call_rcu_tasks_trace+call_rcu_tasks which
will wait for both sleepable and non-sleepable progs to complete.

Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Paul E. McKenney <paulmck@kernel.org>  # for RCU
Link: https://lore.kernel.org/bpf/20210316210007.38949-1-alexei.starovoitov@gmail.com

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 747bba0a584a..72b5a57e9e31 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1936,7 +1936,7 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
  * add rsp, 8                      // skip eth_type_trans's frame
  * ret                             // return to its caller
  */
-int arch_prepare_bpf_trampoline(void *image, void *image_end,
+int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *image_end,
 				const struct btf_func_model *m, u32 flags,
 				struct bpf_tramp_progs *tprogs,
 				void *orig_call)
@@ -1975,6 +1975,15 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
 
 	save_regs(m, &prog, nr_args, stack_size);
 
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		/* arg1: mov rdi, im */
+		emit_mov_imm64(&prog, BPF_REG_1, (long) im >> 32, (u32) (long) im);
+		if (emit_call(&prog, __bpf_tramp_enter, prog)) {
+			ret = -EINVAL;
+			goto cleanup;
+		}
+	}
+
 	if (fentry->nr_progs)
 		if (invoke_bpf(m, &prog, fentry, stack_size))
 			return -EINVAL;
@@ -1993,8 +2002,7 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
 	}
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		if (fentry->nr_progs || fmod_ret->nr_progs)
-			restore_regs(m, &prog, nr_args, stack_size);
+		restore_regs(m, &prog, nr_args, stack_size);
 
 		/* call original function */
 		if (emit_call(&prog, orig_call, prog)) {
@@ -2003,6 +2011,8 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
 		}
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
+		im->ip_after_call = prog;
+		emit_nops(&prog, 5);
 	}
 
 	if (fmod_ret->nr_progs) {
@@ -2033,9 +2043,17 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
 	 * the return value is only updated on the stack and still needs to be
 	 * restored to R0.
 	 */
-	if (flags & BPF_TRAMP_F_CALL_ORIG)
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		im->ip_epilogue = prog;
+		/* arg1: mov rdi, im */
+		emit_mov_imm64(&prog, BPF_REG_1, (long) im >> 32, (u32) (long) im);
+		if (emit_call(&prog, __bpf_tramp_exit, prog)) {
+			ret = -EINVAL;
+			goto cleanup;
+		}
 		/* restore original return value back into RAX */
 		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
+	}
 
 	EMIT1(0x5B); /* pop rbx */
 	EMIT1(0xC9); /* leave */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d7e0f479a5b0..3625f019767d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -21,6 +21,7 @@
 #include <linux/capability.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
+#include <linux/percpu-refcount.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -556,7 +557,8 @@ struct bpf_tramp_progs {
  *      fentry = a set of program to run before calling original function
  *      fexit = a set of program to run after original function
  */
-int arch_prepare_bpf_trampoline(void *image, void *image_end,
+struct bpf_tramp_image;
+int arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
 				const struct btf_func_model *m, u32 flags,
 				struct bpf_tramp_progs *tprogs,
 				void *orig_call);
@@ -565,6 +567,8 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog);
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
 u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog);
 void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start);
+void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
+void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
 
 struct bpf_ksym {
 	unsigned long		 start;
@@ -583,6 +587,18 @@ enum bpf_tramp_prog_type {
 	BPF_TRAMP_REPLACE, /* more than MAX */
 };
 
+struct bpf_tramp_image {
+	void *image;
+	struct bpf_ksym ksym;
+	struct percpu_ref pcref;
+	void *ip_after_call;
+	void *ip_epilogue;
+	union {
+		struct rcu_head rcu;
+		struct work_struct work;
+	};
+};
+
 struct bpf_trampoline {
 	/* hlist for trampoline_table */
 	struct hlist_node hlist;
@@ -605,9 +621,8 @@ struct bpf_trampoline {
 	/* Number of attached programs. A counter per kind. */
 	int progs_cnt[BPF_TRAMP_MAX];
 	/* Executable image of trampoline */
-	void *image;
+	struct bpf_tramp_image *cur_image;
 	u64 selector;
-	struct bpf_ksym ksym;
 };
 
 struct bpf_attach_target_info {
@@ -691,6 +706,8 @@ void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
 void bpf_image_ksym_del(struct bpf_ksym *ksym);
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
+int bpf_jit_charge_modmem(u32 pages);
+void bpf_jit_uncharge_modmem(u32 pages);
 #else
 static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
 					   struct bpf_trampoline *tr)
@@ -787,7 +804,6 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
-	enum bpf_tramp_prog_type trampoline_prog_type;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 1a666a975416..70f6fd4fa305 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -430,7 +430,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 
 		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
 		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
-		err = arch_prepare_bpf_trampoline(image,
+		err = arch_prepare_bpf_trampoline(NULL, image,
 						  st_map->image + PAGE_SIZE,
 						  &st_ops->func_models[i], 0,
 						  tprogs, NULL);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3a283bf97f2f..75244ecb2389 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -827,7 +827,7 @@ static int __init bpf_jit_charge_init(void)
 }
 pure_initcall(bpf_jit_charge_init);
 
-static int bpf_jit_charge_modmem(u32 pages)
+int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
@@ -840,7 +840,7 @@ static int bpf_jit_charge_modmem(u32 pages)
 	return 0;
 }
 
-static void bpf_jit_uncharge_modmem(u32 pages)
+void bpf_jit_uncharge_modmem(u32 pages)
 {
 	atomic_long_sub(pages, &bpf_jit_current);
 }
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7bc3b3209224..1f3a4be4b175 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -57,19 +57,10 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
 			   PAGE_SIZE, true, ksym->name);
 }
 
-static void bpf_trampoline_ksym_add(struct bpf_trampoline *tr)
-{
-	struct bpf_ksym *ksym = &tr->ksym;
-
-	snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu", tr->key);
-	bpf_image_ksym_add(tr->image, ksym);
-}
-
 static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
-	void *image;
 	int i;
 
 	mutex_lock(&trampoline_mutex);
@@ -84,14 +75,6 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	if (!tr)
 		goto out;
 
-	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
-	image = bpf_jit_alloc_exec_page();
-	if (!image) {
-		kfree(tr);
-		tr = NULL;
-		goto out;
-	}
-
 	tr->key = key;
 	INIT_HLIST_NODE(&tr->hlist);
 	hlist_add_head(&tr->hlist, head);
@@ -99,9 +82,6 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	mutex_init(&tr->mutex);
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
-	tr->image = image;
-	INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
-	bpf_trampoline_ksym_add(tr);
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
@@ -185,10 +165,142 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total)
 	return tprogs;
 }
 
+static void __bpf_tramp_image_put_deferred(struct work_struct *work)
+{
+	struct bpf_tramp_image *im;
+
+	im = container_of(work, struct bpf_tramp_image, work);
+	bpf_image_ksym_del(&im->ksym);
+	bpf_jit_free_exec(im->image);
+	bpf_jit_uncharge_modmem(1);
+	percpu_ref_exit(&im->pcref);
+	kfree_rcu(im, rcu);
+}
+
+/* callback, fexit step 3 or fentry step 2 */
+static void __bpf_tramp_image_put_rcu(struct rcu_head *rcu)
+{
+	struct bpf_tramp_image *im;
+
+	im = container_of(rcu, struct bpf_tramp_image, rcu);
+	INIT_WORK(&im->work, __bpf_tramp_image_put_deferred);
+	schedule_work(&im->work);
+}
+
+/* callback, fexit step 2. Called after percpu_ref_kill confirms. */
+static void __bpf_tramp_image_release(struct percpu_ref *pcref)
+{
+	struct bpf_tramp_image *im;
+
+	im = container_of(pcref, struct bpf_tramp_image, pcref);
+	call_rcu_tasks(&im->rcu, __bpf_tramp_image_put_rcu);
+}
+
+/* callback, fexit or fentry step 1 */
+static void __bpf_tramp_image_put_rcu_tasks(struct rcu_head *rcu)
+{
+	struct bpf_tramp_image *im;
+
+	im = container_of(rcu, struct bpf_tramp_image, rcu);
+	if (im->ip_after_call)
+		/* the case of fmod_ret/fexit trampoline and CONFIG_PREEMPTION=y */
+		percpu_ref_kill(&im->pcref);
+	else
+		/* the case of fentry trampoline */
+		call_rcu_tasks(&im->rcu, __bpf_tramp_image_put_rcu);
+}
+
+static void bpf_tramp_image_put(struct bpf_tramp_image *im)
+{
+	/* The trampoline image that calls original function is using:
+	 * rcu_read_lock_trace to protect sleepable bpf progs
+	 * rcu_read_lock to protect normal bpf progs
+	 * percpu_ref to protect trampoline itself
+	 * rcu tasks to protect trampoline asm not covered by percpu_ref
+	 * (which are few asm insns before __bpf_tramp_enter and
+	 *  after __bpf_tramp_exit)
+	 *
+	 * The trampoline is unreachable before bpf_tramp_image_put().
+	 *
+	 * First, patch the trampoline to avoid calling into fexit progs.
+	 * The progs will be freed even if the original function is still
+	 * executing or sleeping.
+	 * In case of CONFIG_PREEMPT=y use call_rcu_tasks() to wait on
+	 * first few asm instructions to execute and call into
+	 * __bpf_tramp_enter->percpu_ref_get.
+	 * Then use percpu_ref_kill to wait for the trampoline and the original
+	 * function to finish.
+	 * Then use call_rcu_tasks() to make sure few asm insns in
+	 * the trampoline epilogue are done as well.
+	 *
+	 * In !PREEMPT case the task that got interrupted in the first asm
+	 * insns won't go through an RCU quiescent state which the
+	 * percpu_ref_kill will be waiting for. Hence the first
+	 * call_rcu_tasks() is not necessary.
+	 */
+	if (im->ip_after_call) {
+		int err = bpf_arch_text_poke(im->ip_after_call, BPF_MOD_JUMP,
+					     NULL, im->ip_epilogue);
+		WARN_ON(err);
+		if (IS_ENABLED(CONFIG_PREEMPTION))
+			call_rcu_tasks(&im->rcu, __bpf_tramp_image_put_rcu_tasks);
+		else
+			percpu_ref_kill(&im->pcref);
+		return;
+	}
+
+	/* The trampoline without fexit and fmod_ret progs doesn't call original
+	 * function and doesn't use percpu_ref.
+	 * Use call_rcu_tasks_trace() to wait for sleepable progs to finish.
+	 * Then use call_rcu_tasks() to wait for the rest of trampoline asm
+	 * and normal progs.
+	 */
+	call_rcu_tasks_trace(&im->rcu, __bpf_tramp_image_put_rcu_tasks);
+}
+
+static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, u32 idx)
+{
+	struct bpf_tramp_image *im;
+	struct bpf_ksym *ksym;
+	void *image;
+	int err = -ENOMEM;
+
+	im = kzalloc(sizeof(*im), GFP_KERNEL);
+	if (!im)
+		goto out;
+
+	err = bpf_jit_charge_modmem(1);
+	if (err)
+		goto out_free_im;
+
+	err = -ENOMEM;
+	im->image = image = bpf_jit_alloc_exec_page();
+	if (!image)
+		goto out_uncharge;
+
+	err = percpu_ref_init(&im->pcref, __bpf_tramp_image_release, 0, GFP_KERNEL);
+	if (err)
+		goto out_free_image;
+
+	ksym = &im->ksym;
+	INIT_LIST_HEAD_RCU(&ksym->lnode);
+	snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu_%u", key, idx);
+	bpf_image_ksym_add(image, ksym);
+	return im;
+
+out_free_image:
+	bpf_jit_free_exec(im->image);
+out_uncharge:
+	bpf_jit_uncharge_modmem(1);
+out_free_im:
+	kfree(im);
+out:
+	return ERR_PTR(err);
+}
+
 static int bpf_trampoline_update(struct bpf_trampoline *tr)
 {
-	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
-	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
+	struct bpf_tramp_image *im;
 	struct bpf_tramp_progs *tprogs;
 	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
 	int err, total;
@@ -198,41 +310,42 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 		return PTR_ERR(tprogs);
 
 	if (total == 0) {
-		err = unregister_fentry(tr, old_image);
+		err = unregister_fentry(tr, tr->cur_image->image);
+		bpf_tramp_image_put(tr->cur_image);
+		tr->cur_image = NULL;
 		tr->selector = 0;
 		goto out;
 	}
 
+	im = bpf_tramp_image_alloc(tr->key, tr->selector);
+	if (IS_ERR(im)) {
+		err = PTR_ERR(im);
+		goto out;
+	}
+
 	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
 	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
 
-	/* Though the second half of trampoline page is unused a task could be
-	 * preempted in the middle of the first half of trampoline and two
-	 * updates to trampoline would change the code from underneath the
-	 * preempted task. Hence wait for tasks to voluntarily schedule or go
-	 * to userspace.
-	 * The same trampoline can hold both sleepable and non-sleepable progs.
-	 * synchronize_rcu_tasks_trace() is needed to make sure all sleepable
-	 * programs finish executing.
-	 * Wait for these two grace periods together.
-	 */
-	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
-
-	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
+	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
 					  &tr->func.model, flags, tprogs,
 					  tr->func.addr);
 	if (err < 0)
 		goto out;
 
-	if (tr->selector)
+	WARN_ON(tr->cur_image && tr->selector == 0);
+	WARN_ON(!tr->cur_image && tr->selector);
+	if (tr->cur_image)
 		/* progs already running at this address */
-		err = modify_fentry(tr, old_image, new_image);
+		err = modify_fentry(tr, tr->cur_image->image, im->image);
 	else
 		/* first time registering */
-		err = register_fentry(tr, new_image);
+		err = register_fentry(tr, im->image);
 	if (err)
 		goto out;
+	if (tr->cur_image)
+		bpf_tramp_image_put(tr->cur_image);
+	tr->cur_image = im;
 	tr->selector++;
 out:
 	kfree(tprogs);
@@ -364,17 +477,12 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 		goto out;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
-	bpf_image_ksym_del(&tr->ksym);
-	/* This code will be executed when all bpf progs (both sleepable and
-	 * non-sleepable) went through
-	 * bpf_prog_put()->call_rcu[_tasks_trace]()->bpf_prog_free_deferred().
-	 * Hence no need for another synchronize_rcu_tasks_trace() here,
-	 * but synchronize_rcu_tasks() is still needed, since trampoline
-	 * may not have had any sleepable programs and we need to wait
-	 * for tasks to get out of trampoline code before freeing it.
+	/* This code will be executed even when the last bpf_tramp_image
+	 * is alive. All progs are detached from the trampoline and the
+	 * trampoline image is patched with jmp into epilogue to skip
+	 * fexit progs. The fentry-only trampoline will be freed via
+	 * multiple rcu callbacks.
 	 */
-	synchronize_rcu_tasks();
-	bpf_jit_free_exec(tr->image);
 	hlist_del(&tr->hlist);
 	kfree(tr);
 out:
@@ -478,8 +586,18 @@ void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start)
 	rcu_read_unlock_trace();
 }
 
+void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr)
+{
+	percpu_ref_get(&tr->pcref);
+}
+
+void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr)
+{
+	percpu_ref_put(&tr->pcref);
+}
+
 int __weak
-arch_prepare_bpf_trampoline(void *image, void *image_end,
+arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
 			    const struct btf_func_model *m, u32 flags,
 			    struct bpf_tramp_progs *tprogs,
 			    void *orig_call)

