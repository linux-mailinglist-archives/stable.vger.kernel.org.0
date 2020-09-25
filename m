Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4875C278147
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgIYHK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 03:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYHK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 03:10:56 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED2AC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 00:10:56 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id n7so406011vkq.5
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 00:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Tg9tcpGw8sJd6uhWcIi5C8fdM3tRHRXGEvlMNL34z1E=;
        b=YRxZQEXa4Rzg5+oXLSDWtZODWTS8dZmUQ+1A1H9wAGtfTUgR2z+sIbgJbuHqj/9SbJ
         VQjwEVOMe6kH1wjwFwYdXRLq8QPry3TkNnmfNj2JTfSYg94cktYQE32upclby4aL/uQx
         G1L8w4hGyERqVRq+/VEcJV9O1x5P/nh7QFxHvTfiJFLOtjfA0WolDV5pKMoGRLwet4PT
         zjReFL2HedA0OwAEXiyxm9icutgHp4MY2iyRqFYhC8KgEPZ3upNdK9AxDprfwtXYUMj1
         77LHBaddzD9XY9NWGrqZHIun2kQ/b9d4I9iELX8WAeLB4fA57fVdj4hqzUPujTeLc3nk
         2/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Tg9tcpGw8sJd6uhWcIi5C8fdM3tRHRXGEvlMNL34z1E=;
        b=jb7ssHXoK3bPSzp2cs6d+xCrnQpmHUuE882NR8RwkyDyA7+L3Iur8qp2JZ0IC4OGxO
         oyO3rbFtDnpsdkx9MgYbnlPgwLZ1D+ITDpLwRHh+P+jDi4AfZZaH41DKuZH5QkUNXa2D
         OY3xcqM0o+xQpCqVyLzbFuWYCEguQo7M2IjRbB+K16k5XYL/+5ftFU6cTRlQvy/MtouQ
         wt9zwhU5BQoUh/LBQ6w3FaUmgGbdmgvCKZ7gM8nuAT0scmnlk1kdyOgcHuBsnUwscfNu
         C+Tbq2kMLNzj2kRnLu0ATr6lCzxnipyr4uJSxRmL/GWDjn6dSln/zq+LqZTbiRRoCG9g
         A0rA==
X-Gm-Message-State: AOAM5334ub52vlkDePZiC3HwNBoBWax0raP8Qutb8NetStWS6cl3BRdE
        Xs4BQm/HiqeuBET7VTLVJ/kdy4s+VPcdCmBcIsgoIgukxsgE8zyd
X-Google-Smtp-Source: ABdhPJzb1XTEYRZUGgqJ1l62r3BLRofZvOSX7m8Y6h3ESo3UxtLIYV8CgJQUgHff1WKXURMnRkajHbvvN5GRtVw1k3c=
X-Received: by 2002:a1f:7882:: with SMTP id t124mr2024541vkc.22.1601017854523;
 Fri, 25 Sep 2020 00:10:54 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 25 Sep 2020 12:40:43 +0530
Message-ID: <CA+G9fYsdTLRj55_bvod8Sf+0zvK0RRMp5+FeJcOx5oAcAKOGXA@mail.gmail.com>
Subject: [stable 5.8] rcu: INFO: rcu_sched self-detected stall on CPU - RIP: 0010:trace_graph_return
To:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rcu@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running LTP trace test case on qemu_x86_64, qemu_i386 and i386
the following kernel rcu: INFO reported.

Easily reproducible on qemu_x86_64, qemu_i386 and i386 devices.

steps to reproduce:
    # Boot qemu_x86_64 or qemu i386 or i386 with trace configs enabled.
    # cd /opt/ltp
    # ./runltp -f tracing

metadata:
  git branch: linux-5.8.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: f2ae9d9cdf48e015834ce21030249793bf0c44f5
  git describe: v5.8.9-296-gf2ae9d9cdf48
  make_kernelversion: 5.8.11-rc1
  kernel-config:
https://builds.tuxbuild.com/SQySbShzDnHK3CzpR1T7GA/kernel.config


[   99.868127] rcu: INFO: rcu_sched self-detected stall on CPU
[   99.868127] rcu: 3-....: (1 GPs behind)
idle=d66/1/0x4000000000000000 softirq=2573/2600 fqs=3631
[   99.868127] (t=21003 jiffies g=2909 q=4480)
[   99.868127] NMI backtrace for cpu 3
[   99.868127] CPU: 3 PID: 781 Comm: sh Not tainted 5.8.11-rc1 #1
[   99.868127] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[   99.874535] Call Trace:
[   99.874535]  <IRQ>
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  dump_stack+0x81/0xba
[   99.874535]  nmi_cpu_backtrace.cold+0x14/0x54
[   99.874535]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[   99.874535]  nmi_trigger_cpumask_backtrace+0x85/0x92
[   99.874535]  arch_trigger_cpumask_backtrace+0x19/0x20
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  rcu_dump_cpu_stacks+0xa0/0xd2
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  rcu_sched_clock_irq.cold+0x23a/0x41c
[   99.874535]  ? rcu_sched_clock_irq+0x5/0x490
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  update_process_times+0x28/0x60
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  tick_sched_handle.isra.0+0x34/0x50
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  tick_sched_timer+0x40/0x80
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  __hrtimer_run_queues+0x96/0x2b0
[   99.874535]  ? tick_sched_handle.isra.0+0x50/0x50
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  hrtimer_interrupt+0x109/0x220
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  __sysvec_apic_timer_interrupt+0x64/0x100
[   99.874535]  ? ftrace_graph_caller+0xc0/0xc0
[   99.874535]  asm_call_on_stack+0x12/0x20
[   99.874535]  </IRQ>
[   99.874535]  sysvec_apic_timer_interrupt+0x7e/0x90
[   99.874535]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   99.874535] RIP: 0010:__text_poke+0x367/0x3f0
[   99.874535] Code: 14 25 80 6d 01 00 e8 b8 80 03 00 65 48 8b 05 d0
f0 76 63 a8 aa 75 58 ba 00 10 00 00 e9 d9 fe ff ff e8 3d 8f 1f 00 ff
75 c0 9d <e9> 1a ff ff ff 4c 89 e7 e8 8c 0a 29 00 48 89 c1 49 81 ff 00
10 00
[   99.874535] RSP: 0018:ffffa932c0947c40 EFLAGS: 00000286
[   99.874535] RAX: ffffa932c0947ca8 RBX: ffff8ce37b16deb8 RCX: 0000000000000000
[   99.874535] RDX: 0000000000000001 RSI: ffffffff9c8d2550 RDI: ffffffff9c8a7c03
[   99.874535] RBP: ffffa932c0947ca8 R08: ffff8ce3619cc280 R09: ffff8ce3619d7000
[   99.874535] R10: 0000000000000668 R11: ffff8ce3619d7678 R12: ffffffff9d0a8620
[   99.874535] R13: 0000000000000001 R14: ffffffff9e5b7de9 R15: 0000000000000621
[   99.874535]  ? dpm_suspend+0x240/0x240
[   99.912445]  ? ftrace_graph_caller+0xc0/0xc0
[   99.912445]  ? __text_poke+0x363/0x3f0
[   99.912445]  ? ftrace_graph_caller+0xc0/0xc0
[   99.912445]  text_poke_bp_batch+0x123/0x190
[   99.912445]  ? node_access_release+0x10/0x10
[   99.912445]  ? ftrace_graph_caller+0xc0/0xc0
[   99.912445]  text_poke_queue+0xa7/0xd0
[   99.912445]  ? ftrace_graph_caller+0xc0/0xc0
[   99.912445]  ftrace_replace_code+0x11f/0x170
[   99.912445]  ftrace_modify_all_code+0xc8/0x160
[   99.912445]  arch_ftrace_update_code+0x9/0x10
[   99.912445]  ftrace_run_update_code+0x1a/0x70
[   99.912445]  ftrace_startup_enable+0x2e/0x50
[   99.912445]  ftrace_startup+0xa4/0x100
[   99.912445]  register_ftrace_function+0x25/0x70
[   99.912445]  stack_trace_sysctl+0x77/0x9c
[   99.912445]  proc_sys_call_handler+0x164/0x190
[   99.912445]  proc_sys_write+0x14/0x20
[   99.912445]  vfs_write+0xc9/0x200
[   99.912445]  ksys_write+0x67/0xe0
[   99.912445]  __x64_sys_write+0x1a/0x20
[   99.912445]  do_syscall_64+0x51/0x90
[   99.912445]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   99.912445] RIP: 0033:0x7f1163016144
[   99.912445] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00
00 00 00 00 66 90 48 8d 05 c1 e7 2c 00 8b 00 85 c0 75 13 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89
f5 53
[   99.912445] RSP: 002b:00007ffe884a34d8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[   99.912445] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f1163016144
[   99.912445] RDX: 0000000000000002 RSI: 0000000001852ea0 RDI: 0000000000000001
[   99.912445] RBP: 0000000001852ea0 R08: 000000000000000a R09: 00007f11630633e0
[   99.912445] R10: 000000000000000a R11: 0000000000000246 R12: 00007f11632e0760
[   99.912445] R13: 0000000000000002 R14: 00007f11632db760 R15: 0000000000000002
[  173.329178] rcu: INFO: rcu_sched self-detected stall on CPU
[  173.329178] rcu: 2-....: (20973 ticks this GP)
idle=a4a/1/0x4000000000000000 softirq=3412/3412 fqs=4832
[  173.329178] (t=21000 jiffies g=3197 q=7683)
[  173.329178] NMI backtrace for cpu 2
[  173.329178] CPU: 2 PID: 781 Comm: sh Not tainted 5.8.11-rc1 #1
[  173.329178] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  173.329178] Call Trace:
[  173.329178]  <IRQ>
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  dump_stack+0x81/0xba
[  173.329178]  nmi_cpu_backtrace.cold+0x14/0x54
[  173.329178]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[  173.329178]  nmi_trigger_cpumask_backtrace+0x85/0x92
[  173.329178]  arch_trigger_cpumask_backtrace+0x19/0x20
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  rcu_dump_cpu_stacks+0xa0/0xd2
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  rcu_sched_clock_irq.cold+0x23a/0x41c
[  173.329178]  ? rcu_sched_clock_irq+0x5/0x490
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  update_process_times+0x28/0x60
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  tick_sched_handle.isra.0+0x34/0x50
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  tick_sched_timer+0x40/0x80
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  __hrtimer_run_queues+0x96/0x2b0
[  173.329178]  ? tick_sched_handle.isra.0+0x50/0x50
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  hrtimer_interrupt+0x109/0x220
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  __sysvec_apic_timer_interrupt+0x64/0x100
[  173.329178]  ? ftrace_graph_caller+0xc0/0xc0
[  173.329178]  asm_call_on_stack+0x12/0x20
[  173.329178]  </IRQ>
[  173.329178]  sysvec_apic_timer_interrupt+0x7e/0x90
[  173.329178]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  173.329178] RIP: 0010:__text_poke+0x367/0x3f0
[  173.329178] Code: 14 25 80 6d 01 00 e8 b8 80 03 00 65 48 8b 05 d0
f0 76 63 a8 aa 75 58 ba 00 10 00 00 e9 d9 fe ff ff e8 3d 8f 1f 00 ff
75 c0 9d <e9> 1a ff ff ff 4c 89 e7 e8 8c 0a 29 00 48 89 c1 49 81 ff 00
10 00
[  173.372903] RSP: 0018:ffffa932c0947c40 EFLAGS: 00000282
[  173.374214] RAX: ffffa932c0947ca8 RBX: ffff8ce37b16deb8 RCX: 0000000000000000
[  173.374214] RDX: 0000000000000001 RSI: ffffffff9c8d2550 RDI: ffffffff9c8a7c03
[  173.374214] RBP: ffffa932c0947ca8 R08: ffff8ce3618c8a00 R09: ffff8ce3618f1000
[  173.374214] R10: 0000000000000f40 R11: ffff8ce3618f1f50 R12: ffffffff9caf68e1
[  173.374214] R13: 0000000000000004 R14: ffffffff9e5b798a R15: 00000000000008e5
[  173.374214]  ? mark_page_lazyfree+0x1/0x130
[  173.374214]  ? ftrace_graph_caller+0xc0/0xc0
[  173.374214]  ? __text_poke+0x363/0x3f0
[  173.374214]  ? ftrace_graph_caller+0xc0/0xc0
[  173.374214]  text_poke_bp_batch+0xd4/0x190
[  173.374214]  ? frag_start+0x40/0x40
[  173.374214]  ? ftrace_graph_caller+0xc0/0xc0
[  173.374214]  text_poke_queue+0xa7/0xd0
[  173.374214]  ? ftrace_graph_caller+0xc0/0xc0
[  173.374214]  ftrace_replace_code+0x11f/0x170
[  173.397011]  ftrace_modify_all_code+0xc8/0x160
[  173.397011]  arch_ftrace_update_code+0x9/0x10
[  173.397011]  ftrace_run_update_code+0x1a/0x70
[  173.397011]  ftrace_startup_enable+0x2e/0x50
[  173.397011]  ftrace_startup+0xa4/0x100
[  173.397011]  register_ftrace_function+0x25/0x70
[  173.397011]  stack_trace_sysctl+0x77/0x9c
[  173.397011]  proc_sys_call_handler+0x164/0x190
[  173.397011]  proc_sys_write+0x14/0x20
[  173.397011]  vfs_write+0xc9/0x200
[  173.397011]  ksys_write+0x67/0xe0
[  173.397011]  __x64_sys_write+0x1a/0x20
[  173.397011]  do_syscall_64+0x51/0x90
[  173.397011]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  173.397011] RIP: 0033:0x7f1163016144
[  173.397011] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00
00 00 00 00 66 90 48 8d 05 c1 e7 2c 00 8b 00 85 c0 75 13 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89
f5 53
[  173.397011] RSP: 002b:00007ffe884a34d8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  173.397011] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f1163016144
[  173.397011] RDX: 0000000000000002 RSI: 0000000001852ea0 RDI: 0000000000000001
[  173.397011] RBP: 0000000001852ea0 R08: 000000000000000a R09: 00007f11630633e0
[  173.397011] R10: 000000000000000a R11: 0000000000000246 R12: 00007f11632e0760
[  173.397011] R13: 0000000000000002 R14: 00007f11632db760 R15: 0000000000000002

[  236.332272] rcu: INFO: rcu_sched self-detected stall on CPU
[  236.332288] rcu: 2-....: (83813 ticks this GP)
idle=a4a/1/0x4000000000000000 softirq=3412/3412 fqs=18275
[  236.332288] (t=84003 jiffies g=3197 q=21302)
[  236.332288] NMI backtrace for cpu 2
[  236.332288] CPU: 2 PID: 781 Comm: sh Not tainted 5.8.11-rc1 #1
[  236.332288] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  236.332288] Call Trace:
[  236.332288]  <IRQ>
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  dump_stack+0x81/0xba
[  236.332288]  nmi_cpu_backtrace.cold+0x14/0x54
[  236.332288]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[  236.332288]  nmi_trigger_cpumask_backtrace+0x85/0x92
[  236.332288]  arch_trigger_cpumask_backtrace+0x19/0x20
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  rcu_dump_cpu_stacks+0xa0/0xd2
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  rcu_sched_clock_irq.cold+0x23a/0x41c
[  236.332288]  ? rcu_sched_clock_irq+0x5/0x490
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  update_process_times+0x28/0x60
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  tick_sched_handle.isra.0+0x34/0x50
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  tick_sched_timer+0x40/0x80
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  __hrtimer_run_queues+0x96/0x2b0
[  236.332288]  ? tick_sched_handle.isra.0+0x50/0x50
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  hrtimer_interrupt+0x109/0x220
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  __sysvec_apic_timer_interrupt+0x64/0x100
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  asm_call_on_stack+0x12/0x20
[  236.332288]  </IRQ>
[  236.332288]  sysvec_apic_timer_interrupt+0x7e/0x90
[  236.332288]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  236.332288] RIP: 0010:trace_graph_entry+0x1ce/0x200
[  236.332288] Code: 8b 15 a6 33 57 63 81 e2 00 00 0f 00 74 24 48 81
88 c8 09 00 00 00 02 00 00 e9 c4 fe ff ff e9 bf fe ff ff e8 84 d1 ff
ff 53 9d <8b> 45 dc e9 4d fe ff ff 48 81 a0 c8 09 00 00 ff fd ff ff e9
a0 fe
[  236.332288] RSP: 0018:ffffa932c0947a88 EFLAGS: 00000246
[  236.332288] RAX: ffffa932c0947ab0 RBX: 0000000000000246 RCX: 0000000000000000
[  236.332288] RDX: 0000000000000001 RSI: ffffffff9caa7fad RDI: ffffffff9caa39bc
[  236.332288] RBP: ffffa932c0947ab0 R08: ffff8ce361887800 R09: ffff8ce3618a8000
[  236.332288] R10: 0000000000000cf0 R11: ffff8ce3618a8d00 R12: ffffffff9e274520
[  236.332288] R13: ffffa932c0947adc R14: ffff8ce37bd2ca20 R15: ffffffff9e5c7e80
[  236.332288]  ? ftrace_graph_entry_test+0x2d/0x40
[  236.332288]  ? trace_graph_entry+0x1cc/0x200
[  236.332288]  ? insn_get_sib.part.0+0x60/0x60
[  236.332288]  ftrace_graph_entry_test+0x2d/0x40
[  236.332288]  ? insn_get_immediate.part.0+0x1ae/0x330
[  236.332288]  function_graph_enter+0xe8/0x140
[  236.332288]  ? insn_get_sib.part.0+0x60/0x60
[  236.332288]  ? insn_get_immediate.part.0+0x1ae/0x330
[  236.332288]  prepare_ftrace_return+0x5c/0x80
[  236.332288]  ? mipi_dsi_dcs_write+0xa0/0xa0
[  236.332288]  ftrace_graph_caller+0x81/0xc0
[  236.332288]  ? mipi_dsi_dcs_write+0xa0/0xa0
[  236.332288]  ? ftrace_graph_caller+0x81/0xc0
[  236.332288]  ? mipi_dsi_dcs_write+0xa0/0xa0
[  236.332288]  ? ftrace_graph_caller+0x81/0xc0
[  236.332288]  ? ftrace_return_to_handler+0x8d/0xf0
[  236.332288]  ? insn_get_displacement.part.0+0x5/0xd0
[  236.332288]  ? insn_get_immediate.part.0+0x5/0x330
[  236.332288]  insn_get_displacement.part.0+0x5/0xd0
[  236.332288]  insn_get_immediate.part.0+0x1ae/0x330
[  236.332288]  ? insn_get_displacement.part.0+0x5/0xd0
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  ? insn_get_immediate.part.0+0x1ae/0x330
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  insn_get_length+0x2c/0x40
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  text_poke_loc_init+0x6f/0x160
[  236.332288]  ? mipi_dsi_dcs_write+0xa0/0xa0
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  text_poke_queue+0x84/0xd0
[  236.332288]  ? ftrace_graph_caller+0xc0/0xc0
[  236.332288]  ftrace_replace_code+0x11f/0x170
[  236.332288]  ftrace_modify_all_code+0xc8/0x160
[  236.332288]  arch_ftrace_update_code+0x9/0x10
[  236.332288]  ftrace_run_update_code+0x1a/0x70
[  236.332288]  ftrace_startup_enable+0x2e/0x50
[  236.332288]  ftrace_startup+0xa4/0x100
[  236.332288]  register_ftrace_function+0x25/0x70
[  236.332288]  stack_trace_sysctl+0x77/0x9c
[  236.332288]  proc_sys_call_handler+0x164/0x190
[  236.332288]  proc_sys_write+0x14/0x20
[  236.332288]  vfs_write+0xc9/0x200
[  236.332288]  ksys_write+0x67/0xe0
[  236.332288]  __x64_sys_write+0x1a/0x20
[  236.332288]  do_syscall_64+0x51/0x90
[  236.332288]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  236.332288] RIP: 0033:0x7f1163016144
[  236.332288] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00
00 00 00 00 66 90 48 8d 05 c1 e7 2c 00 8b 00 85 c0 75 13 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89
f5 53
[  236.332288] RSP: 002b:00007ffe884a34d8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  236.332288] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f1163016144
[  236.332288] RDX: 0000000000000002 RSI: 0000000001852ea0 RDI: 0000000000000001
[  236.332288] RBP: 0000000001852ea0 R08: 000000000000000a R09: 00007f11630633e0
[  236.332288] R10: 000000000000000a R11: 0000000000000246 R12: 00007f11632e0760
[  236.332288] R13: 0000000000000002 R14: 00007f11632db760 R15: 0000000000000002

[  299.335247] rcu: INFO: rcu_sched self-detected stall on CPU
[  299.335269] rcu: 2-....: (146579 ticks this GP)
idle=a4a/1/0x4000000000000000 softirq=3412/3412 fqs=31785
[  299.335269] (t=147006 jiffies g=3197 q=35014)
[  299.335269] NMI backtrace for cpu 2
[  299.335269] CPU: 2 PID: 781 Comm: sh Not tainted 5.8.11-rc1 #1
[  299.335269] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  299.335269] Call Trace:
[  299.335269]  <IRQ>
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  dump_stack+0x81/0xba
[  299.335269]  nmi_cpu_backtrace.cold+0x14/0x54
[  299.335269]  ? lapic_can_unplug_cpu.cold+0x3b/0x3b
[  299.335269]  nmi_trigger_cpumask_backtrace+0x85/0x92
[  299.335269]  arch_trigger_cpumask_backtrace+0x19/0x20
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  rcu_dump_cpu_stacks+0xa0/0xd2
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  rcu_sched_clock_irq.cold+0x23a/0x41c
[  299.335269]  ? rcu_sched_clock_irq+0x5/0x490
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  update_process_times+0x28/0x60
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  tick_sched_handle.isra.0+0x34/0x50
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  tick_sched_timer+0x40/0x80
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  __hrtimer_run_queues+0x96/0x2b0
[  299.335269]  ? tick_sched_handle.isra.0+0x50/0x50
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  hrtimer_interrupt+0x109/0x220
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  __sysvec_apic_timer_interrupt+0x64/0x100
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  asm_call_on_stack+0x12/0x20
[  299.335269]  </IRQ>
[  299.335269]  sysvec_apic_timer_interrupt+0x7e/0x90
[  299.335269]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  299.335269] RIP: 0010:trace_graph_return+0xcf/0xf0
[  299.335269] Code: e8 26 fe ff ff f0 ff 0b 41 f7 c5 00 02 00 00 75
11 41 55 9d e8 b2 d2 ff ff 5b 41 5c 41 5d 41 5e 5d c3 e8 54 cf ff ff
41 55 9d <5b> 41 5c 41 5d 41 5e 5d c3 48 81 a2 c8 09 00 00 ff fb ff ff
e9 56
[  299.335269] RSP: 0018:ffffa932c09479b8 EFLAGS: 00000246
[  299.335269] RAX: ffffa932c09479d8 RBX: ffff8ce37bd2ca20 RCX: 0000000000000000
[  299.335269] RDX: 0000000000000001 RSI: ffffffff9caa81ad RDI: ffffffff9caa3bec
[  299.335269] RBP: ffffa932c09479d8 R08: ffff8ce36198b680 R09: ffff8ce3619a6000
[  299.335269] R10: 0000000000000148 R11: ffff8ce3619a6158 R12: ffffa932c09479ec
[  299.335269] R13: 0000000000000246 R14: ffffffff9e274520 R15: ffffffff9ce140b0
[  299.335269]  ? bad_get_user+0xd/0xd
[  299.335269]  ? ftrace_return_to_handler+0x8d/0xf0
[  299.335269]  ? trace_graph_return+0xcc/0xf0
[  299.335269]  ? stack_trace_call+0x66/0x2f0
[  299.335269]  ? insn_get_opcode.part.0+0xb7/0x1a0
[  299.335269]  ftrace_return_to_handler+0x8d/0xf0
[  299.335269]  return_to_handler+0x15/0x30
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  ? stack_trace_call+0x66/0x2f0
[  299.335269]  ? ftrace_ops_test+0x33/0x50
[  299.335269]  ? insn_get_opcode.part.0+0xb7/0x1a0
[  299.335269]  ? bad_get_user+0xd/0xd
[  299.335269]  ftrace_ops_list_func+0x103/0x120
[  299.335269]  ? release_hwdep_device+0x20/0x20
[  299.335269]  ftrace_call+0x5/0x34
[  299.335269]  ? trace_hardirqs_on+0x38/0xf0
[  299.335269]  ? ftrace_return_to_handler+0x8d/0xf0
[  299.335269]  ? inat_get_opcode_attribute+0x5/0x20
[  299.335269]  inat_get_opcode_attribute+0x5/0x20
[  299.335269]  insn_get_opcode.part.0+0xb7/0x1a0
[  299.335269]  ? inat_get_opcode_attribute+0x5/0x20
[  299.335269]  ? insn_get_opcode.part.0+0xb7/0x1a0
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  insn_get_modrm.part.0+0x62/0xf0
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  insn_get_sib.part.0+0x40/0x60
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  insn_get_displacement.part.0+0x84/0xd0
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  insn_get_immediate.part.0+0x1ae/0x330
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  insn_get_length+0x2c/0x40
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  text_poke_loc_init+0x6f/0x160
[  299.335269]  ? release_hwdep_device+0x20/0x20
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  text_poke_queue+0x84/0xd0
[  299.335269]  ? ftrace_graph_caller+0xc0/0xc0
[  299.335269]  ftrace_replace_code+0x11f/0x170
[  299.335269]  ftrace_modify_all_code+0xc8/0x160
[  299.335269]  arch_ftrace_update_code+0x9/0x10
[  299.335269]  ftrace_run_update_code+0x1a/0x70
[  299.335269]  ftrace_startup_enable+0x2e/0x50
[  299.335269]  ftrace_startup+0xa4/0x100
[  299.335269]  register_ftrace_function+0x25/0x70
[  299.335269]  stack_trace_sysctl+0x77/0x9c
[  299.335269]  proc_sys_call_handler+0x164/0x190
[  299.335269]  proc_sys_write+0x14/0x20
[  299.335269]  vfs_write+0xc9/0x200
[  299.335269]  ksys_write+0x67/0xe0
[  299.335269]  __x64_sys_write+0x1a/0x20
[  299.335269]  do_syscall_64+0x51/0x90
[  299.335269]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  299.335269] RIP: 0033:0x7f1163016144
[  299.335269] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00
00 00 00 00 66 90 48 8d 05 c1 e7 2c 00 8b 00 85 c0 75 13 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89
f5 53
[  299.335269] RSP: 002b:00007ffe884a34d8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  299.335269] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f1163016144
[  299.335269] RDX: 0000000000000002 RSI: 0000000001852ea0 RDI: 0000000000000001
[  299.335269] RBP: 0000000001852ea0 R08: 000000000000000a R09: 00007f11630633e0
[  299.335269] R10: 000000000000000a R11: 0000000000000246 R12: 00007f11632e0760
[  299.335269] R13: 0000000000000002 R14: 00007f11632db760 R15: 0000000000000002


full test log,
https://lkft.validation.linaro.org/scheduler/job/1779500#L1155
https://lkft.validation.linaro.org/scheduler/job/1779336#L1180
https://lkft.validation.linaro.org/scheduler/job/1779359#L1774

-- 
Linaro LKFT
https://lkft.linaro.org
