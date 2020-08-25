Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CCA2511EA
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 08:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgHYGNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 02:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgHYGNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 02:13:18 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD6DC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 23:13:18 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id b16so5396192vsl.6
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 23:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Nz8o+oFvxFIhPP9y7NnSAQb/n8LmPLlle/QHO7DpndA=;
        b=CHcV8Y2TPdlo+Xta4i6qa6+UDp6JmhA67sFlMSlUMo14OUYmOlCKGXrJTAaIY9mHAx
         IsuNHPFBRGHmvf2brBdrnjjPhMIF/ZP4bqik/ezRLgcqq1mvN3URaAt+z4bAw76ZphyS
         bxj/r35WXAv3B6/D+S1uUCiHWGb63j7ikf9lR9HGGw8yaMgBWleWC8JqHh0T1cJ7DVmq
         LaVysvdwTt0dEc9UwH+B09rZ2s5Q+JqoLOJk8JyqdGKS57nWxuFbMa1J6+WNbcDgY5tT
         PYvlF9Q/hXszp5eX0+F2Dh7+pwcIVNCT1O764sUWcU2EqACfMa6IssZxIbeHidPBGIT7
         r3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Nz8o+oFvxFIhPP9y7NnSAQb/n8LmPLlle/QHO7DpndA=;
        b=eXN0P+z3aSvmZiOt5QRM3ep9Ej1GSH6DwmrZC7WCOh/5Jp+UCTGv+UR9BT/fOQNIrp
         wQgW8sORKMNraKovptWjCGevhVjqJMk+M3kgApjCGOEA9byjAqIH3j/Qv7pBMUBWEvd9
         QsIG5RepVRCZ7WjAmFaC0NWjb3RH/gm65HJnAhId9tFnG0JoAbQig3X/KW5Xh3a04Kpd
         L8tYlyOc8+j1oEVkGMgVzyU9GHnA4xMfZ5hmjDr7cBVVqIWTERjxZ6eZQ4yXxRu7tmAJ
         n7lujs0DL4KbJkdpG+Sq5bR2JC35JKrAxPaZc9oQ2pBn9axBv4HsKHFkuS+F2/FgAiI0
         k1Nw==
X-Gm-Message-State: AOAM530WOnlcryJo2XUPUNH1S+Jx5X8VJYXHEQdyhAM/kZZiQUfZSK+n
        rxNGLJr5bLPI4Qdoz+6UsZs9fbPd1MfuIu6WxEsB6g==
X-Google-Smtp-Source: ABdhPJyjXdr7m5mL+FbqV7gIRFxLsYp34bvthy15kKLktzHelIgZq89Aj3QVtSZ7UedRF7IzprWPIkpZCyFJUqmT0N8=
X-Received: by 2002:a05:6102:44e:: with SMTP id e14mr4983180vsq.185.1598335996312;
 Mon, 24 Aug 2020 23:13:16 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 11:43:05 +0530
Message-ID: <CA+G9fYtg58tm3zq3sobCrXD-aSZ0vaH1mCfJ+pXoTSmO2LYs4A@mail.gmail.com>
Subject: Kernel panic - not syncing: Attempted to kill init! x86_64 running 4.19
To:     X86 ML <x86@kernel.org>, open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Leo Yan <leo.yan@linaro.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running LTP tracing ftrace-stress-test kernel on x86_64 got panic on
stable rc 4.19 branch. I have checked this kernel panic has been happening from
the beginning of 4.19 release. I will run git bisect starting from
4.18 and get back to you
on this email thread.


steps to reproduce:
# Boot qemu x86_64 with trace configs enabled.
# cd /opt/ltp
# ./runltp -f tracing

Test output log:
---------------------
ftrace-stress-test 1 TINFO: Start pid16=3123
/opt/ltp/testcases/bin/ftrace_stress/ftrace_tracing_cpumask.sh
ftrace-stress-test 1 TINFO: Start pid17=3124
/opt/ltp/testcases/bin/ftrace_stress/ftrace_set_ftrace_filter.sh
[   81.695606] Core dump to |/bin/false pipe failed
[   81.696936] false (3169) used greatest stack depth: 11224 bytes left
[   81.711194] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[   81.711194]
[   81.720342] CPU: 2 PID: 1 Comm: systemd Not tainted 4.19.142-rc2 #1
[   81.726622] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   81.734121] Call Trace:
[   81.736599]  ? ftrace_graph_caller+0xb0/0xb0
[   81.740890]  dump_stack+0x7a/0xaa
[   81.744245]  panic+0xe6/0x239
[   81.747260]  ? panic+0x5/0x239
[   81.750343]  ? ftrace_graph_caller+0xb0/0xb0
[   81.754633]  do_exit.cold+0xa0/0xb7
[   81.758138]  ? do_exit+0x5/0xb40
[   81.761389]  ? ftrace_return_to_handler+0x99/0xf0
[   81.766115]  ? ftrace_graph_caller+0xb0/0xb0
[   81.770399]  do_group_exit+0x47/0xb0
[   81.773992]  ? ftrace_graph_caller+0xb0/0xb0
[   81.778277]  get_signal+0x158/0x7e0
[   81.781797]  do_signal+0x37/0x640
[   81.785136]  ? trace_event_raw_event_rcu_dyntick+0x75/0xc0
[   81.790658]  exit_to_usermode_loop+0x78/0xd0
[   81.794946]  prepare_exit_to_usermode+0x66/0x90
[   81.799495]  ? page_fault+0x8/0x30
[   81.802915]  retint_user+0x8/0x18
[   81.806259] RIP: 0033:0x7f62d3b648a8
[   81.809850] Code: fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00 55 66 0f ef c0 48 89 e5 41 56 41 54 53 48 81 ec 98 08 00 00 48
8b 45 28 <0f> 29 85 90 f7 ff ff 8b 1d 0f 68 38 00 0f 29 85 a0 f7 ff ff
4c 8b
[   81.828611] RSP: 002b:00007ffe44822e80 EFLAGS: 00010202
[   81.833854] RAX: 00007ffe44823950 RBX: 00007ffe44823950 RCX: 00000000000000d7
[   81.840997] RDX: 000055a3d336bc15 RSI: 0000000000000000 RDI: 0000000000000018
[   81.848138] RBP: 00007ffe44823730 R08: 000055a3d336e9c5 R09: 0000000000000000
[   81.855278] R10: 00007ffe44823788 R11: 0000000000000000 R12: 00007ffe44823800
[   81.862419] R13: 00000000000000d7 R14: 00007ffe44823840 R15: 0000000000000018
[   81.869625] Kernel Offset: 0x1f800000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   81.880417] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b
[   81.880417]  ]---
[   81.890803] ------------[ cut here ]------------
[   81.895440] sched: Unexpected reschedule of offline CPU#3!
[   81.900946] WARNING: CPU: 2 PID: 1 at arch/x86/kernel/smp.c:128
native_smp_send_reschedule+0x3a/0x40
[   81.910087] Modules linked in: x86_pkg_temp_thermal
[   81.914984] CPU: 2 PID: 1 Comm: systemd Not tainted 4.19.142-rc2 #1
[   81.921266] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   81.928762] RIP: 0010:native_smp_send_reschedule+0x3a/0x40
[   81.934257] Code: b7 8f 01 73 17 48 8b 05 c4 2d 58 01 be fd 00 00
00 48 8b 40 30 e8 b6 ea f4 00 5d c3 89 fe 48 c7 c7 b8 9a d3 a1 e8 c2
e1 0b 00 <0f> 0b 5d c3 66 90 e8 ab a3 d4 00 55 48 89 e5 53 48 83 ec 10
65 48
[   81.953021] RSP: 0000:ffff9ad0dfb03d38 EFLAGS: 00010082
[   81.958265] RAX: 0000000000000000 RBX: ffff9ad0dfb9fb40 RCX: 000000000000001f
[   81.965404] RDX: 0000000000000007 RSI: ffff9ad0da7c6000 RDI: ffffffffa08b755a
[   81.972545] RBP: ffff9ad0dfb03d38 R08: 0000000000000000 R09: ffffb7044002ff58
[   81.979686] R10: 0000000000000000 R11: ffff9ad0dda48000 R12: 0000000000000003
[   81.986830] R13: ffff9ad0dfb9fb40 R14: ffff9ad0dfb03df8 R15: ffff9ad0dfb03df8
[   81.993979] FS:  00007f62d4103840(0000) GS:ffff9ad0dfb00000(0000)
knlGS:0000000000000000
[   82.002082] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   82.007846] CR2: 0000000000000000 CR3: 000000045c4e2003 CR4: 00000000003606e0
[   82.014995] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.022146] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   82.029294] Call Trace:
[   82.031767]  <IRQ>
[   82.033804]  ? ftrace_graph_caller+0xb0/0xb0
[   82.038093]  resched_curr+0x5e/0xc0
[   82.041606]  ? ftrace_graph_caller+0xb0/0xb0
[   82.045891]  check_preempt_curr+0x4e/0x90
[   82.049923]  ? ftrace_graph_caller+0xb0/0xb0
[   82.054213]  ttwu_do_wakeup+0x1e/0x140
[   82.057978]  ? ftrace_graph_caller+0xb0/0xb0
[   82.062262]  ttwu_do_activate+0x6c/0x90
[   82.066125]  ? ftrace_graph_caller+0xb0/0xb0
[   82.070409]  try_to_wake_up+0x205/0x4b0
[   82.074259]  ? try_to_wake_up+0x5/0x4b0
[   82.078115]  ? default_wake_function+0x5/0x20
[   82.082498]  ? ftrace_graph_caller+0xb0/0xb0
[   82.086788]  default_wake_function+0x12/0x20
[   82.091071]  ? ftrace_graph_caller+0xb0/0xb0
[   82.095361]  autoremove_wake_function+0x12/0x40
[   82.099915]  ? ftrace_graph_caller+0xb0/0xb0
[   82.104200]  __wake_up_common+0x7e/0x140
[   82.108152]  ? ftrace_graph_caller+0xb0/0xb0
[   82.112441]  __wake_up_common_lock+0x7b/0xf0
[   82.116733]  ? ftrace_graph_caller+0xb0/0xb0
[   82.121024]  __wake_up+0x13/0x20
[   82.124276]  ? ftrace_graph_caller+0xb0/0xb0
[   82.128564]  wake_up_klogd_work_func+0x5c/0x60
[   82.133028]  ? ftrace_graph_caller+0xb0/0xb0
[   82.137317]  irq_work_run_list+0x4f/0x70
[   82.141261]  ? set_memory_decrypted+0x10/0x10
[   82.145636]  irq_work_run+0x2c/0x40
[   82.149139]  flush_smp_call_function_queue+0x72/0xf0
[   82.154123]  ? ftrace_graph_caller+0xb0/0xb0
[   82.158412]  generic_smp_call_function_single_interrupt+0x13/0x2b
[   82.164522]  ? ftrace_graph_caller+0xb0/0xb0
[   82.168810]  smp_call_function_interrupt+0x3e/0xd0
[   82.173623]  ? ftrace_graph_caller+0xb0/0xb0
[   82.177910]  call_function_interrupt+0xf/0x20
[   82.182287]  </IRQ>
[   82.184411] RIP: 0010:panic+0x1fa/0x239
[   82.188266] Code: b0 83 3d e3 5f a3 01 00 74 05 e8 4c 6c 02 00 48
c7 c6 a0 b9 3a a2 48 c7 c7 d0 2c d4 a1 e8 9c fb 05 00 e8 74 58 0e 00
fb 31 db <4c> 39 eb 7c 1d 41 83 f4 01 48 8b 05 91 5f a3 01 44 89 e7 e8
49 06
[   82.207019] RSP: 0000:ffffb7044002fc40 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff03
[   82.214603] RAX: ffffb7044002fcb0 RBX: 0000000000000000 RCX: 000000000000001f
[   82.221754] RDX: 0000000000000001 RSI: ffffffffa16019c0 RDI: ffffffffa097599c
[   82.228902] RBP: ffffb7044002fcb0 R08: 0000000000000000 R09: ffffb7044002ff58
[   82.236044] R10: 0000000000000000 R11: ffff9ad0dda48000 R12: 0000000000000000
[   82.243194] R13: 0000000000000000 R14: ffffb7044002fe01 R15: 000000000000000b
[   82.250354]  ? ftrace_graph_caller+0xb0/0xb0
[   82.254644]  ? panic+0x1f7/0x239
[   82.257901]  ? panic+0x5/0x239
[   82.260979]  ? ftrace_graph_caller+0xb0/0xb0
[   82.265271]  do_exit.cold+0xa0/0xb7
[   82.268781]  ? do_exit+0x5/0xb40
[   82.272030]  ? ftrace_return_to_handler+0x99/0xf0
[   82.276759]  ? ftrace_graph_caller+0xb0/0xb0
[   82.281044]  do_group_exit+0x47/0xb0
[   82.284642]  ? ftrace_graph_caller+0xb0/0xb0
[   82.288930]  get_signal+0x158/0x7e0
[   82.292449]  do_signal+0x37/0x640
[   82.295787]  ? trace_event_raw_event_rcu_dyntick+0x75/0xc0
[   82.301309]  exit_to_usermode_loop+0x78/0xd0
[   82.305598]  prepare_exit_to_usermode+0x66/0x90
[   82.310145]  ? page_fault+0x8/0x30
[   82.313570]  retint_user+0x8/0x18
[   82.316904] RIP: 0033:0x7f62d3b648a8
[   82.320493] Code: fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00 55 66 0f ef c0 48 89 e5 41 56 41 54 53 48 81 ec 98 08 00 00 48
8b 45 28 <0f> 29 85 90 f7 ff ff 8b 1d 0f 68 38 00 0f 29 85 a0 f7 ff ff
4c 8b
[   82.339254] RSP: 002b:00007ffe44822e80 EFLAGS: 00010202
[   82.344498] RAX: 00007ffe44823950 RBX: 00007ffe44823950 RCX: 00000000000000d7
[   82.351647] RDX: 000055a3d336bc15 RSI: 0000000000000000 RDI: 0000000000000018
[   82.358789] RBP: 00007ffe44823730 R08: 000055a3d336e9c5 R09: 0000000000000000
[   82.365931] R10: 00007ffe44823788 R11: 0000000000000000 R12: 00007ffe44823800
[   82.373081] R13: 00000000000000d7 R14: 00007ffe44823840 R15: 0000000000000018
[   82.380236] ---[ end trace d471dcce52203e4f ]---

full test log link,
https://lkft.validation.linaro.org/scheduler/job/1705337#L1514

-- 
Linaro LKFT
https://lkft.linaro.org
