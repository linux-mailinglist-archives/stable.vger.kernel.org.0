Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6027D312EC2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBHKSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:18:53 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56877 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232026AbhBHKPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:15:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 50B3FA8F;
        Mon,  8 Feb 2021 05:12:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=J7Mkgb
        8VnmvuyjnEA9HDDPSxuie3lPs2PRTUJUYmXkg=; b=EhtHAJw7ATQ613yRi7meFE
        pdT/uh8OZazu6k/g4m/NW+w8taPKdtvK7rJtdvHMbUIjc3LAg/97UTvkrS/vkEO9
        dcd+V/7BFT27wHUunb+vMP0jFGlHpDoeCVzwFiT2+EXFeoWm9IRS4/2Jx+xeUxYi
        auSUuKjG8f7++5XXVFa/wguxAVch77Uu0kzFa3jN+cAZAl3W8WFKWSFR1rXnzPt2
        pELMMvIUq9eO5fmhHBCqDh4PXL9CtDmo0ugq5TmkbIanbORjSbSsunp0hEF1lXna
        9I/InRUyqcEKPERR9WMS21OPpwa40OzZ7E325VjnUksMWYWpueFv1JVCJQSEf+Qw
        ==
X-ME-Sender: <xms:oA4hYG3cvBm2EyUI3DpeZaV2oyuYnjpktRlHuiYMOvSP3WtHRHCCUQ>
    <xme:oA4hYJHk5aUlOV3IEY6XsCJaGinGLeDYjnb3_-gLSp4hd8WNCObTlNV5O6xps-Vld
    rN1zoUkXzuIkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oA4hYO7vSJmZue5y0m37pwRD495QyZcTLhv9IkYopY2gufprG4v44Q>
    <xmx:oA4hYH1o6aMfEVtD2PNX-SavPhl8c-IBS88fyBvbyadEqwSEV1tGuQ>
    <xmx:oA4hYJGPwXPC96WGVb6mPr3wY67UEQUZZbYrWHRaKPC40pPuHr5Gjg>
    <xmx:oA4hYHMmZPGofWlrUwbdQUMNpN92mGrTEfbq7-PC8NJJUSarnzaDUphD_XA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E1CD24005E;
        Mon,  8 Feb 2021 05:12:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] tracing/kprobe: Fix to support kretprobe events on unloaded" failed to apply to 5.4-stable tree
To:     mhiramat@kernel.org, Jianlin.Lv@arm.com, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:12:39 +0100
Message-ID: <161277915958242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 97c753e62e6c31a404183898d950d8c08d752dbd Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 28 Jan 2021 00:37:51 +0900
Subject: [PATCH] tracing/kprobe: Fix to support kretprobe events on unloaded
 modules

Fix kprobe_on_func_entry() returns error code instead of false so that
register_kretprobe() can return an appropriate error code.

append_trace_kprobe() expects the kprobe registration returns -ENOENT
when the target symbol is not found, and it checks whether the target
module is unloaded or not. If the target module doesn't exist, it
defers to probe the target symbol until the module is loaded.

However, since register_kretprobe() returns -EINVAL instead of -ENOENT
in that case, it always fail on putting the kretprobe event on unloaded
modules. e.g.

Kprobe event:
/sys/kernel/debug/tracing # echo p xfs:xfs_end_io >> kprobe_events
[   16.515574] trace_kprobe: This probe might be able to register after target module is loaded. Continue.

Kretprobe event: (p -> r)
/sys/kernel/debug/tracing # echo r xfs:xfs_end_io >> kprobe_events
sh: write error: Invalid argument
/sys/kernel/debug/tracing # cat error_log
[   41.122514] trace_kprobe: error: Failed to register probe event
  Command: r xfs:xfs_end_io
             ^

To fix this bug, change kprobe_on_func_entry() to detect symbol lookup
failure and return -ENOENT in that case. Otherwise it returns -EINVAL
or 0 (succeeded, given address is on the entry).

Link: https://lkml.kernel.org/r/161176187132.1067016.8118042342894378981.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 59158ec4aef7 ("tracing/kprobes: Check the probe on unloaded module correctly")
Reported-by: Jianlin Lv <Jianlin.Lv@arm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index b3a36b0cfc81..1883a4a9f16a 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -266,7 +266,7 @@ extern void kprobes_inc_nmissed_count(struct kprobe *p);
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
 extern int arch_populate_kprobe_blacklist(void);
 extern bool arch_kprobe_on_func_entry(unsigned long offset);
-extern bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
+extern int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
 
 extern bool within_kprobe_blacklist(unsigned long addr);
 extern int kprobe_add_ksym_blacklist(unsigned long entry);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f7fb5d135930..1a5bc321e0a5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1954,29 +1954,45 @@ bool __weak arch_kprobe_on_func_entry(unsigned long offset)
 	return !offset;
 }
 
-bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
+/**
+ * kprobe_on_func_entry() -- check whether given address is function entry
+ * @addr: Target address
+ * @sym:  Target symbol name
+ * @offset: The offset from the symbol or the address
+ *
+ * This checks whether the given @addr+@offset or @sym+@offset is on the
+ * function entry address or not.
+ * This returns 0 if it is the function entry, or -EINVAL if it is not.
+ * And also it returns -ENOENT if it fails the symbol or address lookup.
+ * Caller must pass @addr or @sym (either one must be NULL), or this
+ * returns -EINVAL.
+ */
+int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
 {
 	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
 
 	if (IS_ERR(kp_addr))
-		return false;
+		return PTR_ERR(kp_addr);
 
-	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
-						!arch_kprobe_on_func_entry(offset))
-		return false;
+	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset))
+		return -ENOENT;
 
-	return true;
+	if (!arch_kprobe_on_func_entry(offset))
+		return -EINVAL;
+
+	return 0;
 }
 
 int register_kretprobe(struct kretprobe *rp)
 {
-	int ret = 0;
+	int ret;
 	struct kretprobe_instance *inst;
 	int i;
 	void *addr;
 
-	if (!kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset))
-		return -EINVAL;
+	ret = kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset);
+	if (ret)
+		return ret;
 
 	if (kretprobe_blacklist_size) {
 		addr = kprobe_addr(&rp->kp);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index e6fba1798771..56c7fbff7bd7 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -221,9 +221,9 @@ bool trace_kprobe_on_func_entry(struct trace_event_call *call)
 {
 	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
 
-	return tk ? kprobe_on_func_entry(tk->rp.kp.addr,
+	return tk ? (kprobe_on_func_entry(tk->rp.kp.addr,
 			tk->rp.kp.addr ? NULL : tk->rp.kp.symbol_name,
-			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) : false;
+			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) == 0) : false;
 }
 
 bool trace_kprobe_error_injectable(struct trace_event_call *call)
@@ -828,9 +828,11 @@ static int trace_kprobe_create(int argc, const char *argv[])
 		}
 		if (is_return)
 			flags |= TPARG_FL_RETURN;
-		if (kprobe_on_func_entry(NULL, symbol, offset))
+		ret = kprobe_on_func_entry(NULL, symbol, offset);
+		if (ret == 0)
 			flags |= TPARG_FL_FENTRY;
-		if (offset && is_return && !(flags & TPARG_FL_FENTRY)) {
+		/* Defer the ENOENT case until register kprobe */
+		if (ret == -EINVAL && is_return) {
 			trace_probe_log_err(0, BAD_RETPROBE);
 			goto parse_error;
 		}

