Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2A5E77F9
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 12:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiIWKKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 06:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiIWKKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 06:10:31 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5238410F702;
        Fri, 23 Sep 2022 03:10:28 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3378303138bso126811037b3.9;
        Fri, 23 Sep 2022 03:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KHwdpEvOx7gVgi3OOaFkocFydR4YH+tf96jUOZ54ZC8=;
        b=MOfzZdAtnOrddbif5UM03puYUJ2xZNbYEXgfaOA/TrtbsYxCZthqtPW1+Tmd9mCNNR
         IinHaJ9tK3A8toUCGoMDnhD9I2CkgRKSFm9oEKHN+iurdhErR6netHkFBZams96NfU1X
         3PjB7H+gEP8qFUDteVoJdgPI5ExyfAoBw4AKm+YZpjlgILn1NWUj0ZCri4WLrU5s3aaE
         KlXaqITkl5cCevB0/IczeD5O6+eEHFPM0ErXw04hAfracYxKl+Pw0uu+AeQuHyQm9n/s
         hIVXLNvAUpR3yX1v8kSThHyVDuRMWI7ToiGzkp4DyCvy/L3b0juyorJpYt9sTr6lDEeB
         7o9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KHwdpEvOx7gVgi3OOaFkocFydR4YH+tf96jUOZ54ZC8=;
        b=ETSOswhTg65U78f8OVOxaMTVUrNuM83IyLenGFFu0sSt3xMlsTnOXCDpkWfK0aUPwK
         SzY2ol8jykhFF/0DTbnIQvE9ncYMzjm/l0Ww3e6f6IYeGLuLjrPbhW6PiX94CBqWXVVs
         d67P4bjhiHCAy3fMBsxMbVpC6rn5AscM9WmUVxQItqbHi+8SBn+pxj02Y08BOaTyGO1L
         InWsXPh3I4o5VK/B/+rGH/0EAKzVdKWxAVe4C0QwK7dDFoJYFT3HLuUHDSbbEX3JA4MP
         0f2/1HzdHEALA4Kgg2AI0j/61poYzps0Xo1W/wz12oeUHH9fIKgnpVb8TxbHP5W8iwrC
         z5uQ==
X-Gm-Message-State: ACrzQf01Fyv00X74jm0GkTH6VBD0tNsgFjJjwBoVFyYt1g8xDQlNBGYs
        saLXp3VH0G98M1l02aExkBgGwXodFRnXzO+I93c=
X-Google-Smtp-Source: AMsMyM67iiYBDFck8lbsxqi6yDBwVgDc9EFgKUL6juPYQqcT0Z6xPPFTQXCdw9sWl0DkBJhAPCpHHOjfFY5tVSUekz8=
X-Received: by 2002:a81:6e45:0:b0:349:ef9c:123b with SMTP id
 j66-20020a816e45000000b00349ef9c123bmr7588236ywc.104.1663927826846; Fri, 23
 Sep 2022 03:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <b7aa8d89-09cb-4fd3-a74c-2742a7254b82n@googlegroups.com>
 <CACT4Y+b6pVopdR9cASZOza3zx=fKqEBCOKE2NfOuV3nC9Oc95w@mail.gmail.com> <29071f9e-8cd8-424f-b149-243a09890942n@googlegroups.com>
In-Reply-To: <29071f9e-8cd8-424f-b149-243a09890942n@googlegroups.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 23 Sep 2022 12:10:16 +0200
Message-ID: <CAKXUXMxzLQgjFhps9XreqO3OZW_D2CHDHen0XqmYMXc=aT8Kpg@mail.gmail.com>
Subject: Re: WARNING in dev_watchdog with 5.19 kernel
To:     Tushar Vyavahare <tush133@gmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        gregkh@linuxfoundation.org,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tushar, this is most likely not going to reach anyone either.

The linux-kernel mailing list is a general kernel-related mailing
list, but it is unlikely to reach the one person (the one group of
people) you would like to reach with your mail.

Greg KH is the stable maintainer, but not the "bugfixing maintainer
for all bugs in stable". The bugs are fixed in mainline; Greg KH only
takes care that reported backports are properly collected and released
in timely manner.

You need to figure out which subsystem this bug report shall be forwarded to.

Generally, you will probably get very little feedback by others:

- The kernel has been exposed to fuzzing for many years by now---if I
recall correctly, syzkaller/syzbot has been running and reporting
since 2017 or even before.
- There is a long list of known issues with C reproducers that have
not been fixed. They are probably of higher interest to the kernel
developers.
- There is a similarly long list of reports without reproducers. These
are difficult to analyze and fix. It is difficult to trigger, bisect,
confirm a fix etc.
- So far, we do not know if your report without a reproducer is yet
another duplicate of the long list.
- Fuzzing reports are not identical to bugs reported by real users. We
simply do not know if the sequence you triggered is in any way
sensible for a real user to come up with.
- We do not know even some basic information precisely enough to guide
you to some next steps in your work to make others consider looking at
the report.

I can only advise you to understand how to report issues in the kernel
community before continuing to report something you identified with
fuzzing, and learn how others in this community have successfully
reported something they identified with fuzzing and why some types of
reports are just better to be ignored by others.

Anyway, thanks for trying out syzkaller and good luck for the future.


Lukas

On Fri, Sep 23, 2022 at 11:27 AM Tushar Vyavahare <tush133@gmail.com> wrote:
>
>
>
> ---------- Forwarded message ---------
> From: dvy...@google.com <dvyukov@google.com>
> Date: Friday, September 23, 2022 at 2:46:18 PM UTC+5:30
> Subject: Re: WARNING in dev_watchdog with 5.19 kernel
> To: Tushar Vyavahare <tush133@gmail.com>
> Cc: syzkaller <syzkaller@googlegroups.com>
>
>
> On Fri, 23 Sept 2022 at 11:09, Tushar Vyavahare <tus...@gmail.com> wrote:
> >
> > Hi,
> >
> > I've got the following error report while fuzzing the kernel with syzkaller(added custom driver as a part of it).
> > Kernel Version: V5.19 standard
> > Unfortunately, I dont have reproducible program for it.
>
> Hi Tushar,
>
> There are no kernel developers on syzkaller mailing list. You need to
> report this to the kernel mailing lists.
>
>
> > -----------[ cut here ]-----------
> > NETDEV WATCHDOG: eth0 (e1000): transmit queue 0 timed out
> > WARNING: CPU: 1 PID: 1869 at net/sched/sch_generic.c:525 dev_watchdog+0x79b/0x8f0 net/sched/sch_generic.c:525
> > Modules linked in:
> > CPU: 1 PID: 1869 Comm: syz-executor.21 Not tainted 6.0.0-rc3-00107-g42e66b1cc3a0-dirty #2
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > RIP: 0010:dev_watchdog+0x79b/0x8f0 net/sched/sch_generic.c:525
> > Code: b4 c9 fd 48 8b 1c 24 c6 05 07 8a 94 02 01 48 89 df e8 49 18 ea ff 89 e9 48 89 de 48 c7 c7 e0 17 e3 84 48 89 c2 e8 f3 fe a8 00 <0f> 0b e9 7d fd ff ff e8 29 b4 c9 fd 0f 0b e9 18 fd ff ff 48 c7 c7
> > RSP: 0018:ffffc900001e8cc0 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: ffff8880113f0000 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffff88805d4f8000 RDI: fffff5200003d18a
> > RBP: 0000000000000000 R08: ffffffff812c7328 R09: 0000000000000000
> > R10: 0000000000000005 R11: ffffed100d954ef1 R12: 0000000000000001
> > R13: ffff8880113f04c8 R14: ffff88800cb42000 R15: ffff8880113f03e0
> > FS: 0000555555af8980(0000) GS:ffff88806ca80000(0000) knlGS:0000000000000000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007ffc02e6cbd8 CR3: 000000005d465000 CR4: 0000000000150ee0
> > Call Trace:
> > <IRQ>
> > call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> > expire_timers kernel/time/timer.c:1519 [inline]
> > __run_timers.part.0+0x69c/0xad0 kernel/time/timer.c:1790
> > __run_timers kernel/time/timer.c:1768 [inline]
> > run_timer_softirq+0xb6/0x1d0 kernel/time/timer.c:1803
> > __do_softirq+0x1c7/0x921 kernel/softirq.c:571
> > invoke_softirq kernel/softirq.c:445 [inline]
> > __irq_exit_rcu kernel/softirq.c:650 [inline]
> > irq_exit_rcu+0xe2/0x120 kernel/softirq.c:662
> > sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1106
> > </IRQ>
> > <TASK>
> > asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
> > RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
> > RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x40 kernel/kcov.c:199
> > Code: cc bc 7e 81 e2 00 01 ff 00 75 10 65 48 8b 04 25 c0 6e 02 00 48 8b 80 b0 14 00 00 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 <65> 48 8b 0c 25 c0 6e 02 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8
> > RSP: 0018:ffffc900026ff8e0 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000200 RCX: ffff88805d4f8000
> > RDX: 0000000000000000 RSI: ffff88805d4f8000 RDI: 0000000000000002
> > RBP: ffffc900026ff9f8 R08: ffffffff818dcb2b R09: 0000000000000000
> > R10: 0000000000000007 R11: fffffbfff0ffb4e5 R12: 0000000000000000
> > R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> > __seqprop_spinlock_sequence include/linux/seqlock.h:275 [inline]
> > read_seqbegin include/linux/seqlock.h:836 [inline]
> > read_seqbegin_or_lock include/linux/seqlock.h:1140 [inline]
> > read_seqbegin_or_lock include/linux/seqlock.h:1137 [inline]
> > prepend_path.isra.0+0x3a1/0xdd0 fs/d_path.c:170
> > d_absolute_path+0xf3/0x1a0 fs/d_path.c:233
> > tomoyo_get_absolute_path security/tomoyo/realpath.c:101 [inline]
> > tomoyo_realpath_from_path+0x282/0x620 security/tomoyo/realpath.c:276
> > tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
> > tomoyo_path_perm+0x219/0x420 security/tomoyo/file.c:822
> > tomoyo_path_unlink+0x8e/0xd0 security/tomoyo/tomoyo.c:149
> > security_path_unlink+0xd7/0x150 security/security.c:1173
> > do_unlinkat+0x36c/0x660 fs/namei.c:4293
> > __do_sys_unlink fs/namei.c:4345 [inline]
> > __se_sys_unlink fs/namei.c:4343 [inline]
> > __x64_sys_unlink+0x3e/0x50 fs/namei.c:4343
> > do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f4ebd9af2cb
> > ================================
> > WARNING: inconsistent lock state
> > 6.0.0-rc3-00107-g42e66b1cc3a0-dirty #2 Not tainted
> > --------------------------------
> > inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> > syz-executor.21/1869 [HC0[0]:SC1[1]:HE1:SE0] takes:
> > ffffffff857877b8 (vmap_area_lock){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
> > ffffffff857877b8 (vmap_area_lock){+.?.}-{2:2}, at: find_vmap_area+0x1c/0x130 mm/vmalloc.c:1836 {SOFTIRQ-ON-W}
> >
> > state was registered at:
> > lock_acquire kernel/locking/lockdep.c:5666 [inline]
> > lock_acquire+0x1ab/0x580 kernel/locking/lockdep.c:5631
> > __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
> > _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
> > spin_lock include/linux/spinlock.h:349 [inline]
> > alloc_vmap_area mm/vmalloc.c:1617 [inline]
> > alloc_vmap_area+0xa05/0x1e30 mm/vmalloc.c:1569
> > __get_vm_area_node+0x142/0x3f0 mm/vmalloc.c:2484
> > get_vm_area_caller+0x43/0x50 mm/vmalloc.c:2537
> > __ioremap_caller.constprop.0+0x32d/0x600 arch/x86/mm/ioremap.c:280
> > acpi_os_ioremap include/acpi/acpi_io.h:13 [inline]
> > acpi_map drivers/acpi/osl.c:296 [inline]
> > acpi_os_map_iomem+0x463/0x550 drivers/acpi/osl.c:355
> > acpi_tb_acquire_table+0xd8/0x209 drivers/acpi/acpica/tbdata.c:142
> > acpi_tb_validate_table drivers/acpi/acpica/tbdata.c:317 [inline]
> > acpi_tb_validate_table+0x50/0x8c drivers/acpi/acpica/tbdata.c:308
> > acpi_tb_verify_temp_table+0x84/0x674 drivers/acpi/acpica/tbdata.c:504
> > acpi_reallocate_root_table+0x374/0x3e0 drivers/acpi/acpica/tbxface.c:180
> > acpi_early_init+0x13a/0x438 drivers/acpi/bus.c:1214
> > start_kernel+0x3d4/0x494 init/main.c:1099
> > secondary_startup_64_no_verify+0xce/0xdb
> > irq event stamp: 53942274
> > hardirqs last enabled at (53942274): [<ffffffff812c0d1e>] __up_console_sem+0xae/0xc0 kernel/printk/printk.c:264
> > hardirqs last disabled at (53942273): [<ffffffff812c0d03>] __up_console_sem+0x93/0xc0 kernel/printk/printk.c:262
> > softirqs last enabled at (53940998): [<ffffffff8109bec6>] fpu_clone+0x396/0xf90 arch/x86/kernel/fpu/core.c:608
> > softirqs last disabled at (53941505): [<ffffffff81164212>] invoke_softirq kernel/softirq.c:445 [inline]
> > softirqs last disabled at (53941505): [<ffffffff81164212>] __irq_exit_rcu kernel/softirq.c:650 [inline]
> > softirqs last disabled at (53941505): [<ffffffff81164212>] irq_exit_rcu+0xe2/0x120 kernel/softirq.c:662
> > other info that might help us debug this:
> > Possible unsafe locking scenario:
> > CPU0
> > ----
> > lock(vmap_area_lock);
> > <Interrupt>
> > lock(vmap_area_lock);
> > *** DEADLOCK ***
> > 7 locks held by syz-executor.21/1869:
> > #0: ffff8880114fe438 (sb_writers#4){..}-{0:0}, at: do_unlinkat+0x17f/0x660 fs/namei.c:4276
> > #1: ffff888018304990 (&type->i_mutex_dir_key#3/1){..}-{3:3}, at: inode_lock_nested include/linux/fs.h:791 [inline]
> > #1: ffff888018304990 (&type->i_mutex_dir_key#3/1){..}-{3:3}, at: do_unlinkat+0x26c/0x660 fs/namei.c:4280
> > #2: ffffffff8591c728 (tomoyo_ss){....}-{0:0}, at: tomoyo_path_perm+0x1c1/0x420 security/tomoyo/file.c:847
> > #3: ffffffff85695b20 (rcu_read_lock){....}-{1:2}, at: prepend_path.isra.0+0x0/0xdd0 fs/d_path.c:368
> > #4: ffffffff85695b20 (rcu_read_lock){....}-{1:2}, at: read_seqbegin include/linux/seqlock.h:840 [inline]
> > #4: ffffffff85695b20 (rcu_read_lock){....}-{1:2}, at: read_seqbegin_or_lock include/linux/seqlock.h:1140 [inline]
> > #4: ffffffff85695b20 (rcu_read_lock){....}-{1:2}, at: read_seqbegin_or_lock include/linux/seqlock.h:1137 [inline]
> > #4: ffffffff85695b20 (rcu_read_lock){....}-{1:2}, at: prepend_path.isra.0+0x254/0xdd0 fs/d_path.c:165
> > #5: ffffc900001e8d68 ((&dev->watchdog_timer)){+..}{0:0}, at: lockdep_copy_map include/linux/lockdep.h:31 [inline]
> > #5: ffffc900001e8d68 ((&dev->watchdog_timer)){+..}{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1464
> > #6: ffff8880113f03f8 (&dev->tx_global_lock){+..}{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
> > #6: ffff8880113f03f8 (&dev->tx_global_lock){+..}{2:2}, at: dev_watchdog+0x30/0x8f0 net/sched/sch_generic.c:500
> > stack backtrace:
> > CPU: 1 PID: 1869 Comm: syz-executor.21 Not tainted 6.0.0-rc3-00107-g42e66b1cc3a0-dirty #2
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > Call Trace:
> > <IRQ>
> > __dump_stack lib/dump_stack.c:88 [inline]
> > dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> > print_usage_bug kernel/locking/lockdep.c:3961 [inline]
> > valid_state kernel/locking/lockdep.c:3973 [inline]
> > mark_lock_irq kernel/locking/lockdep.c:4176 [inline]
> > mark_lock.part.0.cold+0x19/0x46 kernel/locking/lockdep.c:4632
> > mark_lock kernel/locking/lockdep.c:4596 [inline]
> > mark_usage kernel/locking/lockdep.c:4527 [inline]
> > __lock_acquire+0x139f/0x5830 kernel/locking/lockdep.c:5007
> > lock_acquire kernel/locking/lockdep.c:5666 [inline]
> > lock_acquire+0x1ab/0x580 kernel/locking/lockdep.c:5631
> > __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
> > _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
> > spin_lock include/linux/spinlock.h:349 [inline]
> > find_vmap_area+0x1c/0x130 mm/vmalloc.c:1836
> > check_heap_object mm/usercopy.c:176 [inline]
> > __check_object_size mm/usercopy.c:250 [inline]
> > __check_object_size+0x1f8/0x700 mm/usercopy.c:212
> > check_object_size include/linux/thread_info.h:199 [inline]
> > __copy_from_user_inatomic include/linux/uaccess.h:62 [inline]
> > copy_from_user_nmi arch/x86/lib/usercopy.c:47 [inline]
> > copy_from_user_nmi+0xcb/0x130 arch/x86/lib/usercopy.c:31
> > copy_code arch/x86/kernel/dumpstack.c:91 [inline]
> > show_opcodes+0x5b/0xb0 arch/x86/kernel/dumpstack.c:121
> > show_iret_regs+0xd/0x33 arch/x86/kernel/dumpstack.c:149
> > __show_regs+0x1e/0x60 arch/x86/kernel/process_64.c:74
> > show_trace_log_lvl+0x265/0x2bb arch/x86/kernel/dumpstack.c:292
> > __warn+0xe2/0x190 kernel/panic.c:621
> > report_bug+0x272/0x300 lib/bug.c:198
> > handle_bug+0x3c/0x60 arch/x86/kernel/traps.c:316
> > exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:336
> > asm_exc_invalid_op+0x16/0x20 arch/x86/include/asm/idtentry.h:568
> > RIP: 0010:dev_watchdog+0x79b/0x8f0 net/sched/sch_generic.c:525
> > Code: b4 c9 fd 48 8b 1c 24 c6 05 07 8a 94 02 01 48 89 df e8 49 18 ea ff 89 e9 48 89 de 48 c7 c7 e0 17 e3 84 48 89 c2 e8 f3 fe a8 00 <0f> 0b e9 7d fd ff ff e8 29 b4 c9 fd 0f 0b e9 18 fd ff ff 48 c7 c7
> > RSP: 0018:ffffc900001e8cc0 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: ffff8880113f0000 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffff88805d4f8000 RDI: fffff5200003d18a
> > RBP: 0000000000000000 R08: ffffffff812c7328 R09: 0000000000000000
> > R10: 0000000000000005 R11: ffffed100d954ef1 R12: 0000000000000001
> > R13: ffff8880113f04c8 R14: ffff88800cb42000 R15: ffff8880113f03e0
> > call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> > expire_timers kernel/time/timer.c:1519 [inline]
> > __run_timers.part.0+0x69c/0xad0 kernel/time/timer.c:1790
> > __run_timers kernel/time/timer.c:1768 [inline]
> > run_timer_softirq+0xb6/0x1d0 kernel/time/timer.c:1803
> > __do_softirq+0x1c7/0x921 kernel/softirq.c:571
> > invoke_softirq kernel/softirq.c:445 [inline]
> > __irq_exit_rcu kernel/softirq.c:650 [inline]
> > irq_exit_rcu+0xe2/0x120 kernel/softirq.c:662
> > sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1106
> > </IRQ>
> > <TASK>
> > asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
> > RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
> > RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x40 kernel/kcov.c:199
> > Code: cc bc 7e 81 e2 00 01 ff 00 75 10 65 48 8b 04 25 c0 6e 02 00 48 8b 80 b0 14 00 00 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 <65> 48 8b 0c 25 c0 6e 02 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8
> > RSP: 0018:ffffc900026ff8e0 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000200 RCX: ffff88805d4f8000
> > RDX: 0000000000000000 RSI: ffff88805d4f8000 RDI: 0000000000000002
> > RBP: ffffc900026ff9f8 R08: ffffffff818dcb2b R09: 0000000000000000
> > R10: 0000000000000007 R11: fffffbfff0ffb4e5 R12: 0000000000000000
> > R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> > __seqprop_spinlock_sequence include/linux/seqlock.h:275 [inline]
> > read_seqbegin include/linux/seqlock.h:836 [inline]
> > read_seqbegin_or_lock include/linux/seqlock.h:1140 [inline]
> > read_seqbegin_or_lock include/linux/seqlock.h:1137 [inline]
> > prepend_path.isra.0+0x3a1/0xdd0 fs/d_path.c:170
> > d_absolute_path+0xf3/0x1a0 fs/d_path.c:233
> > tomoyo_get_absolute_path security/tomoyo/realpath.c:101 [inline]
> > tomoyo_realpath_from_path+0x282/0x620 security/tomoyo/realpath.c:276
> > tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
> > tomoyo_path_perm+0x219/0x420 security/tomoyo/file.c:822
> > tomoyo_path_unlink+0x8e/0xd0 security/tomoyo/tomoyo.c:149
> > security_path_unlink+0xd7/0x150 security/security.c:1173
> > do_unlinkat+0x36c/0x660 fs/namei.c:4293
> > __do_sys_unlink fs/namei.c:4345 [inline]
> > __se_sys_unlink fs/namei.c:4343 [inline]
> > __x64_sys_unlink+0x3e/0x50 fs/namei.c:4343
> > do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f4ebd9af2cb
> > Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffc02e6d318 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4ebd9af2cb
> > RDX: 00007ffc02e6d350 RSI: 00007ffc02e6d350 RDI: 00007ffc02e6d3e0
> > RBP: 00007ffc02e6d3e0 R08: 0000000000000001 R09: 00007ffc02e6d1a0
> > R10: 00000000fffffff8 R11: 0000000000000206 R12: 00007f4ebda1b3ff
> > R13: 00007ffc02e6e480 R14: 0000555555afa080 R15: 0000000000000032
> > </TASK>
> > Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffc02e6d318 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4ebd9af2cb
> > RDX: 00007ffc02e6d350 RSI: 00007ffc02e6d350 RDI: 00007ffc02e6d3e0
> > RBP: 00007ffc02e6d3e0 R08: 0000000000000001 R09: 00007ffc02e6d1a0
> > R10: 00000000fffffff8 R11: 0000000000000206 R12: 00007f4ebda1b3ff
> > R13: 00007ffc02e6e480 R14: 0000555555afa080 R15: 0000000000000032
> > </TASK>
> > ----------------
> > Code disassembly (best guess):
> > 0: cc int3
> > 1: bc 7e 81 e2 00 mov $0xe2817e,%esp
> > 6: 01 ff add %edi,%edi
> > 8: 00 75 10 add %dh,0x10(%rbp)
> > b: 65 48 8b 04 25 c0 6e mov %gs:0x26ec0,%rax
> > 12: 02 00
> > 14: 48 8b 80 b0 14 00 00 mov 0x14b0(%rax),%rax
> > 1b: c3 retq
> > 1c: 66 66 2e 0f 1f 84 00 data16 nopw %cs:0x0(%rax,%rax,1)
> > 23: 00 00 00 00
> > 27: 0f 1f 00 nopl (%rax)
> >
> > 2a: 65 48 8b 0c 25 c0 6e mov %gs:0x26ec0,%rcx <-- trapping instruction
> > 31: 02 00
> > 33: bf 02 00 00 00 mov $0x2,%edi
> > 38: 48 89 ce mov %rcx,%rsi
> > 3b: 4c 8b 04 24 mov (%rsp),%r8
> > 3f: e8 .byte 0xe8
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+...@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/b7aa8d89-09cb-4fd3-a74c-2742a7254b82n%40googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/29071f9e-8cd8-424f-b149-243a09890942n%40googlegroups.com.
