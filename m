Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C645230F807
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbhBDQdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238084AbhBDQdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 11:33:17 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C41C061786
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 08:32:36 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l12so4290019wry.2
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 08:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HuBnP8xcfwvU5huDIYCtR/lw8V4aZzJFUtPoRjMCG/g=;
        b=vI4pmK7xNiF8hoylxrR0JygvOfJCPFZ303EyhbOjKAL8/to9cIFoH+OVwJUkHMqjx0
         G6y9HnC1ID/qw1ofubCbey5/w1s2d1ZdOM67sy1xsnUsAxkEkiW9ft2iMzFSFgkBnKB1
         m1QqLTKNsbC7IXnsZdFpDup9v7VHGMQ2Cxn/y42keOPOHrjqmr4OGFveYMrFrNnCgfDX
         UJDadNzEYd7xbQU9nNK4n6d8pC4s2eiNMK9jehj/Epjdo/nPQEOdE8r5vuuz0yclUEkX
         7rMrPp6wcTgHXOkQvsVwJ+iJa4DeLDjQB0TZTaCzrbnVBx29rtTz10gfYeiniBA149ep
         spvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HuBnP8xcfwvU5huDIYCtR/lw8V4aZzJFUtPoRjMCG/g=;
        b=tvhUR1CNS1vx05csL6VKa59DUyyaJfQwz+ZDEn3jh/GPYAVpu35qOIOO4sSok0oIQW
         vkjXHi2PvysnmPVD0iQUonIW0TFw5ItuFMXTXpw+yICNXD9/iyawfs6K3/HAmn5a8LmL
         KtsAHQ92E25R9DGv0iICDSBxW7PkO82cNU5x/eX81awoUvIQzvHe7HD83z8cKH/gWaZc
         bZOT2ElFIpqSd3WAq6VhHfEhxep3HdcS/rVQdx8RtVoetIRXr7NrlHwxo6OgQsL0s4mZ
         x5/08b8gSrL77qZI57pgOHi8nz0CvjdiimLQyD5dHVg42O3nlmKvKgcbFCJ+stTTNFpQ
         QxSw==
X-Gm-Message-State: AOAM533Ec+B2boxC2J12eUjPGE7xibliGL+rgFABQo9YMcpfXI3Cxb+u
        91J1bWPM3BhKA6uTzNk2MqE=
X-Google-Smtp-Source: ABdhPJzCNZ1OhYOEh/GytPAWpmfN5zQvTIYXcFZopubRtgtL2khyRjnL9NjY9sKNUpUhV0bS//STIQ==
X-Received: by 2002:adf:dfc7:: with SMTP id q7mr134299wrn.153.1612456355532;
        Thu, 04 Feb 2021 08:32:35 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id f6sm6140111wmq.33.2021.02.04.08.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 08:32:34 -0800 (PST)
Date:   Thu, 4 Feb 2021 16:32:33 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     edumazet@google.com, kuba@kernel.org, syzkaller@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net_sched: gen_estimator: support large
 ewma log" failed to apply to 5.4-stable tree
Message-ID: <YBwhocDeX7VbVXHH@debian>
References: <1611587765159215@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sxpTPXKRUGMWioGM"
Content-Disposition: inline
In-Reply-To: <1611587765159215@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sxpTPXKRUGMWioGM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 25, 2021 at 04:16:05PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.19-stable and 4.14-stable.

--
Regards
Sudip

--sxpTPXKRUGMWioGM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net_sched-gen_estimator-support-large-ewma-log.patch"

From d4e005fb0de4335db515c02d4d39201f08d2f8be Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 14 Jan 2021 10:19:29 -0800
Subject: [PATCH] net_sched: gen_estimator: support large ewma log

commit dd5e073381f2ada3630f36be42833c6e9c78b75e upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 net/core/gen_estimator.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index bfe7bdd4c340..98c396769be9 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -80,11 +80,11 @@ static void est_timer(struct timer_list *t)
 	u64 rate, brate;
 
 	est_fetch_counters(est, &b);
-	brate = (b.bytes - est->last_bytes) << (10 - est->ewma_log - est->intvl_log);
-	brate -= (est->avbps >> est->ewma_log);
+	brate = (b.bytes - est->last_bytes) << (10 - est->intvl_log);
+	brate = (brate >> est->ewma_log) - (est->avbps >> est->ewma_log);
 
-	rate = (u64)(b.packets - est->last_packets) << (10 - est->ewma_log - est->intvl_log);
-	rate -= (est->avpps >> est->ewma_log);
+	rate = (u64)(b.packets - est->last_packets) << (10 - est->intvl_log);
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
-- 
2.29.2


--sxpTPXKRUGMWioGM--
