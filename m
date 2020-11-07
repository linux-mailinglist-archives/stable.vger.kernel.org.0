Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE462AA664
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgKGPpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:45:39 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60893 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgKGPpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:45:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7648CF92;
        Sat,  7 Nov 2020 10:45:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:45:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2fY4kg
        uoIOD40AzN5p9XED+OLmjgSXZmX9yfw7i/k1g=; b=gWJuxMJzU6DjHyJpjOqJqZ
        RODSUKTv0PUd8d9Mv64JOngVgNBlhjZNXHhX5Bvs9MNGAMJpvSdbee4Mvj7CvYyr
        5YvIFzTV9b6nM9cztQ09NEC3eMzIUZIN08itLz7ggDZsq6/UwA8VH+ANCn8rz7FC
        1rlNdsvSY5oH8hKkcamFIdh3Oi7a0tQIzjZ/etrK7HmmOf5xHXAUvz117+8JUOLW
        tBr3MhMr5vm8Ion33kwtF5FH/HlihJdDAPX5c9yZ1IsxIhJEKy32+QiPGH307Ju3
        C7ULgTGkvfkJ9OpCJM/WmzuAT+DXojRevKmnyFsJt/8YrWICnaVJPZ8v+xuQWXOg
        ==
X-ME-Sender: <xms:IcGmX_RSJ8c9iSh0Va6z4tPCMkF5HmdEBzKzAEtcHUCb8rL5MAjrtA>
    <xme:IcGmXwymK3mE4SohTgyOzA4eByYN3Dn3Pbp6SZ_uAGD-4tEUunVne0P437GNtnuRH
    nGGOqiYCUtbtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:IcGmX03TNEFlFksMV2Ns7ji1U5RaHDEWZgfIZfbLFK7iGXNBXAp-og>
    <xmx:IcGmX_CRNA8f7AmUXJe7NP1zBijn54ro5DVYwH2D4HW41fb7u70dzg>
    <xmx:IcGmX4iHA5ryRFCpZXmFqvrAIWaJhQF2It0tfiy2XkOwMnocz3LYVg>
    <xmx:IsGmX2cOQp4fdRRmgAuVyBudVCt95VD7Fs3MvkPY4gz01w4gNNUNxKmM97M>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5767C3060579;
        Sat,  7 Nov 2020 10:45:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] ring-buffer: Fix recursion protection transitions between" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:46:22 +0100
Message-ID: <1604763982232117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b02414c8f045ab3b9afc816c3735bc98c5c3d262 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 2 Nov 2020 15:31:27 -0500
Subject: [PATCH] ring-buffer: Fix recursion protection transitions between
 interrupt context

The recursion protection of the ring buffer depends on preempt_count() to be
correct. But it is possible that the ring buffer gets called after an
interrupt comes in but before it updates the preempt_count(). This will
trigger a false positive in the recursion code.

Use the same trick from the ftrace function callback recursion code which
uses a "transition" bit that gets set, to allow for a single recursion for
to handle transitions between contexts.

Cc: stable@vger.kernel.org
Fixes: 567cd4da54ff4 ("ring-buffer: User context bit recursion checking")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f45fd9d5a45..dc83b3fa9fe7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -438,14 +438,16 @@ enum {
 };
 /*
  * Used for which event context the event is in.
- *  NMI     = 0
- *  IRQ     = 1
- *  SOFTIRQ = 2
- *  NORMAL  = 3
+ *  TRANSITION = 0
+ *  NMI     = 1
+ *  IRQ     = 2
+ *  SOFTIRQ = 3
+ *  NORMAL  = 4
  *
  * See trace_recursive_lock() comment below for more details.
  */
 enum {
+	RB_CTX_TRANSITION,
 	RB_CTX_NMI,
 	RB_CTX_IRQ,
 	RB_CTX_SOFTIRQ,
@@ -3014,10 +3016,10 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
  * a bit of overhead in something as critical as function tracing,
  * we use a bitmask trick.
  *
- *  bit 0 =  NMI context
- *  bit 1 =  IRQ context
- *  bit 2 =  SoftIRQ context
- *  bit 3 =  normal context.
+ *  bit 1 =  NMI context
+ *  bit 2 =  IRQ context
+ *  bit 3 =  SoftIRQ context
+ *  bit 4 =  normal context.
  *
  * This works because this is the order of contexts that can
  * preempt other contexts. A SoftIRQ never preempts an IRQ
@@ -3040,6 +3042,30 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
  * The least significant bit can be cleared this way, and it
  * just so happens that it is the same bit corresponding to
  * the current context.
+ *
+ * Now the TRANSITION bit breaks the above slightly. The TRANSITION bit
+ * is set when a recursion is detected at the current context, and if
+ * the TRANSITION bit is already set, it will fail the recursion.
+ * This is needed because there's a lag between the changing of
+ * interrupt context and updating the preempt count. In this case,
+ * a false positive will be found. To handle this, one extra recursion
+ * is allowed, and this is done by the TRANSITION bit. If the TRANSITION
+ * bit is already set, then it is considered a recursion and the function
+ * ends. Otherwise, the TRANSITION bit is set, and that bit is returned.
+ *
+ * On the trace_recursive_unlock(), the TRANSITION bit will be the first
+ * to be cleared. Even if it wasn't the context that set it. That is,
+ * if an interrupt comes in while NORMAL bit is set and the ring buffer
+ * is called before preempt_count() is updated, since the check will
+ * be on the NORMAL bit, the TRANSITION bit will then be set. If an
+ * NMI then comes in, it will set the NMI bit, but when the NMI code
+ * does the trace_recursive_unlock() it will clear the TRANSTION bit
+ * and leave the NMI bit set. But this is fine, because the interrupt
+ * code that set the TRANSITION bit will then clear the NMI bit when it
+ * calls trace_recursive_unlock(). If another NMI comes in, it will
+ * set the TRANSITION bit and continue.
+ *
+ * Note: The TRANSITION bit only handles a single transition between context.
  */
 
 static __always_inline int
@@ -3055,8 +3081,16 @@ trace_recursive_lock(struct ring_buffer_per_cpu *cpu_buffer)
 		bit = pc & NMI_MASK ? RB_CTX_NMI :
 			pc & HARDIRQ_MASK ? RB_CTX_IRQ : RB_CTX_SOFTIRQ;
 
-	if (unlikely(val & (1 << (bit + cpu_buffer->nest))))
-		return 1;
+	if (unlikely(val & (1 << (bit + cpu_buffer->nest)))) {
+		/*
+		 * It is possible that this was called by transitioning
+		 * between interrupt context, and preempt_count() has not
+		 * been updated yet. In this case, use the TRANSITION bit.
+		 */
+		bit = RB_CTX_TRANSITION;
+		if (val & (1 << (bit + cpu_buffer->nest)))
+			return 1;
+	}
 
 	val |= (1 << (bit + cpu_buffer->nest));
 	cpu_buffer->current_context = val;
@@ -3071,8 +3105,8 @@ trace_recursive_unlock(struct ring_buffer_per_cpu *cpu_buffer)
 		cpu_buffer->current_context - (1 << cpu_buffer->nest);
 }
 
-/* The recursive locking above uses 4 bits */
-#define NESTED_BITS 4
+/* The recursive locking above uses 5 bits */
+#define NESTED_BITS 5
 
 /**
  * ring_buffer_nest_start - Allow to trace while nested

