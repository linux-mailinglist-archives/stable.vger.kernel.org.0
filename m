Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2712AA665
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgKGPpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:45:41 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33907 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgKGPpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:45:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0E1C5F93;
        Sat,  7 Nov 2020 10:45:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=j38/LA
        7g3QIEZUt50I4KGtFBwSyRzbT5s51yqEy0iCg=; b=QkxAFc8uDvlo9mkZmX7CWq
        5D3fPcRy85/Q6Z0c7fofNg+ZRgzfRCu//H7SIpk+6dSTXPv3axFR4k4vuAmZOEQt
        jMAZvmiR1X58rH2xHQUJEr5xsWdW8Np5+/SqqNyE2sjBhbIThEkBefm38Qfn4hHV
        kMTgtSyO66DrZ+36k5xEJ9LrSwP9wk7MQ6PqE+uFDLXbOCSMx0I1W7g8F4nBHWH5
        rTpRFfw7ll7SLH6Wg7SnJQg03cAxZyjsbDqH0ZyVBaytS1nRr+hPJGHXFET5boQk
        UFiG10yZGdKRdK0st6+F5NRGzDhA+E2CORlu26idnZmgTLESvk+ecZA7Nk4iRuxQ
        ==
X-ME-Sender: <xms:I8GmXzUzoD4CMcB1hyN-dSWN_LdxhGcS1ImDQGqSWy4uNG17cB9EWg>
    <xme:I8GmX7mHCQvu-exS_VxRq8YZa6eLTc2Tuv5zRSYaiUN2aR5aPsLky5hepI7EGBbVY
    Jf_j1j2jaEIvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:I8GmX_ZX68aItfVrGffrbnepIUR5ljoiNzMEJTR9_Fm8Ay9wCmR9lg>
    <xmx:I8GmX-Xj5tIJaoz2aaMp3o5qDH0oj32dI6NPWT7sWAqSrtkjFrwIpA>
    <xmx:I8GmX9mKbiak-M4K0EvorrDzvzGDd6KpBhTOC6WP-heBDPAJZPkeOw>
    <xmx:I8GmX7SYB0wnj68joCAcVfBkVewsM0rpuibhxdP9EL3vwUND5WROds41t5A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17DB232803D4;
        Sat,  7 Nov 2020 10:45:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] ring-buffer: Fix recursion protection transitions between" failed to apply to 4.9-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:46:24 +0100
Message-ID: <16047639846098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

