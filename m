Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5521DF9D1B
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 23:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKLWdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 17:33:17 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42971 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfKLWdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 17:33:17 -0500
Received: by mail-pf1-f193.google.com with SMTP id s5so98601pfh.9
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 14:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=o3CmO7zjmtQ91zKp8gxrVdnwE4gSVm5uZwYBGZHKXRI=;
        b=usJb56F0Kpt5dNelgyXzyJE7aAvIZOUXquMJUG01Hdt16QKf0mVN4pRhS0cSWP7OFZ
         Lcfdd1psU0Qce9L5Lqsc7FzuxGjCLgl2vGCOCK8fAzbj22s/xbXzOc2e5riFsix3vW4G
         8FVQeSz6bVrb86aLRsfJMScRMOErt3F2ZoeVk68YqgbQfR2+psMQ5WLF+vAzTULYaN0X
         UcqXXyiaPr+TGYPC9JJU0bG57y66IF5/irZc/2uKxAKKVm2pTXgJmTTlAXm6Rq36HXSi
         T6vGgt3qZW9Zjd9aXcqM7gZUcI9W/0KHdJ02QVURpd1N1/5B3NmiwQNg200z6xsRhesG
         sixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=o3CmO7zjmtQ91zKp8gxrVdnwE4gSVm5uZwYBGZHKXRI=;
        b=Ql8QwzVLZ1wjNXgElQPzMSXiA0WiJzFHH2dQFeudBrbxu0fiI/W3KdcUZCKd7Pjxf+
         ORGpR0lDSpvZnollJAvOd/LR+WCQzplb4qLB9AHtb3KUrio6YFqrUH0tZQD2DcYqZbWz
         5X8Fd9dlI20rfBQXn8NIw1441IfBYvFnzSOLnXpW7qh61t/+c96UAiGXPk9DRxpMn/zE
         toPpGYO/Q8l3t2cSRP8C4oUSrOcK8OQdMTJ6cad78Ij8MVf1eAf307ruzpmHoytBDDaf
         ugVSwuK35XBqutBEZsw+aHFOQ7u6z7dLuJIdT8I2mXGnuZQMgqBpwe0W+HOijyRnlT9i
         +t2w==
X-Gm-Message-State: APjAAAWN6/2MDrlne+fC0R/4kUKJRK8pjO20OvYdfNK97J2dnghMat9c
        LMh/IsTLhhgvLjFYgms0ZpVaIzlpnWdhkQ==
X-Google-Smtp-Source: APXvYqzI6gIjcA2PHNdTAbMGvoyUyClK0DJuzV19DbZT7PuYW1muYrC5v/EdNdCIlVPhX0w4b/NFUQ==
X-Received: by 2002:a62:2942:: with SMTP id p63mr377919pfp.110.1573597990400;
        Tue, 12 Nov 2019 14:33:10 -0800 (PST)
Received: from debian ([171.49.172.14])
        by smtp.gmail.com with ESMTPSA id o20sm78pfp.16.2019.11.12.14.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:33:09 -0800 (PST)
Date:   Wed, 13 Nov 2019 04:03:00 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     akpm@linux-foundation.org, oleg@redhat.com, christian@brauner.io,
        tj@kernel.org, peterz@infradead.org, prsood@codeaurora.org,
        avagin@gmail.com, aarcange@redhat.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: PROBLEM: objtool: __x64_sys_exit_group()+0x14: unreachable
 instruction
Message-ID: <20191112223300.GA17891@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello all,

i found a warning during kernel build (5.3.11-rc1+).
-----------------x----------x-----------------
kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
-------------------x---------------x-----------

Related details:
---------------

$uname -a
Linux debian 5.3.11-rc1+ #6 SMP Tue Nov 12 01:23:06 IST 2019 x86_64 GNU/Linux
$

$gcc --version
gcc (Debian 9.2.1-14) 9.2.1 20191025
------x---has-been-cut-here--x------



(gdb) l __x64_sys_exit_group
987	/*
988	 * this kills every thread in the thread group. Note that any externally
989	 * wait4()-ing process will get the correct exit code - even if this
990	 * thread is not the thread group leader.
991	 */
992	SYSCALL_DEFINE1(exit_group, int, error_code)
993	{
994		do_group_exit((error_code & 0xff) << 8);
995		/* NOTREACHED */
996		return 0;
(gdb) 

(gdb) l *__x64_sys_exit_group+0x14
0xffffffff81085404 is in __x64_sys_exit_group (kernel/exit.c:996).
991	 */
992	SYSCALL_DEFINE1(exit_group, int, error_code)
993	{
994		do_group_exit((error_code & 0xff) << 8);
995		/* NOTREACHED */
996		return 0;
997	}
998	
999	struct waitid_info {
1000		pid_t pid;
(gdb) 


(gdb) l *__x64_sys_exit_group
0xffffffff810853f0 is in __x64_sys_exit_group (kernel/exit.c:992).
987	/*
988	 * this kills every thread in the thread group. Note that any externally
989	 * wait4()-ing process will get the correct exit code - even if this
990	 * thread is not the thread group leader.
991	 */
992	SYSCALL_DEFINE1(exit_group, int, error_code)
993	{
994		do_group_exit((error_code & 0xff) << 8);
995		/* NOTREACHED */
996		return 0;
(gdb) 

--------------------x-------------x-----------------------------

objdump -r -S -l --disassemble kernel/exit.o   output is attached

--
software engineer
rajagiri school of engineering and technology







--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="objoutput.txt"


kernel/exit.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <arch_local_irq_enable>:
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_disable);
}

static inline notrace void arch_local_irq_enable(void)
{
	PVOP_VCALLEE0(irq.irq_enable);
       0:	ff 14 25 00 00 00 00 	callq  *0x0
			3: R_X86_64_32S	pv_ops+0x140
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:779
}
       7:	c3                   	retq   
       8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
       f:	00 

0000000000000010 <will_become_orphaned_pgrp>:
will_become_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:334
 *
 * "I ask you, have you ever known what it is to be an orphan?"
 */
static int will_become_orphaned_pgrp(struct pid *pgrp,
					struct task_struct *ignored_task)
{
      10:	e8 00 00 00 00       	callq  15 <will_become_orphaned_pgrp+0x5>
			11: R_X86_64_PLT32	__fentry__-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:348
		if (task_pgrp(p->real_parent) != pgrp &&
		    task_session(p->real_parent) == task_session(p))
			return 0;
	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);

	return 1;
      15:	41 b8 01 00 00 00    	mov    $0x1,%r8d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:337
	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
      1b:	48 85 ff             	test   %rdi,%rdi
      1e:	0f 84 86 00 00 00    	je     aa <will_become_orphaned_pgrp+0x9a>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199 (discriminator 2)
})

static __always_inline
void __read_once_size(const volatile void *p, void *res, int size)
{
	__READ_ONCE_SIZE;
      24:	48 8b 47 18          	mov    0x18(%rdi),%rax
will_become_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:337 (discriminator 2)
      28:	48 85 c0             	test   %rax,%rax
      2b:	74 7d                	je     aa <will_become_orphaned_pgrp+0x9a>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:337 (discriminator 6)
      2d:	48 2d 60 05 00 00    	sub    $0x560,%rax
      33:	75 0a                	jne    3f <will_become_orphaned_pgrp+0x2f>
      35:	eb 73                	jmp    aa <will_become_orphaned_pgrp+0x9a>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:337 (discriminator 18)
      37:	48 2d 60 05 00 00    	sub    $0x560,%rax
      3d:	74 65                	je     a4 <will_become_orphaned_pgrp+0x94>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:338
		if ((p == ignored_task) ||
      3f:	48 39 c6             	cmp    %rax,%rsi
      42:	74 54                	je     98 <will_become_orphaned_pgrp+0x88>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:338 (discriminator 1)
      44:	8b 90 6c 04 00 00    	mov    0x46c(%rax),%edx
      4a:	85 d2                	test   %edx,%edx
      4c:	74 13                	je     61 <will_become_orphaned_pgrp+0x51>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
      4e:	48 8b 90 80 05 00 00 	mov    0x580(%rax),%rdx
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
			      struct task_struct, thread_group);
}

static inline int thread_group_empty(struct task_struct *p)
{
	return list_empty(&p->thread_group);
      55:	48 8d 88 80 05 00 00 	lea    0x580(%rax),%rcx
will_become_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:339
		    (p->exit_state && thread_group_empty(p)) ||
      5c:	48 39 d1             	cmp    %rdx,%rcx
      5f:	74 37                	je     98 <will_become_orphaned_pgrp+0x88>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:340 (discriminator 1)
		    is_global_init(p->real_parent))
      61:	48 8b 90 e0 04 00 00 	mov    0x4e0(%rax),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:339 (discriminator 1)
		    (p->exit_state && thread_group_empty(p)) ||
      68:	83 ba d4 04 00 00 01 	cmpl   $0x1,0x4d4(%rdx)
      6f:	74 27                	je     98 <will_become_orphaned_pgrp+0x88>
task_pgrp():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:624
	return task->signal->pids[PIDTYPE_PGID];
      71:	48 8b 92 d8 06 00 00 	mov    0x6d8(%rdx),%rdx
will_become_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:343
		if (task_pgrp(p->real_parent) != pgrp &&
      78:	48 3b ba 70 01 00 00 	cmp    0x170(%rdx),%rdi
      7f:	74 17                	je     98 <will_become_orphaned_pgrp+0x88>
task_session():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:629 (discriminator 1)
	return task->signal->pids[PIDTYPE_SID];
      81:	48 8b 88 d8 06 00 00 	mov    0x6d8(%rax),%rcx
will_become_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:343 (discriminator 1)
      88:	48 8b 92 78 01 00 00 	mov    0x178(%rdx),%rdx
      8f:	48 39 91 78 01 00 00 	cmp    %rdx,0x178(%rcx)
      96:	74 16                	je     ae <will_become_orphaned_pgrp+0x9e>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199 (discriminator 14)
      98:	48 8b 80 60 05 00 00 	mov    0x560(%rax),%rax
will_become_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:337 (discriminator 14)
	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
      9f:	48 85 c0             	test   %rax,%rax
      a2:	75 93                	jne    37 <will_become_orphaned_pgrp+0x27>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:348
	return 1;
      a4:	41 b8 01 00 00 00    	mov    $0x1,%r8d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:349
}
      aa:	44 89 c0             	mov    %r8d,%eax
      ad:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:345
			return 0;
      ae:	45 31 c0             	xor    %r8d,%r8d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:349
}
      b1:	44 89 c0             	mov    %r8d,%eax
      b4:	c3                   	retq   
      b5:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
      bc:	00 00 00 00 

00000000000000c0 <kill_orphaned_pgrp>:
kill_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:381
 * a result of our exiting, and if they have any stopped jobs,
 * send them a SIGHUP and then a SIGCONT. (POSIX 3.2.2.2)
 */
static void
kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
{
      c0:	e8 00 00 00 00       	callq  c5 <kill_orphaned_pgrp+0x5>
			c1: R_X86_64_PLT32	__fentry__-0x4
      c5:	41 54                	push   %r12
task_pgrp():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:624
	return task->signal->pids[PIDTYPE_PGID];
      c7:	48 8b 97 d8 06 00 00 	mov    0x6d8(%rdi),%rdx
      ce:	4c 8b a2 70 01 00 00 	mov    0x170(%rdx),%r12
kill_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:385
	struct pid *pgrp = task_pgrp(tsk);
	struct task_struct *ignored_task = tsk;

	if (!parent)
      d5:	48 85 f6             	test   %rsi,%rsi
      d8:	74 25                	je     ff <kill_orphaned_pgrp+0x3f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:394
		parent = tsk->real_parent;
	else
		/* reparent: our child is in a different pgrp than
		 * we are, and it was the only connection outside.
		 */
		ignored_task = NULL;
      da:	31 ff                	xor    %edi,%edi
task_pgrp():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:624
      dc:	48 8b 86 d8 06 00 00 	mov    0x6d8(%rsi),%rax
kill_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:396

	if (task_pgrp(parent) != pgrp &&
      e3:	4c 3b a0 70 01 00 00 	cmp    0x170(%rax),%r12
      ea:	74 10                	je     fc <kill_orphaned_pgrp+0x3c>
      ec:	48 8b 80 78 01 00 00 	mov    0x178(%rax),%rax
      f3:	48 39 82 78 01 00 00 	cmp    %rax,0x178(%rdx)
      fa:	74 0c                	je     108 <kill_orphaned_pgrp+0x48>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:403
	    will_become_orphaned_pgrp(pgrp, ignored_task) &&
	    has_stopped_jobs(pgrp)) {
		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
	}
}
      fc:	41 5c                	pop    %r12
      fe:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:389
		parent = tsk->real_parent;
      ff:	48 8b b7 e0 04 00 00 	mov    0x4e0(%rdi),%rsi
     106:	eb d4                	jmp    dc <kill_orphaned_pgrp+0x1c>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:398
	    will_become_orphaned_pgrp(pgrp, ignored_task) &&
     108:	48 89 fe             	mov    %rdi,%rsi
     10b:	4c 89 e7             	mov    %r12,%rdi
     10e:	e8 fd fe ff ff       	callq  10 <will_become_orphaned_pgrp>
has_stopped_jobs():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:366
	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
     113:	85 c0                	test   %eax,%eax
     115:	74 e5                	je     fc <kill_orphaned_pgrp+0x3c>
     117:	4d 85 e4             	test   %r12,%r12
     11a:	74 e0                	je     fc <kill_orphaned_pgrp+0x3c>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     11c:	49 8b 44 24 18       	mov    0x18(%r12),%rax
has_stopped_jobs():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:366
     121:	48 85 c0             	test   %rax,%rax
     124:	75 0e                	jne    134 <kill_orphaned_pgrp+0x74>
     126:	eb d4                	jmp    fc <kill_orphaned_pgrp+0x3c>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     128:	48 8b 80 60 05 00 00 	mov    0x560(%rax),%rax
has_stopped_jobs():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:366
     12f:	48 85 c0             	test   %rax,%rax
     132:	74 c8                	je     fc <kill_orphaned_pgrp+0x3c>
     134:	48 2d 60 05 00 00    	sub    $0x560,%rax
     13a:	74 c0                	je     fc <kill_orphaned_pgrp+0x3c>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:367
		if (p->signal->flags & SIGNAL_STOP_STOPPED)
     13c:	48 8b 90 d8 06 00 00 	mov    0x6d8(%rax),%rdx
     143:	f6 42 74 01          	testb  $0x1,0x74(%rdx)
     147:	74 df                	je     128 <kill_orphaned_pgrp+0x68>
kill_orphaned_pgrp():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:400
		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
     149:	4c 89 e2             	mov    %r12,%rdx
     14c:	be 01 00 00 00       	mov    $0x1,%esi
     151:	bf 01 00 00 00       	mov    $0x1,%edi
     156:	e8 00 00 00 00       	callq  15b <kill_orphaned_pgrp+0x9b>
			157: R_X86_64_PLT32	__kill_pgrp_info-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:401
		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
     15b:	4c 89 e2             	mov    %r12,%rdx
     15e:	be 01 00 00 00       	mov    $0x1,%esi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:403
}
     163:	41 5c                	pop    %r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:401
		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
     165:	bf 12 00 00 00       	mov    $0x12,%edi
     16a:	e9 00 00 00 00       	jmpq   16f <kill_orphaned_pgrp+0xaf>
			16b: R_X86_64_PLT32	__kill_pgrp_info-0x4
     16f:	90                   	nop

0000000000000170 <task_stopped_code>:
task_stopped_code():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1188

	return pid;
}

static int *task_stopped_code(struct task_struct *p, bool ptrace)
{
     170:	e8 00 00 00 00       	callq  175 <task_stopped_code+0x5>
			171: R_X86_64_PLT32	__fentry__-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1189
	if (ptrace) {
     175:	40 84 f6             	test   %sil,%sil
     178:	74 1e                	je     198 <task_stopped_code+0x28>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1190
		if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
     17a:	48 8b 57 10          	mov    0x10(%rdi),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1196
			return &p->exit_code;
	} else {
		if (p->signal->flags & SIGNAL_STOP_STOPPED)
			return &p->signal->group_exit_code;
	}
	return NULL;
     17e:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1190
		if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
     180:	83 e2 08             	and    $0x8,%edx
     183:	74 2b                	je     1b0 <task_stopped_code+0x40>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1191
			return &p->exit_code;
     185:	48 8d 97 70 04 00 00 	lea    0x470(%rdi),%rdx
     18c:	f6 87 82 04 00 00 40 	testb  $0x40,0x482(%rdi)
     193:	48 0f 44 c2          	cmove  %rdx,%rax
     197:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1193
		if (p->signal->flags & SIGNAL_STOP_STOPPED)
     198:	48 8b 97 d8 06 00 00 	mov    0x6d8(%rdi),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1194
			return &p->signal->group_exit_code;
     19f:	48 8d 42 60          	lea    0x60(%rdx),%rax
     1a3:	f6 42 74 01          	testb  $0x1,0x74(%rdx)
     1a7:	ba 00 00 00 00       	mov    $0x0,%edx
     1ac:	48 0f 44 c2          	cmove  %rdx,%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1197
}
     1b0:	c3                   	retq   
     1b1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
     1b8:	00 00 00 00 
     1bc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000001c0 <child_wait_callback>:
child_wait_callback():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1483
	return 0;
}

static int child_wait_callback(wait_queue_entry_t *wait, unsigned mode,
				int sync, void *key)
{
     1c0:	e8 00 00 00 00       	callq  1c5 <child_wait_callback+0x5>
			1c1: R_X86_64_PLT32	__fentry__-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1488
	struct wait_opts *wo = container_of(wait, struct wait_opts,
						child_wait);
	struct task_struct *p = key;

	if (!eligible_pid(wo, p))
     1c5:	8b 47 d8             	mov    -0x28(%rdi),%eax
eligible_pid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1021
	return	wo->wo_type == PIDTYPE_MAX ||
     1c8:	83 f8 04             	cmp    $0x4,%eax
     1cb:	74 1c                	je     1e9 <child_wait_callback+0x29>
task_pid_type():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:605
	if (type == PIDTYPE_PID)
     1cd:	85 c0                	test   %eax,%eax
     1cf:	74 30                	je     201 <child_wait_callback+0x41>
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:608
		pid = task->signal->pids[type];
     1d1:	4c 8b 81 d8 06 00 00 	mov    0x6d8(%rcx),%r8
     1d8:	49 8b 84 c0 60 01 00 	mov    0x160(%r8,%rax,8),%rax
     1df:	00 
eligible_pid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1021
     1e0:	48 39 47 e0          	cmp    %rax,-0x20(%rdi)
     1e4:	74 03                	je     1e9 <child_wait_callback+0x29>
child_wait_callback():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1495

	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
		return 0;

	return default_wake_function(wait, mode, sync, key);
}
     1e6:	31 c0                	xor    %eax,%eax
     1e8:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1491
	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
     1e9:	f6 47 df 20          	testb  $0x20,-0x21(%rdi)
     1ed:	74 0d                	je     1fc <child_wait_callback+0x3c>
     1ef:	48 8b 81 e8 04 00 00 	mov    0x4e8(%rcx),%rax
     1f6:	48 39 47 08          	cmp    %rax,0x8(%rdi)
     1fa:	75 ea                	jne    1e6 <child_wait_callback+0x26>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1494
	return default_wake_function(wait, mode, sync, key);
     1fc:	e9 00 00 00 00       	jmpq   201 <child_wait_callback+0x41>
			1fd: R_X86_64_PLT32	default_wake_function-0x4
task_pid():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1296
	 */
};

static inline struct pid *task_pid(struct task_struct *task)
{
	return task->thread_pid;
     201:	48 8b 81 38 05 00 00 	mov    0x538(%rcx),%rax
task_pid_type():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1296
     208:	eb d6                	jmp    1e0 <child_wait_callback+0x20>
child_wait_callback():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1296
     20a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000210 <delayed_put_task_struct>:
delayed_put_task_struct():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:177
{
     210:	e8 00 00 00 00       	callq  215 <delayed_put_task_struct+0x5>
			211: R_X86_64_PLT32	__fentry__-0x4
     215:	41 54                	push   %r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:178
	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
     217:	4c 8d a7 50 f6 ff ff 	lea    -0x9b0(%rdi),%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:177
{
     21e:	55                   	push   %rbp
     21f:	53                   	push   %rbx
     220:	48 89 fb             	mov    %rdi,%rbx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:180
	perf_event_delayed_put(tsk);
     223:	4c 89 e7             	mov    %r12,%rdi
     226:	e8 00 00 00 00       	callq  22b <delayed_put_task_struct+0x1b>
			227: R_X86_64_PLT32	perf_event_delayed_put-0x4
arch_static_branch():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/jump_label.h:25
#include <linux/stringify.h>
#include <linux/types.h>

static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
{
	asm_volatile_goto("1:"
     22b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114

extern void __put_task_struct(struct task_struct *t);

static inline void put_task_struct(struct task_struct *t)
{
	if (refcount_dec_and_test(&t->usage))
     230:	48 8d bb 70 f6 ff ff 	lea    -0x990(%rbx),%rdi
     237:	e8 00 00 00 00       	callq  23c <delayed_put_task_struct+0x2c>
			238: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
     23c:	84 c0                	test   %al,%al
     23e:	75 51                	jne    291 <delayed_put_task_struct+0x81>
delayed_put_task_struct():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:183
}
     240:	5b                   	pop    %rbx
     241:	5d                   	pop    %rbp
     242:	41 5c                	pop    %r12
     244:	c3                   	retq   
trace_sched_process_free():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:241
);

/*
 * Tracepoint for freeing a task:
 */
DEFINE_EVENT(sched_process_template, sched_process_free,
     245:	65 8b 05 00 00 00 00 	mov    %gs:0x0(%rip),%eax        # 24c <delayed_put_task_struct+0x3c>
			248: R_X86_64_PC32	cpu_number-0x4
cpumask_test_cpu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/cpumask.h:344
 *
 * Returns 1 if @cpu is set in @cpumask, else returns 0
 */
static inline int cpumask_test_cpu(int cpu, const struct cpumask *cpumask)
{
	return test_bit(cpumask_check(cpu), cpumask_bits((cpumask)));
     24c:	89 c0                	mov    %eax,%eax
variable_test_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:215

static __always_inline bool variable_test_bit(long nr, volatile const unsigned long *addr)
{
	bool oldbit;

	asm volatile(__ASM_SIZE(bt) " %2,%1"
     24e:	48 0f a3 05 00 00 00 	bt     %rax,0x0(%rip)        # 256 <delayed_put_task_struct+0x46>
     255:	00 
			252: R_X86_64_PC32	__cpu_online_mask-0x4
trace_sched_process_free():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:241
     256:	73 d8                	jae    230 <delayed_put_task_struct+0x20>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     258:	48 8b 2d 00 00 00 00 	mov    0x0(%rip),%rbp        # 25f <delayed_put_task_struct+0x4f>
			25b: R_X86_64_PC32	__tracepoint_sched_process_free+0x24
trace_sched_process_free():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:241
     25f:	48 85 ed             	test   %rbp,%rbp
     262:	74 1d                	je     281 <delayed_put_task_struct+0x71>
     264:	48 8b 45 00          	mov    0x0(%rbp),%rax
     268:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
     26c:	48 83 c5 18          	add    $0x18,%rbp
     270:	4c 89 e6             	mov    %r12,%rsi
     273:	e8 00 00 00 00       	callq  278 <delayed_put_task_struct+0x68>
			274: R_X86_64_PLT32	__x86_indirect_thunk_rax-0x4
     278:	48 8b 45 00          	mov    0x0(%rbp),%rax
     27c:	48 85 c0             	test   %rax,%rax
     27f:	75 e7                	jne    268 <delayed_put_task_struct+0x58>
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114
     281:	48 8d bb 70 f6 ff ff 	lea    -0x990(%rbx),%rdi
     288:	e8 00 00 00 00       	callq  28d <delayed_put_task_struct+0x7d>
			289: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
     28d:	84 c0                	test   %al,%al
     28f:	74 af                	je     240 <delayed_put_task_struct+0x30>
delayed_put_task_struct():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:183
     291:	5b                   	pop    %rbx
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
		__put_task_struct(t);
     292:	4c 89 e7             	mov    %r12,%rdi
delayed_put_task_struct():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:183
     295:	5d                   	pop    %rbp
     296:	41 5c                	pop    %r12
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
     298:	e9 00 00 00 00       	jmpq   29d <delayed_put_task_struct+0x8d>
			299: R_X86_64_PLT32	__put_task_struct-0x4
delayed_put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
     29d:	0f 1f 00             	nopl   (%rax)

00000000000002a0 <release_task>:
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:187
{
     2a0:	e8 00 00 00 00       	callq  2a5 <release_task+0x5>
			2a1: R_X86_64_PLT32	__fentry__-0x4
     2a5:	41 57                	push   %r15
     2a7:	41 56                	push   %r14
list_del_rcu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rculist.h:131
 * grace period has elapsed.
 */
static inline void list_del_rcu(struct list_head *entry)
{
	__list_del_entry(entry);
	entry->prev = LIST_POISON2;
     2a9:	49 be 22 01 00 00 00 	movabs $0xdead000000000122,%r14
     2b0:	00 ad de 
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:187
     2b3:	41 55                	push   %r13
     2b5:	41 54                	push   %r12
     2b7:	55                   	push   %rbp
     2b8:	53                   	push   %rbx
     2b9:	48 89 fb             	mov    %rdi,%rbx
     2bc:	48 83 ec 18          	sub    $0x18,%rsp
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     2c0:	48 8b 83 68 06 00 00 	mov    0x668(%rbx),%rax
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:194
	atomic_dec(&__task_cred(p)->user->processes);
     2c7:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
arch_atomic_dec():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:110
 *
 * Atomically decrements @v by 1.
 */
static __always_inline void arch_atomic_dec(atomic_t *v)
{
	asm volatile(LOCK_PREFIX "decl %0"
     2ce:	f0 ff 48 04          	lock decl 0x4(%rax)
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:197
	proc_flush_task(p);
     2d2:	48 89 df             	mov    %rbx,%rdi
     2d5:	e8 00 00 00 00       	callq  2da <release_task+0x3a>
			2d6: R_X86_64_PLT32	proc_flush_task-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:198
	cgroup_release(p);
     2da:	48 89 df             	mov    %rbx,%rdi
     2dd:	e8 00 00 00 00       	callq  2e2 <release_task+0x42>
			2de: R_X86_64_PLT32	cgroup_release-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:200
	write_lock_irq(&tasklist_lock);
     2e2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			2e5: R_X86_64_32S	tasklist_lock
     2e9:	e8 00 00 00 00       	callq  2ee <release_task+0x4e>
			2ea: R_X86_64_PLT32	_raw_write_lock_irq-0x4
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     2ee:	48 8b 83 18 05 00 00 	mov    0x518(%rbx),%rax
ptrace_release_task():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:237
 *
 * Called with write_lock(&tasklist_lock) held.
 */
static inline void ptrace_release_task(struct task_struct *task)
{
	BUG_ON(!list_empty(&task->ptraced));
     2f5:	48 8d 93 18 05 00 00 	lea    0x518(%rbx),%rdx
     2fc:	48 39 c2             	cmp    %rax,%rdx
     2ff:	0f 85 07 04 00 00    	jne    70c <release_task+0x46c>
ptrace_unlink():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:104
	if (unlikely(child->ptrace))
     305:	8b 43 28             	mov    0x28(%rbx),%eax
     308:	85 c0                	test   %eax,%eax
     30a:	0f 85 fe 03 00 00    	jne    70e <release_task+0x46e>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     310:	48 8b 83 28 05 00 00 	mov    0x528(%rbx),%rax
ptrace_release_task():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:239
	ptrace_unlink(task);
	BUG_ON(!list_empty(&task->ptrace_entry));
     317:	48 8d 93 28 05 00 00 	lea    0x528(%rbx),%rdx
     31e:	48 39 c2             	cmp    %rax,%rdx
     321:	0f 85 f4 03 00 00    	jne    71b <release_task+0x47b>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     327:	48 8b ab e0 06 00 00 	mov    0x6e0(%rbx),%rbp
thread_group_leader():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:639
	return p->exit_signal >= 0;
     32e:	44 8b ab 74 04 00 00 	mov    0x474(%rbx),%r13d
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:94
	struct signal_struct *sig = tsk->signal;
     335:	4c 8b bb d8 06 00 00 	mov    0x6d8(%rbx),%r15
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338
	raw_spin_lock_init(&(_lock)->rlock);		\
} while (0)

static __always_inline void spin_lock(spinlock_t *lock)
{
	raw_spin_lock(&lock->rlock);
     33c:	48 89 ef             	mov    %rbp,%rdi
     33f:	e8 00 00 00 00       	callq  344 <release_task+0xa4>
			340: R_X86_64_PLT32	_raw_spin_lock-0x4
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:105
	posix_cpu_timers_exit(tsk);
     344:	48 89 df             	mov    %rbx,%rdi
     347:	e8 00 00 00 00       	callq  34c <release_task+0xac>
			348: R_X86_64_PLT32	posix_cpu_timers_exit-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:106
	if (group_dead) {
     34c:	45 85 ed             	test   %r13d,%r13d
     34f:	79 49                	jns    39a <release_task+0xfa>
task_tgid():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:614
	return task->signal->pids[PIDTYPE_TGID];
     351:	48 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%rax
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:114
		if (unlikely(has_group_leader_pid(tsk)))
     358:	48 8b 80 68 01 00 00 	mov    0x168(%rax),%rax
     35f:	48 39 83 38 05 00 00 	cmp    %rax,0x538(%rbx)
     366:	0f 84 93 03 00 00    	je     6ff <release_task+0x45f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:127
		if (sig->notify_count > 0 && !--sig->notify_count)
     36c:	41 8b 47 64          	mov    0x64(%r15),%eax
     370:	85 c0                	test   %eax,%eax
     372:	7e 0d                	jle    381 <release_task+0xe1>
     374:	83 e8 01             	sub    $0x1,%eax
     377:	41 89 47 64          	mov    %eax,0x64(%r15)
     37b:	0f 84 70 03 00 00    	je     6f1 <release_task+0x451>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:130
		if (tsk == sig->curr_target)
     381:	49 3b 5f 38          	cmp    0x38(%r15),%rbx
     385:	75 32                	jne    3b9 <release_task+0x119>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     387:	48 8b 83 80 05 00 00 	mov    0x580(%rbx),%rax
next_thread():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:661
	return list_entry_rcu(p->thread_group.next,
     38e:	48 2d 80 05 00 00    	sub    $0x580,%rax
     394:	49 89 47 38          	mov    %rax,0x38(%r15)
     398:	eb 1f                	jmp    3b9 <release_task+0x119>
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:107
		posix_cpu_timers_exit_group(tsk);
     39a:	48 89 df             	mov    %rbx,%rdi
     39d:	e8 00 00 00 00       	callq  3a2 <release_task+0x102>
			39e: R_X86_64_PLT32	posix_cpu_timers_exit_group-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:120
		tty = sig->tty;
     3a2:	49 8b 87 90 01 00 00 	mov    0x190(%r15),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:121
		sig->tty = NULL;
     3a9:	49 c7 87 90 01 00 00 	movq   $0x0,0x190(%r15)
     3b0:	00 00 00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:120
		tty = sig->tty;
     3b4:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:134
	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
     3b9:	48 8d bb d0 00 00 00 	lea    0xd0(%rbx),%rdi
     3c0:	be 08 00 00 00       	mov    $0x8,%esi
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338
     3c5:	4d 8d a7 a4 01 00 00 	lea    0x1a4(%r15),%r12
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:134
     3cc:	e8 00 00 00 00       	callq  3d1 <release_task+0x131>
			3cd: R_X86_64_PLT32	add_device_randomness-0x4
task_cputime():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/cputime.h:28
extern u64 task_gtime(struct task_struct *t);
#else
static inline void task_cputime(struct task_struct *t,
				u64 *utime, u64 *stime)
{
	*utime = t->utime;
     3d1:	48 8b 8b b8 05 00 00 	mov    0x5b8(%rbx),%rcx
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/cputime.h:29
	*stime = t->stime;
     3d8:	48 8b 83 c0 05 00 00 	mov    0x5c0(%rbx),%rax
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338
     3df:	4c 89 e7             	mov    %r12,%rdi
task_cputime():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/cputime.h:28
	*utime = t->utime;
     3e2:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/cputime.h:29
	*stime = t->stime;
     3e7:	48 89 04 24          	mov    %rax,(%rsp)
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338
     3eb:	e8 00 00 00 00       	callq  3f0 <release_task+0x150>
			3ec: R_X86_64_PLT32	_raw_spin_lock-0x4
raw_write_seqcount_begin():
/home/jeffrin/UP/linux-stable-rc/./include/linux/seqlock.h:228



static inline void raw_write_seqcount_begin(seqcount_t *s)
{
	s->sequence++;
     3f0:	41 83 87 a0 01 00 00 	addl   $0x1,0x1a0(%r15)
     3f7:	01 
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:146
	sig->stime += stime;
     3f8:	48 8b 04 24          	mov    (%rsp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:145
	sig->utime += utime;
     3fc:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
__unhash_process():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:75
	detach_pid(p, PIDTYPE_PID);
     401:	31 f6                	xor    %esi,%esi
     403:	48 89 df             	mov    %rbx,%rdi
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:145
	sig->utime += utime;
     406:	49 01 8f a8 01 00 00 	add    %rcx,0x1a8(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:146
	sig->stime += stime;
     40d:	49 01 87 b0 01 00 00 	add    %rax,0x1b0(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:147
	sig->gtime += task_gtime(tsk);
     414:	48 8b 83 c8 05 00 00 	mov    0x5c8(%rbx),%rax
     41b:	49 01 87 c8 01 00 00 	add    %rax,0x1c8(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:148
	sig->min_flt += tsk->min_flt;
     422:	48 8b 83 08 06 00 00 	mov    0x608(%rbx),%rax
     429:	49 01 87 10 02 00 00 	add    %rax,0x210(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:149
	sig->maj_flt += tsk->maj_flt;
     430:	48 8b 83 10 06 00 00 	mov    0x610(%rbx),%rax
     437:	49 01 87 18 02 00 00 	add    %rax,0x218(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:150
	sig->nvcsw += tsk->nvcsw;
     43e:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
     445:	49 01 87 f0 01 00 00 	add    %rax,0x1f0(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:151
	sig->nivcsw += tsk->nivcsw;
     44c:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
     453:	49 01 87 f8 01 00 00 	add    %rax,0x1f8(%r15)
task_io_get_inblock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:22
 * We approximate number of blocks, because we account bytes only.
 * A 'block' is 512 bytes
 */
static inline unsigned long task_io_get_inblock(const struct task_struct *p)
{
	return p->ioac.read_bytes >> 9;
     45a:	48 8b 83 f8 07 00 00 	mov    0x7f8(%rbx),%rax
     461:	48 c1 e8 09          	shr    $0x9,%rax
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:152
	sig->inblock += task_io_get_inblock(tsk);
     465:	49 01 87 30 02 00 00 	add    %rax,0x230(%r15)
task_io_get_oublock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:36
 * We approximate number of blocks, because we account bytes only.
 * A 'block' is 512 bytes
 */
static inline unsigned long task_io_get_oublock(const struct task_struct *p)
{
	return p->ioac.write_bytes >> 9;
     46c:	48 8b 83 00 08 00 00 	mov    0x800(%rbx),%rax
     473:	48 c1 e8 09          	shr    $0x9,%rax
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:153
	sig->oublock += task_io_get_oublock(tsk);
     477:	49 01 87 38 02 00 00 	add    %rax,0x238(%r15)
task_chr_io_accounting_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:96

#ifdef CONFIG_TASK_XACCT
static inline void task_chr_io_accounting_add(struct task_io_accounting *dst,
						struct task_io_accounting *src)
{
	dst->rchar += src->rchar;
     47e:	48 8b 83 d8 07 00 00 	mov    0x7d8(%rbx),%rax
     485:	49 01 87 60 02 00 00 	add    %rax,0x260(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:97
	dst->wchar += src->wchar;
     48c:	48 8b 83 e0 07 00 00 	mov    0x7e0(%rbx),%rax
     493:	49 01 87 68 02 00 00 	add    %rax,0x268(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:98
	dst->syscr += src->syscr;
     49a:	48 8b 83 e8 07 00 00 	mov    0x7e8(%rbx),%rax
     4a1:	49 01 87 70 02 00 00 	add    %rax,0x270(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:99
	dst->syscw += src->syscw;
     4a8:	48 8b 83 f0 07 00 00 	mov    0x7f0(%rbx),%rax
     4af:	49 01 87 78 02 00 00 	add    %rax,0x278(%r15)
task_blk_io_accounting_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:52
	dst->read_bytes += src->read_bytes;
     4b6:	48 8b 83 f8 07 00 00 	mov    0x7f8(%rbx),%rax
     4bd:	49 01 87 80 02 00 00 	add    %rax,0x280(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:53
	dst->write_bytes += src->write_bytes;
     4c4:	48 8b 83 00 08 00 00 	mov    0x800(%rbx),%rax
     4cb:	49 01 87 88 02 00 00 	add    %rax,0x288(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:54
	dst->cancelled_write_bytes += src->cancelled_write_bytes;
     4d2:	48 8b 83 08 08 00 00 	mov    0x808(%rbx),%rax
     4d9:	49 01 87 90 02 00 00 	add    %rax,0x290(%r15)
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:155
	sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
     4e0:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:156
	sig->nr_threads--;
     4e7:	41 83 6f 08 01       	subl   $0x1,0x8(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:155
	sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
     4ec:	49 01 87 98 02 00 00 	add    %rax,0x298(%r15)
__unhash_process():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:74
	nr_threads--;
     4f3:	83 2d 00 00 00 00 01 	subl   $0x1,0x0(%rip)        # 4fa <release_task+0x25a>
			4f5: R_X86_64_PC32	nr_threads-0x5
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:75
	detach_pid(p, PIDTYPE_PID);
     4fa:	e8 00 00 00 00       	callq  4ff <release_task+0x25f>
			4fb: R_X86_64_PLT32	detach_pid-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:76
	if (group_dead) {
     4ff:	45 85 ed             	test   %r13d,%r13d
     502:	0f 89 13 01 00 00    	jns    61b <release_task+0x37b>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:85
	list_del_rcu(&p->thread_group);
     508:	48 8d bb 80 05 00 00 	lea    0x580(%rbx),%rdi
__list_del_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:131
 * Note: list_empty() on entry does not return true after this, the entry is
 * in an undefined state.
 */
static inline void __list_del_entry(struct list_head *entry)
{
	if (!__list_del_entry_valid(entry))
     50f:	e8 00 00 00 00       	callq  514 <release_task+0x274>
			510: R_X86_64_PLT32	__list_del_entry_valid-0x4
     514:	84 c0                	test   %al,%al
     516:	74 15                	je     52d <release_task+0x28d>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:134
		return;

	__list_del(entry->prev, entry->next);
     518:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
     51f:	48 8b 83 88 05 00 00 	mov    0x588(%rbx),%rax
__list_del():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:105
	next->prev = prev;
     526:	48 89 41 08          	mov    %rax,0x8(%rcx)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
{
	switch (size) {
	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
	case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
	case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
     52a:	48 89 08             	mov    %rcx,(%rax)
list_del_rcu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rculist.h:131
     52d:	4c 89 b3 88 05 00 00 	mov    %r14,0x588(%rbx)
__unhash_process():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:86
	list_del_rcu(&p->thread_node);
     534:	48 8d bb 90 05 00 00 	lea    0x590(%rbx),%rdi
__list_del_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:131
	if (!__list_del_entry_valid(entry))
     53b:	e8 00 00 00 00       	callq  540 <release_task+0x2a0>
			53c: R_X86_64_PLT32	__list_del_entry_valid-0x4
     540:	84 c0                	test   %al,%al
     542:	74 15                	je     559 <release_task+0x2b9>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:134
	__list_del(entry->prev, entry->next);
     544:	48 8b 8b 90 05 00 00 	mov    0x590(%rbx),%rcx
     54b:	48 8b 83 98 05 00 00 	mov    0x598(%rbx),%rax
__list_del():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:105
	next->prev = prev;
     552:	48 89 41 08          	mov    %rax,0x8(%rcx)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
     556:	48 89 08             	mov    %rcx,(%rax)
list_del_rcu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rculist.h:131
     559:	4c 89 b3 98 05 00 00 	mov    %r14,0x598(%rbx)
raw_write_seqcount_end():
/home/jeffrin/UP/linux-stable-rc/./include/linux/seqlock.h:235
}

static inline void raw_write_seqcount_end(seqcount_t *s)
{
	smp_wmb();
	s->sequence++;
     560:	41 83 87 a0 01 00 00 	addl   $0x1,0x1a0(%r15)
     567:	01 
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
     568:	4c 89 e7             	mov    %r12,%rdi
     56b:	ff 14 25 00 00 00 00 	callq  *0x0
			56e: R_X86_64_32S	pv_ops+0x2a8
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:164
	flush_sigqueue(&tsk->pending);
     572:	48 8d bb 00 07 00 00 	lea    0x700(%rbx),%rdi
     579:	e8 00 00 00 00       	callq  57e <release_task+0x2de>
			57a: R_X86_64_PLT32	flush_sigqueue-0x4
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
     57e:	48 89 ef             	mov    %rbp,%rdi
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:165
	tsk->sighand = NULL;
     581:	48 c7 83 e0 06 00 00 	movq   $0x0,0x6e0(%rbx)
     588:	00 00 00 00 
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
     58c:	ff 14 25 00 00 00 00 	callq  *0x0
			58f: R_X86_64_32S	pv_ops+0x2a8
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:168
	__cleanup_sighand(sighand);
     593:	e8 00 00 00 00       	callq  598 <release_task+0x2f8>
			594: R_X86_64_PLT32	__cleanup_sighand-0x4
arch_clear_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:76
		asm volatile(LOCK_PREFIX "andb %1,%0"
     598:	f0 80 23 fb          	lock andb $0xfb,(%rbx)
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:170
	if (group_dead) {
     59c:	45 85 ed             	test   %r13d,%r13d
     59f:	78 13                	js     5b4 <release_task+0x314>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:171
		flush_sigqueue(&sig->shared_pending);
     5a1:	49 8d 7f 40          	lea    0x40(%r15),%rdi
     5a5:	e8 00 00 00 00       	callq  5aa <release_task+0x30a>
			5a6: R_X86_64_PLT32	flush_sigqueue-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:172
		tty_kref_put(tty);
     5aa:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
     5af:	e8 00 00 00 00       	callq  5b4 <release_task+0x314>
			5b0: R_X86_64_PLT32	tty_kref_put-0x4
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:210
	leader = p->group_leader;
     5b4:	48 8b ab 10 05 00 00 	mov    0x510(%rbx),%rbp
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:211
	if (leader != p && thread_group_empty(leader)
     5bb:	48 39 eb             	cmp    %rbp,%rbx
     5be:	74 17                	je     5d7 <release_task+0x337>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
     5c0:	48 8b 85 80 05 00 00 	mov    0x580(%rbp),%rax
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
	return list_empty(&p->thread_group);
     5c7:	48 8d 95 80 05 00 00 	lea    0x580(%rbp),%rdx
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:211
     5ce:	48 39 c2             	cmp    %rax,%rdx
     5d1:	0f 84 e2 00 00 00    	je     6b9 <release_task+0x419>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:209
	zap_leader = 0;
     5d7:	45 31 e4             	xor    %r12d,%r12d
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:223
	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
     5da:	c6 05 00 00 00 00 00 	movb   $0x0,0x0(%rip)        # 5e1 <release_task+0x341>
			5dc: R_X86_64_PC32	tasklist_lock-0x5
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
     5e1:	ff 14 25 00 00 00 00 	callq  *0x0
			5e4: R_X86_64_32S	pv_ops+0x140
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:224
	release_thread(p);
     5e8:	48 89 df             	mov    %rbx,%rdi
     5eb:	e8 00 00 00 00       	callq  5f0 <release_task+0x350>
			5ec: R_X86_64_PLT32	release_thread-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:225
	call_rcu(&p->rcu, delayed_put_task_struct);
     5f0:	48 8d bb b0 09 00 00 	lea    0x9b0(%rbx),%rdi
     5f7:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
			5fa: R_X86_64_32S	.text+0x210
     5fe:	e8 00 00 00 00       	callq  603 <release_task+0x363>
			5ff: R_X86_64_PLT32	call_rcu-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:228
	if (unlikely(zap_leader))
     603:	45 85 e4             	test   %r12d,%r12d
     606:	0f 85 11 01 00 00    	jne    71d <release_task+0x47d>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:230
}
     60c:	48 83 c4 18          	add    $0x18,%rsp
     610:	5b                   	pop    %rbx
     611:	5d                   	pop    %rbp
     612:	41 5c                	pop    %r12
     614:	41 5d                	pop    %r13
     616:	41 5e                	pop    %r14
     618:	41 5f                	pop    %r15
     61a:	c3                   	retq   
__unhash_process():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:77
		detach_pid(p, PIDTYPE_TGID);
     61b:	be 01 00 00 00       	mov    $0x1,%esi
     620:	48 89 df             	mov    %rbx,%rdi
     623:	e8 00 00 00 00       	callq  628 <release_task+0x388>
			624: R_X86_64_PLT32	detach_pid-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:78
		detach_pid(p, PIDTYPE_PGID);
     628:	be 02 00 00 00       	mov    $0x2,%esi
     62d:	48 89 df             	mov    %rbx,%rdi
     630:	e8 00 00 00 00       	callq  635 <release_task+0x395>
			631: R_X86_64_PLT32	detach_pid-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:79
		detach_pid(p, PIDTYPE_SID);
     635:	48 89 df             	mov    %rbx,%rdi
     638:	be 03 00 00 00       	mov    $0x3,%esi
     63d:	e8 00 00 00 00       	callq  642 <release_task+0x3a2>
			63e: R_X86_64_PLT32	detach_pid-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:81
		list_del_rcu(&p->tasks);
     642:	48 8d bb d0 03 00 00 	lea    0x3d0(%rbx),%rdi
__list_del_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:131
	if (!__list_del_entry_valid(entry))
     649:	e8 00 00 00 00       	callq  64e <release_task+0x3ae>
			64a: R_X86_64_PLT32	__list_del_entry_valid-0x4
     64e:	84 c0                	test   %al,%al
     650:	74 15                	je     667 <release_task+0x3c7>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:134
	__list_del(entry->prev, entry->next);
     652:	48 8b 8b d0 03 00 00 	mov    0x3d0(%rbx),%rcx
     659:	48 8b 83 d8 03 00 00 	mov    0x3d8(%rbx),%rax
__list_del():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:105
	next->prev = prev;
     660:	48 89 41 08          	mov    %rax,0x8(%rcx)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
     664:	48 89 08             	mov    %rcx,(%rax)
list_del_rcu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rculist.h:131
     667:	4c 89 b3 d8 03 00 00 	mov    %r14,0x3d8(%rbx)
__unhash_process():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:82
		list_del_init(&p->sibling);
     66e:	48 8d 8b 00 05 00 00 	lea    0x500(%rbx),%rcx
__list_del_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:131
	if (!__list_del_entry_valid(entry))
     675:	48 89 cf             	mov    %rcx,%rdi
     678:	48 89 0c 24          	mov    %rcx,(%rsp)
     67c:	e8 00 00 00 00       	callq  681 <release_task+0x3e1>
			67d: R_X86_64_PLT32	__list_del_entry_valid-0x4
     681:	48 8b 0c 24          	mov    (%rsp),%rcx
     685:	84 c0                	test   %al,%al
     687:	74 15                	je     69e <release_task+0x3fe>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:134
	__list_del(entry->prev, entry->next);
     689:	48 8b b3 00 05 00 00 	mov    0x500(%rbx),%rsi
     690:	48 8b 83 08 05 00 00 	mov    0x508(%rbx),%rax
__list_del():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:105
	next->prev = prev;
     697:	48 89 46 08          	mov    %rax,0x8(%rsi)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
     69b:	48 89 30             	mov    %rsi,(%rax)
     69e:	48 89 8b 00 05 00 00 	mov    %rcx,0x500(%rbx)
INIT_LIST_HEAD():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:29
	list->prev = list;
     6a5:	48 89 8b 08 05 00 00 	mov    %rcx,0x508(%rbx)
__unhash_process():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:83
		__this_cpu_dec(process_counts);
     6ac:	65 48 ff 0d 00 00 00 	decq   %gs:0x0(%rip)        # 6b4 <release_task+0x414>
     6b3:	00 
			6b0: R_X86_64_PC32	process_counts-0x4
     6b4:	e9 4f fe ff ff       	jmpq   508 <release_task+0x268>
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:212
			&& leader->exit_state == EXIT_ZOMBIE) {
     6b9:	83 bd 6c 04 00 00 20 	cmpl   $0x20,0x46c(%rbp)
     6c0:	0f 85 11 ff ff ff    	jne    5d7 <release_task+0x337>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:218
		zap_leader = do_notify_parent(leader, leader->exit_signal);
     6c6:	8b b5 74 04 00 00    	mov    0x474(%rbp),%esi
     6cc:	48 89 ef             	mov    %rbp,%rdi
     6cf:	e8 00 00 00 00       	callq  6d4 <release_task+0x434>
			6d0: R_X86_64_PLT32	do_notify_parent-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:219
		if (zap_leader)
     6d4:	84 c0                	test   %al,%al
     6d6:	0f 84 fb fe ff ff    	je     5d7 <release_task+0x337>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:220
			leader->exit_state = EXIT_DEAD;
     6dc:	c7 85 6c 04 00 00 10 	movl   $0x10,0x46c(%rbp)
     6e3:	00 00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:218
		zap_leader = do_notify_parent(leader, leader->exit_signal);
     6e6:	41 bc 01 00 00 00    	mov    $0x1,%r12d
     6ec:	e9 e9 fe ff ff       	jmpq   5da <release_task+0x33a>
__exit_signal():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:128
			wake_up_process(sig->group_exit_task);
     6f1:	49 8b 7f 68          	mov    0x68(%r15),%rdi
     6f5:	e8 00 00 00 00       	callq  6fa <release_task+0x45a>
			6f6: R_X86_64_PLT32	wake_up_process-0x4
     6fa:	e9 82 fc ff ff       	jmpq   381 <release_task+0xe1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:115
			posix_cpu_timers_exit_group(tsk);
     6ff:	48 89 df             	mov    %rbx,%rdi
     702:	e8 00 00 00 00       	callq  707 <release_task+0x467>
			703: R_X86_64_PLT32	posix_cpu_timers_exit_group-0x4
     707:	e9 60 fc ff ff       	jmpq   36c <release_task+0xcc>
ptrace_release_task():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:237
	BUG_ON(!list_empty(&task->ptraced));
     70c:	0f 0b                	ud2    
ptrace_unlink():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:105
		__ptrace_unlink(child);
     70e:	48 89 df             	mov    %rbx,%rdi
     711:	e8 00 00 00 00       	callq  716 <release_task+0x476>
			712: R_X86_64_PLT32	__ptrace_unlink-0x4
     716:	e9 f5 fb ff ff       	jmpq   310 <release_task+0x70>
ptrace_release_task():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:239
	BUG_ON(!list_empty(&task->ptrace_entry));
     71b:	0f 0b                	ud2    
release_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:210
	leader = p->group_leader;
     71d:	48 89 eb             	mov    %rbp,%rbx
     720:	e9 9b fb ff ff       	jmpq   2c0 <release_task+0x20>
     725:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
     72c:	00 00 00 00 

0000000000000730 <wait_consider_task>:
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1343
{
     730:	e8 00 00 00 00       	callq  735 <wait_consider_task+0x5>
			731: R_X86_64_PLT32	__fentry__-0x4
     735:	41 57                	push   %r15
     737:	41 56                	push   %r14
     739:	41 55                	push   %r13
     73b:	41 54                	push   %r12
     73d:	55                   	push   %rbp
     73e:	48 89 d5             	mov    %rdx,%rbp
     741:	53                   	push   %rbx
     742:	48 83 ec 28          	sub    $0x28,%rsp
     746:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
     74d:	00 00 
     74f:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
     754:	31 c0                	xor    %eax,%eax
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
     756:	8b 92 6c 04 00 00    	mov    0x46c(%rdx),%edx
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1352
	if (unlikely(exit_state == EXIT_DEAD))
     75c:	83 fa 10             	cmp    $0x10,%edx
     75f:	74 26                	je     787 <wait_consider_task+0x57>
eligible_child():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1028
	if (!eligible_pid(wo, p))
     761:	8b 07                	mov    (%rdi),%eax
     763:	48 89 fb             	mov    %rdi,%rbx
     766:	41 89 f5             	mov    %esi,%r13d
eligible_pid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1021
	return	wo->wo_type == PIDTYPE_MAX ||
     769:	83 f8 04             	cmp    $0x4,%eax
     76c:	74 4f                	je     7bd <wait_consider_task+0x8d>
task_pid_type():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:605
	if (type == PIDTYPE_PID)
     76e:	85 c0                	test   %eax,%eax
     770:	74 3e                	je     7b0 <wait_consider_task+0x80>
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:608
		pid = task->signal->pids[type];
     772:	48 8b 8d d8 06 00 00 	mov    0x6d8(%rbp),%rcx
     779:	48 8b 84 c1 60 01 00 	mov    0x160(%rcx,%rax,8),%rax
     780:	00 
eligible_pid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1021
     781:	48 39 43 08          	cmp    %rax,0x8(%rbx)
     785:	74 36                	je     7bd <wait_consider_task+0x8d>
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1305
		return 0;
     787:	45 31 e4             	xor    %r12d,%r12d
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1442
}
     78a:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
     78f:	65 48 33 04 25 28 00 	xor    %gs:0x28,%rax
     796:	00 00 
     798:	0f 85 6f 08 00 00    	jne    100d <wait_consider_task+0x8dd>
     79e:	48 83 c4 28          	add    $0x28,%rsp
     7a2:	44 89 e0             	mov    %r12d,%eax
     7a5:	5b                   	pop    %rbx
     7a6:	5d                   	pop    %rbp
     7a7:	41 5c                	pop    %r12
     7a9:	41 5d                	pop    %r13
     7ab:	41 5e                	pop    %r14
     7ad:	41 5f                	pop    %r15
     7af:	c3                   	retq   
task_pid():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1296
     7b0:	48 8b 85 38 05 00 00 	mov    0x538(%rbp),%rax
eligible_pid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1021
	return	wo->wo_type == PIDTYPE_MAX ||
     7b7:	48 39 43 08          	cmp    %rax,0x8(%rbx)
     7bb:	75 ca                	jne    787 <wait_consider_task+0x57>
eligible_child():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1035
	if (ptrace || (wo->wo_flags & __WALL))
     7bd:	45 85 ed             	test   %r13d,%r13d
     7c0:	0f 85 b1 02 00 00    	jne    a77 <wait_consider_task+0x347>
     7c6:	8b 43 04             	mov    0x4(%rbx),%eax
     7c9:	a9 00 00 00 40       	test   $0x40000000,%eax
     7ce:	75 15                	jne    7e5 <wait_consider_task+0xb5>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1046
	if ((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
     7d0:	83 bd 74 04 00 00 11 	cmpl   $0x11,0x474(%rbp)
     7d7:	89 c1                	mov    %eax,%ecx
     7d9:	40 0f 95 c6          	setne  %sil
     7dd:	c1 e9 1f             	shr    $0x1f,%ecx
     7e0:	40 38 ce             	cmp    %cl,%sil
     7e3:	75 a2                	jne    787 <wait_consider_task+0x57>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1359
	if (unlikely(exit_state == EXIT_TRACE)) {
     7e5:	83 fa 30             	cmp    $0x30,%edx
     7e8:	0f 84 e9 03 00 00    	je     bd7 <wait_consider_task+0x4a7>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1369 (discriminator 1)
	if (likely(!ptrace) && unlikely(p->ptrace)) {
     7ee:	8b 7d 28             	mov    0x28(%rbp),%edi
     7f1:	85 ff                	test   %edi,%edi
     7f3:	0f 85 fa 03 00 00    	jne    bf3 <wait_consider_task+0x4c3>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1386
	if (exit_state == EXIT_ZOMBIE) {
     7f9:	83 fa 20             	cmp    $0x20,%edx
     7fc:	0f 84 40 02 00 00    	je     a42 <wait_consider_task+0x312>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1419
			wo->notask_error = 0;
     802:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%rbx)
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1228
	if (!ptrace && !(wo->wo_flags & WUNTRACED))
     809:	a8 02                	test   $0x2,%al
     80b:	0f 84 3b 01 00 00    	je     94c <wait_consider_task+0x21c>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1231
	if (!task_stopped_code(p, ptrace))
     811:	45 31 e4             	xor    %r12d,%r12d
     814:	45 85 ed             	test   %r13d,%r13d
     817:	48 89 ef             	mov    %rbp,%rdi
     81a:	41 0f 95 c4          	setne  %r12b
     81e:	44 89 e6             	mov    %r12d,%esi
     821:	e8 4a f9 ff ff       	callq  170 <task_stopped_code>
     826:	48 85 c0             	test   %rax,%rax
     829:	0f 84 1a 01 00 00    	je     949 <wait_consider_task+0x219>
spin_lock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:363
	raw_spin_lock_nest_lock(spinlock_check(lock), nest_lock);	\
} while (0)

static __always_inline void spin_lock_irq(spinlock_t *lock)
{
	raw_spin_lock_irq(&lock->rlock);
     82f:	48 8b bd e0 06 00 00 	mov    0x6e0(%rbp),%rdi
     836:	e8 00 00 00 00       	callq  83b <wait_consider_task+0x10b>
			837: R_X86_64_PLT32	_raw_spin_lock_irq-0x4
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1237
	p_code = task_stopped_code(p, ptrace);
     83b:	44 89 e6             	mov    %r12d,%esi
     83e:	48 89 ef             	mov    %rbp,%rdi
     841:	e8 2a f9 ff ff       	callq  170 <task_stopped_code>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1238
	if (unlikely(!p_code))
     846:	48 85 c0             	test   %rax,%rax
     849:	0f 84 ed 03 00 00    	je     c3c <wait_consider_task+0x50c>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1241
	exit_code = *p_code;
     84f:	44 8b 30             	mov    (%rax),%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1222
	uid_t uid = 0; /* unneeded, required by compiler */
     852:	45 31 ff             	xor    %r15d,%r15d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1242
	if (!exit_code)
     855:	45 85 f6             	test   %r14d,%r14d
     858:	74 35                	je     88f <wait_consider_task+0x15f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1245
	if (!unlikely(wo->wo_flags & WNOWAIT))
     85a:	f6 43 07 01          	testb  $0x1,0x7(%rbx)
     85e:	75 06                	jne    866 <wait_consider_task+0x136>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1246
		*p_code = 0;
     860:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     866:	48 8b 85 68 06 00 00 	mov    0x668(%rbp),%rax
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1248
	uid = from_kuid_munged(current_user_ns(), task_uid(p));
     86d:	8b 70 04             	mov    0x4(%rax),%esi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15

DECLARE_PER_CPU(struct task_struct *, current_task);

static __always_inline struct task_struct *get_current(void)
{
	return this_cpu_read_stable(current_task);
     870:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
     877:	00 00 
			875: R_X86_64_32S	current_task
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1248
     879:	48 8b 80 70 06 00 00 	mov    0x670(%rax),%rax
     880:	48 8b b8 88 00 00 00 	mov    0x88(%rax),%rdi
     887:	e8 00 00 00 00       	callq  88c <wait_consider_task+0x15c>
			888: R_X86_64_PLT32	from_kuid_munged-0x4
     88c:	41 89 c7             	mov    %eax,%r15d
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
     88f:	48 8b bd e0 06 00 00 	mov    0x6e0(%rbp),%rdi
     896:	ff 14 25 00 00 00 00 	callq  *0x0
			899: R_X86_64_32S	pv_ops+0x2a8
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
     89d:	ff 14 25 00 00 00 00 	callq  *0x0
			8a0: R_X86_64_32S	pv_ops+0x140
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1251
	if (!exit_code)
     8a4:	45 85 f6             	test   %r14d,%r14d
     8a7:	0f 84 9c 00 00 00    	je     949 <wait_consider_task+0x219>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1261
	get_task_struct(p);
     8ad:	4c 8d 45 20          	lea    0x20(%rbp),%r8
     8b1:	4c 89 c7             	mov    %r8,%rdi
     8b4:	4c 89 04 24          	mov    %r8,(%rsp)
     8b8:	e8 00 00 00 00       	callq  8bd <wait_consider_task+0x18d>
			8b9: R_X86_64_PLT32	refcount_inc_checked-0x4
task_pid_vnr():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1324
	return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
}

static inline pid_t task_pid_vnr(struct task_struct *tsk)
{
	return __task_pid_nr_ns(tsk, PIDTYPE_PID, NULL);
     8bd:	31 d2                	xor    %edx,%edx
     8bf:	31 f6                	xor    %esi,%esi
     8c1:	48 89 ef             	mov    %rbp,%rdi
     8c4:	e8 00 00 00 00       	callq  8c9 <wait_consider_task+0x199>
			8c5: R_X86_64_PLT32	__task_pid_nr_ns-0x4
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1263
	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
     8c9:	45 85 ed             	test   %r13d,%r13d
     8cc:	41 0f 94 c5          	sete   %r13b
task_pid_vnr():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1324
     8d0:	41 89 c4             	mov    %eax,%r12d
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
 *
 * Atomically adds @i to @v and returns @i + @v
 */
static __always_inline int arch_atomic_add_return(int i, atomic_t *v)
{
	return i + xadd(&v->counter, i);
     8d3:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1263
     8d8:	45 0f b6 ed          	movzbl %r13b,%r13d
     8dc:	41 83 c5 04          	add    $0x4,%r13d
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
     8e0:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # 8e8 <wait_consider_task+0x1b8>
     8e7:	00 
			8e4: R_X86_64_PC32	tasklist_lock-0x4
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1266
	if (wo->wo_rusage)
     8e8:	48 8b 53 20          	mov    0x20(%rbx),%rdx
     8ec:	4c 8b 04 24          	mov    (%rsp),%r8
     8f0:	48 85 d2             	test   %rdx,%rdx
     8f3:	74 11                	je     906 <wait_consider_task+0x1d6>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1267
		getrusage(p, RUSAGE_BOTH, wo->wo_rusage);
     8f5:	be fe ff ff ff       	mov    $0xfffffffe,%esi
     8fa:	48 89 ef             	mov    %rbp,%rdi
     8fd:	e8 00 00 00 00       	callq  902 <wait_consider_task+0x1d2>
			8fe: R_X86_64_PLT32	getrusage-0x4
     902:	4c 8b 04 24          	mov    (%rsp),%r8
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114
	if (refcount_dec_and_test(&t->usage))
     906:	4c 89 c7             	mov    %r8,%rdi
     909:	e8 00 00 00 00       	callq  90e <wait_consider_task+0x1de>
			90a: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
     90e:	84 c0                	test   %al,%al
     910:	0f 85 d0 02 00 00    	jne    be6 <wait_consider_task+0x4b6>
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1270
	if (likely(!(wo->wo_flags & WNOWAIT)))
     916:	f6 43 07 01          	testb  $0x1,0x7(%rbx)
     91a:	75 0c                	jne    928 <wait_consider_task+0x1f8>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1271
		wo->wo_stat = (exit_code << 8) | 0x7f;
     91c:	44 89 f0             	mov    %r14d,%eax
     91f:	c1 e0 08             	shl    $0x8,%eax
     922:	83 c8 7f             	or     $0x7f,%eax
     925:	89 43 18             	mov    %eax,0x18(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1273
	infop = wo->wo_info;
     928:	48 8b 43 10          	mov    0x10(%rbx),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1274
	if (infop) {
     92c:	48 85 c0             	test   %rax,%rax
     92f:	74 0f                	je     940 <wait_consider_task+0x210>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1275
		infop->cause = why;
     931:	44 89 68 0c          	mov    %r13d,0xc(%rax)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1276
		infop->status = exit_code;
     935:	44 89 70 08          	mov    %r14d,0x8(%rax)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1277
		infop->pid = pid;
     939:	44 89 20             	mov    %r12d,(%rax)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1278
		infop->uid = uid;
     93c:	44 89 78 04          	mov    %r15d,0x4(%rax)
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1433
	if (ret)
     940:	45 85 e4             	test   %r12d,%r12d
     943:	0f 85 41 fe ff ff    	jne    78a <wait_consider_task+0x5a>
     949:	8b 43 04             	mov    0x4(%rbx),%eax
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1295
	if (!unlikely(wo->wo_flags & WCONTINUED))
     94c:	a8 08                	test   $0x8,%al
     94e:	0f 84 33 fe ff ff    	je     787 <wait_consider_task+0x57>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1298
	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
     954:	48 8b 85 d8 06 00 00 	mov    0x6d8(%rbp),%rax
     95b:	f6 40 74 02          	testb  $0x2,0x74(%rax)
     95f:	0f 84 22 fe ff ff    	je     787 <wait_consider_task+0x57>
spin_lock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:363
     965:	48 8b bd e0 06 00 00 	mov    0x6e0(%rbp),%rdi
     96c:	e8 00 00 00 00       	callq  971 <wait_consider_task+0x241>
			96d: R_X86_64_PLT32	_raw_spin_lock_irq-0x4
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1303
	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED)) {
     971:	48 8b 95 d8 06 00 00 	mov    0x6d8(%rbp),%rdx
     978:	8b 42 74             	mov    0x74(%rdx),%eax
     97b:	a8 02                	test   $0x2,%al
     97d:	0f 84 66 06 00 00    	je     fe9 <wait_consider_task+0x8b9>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1307
	if (!unlikely(wo->wo_flags & WNOWAIT))
     983:	f6 43 07 01          	testb  $0x1,0x7(%rbx)
     987:	75 06                	jne    98f <wait_consider_task+0x25f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1308
		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
     989:	83 e0 fd             	and    $0xfffffffd,%eax
     98c:	89 42 74             	mov    %eax,0x74(%rdx)
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     98f:	48 8b 85 68 06 00 00 	mov    0x668(%rbp),%rax
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1309
	uid = from_kuid_munged(current_user_ns(), task_uid(p));
     996:	8b 70 04             	mov    0x4(%rax),%esi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
     999:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
     9a0:	00 00 
			99e: R_X86_64_32S	current_task
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1309
     9a2:	48 8b 80 70 06 00 00 	mov    0x670(%rax),%rax
     9a9:	48 8b b8 88 00 00 00 	mov    0x88(%rax),%rdi
     9b0:	e8 00 00 00 00       	callq  9b5 <wait_consider_task+0x285>
			9b1: R_X86_64_PLT32	from_kuid_munged-0x4
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
     9b5:	48 8b bd e0 06 00 00 	mov    0x6e0(%rbp),%rdi
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1309
     9bc:	41 89 c5             	mov    %eax,%r13d
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
     9bf:	ff 14 25 00 00 00 00 	callq  *0x0
			9c2: R_X86_64_32S	pv_ops+0x2a8
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
     9c6:	ff 14 25 00 00 00 00 	callq  *0x0
			9c9: R_X86_64_32S	pv_ops+0x140
task_pid_vnr():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1324
     9cd:	31 d2                	xor    %edx,%edx
     9cf:	31 f6                	xor    %esi,%esi
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1313
	get_task_struct(p);
     9d1:	4c 8d 75 20          	lea    0x20(%rbp),%r14
task_pid_vnr():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1324
     9d5:	48 89 ef             	mov    %rbp,%rdi
     9d8:	e8 00 00 00 00       	callq  9dd <wait_consider_task+0x2ad>
			9d9: R_X86_64_PLT32	__task_pid_nr_ns-0x4
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1313
     9dd:	4c 89 f7             	mov    %r14,%rdi
task_pid_vnr():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1324
     9e0:	41 89 c4             	mov    %eax,%r12d
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1313
     9e3:	e8 00 00 00 00       	callq  9e8 <wait_consider_task+0x2b8>
			9e4: R_X86_64_PLT32	refcount_inc_checked-0x4
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
     9e8:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
     9ed:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # 9f5 <wait_consider_task+0x2c5>
     9f4:	00 
			9f1: R_X86_64_PC32	tasklist_lock-0x4
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1316
	if (wo->wo_rusage)
     9f5:	48 8b 53 20          	mov    0x20(%rbx),%rdx
     9f9:	48 85 d2             	test   %rdx,%rdx
     9fc:	74 0d                	je     a0b <wait_consider_task+0x2db>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1317
		getrusage(p, RUSAGE_BOTH, wo->wo_rusage);
     9fe:	be fe ff ff ff       	mov    $0xfffffffe,%esi
     a03:	48 89 ef             	mov    %rbp,%rdi
     a06:	e8 00 00 00 00       	callq  a0b <wait_consider_task+0x2db>
			a07: R_X86_64_PLT32	getrusage-0x4
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114
     a0b:	4c 89 f7             	mov    %r14,%rdi
     a0e:	e8 00 00 00 00       	callq  a13 <wait_consider_task+0x2e3>
			a0f: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
     a13:	84 c0                	test   %al,%al
     a15:	0f 85 b5 05 00 00    	jne    fd0 <wait_consider_task+0x8a0>
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1320
	infop = wo->wo_info;
     a1b:	48 8b 43 10          	mov    0x10(%rbx),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1321
	if (!infop) {
     a1f:	48 85 c0             	test   %rax,%rax
     a22:	0f 84 b5 05 00 00    	je     fdd <wait_consider_task+0x8ad>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1327
		infop->status = SIGCONT;
     a28:	48 b9 12 00 00 00 06 	movabs $0x600000012,%rcx
     a2f:	00 00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1325
		infop->pid = pid;
     a32:	44 89 20             	mov    %r12d,(%rax)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1326
		infop->uid = uid;
     a35:	44 89 68 04          	mov    %r13d,0x4(%rax)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1327
		infop->status = SIGCONT;
     a39:	48 89 48 08          	mov    %rcx,0x8(%rax)
     a3d:	e9 48 fd ff ff       	jmpq   78a <wait_consider_task+0x5a>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1388
		if (!delay_group_leader(p)) {
     a42:	8b 85 74 04 00 00    	mov    0x474(%rbp),%eax
     a48:	85 c0                	test   %eax,%eax
     a4a:	78 5a                	js     aa6 <wait_consider_task+0x376>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     a4c:	48 8b 85 80 05 00 00 	mov    0x580(%rbp),%rax
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
	return list_empty(&p->thread_group);
     a53:	48 8d 95 80 05 00 00 	lea    0x580(%rbp),%rdx
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1388
     a5a:	48 39 c2             	cmp    %rax,%rdx
     a5d:	74 42                	je     aa1 <wait_consider_task+0x371>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1418
		if (likely(!ptrace) || (wo->wo_flags & (WCONTINUED | WEXITED)))
     a5f:	45 85 ed             	test   %r13d,%r13d
     a62:	0f 85 04 05 00 00    	jne    f6c <wait_consider_task+0x83c>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1419
			wo->notask_error = 0;
     a68:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%rbx)
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1228
	if (!ptrace && !(wo->wo_flags & WUNTRACED))
     a6f:	8b 43 04             	mov    0x4(%rbx),%eax
     a72:	e9 92 fd ff ff       	jmpq   809 <wait_consider_task+0xd9>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1359
	if (unlikely(exit_state == EXIT_TRACE)) {
     a77:	83 fa 30             	cmp    $0x30,%edx
     a7a:	0f 84 07 fd ff ff    	je     787 <wait_consider_task+0x57>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1386
	if (exit_state == EXIT_ZOMBIE) {
     a80:	83 fa 20             	cmp    $0x20,%edx
     a83:	0f 84 89 05 00 00    	je     1012 <wait_consider_task+0x8e2>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1419
			wo->notask_error = 0;
     a89:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%rbx)
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1228
	if (!ptrace && !(wo->wo_flags & WUNTRACED))
     a90:	e9 7c fd ff ff       	jmpq   811 <wait_consider_task+0xe1>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1388
		if (!delay_group_leader(p)) {
     a95:	83 bd 74 04 00 00 00 	cmpl   $0x0,0x474(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1382
			ptrace = 1;
     a9c:	41 89 fd             	mov    %edi,%r13d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1388
		if (!delay_group_leader(p)) {
     a9f:	79 ab                	jns    a4c <wait_consider_task+0x31c>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1394
			if (unlikely(ptrace) || likely(!p->ptrace))
     aa1:	45 85 ed             	test   %r13d,%r13d
     aa4:	75 07                	jne    aad <wait_consider_task+0x37d>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1394 (discriminator 1)
     aa6:	8b 75 28             	mov    0x28(%rbp),%esi
     aa9:	85 f6                	test   %esi,%esi
     aab:	75 bb                	jne    a68 <wait_consider_task+0x338>
task_pid_vnr():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1324
     aad:	31 d2                	xor    %edx,%edx
     aaf:	31 f6                	xor    %esi,%esi
     ab1:	48 89 ef             	mov    %rbp,%rdi
     ab4:	e8 00 00 00 00       	callq  ab9 <wait_consider_task+0x389>
			ab5: R_X86_64_PLT32	__task_pid_nr_ns-0x4
     ab9:	41 89 c4             	mov    %eax,%r12d
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
     abc:	48 8b 85 68 06 00 00 	mov    0x668(%rbp),%rax
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1062
	uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
     ac3:	8b 70 04             	mov    0x4(%rax),%esi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
     ac6:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
     acd:	00 00 
			acb: R_X86_64_32S	current_task
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1062
     acf:	48 8b 80 70 06 00 00 	mov    0x670(%rax),%rax
     ad6:	48 8b b8 88 00 00 00 	mov    0x88(%rax),%rdi
     add:	e8 00 00 00 00       	callq  ae2 <wait_consider_task+0x3b2>
			ade: R_X86_64_PLT32	from_kuid_munged-0x4
     ae2:	41 89 c6             	mov    %eax,%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1065
	if (!likely(wo->wo_flags & WEXITED))
     ae5:	8b 43 04             	mov    0x4(%rbx),%eax
     ae8:	a8 04                	test   $0x4,%al
     aea:	0f 84 97 fc ff ff    	je     787 <wait_consider_task+0x57>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1068
	if (unlikely(wo->wo_flags & WNOWAIT)) {
     af0:	a9 00 00 00 01       	test   $0x1000000,%eax
     af5:	0f 85 1e 04 00 00    	jne    f19 <wait_consider_task+0x7e9>
same_thread_group():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:656
	return p1->signal == p2->signal;
     afb:	48 8b 85 e8 04 00 00 	mov    0x4e8(%rbp),%rax
     b02:	48 8b 95 e0 04 00 00 	mov    0x4e0(%rbp),%rdx
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1082
		EXIT_TRACE : EXIT_DEAD;
     b09:	41 bd 10 00 00 00    	mov    $0x10,%r13d
     b0f:	48 8b 80 d8 06 00 00 	mov    0x6d8(%rax),%rax
     b16:	48 39 82 d8 06 00 00 	cmp    %rax,0x6d8(%rdx)
     b1d:	74 13                	je     b32 <wait_consider_task+0x402>
     b1f:	44 8b ad 74 04 00 00 	mov    0x474(%rbp),%r13d
     b26:	41 c1 fd 1f          	sar    $0x1f,%r13d
     b2a:	41 83 e5 e0          	and    $0xffffffe0,%r13d
     b2e:	41 83 c5 30          	add    $0x30,%r13d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1083
	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
     b32:	b8 20 00 00 00       	mov    $0x20,%eax
     b37:	f0 44 0f b1 ad 6c 04 	lock cmpxchg %r13d,0x46c(%rbp)
     b3e:	00 00 
     b40:	83 f8 20             	cmp    $0x20,%eax
     b43:	0f 85 3e fc ff ff    	jne    787 <wait_consider_task+0x57>
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
     b49:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
     b4e:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # b56 <wait_consider_task+0x426>
     b55:	00 
			b52: R_X86_64_PC32	tasklist_lock-0x4
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1094
	if (state == EXIT_DEAD && thread_group_leader(p)) {
     b56:	41 83 fd 10          	cmp    $0x10,%r13d
     b5a:	0f 84 09 01 00 00    	je     c69 <wait_consider_task+0x539>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1149
	if (wo->wo_rusage)
     b60:	48 8b 53 20          	mov    0x20(%rbx),%rdx
     b64:	48 85 d2             	test   %rdx,%rdx
     b67:	74 0d                	je     b76 <wait_consider_task+0x446>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1150
		getrusage(p, RUSAGE_BOTH, wo->wo_rusage);
     b69:	be fe ff ff ff       	mov    $0xfffffffe,%esi
     b6e:	48 89 ef             	mov    %rbp,%rdi
     b71:	e8 00 00 00 00       	callq  b76 <wait_consider_task+0x446>
			b72: R_X86_64_PLT32	getrusage-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1151
	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
     b76:	48 8b 85 d8 06 00 00 	mov    0x6d8(%rbp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1152
		? p->signal->group_exit_code : p->exit_code;
     b7d:	f6 40 74 04          	testb  $0x4,0x74(%rax)
     b81:	0f 84 c0 00 00 00    	je     c47 <wait_consider_task+0x517>
     b87:	44 8b 78 60          	mov    0x60(%rax),%r15d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1153
	wo->wo_stat = status;
     b8b:	44 89 7b 18          	mov    %r15d,0x18(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1155
	if (state == EXIT_TRACE) {
     b8f:	41 83 fd 30          	cmp    $0x30,%r13d
     b93:	0f 84 ef 03 00 00    	je     f88 <wait_consider_task+0x858>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1167
	if (state == EXIT_DEAD)
     b99:	41 83 fd 10          	cmp    $0x10,%r13d
     b9d:	0f 84 d8 03 00 00    	je     f7b <wait_consider_task+0x84b>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1171
	infop = wo->wo_info;
     ba3:	48 8b 53 10          	mov    0x10(%rbx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1172
	if (infop) {
     ba7:	48 85 d2             	test   %rdx,%rdx
     baa:	0f 84 da fb ff ff    	je     78a <wait_consider_task+0x5a>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1173
		if ((status & 0x7f) == 0) {
     bb0:	44 89 f9             	mov    %r15d,%ecx
     bb3:	83 e1 7f             	and    $0x7f,%ecx
     bb6:	0f 85 97 00 00 00    	jne    c53 <wait_consider_task+0x523>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1175
			infop->status = status >> 8;
     bbc:	41 c1 ff 08          	sar    $0x8,%r15d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1174
			infop->cause = CLD_EXITED;
     bc0:	c7 42 0c 01 00 00 00 	movl   $0x1,0xc(%rdx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1175
			infop->status = status >> 8;
     bc7:	44 89 7a 08          	mov    %r15d,0x8(%rdx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1180
		infop->pid = pid;
     bcb:	44 89 22             	mov    %r12d,(%rdx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1181
		infop->uid = uid;
     bce:	44 89 72 04          	mov    %r14d,0x4(%rdx)
     bd2:	e9 b3 fb ff ff       	jmpq   78a <wait_consider_task+0x5a>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1365
			wo->notask_error = 0;
     bd7:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1366
		return 0;
     bde:	45 31 e4             	xor    %r12d,%r12d
     be1:	e9 a4 fb ff ff       	jmpq   78a <wait_consider_task+0x5a>
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
		__put_task_struct(t);
     be6:	48 89 ef             	mov    %rbp,%rdi
     be9:	e8 00 00 00 00       	callq  bee <wait_consider_task+0x4be>
			bea: R_X86_64_PLT32	__put_task_struct-0x4
     bee:	e9 23 fd ff ff       	jmpq   916 <wait_consider_task+0x1e6>
same_thread_group():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:656
     bf3:	48 8b 8d e0 04 00 00 	mov    0x4e0(%rbp),%rcx
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1381
		if (!ptrace_reparented(p))
     bfa:	31 ff                	xor    %edi,%edi
same_thread_group():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:656
     bfc:	48 8b b1 d8 06 00 00 	mov    0x6d8(%rcx),%rsi
     c03:	48 8b 8d e8 04 00 00 	mov    0x4e8(%rbp),%rcx
     c0a:	48 8b 89 d8 06 00 00 	mov    0x6d8(%rcx),%rcx
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1381
     c11:	48 39 ce             	cmp    %rcx,%rsi
     c14:	40 0f 94 c7          	sete   %dil
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1386
	if (exit_state == EXIT_ZOMBIE) {
     c18:	83 fa 20             	cmp    $0x20,%edx
     c1b:	0f 84 74 fe ff ff    	je     a95 <wait_consider_task+0x365>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1419
			wo->notask_error = 0;
     c21:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%rbx)
wait_task_stopped():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1228
	if (!ptrace && !(wo->wo_flags & WUNTRACED))
     c28:	48 39 ce             	cmp    %rcx,%rsi
     c2b:	0f 85 d8 fb ff ff    	jne    809 <wait_consider_task+0xd9>
     c31:	41 bd 01 00 00 00    	mov    $0x1,%r13d
     c37:	e9 d5 fb ff ff       	jmpq   811 <wait_consider_task+0xe1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1222
	uid_t uid = 0; /* unneeded, required by compiler */
     c3c:	45 31 ff             	xor    %r15d,%r15d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1234
	exit_code = 0;
     c3f:	45 31 f6             	xor    %r14d,%r14d
     c42:	e9 48 fc ff ff       	jmpq   88f <wait_consider_task+0x15f>
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1152
		? p->signal->group_exit_code : p->exit_code;
     c47:	44 8b bd 70 04 00 00 	mov    0x470(%rbp),%r15d
     c4e:	e9 38 ff ff ff       	jmpq   b8b <wait_consider_task+0x45b>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1177
			infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
     c53:	41 c0 ef 07          	shr    $0x7,%r15b
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1178
			infop->status = status & 0x7f;
     c57:	89 4a 08             	mov    %ecx,0x8(%rdx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1177
			infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
     c5a:	41 0f b6 c7          	movzbl %r15b,%eax
     c5e:	83 c0 02             	add    $0x2,%eax
     c61:	89 42 0c             	mov    %eax,0xc(%rdx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1178
			infop->status = status & 0x7f;
     c64:	e9 62 ff ff ff       	jmpq   bcb <wait_consider_task+0x49b>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1094
	if (state == EXIT_DEAD && thread_group_leader(p)) {
     c69:	8b 8d 74 04 00 00    	mov    0x474(%rbp),%ecx
     c6f:	85 c9                	test   %ecx,%ecx
     c71:	0f 88 e9 fe ff ff    	js     b60 <wait_consider_task+0x430>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1095
		struct signal_struct *sig = p->signal;
     c77:	48 8b 8d d8 06 00 00 	mov    0x6d8(%rbp),%rcx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1120
		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
     c7e:	48 8d 54 24 18       	lea    0x18(%rsp),%rdx
     c83:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
     c88:	48 89 ef             	mov    %rbp,%rdi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
     c8b:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
     c92:	00 00 
			c90: R_X86_64_32S	current_task
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1095
		struct signal_struct *sig = p->signal;
     c94:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1096
		struct signal_struct *psig = current->signal;
     c99:	4c 8b b8 d8 06 00 00 	mov    0x6d8(%rax),%r15
     ca0:	48 89 04 24          	mov    %rax,(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1120
		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
     ca4:	e8 00 00 00 00       	callq  ca9 <wait_consider_task+0x579>
			ca5: R_X86_64_PLT32	thread_group_cputime_adjusted-0x4
spin_lock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:363
     ca9:	48 8b 04 24          	mov    (%rsp),%rax
     cad:	48 8b b8 e0 06 00 00 	mov    0x6e0(%rax),%rdi
     cb4:	e8 00 00 00 00       	callq  cb9 <wait_consider_task+0x589>
			cb5: R_X86_64_PLT32	_raw_spin_lock_irq-0x4
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338
	raw_spin_lock(&lock->rlock);
     cb9:	49 8d bf a4 01 00 00 	lea    0x1a4(%r15),%rdi
     cc0:	48 89 3c 24          	mov    %rdi,(%rsp)
     cc4:	e8 00 00 00 00       	callq  cc9 <wait_consider_task+0x599>
			cc5: R_X86_64_PLT32	_raw_spin_lock-0x4
raw_write_seqcount_begin():
/home/jeffrin/UP/linux-stable-rc/./include/linux/seqlock.h:228
	s->sequence++;
     cc9:	41 83 87 a0 01 00 00 	addl   $0x1,0x1a0(%r15)
     cd0:	01 
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1123
		psig->cutime += tgutime + sig->cutime;
     cd1:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
     cd6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
     cdb:	48 03 81 b8 01 00 00 	add    0x1b8(%rcx),%rax
     ce2:	49 01 87 b8 01 00 00 	add    %rax,0x1b8(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1124
		psig->cstime += tgstime + sig->cstime;
     ce9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
     cee:	48 03 81 c0 01 00 00 	add    0x1c0(%rcx),%rax
     cf5:	49 01 87 c0 01 00 00 	add    %rax,0x1c0(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1125
		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
     cfc:	48 8b 81 d0 01 00 00 	mov    0x1d0(%rcx),%rax
     d03:	48 03 81 c8 01 00 00 	add    0x1c8(%rcx),%rax
     d0a:	48 03 85 c8 05 00 00 	add    0x5c8(%rbp),%rax
     d11:	49 01 87 d0 01 00 00 	add    %rax,0x1d0(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1127
			p->min_flt + sig->min_flt + sig->cmin_flt;
     d18:	48 8b 81 20 02 00 00 	mov    0x220(%rcx),%rax
     d1f:	48 03 81 10 02 00 00 	add    0x210(%rcx),%rax
     d26:	48 03 85 08 06 00 00 	add    0x608(%rbp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1126
		psig->cmin_flt +=
     d2d:	49 01 87 20 02 00 00 	add    %rax,0x220(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1129
			p->maj_flt + sig->maj_flt + sig->cmaj_flt;
     d34:	48 8b 81 28 02 00 00 	mov    0x228(%rcx),%rax
     d3b:	48 03 81 18 02 00 00 	add    0x218(%rcx),%rax
     d42:	48 03 85 10 06 00 00 	add    0x610(%rbp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1128
		psig->cmaj_flt +=
     d49:	49 01 87 28 02 00 00 	add    %rax,0x228(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1131
			p->nvcsw + sig->nvcsw + sig->cnvcsw;
     d50:	48 8b 81 00 02 00 00 	mov    0x200(%rcx),%rax
     d57:	48 03 81 f0 01 00 00 	add    0x1f0(%rcx),%rax
     d5e:	48 03 85 e8 05 00 00 	add    0x5e8(%rbp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1130
		psig->cnvcsw +=
     d65:	49 01 87 00 02 00 00 	add    %rax,0x200(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1133
			p->nivcsw + sig->nivcsw + sig->cnivcsw;
     d6c:	48 8b 81 08 02 00 00 	mov    0x208(%rcx),%rax
     d73:	48 03 81 f8 01 00 00 	add    0x1f8(%rcx),%rax
     d7a:	48 03 85 f0 05 00 00 	add    0x5f0(%rbp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1132
		psig->cnivcsw +=
     d81:	49 01 87 08 02 00 00 	add    %rax,0x208(%r15)
task_io_get_inblock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:22
	return p->ioac.read_bytes >> 9;
     d88:	48 8b 95 f8 07 00 00 	mov    0x7f8(%rbp),%rdx
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1141
		if (psig->cmaxrss < maxrss)
     d8f:	48 8b 3c 24          	mov    (%rsp),%rdi
task_io_get_inblock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:22
     d93:	48 c1 ea 09          	shr    $0x9,%rdx
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1135
			task_io_get_inblock(p) +
     d97:	48 03 91 30 02 00 00 	add    0x230(%rcx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1136
			sig->inblock + sig->cinblock;
     d9e:	48 03 91 40 02 00 00 	add    0x240(%rcx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1134
		psig->cinblock +=
     da5:	49 01 97 40 02 00 00 	add    %rdx,0x240(%r15)
task_io_get_oublock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:36
	return p->ioac.write_bytes >> 9;
     dac:	48 8b 95 00 08 00 00 	mov    0x800(%rbp),%rdx
     db3:	48 c1 ea 09          	shr    $0x9,%rdx
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1138
			task_io_get_oublock(p) +
     db7:	48 03 91 38 02 00 00 	add    0x238(%rcx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1139
			sig->oublock + sig->coublock;
     dbe:	48 03 91 48 02 00 00 	add    0x248(%rcx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1137
		psig->coublock +=
     dc5:	49 01 97 48 02 00 00 	add    %rdx,0x248(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1140
		maxrss = max(sig->maxrss, sig->cmaxrss);
     dcc:	48 8b 81 58 02 00 00 	mov    0x258(%rcx),%rax
     dd3:	48 39 81 50 02 00 00 	cmp    %rax,0x250(%rcx)
     dda:	48 0f 43 81 50 02 00 	cmovae 0x250(%rcx),%rax
     de1:	00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1141
		if (psig->cmaxrss < maxrss)
     de2:	49 3b 87 58 02 00 00 	cmp    0x258(%r15),%rax
     de9:	76 07                	jbe    df2 <wait_consider_task+0x6c2>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1142
			psig->cmaxrss = maxrss;
     deb:	49 89 87 58 02 00 00 	mov    %rax,0x258(%r15)
task_chr_io_accounting_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:96
	dst->rchar += src->rchar;
     df2:	48 8b 95 d8 07 00 00 	mov    0x7d8(%rbp),%rdx
     df9:	49 03 97 60 02 00 00 	add    0x260(%r15),%rdx
     e00:	49 89 97 60 02 00 00 	mov    %rdx,0x260(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:97
	dst->wchar += src->wchar;
     e07:	4c 8b 9d e0 07 00 00 	mov    0x7e0(%rbp),%r11
     e0e:	4d 03 9f 68 02 00 00 	add    0x268(%r15),%r11
     e15:	4d 89 9f 68 02 00 00 	mov    %r11,0x268(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:98
	dst->syscr += src->syscr;
     e1c:	4c 8b 95 e8 07 00 00 	mov    0x7e8(%rbp),%r10
     e23:	4d 03 97 70 02 00 00 	add    0x270(%r15),%r10
     e2a:	4d 89 97 70 02 00 00 	mov    %r10,0x270(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:99
	dst->syscw += src->syscw;
     e31:	4c 8b 8d f0 07 00 00 	mov    0x7f0(%rbp),%r9
     e38:	4d 03 8f 78 02 00 00 	add    0x278(%r15),%r9
     e3f:	4d 89 8f 78 02 00 00 	mov    %r9,0x278(%r15)
task_blk_io_accounting_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:52
	dst->read_bytes += src->read_bytes;
     e46:	4c 8b 85 f8 07 00 00 	mov    0x7f8(%rbp),%r8
     e4d:	4d 03 87 80 02 00 00 	add    0x280(%r15),%r8
     e54:	4d 89 87 80 02 00 00 	mov    %r8,0x280(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:53
	dst->write_bytes += src->write_bytes;
     e5b:	48 8b b5 00 08 00 00 	mov    0x800(%rbp),%rsi
     e62:	49 03 b7 88 02 00 00 	add    0x288(%r15),%rsi
     e69:	49 89 b7 88 02 00 00 	mov    %rsi,0x288(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:54
	dst->cancelled_write_bytes += src->cancelled_write_bytes;
     e70:	48 8b 85 08 08 00 00 	mov    0x808(%rbp),%rax
     e77:	49 03 87 90 02 00 00 	add    0x290(%r15),%rax
     e7e:	49 89 87 90 02 00 00 	mov    %rax,0x290(%r15)
task_chr_io_accounting_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:96
	dst->rchar += src->rchar;
     e85:	48 03 91 60 02 00 00 	add    0x260(%rcx),%rdx
     e8c:	49 89 97 60 02 00 00 	mov    %rdx,0x260(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:97
	dst->wchar += src->wchar;
     e93:	4c 03 99 68 02 00 00 	add    0x268(%rcx),%r11
     e9a:	4d 89 9f 68 02 00 00 	mov    %r11,0x268(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:98
	dst->syscr += src->syscr;
     ea1:	4c 03 91 70 02 00 00 	add    0x270(%rcx),%r10
     ea8:	4d 89 97 70 02 00 00 	mov    %r10,0x270(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:99
	dst->syscw += src->syscw;
     eaf:	4c 03 89 78 02 00 00 	add    0x278(%rcx),%r9
     eb6:	4d 89 8f 78 02 00 00 	mov    %r9,0x278(%r15)
task_blk_io_accounting_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:52
	dst->read_bytes += src->read_bytes;
     ebd:	4c 03 81 80 02 00 00 	add    0x280(%rcx),%r8
     ec4:	4d 89 87 80 02 00 00 	mov    %r8,0x280(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:53
	dst->write_bytes += src->write_bytes;
     ecb:	48 03 b1 88 02 00 00 	add    0x288(%rcx),%rsi
     ed2:	49 89 b7 88 02 00 00 	mov    %rsi,0x288(%r15)
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_io_accounting_ops.h:54
	dst->cancelled_write_bytes += src->cancelled_write_bytes;
     ed9:	48 03 81 90 02 00 00 	add    0x290(%rcx),%rax
     ee0:	49 89 87 90 02 00 00 	mov    %rax,0x290(%r15)
raw_write_seqcount_end():
/home/jeffrin/UP/linux-stable-rc/./include/linux/seqlock.h:235
	s->sequence++;
     ee7:	41 83 87 a0 01 00 00 	addl   $0x1,0x1a0(%r15)
     eee:	01 
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
     eef:	ff 14 25 00 00 00 00 	callq  *0x0
			ef2: R_X86_64_32S	pv_ops+0x2a8
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
     ef6:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
     efd:	00 00 
			efb: R_X86_64_32S	current_task
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
     eff:	48 8b b8 e0 06 00 00 	mov    0x6e0(%rax),%rdi
     f06:	ff 14 25 00 00 00 00 	callq  *0x0
			f09: R_X86_64_32S	pv_ops+0x2a8
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
     f0d:	ff 14 25 00 00 00 00 	callq  *0x0
			f10: R_X86_64_32S	pv_ops+0x140
__raw_spin_unlock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock_api_smp.h:169
static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
{
	spin_release(&lock->dep_map, 1, _RET_IP_);
	do_raw_spin_unlock(lock);
	local_irq_enable();
	preempt_enable();
     f14:	e9 47 fc ff ff       	jmpq   b60 <wait_consider_task+0x430>
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1070
		get_task_struct(p);
     f19:	4c 8d 6d 20          	lea    0x20(%rbp),%r13
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1069
		status = p->exit_code;
     f1d:	44 8b bd 70 04 00 00 	mov    0x470(%rbp),%r15d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1070
		get_task_struct(p);
     f24:	4c 89 ef             	mov    %r13,%rdi
     f27:	e8 00 00 00 00       	callq  f2c <wait_consider_task+0x7fc>
			f28: R_X86_64_PLT32	refcount_inc_checked-0x4
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
     f2c:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
     f31:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # f39 <wait_consider_task+0x809>
     f38:	00 
			f35: R_X86_64_PC32	tasklist_lock-0x4
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1073
		if (wo->wo_rusage)
     f39:	48 8b 53 20          	mov    0x20(%rbx),%rdx
     f3d:	48 85 d2             	test   %rdx,%rdx
     f40:	74 0d                	je     f4f <wait_consider_task+0x81f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1074
			getrusage(p, RUSAGE_BOTH, wo->wo_rusage);
     f42:	be fe ff ff ff       	mov    $0xfffffffe,%esi
     f47:	48 89 ef             	mov    %rbp,%rdi
     f4a:	e8 00 00 00 00       	callq  f4f <wait_consider_task+0x81f>
			f4b: R_X86_64_PLT32	getrusage-0x4
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114
	if (refcount_dec_and_test(&t->usage))
     f4f:	4c 89 ef             	mov    %r13,%rdi
     f52:	e8 00 00 00 00       	callq  f57 <wait_consider_task+0x827>
			f53: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
     f57:	84 c0                	test   %al,%al
     f59:	0f 84 44 fc ff ff    	je     ba3 <wait_consider_task+0x473>
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
		__put_task_struct(t);
     f5f:	48 89 ef             	mov    %rbp,%rdi
     f62:	e8 00 00 00 00       	callq  f67 <wait_consider_task+0x837>
			f63: R_X86_64_PLT32	__put_task_struct-0x4
     f67:	e9 37 fc ff ff       	jmpq   ba3 <wait_consider_task+0x473>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1418 (discriminator 1)
		if (likely(!ptrace) || (wo->wo_flags & (WCONTINUED | WEXITED)))
     f6c:	f6 43 04 0c          	testb  $0xc,0x4(%rbx)
     f70:	0f 85 13 fb ff ff    	jne    a89 <wait_consider_task+0x359>
     f76:	e9 96 f8 ff ff       	jmpq   811 <wait_consider_task+0xe1>
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1168
		release_task(p);
     f7b:	48 89 ef             	mov    %rbp,%rdi
     f7e:	e8 00 00 00 00       	callq  f83 <wait_consider_task+0x853>
			f7f: R_X86_64_PLT32	release_task-0x4
     f83:	e9 1b fc ff ff       	jmpq   ba3 <wait_consider_task+0x473>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1156
		write_lock_irq(&tasklist_lock);
     f88:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			f8b: R_X86_64_32S	tasklist_lock
     f8f:	e8 00 00 00 00       	callq  f94 <wait_consider_task+0x864>
			f90: R_X86_64_PLT32	_raw_write_lock_irq-0x4
ptrace_unlink():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:104
	if (unlikely(child->ptrace))
     f94:	8b 55 28             	mov    0x28(%rbp),%edx
     f97:	85 d2                	test   %edx,%edx
     f99:	75 68                	jne    1003 <wait_consider_task+0x8d3>
wait_task_zombie():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1162
		if (do_notify_parent(p, p->exit_signal))
     f9b:	8b b5 74 04 00 00    	mov    0x474(%rbp),%esi
     fa1:	48 89 ef             	mov    %rbp,%rdi
     fa4:	e8 00 00 00 00       	callq  fa9 <wait_consider_task+0x879>
			fa5: R_X86_64_PLT32	do_notify_parent-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1163
			state = EXIT_DEAD;
     fa9:	3c 01                	cmp    $0x1,%al
     fab:	45 19 ed             	sbb    %r13d,%r13d
     fae:	41 83 e5 10          	and    $0x10,%r13d
     fb2:	41 83 c5 10          	add    $0x10,%r13d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1164
		p->exit_state = state;
     fb6:	44 89 ad 6c 04 00 00 	mov    %r13d,0x46c(%rbp)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:223
	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
     fbd:	c6 05 00 00 00 00 00 	movb   $0x0,0x0(%rip)        # fc4 <wait_consider_task+0x894>
			fbf: R_X86_64_PC32	tasklist_lock-0x5
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
     fc4:	ff 14 25 00 00 00 00 	callq  *0x0
			fc7: R_X86_64_32S	pv_ops+0x140
__raw_write_unlock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rwlock_api_smp.h:269
{
	rwlock_release(&lock->dep_map, 1, _RET_IP_);
	do_raw_write_unlock(lock);
	local_irq_enable();
	preempt_enable();
}
     fcb:	e9 c9 fb ff ff       	jmpq   b99 <wait_consider_task+0x469>
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
     fd0:	48 89 ef             	mov    %rbp,%rdi
     fd3:	e8 00 00 00 00       	callq  fd8 <wait_consider_task+0x8a8>
			fd4: R_X86_64_PLT32	__put_task_struct-0x4
     fd8:	e9 3e fa ff ff       	jmpq   a1b <wait_consider_task+0x2eb>
wait_task_continued():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1322
		wo->wo_stat = 0xffff;
     fdd:	c7 43 18 ff ff 00 00 	movl   $0xffff,0x18(%rbx)
     fe4:	e9 a1 f7 ff ff       	jmpq   78a <wait_consider_task+0x5a>
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
     fe9:	48 8b bd e0 06 00 00 	mov    0x6e0(%rbp),%rdi
     ff0:	ff 14 25 00 00 00 00 	callq  *0x0
			ff3: R_X86_64_32S	pv_ops+0x2a8
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
     ff7:	ff 14 25 00 00 00 00 	callq  *0x0
			ffa: R_X86_64_32S	pv_ops+0x140
__raw_spin_unlock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock_api_smp.h:169
     ffe:	e9 84 f7 ff ff       	jmpq   787 <wait_consider_task+0x57>
ptrace_unlink():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:105
		__ptrace_unlink(child);
    1003:	48 89 ef             	mov    %rbp,%rdi
    1006:	e8 00 00 00 00       	callq  100b <wait_consider_task+0x8db>
			1007: R_X86_64_PLT32	__ptrace_unlink-0x4
    100b:	eb 8e                	jmp    f9b <wait_consider_task+0x86b>
wait_consider_task():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1442
}
    100d:	e8 00 00 00 00       	callq  1012 <wait_consider_task+0x8e2>
			100e: R_X86_64_PLT32	__stack_chk_fail-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1388
		if (!delay_group_leader(p)) {
    1012:	83 bd 74 04 00 00 00 	cmpl   $0x0,0x474(%rbp)
    1019:	0f 89 2d fa ff ff    	jns    a4c <wait_consider_task+0x31c>
    101f:	e9 89 fa ff ff       	jmpq   aad <wait_consider_task+0x37d>
    1024:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    102b:	00 00 00 00 
    102f:	90                   	nop

0000000000001030 <do_wait>:
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1504
	__wake_up_sync_key(&parent->signal->wait_chldexit,
				TASK_INTERRUPTIBLE, 1, p);
}

static long do_wait(struct wait_opts *wo)
{
    1030:	e8 00 00 00 00       	callq  1035 <do_wait+0x5>
			1031: R_X86_64_PLT32	__fentry__-0x4
    1035:	41 57                	push   %r15
    1037:	49 89 ff             	mov    %rdi,%r15
    103a:	41 56                	push   %r14
    103c:	41 55                	push   %r13
    103e:	41 54                	push   %r12
    1040:	55                   	push   %rbp
    1041:	53                   	push   %rbx
    1042:	48 83 ec 18          	sub    $0x18,%rsp
arch_static_branch():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/jump_label.h:25
    1046:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    104b:	65 48 8b 2c 25 00 00 	mov    %gs:0x0,%rbp
    1052:	00 00 
			1050: R_X86_64_32S	current_task
init_waitqueue_func_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/wait.h:89
}

static inline void
init_waitqueue_func_entry(struct wait_queue_entry *wq_entry, wait_queue_func_t func)
{
	wq_entry->flags		= 0;
    1054:	41 c7 47 28 00 00 00 	movl   $0x0,0x28(%r15)
    105b:	00 
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1510
	struct task_struct *tsk;
	int retval;

	trace_sched_process_wait(wo->wo_pid);

	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
    105c:	49 8d 77 28          	lea    0x28(%r15),%rsi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1060:	48 89 eb             	mov    %rbp,%rbx
init_waitqueue_func_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/wait.h:91
	wq_entry->private	= NULL;
	wq_entry->func		= func;
    1063:	49 c7 47 38 00 00 00 	movq   $0x0,0x38(%r15)
    106a:	00 
			1067: R_X86_64_32S	.text+0x1c0
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1511
	wo->child_wait.private = current;
    106b:	49 89 6f 30          	mov    %rbp,0x30(%r15)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1512
	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
    106f:	48 8b 85 d8 06 00 00 	mov    0x6d8(%rbp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1510
	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
    1076:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1512
	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
    107b:	48 8d 78 20          	lea    0x20(%rax),%rdi
    107f:	e8 00 00 00 00       	callq  1084 <do_wait+0x54>
			1080: R_X86_64_PLT32	add_wait_queue-0x4
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1084:	48 89 2c 24          	mov    %rbp,(%rsp)
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1521
	 * We will clear ->notask_error to zero if we see any child that
	 * might later match our criteria, even if we are not able to reap
	 * it yet.
	 */
	wo->notask_error = -ECHILD;
	if ((wo->wo_type < PIDTYPE_MAX) &&
    1088:	41 8b 07             	mov    (%r15),%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1520
	wo->notask_error = -ECHILD;
    108b:	41 c7 47 50 f6 ff ff 	movl   $0xfffffff6,0x50(%r15)
    1092:	ff 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1521
	if ((wo->wo_type < PIDTYPE_MAX) &&
    1093:	83 f8 03             	cmp    $0x3,%eax
    1096:	77 55                	ja     10ed <do_wait+0xbd>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1522 (discriminator 1)
	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
    1098:	49 8b 57 08          	mov    0x8(%r15),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1521 (discriminator 1)
	if ((wo->wo_type < PIDTYPE_MAX) &&
    109c:	48 85 d2             	test   %rdx,%rdx
    109f:	74 0d                	je     10ae <do_wait+0x7e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1522
	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
    10a1:	48 8d 44 c2 08       	lea    0x8(%rdx,%rax,8),%rax
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
    10a6:	48 8b 00             	mov    (%rax),%rax
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1522
    10a9:	48 85 c0             	test   %rax,%rax
    10ac:	75 3f                	jne    10ed <do_wait+0xbd>
    10ae:	49 c7 c4 f6 ff ff ff 	mov    $0xfffffffffffffff6,%r12
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    10b5:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    10bc:	00 00 
			10ba: R_X86_64_32S	current_task
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1553
			goto repeat;
		}
	}
end:
	__set_current_state(TASK_RUNNING);
	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
    10be:	48 8b b8 d8 06 00 00 	mov    0x6d8(%rax),%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1552
	__set_current_state(TASK_RUNNING);
    10c5:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
    10cc:	00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1553
	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
    10cd:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
    10d2:	48 83 c7 20          	add    $0x20,%rdi
    10d6:	e8 00 00 00 00       	callq  10db <do_wait+0xab>
			10d7: R_X86_64_PLT32	remove_wait_queue-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1555
	return retval;
}
    10db:	4c 89 e0             	mov    %r12,%rax
    10de:	48 83 c4 18          	add    $0x18,%rsp
    10e2:	5b                   	pop    %rbx
    10e3:	5d                   	pop    %rbp
    10e4:	41 5c                	pop    %r12
    10e6:	41 5d                	pop    %r13
    10e8:	41 5e                	pop    %r14
    10ea:	41 5f                	pop    %r15
    10ec:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1525
	set_current_state(TASK_INTERRUPTIBLE);
    10ed:	48 c7 44 24 10 01 00 	movq   $0x1,0x10(%rsp)
    10f4:	00 00 
    10f6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    10fb:	48 87 45 10          	xchg   %rax,0x10(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1526
	read_lock(&tasklist_lock);
    10ff:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			1102: R_X86_64_32S	tasklist_lock
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1525
	set_current_state(TASK_INTERRUPTIBLE);
    1106:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    110b:	49 89 ee             	mov    %rbp,%r14
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1525
    110e:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1526
	read_lock(&tasklist_lock);
    1113:	e8 00 00 00 00       	callq  1118 <do_wait+0xe8>
			1114: R_X86_64_PLT32	_raw_read_lock-0x4
do_wait_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1457
	list_for_each_entry(p, &tsk->children, sibling) {
    1118:	49 8b 86 f0 04 00 00 	mov    0x4f0(%r14),%rax
    111f:	4d 8d a6 f0 04 00 00 	lea    0x4f0(%r14),%r12
    1126:	4c 8d a8 00 fb ff ff 	lea    -0x500(%rax),%r13
    112d:	49 39 c4             	cmp    %rax,%r12
    1130:	75 15                	jne    1147 <do_wait+0x117>
    1132:	eb 2c                	jmp    1160 <do_wait+0x130>
    1134:	49 8b 85 00 05 00 00 	mov    0x500(%r13),%rax
    113b:	4c 8d a8 00 fb ff ff 	lea    -0x500(%rax),%r13
    1142:	49 39 c4             	cmp    %rax,%r12
    1145:	74 19                	je     1160 <do_wait+0x130>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1458
		int ret = wait_consider_task(wo, 0, p);
    1147:	31 f6                	xor    %esi,%esi
    1149:	4c 89 ea             	mov    %r13,%rdx
    114c:	4c 89 ff             	mov    %r15,%rdi
    114f:	e8 dc f5 ff ff       	callq  730 <wait_consider_task>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1460
		if (ret)
    1154:	85 c0                	test   %eax,%eax
    1156:	74 dc                	je     1134 <do_wait+0x104>
    1158:	4c 63 e0             	movslq %eax,%r12
    115b:	e9 55 ff ff ff       	jmpq   10b5 <do_wait+0x85>
ptrace_do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1471
	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
    1160:	49 8b 86 18 05 00 00 	mov    0x518(%r14),%rax
    1167:	4d 8d a6 18 05 00 00 	lea    0x518(%r14),%r12
    116e:	4c 8d a8 d8 fa ff ff 	lea    -0x528(%rax),%r13
    1175:	49 39 c4             	cmp    %rax,%r12
    1178:	75 15                	jne    118f <do_wait+0x15f>
    117a:	eb 29                	jmp    11a5 <do_wait+0x175>
    117c:	49 8b 85 28 05 00 00 	mov    0x528(%r13),%rax
    1183:	4c 8d a8 d8 fa ff ff 	lea    -0x528(%rax),%r13
    118a:	49 39 c4             	cmp    %rax,%r12
    118d:	74 16                	je     11a5 <do_wait+0x175>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1472
		int ret = wait_consider_task(wo, 1, p);
    118f:	4c 89 ea             	mov    %r13,%rdx
    1192:	be 01 00 00 00       	mov    $0x1,%esi
    1197:	4c 89 ff             	mov    %r15,%rdi
    119a:	e8 91 f5 ff ff       	callq  730 <wait_consider_task>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1474
		if (ret)
    119f:	85 c0                	test   %eax,%eax
    11a1:	74 d9                	je     117c <do_wait+0x14c>
    11a3:	eb b3                	jmp    1158 <do_wait+0x128>
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1537
		if (wo->wo_flags & __WNOTHREAD)
    11a5:	41 f6 47 07 20       	testb  $0x20,0x7(%r15)
    11aa:	75 17                	jne    11c3 <do_wait+0x193>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    11ac:	4d 8b b6 80 05 00 00 	mov    0x580(%r14),%r14
next_thread():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:661
	return list_entry_rcu(p->thread_group.next,
    11b3:	49 81 ee 80 05 00 00 	sub    $0x580,%r14
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1539
	} while_each_thread(current, tsk);
    11ba:	4c 39 f3             	cmp    %r14,%rbx
    11bd:	0f 85 55 ff ff ff    	jne    1118 <do_wait+0xe8>
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
    11c3:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
    11c8:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # 11d0 <do_wait+0x1a0>
    11cf:	00 
			11cc: R_X86_64_PC32	tasklist_lock-0x4
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1543
	retval = wo->notask_error;
    11d0:	41 8b 47 50          	mov    0x50(%r15),%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1544
	if (!retval && !(wo->wo_flags & WNOHANG)) {
    11d4:	85 c0                	test   %eax,%eax
    11d6:	75 80                	jne    1158 <do_wait+0x128>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1544 (discriminator 1)
    11d8:	41 f6 47 04 01       	testb  $0x1,0x4(%r15)
    11dd:	75 68                	jne    1247 <do_wait+0x217>
constant_test_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:208
		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
    11df:	48 8b 04 24          	mov    (%rsp),%rax
    11e3:	48 8b 00             	mov    (%rax),%rax
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1546
		if (!signal_pending(current)) {
    11e6:	a8 04                	test   $0x4,%al
    11e8:	75 51                	jne    123b <do_wait+0x20b>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1547
			schedule();
    11ea:	e8 00 00 00 00       	callq  11ef <do_wait+0x1bf>
			11eb: R_X86_64_PLT32	schedule-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1548
			goto repeat;
    11ef:	e9 94 fe ff ff       	jmpq   1088 <do_wait+0x58>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1508
	trace_sched_process_wait(wo->wo_pid);
    11f4:	48 8b 6f 08          	mov    0x8(%rdi),%rbp
trace_sched_process_wait():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:262
	TP_ARGS(p));

/*
 * Tracepoint for a waiting task:
 */
TRACE_EVENT(sched_process_wait,
    11f8:	65 8b 05 00 00 00 00 	mov    %gs:0x0(%rip),%eax        # 11ff <do_wait+0x1cf>
			11fb: R_X86_64_PC32	cpu_number-0x4
cpumask_test_cpu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/cpumask.h:344
    11ff:	89 c0                	mov    %eax,%eax
variable_test_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:215
	asm volatile(__ASM_SIZE(bt) " %2,%1"
    1201:	48 0f a3 05 00 00 00 	bt     %rax,0x0(%rip)        # 1209 <do_wait+0x1d9>
    1208:	00 
			1205: R_X86_64_PC32	__cpu_online_mask-0x4
trace_sched_process_wait():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:262
    1209:	0f 83 3c fe ff ff    	jae    104b <do_wait+0x1b>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    120f:	48 8b 1d 00 00 00 00 	mov    0x0(%rip),%rbx        # 1216 <do_wait+0x1e6>
			1212: R_X86_64_PC32	__tracepoint_sched_process_wait+0x24
trace_sched_process_wait():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:262
    1216:	48 85 db             	test   %rbx,%rbx
    1219:	74 1b                	je     1236 <do_wait+0x206>
    121b:	48 8b 03             	mov    (%rbx),%rax
    121e:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
    1222:	48 83 c3 18          	add    $0x18,%rbx
    1226:	48 89 ee             	mov    %rbp,%rsi
    1229:	e8 00 00 00 00       	callq  122e <do_wait+0x1fe>
			122a: R_X86_64_PLT32	__x86_indirect_thunk_rax-0x4
    122e:	48 8b 03             	mov    (%rbx),%rax
    1231:	48 85 c0             	test   %rax,%rax
    1234:	75 e8                	jne    121e <do_wait+0x1ee>
    1236:	e9 10 fe ff ff       	jmpq   104b <do_wait+0x1b>
do_wait():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1551
end:
    123b:	49 c7 c4 00 fe ff ff 	mov    $0xfffffffffffffe00,%r12
    1242:	e9 6e fe ff ff       	jmpq   10b5 <do_wait+0x85>
    1247:	45 31 e4             	xor    %r12d,%r12d
    124a:	e9 66 fe ff ff       	jmpq   10b5 <do_wait+0x85>
    124f:	90                   	nop

0000000000001250 <kernel_waitid>:
kernel_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1559

static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
			  int options, struct rusage *ru)
{
    1250:	e8 00 00 00 00       	callq  1255 <kernel_waitid+0x5>
			1251: R_X86_64_PLT32	__fentry__-0x4
    1255:	41 56                	push   %r14
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1565
	struct wait_opts wo;
	struct pid *pid = NULL;
	enum pid_type type;
	long ret;

	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED|
    1257:	41 89 ce             	mov    %ecx,%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1559
{
    125a:	41 55                	push   %r13
    125c:	41 54                	push   %r12
    125e:	55                   	push   %rbp
    125f:	53                   	push   %rbx
    1260:	48 83 ec 60          	sub    $0x60,%rsp
    1264:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    126b:	00 00 
    126d:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
    1272:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1565
	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED|
    1274:	41 81 e6 f0 ff ff 1e 	and    $0x1efffff0,%r14d
    127b:	75 1b                	jne    1298 <kernel_waitid+0x48>
    127d:	89 cb                	mov    %ecx,%ebx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1568
			__WNOTHREAD|__WCLONE|__WALL))
		return -EINVAL;
	if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
    127f:	f6 c1 0e             	test   $0xe,%cl
    1282:	74 14                	je     1298 <kernel_waitid+0x48>
    1284:	48 89 d5             	mov    %rdx,%rbp
    1287:	4d 89 c4             	mov    %r8,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1571
		return -EINVAL;

	switch (which) {
    128a:	83 ff 01             	cmp    $0x1,%edi
    128d:	74 7b                	je     130a <kernel_waitid+0xba>
    128f:	83 ff 02             	cmp    $0x2,%edi
    1292:	74 60                	je     12f4 <kernel_waitid+0xa4>
    1294:	85 ff                	test   %edi,%edi
    1296:	74 27                	je     12bf <kernel_waitid+0x6f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1567
		return -EINVAL;
    1298:	49 c7 c4 ea ff ff ff 	mov    $0xffffffffffffffea,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1601
	wo.wo_rusage	= ru;
	ret = do_wait(&wo);

	put_pid(pid);
	return ret;
}
    129f:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
    12a4:	65 48 33 04 25 28 00 	xor    %gs:0x28,%rax
    12ab:	00 00 
    12ad:	75 61                	jne    1310 <kernel_waitid+0xc0>
    12af:	48 83 c4 60          	add    $0x60,%rsp
    12b3:	4c 89 e0             	mov    %r12,%rax
    12b6:	5b                   	pop    %rbx
    12b7:	5d                   	pop    %rbp
    12b8:	41 5c                	pop    %r12
    12ba:	41 5d                	pop    %r13
    12bc:	41 5e                	pop    %r14
    12be:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1571
	switch (which) {
    12bf:	41 be 04 00 00 00    	mov    $0x4,%r14d
    12c5:	45 31 ed             	xor    %r13d,%r13d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1597
	ret = do_wait(&wo);
    12c8:	48 89 e7             	mov    %rsp,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1592
	wo.wo_type	= type;
    12cb:	44 89 34 24          	mov    %r14d,(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1593
	wo.wo_pid	= pid;
    12cf:	4c 89 6c 24 08       	mov    %r13,0x8(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1594
	wo.wo_flags	= options;
    12d4:	89 5c 24 04          	mov    %ebx,0x4(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1595
	wo.wo_info	= infop;
    12d8:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1596
	wo.wo_rusage	= ru;
    12dd:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1597
	ret = do_wait(&wo);
    12e2:	e8 49 fd ff ff       	callq  1030 <do_wait>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1599
	put_pid(pid);
    12e7:	4c 89 ef             	mov    %r13,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1597
	ret = do_wait(&wo);
    12ea:	49 89 c4             	mov    %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1599
	put_pid(pid);
    12ed:	e8 00 00 00 00       	callq  12f2 <kernel_waitid+0xa2>
			12ee: R_X86_64_PLT32	put_pid-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1600
	return ret;
    12f2:	eb ab                	jmp    129f <kernel_waitid+0x4f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1582
		if (upid <= 0)
    12f4:	85 f6                	test   %esi,%esi
    12f6:	7e a0                	jle    1298 <kernel_waitid+0x48>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1581
		type = PIDTYPE_PGID;
    12f8:	41 be 02 00 00 00    	mov    $0x2,%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1590
		pid = find_get_pid(upid);
    12fe:	89 f7                	mov    %esi,%edi
    1300:	e8 00 00 00 00       	callq  1305 <kernel_waitid+0xb5>
			1301: R_X86_64_PLT32	find_get_pid-0x4
    1305:	49 89 c5             	mov    %rax,%r13
    1308:	eb be                	jmp    12c8 <kernel_waitid+0x78>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1577
		if (upid <= 0)
    130a:	85 f6                	test   %esi,%esi
    130c:	7f f0                	jg     12fe <kernel_waitid+0xae>
    130e:	eb 88                	jmp    1298 <kernel_waitid+0x48>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1601
}
    1310:	e8 00 00 00 00       	callq  1315 <kernel_waitid+0xc5>
			1311: R_X86_64_PLT32	__stack_chk_fail-0x4
    1315:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    131c:	00 00 00 00 

0000000000001320 <__do_sys_waitid>:
__do_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1605

SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
		infop, int, options, struct rusage __user *, ru)
{
    1320:	55                   	push   %rbp
    1321:	48 89 e5             	mov    %rsp,%rbp
    1324:	41 54                	push   %r12
    1326:	53                   	push   %rbx
    1327:	48 89 d3             	mov    %rdx,%rbx
    132a:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    132e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
    1335:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    133c:	00 00 
    133e:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
    1345:	00 
    1346:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1607
	struct rusage r;
	struct waitid_info info = {.status = 0};
    1348:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
    134f:	00 
    1350:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
    1357:	00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1608
	long err = kernel_waitid(which, upid, &info, options, ru ? &r : NULL);
    1359:	4d 85 c0             	test   %r8,%r8
    135c:	0f 84 a5 00 00 00    	je     1407 <__do_sys_waitid+0xe7>
    1362:	4d 89 c4             	mov    %r8,%r12
    1365:	48 89 e2             	mov    %rsp,%rdx
    1368:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
    136d:	e8 de fe ff ff       	callq  1250 <kernel_waitid>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1611
	int signo = 0;

	if (err > 0) {
    1372:	48 85 c0             	test   %rax,%rax
    1375:	7f 6d                	jg     13e4 <__do_sys_waitid+0xc4>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1609
	int signo = 0;
    1377:	31 c9                	xor    %ecx,%ecx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1617
		signo = SIGCHLD;
		err = 0;
		if (ru && copy_to_user(ru, &r, sizeof(struct rusage)))
			return -EFAULT;
	}
	if (!infop)
    1379:	48 85 db             	test   %rbx,%rbx
    137c:	74 4a                	je     13c8 <__do_sys_waitid+0xa8>
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    137e:	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
    1385:	00 00 
			1383: R_X86_64_32S	current_task
__chk_range_not_ok():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:53
	 * it might overflow the 'addr', so it's
	 * important to subtract the size from the
	 * limit, not add it to the address).
	 */
	if (__builtin_constant_p(size))
		return unlikely(addr > limit - size);
    1387:	48 8b 92 58 0b 00 00 	mov    0xb58(%rdx),%rdx
    138e:	48 83 c2 80          	add    $0xffffffffffffff80,%rdx
user_access_begin():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:714
 * checking before using them, but you have to surround them with the
 * user_access_begin/end() pair.
 */
static __must_check __always_inline bool user_access_begin(const void __user *ptr, size_t len)
{
	if (unlikely(!access_ok(ptr,len)))
    1392:	48 39 d3             	cmp    %rdx,%rbx
    1395:	0f 87 84 00 00 00    	ja     141f <__do_sys_waitid+0xff>
stac():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/smap.h:53
}

static __always_inline void stac(void)
{
	/* Note: a barrier is implicit in alternative() */
	alternative("", __ASM_STAC, X86_FEATURE_SMAP);
    139b:	90                   	nop
    139c:	90                   	nop
    139d:	90                   	nop
user_access_begin():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:716
		return 0;
	__uaccess_begin_nospec();
    139e:	90                   	nop
    139f:	90                   	nop
    13a0:	90                   	nop
__do_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1623
		return err;

	if (!user_access_begin(infop, sizeof(*infop)))
		return -EFAULT;

	unsafe_put_user(signo, &infop->si_signo, Efault);
    13a1:	89 0b                	mov    %ecx,(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1624 (discriminator 10)
	unsafe_put_user(0, &infop->si_errno, Efault);
    13a3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1625 (discriminator 10)
	unsafe_put_user(info.cause, &infop->si_code, Efault);
    13aa:	8b 54 24 0c          	mov    0xc(%rsp),%edx
    13ae:	89 53 08             	mov    %edx,0x8(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1626 (discriminator 10)
	unsafe_put_user(info.pid, &infop->si_pid, Efault);
    13b1:	8b 14 24             	mov    (%rsp),%edx
    13b4:	89 53 10             	mov    %edx,0x10(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1627 (discriminator 10)
	unsafe_put_user(info.uid, &infop->si_uid, Efault);
    13b7:	8b 54 24 04          	mov    0x4(%rsp),%edx
    13bb:	89 53 14             	mov    %edx,0x14(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1628 (discriminator 10)
	unsafe_put_user(info.status, &infop->si_status, Efault);
    13be:	8b 54 24 08          	mov    0x8(%rsp),%edx
    13c2:	89 53 18             	mov    %edx,0x18(%rbx)
clac():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/smap.h:47 (discriminator 10)
	alternative("", __ASM_CLAC, X86_FEATURE_SMAP);
    13c5:	90                   	nop
    13c6:	90                   	nop
    13c7:	90                   	nop
__do_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1634
	user_access_end();
	return err;
Efault:
	user_access_end();
	return -EFAULT;
}
    13c8:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
    13cf:	00 
    13d0:	65 48 33 34 25 28 00 	xor    %gs:0x28,%rsi
    13d7:	00 00 
    13d9:	75 4d                	jne    1428 <__do_sys_waitid+0x108>
    13db:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
    13df:	5b                   	pop    %rbx
    13e0:	41 5c                	pop    %r12
    13e2:	5d                   	pop    %rbp
    13e3:	c3                   	retq   
copy_to_user():
/home/jeffrin/UP/linux-stable-rc/./include/linux/uaccess.h:152

static __always_inline unsigned long __must_check
copy_to_user(void __user *to, const void *from, unsigned long n)
{
	if (likely(check_copy_size(from, n, true)))
		n = _copy_to_user(to, from, n);
    13e4:	ba 90 00 00 00       	mov    $0x90,%edx
    13e9:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
    13ee:	4c 89 e7             	mov    %r12,%rdi
    13f1:	e8 00 00 00 00       	callq  13f6 <__do_sys_waitid+0xd6>
			13f2: R_X86_64_PLT32	_copy_to_user-0x4
__do_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1614
		if (ru && copy_to_user(ru, &r, sizeof(struct rusage)))
    13f6:	48 85 c0             	test   %rax,%rax
    13f9:	75 24                	jne    141f <__do_sys_waitid+0xff>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1612
		signo = SIGCHLD;
    13fb:	b9 11 00 00 00       	mov    $0x11,%ecx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1613
		err = 0;
    1400:	31 c0                	xor    %eax,%eax
    1402:	e9 72 ff ff ff       	jmpq   1379 <__do_sys_waitid+0x59>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1608
	long err = kernel_waitid(which, upid, &info, options, ru ? &r : NULL);
    1407:	45 31 c0             	xor    %r8d,%r8d
    140a:	48 89 e2             	mov    %rsp,%rdx
    140d:	e8 3e fe ff ff       	callq  1250 <kernel_waitid>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1611
	if (err > 0) {
    1412:	48 85 c0             	test   %rax,%rax
    1415:	7f e4                	jg     13fb <__do_sys_waitid+0xdb>
    1417:	e9 5b ff ff ff       	jmpq   1377 <__do_sys_waitid+0x57>
clac():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/smap.h:47
    141c:	90                   	nop
    141d:	90                   	nop
    141e:	90                   	nop
__do_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1633
	return -EFAULT;
    141f:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    1426:	eb a0                	jmp    13c8 <__do_sys_waitid+0xa8>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1634
}
    1428:	e8 00 00 00 00       	callq  142d <__do_sys_waitid+0x10d>
			1429: R_X86_64_PLT32	__stack_chk_fail-0x4
    142d:	0f 1f 00             	nopl   (%rax)

0000000000001430 <__x64_sys_waitid>:
__x64_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1603
SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
    1430:	e8 00 00 00 00       	callq  1435 <__x64_sys_waitid+0x5>
			1431: R_X86_64_PLT32	__fentry__-0x4
    1435:	48 89 f8             	mov    %rdi,%rax
__se_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1603
    1438:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
    143c:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    1440:	48 8b 77 68          	mov    0x68(%rdi),%rsi
    1444:	4c 8b 40 48          	mov    0x48(%rax),%r8
    1448:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
    144c:	e9 cf fe ff ff       	jmpq   1320 <__do_sys_waitid>
__x64_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1603
    1451:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    1458:	00 00 00 00 
    145c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001460 <__ia32_sys_waitid>:
__ia32_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1603
    1460:	e8 00 00 00 00       	callq  1465 <__ia32_sys_waitid+0x5>
			1461: R_X86_64_PLT32	__fentry__-0x4
    1465:	48 89 f8             	mov    %rdi,%rax
__se_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1603
    1468:	48 8b 4f 68          	mov    0x68(%rdi),%rcx
    146c:	8b 57 60             	mov    0x60(%rdi),%edx
    146f:	48 8b 77 58          	mov    0x58(%rdi),%rsi
    1473:	44 8b 40 70          	mov    0x70(%rax),%r8d
    1477:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
    147b:	e9 a0 fe ff ff       	jmpq   1320 <__do_sys_waitid>

0000000000001480 <__do_compat_sys_waitid>:
__do_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1725

COMPAT_SYSCALL_DEFINE5(waitid,
		int, which, compat_pid_t, pid,
		struct compat_siginfo __user *, infop, int, options,
		struct compat_rusage __user *, uru)
{
    1480:	55                   	push   %rbp
    1481:	48 89 e5             	mov    %rsp,%rbp
    1484:	41 54                	push   %r12
    1486:	53                   	push   %rbx
    1487:	48 89 d3             	mov    %rdx,%rbx
    148a:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    148e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
    1495:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    149c:	00 00 
    149e:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
    14a5:	00 
    14a6:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1727
	struct rusage ru;
	struct waitid_info info = {.status = 0};
    14a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
    14af:	00 
    14b0:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
    14b7:	00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1728
	long err = kernel_waitid(which, pid, &info, options, uru ? &ru : NULL);
    14b9:	4d 85 c0             	test   %r8,%r8
    14bc:	0f 84 bc 00 00 00    	je     157e <__do_compat_sys_waitid+0xfe>
    14c2:	4d 89 c4             	mov    %r8,%r12
    14c5:	48 89 e2             	mov    %rsp,%rdx
    14c8:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
    14cd:	e8 7e fd ff ff       	callq  1250 <kernel_waitid>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1730
	int signo = 0;
	if (err > 0) {
    14d2:	48 85 c0             	test   %rax,%rax
    14d5:	0f 8e b3 00 00 00    	jle    158e <__do_compat_sys_waitid+0x10e>
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    14db:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    14e2:	00 00 
			14e0: R_X86_64_32S	current_task
__do_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1735
		signo = SIGCHLD;
		err = 0;
		if (uru) {
			/* kernel_waitid() overwrites everything in ru */
			if (COMPAT_USE_64BIT_TIME)
    14e4:	48 8b 40 18          	mov    0x18(%rax),%rax
    14e8:	f6 80 d3 3f 00 00 40 	testb  $0x40,0x3fd3(%rax)
    14ef:	0f 84 9d 00 00 00    	je     1592 <__do_compat_sys_waitid+0x112>
copy_to_user():
/home/jeffrin/UP/linux-stable-rc/./include/linux/uaccess.h:152
    14f5:	ba 90 00 00 00       	mov    $0x90,%edx
    14fa:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
    14ff:	4c 89 e7             	mov    %r12,%rdi
    1502:	e8 00 00 00 00       	callq  1507 <__do_compat_sys_waitid+0x87>
			1503: R_X86_64_PLT32	_copy_to_user-0x4
__do_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1739
				err = copy_to_user(uru, &ru, sizeof(ru));
			else
				err = put_compat_rusage(&ru, uru);
			if (err)
    1507:	48 85 c0             	test   %rax,%rax
    150a:	0f 85 99 00 00 00    	jne    15a9 <__do_compat_sys_waitid+0x129>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1731
		signo = SIGCHLD;
    1510:	b9 11 00 00 00       	mov    $0x11,%ecx
    1515:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1744
				return -EFAULT;
		}
	}

	if (!infop)
    1517:	48 85 db             	test   %rbx,%rbx
    151a:	74 46                	je     1562 <__do_compat_sys_waitid+0xe2>
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    151c:	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
    1523:	00 00 
			1521: R_X86_64_32S	current_task
__chk_range_not_ok():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:53
		return unlikely(addr > limit - size);
    1525:	48 8b 92 58 0b 00 00 	mov    0xb58(%rdx),%rdx
    152c:	48 83 c2 80          	add    $0xffffffffffffff80,%rdx
user_access_begin():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:714
	if (unlikely(!access_ok(ptr,len)))
    1530:	48 39 d3             	cmp    %rdx,%rbx
    1533:	77 74                	ja     15a9 <__do_compat_sys_waitid+0x129>
stac():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/smap.h:53
	alternative("", __ASM_STAC, X86_FEATURE_SMAP);
    1535:	90                   	nop
    1536:	90                   	nop
    1537:	90                   	nop
user_access_begin():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:716
	__uaccess_begin_nospec();
    1538:	90                   	nop
    1539:	90                   	nop
    153a:	90                   	nop
__do_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1750
		return err;

	if (!user_access_begin(infop, sizeof(*infop)))
		return -EFAULT;

	unsafe_put_user(signo, &infop->si_signo, Efault);
    153b:	89 0b                	mov    %ecx,(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1751 (discriminator 10)
	unsafe_put_user(0, &infop->si_errno, Efault);
    153d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1752 (discriminator 10)
	unsafe_put_user(info.cause, &infop->si_code, Efault);
    1544:	8b 54 24 0c          	mov    0xc(%rsp),%edx
    1548:	89 53 08             	mov    %edx,0x8(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1753 (discriminator 10)
	unsafe_put_user(info.pid, &infop->si_pid, Efault);
    154b:	8b 14 24             	mov    (%rsp),%edx
    154e:	89 53 0c             	mov    %edx,0xc(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1754 (discriminator 10)
	unsafe_put_user(info.uid, &infop->si_uid, Efault);
    1551:	8b 54 24 04          	mov    0x4(%rsp),%edx
    1555:	89 53 10             	mov    %edx,0x10(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1755 (discriminator 10)
	unsafe_put_user(info.status, &infop->si_status, Efault);
    1558:	8b 54 24 08          	mov    0x8(%rsp),%edx
    155c:	89 53 14             	mov    %edx,0x14(%rbx)
clac():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/smap.h:47 (discriminator 10)
	alternative("", __ASM_CLAC, X86_FEATURE_SMAP);
    155f:	90                   	nop
    1560:	90                   	nop
    1561:	90                   	nop
__do_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1761
	user_access_end();
	return err;
Efault:
	user_access_end();
	return -EFAULT;
}
    1562:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
    1569:	00 
    156a:	65 48 33 34 25 28 00 	xor    %gs:0x28,%rsi
    1571:	00 00 
    1573:	75 3d                	jne    15b2 <__do_compat_sys_waitid+0x132>
    1575:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
    1579:	5b                   	pop    %rbx
    157a:	41 5c                	pop    %r12
    157c:	5d                   	pop    %rbp
    157d:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1728
	long err = kernel_waitid(which, pid, &info, options, uru ? &ru : NULL);
    157e:	45 31 c0             	xor    %r8d,%r8d
    1581:	48 89 e2             	mov    %rsp,%rdx
    1584:	e8 c7 fc ff ff       	callq  1250 <kernel_waitid>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1730
	if (err > 0) {
    1589:	48 85 c0             	test   %rax,%rax
    158c:	7f 82                	jg     1510 <__do_compat_sys_waitid+0x90>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1729
	int signo = 0;
    158e:	31 c9                	xor    %ecx,%ecx
    1590:	eb 85                	jmp    1517 <__do_compat_sys_waitid+0x97>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1738
				err = put_compat_rusage(&ru, uru);
    1592:	4c 89 e6             	mov    %r12,%rsi
    1595:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    159a:	e8 00 00 00 00       	callq  159f <__do_compat_sys_waitid+0x11f>
			159b: R_X86_64_PLT32	put_compat_rusage-0x4
    159f:	48 98                	cltq   
    15a1:	e9 61 ff ff ff       	jmpq   1507 <__do_compat_sys_waitid+0x87>
clac():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/smap.h:47
    15a6:	90                   	nop
    15a7:	90                   	nop
    15a8:	90                   	nop
__do_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1760
	return -EFAULT;
    15a9:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    15b0:	eb b0                	jmp    1562 <__do_compat_sys_waitid+0xe2>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1761
}
    15b2:	e8 00 00 00 00       	callq  15b7 <__do_compat_sys_waitid+0x137>
			15b3: R_X86_64_PLT32	__stack_chk_fail-0x4
    15b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    15be:	00 00 

00000000000015c0 <__ia32_compat_sys_waitid>:
__ia32_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1721
COMPAT_SYSCALL_DEFINE5(waitid,
    15c0:	e8 00 00 00 00       	callq  15c5 <__ia32_compat_sys_waitid+0x5>
			15c1: R_X86_64_PLT32	__fentry__-0x4
    15c5:	48 89 f8             	mov    %rdi,%rax
__se_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1721
    15c8:	48 8b 4f 68          	mov    0x68(%rdi),%rcx
    15cc:	8b 57 60             	mov    0x60(%rdi),%edx
    15cf:	48 8b 77 58          	mov    0x58(%rdi),%rsi
    15d3:	44 8b 40 70          	mov    0x70(%rax),%r8d
    15d7:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
    15db:	e9 a0 fe ff ff       	jmpq   1480 <__do_compat_sys_waitid>

00000000000015e0 <__x32_compat_sys_waitid>:
__x32_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1721
    15e0:	e8 00 00 00 00       	callq  15e5 <__x32_compat_sys_waitid+0x5>
			15e1: R_X86_64_PLT32	__fentry__-0x4
    15e5:	48 89 f8             	mov    %rdi,%rax
__se_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1721
    15e8:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
    15ec:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    15f0:	48 8b 77 68          	mov    0x68(%rdi),%rsi
    15f4:	4c 8b 40 48          	mov    0x48(%rax),%r8
    15f8:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
    15fc:	e9 7f fe ff ff       	jmpq   1480 <__do_compat_sys_waitid>
__x32_compat_sys_waitid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1721
    1601:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    1608:	00 00 00 00 
    160c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001610 <task_rcu_dereference>:
task_rcu_dereference():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:237
{
    1610:	e8 00 00 00 00       	callq  1615 <task_rcu_dereference+0x5>
			1611: R_X86_64_PLT32	__fentry__-0x4
    1615:	55                   	push   %rbp
    1616:	53                   	push   %rbx
    1617:	48 89 fb             	mov    %rdi,%rbx
    161a:	48 83 ec 10          	sub    $0x10,%rsp
    161e:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    1625:	00 00 
    1627:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    162c:	31 c0                	xor    %eax,%eax
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    162e:	48 8b 2b             	mov    (%rbx),%rbp
task_rcu_dereference():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:249
	if (!task)
    1631:	48 85 ed             	test   %rbp,%rbp
    1634:	74 3a                	je     1670 <task_rcu_dereference+0x60>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:252
	probe_kernel_address(&task->sighand, sighand);
    1636:	48 8d b5 e0 06 00 00 	lea    0x6e0(%rbp),%rsi
    163d:	ba 08 00 00 00       	mov    $0x8,%edx
    1642:	48 89 e7             	mov    %rsp,%rdi
    1645:	e8 00 00 00 00       	callq  164a <task_rcu_dereference+0x3a>
			1646: R_X86_64_PLT32	probe_kernel_read-0x4
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    164a:	48 8b 03             	mov    (%rbx),%rax
task_rcu_dereference():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:260
	if (unlikely(task != READ_ONCE(*ptask)))
    164d:	48 39 c5             	cmp    %rax,%rbp
    1650:	75 dc                	jne    162e <task_rcu_dereference+0x1e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:289
	if (!sighand)
    1652:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
    1657:	74 17                	je     1670 <task_rcu_dereference+0x60>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:293
}
    1659:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
    165e:	65 48 33 0c 25 28 00 	xor    %gs:0x28,%rcx
    1665:	00 00 
    1667:	75 0b                	jne    1674 <task_rcu_dereference+0x64>
    1669:	48 83 c4 10          	add    $0x10,%rsp
    166d:	5b                   	pop    %rbx
    166e:	5d                   	pop    %rbp
    166f:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:290
		return NULL;
    1670:	31 c0                	xor    %eax,%eax
    1672:	eb e5                	jmp    1659 <task_rcu_dereference+0x49>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:293
}
    1674:	e8 00 00 00 00       	callq  1679 <task_rcu_dereference+0x69>
			1675: R_X86_64_PLT32	__stack_chk_fail-0x4
    1679:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001680 <rcuwait_wake_up>:
rcuwait_wake_up():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:296
{
    1680:	e8 00 00 00 00       	callq  1685 <rcuwait_wake_up+0x5>
			1681: R_X86_64_PLT32	__fentry__-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:312
	smp_mb(); /* (B) */
    1685:	f0 83 44 24 fc 00    	lock addl $0x0,-0x4(%rsp)
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    168b:	48 8b 3f             	mov    (%rdi),%rdi
rcuwait_wake_up():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:319
	if (task)
    168e:	48 85 ff             	test   %rdi,%rdi
    1691:	74 05                	je     1698 <rcuwait_wake_up+0x18>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:320
		wake_up_process(task);
    1693:	e8 00 00 00 00       	callq  1698 <rcuwait_wake_up+0x18>
			1694: R_X86_64_PLT32	wake_up_process-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:322
}
    1698:	c3                   	retq   
    1699:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000016a0 <is_current_pgrp_orphaned>:
is_current_pgrp_orphaned():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:352
{
    16a0:	e8 00 00 00 00       	callq  16a5 <is_current_pgrp_orphaned+0x5>
			16a1: R_X86_64_PLT32	__fentry__-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:355
	read_lock(&tasklist_lock);
    16a5:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			16a8: R_X86_64_32S	tasklist_lock
    16ac:	e8 00 00 00 00       	callq  16b1 <is_current_pgrp_orphaned+0x11>
			16ad: R_X86_64_PLT32	_raw_read_lock-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:356
	retval = will_become_orphaned_pgrp(task_pgrp(current), NULL);
    16b1:	31 f6                	xor    %esi,%esi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    16b3:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    16ba:	00 00 
			16b8: R_X86_64_32S	current_task
task_pgrp():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:624
	return task->signal->pids[PIDTYPE_PGID];
    16bc:	48 8b 80 d8 06 00 00 	mov    0x6d8(%rax),%rax
is_current_pgrp_orphaned():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:356
    16c3:	48 8b b8 70 01 00 00 	mov    0x170(%rax),%rdi
    16ca:	e8 41 e9 ff ff       	callq  10 <will_become_orphaned_pgrp>
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
    16cf:	ba 00 fe ff ff       	mov    $0xfffffe00,%edx
    16d4:	f0 0f c1 15 00 00 00 	lock xadd %edx,0x0(%rip)        # 16dc <is_current_pgrp_orphaned+0x3c>
    16db:	00 
			16d8: R_X86_64_PC32	tasklist_lock-0x4
is_current_pgrp_orphaned():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:360
}
    16dc:	c3                   	retq   
    16dd:	0f 1f 00             	nopl   (%rax)

00000000000016e0 <mm_update_next_owner>:
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:410
{
    16e0:	e8 00 00 00 00       	callq  16e5 <mm_update_next_owner+0x5>
			16e1: R_X86_64_PLT32	__fentry__-0x4
    16e5:	41 57                	push   %r15
    16e7:	41 56                	push   %r14
    16e9:	41 55                	push   %r13
    16eb:	41 54                	push   %r12
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    16ed:	65 4c 8b 24 25 00 00 	mov    %gs:0x0,%r12
    16f4:	00 00 
			16f2: R_X86_64_32S	current_task
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:410
    16f6:	55                   	push   %rbp
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:434
	list_for_each_entry(c, &p->children, sibling) {
    16f7:	4d 8d ac 24 f0 04 00 	lea    0x4f0(%r12),%r13
    16fe:	00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:410
{
    16ff:	53                   	push   %rbx
    1700:	48 89 fb             	mov    %rdi,%rbx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:418
	if (mm->owner != p)
    1703:	4c 39 a3 90 03 00 00 	cmp    %r12,0x390(%rbx)
    170a:	0f 85 92 01 00 00    	jne    18a2 <mm_update_next_owner+0x1c2>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1710:	8b 43 58             	mov    0x58(%rbx),%eax
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:425
	if (atomic_read(&mm->mm_users) <= 1) {
    1713:	83 f8 01             	cmp    $0x1,%eax
    1716:	0f 8e 7b 01 00 00    	jle    1897 <mm_update_next_owner+0x1b7>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:430
	read_lock(&tasklist_lock);
    171c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			171f: R_X86_64_32S	tasklist_lock
    1723:	e8 00 00 00 00       	callq  1728 <mm_update_next_owner+0x48>
			1724: R_X86_64_PLT32	_raw_read_lock-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:434
	list_for_each_entry(c, &p->children, sibling) {
    1728:	49 8b 84 24 f0 04 00 	mov    0x4f0(%r12),%rax
    172f:	00 
    1730:	48 8d a8 00 fb ff ff 	lea    -0x500(%rax),%rbp
    1737:	49 39 c5             	cmp    %rax,%r13
    173a:	75 18                	jne    1754 <mm_update_next_owner+0x74>
    173c:	e9 81 00 00 00       	jmpq   17c2 <mm_update_next_owner+0xe2>
    1741:	48 8b 85 00 05 00 00 	mov    0x500(%rbp),%rax
    1748:	48 8d a8 00 fb ff ff 	lea    -0x500(%rax),%rbp
    174f:	49 39 c5             	cmp    %rax,%r13
    1752:	74 6e                	je     17c2 <mm_update_next_owner+0xe2>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:435
		if (c->mm == mm)
    1754:	48 39 9d 20 04 00 00 	cmp    %rbx,0x420(%rbp)
    175b:	75 e4                	jne    1741 <mm_update_next_owner+0x61>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:470
	BUG_ON(c == p);
    175d:	4c 39 e5             	cmp    %r12,%rbp
    1760:	0f 84 22 01 00 00    	je     1888 <mm_update_next_owner+0x1a8>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:471 (discriminator 2)
	get_task_struct(c);
    1766:	4c 8d 7d 20          	lea    0x20(%rbp),%r15
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338 (discriminator 2)
    176a:	4c 8d b5 60 07 00 00 	lea    0x760(%rbp),%r14
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:471 (discriminator 2)
    1771:	4c 89 ff             	mov    %r15,%rdi
    1774:	e8 00 00 00 00       	callq  1779 <mm_update_next_owner+0x99>
			1775: R_X86_64_PLT32	refcount_inc_checked-0x4
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338 (discriminator 2)
    1779:	4c 89 f7             	mov    %r14,%rdi
    177c:	e8 00 00 00 00       	callq  1781 <mm_update_next_owner+0xa1>
			177d: R_X86_64_PLT32	_raw_spin_lock-0x4
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167 (discriminator 2)
    1781:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
    1786:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # 178e <mm_update_next_owner+0xae>
    178d:	00 
			178a: R_X86_64_PC32	tasklist_lock-0x4
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:482 (discriminator 2)
	if (c->mm != mm) {
    178e:	48 39 9d 20 04 00 00 	cmp    %rbx,0x420(%rbp)
    1795:	0f 84 12 01 00 00    	je     18ad <mm_update_next_owner+0x1cd>
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
    179b:	4c 89 f7             	mov    %r14,%rdi
    179e:	ff 14 25 00 00 00 00 	callq  *0x0
			17a1: R_X86_64_32S	pv_ops+0x2a8
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114
	if (refcount_dec_and_test(&t->usage))
    17a5:	4c 89 ff             	mov    %r15,%rdi
    17a8:	e8 00 00 00 00       	callq  17ad <mm_update_next_owner+0xcd>
			17a9: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
    17ad:	84 c0                	test   %al,%al
    17af:	0f 84 4e ff ff ff    	je     1703 <mm_update_next_owner+0x23>
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
		__put_task_struct(t);
    17b5:	48 89 ef             	mov    %rbp,%rdi
    17b8:	e8 00 00 00 00       	callq  17bd <mm_update_next_owner+0xdd>
			17b9: R_X86_64_PLT32	__put_task_struct-0x4
    17bd:	e9 41 ff ff ff       	jmpq   1703 <mm_update_next_owner+0x23>
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:442
	list_for_each_entry(c, &p->real_parent->children, sibling) {
    17c2:	49 8b 94 24 e0 04 00 	mov    0x4e0(%r12),%rdx
    17c9:	00 
    17ca:	48 8b 82 f0 04 00 00 	mov    0x4f0(%rdx),%rax
    17d1:	48 81 c2 f0 04 00 00 	add    $0x4f0,%rdx
    17d8:	48 8d a8 00 fb ff ff 	lea    -0x500(%rax),%rbp
    17df:	48 39 c2             	cmp    %rax,%rdx
    17e2:	75 15                	jne    17f9 <mm_update_next_owner+0x119>
    17e4:	eb 21                	jmp    1807 <mm_update_next_owner+0x127>
    17e6:	48 8b 85 00 05 00 00 	mov    0x500(%rbp),%rax
    17ed:	48 8d a8 00 fb ff ff 	lea    -0x500(%rax),%rbp
    17f4:	48 39 c2             	cmp    %rax,%rdx
    17f7:	74 0e                	je     1807 <mm_update_next_owner+0x127>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:443
		if (c->mm == mm)
    17f9:	48 39 9d 20 04 00 00 	cmp    %rbx,0x420(%rbp)
    1800:	75 e4                	jne    17e6 <mm_update_next_owner+0x106>
    1802:	e9 56 ff ff ff       	jmpq   175d <mm_update_next_owner+0x7d>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1807:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 180e <mm_update_next_owner+0x12e>
			180a: R_X86_64_PC32	init_task+0x3cc
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:450
	for_each_process(g) {
    180e:	48 8d 88 30 fc ff ff 	lea    -0x3d0(%rax),%rcx
    1815:	48 3d 00 00 00 00    	cmp    $0x0,%rax
			1817: R_X86_64_32S	init_task+0x3d0
    181b:	75 18                	jne    1835 <mm_update_next_owner+0x155>
    181d:	eb 6b                	jmp    188a <mm_update_next_owner+0x1aa>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199 (discriminator 2)
    181f:	48 8b 81 d0 03 00 00 	mov    0x3d0(%rcx),%rax
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:450 (discriminator 2)
    1826:	48 8d 88 30 fc ff ff 	lea    -0x3d0(%rax),%rcx
    182d:	48 3d 00 00 00 00    	cmp    $0x0,%rax
			182f: R_X86_64_32S	init_task+0x3d0
    1833:	74 55                	je     188a <mm_update_next_owner+0x1aa>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:451
		if (g->flags & PF_KTHREAD)
    1835:	f6 80 56 fc ff ff 20 	testb  $0x20,-0x3aa(%rax)
    183c:	75 e1                	jne    181f <mm_update_next_owner+0x13f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:453 (discriminator 1)
		for_each_thread(g, c) {
    183e:	48 8b 90 08 03 00 00 	mov    0x308(%rax),%rdx
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199 (discriminator 1)
    1845:	48 8b 42 10          	mov    0x10(%rdx),%rax
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:453 (discriminator 1)
    1849:	48 83 c2 10          	add    $0x10,%rdx
    184d:	48 8d a8 70 fa ff ff 	lea    -0x590(%rax),%rbp
    1854:	48 39 c2             	cmp    %rax,%rdx
    1857:	75 1a                	jne    1873 <mm_update_next_owner+0x193>
    1859:	eb c4                	jmp    181f <mm_update_next_owner+0x13f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:456
			if (c->mm)
    185b:	48 85 c0             	test   %rax,%rax
    185e:	75 bf                	jne    181f <mm_update_next_owner+0x13f>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199 (discriminator 9)
    1860:	48 8b 85 90 05 00 00 	mov    0x590(%rbp),%rax
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:453 (discriminator 9)
		for_each_thread(g, c) {
    1867:	48 8d a8 70 fa ff ff 	lea    -0x590(%rax),%rbp
    186e:	48 39 c2             	cmp    %rax,%rdx
    1871:	74 ac                	je     181f <mm_update_next_owner+0x13f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:454
			if (c->mm == mm)
    1873:	48 8b 85 20 04 00 00 	mov    0x420(%rbp),%rax
    187a:	48 39 d8             	cmp    %rbx,%rax
    187d:	75 dc                	jne    185b <mm_update_next_owner+0x17b>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:470
	BUG_ON(c == p);
    187f:	4c 39 e5             	cmp    %r12,%rbp
    1882:	0f 85 de fe ff ff    	jne    1766 <mm_update_next_owner+0x86>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:470 (discriminator 1)
    1888:	0f 0b                	ud2    
arch_atomic_add_return():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:167
    188a:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
    188f:	f0 0f c1 05 00 00 00 	lock xadd %eax,0x0(%rip)        # 1897 <mm_update_next_owner+0x1b7>
    1896:	00 
			1893: R_X86_64_PC32	tasklist_lock-0x4
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
    1897:	48 c7 83 90 03 00 00 	movq   $0x0,0x390(%rbx)
    189e:	00 00 00 00 
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:490
}
    18a2:	5b                   	pop    %rbx
    18a3:	5d                   	pop    %rbp
    18a4:	41 5c                	pop    %r12
    18a6:	41 5d                	pop    %r13
    18a8:	41 5e                	pop    %r14
    18aa:	41 5f                	pop    %r15
    18ac:	c3                   	retq   
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
    18ad:	48 89 ab 90 03 00 00 	mov    %rbp,0x390(%rbx)
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
    18b4:	4c 89 f7             	mov    %r14,%rdi
    18b7:	ff 14 25 00 00 00 00 	callq  *0x0
			18ba: R_X86_64_32S	pv_ops+0x2a8
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:114
	if (refcount_dec_and_test(&t->usage))
    18be:	4c 89 ff             	mov    %r15,%rdi
    18c1:	e8 00 00 00 00       	callq  18c6 <mm_update_next_owner+0x1e6>
			18c2: R_X86_64_PLT32	refcount_dec_and_test_checked-0x4
    18c6:	84 c0                	test   %al,%al
    18c8:	74 d8                	je     18a2 <mm_update_next_owner+0x1c2>
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:490
    18ca:	5b                   	pop    %rbx
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
		__put_task_struct(t);
    18cb:	48 89 ef             	mov    %rbp,%rdi
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:490
    18ce:	5d                   	pop    %rbp
    18cf:	41 5c                	pop    %r12
    18d1:	41 5d                	pop    %r13
    18d3:	41 5e                	pop    %r14
    18d5:	41 5f                	pop    %r15
put_task_struct():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
    18d7:	e9 00 00 00 00       	jmpq   18dc <mm_update_next_owner+0x1fc>
			18d8: R_X86_64_PLT32	__put_task_struct-0x4
mm_update_next_owner():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/task.h:115
    18dc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000018e0 <do_exit>:
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:778
{
    18e0:	e8 00 00 00 00       	callq  18e5 <do_exit+0x5>
			18e1: R_X86_64_PLT32	__fentry__-0x4
    18e5:	41 57                	push   %r15
    18e7:	41 56                	push   %r14
    18e9:	41 55                	push   %r13
    18eb:	41 54                	push   %r12
    18ed:	55                   	push   %rbp
    18ee:	48 89 fd             	mov    %rdi,%rbp
    18f1:	53                   	push   %rbx
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    18f2:	65 48 8b 1c 25 00 00 	mov    %gs:0x0,%rbx
    18f9:	00 00 
			18f7: R_X86_64_32S	current_task
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:782
	profile_task_exit(tsk);
    18fb:	48 89 df             	mov    %rbx,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:778
{
    18fe:	48 83 ec 40          	sub    $0x40,%rsp
    1902:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    1909:	00 00 
    190b:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
    1910:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:782
	profile_task_exit(tsk);
    1912:	e8 00 00 00 00       	callq  1917 <do_exit+0x37>
			1913: R_X86_64_PLT32	profile_task_exit-0x4
blk_needs_flush_plug():
/home/jeffrin/UP/linux-stable-rc/./include/linux/blkdev.h:1185
		blk_flush_plug_list(plug, true);
}

static inline bool blk_needs_flush_plug(struct task_struct *tsk)
{
	struct blk_plug *plug = tsk->plug;
    1917:	48 8b 83 a0 07 00 00 	mov    0x7a0(%rbx),%rax
/home/jeffrin/UP/linux-stable-rc/./include/linux/blkdev.h:1187

	return plug &&
    191e:	48 85 c0             	test   %rax,%rax
    1921:	74 1d                	je     1940 <do_exit+0x60>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
    1923:	48 8b 10             	mov    (%rax),%rdx
blk_needs_flush_plug():
/home/jeffrin/UP/linux-stable-rc/./include/linux/blkdev.h:1187
    1926:	48 39 d0             	cmp    %rdx,%rax
    1929:	0f 85 00 00 00 00    	jne    192f <do_exit+0x4f>
			192b: R_X86_64_PC32	.text.unlikely+0x1d
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    192f:	48 8b 50 10          	mov    0x10(%rax),%rdx
blk_needs_flush_plug():
/home/jeffrin/UP/linux-stable-rc/./include/linux/blkdev.h:1189
		 (!list_empty(&plug->mq_list) ||
		 !list_empty(&plug->cb_list));
    1933:	48 83 c0 10          	add    $0x10,%rax
/home/jeffrin/UP/linux-stable-rc/./include/linux/blkdev.h:1188
		 (!list_empty(&plug->mq_list) ||
    1937:	48 39 d0             	cmp    %rdx,%rax
    193a:	0f 85 00 00 00 00    	jne    1940 <do_exit+0x60>
			193c: R_X86_64_PC32	.text.unlikely+0x1d
preempt_count():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:26 (discriminator 3)
 * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
 * that think a non-zero value indicates we cannot preempt.
 */
static __always_inline int preempt_count(void)
{
	return raw_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
    1940:	65 44 8b 2d 00 00 00 	mov    %gs:0x0(%rip),%r13d        # 1948 <do_exit+0x68>
    1947:	00 
			1944: R_X86_64_PC32	__preempt_count-0x4
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:787 (discriminator 3)
	if (unlikely(in_interrupt()))
    1948:	41 81 e5 00 ff 1f 00 	and    $0x1fff00,%r13d
    194f:	44 89 6c 24 0c       	mov    %r13d,0xc(%rsp)
    1954:	0f 85 00 00 00 00    	jne    195a <do_exit+0x7a>
			1956: R_X86_64_PC32	.text.unlikely+0x44
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:789
	if (unlikely(!tsk->pid))
    195a:	8b 83 d0 04 00 00    	mov    0x4d0(%rbx),%eax
    1960:	85 c0                	test   %eax,%eax
    1962:	0f 84 00 00 00 00    	je     1968 <do_exit+0x88>
			1964: R_X86_64_PC32	.text.unlikely+0x38
set_fs():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:31
	current->thread.addr_limit = fs;
    1968:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffff000,%rcx
    196f:	7f 00 00 
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1972:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    1979:	00 00 
			1977: R_X86_64_32S	current_task
set_fs():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/uaccess.h:31
    197b:	48 89 88 58 0b 00 00 	mov    %rcx,0xb58(%rax)
arch_set_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:56
		asm volatile(LOCK_PREFIX "orb %1,%0"
    1982:	f0 80 48 03 80       	lock orb $0x80,0x3(%rax)
ptrace_event():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:157
	if (unlikely(ptrace_event_enabled(current, event))) {
    1987:	f6 40 29 02          	testb  $0x2,0x29(%rax)
    198b:	0f 85 10 08 00 00    	jne    21a1 <do_exit+0x8c1>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:809
	if (unlikely(tsk->flags & PF_EXITING)) {
    1991:	f6 43 24 04          	testb  $0x4,0x24(%rbx)
    1995:	0f 85 00 00 00 00    	jne    199b <do_exit+0xbb>
			1997: R_X86_64_PC32	.text.unlikely+0x94
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:825
	exit_signals(tsk);  /* sets PF_EXITING */
    199b:	48 89 df             	mov    %rbx,%rdi
    199e:	e8 00 00 00 00       	callq  19a3 <do_exit+0xc3>
			199f: R_X86_64_PLT32	exit_signals-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:830
	smp_mb();
    19a3:	f0 83 44 24 fc 00    	lock addl $0x0,-0x4(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:835
	raw_spin_lock_irq(&tsk->pi_lock);
    19a9:	4c 8d a3 64 07 00 00 	lea    0x764(%rbx),%r12
    19b0:	4c 89 e7             	mov    %r12,%rdi
    19b3:	e8 00 00 00 00       	callq  19b8 <do_exit+0xd8>
			19b4: R_X86_64_PLT32	_raw_spin_lock_irq-0x4
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
    19b8:	4c 89 e7             	mov    %r12,%rdi
    19bb:	ff 14 25 00 00 00 00 	callq  *0x0
			19be: R_X86_64_32S	pv_ops+0x2a8
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
    19c2:	ff 14 25 00 00 00 00 	callq  *0x0
			19c5: R_X86_64_32S	pv_ops+0x140
preempt_count():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:26
    19c9:	65 8b 0d 00 00 00 00 	mov    %gs:0x0(%rip),%ecx        # 19d0 <do_exit+0xf0>
			19cc: R_X86_64_PC32	__preempt_count-0x4
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:838
	if (unlikely(in_atomic())) {
    19d0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
    19d6:	0f 85 00 00 00 00    	jne    19dc <do_exit+0xfc>
			19d8: R_X86_64_PC32	.text.unlikely+0x50
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:846
	if (tsk->mm)
    19dc:	48 8b bb 20 04 00 00 	mov    0x420(%rbx),%rdi
    19e3:	48 85 ff             	test   %rdi,%rdi
    19e6:	74 05                	je     19ed <do_exit+0x10d>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:847
		sync_mm_rss(tsk->mm);
    19e8:	e8 00 00 00 00       	callq  19ed <do_exit+0x10d>
			19e9: R_X86_64_PLT32	sync_mm_rss-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:848
	acct_update_integrals(tsk);
    19ed:	48 89 df             	mov    %rbx,%rdi
    19f0:	e8 00 00 00 00       	callq  19f5 <do_exit+0x115>
			19f1: R_X86_64_PLT32	acct_update_integrals-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:849
	group_dead = atomic_dec_and_test(&tsk->signal->live);
    19f5:	48 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%rax
arch_atomic_dec_and_test():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:125
	return GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, e);
    19fc:	f0 ff 48 04          	lock decl 0x4(%rax)
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:849
    1a00:	41 0f 94 c4          	sete   %r12b
arch_atomic_dec_and_test():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:125
    1a04:	41 0f 94 c6          	sete   %r14b
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:849
    1a08:	45 0f b6 e4          	movzbl %r12b,%r12d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:850
	if (group_dead) {
    1a0c:	45 84 f6             	test   %r14b,%r14b
    1a0f:	0f 85 00 06 00 00    	jne    2015 <do_exit+0x735>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:858
	acct_collect(code, group_dead);
    1a15:	31 f6                	xor    %esi,%esi
    1a17:	48 89 ef             	mov    %rbp,%rdi
    1a1a:	e8 00 00 00 00       	callq  1a1f <do_exit+0x13f>
			1a1b: R_X86_64_PLT32	acct_collect-0x4
audit_free():
/home/jeffrin/UP/linux-stable-rc/./include/linux/audit.h:299
	void *p = audit_context();
	return !p || *(int *)p;
}
static inline void audit_free(struct task_struct *task)
{
	if (unlikely(task->audit_context))
    1a1f:	48 83 bb 38 07 00 00 	cmpq   $0x0,0x738(%rbx)
    1a26:	00 
    1a27:	0f 85 8a 07 00 00    	jne    21b7 <do_exit+0x8d7>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:863
	tsk->exit_code = code;
    1a2d:	89 ab 70 04 00 00    	mov    %ebp,0x470(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:864
	taskstats_exit(tsk, group_dead);
    1a33:	44 89 e6             	mov    %r12d,%esi
    1a36:	48 89 df             	mov    %rbx,%rdi
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1a39:	65 4c 8b 24 25 00 00 	mov    %gs:0x0,%r12
    1a40:	00 00 
			1a3e: R_X86_64_32S	current_task
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:864
    1a42:	e8 00 00 00 00       	callq  1a47 <do_exit+0x167>
			1a43: R_X86_64_PLT32	taskstats_exit-0x4
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:499
	struct mm_struct *mm = current->mm;
    1a47:	49 8b ac 24 20 04 00 	mov    0x420(%r12),%rbp
    1a4e:	00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:502
	mm_release(current, mm);
    1a4f:	4c 89 e7             	mov    %r12,%rdi
    1a52:	48 89 ee             	mov    %rbp,%rsi
    1a55:	e8 00 00 00 00       	callq  1a5a <do_exit+0x17a>
			1a56: R_X86_64_PLT32	mm_release-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:503
	if (!mm)
    1a5a:	48 85 ed             	test   %rbp,%rbp
    1a5d:	0f 84 2e 01 00 00    	je     1b91 <do_exit+0x2b1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:505
	sync_mm_rss(mm);
    1a63:	48 89 ef             	mov    %rbp,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:513
	down_read(&mm->mmap_sem);
    1a66:	4c 8d 7d 70          	lea    0x70(%rbp),%r15
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:505
	sync_mm_rss(mm);
    1a6a:	e8 00 00 00 00       	callq  1a6f <do_exit+0x18f>
			1a6b: R_X86_64_PLT32	sync_mm_rss-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:513
	down_read(&mm->mmap_sem);
    1a6f:	4c 89 ff             	mov    %r15,%rdi
    1a72:	e8 00 00 00 00       	callq  1a77 <do_exit+0x197>
			1a73: R_X86_64_PLT32	down_read-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:514
	core_state = mm->core_state;
    1a77:	4c 8b ad 78 03 00 00 	mov    0x378(%rbp),%r13
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:515
	if (core_state) {
    1a7e:	4d 85 ed             	test   %r13,%r13
    1a81:	0f 84 97 00 00 00    	je     1b1e <do_exit+0x23e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:518
		up_read(&mm->mmap_sem);
    1a87:	4c 89 ff             	mov    %r15,%rdi
    1a8a:	e8 00 00 00 00       	callq  1a8f <do_exit+0x1af>
			1a8b: R_X86_64_PLT32	up_read-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:520
		self.task = current;
    1a8f:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:521
		self.next = xchg(&core_state->dumper.next, &self);
    1a94:	48 8d 54 24 28       	lea    0x28(%rsp),%rdx
    1a99:	49 87 55 10          	xchg   %rdx,0x10(%r13)
    1a9d:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
arch_atomic_dec_and_test():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:125
    1aa2:	f0 41 ff 4d 00       	lock decl 0x0(%r13)
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:526
		if (atomic_dec_and_test(&core_state->nr_threads))
    1aa7:	0f 84 d3 06 00 00    	je     2180 <do_exit+0x8a0>
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1aad:	65 4c 8b 24 25 00 00 	mov    %gs:0x0,%r12
    1ab4:	00 00 
			1ab2: R_X86_64_32S	current_task
    1ab6:	eb 30                	jmp    1ae8 <do_exit+0x208>
freezer_do_not_count():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:109
 * until freezer_cont() is called.  Usually, freezer[_do_not]_count() pair
 * wrap a scheduling operation and nothing much else.
 */
static inline void freezer_do_not_count(void)
{
	current->flags |= PF_FREEZER_SKIP;
    1ab8:	41 81 4c 24 24 00 00 	orl    $0x40000000,0x24(%r12)
    1abf:	00 40 
freezable_schedule():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:172

/* Like schedule(), but should not block the freezer. */
static inline void freezable_schedule(void)
{
	freezer_do_not_count();
	schedule();
    1ac1:	e8 00 00 00 00       	callq  1ac6 <do_exit+0x1e6>
			1ac2: R_X86_64_PLT32	schedule-0x4
freezer_count():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:121
	current->flags &= ~PF_FREEZER_SKIP;
    1ac6:	41 81 64 24 24 ff ff 	andl   $0xbfffffff,0x24(%r12)
    1acd:	ff bf 
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:127
	smp_mb();
    1acf:	f0 83 44 24 fc 00    	lock addl $0x0,-0x4(%rsp)
try_to_freeze_unsafe():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:57
	might_sleep();
    1ad5:	e8 00 00 00 00       	callq  1ada <do_exit+0x1fa>
			1ad6: R_X86_64_PLT32	_cond_resched-0x4
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1ada:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 1ae0 <do_exit+0x200>
			1adc: R_X86_64_PC32	system_freezing_cnt-0x4
freezing():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:37
	if (likely(!atomic_read(&system_freezing_cnt)))
    1ae0:	85 c0                	test   %eax,%eax
    1ae2:	0f 85 e3 05 00 00    	jne    20cb <do_exit+0x7eb>
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:530
			set_current_state(TASK_UNINTERRUPTIBLE);
    1ae8:	48 c7 44 24 20 02 00 	movq   $0x2,0x20(%rsp)
    1aef:	00 00 
    1af1:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    1af6:	49 87 44 24 10       	xchg   %rax,0x10(%r12)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:531
			if (!self.task) /* see coredump_finish() */
    1afb:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:530
			set_current_state(TASK_UNINTERRUPTIBLE);
    1b01:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
    1b06:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:531
			if (!self.task) /* see coredump_finish() */
    1b0b:	75 ab                	jne    1ab8 <do_exit+0x1d8>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:535
		__set_current_state(TASK_RUNNING);
    1b0d:	49 c7 44 24 10 00 00 	movq   $0x0,0x10(%r12)
    1b14:	00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:536
		down_read(&mm->mmap_sem);
    1b16:	4c 89 ff             	mov    %r15,%rdi
    1b19:	e8 00 00 00 00       	callq  1b1e <do_exit+0x23e>
			1b1a: R_X86_64_PLT32	down_read-0x4
arch_atomic_inc():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:97
	asm volatile(LOCK_PREFIX "incl %0"
    1b1e:	f0 ff 45 5c          	lock incl 0x5c(%rbp)
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1b22:	65 4c 8b 24 25 00 00 	mov    %gs:0x0,%r12
    1b29:	00 00 
			1b27: R_X86_64_32S	current_task
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:539
	BUG_ON(mm != current->active_mm);
    1b2b:	49 3b ac 24 28 04 00 	cmp    0x428(%r12),%rbp
    1b32:	00 
    1b33:	0f 85 2d 07 00 00    	jne    2266 <do_exit+0x986>
spin_lock():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:338
    1b39:	4d 8d ac 24 60 07 00 	lea    0x760(%r12),%r13
    1b40:	00 
    1b41:	4c 89 ef             	mov    %r13,%rdi
    1b44:	e8 00 00 00 00       	callq  1b49 <do_exit+0x269>
			1b45: R_X86_64_PLT32	_raw_spin_lock-0x4
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:543
	up_read(&mm->mmap_sem);
    1b49:	4c 89 ff             	mov    %r15,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:542
	current->mm = NULL;
    1b4c:	49 c7 84 24 20 04 00 	movq   $0x0,0x420(%r12)
    1b53:	00 00 00 00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:543
	up_read(&mm->mmap_sem);
    1b58:	e8 00 00 00 00       	callq  1b5d <do_exit+0x27d>
			1b59: R_X86_64_PLT32	up_read-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:544
	enter_lazy_tlb(mm, current);
    1b5d:	48 89 ef             	mov    %rbp,%rdi
    1b60:	4c 89 e6             	mov    %r12,%rsi
    1b63:	e8 00 00 00 00       	callq  1b68 <do_exit+0x288>
			1b64: R_X86_64_PLT32	enter_lazy_tlb-0x4
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
    1b68:	4c 89 ef             	mov    %r13,%rdi
    1b6b:	ff 14 25 00 00 00 00 	callq  *0x0
			1b6e: R_X86_64_32S	pv_ops+0x2a8
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:546
	mm_update_next_owner(mm);
    1b72:	48 89 ef             	mov    %rbp,%rdi
    1b75:	e8 00 00 00 00       	callq  1b7a <do_exit+0x29a>
			1b76: R_X86_64_PLT32	mm_update_next_owner-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:547
	mmput(mm);
    1b7a:	48 89 ef             	mov    %rbp,%rdi
    1b7d:	e8 00 00 00 00       	callq  1b82 <do_exit+0x2a2>
			1b7e: R_X86_64_PLT32	mmput-0x4
constant_test_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:208
		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
    1b82:	49 8b 04 24          	mov    (%r12),%rax
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:548
	if (test_thread_flag(TIF_MEMDIE))
    1b86:	a9 00 00 10 00       	test   $0x100000,%eax
    1b8b:	0f 85 09 02 00 00    	jne    1d9a <do_exit+0x4ba>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:868
	if (group_dead)
    1b91:	45 84 f6             	test   %r14b,%r14b
    1b94:	0f 85 18 05 00 00    	jne    20b2 <do_exit+0x7d2>
arch_static_branch():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/jump_label.h:25
    1b9a:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:872
	exit_sem(tsk);
    1b9f:	48 89 df             	mov    %rbx,%rdi
    1ba2:	e8 00 00 00 00       	callq  1ba7 <do_exit+0x2c7>
			1ba3: R_X86_64_PLT32	exit_sem-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:873
	exit_shm(tsk);
    1ba7:	48 89 df             	mov    %rbx,%rdi
    1baa:	e8 00 00 00 00       	callq  1baf <do_exit+0x2cf>
			1bab: R_X86_64_PLT32	exit_shm-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:874
	exit_files(tsk);
    1baf:	48 89 df             	mov    %rbx,%rdi
    1bb2:	e8 00 00 00 00       	callq  1bb7 <do_exit+0x2d7>
			1bb3: R_X86_64_PLT32	exit_files-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:875
	exit_fs(tsk);
    1bb7:	48 89 df             	mov    %rbx,%rdi
    1bba:	e8 00 00 00 00       	callq  1bbf <do_exit+0x2df>
			1bbb: R_X86_64_PLT32	exit_fs-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:876
	if (group_dead)
    1bbf:	45 84 f6             	test   %r14b,%r14b
    1bc2:	0f 85 f4 04 00 00    	jne    20bc <do_exit+0x7dc>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:878
	exit_task_namespaces(tsk);
    1bc8:	48 89 df             	mov    %rbx,%rdi
    1bcb:	e8 00 00 00 00       	callq  1bd0 <do_exit+0x2f0>
			1bcc: R_X86_64_PLT32	exit_task_namespaces-0x4
exit_task_work():
/home/jeffrin/UP/linux-stable-rc/./include/linux/task_work.h:22
struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
void task_work_run(void);

static inline void exit_task_work(struct task_struct *task)
{
	task_work_run();
    1bd0:	e8 00 00 00 00       	callq  1bd5 <do_exit+0x2f5>
			1bd1: R_X86_64_PLT32	task_work_run-0x4
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:880
	exit_thread(tsk);
    1bd5:	48 89 df             	mov    %rbx,%rdi
    1bd8:	e8 00 00 00 00       	callq  1bdd <do_exit+0x2fd>
			1bd9: R_X86_64_PLT32	exit_thread-0x4
exit_umh():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1976

void __exit_umh(struct task_struct *tsk);

static inline void exit_umh(struct task_struct *tsk)
{
	if (unlikely(tsk->flags & PF_UMH))
    1bdd:	f6 43 27 02          	testb  $0x2,0x27(%rbx)
    1be1:	0f 85 3f 06 00 00    	jne    2226 <do_exit+0x946>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:889
	perf_event_exit_task(tsk);
    1be7:	48 89 df             	mov    %rbx,%rdi
    1bea:	e8 00 00 00 00       	callq  1bef <do_exit+0x30f>
			1beb: R_X86_64_PLT32	perf_event_exit_task-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:891
	sched_autogroup_exit_task(tsk);
    1bef:	48 89 df             	mov    %rbx,%rdi
    1bf2:	e8 00 00 00 00       	callq  1bf7 <do_exit+0x317>
			1bf3: R_X86_64_PLT32	sched_autogroup_exit_task-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:892
	cgroup_exit(tsk);
    1bf7:	48 89 df             	mov    %rbx,%rdi
    1bfa:	e8 00 00 00 00       	callq  1bff <do_exit+0x31f>
			1bfb: R_X86_64_PLT32	cgroup_exit-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:897
	flush_ptrace_hw_breakpoint(tsk);
    1bff:	48 89 df             	mov    %rbx,%rdi
    1c02:	e8 00 00 00 00       	callq  1c07 <do_exit+0x327>
			1c03: R_X86_64_PLT32	flush_ptrace_hw_breakpoint-0x4
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:717
	write_lock_irq(&tasklist_lock);
    1c07:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			1c0a: R_X86_64_32S	tasklist_lock
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:715
	LIST_HEAD(dead);
    1c0e:	4c 8d 7c 24 28       	lea    0x28(%rsp),%r15
    1c13:	4c 89 7c 24 28       	mov    %r15,0x28(%rsp)
    1c18:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:717
	write_lock_irq(&tasklist_lock);
    1c1d:	e8 00 00 00 00       	callq  1c22 <do_exit+0x342>
			1c1e: R_X86_64_PLT32	_raw_write_lock_irq-0x4
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1c22:	48 8b 83 18 05 00 00 	mov    0x518(%rbx),%rax
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:677
	if (unlikely(!list_empty(&father->ptraced)))
    1c29:	48 8d 93 18 05 00 00 	lea    0x518(%rbx),%rdx
    1c30:	48 39 c2             	cmp    %rax,%rdx
    1c33:	0f 85 dd 05 00 00    	jne    2216 <do_exit+0x936>
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:568
	struct pid_namespace *pid_ns = task_active_pid_ns(father);
    1c39:	48 89 df             	mov    %rbx,%rdi
    1c3c:	e8 00 00 00 00       	callq  1c41 <do_exit+0x361>
			1c3d: R_X86_64_PLT32	task_active_pid_ns-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:569
	struct task_struct *reaper = pid_ns->child_reaper;
    1c41:	4c 8b 60 38          	mov    0x38(%rax),%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:568
	struct pid_namespace *pid_ns = task_active_pid_ns(father);
    1c45:	48 89 c5             	mov    %rax,%rbp
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:572
	if (likely(reaper != father))
    1c48:	4c 39 e3             	cmp    %r12,%rbx
    1c4b:	0f 84 73 05 00 00    	je     21c4 <do_exit+0x8e4>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1c51:	48 8b 83 f0 04 00 00 	mov    0x4f0(%rbx),%rax
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:682
	if (list_empty(&father->children))
    1c58:	4c 8d ab f0 04 00 00 	lea    0x4f0(%rbx),%r13
    1c5f:	49 39 c5             	cmp    %rax,%r13
    1c62:	0f 84 ea 01 00 00    	je     1e52 <do_exit+0x572>
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
	for_each_thread(p, t) {
    1c68:	48 8b b3 d8 06 00 00 	mov    0x6d8(%rbx),%rsi
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1c6f:	48 8b 56 10          	mov    0x10(%rsi),%rdx
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
    1c73:	48 8d 4e 10          	lea    0x10(%rsi),%rcx
    1c77:	48 8d 82 70 fa ff ff 	lea    -0x590(%rdx),%rax
    1c7e:	48 39 d1             	cmp    %rdx,%rcx
    1c81:	75 1c                	jne    1c9f <do_exit+0x3bf>
    1c83:	e9 5f 04 00 00       	jmpq   20e7 <do_exit+0x807>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1c88:	48 8b 90 90 05 00 00 	mov    0x590(%rax),%rdx
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
    1c8f:	48 8d 82 70 fa ff ff 	lea    -0x590(%rdx),%rax
    1c96:	48 39 d1             	cmp    %rdx,%rcx
    1c99:	0f 84 48 04 00 00    	je     20e7 <do_exit+0x807>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:557
		if (!(t->flags & PF_EXITING))
    1c9f:	f6 40 24 04          	testb  $0x4,0x24(%rax)
    1ca3:	75 e3                	jne    1c88 <do_exit+0x3a8>
find_new_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:611
	if (thread)
    1ca5:	48 85 c0             	test   %rax,%rax
    1ca8:	0f 84 39 04 00 00    	je     20e7 <do_exit+0x807>
    1cae:	49 89 c4             	mov    %rax,%r12
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:686
	list_for_each_entry(p, &father->children, sibling) {
    1cb1:	48 8b 83 f0 04 00 00 	mov    0x4f0(%rbx),%rax
    1cb8:	4c 8d 88 00 fb ff ff 	lea    -0x500(%rax),%r9
    1cbf:	49 39 c5             	cmp    %rax,%r13
    1cc2:	0f 84 40 01 00 00    	je     1e08 <do_exit+0x528>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:687
		for_each_thread(p, t) {
    1cc8:	49 8b 81 d8 06 00 00 	mov    0x6d8(%r9),%rax
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1ccf:	48 8b 50 10          	mov    0x10(%rax),%rdx
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:687
    1cd3:	48 83 c0 10          	add    $0x10,%rax
    1cd7:	48 8d aa 70 fa ff ff 	lea    -0x590(%rdx),%rbp
    1cde:	48 39 c2             	cmp    %rax,%rdx
    1ce1:	75 27                	jne    1d0a <do_exit+0x42a>
    1ce3:	e9 be 00 00 00       	jmpq   1da6 <do_exit+0x4c6>
    1ce8:	49 8b 81 d8 06 00 00 	mov    0x6d8(%r9),%rax
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1cef:	48 8b 95 90 05 00 00 	mov    0x590(%rbp),%rdx
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:687
    1cf6:	48 83 c0 10          	add    $0x10,%rax
    1cfa:	48 8d aa 70 fa ff ff 	lea    -0x590(%rdx),%rbp
    1d01:	48 39 c2             	cmp    %rax,%rdx
    1d04:	0f 84 9c 00 00 00    	je     1da6 <do_exit+0x4c6>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:689
			BUG_ON((!t->ptrace) != (t->parent == father));
    1d0a:	8b 45 28             	mov    0x28(%rbp),%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:688
			t->real_parent = reaper;
    1d0d:	4c 89 a5 e0 04 00 00 	mov    %r12,0x4e0(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:689
			BUG_ON((!t->ptrace) != (t->parent == father));
    1d14:	85 c0                	test   %eax,%eax
    1d16:	0f 94 c1             	sete   %cl
    1d19:	48 39 9d e8 04 00 00 	cmp    %rbx,0x4e8(%rbp)
    1d20:	0f 94 c2             	sete   %dl
    1d23:	38 d1                	cmp    %dl,%cl
    1d25:	75 7d                	jne    1da4 <do_exit+0x4c4>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:690
			if (likely(!t->ptrace))
    1d27:	85 c0                	test   %eax,%eax
    1d29:	75 07                	jne    1d32 <do_exit+0x452>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:691
				t->parent = t->real_parent;
    1d2b:	4c 89 a5 e8 04 00 00 	mov    %r12,0x4e8(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:692
			if (t->pdeath_signal)
    1d32:	8b bd 78 04 00 00    	mov    0x478(%rbp),%edi
    1d38:	85 ff                	test   %edi,%edi
    1d3a:	74 ac                	je     1ce8 <do_exit+0x408>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:693
				group_send_sig_info(t->pdeath_signal,
    1d3c:	b9 01 00 00 00       	mov    $0x1,%ecx
    1d41:	48 89 ea             	mov    %rbp,%rdx
    1d44:	31 f6                	xor    %esi,%esi
    1d46:	4c 89 0c 24          	mov    %r9,(%rsp)
    1d4a:	e8 00 00 00 00       	callq  1d4f <do_exit+0x46f>
			1d4b: R_X86_64_PLT32	group_send_sig_info-0x4
    1d4f:	4c 8b 0c 24          	mov    (%rsp),%r9
    1d53:	eb 93                	jmp    1ce8 <do_exit+0x408>
trace_sched_process_exit():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:248
DEFINE_EVENT(sched_process_template, sched_process_exit,
    1d55:	65 8b 05 00 00 00 00 	mov    %gs:0x0(%rip),%eax        # 1d5c <do_exit+0x47c>
			1d58: R_X86_64_PC32	cpu_number-0x4
cpumask_test_cpu():
/home/jeffrin/UP/linux-stable-rc/./include/linux/cpumask.h:344
    1d5c:	89 c0                	mov    %eax,%eax
variable_test_bit():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/bitops.h:215
	asm volatile(__ASM_SIZE(bt) " %2,%1"
    1d5e:	48 0f a3 05 00 00 00 	bt     %rax,0x0(%rip)        # 1d66 <do_exit+0x486>
    1d65:	00 
			1d62: R_X86_64_PC32	__cpu_online_mask-0x4
trace_sched_process_exit():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:248
    1d66:	0f 83 33 fe ff ff    	jae    1b9f <do_exit+0x2bf>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1d6c:	48 8b 2d 00 00 00 00 	mov    0x0(%rip),%rbp        # 1d73 <do_exit+0x493>
			1d6f: R_X86_64_PC32	__tracepoint_sched_process_exit+0x24
trace_sched_process_exit():
/home/jeffrin/UP/linux-stable-rc/./include/trace/events/sched.h:248
    1d73:	48 85 ed             	test   %rbp,%rbp
    1d76:	74 1d                	je     1d95 <do_exit+0x4b5>
    1d78:	48 8b 45 00          	mov    0x0(%rbp),%rax
    1d7c:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
    1d80:	48 83 c5 18          	add    $0x18,%rbp
    1d84:	48 89 de             	mov    %rbx,%rsi
    1d87:	e8 00 00 00 00       	callq  1d8c <do_exit+0x4ac>
			1d88: R_X86_64_PLT32	__x86_indirect_thunk_rax-0x4
    1d8c:	48 8b 45 00          	mov    0x0(%rbp),%rax
    1d90:	48 85 c0             	test   %rax,%rax
    1d93:	75 e7                	jne    1d7c <do_exit+0x49c>
    1d95:	e9 05 fe ff ff       	jmpq   1b9f <do_exit+0x2bf>
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:549
		exit_oom_victim();
    1d9a:	e8 00 00 00 00       	callq  1d9f <do_exit+0x4bf>
			1d9b: R_X86_64_PLT32	exit_oom_victim-0x4
    1d9f:	e9 ed fd ff ff       	jmpq   1b91 <do_exit+0x2b1>
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:689
			BUG_ON((!t->ptrace) != (t->parent == father));
    1da4:	0f 0b                	ud2    
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:701
		if (!same_thread_group(reaper, father))
    1da6:	48 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%rax
    1dad:	49 39 84 24 d8 06 00 	cmp    %rax,0x6d8(%r12)
    1db4:	00 
    1db5:	74 3a                	je     1df1 <do_exit+0x511>
reparent_leader():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:646
	if (unlikely(p->exit_state == EXIT_DEAD))
    1db7:	41 8b 81 6c 04 00 00 	mov    0x46c(%r9),%eax
    1dbe:	83 f8 10             	cmp    $0x10,%eax
    1dc1:	74 2e                	je     1df1 <do_exit+0x511>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:650
	p->exit_signal = SIGCHLD;
    1dc3:	41 c7 81 74 04 00 00 	movl   $0x11,0x474(%r9)
    1dca:	11 00 00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:653
	if (!p->ptrace &&
    1dce:	41 83 79 28 00       	cmpl   $0x0,0x28(%r9)
    1dd3:	75 09                	jne    1dde <do_exit+0x4fe>
    1dd5:	83 f8 20             	cmp    $0x20,%eax
    1dd8:	0f 84 f7 04 00 00    	je     22d5 <do_exit+0x9f5>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:661
	kill_orphaned_pgrp(p, father);
    1dde:	4c 89 cf             	mov    %r9,%rdi
    1de1:	48 89 de             	mov    %rbx,%rsi
    1de4:	4c 89 0c 24          	mov    %r9,(%rsp)
    1de8:	e8 d3 e2 ff ff       	callq  c0 <kill_orphaned_pgrp>
    1ded:	4c 8b 0c 24          	mov    (%rsp),%r9
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:686
	list_for_each_entry(p, &father->children, sibling) {
    1df1:	49 8b 81 00 05 00 00 	mov    0x500(%r9),%rax
    1df8:	4c 8d 88 00 fb ff ff 	lea    -0x500(%rax),%r9
    1dff:	49 39 c5             	cmp    %rax,%r13
    1e02:	0f 85 c0 fe ff ff    	jne    1cc8 <do_exit+0x3e8>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    1e08:	48 8b 83 f0 04 00 00 	mov    0x4f0(%rbx),%rax
list_splice_tail_init():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:466
 * The list at @list is reinitialised
 */
static inline void list_splice_tail_init(struct list_head *list,
					 struct list_head *head)
{
	if (!list_empty(list)) {
    1e0f:	49 39 c5             	cmp    %rax,%r13
    1e12:	74 3e                	je     1e52 <do_exit+0x572>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:467
		__list_splice(list, head->prev, head);
    1e14:	49 8b 94 24 f8 04 00 	mov    0x4f8(%r12),%rdx
    1e1b:	00 
    1e1c:	48 8b 8b f0 04 00 00 	mov    0x4f0(%rbx),%rcx
    1e23:	48 8b 83 f8 04 00 00 	mov    0x4f8(%rbx),%rax
__list_splice():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:408
	first->prev = prev;
    1e2a:	48 89 51 08          	mov    %rdx,0x8(%rcx)
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:409
	prev->next = first;
    1e2e:	48 89 0a             	mov    %rcx,(%rdx)
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:704
	list_splice_tail_init(&father->children, &reaper->children);
    1e31:	49 8d 94 24 f0 04 00 	lea    0x4f0(%r12),%rdx
    1e38:	00 
    1e39:	48 89 10             	mov    %rdx,(%rax)
__list_splice():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:412
	next->prev = last;
    1e3c:	49 89 84 24 f8 04 00 	mov    %rax,0x4f8(%r12)
    1e43:	00 
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
    1e44:	4c 89 ab f0 04 00 00 	mov    %r13,0x4f0(%rbx)
INIT_LIST_HEAD():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:29
	list->prev = list;
    1e4b:	4c 89 ab f8 04 00 00 	mov    %r13,0x4f8(%rbx)
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:720
	if (group_dead)
    1e52:	45 84 f6             	test   %r14b,%r14b
    1e55:	0f 85 33 03 00 00    	jne    218e <do_exit+0x8ae>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:724
	if (unlikely(tsk->ptrace)) {
    1e5b:	83 7b 28 00          	cmpl   $0x0,0x28(%rbx)
    1e5f:	8b b3 74 04 00 00    	mov    0x474(%rbx),%esi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:723
	tsk->exit_state = EXIT_ZOMBIE;
    1e65:	c7 83 6c 04 00 00 20 	movl   $0x20,0x46c(%rbx)
    1e6c:	00 00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:724
	if (unlikely(tsk->ptrace)) {
    1e6f:	0f 85 1c 04 00 00    	jne    2291 <do_exit+0x9b1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:730
	} else if (thread_group_leader(tsk)) {
    1e75:	85 f6                	test   %esi,%esi
    1e77:	0f 88 4f 01 00 00    	js     1fcc <do_exit+0x6ec>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
    1e7d:	48 8b 83 80 05 00 00 	mov    0x580(%rbx),%rax
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
	return list_empty(&p->thread_group);
    1e84:	48 8d 93 80 05 00 00 	lea    0x580(%rbx),%rdx
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:731
		autoreap = thread_group_empty(tsk) &&
    1e8b:	48 39 c2             	cmp    %rax,%rdx
    1e8e:	0f 84 2d 04 00 00    	je     22c1 <do_exit+0x9e1>
    1e94:	44 0f b6 6c 24 0c    	movzbl 0xc(%rsp),%r13d
    1e9a:	41 83 e5 01          	and    $0x1,%r13d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:737
	if (autoreap) {
    1e9e:	45 84 ed             	test   %r13b,%r13b
    1ea1:	0f 85 25 01 00 00    	jne    1fcc <do_exit+0x6ec>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:743
	if (unlikely(tsk->signal->notify_count < 0))
    1ea7:	48 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%rax
    1eae:	83 78 64 00          	cmpl   $0x0,0x64(%rax)
    1eb2:	0f 88 ba 03 00 00    	js     2272 <do_exit+0x992>
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:223
	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
    1eb8:	c6 05 00 00 00 00 00 	movb   $0x0,0x0(%rip)        # 1ebf <do_exit+0x5df>
			1eba: R_X86_64_PC32	tasklist_lock-0x5
__raw_write_unlock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rwlock_api_smp.h:267
	local_irq_enable();
    1ebf:	e8 3c e1 ff ff       	callq  0 <arch_local_irq_enable>
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:747
	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
    1ec4:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
    1ec9:	48 8b 45 00          	mov    0x0(%rbp),%rax
    1ecd:	4c 8d a5 d8 fa ff ff 	lea    -0x528(%rbp),%r12
    1ed4:	4c 8d a8 d8 fa ff ff 	lea    -0x528(%rax),%r13
    1edb:	4c 39 fd             	cmp    %r15,%rbp
    1ede:	75 05                	jne    1ee5 <do_exit+0x605>
    1ee0:	eb 5a                	jmp    1f3c <do_exit+0x65c>
    1ee2:	49 89 c5             	mov    %rax,%r13
__list_del_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:131
	if (!__list_del_entry_valid(entry))
    1ee5:	48 89 ef             	mov    %rbp,%rdi
    1ee8:	e8 00 00 00 00       	callq  1eed <do_exit+0x60d>
			1ee9: R_X86_64_PLT32	__list_del_entry_valid-0x4
    1eed:	84 c0                	test   %al,%al
    1eef:	74 17                	je     1f08 <do_exit+0x628>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:134
	__list_del(entry->prev, entry->next);
    1ef1:	49 8b 94 24 28 05 00 	mov    0x528(%r12),%rdx
    1ef8:	00 
    1ef9:	49 8b 84 24 30 05 00 	mov    0x530(%r12),%rax
    1f00:	00 
__list_del():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:105
	next->prev = prev;
    1f01:	48 89 42 08          	mov    %rax,0x8(%rdx)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
    1f05:	48 89 10             	mov    %rdx,(%rax)
    1f08:	49 89 ac 24 28 05 00 	mov    %rbp,0x528(%r12)
    1f0f:	00 
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:749
		release_task(p);
    1f10:	4c 89 e7             	mov    %r12,%rdi
INIT_LIST_HEAD():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:29
	list->prev = list;
    1f13:	49 89 ac 24 30 05 00 	mov    %rbp,0x530(%r12)
    1f1a:	00 
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:747
	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
    1f1b:	49 8d ad 28 05 00 00 	lea    0x528(%r13),%rbp
    1f22:	4d 89 ec             	mov    %r13,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:749
		release_task(p);
    1f25:	e8 00 00 00 00       	callq  1f2a <do_exit+0x64a>
			1f26: R_X86_64_PLT32	release_task-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:747
	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
    1f2a:	49 8b 85 28 05 00 00 	mov    0x528(%r13),%rax
    1f31:	48 2d 28 05 00 00    	sub    $0x528,%rax
    1f37:	4c 39 fd             	cmp    %r15,%rbp
    1f3a:	75 a6                	jne    1ee2 <do_exit+0x602>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:901
	proc_exit_connector(tsk);
    1f3c:	48 89 df             	mov    %rbx,%rdi
    1f3f:	e8 00 00 00 00       	callq  1f44 <do_exit+0x664>
			1f40: R_X86_64_PLT32	proc_exit_connector-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:902
	mpol_put_task_policy(tsk);
    1f44:	48 89 df             	mov    %rbx,%rdi
    1f47:	e8 00 00 00 00       	callq  1f4c <do_exit+0x66c>
			1f48: R_X86_64_PLT32	mpol_put_task_policy-0x4
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    1f4c:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    1f53:	00 00 
			1f51: R_X86_64_32S	current_task
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:904
	if (unlikely(current->pi_state_cache))
    1f55:	48 83 b8 80 08 00 00 	cmpq   $0x0,0x880(%rax)
    1f5c:	00 
    1f5d:	0f 85 1d 03 00 00    	jne    2280 <do_exit+0x9a0>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:916
	tsk->flags |= PF_EXITPIDONE;
    1f63:	83 4b 24 08          	orl    $0x8,0x24(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:918
	if (tsk->io_context)
    1f67:	48 83 bb b8 07 00 00 	cmpq   $0x0,0x7b8(%rbx)
    1f6e:	00 
    1f6f:	74 08                	je     1f79 <do_exit+0x699>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:919
		exit_io_context(tsk);
    1f71:	48 89 df             	mov    %rbx,%rdi
    1f74:	e8 00 00 00 00       	callq  1f79 <do_exit+0x699>
			1f75: R_X86_64_PLT32	exit_io_context-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:921
	if (tsk->splice_pipe)
    1f79:	48 8b bb c0 09 00 00 	mov    0x9c0(%rbx),%rdi
    1f80:	48 85 ff             	test   %rdi,%rdi
    1f83:	74 05                	je     1f8a <do_exit+0x6aa>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:922
		free_pipe_info(tsk->splice_pipe);
    1f85:	e8 00 00 00 00       	callq  1f8a <do_exit+0x6aa>
			1f86: R_X86_64_PLT32	free_pipe_info-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:924
	if (tsk->task_frag.page)
    1f8a:	48 8b bb c8 09 00 00 	mov    0x9c8(%rbx),%rdi
    1f91:	48 85 ff             	test   %rdi,%rdi
    1f94:	74 1b                	je     1fb1 <do_exit+0x6d1>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
    1f96:	48 8b 47 08          	mov    0x8(%rdi),%rax
compound_head():
/home/jeffrin/UP/linux-stable-rc/./include/linux/page-flags.h:176

static inline struct page *compound_head(struct page *page)
{
	unsigned long head = READ_ONCE(page->compound_head);

	if (unlikely(head & 1))
    1f9a:	a8 01                	test   $0x1,%al
    1f9c:	0f 85 69 04 00 00    	jne    240b <do_exit+0xb2b>
arch_static_branch():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/jump_label.h:25
    1fa2:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
arch_atomic_dec_and_test():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/atomic.h:125
	return GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, e);
    1fa7:	f0 ff 4f 34          	lock decl 0x34(%rdi)
put_page():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1031
	 * include/linux/memremap.h and HMM for details.
	 */
	if (put_devmap_managed_page(page))
		return;

	if (put_page_testzero(page))
    1fab:	0f 84 b7 02 00 00    	je     2268 <do_exit+0x988>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:931
	if (tsk->nr_dirtied)
    1fb1:	8b 83 e0 09 00 00    	mov    0x9e0(%rbx),%eax
    1fb7:	85 c0                	test   %eax,%eax
    1fb9:	74 07                	je     1fc2 <do_exit+0x6e2>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:932
		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
    1fbb:	65 01 05 00 00 00 00 	add    %eax,%gs:0x0(%rip)        # 1fc2 <do_exit+0x6e2>
			1fbe: R_X86_64_PC32	dirty_throttle_leaks-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:933 (discriminator 162)
	exit_rcu();
    1fc2:	e8 00 00 00 00       	callq  1fc7 <do_exit+0x6e7>
			1fc3: R_X86_64_PLT32	exit_rcu-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:937 (discriminator 162)
	do_task_dead();
    1fc7:	e8 00 00 00 00       	callq  1fcc <do_exit+0x6ec>
			1fc8: R_X86_64_PLT32	do_task_dead-0x4
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:738
		tsk->exit_state = EXIT_DEAD;
    1fcc:	c7 83 6c 04 00 00 10 	movl   $0x10,0x46c(%rbx)
    1fd3:	00 00 00 
list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:79
	__list_add(new, head, head->next);
    1fd6:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:739
		list_add(&tsk->ptrace_entry, &dead);
    1fdb:	48 8d ab 28 05 00 00 	lea    0x528(%rbx),%rbp
__list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:60
	if (!__list_add_valid(new, prev, next))
    1fe2:	4c 89 fe             	mov    %r15,%rsi
    1fe5:	48 89 ef             	mov    %rbp,%rdi
    1fe8:	4c 89 e2             	mov    %r12,%rdx
    1feb:	e8 00 00 00 00       	callq  1ff0 <do_exit+0x710>
			1fec: R_X86_64_PLT32	__list_add_valid-0x4
    1ff0:	84 c0                	test   %al,%al
    1ff2:	0f 84 af fe ff ff    	je     1ea7 <do_exit+0x5c7>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:63
	next->prev = new;
    1ff8:	49 89 6c 24 08       	mov    %rbp,0x8(%r12)
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:64
	new->next = next;
    1ffd:	4c 89 a3 28 05 00 00 	mov    %r12,0x528(%rbx)
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:65
	new->prev = prev;
    2004:	4c 89 bb 30 05 00 00 	mov    %r15,0x530(%rbx)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
    200b:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
__list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:66
	WRITE_ONCE(prev->next, new);
    2010:	e9 92 fe ff ff       	jmpq   1ea7 <do_exit+0x5c7>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:852
		hrtimer_cancel(&tsk->signal->real_timer);
    2015:	48 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%rax
    201c:	48 8d b8 90 00 00 00 	lea    0x90(%rax),%rdi
    2023:	e8 00 00 00 00       	callq  2028 <do_exit+0x748>
			2024: R_X86_64_PLT32	hrtimer_cancel-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:853
		exit_itimers(tsk->signal);
    2028:	48 8b bb d8 06 00 00 	mov    0x6d8(%rbx),%rdi
    202f:	e8 00 00 00 00       	callq  2034 <do_exit+0x754>
			2030: R_X86_64_PLT32	exit_itimers-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:855
		if (tsk->mm)
    2034:	48 8b 8b 20 04 00 00 	mov    0x420(%rbx),%rcx
    203b:	48 85 c9             	test   %rcx,%rcx
    203e:	74 5b                	je     209b <do_exit+0x7bb>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
    2040:	48 8b 91 c0 02 00 00 	mov    0x2c0(%rcx),%rdx
    2047:	48 8b b9 c8 02 00 00 	mov    0x2c8(%rcx),%rdi
get_mm_counter():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1670
	 * But it's never be expected number for users.
	 */
	if (val < 0)
		val = 0;
#endif
	return (unsigned long)val;
    204e:	45 31 c9             	xor    %r9d,%r9d
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    2051:	48 8b b1 d8 02 00 00 	mov    0x2d8(%rcx),%rsi
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:856
			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
    2058:	4c 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%r8
get_mm_counter():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1670
    205f:	48 85 d2             	test   %rdx,%rdx
    2062:	48 89 d0             	mov    %rdx,%rax
get_mm_hiwater_rss():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1712
		get_mm_counter(mm, MM_SHMEMPAGES);
}

static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
{
	return max(mm->hiwater_rss, get_mm_rss(mm));
    2065:	48 8b 91 a8 00 00 00 	mov    0xa8(%rcx),%rdx
get_mm_counter():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1670
	return (unsigned long)val;
    206c:	49 0f 48 c1          	cmovs  %r9,%rax
    2070:	48 85 ff             	test   %rdi,%rdi
    2073:	49 0f 48 f9          	cmovs  %r9,%rdi
get_mm_rss():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1705
	return get_mm_counter(mm, MM_FILEPAGES) +
    2077:	48 01 f8             	add    %rdi,%rax
get_mm_counter():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1670
	return (unsigned long)val;
    207a:	48 85 f6             	test   %rsi,%rsi
    207d:	49 0f 48 f1          	cmovs  %r9,%rsi
get_mm_rss():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1706
		get_mm_counter(mm, MM_ANONPAGES) +
    2081:	48 01 f0             	add    %rsi,%rax
get_mm_hiwater_rss():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1712
	return max(mm->hiwater_rss, get_mm_rss(mm));
    2084:	48 39 d0             	cmp    %rdx,%rax
    2087:	48 0f 42 c2          	cmovb  %rdx,%rax
setmax_mm_hiwater_rss():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1744
static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
					 struct mm_struct *mm)
{
	unsigned long hiwater_rss = get_mm_hiwater_rss(mm);

	if (*maxrss < hiwater_rss)
    208b:	49 3b 80 50 02 00 00 	cmp    0x250(%r8),%rax
    2092:	76 07                	jbe    209b <do_exit+0x7bb>
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1745
		*maxrss = hiwater_rss;
    2094:	49 89 80 50 02 00 00 	mov    %rax,0x250(%r8)
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:858
	acct_collect(code, group_dead);
    209b:	be 01 00 00 00       	mov    $0x1,%esi
    20a0:	48 89 ef             	mov    %rbp,%rdi
    20a3:	e8 00 00 00 00       	callq  20a8 <do_exit+0x7c8>
			20a4: R_X86_64_PLT32	acct_collect-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:860
		tty_audit_exit();
    20a8:	e8 00 00 00 00       	callq  20ad <do_exit+0x7cd>
			20a9: R_X86_64_PLT32	tty_audit_exit-0x4
    20ad:	e9 6d f9 ff ff       	jmpq   1a1f <do_exit+0x13f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:869
		acct_process();
    20b2:	e8 00 00 00 00       	callq  20b7 <do_exit+0x7d7>
			20b3: R_X86_64_PLT32	acct_process-0x4
    20b7:	e9 de fa ff ff       	jmpq   1b9a <do_exit+0x2ba>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:877
		disassociate_ctty(1);
    20bc:	bf 01 00 00 00       	mov    $0x1,%edi
    20c1:	e8 00 00 00 00       	callq  20c6 <do_exit+0x7e6>
			20c2: R_X86_64_PLT32	disassociate_ctty-0x4
    20c6:	e9 fd fa ff ff       	jmpq   1bc8 <do_exit+0x2e8>
freezing():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:39
	return freezing_slow_path(p);
    20cb:	4c 89 e7             	mov    %r12,%rdi
    20ce:	e8 00 00 00 00       	callq  20d3 <do_exit+0x7f3>
			20cf: R_X86_64_PLT32	freezing_slow_path-0x4
try_to_freeze_unsafe():
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:58
	if (likely(!freezing(current)))
    20d3:	84 c0                	test   %al,%al
    20d5:	0f 84 0d fa ff ff    	je     1ae8 <do_exit+0x208>
/home/jeffrin/UP/linux-stable-rc/./include/linux/freezer.h:60
	return __refrigerator(false);
    20db:	31 ff                	xor    %edi,%edi
    20dd:	e8 00 00 00 00       	callq  20e2 <do_exit+0x802>
			20de: R_X86_64_PLT32	__refrigerator-0x4
    20e2:	e9 01 fa ff ff       	jmpq   1ae8 <do_exit+0x208>
find_new_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:614
	if (father->signal->has_child_subreaper) {
    20e7:	f6 46 78 02          	testb  $0x2,0x78(%rsi)
    20eb:	0f 84 c0 fb ff ff    	je     1cb1 <do_exit+0x3d1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:615
		unsigned int ns_level = task_pid(father)->level;
    20f1:	48 8b 83 38 05 00 00 	mov    0x538(%rbx),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:624
		for (reaper = father->real_parent;
    20f8:	48 8b 93 e0 04 00 00 	mov    0x4e0(%rbx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:615
		unsigned int ns_level = task_pid(father)->level;
    20ff:	8b 78 04             	mov    0x4(%rax),%edi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:625
		     task_pid(reaper)->level == ns_level;
    2102:	48 8b 82 38 05 00 00 	mov    0x538(%rdx),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:627
			if (reaper == &init_task)
    2109:	39 78 04             	cmp    %edi,0x4(%rax)
    210c:	74 1c                	je     212a <do_exit+0x84a>
    210e:	e9 9e fb ff ff       	jmpq   1cb1 <do_exit+0x3d1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:626
		     reaper = reaper->real_parent) {
    2113:	48 8b 92 e0 04 00 00 	mov    0x4e0(%rdx),%rdx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:625
		     task_pid(reaper)->level == ns_level;
    211a:	48 8b 82 38 05 00 00 	mov    0x538(%rdx),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:627
			if (reaper == &init_task)
    2121:	39 78 04             	cmp    %edi,0x4(%rax)
    2124:	0f 85 87 fb ff ff    	jne    1cb1 <do_exit+0x3d1>
    212a:	48 81 fa 00 00 00 00 	cmp    $0x0,%rdx
			212d: R_X86_64_32S	init_task
    2131:	0f 84 7a fb ff ff    	je     1cb1 <do_exit+0x3d1>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:629
			if (!reaper->signal->is_child_subreaper)
    2137:	48 8b 82 d8 06 00 00 	mov    0x6d8(%rdx),%rax
    213e:	f6 40 78 01          	testb  $0x1,0x78(%rax)
    2142:	74 cf                	je     2113 <do_exit+0x833>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    2144:	48 8b 70 10          	mov    0x10(%rax),%rsi
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
	for_each_thread(p, t) {
    2148:	48 83 c0 10          	add    $0x10,%rax
    214c:	48 8d 8e 70 fa ff ff 	lea    -0x590(%rsi),%rcx
    2153:	48 39 f0             	cmp    %rsi,%rax
    2156:	75 15                	jne    216d <do_exit+0x88d>
    2158:	eb b9                	jmp    2113 <do_exit+0x833>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    215a:	48 8b b1 90 05 00 00 	mov    0x590(%rcx),%rsi
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
    2161:	48 8d 8e 70 fa ff ff 	lea    -0x590(%rsi),%rcx
    2168:	48 39 f0             	cmp    %rsi,%rax
    216b:	74 a6                	je     2113 <do_exit+0x833>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:557
		if (!(t->flags & PF_EXITING))
    216d:	f6 41 24 04          	testb  $0x4,0x24(%rcx)
    2171:	75 e7                	jne    215a <do_exit+0x87a>
find_new_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:632
			if (thread)
    2173:	48 85 c9             	test   %rcx,%rcx
    2176:	74 9b                	je     2113 <do_exit+0x833>
    2178:	49 89 cc             	mov    %rcx,%r12
    217b:	e9 31 fb ff ff       	jmpq   1cb1 <do_exit+0x3d1>
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:527
			complete(&core_state->startup);
    2180:	49 8d 7d 18          	lea    0x18(%r13),%rdi
    2184:	e8 00 00 00 00       	callq  2189 <do_exit+0x8a9>
			2185: R_X86_64_PLT32	complete-0x4
    2189:	e9 1f f9 ff ff       	jmpq   1aad <do_exit+0x1cd>
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:721
		kill_orphaned_pgrp(tsk->group_leader, NULL);
    218e:	48 8b bb 10 05 00 00 	mov    0x510(%rbx),%rdi
    2195:	31 f6                	xor    %esi,%esi
    2197:	e8 24 df ff ff       	callq  c0 <kill_orphaned_pgrp>
    219c:	e9 ba fc ff ff       	jmpq   1e5b <do_exit+0x57b>
ptrace_event():
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:158
		current->ptrace_message = message;
    21a1:	48 89 a8 c8 07 00 00 	mov    %rbp,0x7c8(%rax)
/home/jeffrin/UP/linux-stable-rc/./include/linux/ptrace.h:159
		ptrace_notify((event << 8) | SIGTRAP);
    21a8:	bf 05 06 00 00       	mov    $0x605,%edi
    21ad:	e8 00 00 00 00       	callq  21b2 <do_exit+0x8d2>
			21ae: R_X86_64_PLT32	ptrace_notify-0x4
    21b2:	e9 da f7 ff ff       	jmpq   1991 <do_exit+0xb1>
audit_free():
/home/jeffrin/UP/linux-stable-rc/./include/linux/audit.h:300
		__audit_free(task);
    21b7:	48 89 df             	mov    %rbx,%rdi
    21ba:	e8 00 00 00 00       	callq  21bf <do_exit+0x8df>
			21bb: R_X86_64_PLT32	__audit_free-0x4
    21bf:	e9 69 f8 ff ff       	jmpq   1a2d <do_exit+0x14d>
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
	for_each_thread(p, t) {
    21c4:	48 8b 93 d8 06 00 00 	mov    0x6d8(%rbx),%rdx
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    21cb:	48 8b 42 10          	mov    0x10(%rdx),%rax
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
    21cf:	48 83 c2 10          	add    $0x10,%rdx
    21d3:	4c 8d a0 70 fa ff ff 	lea    -0x590(%rax),%r12
    21da:	48 39 c2             	cmp    %rax,%rdx
    21dd:	75 1d                	jne    21fc <do_exit+0x91c>
    21df:	e9 7d 01 00 00       	jmpq   2361 <do_exit+0xa81>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    21e4:	49 8b 84 24 90 05 00 	mov    0x590(%r12),%rax
    21eb:	00 
find_alive_thread():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:556
    21ec:	4c 8d a0 70 fa ff ff 	lea    -0x590(%rax),%r12
    21f3:	48 39 c2             	cmp    %rax,%rdx
    21f6:	0f 84 65 01 00 00    	je     2361 <do_exit+0xa81>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:557
		if (!(t->flags & PF_EXITING))
    21fc:	41 f6 44 24 24 04    	testb  $0x4,0x24(%r12)
    2202:	75 e0                	jne    21e4 <do_exit+0x904>
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:576
	if (reaper) {
    2204:	4d 85 e4             	test   %r12,%r12
    2207:	0f 84 54 01 00 00    	je     2361 <do_exit+0xa81>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:577
		pid_ns->child_reaper = reaper;
    220d:	4c 89 65 38          	mov    %r12,0x38(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:578
		return reaper;
    2211:	e9 3b fa ff ff       	jmpq   1c51 <do_exit+0x371>
forget_original_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:678
		exit_ptrace(father, dead);
    2216:	4c 89 fe             	mov    %r15,%rsi
    2219:	48 89 df             	mov    %rbx,%rdi
    221c:	e8 00 00 00 00       	callq  2221 <do_exit+0x941>
			221d: R_X86_64_PLT32	exit_ptrace-0x4
    2221:	e9 13 fa ff ff       	jmpq   1c39 <do_exit+0x359>
exit_umh():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched.h:1977
		__exit_umh(tsk);
    2226:	48 89 df             	mov    %rbx,%rdi
    2229:	e8 00 00 00 00       	callq  222e <do_exit+0x94e>
			222a: R_X86_64_PLT32	__exit_umh-0x4
    222e:	e9 b4 f9 ff ff       	jmpq   1be7 <do_exit+0x307>
page_zonenum():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:934
	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
    2233:	48 8b 07             	mov    (%rdi),%rax
    2236:	48 c1 e8 37          	shr    $0x37,%rax
    223a:	83 e0 07             	and    $0x7,%eax
put_devmap_managed_page():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:958
	if (!is_zone_device_page(page))
    223d:	83 f8 04             	cmp    $0x4,%eax
    2240:	0f 85 61 fd ff ff    	jne    1fa7 <do_exit+0x6c7>
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:960
	switch (page->pgmap->type) {
    2246:	48 8b 47 08          	mov    0x8(%rdi),%rax
    224a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
    2250:	83 e8 01             	sub    $0x1,%eax
    2253:	83 f8 01             	cmp    $0x1,%eax
    2256:	0f 87 4b fd ff ff    	ja     1fa7 <do_exit+0x6c7>
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:963
		__put_devmap_managed_page(page);
    225c:	e8 00 00 00 00       	callq  2261 <do_exit+0x981>
			225d: R_X86_64_PLT32	__put_devmap_managed_page-0x4
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:964
		return true;
    2261:	e9 4b fd ff ff       	jmpq   1fb1 <do_exit+0x6d1>
exit_mm():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:539
	BUG_ON(mm != current->active_mm);
    2266:	0f 0b                	ud2    
put_page():
/home/jeffrin/UP/linux-stable-rc/./include/linux/mm.h:1032
		__put_page(page);
    2268:	e8 00 00 00 00       	callq  226d <do_exit+0x98d>
			2269: R_X86_64_PLT32	__put_page-0x4
    226d:	e9 3f fd ff ff       	jmpq   1fb1 <do_exit+0x6d1>
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:744
		wake_up_process(tsk->signal->group_exit_task);
    2272:	48 8b 78 68          	mov    0x68(%rax),%rdi
    2276:	e8 00 00 00 00       	callq  227b <do_exit+0x99b>
			2277: R_X86_64_PLT32	wake_up_process-0x4
    227b:	e9 38 fc ff ff       	jmpq   1eb8 <do_exit+0x5d8>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:905
		kfree(current->pi_state_cache);
    2280:	48 8b b8 80 08 00 00 	mov    0x880(%rax),%rdi
    2287:	e8 00 00 00 00       	callq  228c <do_exit+0x9ac>
			2288: R_X86_64_PLT32	kfree-0x4
    228c:	e9 d2 fc ff ff       	jmpq   1f63 <do_exit+0x683>
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:728
			tsk->exit_signal : SIGCHLD;
    2291:	85 f6                	test   %esi,%esi
    2293:	78 17                	js     22ac <do_exit+0x9cc>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    2295:	48 8b 83 80 05 00 00 	mov    0x580(%rbx),%rax
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
    229c:	48 8d 93 80 05 00 00 	lea    0x580(%rbx),%rdx
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:725
		int sig = thread_group_leader(tsk) &&
    22a3:	48 39 c2             	cmp    %rax,%rdx
    22a6:	0f 84 68 01 00 00    	je     2414 <do_exit+0xb34>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:728
			tsk->exit_signal : SIGCHLD;
    22ac:	be 11 00 00 00       	mov    $0x11,%esi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:729
		autoreap = do_notify_parent(tsk, sig);
    22b1:	48 89 df             	mov    %rbx,%rdi
    22b4:	e8 00 00 00 00       	callq  22b9 <do_exit+0x9d9>
			22b5: R_X86_64_PLT32	do_notify_parent-0x4
    22b9:	41 89 c5             	mov    %eax,%r13d
    22bc:	e9 dd fb ff ff       	jmpq   1e9e <do_exit+0x5be>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:732
			do_notify_parent(tsk, tsk->exit_signal);
    22c1:	48 89 df             	mov    %rbx,%rdi
    22c4:	e8 00 00 00 00       	callq  22c9 <do_exit+0x9e9>
			22c5: R_X86_64_PLT32	do_notify_parent-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:731
		autoreap = thread_group_empty(tsk) &&
    22c9:	0f b6 c0             	movzbl %al,%eax
    22cc:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    22d0:	e9 bf fb ff ff       	jmpq   1e94 <do_exit+0x5b4>
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
    22d5:	49 8b 81 80 05 00 00 	mov    0x580(%r9),%rax
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
    22dc:	49 8d 91 80 05 00 00 	lea    0x580(%r9),%rdx
reparent_leader():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:654
	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
    22e3:	48 39 c2             	cmp    %rax,%rdx
    22e6:	0f 85 f2 fa ff ff    	jne    1dde <do_exit+0x4fe>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:655
		if (do_notify_parent(p, p->exit_signal)) {
    22ec:	4c 89 cf             	mov    %r9,%rdi
    22ef:	be 11 00 00 00       	mov    $0x11,%esi
    22f4:	4c 89 0c 24          	mov    %r9,(%rsp)
    22f8:	e8 00 00 00 00       	callq  22fd <do_exit+0xa1d>
			22f9: R_X86_64_PLT32	do_notify_parent-0x4
    22fd:	4c 8b 0c 24          	mov    (%rsp),%r9
    2301:	84 c0                	test   %al,%al
    2303:	0f 84 d5 fa ff ff    	je     1dde <do_exit+0x4fe>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:657
			list_add(&p->ptrace_entry, dead);
    2309:	49 8d a9 28 05 00 00 	lea    0x528(%r9),%rbp
__list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:60
	if (!__list_add_valid(new, prev, next))
    2310:	4c 89 fe             	mov    %r15,%rsi
reparent_leader():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:657
    2313:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:656
			p->exit_state = EXIT_DEAD;
    2318:	41 c7 81 6c 04 00 00 	movl   $0x10,0x46c(%r9)
    231f:	10 00 00 00 
list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:79
	__list_add(new, head, head->next);
    2323:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
__list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:60
	if (!__list_add_valid(new, prev, next))
    2328:	48 89 ef             	mov    %rbp,%rdi
    232b:	48 89 14 24          	mov    %rdx,(%rsp)
    232f:	e8 00 00 00 00       	callq  2334 <do_exit+0xa54>
			2330: R_X86_64_PLT32	__list_add_valid-0x4
    2334:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
    2339:	84 c0                	test   %al,%al
    233b:	0f 84 9d fa ff ff    	je     1dde <do_exit+0x4fe>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:63
	next->prev = new;
    2341:	48 8b 14 24          	mov    (%rsp),%rdx
    2345:	48 89 6a 08          	mov    %rbp,0x8(%rdx)
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:64
	new->next = next;
    2349:	49 89 91 28 05 00 00 	mov    %rdx,0x528(%r9)
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:65
	new->prev = prev;
    2350:	4d 89 b9 30 05 00 00 	mov    %r15,0x530(%r9)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
    2357:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
__list_add():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:66
	WRITE_ONCE(prev->next, new);
    235c:	e9 7d fa ff ff       	jmpq   1dde <do_exit+0x4fe>
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:223
	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
    2361:	c6 05 00 00 00 00 00 	movb   $0x0,0x0(%rip)        # 2368 <do_exit+0xa88>
			2363: R_X86_64_PC32	tasklist_lock-0x5
__raw_write_unlock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/rwlock_api_smp.h:267
    2368:	e8 93 dc ff ff       	callq  0 <arch_local_irq_enable>
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:582
	if (unlikely(pid_ns == &init_pid_ns)) {
    236d:	48 81 fd 00 00 00 00 	cmp    $0x0,%rbp
			2370: R_X86_64_32S	init_pid_ns
    2374:	0f 84 00 00 00 00    	je     237a <do_exit+0xa9a>
			2376: R_X86_64_PC32	.text.unlikely+0x3
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:587
	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
    237a:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
    237f:	4c 8b 20             	mov    (%rax),%r12
    2382:	4c 8d a8 d8 fa ff ff 	lea    -0x528(%rax),%r13
    2389:	49 81 ec 28 05 00 00 	sub    $0x528,%r12
    2390:	eb 51                	jmp    23e3 <do_exit+0xb03>
__list_del_entry():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:131
	if (!__list_del_entry_valid(entry))
    2392:	48 89 d7             	mov    %rdx,%rdi
    2395:	48 89 14 24          	mov    %rdx,(%rsp)
    2399:	e8 00 00 00 00       	callq  239e <do_exit+0xabe>
			239a: R_X86_64_PLT32	__list_del_entry_valid-0x4
    239e:	48 8b 14 24          	mov    (%rsp),%rdx
    23a2:	84 c0                	test   %al,%al
    23a4:	74 15                	je     23bb <do_exit+0xadb>
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:134
	__list_del(entry->prev, entry->next);
    23a6:	49 8b 8d 28 05 00 00 	mov    0x528(%r13),%rcx
    23ad:	49 8b 85 30 05 00 00 	mov    0x530(%r13),%rax
__list_del():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:105
	next->prev = prev;
    23b4:	48 89 41 08          	mov    %rax,0x8(%rcx)
__write_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:226
	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
    23b8:	48 89 08             	mov    %rcx,(%rax)
    23bb:	49 89 95 28 05 00 00 	mov    %rdx,0x528(%r13)
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:589
		release_task(p);
    23c2:	4c 89 ef             	mov    %r13,%rdi
INIT_LIST_HEAD():
/home/jeffrin/UP/linux-stable-rc/./include/linux/list.h:29
	list->prev = list;
    23c5:	49 89 95 30 05 00 00 	mov    %rdx,0x530(%r13)
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:587
	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
    23cc:	4d 89 e5             	mov    %r12,%r13
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:589
		release_task(p);
    23cf:	e8 00 00 00 00       	callq  23d4 <do_exit+0xaf4>
			23d0: R_X86_64_PLT32	release_task-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:587
	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
    23d4:	49 8b 84 24 28 05 00 	mov    0x528(%r12),%rax
    23db:	00 
    23dc:	4c 8d a0 d8 fa ff ff 	lea    -0x528(%rax),%r12
    23e3:	49 8d 95 28 05 00 00 	lea    0x528(%r13),%rdx
    23ea:	4c 39 fa             	cmp    %r15,%rdx
    23ed:	75 a3                	jne    2392 <do_exit+0xab2>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:592
	zap_pid_ns_processes(pid_ns);
    23ef:	48 89 ef             	mov    %rbp,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:595
	return father;
    23f2:	49 89 dc             	mov    %rbx,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:592
	zap_pid_ns_processes(pid_ns);
    23f5:	e8 00 00 00 00       	callq  23fa <do_exit+0xb1a>
			23f6: R_X86_64_PLT32	zap_pid_ns_processes-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:593
	write_lock_irq(&tasklist_lock);
    23fa:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			23fd: R_X86_64_32S	tasklist_lock
    2401:	e8 00 00 00 00       	callq  2406 <do_exit+0xb26>
			2402: R_X86_64_PLT32	_raw_write_lock_irq-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:595
	return father;
    2406:	e9 46 f8 ff ff       	jmpq   1c51 <do_exit+0x371>
compound_head():
/home/jeffrin/UP/linux-stable-rc/./include/linux/page-flags.h:177
		return (struct page *) (head - 1);
    240b:	48 8d 78 ff          	lea    -0x1(%rax),%rdi
    240f:	e9 8e fb ff ff       	jmpq   1fa2 <do_exit+0x6c2>
same_thread_group():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:656
	return p1->signal == p2->signal;
    2414:	48 8b 93 e0 04 00 00 	mov    0x4e0(%rbx),%rdx
    241b:	48 8b 83 e8 04 00 00 	mov    0x4e8(%rbx),%rax
exit_notify():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:728
			tsk->exit_signal : SIGCHLD;
    2422:	48 8b 80 d8 06 00 00 	mov    0x6d8(%rax),%rax
    2429:	48 39 82 d8 06 00 00 	cmp    %rax,0x6d8(%rdx)
    2430:	b8 11 00 00 00       	mov    $0x11,%eax
    2435:	0f 45 f0             	cmovne %eax,%esi
    2438:	e9 74 fe ff ff       	jmpq   22b1 <do_exit+0x9d1>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:728
    243d:	0f 1f 00             	nopl   (%rax)

0000000000002440 <complete_and_exit>:
complete_and_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:942
{
    2440:	e8 00 00 00 00       	callq  2445 <complete_and_exit+0x5>
			2441: R_X86_64_PLT32	__fentry__-0x4
    2445:	55                   	push   %rbp
    2446:	48 89 f5             	mov    %rsi,%rbp
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:943
	if (comp)
    2449:	48 85 ff             	test   %rdi,%rdi
    244c:	74 05                	je     2453 <complete_and_exit+0x13>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:944
		complete(comp);
    244e:	e8 00 00 00 00       	callq  2453 <complete_and_exit+0x13>
			244f: R_X86_64_PLT32	complete-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:946
	do_exit(code);
    2453:	48 89 ef             	mov    %rbp,%rdi
    2456:	e8 00 00 00 00       	callq  245b <complete_and_exit+0x1b>
			2457: R_X86_64_PLT32	do_exit-0x4
    245b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000002460 <__x64_sys_exit>:
__x64_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:950
SYSCALL_DEFINE1(exit, int, error_code)
    2460:	e8 00 00 00 00       	callq  2465 <__x64_sys_exit+0x5>
			2461: R_X86_64_PLT32	__fentry__-0x4
__se_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:950
    2465:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
__do_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:952
	do_exit((error_code&0xff)<<8);
    2469:	c1 e7 08             	shl    $0x8,%edi
    246c:	81 e7 00 ff 00 00    	and    $0xff00,%edi
    2472:	e8 00 00 00 00       	callq  2477 <__x64_sys_exit+0x17>
			2473: R_X86_64_PLT32	do_exit-0x4
__x64_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:952
    2477:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    247e:	00 00 

0000000000002480 <__ia32_sys_exit>:
__ia32_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:950
SYSCALL_DEFINE1(exit, int, error_code)
    2480:	e8 00 00 00 00       	callq  2485 <__ia32_sys_exit+0x5>
			2481: R_X86_64_PLT32	__fentry__-0x4
__se_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:950
    2485:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
__do_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:952
	do_exit((error_code&0xff)<<8);
    2489:	c1 e7 08             	shl    $0x8,%edi
    248c:	81 e7 00 ff 00 00    	and    $0xff00,%edi
    2492:	e8 00 00 00 00       	callq  2497 <__ia32_sys_exit+0x17>
			2493: R_X86_64_PLT32	do_exit-0x4
__ia32_sys_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:952
    2497:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    249e:	00 00 

00000000000024a0 <do_group_exit>:
do_group_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:961
{
    24a0:	e8 00 00 00 00       	callq  24a5 <do_group_exit+0x5>
			24a1: R_X86_64_PLT32	__fentry__-0x4
    24a5:	41 55                	push   %r13
    24a7:	41 54                	push   %r12
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    24a9:	65 4c 8b 24 25 00 00 	mov    %gs:0x0,%r12
    24b0:	00 00 
			24ae: R_X86_64_32S	current_task
do_group_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:961
    24b2:	55                   	push   %rbp
    24b3:	53                   	push   %rbx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:962
	struct signal_struct *sig = current->signal;
    24b4:	49 8b ac 24 d8 06 00 	mov    0x6d8(%r12),%rbp
    24bb:	00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:964
	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
    24bc:	40 f6 c7 80          	test   $0x80,%dil
    24c0:	75 76                	jne    2538 <do_group_exit+0x98>
signal_group_exit():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:267 (discriminator 2)
	return	(sig->flags & SIGNAL_GROUP_EXIT) ||
    24c2:	f6 45 74 04          	testb  $0x4,0x74(%rbp)
    24c6:	75 07                	jne    24cf <do_group_exit+0x2f>
    24c8:	48 83 7d 68 00       	cmpq   $0x0,0x68(%rbp)
    24cd:	74 0b                	je     24da <do_group_exit+0x3a>
do_group_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:967
		exit_code = sig->group_exit_code;
    24cf:	8b 5d 60             	mov    0x60(%rbp),%ebx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:983
	do_exit(exit_code);
    24d2:	48 63 fb             	movslq %ebx,%rdi
    24d5:	e8 00 00 00 00       	callq  24da <do_group_exit+0x3a>
			24d6: R_X86_64_PLT32	do_exit-0x4
__read_once_size():
/home/jeffrin/UP/linux-stable-rc/./include/linux/compiler.h:199
	__READ_ONCE_SIZE;
    24da:	49 8b 84 24 80 05 00 	mov    0x580(%r12),%rax
    24e1:	00 
thread_group_empty():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:667
	return list_empty(&p->thread_group);
    24e2:	49 8d 94 24 80 05 00 	lea    0x580(%r12),%rdx
    24e9:	00 
    24ea:	89 fb                	mov    %edi,%ebx
do_group_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:968
	else if (!thread_group_empty(current)) {
    24ec:	48 39 c2             	cmp    %rax,%rdx
    24ef:	74 e1                	je     24d2 <do_group_exit+0x32>
spin_lock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock.h:363
	raw_spin_lock_irq(&lock->rlock);
    24f1:	4d 8b ac 24 e0 06 00 	mov    0x6e0(%r12),%r13
    24f8:	00 
    24f9:	4c 89 ef             	mov    %r13,%rdi
    24fc:	e8 00 00 00 00       	callq  2501 <do_group_exit+0x61>
			24fd: R_X86_64_PLT32	_raw_spin_lock_irq-0x4
signal_group_exit():
/home/jeffrin/UP/linux-stable-rc/./include/linux/sched/signal.h:267
	return	(sig->flags & SIGNAL_GROUP_EXIT) ||
    2501:	f6 45 74 04          	testb  $0x4,0x74(%rbp)
    2505:	75 1b                	jne    2522 <do_group_exit+0x82>
    2507:	48 83 7d 68 00       	cmpq   $0x0,0x68(%rbp)
    250c:	75 14                	jne    2522 <do_group_exit+0x82>
do_group_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:976
			sig->group_exit_code = exit_code;
    250e:	89 5d 60             	mov    %ebx,0x60(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:978
			zap_other_threads(current);
    2511:	4c 89 e7             	mov    %r12,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:977
			sig->flags = SIGNAL_GROUP_EXIT;
    2514:	c7 45 74 04 00 00 00 	movl   $0x4,0x74(%rbp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:978
			zap_other_threads(current);
    251b:	e8 00 00 00 00       	callq  2520 <do_group_exit+0x80>
			251c: R_X86_64_PLT32	zap_other_threads-0x4
    2520:	eb 03                	jmp    2525 <do_group_exit+0x85>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:974
			exit_code = sig->group_exit_code;
    2522:	8b 5d 60             	mov    0x60(%rbp),%ebx
pv_queued_spin_unlock():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:659
    2525:	4c 89 ef             	mov    %r13,%rdi
    2528:	ff 14 25 00 00 00 00 	callq  *0x0
			252b: R_X86_64_32S	pv_ops+0x2a8
arch_local_irq_enable():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/paravirt.h:778
	PVOP_VCALLEE0(irq.irq_enable);
    252f:	ff 14 25 00 00 00 00 	callq  *0x0
			2532: R_X86_64_32S	pv_ops+0x140
__raw_spin_unlock_irq():
/home/jeffrin/UP/linux-stable-rc/./include/linux/spinlock_api_smp.h:170
}
    2536:	eb 9a                	jmp    24d2 <do_group_exit+0x32>
do_group_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:964 (discriminator 1)
	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
    2538:	0f 0b                	ud2    
    253a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000002540 <__x64_sys_exit_group>:
__x64_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:992
SYSCALL_DEFINE1(exit_group, int, error_code)
    2540:	e8 00 00 00 00       	callq  2545 <__x64_sys_exit_group+0x5>
			2541: R_X86_64_PLT32	__fentry__-0x4
__se_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:992
    2545:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
__do_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:994
	do_group_exit((error_code & 0xff) << 8);
    2549:	c1 e7 08             	shl    $0x8,%edi
    254c:	0f b7 ff             	movzwl %di,%edi
    254f:	e8 00 00 00 00       	callq  2554 <__x64_sys_exit_group+0x14>
			2550: R_X86_64_PLT32	do_group_exit-0x4
__x64_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:992
SYSCALL_DEFINE1(exit_group, int, error_code)
    2554:	31 c0                	xor    %eax,%eax
    2556:	c3                   	retq   
    2557:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    255e:	00 00 

0000000000002560 <__ia32_sys_exit_group>:
__ia32_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:992
    2560:	e8 00 00 00 00       	callq  2565 <__ia32_sys_exit_group+0x5>
			2561: R_X86_64_PLT32	__fentry__-0x4
__se_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:992
    2565:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
__do_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:994
	do_group_exit((error_code & 0xff) << 8);
    2569:	c1 e7 08             	shl    $0x8,%edi
    256c:	0f b7 ff             	movzwl %di,%edi
    256f:	e8 00 00 00 00       	callq  2574 <__ia32_sys_exit_group+0x14>
			2570: R_X86_64_PLT32	do_group_exit-0x4
__ia32_sys_exit_group():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:992
SYSCALL_DEFINE1(exit_group, int, error_code)
    2574:	31 c0                	xor    %eax,%eax
    2576:	c3                   	retq   
    2577:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    257e:	00 00 

0000000000002580 <__wake_up_parent>:
__wake_up_parent():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1498
{
    2580:	e8 00 00 00 00       	callq  2585 <__wake_up_parent+0x5>
			2581: R_X86_64_PLT32	__fentry__-0x4
    2585:	48 89 f9             	mov    %rdi,%rcx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1499
	__wake_up_sync_key(&parent->signal->wait_chldexit,
    2588:	48 8b be d8 06 00 00 	mov    0x6d8(%rsi),%rdi
    258f:	ba 01 00 00 00       	mov    $0x1,%edx
    2594:	be 01 00 00 00       	mov    $0x1,%esi
    2599:	48 83 c7 20          	add    $0x20,%rdi
    259d:	e9 00 00 00 00       	jmpq   25a2 <__wake_up_parent+0x22>
			259e: R_X86_64_PLT32	__wake_up_sync_key-0x4
    25a2:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    25a9:	00 00 00 00 
    25ad:	0f 1f 00             	nopl   (%rax)

00000000000025b0 <kernel_wait4>:
kernel_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1638
{
    25b0:	e8 00 00 00 00       	callq  25b5 <kernel_wait4+0x5>
			25b1: R_X86_64_PLT32	__fentry__-0x4
    25b5:	41 56                	push   %r14
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1644
	if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
    25b7:	41 89 d6             	mov    %edx,%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1638
{
    25ba:	41 55                	push   %r13
    25bc:	41 54                	push   %r12
    25be:	55                   	push   %rbp
    25bf:	53                   	push   %rbx
    25c0:	48 83 ec 60          	sub    $0x60,%rsp
    25c4:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    25cb:	00 00 
    25cd:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
    25d2:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1644
	if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
    25d4:	41 81 e6 f4 ff ff 1f 	and    $0x1ffffff4,%r14d
    25db:	0f 85 f3 00 00 00    	jne    26d4 <kernel_wait4+0x124>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1649
	if (upid == INT_MIN)
    25e1:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
    25e7:	0f 84 f0 00 00 00    	je     26dd <kernel_wait4+0x12d>
    25ed:	48 89 f5             	mov    %rsi,%rbp
    25f0:	89 d3                	mov    %edx,%ebx
    25f2:	49 89 cc             	mov    %rcx,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1652
	if (upid == -1)
    25f5:	83 ff ff             	cmp    $0xffffffff,%edi
    25f8:	0f 84 a6 00 00 00    	je     26a4 <kernel_wait4+0xf4>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1654
	else if (upid < 0) {
    25fe:	85 ff                	test   %edi,%edi
    2600:	0f 88 b9 00 00 00    	js     26bf <kernel_wait4+0x10f>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1657
	} else if (upid == 0) {
    2606:	0f 85 a6 00 00 00    	jne    26b2 <kernel_wait4+0x102>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1659
		pid = get_task_pid(current, PIDTYPE_PGID);
    260c:	be 02 00 00 00       	mov    $0x2,%esi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1658
		type = PIDTYPE_PGID;
    2611:	41 be 02 00 00 00    	mov    $0x2,%r14d
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
    2617:	65 48 8b 3c 25 00 00 	mov    %gs:0x0,%rdi
    261e:	00 00 
			261c: R_X86_64_32S	current_task
kernel_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1659
		pid = get_task_pid(current, PIDTYPE_PGID);
    2620:	e8 00 00 00 00       	callq  2625 <kernel_wait4+0x75>
			2621: R_X86_64_PLT32	get_task_pid-0x4
    2625:	49 89 c5             	mov    %rax,%r13
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1667
	wo.wo_flags	= options | WEXITED;
    2628:	83 cb 04             	or     $0x4,%ebx
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1671
	ret = do_wait(&wo);
    262b:	48 89 e7             	mov    %rsp,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1670
	wo.wo_rusage	= ru;
    262e:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1665
	wo.wo_type	= type;
    2633:	44 89 34 24          	mov    %r14d,(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1666
	wo.wo_pid	= pid;
    2637:	4c 89 6c 24 08       	mov    %r13,0x8(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1667
	wo.wo_flags	= options | WEXITED;
    263c:	89 5c 24 04          	mov    %ebx,0x4(%rsp)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1668
	wo.wo_info	= NULL;
    2640:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
    2647:	00 00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1669
	wo.wo_stat	= 0;
    2649:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
    2650:	00 
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1671
	ret = do_wait(&wo);
    2651:	e8 da e9 ff ff       	callq  1030 <do_wait>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1672
	put_pid(pid);
    2656:	4c 89 ef             	mov    %r13,%rdi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1671
	ret = do_wait(&wo);
    2659:	49 89 c4             	mov    %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1672
	put_pid(pid);
    265c:	e8 00 00 00 00       	callq  2661 <kernel_wait4+0xb1>
			265d: R_X86_64_PLT32	put_pid-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1673
	if (ret > 0 && stat_addr && put_user(wo.wo_stat, stat_addr))
    2661:	4d 85 e4             	test   %r12,%r12
    2664:	7e 1e                	jle    2684 <kernel_wait4+0xd4>
    2666:	48 85 ed             	test   %rbp,%rbp
    2669:	74 19                	je     2684 <kernel_wait4+0xd4>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1673 (discriminator 1)
    266b:	8b 44 24 18          	mov    0x18(%rsp),%eax
    266f:	48 89 e9             	mov    %rbp,%rcx
    2672:	e8 00 00 00 00       	callq  2677 <kernel_wait4+0xc7>
			2673: R_X86_64_PLT32	__put_user_4-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1674 (discriminator 1)
		ret = -EFAULT;
    2677:	85 c0                	test   %eax,%eax
    2679:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    2680:	4c 0f 45 e0          	cmovne %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1677
}
    2684:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
    2689:	65 48 33 04 25 28 00 	xor    %gs:0x28,%rax
    2690:	00 00 
    2692:	75 52                	jne    26e6 <kernel_wait4+0x136>
    2694:	48 83 c4 60          	add    $0x60,%rsp
    2698:	4c 89 e0             	mov    %r12,%rax
    269b:	5b                   	pop    %rbx
    269c:	5d                   	pop    %rbp
    269d:	41 5c                	pop    %r12
    269f:	41 5d                	pop    %r13
    26a1:	41 5e                	pop    %r14
    26a3:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1653
		type = PIDTYPE_MAX;
    26a4:	41 be 04 00 00 00    	mov    $0x4,%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1640
	struct pid *pid = NULL;
    26aa:	45 31 ed             	xor    %r13d,%r13d
    26ad:	e9 76 ff ff ff       	jmpq   2628 <kernel_wait4+0x78>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1662
		pid = find_get_pid(upid);
    26b2:	e8 00 00 00 00       	callq  26b7 <kernel_wait4+0x107>
			26b3: R_X86_64_PLT32	find_get_pid-0x4
    26b7:	49 89 c5             	mov    %rax,%r13
    26ba:	e9 69 ff ff ff       	jmpq   2628 <kernel_wait4+0x78>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1656
		pid = find_get_pid(-upid);
    26bf:	f7 df                	neg    %edi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1655
		type = PIDTYPE_PGID;
    26c1:	41 be 02 00 00 00    	mov    $0x2,%r14d
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1656
		pid = find_get_pid(-upid);
    26c7:	e8 00 00 00 00       	callq  26cc <kernel_wait4+0x11c>
			26c8: R_X86_64_PLT32	find_get_pid-0x4
    26cc:	49 89 c5             	mov    %rax,%r13
    26cf:	e9 54 ff ff ff       	jmpq   2628 <kernel_wait4+0x78>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1646
		return -EINVAL;
    26d4:	49 c7 c4 ea ff ff ff 	mov    $0xffffffffffffffea,%r12
    26db:	eb a7                	jmp    2684 <kernel_wait4+0xd4>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1650
		return -ESRCH;
    26dd:	49 c7 c4 fd ff ff ff 	mov    $0xfffffffffffffffd,%r12
    26e4:	eb 9e                	jmp    2684 <kernel_wait4+0xd4>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1677
}
    26e6:	e8 00 00 00 00       	callq  26eb <kernel_wait4+0x13b>
			26e7: R_X86_64_PLT32	__stack_chk_fail-0x4
    26eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000026f0 <__do_sys_wait4>:
__do_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1681
{
    26f0:	55                   	push   %rbp
    26f1:	48 89 e5             	mov    %rsp,%rbp
    26f4:	41 55                	push   %r13
    26f6:	41 54                	push   %r12
    26f8:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    26fc:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
    2703:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    270a:	00 00 
    270c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
    2713:	00 
    2714:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1683
	long err = kernel_wait4(upid, stat_addr, options, ru ? &r : NULL);
    2716:	48 85 c9             	test   %rcx,%rcx
    2719:	74 53                	je     276e <__do_sys_wait4+0x7e>
    271b:	49 89 cd             	mov    %rcx,%r13
    271e:	48 89 e1             	mov    %rsp,%rcx
    2721:	e8 00 00 00 00       	callq  2726 <__do_sys_wait4+0x36>
			2722: R_X86_64_PLT32	kernel_wait4-0x4
    2726:	49 89 c4             	mov    %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1685
	if (err > 0) {
    2729:	48 85 c0             	test   %rax,%rax
    272c:	7f 20                	jg     274e <__do_sys_wait4+0x5e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1690
}
    272e:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
    2735:	00 
    2736:	65 48 33 04 25 28 00 	xor    %gs:0x28,%rax
    273d:	00 00 
    273f:	75 39                	jne    277a <__do_sys_wait4+0x8a>
    2741:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
    2745:	4c 89 e0             	mov    %r12,%rax
    2748:	41 5c                	pop    %r12
    274a:	41 5d                	pop    %r13
    274c:	5d                   	pop    %rbp
    274d:	c3                   	retq   
copy_to_user():
/home/jeffrin/UP/linux-stable-rc/./include/linux/uaccess.h:152
    274e:	ba 90 00 00 00       	mov    $0x90,%edx
    2753:	48 89 e6             	mov    %rsp,%rsi
    2756:	4c 89 ef             	mov    %r13,%rdi
    2759:	e8 00 00 00 00       	callq  275e <__do_sys_wait4+0x6e>
			275a: R_X86_64_PLT32	_copy_to_user-0x4
__do_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1687
			return -EFAULT;
    275e:	48 85 c0             	test   %rax,%rax
    2761:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    2768:	4c 0f 45 e0          	cmovne %rax,%r12
    276c:	eb c0                	jmp    272e <__do_sys_wait4+0x3e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1683
	long err = kernel_wait4(upid, stat_addr, options, ru ? &r : NULL);
    276e:	31 c9                	xor    %ecx,%ecx
    2770:	e8 00 00 00 00       	callq  2775 <__do_sys_wait4+0x85>
			2771: R_X86_64_PLT32	kernel_wait4-0x4
    2775:	49 89 c4             	mov    %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1685
	if (err > 0) {
    2778:	eb b4                	jmp    272e <__do_sys_wait4+0x3e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1690
}
    277a:	e8 00 00 00 00       	callq  277f <__do_sys_wait4+0x8f>
			277b: R_X86_64_PLT32	__stack_chk_fail-0x4
    277f:	90                   	nop

0000000000002780 <__x64_sys_wait4>:
__x64_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1679
SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
    2780:	e8 00 00 00 00       	callq  2785 <__x64_sys_wait4+0x5>
			2781: R_X86_64_PLT32	__fentry__-0x4
__se_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1679
    2785:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
    2789:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    278d:	48 8b 77 68          	mov    0x68(%rdi),%rsi
    2791:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
    2795:	e9 56 ff ff ff       	jmpq   26f0 <__do_sys_wait4>
__x64_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1679
    279a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000027a0 <__ia32_sys_wait4>:
__ia32_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1679
    27a0:	e8 00 00 00 00       	callq  27a5 <__ia32_sys_wait4+0x5>
			27a1: R_X86_64_PLT32	__fentry__-0x4
__se_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1679
    27a5:	8b 4f 68             	mov    0x68(%rdi),%ecx
    27a8:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    27ac:	8b 77 58             	mov    0x58(%rdi),%esi
    27af:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
    27b3:	e9 38 ff ff ff       	jmpq   26f0 <__do_sys_wait4>
__ia32_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1679
    27b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    27bf:	00 

00000000000027c0 <__x64_sys_waitpid>:
__x64_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1698
SYSCALL_DEFINE3(waitpid, pid_t, pid, int __user *, stat_addr, int, options)
    27c0:	e8 00 00 00 00       	callq  27c5 <__x64_sys_waitpid+0x5>
			27c1: R_X86_64_PLT32	__fentry__-0x4
__se_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1698
    27c5:	48 8b 57 60          	mov    0x60(%rdi),%rdx
__do_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1700
	return kernel_wait4(pid, stat_addr, options, NULL);
    27c9:	48 8b 77 68          	mov    0x68(%rdi),%rsi
    27cd:	31 c9                	xor    %ecx,%ecx
__se_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1698
SYSCALL_DEFINE3(waitpid, pid_t, pid, int __user *, stat_addr, int, options)
    27cf:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
__do_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1700
	return kernel_wait4(pid, stat_addr, options, NULL);
    27d3:	e9 d8 fd ff ff       	jmpq   25b0 <kernel_wait4>
__x64_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1700
    27d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    27df:	00 

00000000000027e0 <__ia32_sys_waitpid>:
__ia32_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1698
SYSCALL_DEFINE3(waitpid, pid_t, pid, int __user *, stat_addr, int, options)
    27e0:	e8 00 00 00 00       	callq  27e5 <__ia32_sys_waitpid+0x5>
			27e1: R_X86_64_PLT32	__fentry__-0x4
__se_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1698
    27e5:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    27e9:	8b 77 58             	mov    0x58(%rdi),%esi
__do_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1700
	return kernel_wait4(pid, stat_addr, options, NULL);
    27ec:	31 c9                	xor    %ecx,%ecx
__se_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1698
SYSCALL_DEFINE3(waitpid, pid_t, pid, int __user *, stat_addr, int, options)
    27ee:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
__do_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1700
	return kernel_wait4(pid, stat_addr, options, NULL);
    27f2:	e9 b9 fd ff ff       	jmpq   25b0 <kernel_wait4>
__ia32_sys_waitpid():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1700
    27f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    27fe:	00 00 

0000000000002800 <__do_compat_sys_wait4>:
__do_compat_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1711
{
    2800:	55                   	push   %rbp
    2801:	48 89 e5             	mov    %rsp,%rbp
    2804:	41 55                	push   %r13
    2806:	41 54                	push   %r12
    2808:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    280c:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
    2813:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
    281a:	00 00 
    281c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
    2823:	00 
    2824:	31 c0                	xor    %eax,%eax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1713
	long err = kernel_wait4(pid, stat_addr, options, ru ? &r : NULL);
    2826:	48 85 c9             	test   %rcx,%rcx
    2829:	74 4d                	je     2878 <__do_compat_sys_wait4+0x78>
    282b:	49 89 cd             	mov    %rcx,%r13
    282e:	48 89 e1             	mov    %rsp,%rcx
    2831:	e8 00 00 00 00       	callq  2836 <__do_compat_sys_wait4+0x36>
			2832: R_X86_64_PLT32	kernel_wait4-0x4
    2836:	49 89 c4             	mov    %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1714
	if (err > 0) {
    2839:	48 85 c0             	test   %rax,%rax
    283c:	7f 20                	jg     285e <__do_compat_sys_wait4+0x5e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1719
}
    283e:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
    2845:	00 
    2846:	65 48 33 04 25 28 00 	xor    %gs:0x28,%rax
    284d:	00 00 
    284f:	75 33                	jne    2884 <__do_compat_sys_wait4+0x84>
    2851:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
    2855:	4c 89 e0             	mov    %r12,%rax
    2858:	41 5c                	pop    %r12
    285a:	41 5d                	pop    %r13
    285c:	5d                   	pop    %rbp
    285d:	c3                   	retq   
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1715 (discriminator 1)
		if (ru && put_compat_rusage(&r, ru))
    285e:	4c 89 ee             	mov    %r13,%rsi
    2861:	48 89 e7             	mov    %rsp,%rdi
    2864:	e8 00 00 00 00       	callq  2869 <__do_compat_sys_wait4+0x69>
			2865: R_X86_64_PLT32	put_compat_rusage-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1716 (discriminator 1)
			return -EFAULT;
    2869:	85 c0                	test   %eax,%eax
    286b:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    2872:	4c 0f 45 e0          	cmovne %rax,%r12
    2876:	eb c6                	jmp    283e <__do_compat_sys_wait4+0x3e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1713
	long err = kernel_wait4(pid, stat_addr, options, ru ? &r : NULL);
    2878:	31 c9                	xor    %ecx,%ecx
    287a:	e8 00 00 00 00       	callq  287f <__do_compat_sys_wait4+0x7f>
			287b: R_X86_64_PLT32	kernel_wait4-0x4
    287f:	49 89 c4             	mov    %rax,%r12
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1714
	if (err > 0) {
    2882:	eb ba                	jmp    283e <__do_compat_sys_wait4+0x3e>
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1719
}
    2884:	e8 00 00 00 00       	callq  2889 <__do_compat_sys_wait4+0x89>
			2885: R_X86_64_PLT32	__stack_chk_fail-0x4
    2889:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000002890 <__ia32_compat_sys_wait4>:
__ia32_compat_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1706
COMPAT_SYSCALL_DEFINE4(wait4,
    2890:	e8 00 00 00 00       	callq  2895 <__ia32_compat_sys_wait4+0x5>
			2891: R_X86_64_PLT32	__fentry__-0x4
__se_compat_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1706
    2895:	8b 4f 68             	mov    0x68(%rdi),%ecx
    2898:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    289c:	8b 77 58             	mov    0x58(%rdi),%esi
    289f:	48 8b 7f 28          	mov    0x28(%rdi),%rdi
    28a3:	e9 58 ff ff ff       	jmpq   2800 <__do_compat_sys_wait4>
__ia32_compat_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1706
    28a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    28af:	00 

00000000000028b0 <__x32_compat_sys_wait4>:
__x32_compat_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1706
    28b0:	e8 00 00 00 00       	callq  28b5 <__x32_compat_sys_wait4+0x5>
			28b1: R_X86_64_PLT32	__fentry__-0x4
__se_compat_sys_wait4():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1706
    28b5:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
    28b9:	48 8b 57 60          	mov    0x60(%rdi),%rdx
    28bd:	48 8b 77 68          	mov    0x68(%rdi),%rsi
    28c1:	48 8b 7f 70          	mov    0x70(%rdi),%rdi
    28c5:	e9 36 ff ff ff       	jmpq   2800 <__do_compat_sys_wait4>

Disassembly of section .text.unlikely:

0000000000000000 <abort>:
abort():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1765
#endif

__weak void abort(void)
{
   0:	e8 00 00 00 00       	callq  5 <abort+0x5>
			1: R_X86_64_PLT32	__fentry__-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:1766
	BUG();
   5:	0f 0b                	ud2    

0000000000000007 <do_exit.cold>:
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:584
			father->signal->group_exit_code ?: father->exit_code);
   7:	48 8b 83 d8 06 00 00 	mov    0x6d8(%rbx),%rax
   e:	8b 70 60             	mov    0x60(%rax),%esi
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:583
		panic("Attempted to kill init! exitcode=0x%08x\n",
  11:	85 f6                	test   %esi,%esi
  13:	74 1f                	je     34 <do_exit.cold+0x2d>
  15:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			18: R_X86_64_32S	.rodata.str1.8+0xd8
  1c:	e8 00 00 00 00       	callq  21 <do_exit.cold+0x1a>
			1d: R_X86_64_PLT32	panic-0x4
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:785 (discriminator 1)
	WARN_ON(blk_needs_flush_plug(tsk));
  21:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			24: R_X86_64_32S	.rodata.str1.8
  28:	e8 00 00 00 00       	callq  2d <do_exit.cold+0x26>
			29: R_X86_64_PLT32	printk-0x4
  2d:	0f 0b                	ud2    
  2f:	e9 00 00 00 00       	jmpq   34 <do_exit.cold+0x2d>
			30: R_X86_64_PC32	.text+0x193c
find_child_reaper():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:583
		panic("Attempted to kill init! exitcode=0x%08x\n",
  34:	8b b3 70 04 00 00    	mov    0x470(%rbx),%esi
  3a:	eb d9                	jmp    15 <do_exit.cold+0xe>
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:790
		panic("Attempted to kill the idle task!");
  3c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			3f: R_X86_64_32S	.rodata.str1.8+0x50
  43:	e8 00 00 00 00       	callq  48 <do_exit.cold+0x41>
			44: R_X86_64_PLT32	panic-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:788
		panic("Aiee, killing interrupt handler!");
  48:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			4b: R_X86_64_32S	.rodata.str1.8+0x28
  4f:	e8 00 00 00 00       	callq  54 <do_exit.cold+0x4d>
			50: R_X86_64_PLT32	panic-0x4
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
  54:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
  5b:	00 00 
			59: R_X86_64_32S	current_task
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:839
		pr_info("note: %s[%d] exited with preempt_count %d\n",
  5d:	8b 90 d0 04 00 00    	mov    0x4d0(%rax),%edx
  63:	48 8d b0 80 06 00 00 	lea    0x680(%rax),%rsi
  6a:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			6d: R_X86_64_32S	.rodata.str1.8+0xa8
  71:	e8 00 00 00 00       	callq  76 <do_exit.cold+0x6f>
			72: R_X86_64_PLT32	printk-0x4
preempt_count_set():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:34
static __always_inline void preempt_count_set(int pc)
{
	int old, new;

	do {
		old = raw_cpu_read_4(__preempt_count);
  76:	65 8b 15 00 00 00 00 	mov    %gs:0x0(%rip),%edx        # 7d <do_exit.cold+0x76>
			79: R_X86_64_PC32	__preempt_count-0x4
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:35
		new = (old & PREEMPT_NEED_RESCHED) |
  7d:	89 d1                	mov    %edx,%ecx
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:37
			(pc & ~PREEMPT_NEED_RESCHED);
	} while (raw_cpu_cmpxchg_4(__preempt_count, old, new) != old);
  7f:	89 d0                	mov    %edx,%eax
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:35
		new = (old & PREEMPT_NEED_RESCHED) |
  81:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/preempt.h:37
	} while (raw_cpu_cmpxchg_4(__preempt_count, old, new) != old);
  87:	65 0f b1 0d 00 00 00 	cmpxchg %ecx,%gs:0x0(%rip)        # 8f <do_exit.cold+0x88>
  8e:	00 
			8b: R_X86_64_PC32	__preempt_count-0x4
  8f:	39 c2                	cmp    %eax,%edx
  91:	75 e3                	jne    76 <do_exit.cold+0x6f>
  93:	e9 00 00 00 00       	jmpq   98 <do_exit.cold+0x91>
			94: R_X86_64_PC32	.text+0x19d8
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:810
		pr_alert("Fixing recursive fault but reboot is needed!\n");
  98:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			9b: R_X86_64_32S	.rodata.str1.8+0x78
  9f:	e8 00 00 00 00       	callq  a4 <do_exit.cold+0x9d>
			a0: R_X86_64_PLT32	printk-0x4
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:820
		tsk->flags |= PF_EXITPIDONE;
  a4:	83 4b 24 08          	orl    $0x8,0x24(%rbx)
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:821
		set_current_state(TASK_UNINTERRUPTIBLE);
  a8:	48 c7 44 24 18 02 00 	movq   $0x2,0x18(%rsp)
  af:	00 00 
  b1:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
get_current():
/home/jeffrin/UP/linux-stable-rc/./arch/x86/include/asm/current.h:15
  b6:	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
  bd:	00 00 
			bb: R_X86_64_32S	current_task
do_exit():
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:821
  bf:	48 87 42 10          	xchg   %rax,0x10(%rdx)
  c3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  c8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
/home/jeffrin/UP/linux-stable-rc/kernel/exit.c:822
		schedule();
  cd:	e8 00 00 00 00       	callq  d2 <do_exit.cold+0xcb>
			ce: R_X86_64_PLT32	schedule-0x4
  d2:	e9 00 00 00 00       	jmpq   d7 <_eil_addr___x64_sys_exit+0x7>
			d3: R_X86_64_PC32	.text+0x1997

Disassembly of section .altinstr_replacement:

0000000000000000 <.altinstr_replacement>:
   0:	0f 01 cb             	stac   
   3:	0f ae f0             	mfence 
   6:	0f ae e8             	lfence 
   9:	0f 01 ca             	clac   
   c:	0f 01 ca             	clac   
   f:	0f 01 cb             	stac   
  12:	0f ae f0             	mfence 
  15:	0f ae e8             	lfence 
  18:	0f 01 ca             	clac   
  1b:	0f 01 ca             	clac   

--n8g4imXOkfNTN/H1--
