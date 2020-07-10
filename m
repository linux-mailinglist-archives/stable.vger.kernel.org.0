Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A9B21AE11
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 06:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgGJE3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 00:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgGJE3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 00:29:09 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBBBC08C5DC
        for <stable@vger.kernel.org>; Thu,  9 Jul 2020 21:29:09 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id c11so2432581lfh.8
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 21:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjMEHo8189HJa7MEyvNdBopJi1aBYqswf36F3ZzUmHE=;
        b=zJ6DbLIMI9RS1PmJSJo6xFsTDH6O8QB//0z7B26kKdSld9NfBya8Rtu3IZ074XA+CR
         PguXCBuyQSrp48FDSdtpHC7sXpIeoytzCn4yZJuMc4a+HhVuBhkF65tWkHci0v9jDyUp
         3fl2+D4AVaXwcR1us0SK9O6PhX8yo08LWb6Mxp+3I4gmL5zBBb3qeS/YuWiuhbm4s8Xs
         7ksKitvvtr6ndfV5SLJDDI7VIU+LC2QXgmVFC8XA8RoGWoMj9/yHZ4lepjWHA0Xo6Nft
         SUxflY6EifOYbS7WQHtSt2iGPYeDGj2yyPGJyFWP7+NMTKzk4hkjYkEiZMyAFMVSkByI
         D5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjMEHo8189HJa7MEyvNdBopJi1aBYqswf36F3ZzUmHE=;
        b=AgBtcxpJ4KpQsdz5PYhmKHaWd5JfwhqLVtebsr1cjbH1G4Zp/GKqHXaiFDoxM2O/8O
         /rOCBVw+FNB0T0BPKfqEL3guxM6p+88P+Dhi4kc4LkzJIrB3IOwpD/e+MN+eoo1INPYH
         HcM3aVt9/d0n2Xn5dI6mlmste6u7jBa1sHomjhYVFWZdQltQUNfPOsRAvoN/DtM3gyHm
         2ETBm3ibdsf4A/Mk/6HzUCZ37Sg9TvFje9xl0d3UQHDLvmWyEATaKafLQhbVlt6kMUZL
         S3YsJogQIlyJ3acyvMRmVhdNt2JK7uFFTkpzex8NmO08XvtuOeLald9+xtTeL/ASvmS8
         05iQ==
X-Gm-Message-State: AOAM533CY9ZrUh6gUpFo0G07M8l+IluxwOiUpzC6NkaYujkwrz8UxofB
        4L39bQlOjzX4qzz1InGN0SmiHogOyY0s87xH7uxSug==
X-Google-Smtp-Source: ABdhPJybWciRrhe576e0XFkP5ZOq4e0ax7CtRCdKFW0nOqW2ctV9r+kQAZVIQT05SbrSdysuc/SYrSucY8LQCyzy0w0=
X-Received: by 2002:ac2:5226:: with SMTP id i6mr42252318lfl.55.1594355347306;
 Thu, 09 Jul 2020 21:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
In-Reply-To: <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 10 Jul 2020 09:58:55 +0530
Message-ID: <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Jul 2020 at 00:42, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Jul 8, 2020 at 10:28 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > While running LTP mm test suite on i386 or qemu_i386 this kernel warning
> > has been noticed from stable 5.4 to stable 5.7 branches and mainline 5.8.0-rc4
> > and linux next.
>
> Hmm
>
> If this is repeatable, would you mind making the warning also print
> out the old range and new addresses and pmd value?

Your patch applied and re-tested.
warning triggered 10 times.

old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)

Here is the crash output log,
thp01.c:98: PASS: system didn't crash.
[  741.507000] ------------[ cut here ]------------
[  741.511684] WARNING: CPU: 1 PID: 15173 at mm/mremap.c:211
move_page_tables.cold+0x0/0x2b
[  741.519812] Modules linked in: x86_pkg_temp_thermal fuse
[  741.525163] CPU: 1 PID: 15173 Comm: true Not tainted 5.8.0-rc4 #1
[  741.531313] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  741.538760] EIP: move_page_tables.cold+0x0/0x2b
[  741.543337] Code: b1 a0 03 00 00 81 c1 cc 04 00 00 bb ea ff ff ff
51 68 e0 bc 68 d8 c6 05 dc 29 97 d8 01 e8 13 26 e9 ff 83 c4 0c e9 70
ea ff ff <0f> 0b 52 50 ff 75 08 ff 75 b4 ff 75 d4 68 3c bd 68 d8 e8 f4
25 e9
[  741.562140] EAX: 7d530067 EBX: e9c90ff8 ECX: 00000000 EDX: 00000000
[  741.568456] ESI: 00000000 EDI: 7d5ba007 EBP: cef67dd0 ESP: cef67d28
[  741.574776] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  741.581623] CR0: 80050033 CR2: b7d53f50 CR3: 107da000 CR4: 003406f0
[  741.587941] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  741.594259] DR6: fffe0ff0 DR7: 00000400
[  741.598159] Call Trace:
[  741.600694]  setup_arg_pages+0x22b/0x310
[  741.604654]  ? _raw_spin_unlock_irqrestore+0x45/0x50
[  741.609677]  ? trace_hardirqs_on+0x4b/0x110
[  741.613930]  ? get_random_u32+0x4e/0x80
[  741.617809]  ? get_random_u32+0x4e/0x80
[  741.621687]  load_elf_binary+0x31e/0x10f0
[  741.625714]  ? __do_execve_file+0x5b4/0xbf0
[  741.629917]  ? find_held_lock+0x24/0x80
[  741.633839]  __do_execve_file+0x5a8/0xbf0
[  741.637893]  __ia32_sys_execve+0x2a/0x40
[  741.641875]  do_syscall_32_irqs_on+0x3d/0x2c0
[  741.646246]  ? find_held_lock+0x24/0x80
[  741.650105]  ? lock_release+0x8a/0x260
[  741.653890]  ? __might_fault+0x41/0x80
[  741.657660]  do_fast_syscall_32+0x60/0xf0
[  741.661691]  do_SYSENTER_32+0x15/0x20
[  741.665373]  entry_SYSENTER_32+0x9f/0xf2
[  741.669328] EIP: 0xb7f38549
[  741.672140] Code: Bad RIP value.
[  741.675430] EAX: ffffffda EBX: bfe19bf0 ECX: 08067420 EDX: bfe19e24
[  741.681708] ESI: 08058a14 EDI: bfe19bf9 EBP: bfe19c98 ESP: bfe19bc8
[  741.687991] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  741.694804] irq event stamp: 23911
[  741.698253] hardirqs last  enabled at (23929): [<d756f075>]
console_unlock+0x4a5/0x610
[  741.706181] hardirqs last disabled at (23946): [<d756ec5a>]
console_unlock+0x8a/0x610
[  741.714041] softirqs last  enabled at (23962): [<d82b975c>]
__do_softirq+0x2dc/0x3da
[  741.721849] softirqs last disabled at (23973): [<d74a8275>]
call_on_stack+0x45/0x50
[  741.729513] ---[ end trace 170f646c1b6225e0 ]---
[  741.734151]  old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)

Build link: https://builds.tuxbuild.com/1cwiUvFIB4M0hPyB1eA3cA/
vmlinux: https://builds.tuxbuild.com/1cwiUvFIB4M0hPyB1eA3cA/vmlinux.xz
system.map: https://builds.tuxbuild.com/1cwiUvFIB4M0hPyB1eA3cA/System.map


full test log,
https://lkft.validation.linaro.org/scheduler/job/1554181#L10557

- Naresh

>
> Something like the attached (UNTESTED!) patch.
>
>          Linus
