Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9C400A50
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 09:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhIDH4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Sep 2021 03:56:33 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53851 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbhIDH4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Sep 2021 03:56:33 -0400
Received: by mail-io1-f69.google.com with SMTP id n189-20020a6b8bc6000000b005b92c64b625so1017125iod.20
        for <stable@vger.kernel.org>; Sat, 04 Sep 2021 00:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Fnlcdjve0qVJTFGXW0budG2MUFIzNniVDA3qsZRMbiU=;
        b=gKZAqG64pnxrZ8NOu1IuE7V8ZF56J/53yFe7jG/k9s5UJPU75Tt2Xf6LyqNMWkhI6i
         ovGlRCRQH4BtDM5i83xGxNdmNvUd0uXABVEaONz+QMZWnm527rZ9uI9YnBcm6Hn9Q7A+
         oM4wxdO5544aZCMkjOQSEhl1X7JG5/3B+7q3qW3PMQaCpV1QdZgTn5LBf1Mq1HTDGtH6
         qY7ePVmg3rr6RooI13NlaUDh1nKLsVfJdw5S+TV4KXXEcr5QpSWeeQEe+/68bdYOiE4i
         4DAHfKvamh8Fa25PkSMAn00BTTRogdAqaXgFbMc95qHBue7WgfHMLn8orIQUem4xXoIn
         IaQw==
X-Gm-Message-State: AOAM530wCk11Ysu/wIl+wvmb9QdsOUJ78DrwBnoDddQHrVIFd9TaWh9R
        pJnMSvgdCHXidY9Xbq0rwDFS2v08Z4dQk4p0oSFn+0KQ24VO
X-Google-Smtp-Source: ABdhPJzJ3c+eEtz/Pv4/JLvY2AQBZnpxixIGH4faWYvTZ9eySYMMapGgooc1ocdYk4Uclm5dvst90X/ZeTm0Q3x75gcDydNxSpcD
MIME-Version: 1.0
X-Received: by 2002:a02:ca0b:: with SMTP id i11mr2396950jak.84.1630742131775;
 Sat, 04 Sep 2021 00:55:31 -0700 (PDT)
Date:   Sat, 04 Sep 2021 00:55:31 -0700
In-Reply-To: <000000000000a9b79905c04e25a0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007c1cd805cb26bd7a@google.com>
Subject: Re: [syzbot] INFO: rcu detected stall in tx
From:   syzbot <syzbot+e2eae5639e7203360018@syzkaller.appspotmail.com>
To:     Guido.Kiener@rohde-schwarz.com, Qiang.Zhang@windriver.com,
        Thinh.Nguyen@synopsys.com, bp@alien8.de, dpenkler@gmail.com,
        dvyukov@google.com, dwmw@amazon.co.uk, fgheet255t@gmail.com,
        fweisbec@gmail.com, gregkh@linuxfoundation.org,
        guido.kiener@rohde-schwarz.com, hpa@zytor.com,
        john.stultz@linaro.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        luto@kernel.org, mathias.nyman@intel.com,
        mathias.nyman@linux.intel.com, mingo@kernel.org, mingo@redhat.com,
        qiang.zhang@windriver.com, sboyd@kernel.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tonymarislogistics@yandex.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7cca308cfdc0 Merge tag 'powerpc-5.15-1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10535915300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c582b69de20dde2
dashboard link: https://syzkaller.appspot.com/bug?extid=e2eae5639e7203360018
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e2e533300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1294ff33300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e2eae5639e7203360018@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (288 ticks this GP) idle=bdd/1/0x4000000000000000 softirq=20305/20305 fqs=5241 
	(t=10500 jiffies g=18249 q=67)
NMI backtrace for cpu 1
CPU: 1 PID: 3254 Comm: aoe_tx0 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:711 [inline]
 rcu_pending kernel/rcu/tree.c:3880 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2599
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1421
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:__sanitizer_cov_trace_pc+0x5c/0x60 kernel/kcov.c:207
Code: 82 18 15 00 00 83 f8 02 75 20 48 8b 8a 20 15 00 00 8b 92 1c 15 00 00 48 8b 01 48 83 c0 01 48 39 c2 76 07 48 89 34 c1 48 89 01 <c3> 0f 1f 00 41 55 41 54 49 89 fc 55 48 bd eb 83 b5 80 46 86 c8 61
RSP: 0018:ffffc90002ccfad8 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880206e3900 RSI: ffffffff874e536f RDI: 0000000000000003
RBP: ffff88807df1b340 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff874e5366 R11: 0000000000000000 R12: ffff88807df1b000
R13: dffffc0000000000 R14: ffff8880709ff490 R15: ffff88807df1b338
 __list_del_entry include/linux/list.h:132 [inline]
 list_move_tail include/linux/list.h:227 [inline]
 fq_codel_dequeue+0x7cf/0x1f50 net/sched/sch_fq_codel.c:299
 dequeue_skb net/sched/sch_generic.c:292 [inline]
 qdisc_restart net/sched/sch_generic.c:397 [inline]
 __qdisc_run+0x1ae/0x1700 net/sched/sch_generic.c:415
 __dev_xmit_skb net/core/dev.c:3861 [inline]
 __dev_queue_xmit+0x1f6e/0x3710 net/core/dev.c:4170
 tx+0x68/0xb0 drivers/block/aoe/aoenet.c:63
 kthread+0x1e7/0x3b0 drivers/block/aoe/aoecmd.c:1230
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	18 15 00 00 83 f8    	sbb    %dl,-0x77d0000(%rip)        # 0xf8830006
   6:	02 75 20             	add    0x20(%rbp),%dh
   9:	48 8b 8a 20 15 00 00 	mov    0x1520(%rdx),%rcx
  10:	8b 92 1c 15 00 00    	mov    0x151c(%rdx),%edx
  16:	48 8b 01             	mov    (%rcx),%rax
  19:	48 83 c0 01          	add    $0x1,%rax
  1d:	48 39 c2             	cmp    %rax,%rdx
  20:	76 07                	jbe    0x29
  22:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
  26:	48 89 01             	mov    %rax,(%rcx)
* 29:	c3                   	retq <-- trapping instruction
  2a:	0f 1f 00             	nopl   (%rax)
  2d:	41 55                	push   %r13
  2f:	41 54                	push   %r12
  31:	49 89 fc             	mov    %rdi,%r12
  34:	55                   	push   %rbp
  35:	48 bd eb 83 b5 80 46 	movabs $0x61c8864680b583eb,%rbp
  3c:	86 c8 61

