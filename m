Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F88B696CED
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBNS3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBNS3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:29:43 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637672E809
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 10:29:40 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id b1so8162172ybn.2
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 10:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/SlM87rL56jccJmLjLD6pTt8gewwZHtk9Lfqq8eDJzo=;
        b=ByI7f+xmR9BKi76Wa/CKqqPsRIOf+GohZ7Iw+mMNInS9m2L51FLkqlKXF6QPwu4Erm
         OwGHtnbcHAaOpmdEpqdC7wBiX09LgERIvazIDD5poNKNskyiK/M0v1e7BfWX4eMYMf7U
         I2kkH1iNg4dxsMkJE9k7OHHlNW51rjVuP0eUT/+qrB89Y/s2lj1VHhobvkbO67cz9OSR
         3IRfKLKW/NsnZPjIMiF7FcLWZrphA6iEymXHsyu+ZoDFH3aVkrKe22WTJS5NGeNnFnCR
         E8ffWxqSxZmhu/MQ6F0PZIrrF/Jm8AcOTLyW7fuXr7DB8+uB7BMp4vRUhGO1A7JgTBzG
         4vpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/SlM87rL56jccJmLjLD6pTt8gewwZHtk9Lfqq8eDJzo=;
        b=bS2IbddoQtCVOUBuMxR4A2HkndAj26AEMoXDoCtjFDKrAjyLqSyksrttZyx1QvTg1h
         a/9lpKahjrdSF3zDJYGXPWiFvXSj81z4JyB08VfrxSSEoMVNoNTp/dAL9TamwvQ+0jSr
         +3t6w0Crwql3Fm+t5W3oz6sf9X1KQwm3YuKo2zOrqWoUqggXlFWeN1c4cRVbb+Tpl7RC
         ojyxYxyxguECBYLqBcdonBzKG6UJNQAO1Em4RRymrMhoV4yPccqawvcyUost3zeHbexK
         Mx1CNoco7hJy3YJp/Z+60TffKTWrkj3G853uuCyZvoO7MvRcd0Xsnf5o7tvcjJimB/Dx
         McTQ==
X-Gm-Message-State: AO0yUKV9SKXBRr8AlC1WGojP8ReMGirZLQX4SCSgF+bgmiQ2vczYtTG+
        2sO9jkPGj8RgAn3nBuETEPGGe3JyXSOfQSOkj/RQgg==
X-Google-Smtp-Source: AK7set/RQifId3+U+Ef+RNudtbMOC6rMvxl7BSMB5lhMb7vx0iw6fZCsAUo6JgnOSCLyXjhfZMxKnfrP5WeO/seS6s0=
X-Received: by 2002:a25:9709:0:b0:921:6df4:c136 with SMTP id
 d9-20020a259709000000b009216df4c136mr357279ybo.201.1676399379141; Tue, 14 Feb
 2023 10:29:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpGiktjjPZYPp8LNtbmvYhkxh_icEWXOVgsq9qeq+w6s+g@mail.gmail.com>
 <20230214181335.3946674-1-kamatam@amazon.com> <CAJuCfpFe+K4wHJzB-4JHr-5_2Scifx-WPwAi9SbBz5JAu5cmyQ@mail.gmail.com>
In-Reply-To: <CAJuCfpFe+K4wHJzB-4JHr-5_2Scifx-WPwAi9SbBz5JAu5cmyQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 14 Feb 2023 10:29:27 -0800
Message-ID: <CAJuCfpGyPkGVWc3Go5XDPW-aJZcuGK_W2J+LPP4MfHTqaUiQQQ@mail.gmail.com>
Subject: Re: [PATCH v3] sched/psi: fix use-after-free in ep_remove_wait_queue()
To:     Munehisa Kamata <kamatam@amazon.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     ebiggers@kernel.org, hannes@cmpxchg.org, hdanton@sina.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 10:28 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Tue, Feb 14, 2023 at 10:13 AM Munehisa Kamata <kamatam@amazon.com> wrote:
> >
> > If a non-root cgroup gets removed when there is a thread that registered
> > trigger and is polling on a pressure file within the cgroup, the polling
> > waitqueue gets freed in the following path.
> >
> >  do_rmdir
> >    cgroup_rmdir
> >      kernfs_drain_open_files
> >        cgroup_file_release
> >          cgroup_pressure_release
> >            psi_trigger_destroy
> >
> > However, the polling thread still has a reference to the pressure file and
> > will access the freed waitqueue when the file is closed or upon exit.
> >
> >  fput
> >    ep_eventpoll_release
> >      ep_free
> >        ep_remove_wait_queue
> >          remove_wait_queue
> >
> > This results in use-after-free as pasted below.
> >
> > The fundamental problem here is that cgroup_file_release() (and
> > consequently waitqueue's lifetime) is not tied to the file's real lifetime.
> > Using wake_up_pollfree() here might be less than ideal, but it also is not
> > fully contradicting the comment at commit 42288cb44c4b ("wait: add
> > wake_up_pollfree()") since the waitqueue's lifetime is not tied to file's
> > one and can be considered as another special case. While this would be
> > fixable by somehow making cgroup_file_release() be tied to the fput(), it
> > would require sizable refactoring at cgroups or higher layer which might be
> > more justifiable if we identify more cases like this.
> >
> >  BUG: KASAN: use-after-free in _raw_spin_lock_irqsave+0x60/0xc0
> >  Write of size 4 at addr ffff88810e625328 by task a.out/4404
> >
> >  CPU: 19 PID: 4404 Comm: a.out Not tainted 6.2.0-rc6 #38
> >  Hardware name: Amazon EC2 c5a.8xlarge/, BIOS 1.0 10/16/2017
> >  Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x73/0xa0
> >  print_report+0x16c/0x4e0
> >  ? _printk+0x59/0x80
> >  ? __virt_addr_valid+0xb8/0x130
> >  ? _raw_spin_lock_irqsave+0x60/0xc0
> >  kasan_report+0xc3/0xf0
> >  ? _raw_spin_lock_irqsave+0x60/0xc0
> >  kasan_check_range+0x2d2/0x310
> >  _raw_spin_lock_irqsave+0x60/0xc0
> >  remove_wait_queue+0x1a/0xa0
> >  ep_free+0x12c/0x170
> >  ep_eventpoll_release+0x26/0x30
> >  __fput+0x202/0x400
> >  task_work_run+0x11d/0x170
> >  do_exit+0x495/0x1130
> >  ? update_cfs_rq_load_avg+0x2c2/0x2e0
> >  do_group_exit+0x100/0x100
> >  get_signal+0xd67/0xde0
> >  ? finish_task_switch+0x15f/0x3a0
> >  arch_do_signal_or_restart+0x2a/0x2b0
> >  exit_to_user_mode_prepare+0x94/0x100
> >  syscall_exit_to_user_mode+0x20/0x40
> >  do_syscall_64+0x52/0x90
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >  RIP: 0033:0x7f8e392bfb91
> >  Code: Unable to access opcode bytes at 0x7f8e392bfb67.
> >  RSP: 002b:00007fff261e08d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000022
> >  RAX: fffffffffffffdfe RBX: 0000000000000000 RCX: 00007f8e392bfb91
> >  RDX: 0000000000000001 RSI: 00007fff261e08e8 RDI: 0000000000000004
> >  RBP: 00007fff261e0920 R08: 0000000000400780 R09: 00007f8e3960f240
> >  R10: 00000000000003df R11: 0000000000000246 R12: 00000000004005a0
> >  R13: 00007fff261e0a00 R14: 0000000000000000 R15: 0000000000000000
> >  </TASK>
> >
> >  Allocated by task 4404:
> >  kasan_set_track+0x3d/0x60
> >  __kasan_kmalloc+0x85/0x90
> >  psi_trigger_create+0x113/0x3e0
> >  pressure_write+0x146/0x2e0
> >  cgroup_file_write+0x11c/0x250
> >  kernfs_fop_write_iter+0x186/0x220
> >  vfs_write+0x3d8/0x5c0
> >  ksys_write+0x90/0x110
> >  do_syscall_64+0x43/0x90
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> >  Freed by task 4407:
> >  kasan_set_track+0x3d/0x60
> >  kasan_save_free_info+0x27/0x40
> >  ____kasan_slab_free+0x11d/0x170
> >  slab_free_freelist_hook+0x87/0x150
> >  __kmem_cache_free+0xcb/0x180
> >  psi_trigger_destroy+0x2e8/0x310
> >  cgroup_file_release+0x4f/0xb0
> >  kernfs_drain_open_files+0x165/0x1f0
> >  kernfs_drain+0x162/0x1a0
> >  __kernfs_remove+0x1fb/0x310
> >  kernfs_remove_by_name_ns+0x95/0xe0
> >  cgroup_addrm_files+0x67f/0x700
> >  cgroup_destroy_locked+0x283/0x3c0
> >  cgroup_rmdir+0x29/0x100
> >  kernfs_iop_rmdir+0xd1/0x140
> >  vfs_rmdir+0xfe/0x240
> >  do_rmdir+0x13d/0x280
> >  __x64_sys_rmdir+0x2c/0x30
> >  do_syscall_64+0x43/0x90
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > v3: updated commit message and the comment in the code
> > v2: updated commit message
> >
> > Link: https://lore.kernel.org/lkml/20230106224859.4123476-1-kamatam@amazon.com/
> > Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> > Signed-off-by: Mengchi Cheng <mengcc@amazon.com>
>

Acked-by: Suren Baghdasaryan <surenb@google.com>

CC'ing PeterZ directly for inclusion into his tree.

>
> > ---
> >  kernel/sched/psi.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > index 8ac8b81bfee6..02e011cabe91 100644
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
> >
> >         group = t->group;
> >         /*
> > -        * Wakeup waiters to stop polling. Can happen if cgroup is deleted
> > -        * from under a polling process.
> > +        * Wakeup waiters to stop polling and clear the queue to prevent it from
> > +        * being accessed later. Can happen if cgroup is deleted from under a
> > +        * polling process.
> >          */
> > -       wake_up_interruptible(&t->event_wait);
> > +       wake_up_pollfree(&t->event_wait);
> >
> >         mutex_lock(&group->trigger_lock);
> >
> > --
> > 2.38.1
> >
