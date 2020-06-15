Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C9B1F9B38
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgFOPAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:00:33 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:48419 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730859AbgFOPAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:00:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BF5CF793;
        Mon, 15 Jun 2020 11:00:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PRjlmM
        UENDQewJaDz/XcZeFud5OJRkyqbEbe7G1CBrY=; b=b0fiMwwwU2b5To92Y9yqPr
        L3BH8Lms7qJYkn4cZfoQvVfmdJYKq4JZFz7KBNhbPRboZvNzxYY84L5ZZdut7ZLS
        5vzYj4fFo3Iokh1t/T4HSXy9y1J3sQH7B8z3SLVkWGFcH19hquhHOIJME11Hdz6I
        EuMI78WEiwG4fZXCzieUWqMPvnzKsTXdWBFhKt5MQy52BKskqwLUm0dLPPyl+qkL
        ZoJu8C5bNBoC0nbwxujemdV2zM8riw8Yj9HWbXSmQmbWJGTuocbUi6FHcGgAnKVo
        NbHLxELf9jZK7sFYTm4nUnEdTDlhwsedGNBs0kY2FngK6UjwZmy9/Ba2bK1AzMHw
        ==
X-ME-Sender: <xms:Do3nXiqb66wUO2Huibjfx4-YRRfSECTHNYlEMk8IhN93kyQXqHOZ6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:D43nXgrpZgxgJ9j_lnTShQtgjy5bz5cpiobtWdjV7V4_auD4kEvN_A>
    <xmx:D43nXnONyDXjSEUYwaEYhd1w7dNWekL5ytI694dFB9S5w2QT88AuQw>
    <xmx:D43nXh74YHoXHNfYuYazbQak6_ToIlFsZiut7EbRFxoxyY4yHW0ufA>
    <xmx:D43nXjSpR5ooQxjTAOHXuJ-QOKsL7YUBoqUHt595O7rvE0GW7PG69Sf7iwY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9328B3280060;
        Mon, 15 Jun 2020 11:00:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/{mce,mm}: Unmap the entire page if the whole page is" failed to apply to 5.6-stable tree
To:     tony.luck@intel.com, bp@suse.de, juew@google.com,
        stable@vger.kernel.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:00:13 +0200
Message-ID: <15922332135132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 17fae1294ad9d711b2c3dd0edef479d40c76a5e8 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Wed, 20 May 2020 09:35:46 -0700
Subject: [PATCH] x86/{mce,mm}: Unmap the entire page if the whole page is
 affected and poisoned

An interesting thing happened when a guest Linux instance took a machine
check. The VMM unmapped the bad page from guest physical space and
passed the machine check to the guest.

Linux took all the normal actions to offline the page from the process
that was using it. But then guest Linux crashed because it said there
was a second machine check inside the kernel with this stack trace:

do_memory_failure
    set_mce_nospec
         set_memory_uc
              _set_memory_uc
                   change_page_attr_set_clr
                        cpa_flush
                             clflush_cache_range_opt

This was odd, because a CLFLUSH instruction shouldn't raise a machine
check (it isn't consuming the data). Further investigation showed that
the VMM had passed in another machine check because is appeared that the
guest was accessing the bad page.

Fix is to check the scope of the poison by checking the MCi_MISC register.
If the entire page is affected, then unmap the page. If only part of the
page is affected, then mark the page as uncacheable.

This assumes that VMMs will do the logical thing and pass in the "whole
page scope" via the MCi_MISC register (since they unmapped the entire
page).

  [ bp: Adjust to x86/entry changes. ]

Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
Reported-by: Jue Wang <juew@google.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jue Wang <juew@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200520163546.GA7977@agluck-desk2.amr.corp.intel.com

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index ec2c0a094b5d..5948218f35c5 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -86,28 +86,35 @@ int set_direct_map_default_noflush(struct page *page);
 extern int kernel_set_to_readonly;
 
 #ifdef CONFIG_X86_64
-static inline int set_mce_nospec(unsigned long pfn)
+/*
+ * Prevent speculative access to the page by either unmapping
+ * it (if we do not require access to any part of the page) or
+ * marking it uncacheable (if we want to try to retrieve data
+ * from non-poisoned lines in the page).
+ */
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	unsigned long decoy_addr;
 	int rc;
 
 	/*
-	 * Mark the linear address as UC to make sure we don't log more
-	 * errors because of speculative access to the page.
 	 * We would like to just call:
-	 *      set_memory_uc((unsigned long)pfn_to_kaddr(pfn), 1);
+	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
 	 * but doing that would radically increase the odds of a
 	 * speculative access to the poison page because we'd have
 	 * the virtual address of the kernel 1:1 mapping sitting
 	 * around in registers.
 	 * Instead we get tricky.  We create a non-canonical address
 	 * that looks just like the one we want, but has bit 63 flipped.
-	 * This relies on set_memory_uc() properly sanitizing any __pa()
+	 * This relies on set_memory_XX() properly sanitizing any __pa()
 	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
 	 */
 	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
 
-	rc = set_memory_uc(decoy_addr, 1);
+	if (unmap)
+		rc = set_memory_np(decoy_addr, 1);
+	else
+		rc = set_memory_uc(decoy_addr, 1);
 	if (rc)
 		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
 	return rc;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 30413325de22..ce9120c4f740 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -520,6 +520,14 @@ bool mce_is_memory_error(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_memory_error);
 
+static bool whole_page(struct mce *m)
+{
+	if (!mca_cfg.ser || !(m->status & MCI_STATUS_MISCV))
+		return true;
+
+	return MCI_MISC_ADDR_LSB(m->misc) >= PAGE_SHIFT;
+}
+
 bool mce_is_correctable(struct mce *m)
 {
 	if (m->cpuvendor == X86_VENDOR_AMD && m->status & MCI_STATUS_DEFERRED)
@@ -573,7 +581,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
 
 	pfn = mce->addr >> PAGE_SHIFT;
 	if (!memory_failure(pfn, 0)) {
-		set_mce_nospec(pfn);
+		set_mce_nospec(pfn, whole_page(mce));
 		mce->kflags |= MCE_HANDLED_UC;
 	}
 
@@ -1173,11 +1181,12 @@ static void kill_me_maybe(struct callback_head *cb)
 	int flags = MF_ACTION_REQUIRED;
 
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
-	if (!(p->mce_status & MCG_STATUS_RIPV))
+
+	if (!p->mce_ripv)
 		flags |= MF_MUST_KILL;
 
 	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, flags)) {
-		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
+		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
 		return;
 	}
 
@@ -1331,7 +1340,8 @@ void noinstr do_machine_check(struct pt_regs *regs)
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
 		current->mce_addr = m.addr;
-		current->mce_status = m.mcgstatus;
+		current->mce_ripv = !!(m.mcgstatus & MCG_STATUS_RIPV);
+		current->mce_whole_page = whole_page(&m);
 		current->mce_kill_me.func = kill_me_maybe;
 		if (kill_it)
 			current->mce_kill_me.func = kill_me_now;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d96e3e7fff..62c1de522fc5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1304,7 +1304,9 @@ struct task_struct {
 
 #ifdef CONFIG_X86_MCE
 	u64				mce_addr;
-	u64				mce_status;
+	__u64				mce_ripv : 1,
+					mce_whole_page : 1,
+					__mce_reserved : 62;
 	struct callback_head		mce_kill_me;
 #endif
 
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 86281ac7c305..860e0f843c12 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -26,7 +26,7 @@ static inline int set_direct_map_default_noflush(struct page *page)
 #endif
 
 #ifndef set_mce_nospec
-static inline int set_mce_nospec(unsigned long pfn)
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }

