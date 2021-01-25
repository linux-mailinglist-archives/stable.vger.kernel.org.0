Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D063032E1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbhAZEje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:39:34 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:34579 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730255AbhAYPmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 10:42:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 78C5CF68;
        Mon, 25 Jan 2021 10:16:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 10:16:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kd5RG3
        22iGRCklBeA/2vWBSFtk0zzbQPyoh+4lOmsOI=; b=X48cEMCHAe0RXF6kasEIDs
        4rpud+zLnTs8Sj34ONe8T3dvRyEqdyZ0+Bt9Ur/j26/UarqLl8ntiHKW3rEDyMAb
        hjJkz+gzzM1T4J897nuM3qa1KTc5D6NGONJwBU59P6uBDHV4wn9pB9pwmribzGHG
        /Z2O9+dnbJ8RpxH/bKuZhJWVl4i1XwUuQtYXBS4+l2QxsPGGuUDi2zas7Mz7slnR
        hjq3Fp5cDWn71BpCqRzVk4f4egQqfn8KfikZs4N78bPejCNpT44G+QLZIfwCHxzh
        rzFoDQ823576bsIpayC5BowTzQ8Wa4lPypr5kHrdVN4lO3Q6zEhgGorMJw/Ltatw
        ==
X-ME-Sender: <xms:wuAOYO-RVmhC1cT3oHAguK2wGtWmNc5Mbr1VGh-tJUs_IN_bb6tlRQ>
    <xme:wuAOYOv4QkYNfgXkIjmJqCHs_Uio4qw9WenSUJ8URyQ6WwmK-ikZBk4k3NJ8_GiNF
    F1ABbfXME0g9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wuAOYEB2K1Be_aEb8qC057hAALL2C7iKdbgl14331YO0AKHkWDLjCQ>
    <xmx:wuAOYGdFovb8A4HgNBQ7-3wNwXYeOtcScXz4OZgpsUKGMazZE05qLw>
    <xmx:wuAOYDPbqVahcS1GIJyU5Qa79kWsE4DZe9xb1I-qctA1IUfGdL1qqw>
    <xmx:wuAOYJ32P7DxbIT3rbCCaMP9aaGryGdsQ0nCRN0uaOo-Zl-CKsgmy9vo-yQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A027A240067;
        Mon, 25 Jan 2021 10:16:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] net_sched: gen_estimator: support large ewma log" failed to apply to 4.14-stable tree
To:     edumazet@google.com, kuba@kernel.org, syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 16:16:07 +0100
Message-ID: <161158776743223@kroah.com>
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

From dd5e073381f2ada3630f36be42833c6e9c78b75e Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 14 Jan 2021 10:19:29 -0800
Subject: [PATCH] net_sched: gen_estimator: support large ewma log

syzbot report reminded us that very big ewma_log were supported in the past,
even if they made litle sense.

tc qdisc replace dev xxx root est 1sec 131072sec ...

While fixing the bug, also add boundary checks for ewma_log, in line
with range supported by iproute2.

UBSAN: shift-out-of-bounds in net/core/gen_estimator.c:83:38
shift exponent -1 is negative
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 est_timer.cold+0xbb/0x12d net/core/gen_estimator.c:83
 call_timer_fn+0x1a5/0x710 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x692/0xa80 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1744
 __do_softirq+0x2bc/0xa77 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x17f/0x200 kernel/softirq.c:420
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516

Fixes: 1c0d32fde5bd ("net_sched: gen_estimator: complete rewrite of rate estimators")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20210114181929.1717985-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 80dbf2f4016e..8e582e29a41e 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -80,11 +80,11 @@ static void est_timer(struct timer_list *t)
 	u64 rate, brate;
 
 	est_fetch_counters(est, &b);
-	brate = (b.bytes - est->last_bytes) << (10 - est->ewma_log - est->intvl_log);
-	brate -= (est->avbps >> est->ewma_log);
+	brate = (b.bytes - est->last_bytes) << (10 - est->intvl_log);
+	brate = (brate >> est->ewma_log) - (est->avbps >> est->ewma_log);
 
-	rate = (b.packets - est->last_packets) << (10 - est->ewma_log - est->intvl_log);
-	rate -= (est->avpps >> est->ewma_log);
+	rate = (b.packets - est->last_packets) << (10 - est->intvl_log);
+	rate = (rate >> est->ewma_log) - (est->avpps >> est->ewma_log);
 
 	write_seqcount_begin(&est->seq);
 	est->avbps += brate;
@@ -143,6 +143,9 @@ int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 	if (parm->interval < -2 || parm->interval > 3)
 		return -EINVAL;
 
+	if (parm->ewma_log == 0 || parm->ewma_log >= 31)
+		return -EINVAL;
+
 	est = kzalloc(sizeof(*est), GFP_KERNEL);
 	if (!est)
 		return -ENOBUFS;

