Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C6A3A581A
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhFML6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:58:45 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60149 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFML6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:58:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id ABBB17EA;
        Sun, 13 Jun 2021 07:56:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 13 Jun 2021 07:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ta2B6A
        bhGO7VD1vqc/Mk2CC0N1YqyY1qIP+qrHPrbgI=; b=IqhKRlOvha30iHhQaRb3gY
        DInst3bRZnz5DrZk5Kiv1fb7eEnfHKn7Ro8TbINAD+noKzCuMJhu9k0M41/5u14s
        unXkOrpUYtRO02fe62Nf/5yN5UcCFpcmis0lL64dZBQBqjEf0OQbA/sFoHAhlMsl
        q1W4SE3oeG0u7uWnemRKr2x7pikjl2i0Ueu2BOZdoAJmK0d/x6qO1nMI6pd9Gt72
        Nxgm9FLLlu2m5f28aTcosVIF5njcpcurBv7zi2bi1fmSxRlFDkhtXItTPNGMfYPf
        trUqco+y6mj/u7bBfOzVLoW3AEuANnZKwgp9lVxbY3atHenitpPjiljskz65grPQ
        ==
X-ME-Sender: <xms:efLFYP96bZXdzTrDR85rNiYIwkQEN-JKgXaPv4hcJGLEmajtAQkovw>
    <xme:efLFYLuUKMkXWdNKNMMEhQb34OZ-FGHlPCzeJkZS6BqIy_JQHuax4ruTGXVc0kgoS
    2UYkrohmq1V5Q>
X-ME-Received: <xmr:efLFYNCtq1ndkmFXkpDJ2IOfp0LldYj1t-wkqwESpfGMi2Ch-sCmv3Kqk7q_iFh49YGw-gohpxJXLlMp4xLKP_qaaKNZCTFe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:efLFYLdN5UypYgyjjxJNPEP59TTXPMrPLuspRrMzOSv2y3AhgoaLvg>
    <xmx:efLFYENFbFRadvxyloaPVzQvLeHcNW-AMi-F6S5AO-nmxqwWmxvpvw>
    <xmx:efLFYNlL_qzbx75UdCB_D8T9A5rJAX9N1zOXXGqRR52_8Lxk5QT_yQ>
    <xmx:efLFYLfDnNus1h6CuTMARLzeuRyWWyWY2GbXSsWml1NstRpX7N5JWldPIcE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:56:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Correct the length check which causes memory" failed to apply to 5.10-stable tree
To:     liangyan.peng@linux.alibaba.com, gregkh@linuxfoundation.org,
        jnwang@linux.alibaba.com, mingo@redhat.com, rostedt@goodmis.org,
        wetp.zy@linux.alibaba.com, xlpang@linux.alibaba.com,
        yinbinbin@alibabacloud.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:56:27 +0200
Message-ID: <162358538716087@kroah.com>
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

From 3e08a9f9760f4a70d633c328a76408e62d6f80a3 Mon Sep 17 00:00:00 2001
From: Liangyan <liangyan.peng@linux.alibaba.com>
Date: Mon, 7 Jun 2021 20:57:34 +0800
Subject: [PATCH] tracing: Correct the length check which causes memory
 corruption

We've suffered from severe kernel crashes due to memory corruption on
our production environment, like,

Call Trace:
[1640542.554277] general protection fault: 0000 [#1] SMP PTI
[1640542.554856] CPU: 17 PID: 26996 Comm: python Kdump: loaded Tainted:G
[1640542.556629] RIP: 0010:kmem_cache_alloc+0x90/0x190
[1640542.559074] RSP: 0018:ffffb16faa597df8 EFLAGS: 00010286
[1640542.559587] RAX: 0000000000000000 RBX: 0000000000400200 RCX:
0000000006e931bf
[1640542.560323] RDX: 0000000006e931be RSI: 0000000000400200 RDI:
ffff9a45ff004300
[1640542.560996] RBP: 0000000000400200 R08: 0000000000023420 R09:
0000000000000000
[1640542.561670] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff9a20608d
[1640542.562366] R13: ffff9a45ff004300 R14: ffff9a45ff004300 R15:
696c662f65636976
[1640542.563128] FS:  00007f45d7c6f740(0000) GS:ffff9a45ff840000(0000)
knlGS:0000000000000000
[1640542.563937] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1640542.564557] CR2: 00007f45d71311a0 CR3: 000000189d63e004 CR4:
00000000003606e0
[1640542.565279] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1640542.566069] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[1640542.566742] Call Trace:
[1640542.567009]  anon_vma_clone+0x5d/0x170
[1640542.567417]  __split_vma+0x91/0x1a0
[1640542.567777]  do_munmap+0x2c6/0x320
[1640542.568128]  vm_munmap+0x54/0x70
[1640542.569990]  __x64_sys_munmap+0x22/0x30
[1640542.572005]  do_syscall_64+0x5b/0x1b0
[1640542.573724]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[1640542.575642] RIP: 0033:0x7f45d6e61e27

James Wang has reproduced it stably on the latest 4.19 LTS.
After some debugging, we finally proved that it's due to ftrace
buffer out-of-bound access using a debug tool as follows:
[   86.775200] BUG: Out-of-bounds write at addr 0xffff88aefe8b7000
[   86.780806]  no_context+0xdf/0x3c0
[   86.784327]  __do_page_fault+0x252/0x470
[   86.788367]  do_page_fault+0x32/0x140
[   86.792145]  page_fault+0x1e/0x30
[   86.795576]  strncpy_from_unsafe+0x66/0xb0
[   86.799789]  fetch_memory_string+0x25/0x40
[   86.804002]  fetch_deref_string+0x51/0x60
[   86.808134]  kprobe_trace_func+0x32d/0x3a0
[   86.812347]  kprobe_dispatcher+0x45/0x50
[   86.816385]  kprobe_ftrace_handler+0x90/0xf0
[   86.820779]  ftrace_ops_assist_func+0xa1/0x140
[   86.825340]  0xffffffffc00750bf
[   86.828603]  do_sys_open+0x5/0x1f0
[   86.832124]  do_syscall_64+0x5b/0x1b0
[   86.835900]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

commit b220c049d519 ("tracing: Check length before giving out
the filter buffer") adds length check to protect trace data
overflow introduced in 0fc1b09ff1ff, seems that this fix can't prevent
overflow entirely, the length check should also take the sizeof
entry->array[0] into account, since this array[0] is filled the
length of trace data and occupy addtional space and risk overflow.

Link: https://lkml.kernel.org/r/20210607125734.1770447-1-liangyan.peng@linux.alibaba.com

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: b220c049d519 ("tracing: Check length before giving out the filter buffer")
Reviewed-by: Xunlei Pang <xlpang@linux.alibaba.com>
Reviewed-by: yinbinbin <yinbinbin@alibabacloud.com>
Reviewed-by: Wetp Zhang <wetp.zy@linux.alibaba.com>
Tested-by: James Wang <jnwang@linux.alibaba.com>
Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a21ef9cd2aae..9299057feb56 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2736,7 +2736,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
 	    (entry = this_cpu_read(trace_buffered_event))) {
 		/* Try to use the per cpu buffer first */
 		val = this_cpu_inc_return(trace_buffered_event_cnt);
-		if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
+		if ((len < (PAGE_SIZE - sizeof(*entry) - sizeof(entry->array[0]))) && val == 1) {
 			trace_event_setup(entry, type, trace_ctx);
 			entry->array[0] = len;
 			return entry;

