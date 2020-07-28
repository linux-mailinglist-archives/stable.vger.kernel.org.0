Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A89230AE4
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgG1NDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 09:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729764AbgG1NDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 09:03:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD60EC061794
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 06:03:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h12so485910pgf.7
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 06:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LlxNk1zIi8yGHdhZuUAKBshbG8msBSfKJxj73MCTTLY=;
        b=fuVbdu4kg8Y99dAbxJpvJBuhav/4G0H89oQkPKu/UwNUVa4/ENuFAawGrvnbJFgoBt
         b6c+/PdHdm+0fvfYLSNGfWwutyT8zJ00cYHAaOS6f9zTafyFXhSpDOlRg7QaVDBaxrDo
         TzhYbLtsg4hf97K1fgAhkWfDPZmffE/6AGln3ZeHZU372/2HZl7YG4qqjRmhnkxiVeX8
         kbqg+AAQnrsAw3LqjOtGcWjoadgMoWDoBHty5NSeyzn4HWaFAoR5Hzrn3wuFVoxhwOyQ
         9CBgCvBr131KH9KAuci0tTV/fM03zcREGkuUISWapCiTryHcr5GWvASIH8JbIEz3hDV/
         OCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LlxNk1zIi8yGHdhZuUAKBshbG8msBSfKJxj73MCTTLY=;
        b=Xb1maO7Tn7RHGhO/KLxhpLP+gerutv/T9JcWAaUIz9j55h4qYMzMx6DnpwKzSmRDSw
         Rj8LDaT0INJeS3tUPxPOJVevN1a50pardv6uffjWU4v95zRUJLNgszngu2t0Zfz/L1tX
         k/K+hyJglkmK9BmeTPAkmozsUgqTerJb69ceRtG2ZwsZLio/dJUkq00dcUuMBcO2jwEQ
         VlxMxylO/cLdN13gBjsmqPrXi2iRBc8s5ZX7WFmiQSFRzjoaZAeApaH82nS8InufktZe
         zgUOppqEABsLLtwoWc1dW0O3pyO9pubk4MBObv6kjxNDOUVvenpUl3gjLkDNMKx5lKRF
         eS3Q==
X-Gm-Message-State: AOAM532elbcb7W4S7T+L+8JTqf8IhU2tR7SdvIV3V5ruyG5Que4wHdFJ
        bSQI4P6CkvtrZqT/bb0Zsxd2q2F2DyJusEoAeWiONg==
X-Google-Smtp-Source: ABdhPJxXOos+AHvLu5t5Nmre7lPk3d4zzmjsRfGAu0xPh4r4M1Eyh6Y94iVlrv2joUOb/+jXZjClcy6GDG72xjzZbIg=
X-Received: by 2002:a63:7e52:: with SMTP id o18mr1089996pgn.273.1595941427207;
 Tue, 28 Jul 2020 06:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134914.312934924@linuxfoundation.org> <CA+G9fYvBRONMYwX36Hcju4JA5TwstkT2Afyuy2DB1zQcBcc1CA@mail.gmail.com>
In-Reply-To: <CA+G9fYvBRONMYwX36Hcju4JA5TwstkT2Afyuy2DB1zQcBcc1CA@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 28 Jul 2020 21:03:11 +0800
Message-ID: <CAMZfGtVV-u7K+Z0vFLkoKv1UOTfk=a9+r_6G4PYfGLywwnkm3Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 4.19 00/86] 4.19.135-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-mm <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, lkft-triage@lists.linaro.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for your test. I have reviewed the patch:

[PATCH 4.19 76/86] mm: memcg/slab: fix memory leak at non-root
kmem_cache destroy

There is a backport problem and I have pointed out the problem in that emai=
l.

On Tue, Jul 28, 2020 at 4:34 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 27 Jul 2020 at 19:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.135 release.
> > There are 86 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.135-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
> <trim>
>
> Results from Linaro=E2=80=99s test farm.
> Regressions detected on x86_64.
>
> Boot failures on x86_64 devices running 4.19.135-rc1 kernel.
>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 4.19.135-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
> git branch: linux-4.19.y
> git commit: e11702667f84474535b156dbb194deffa0a6cdb4
> git describe: v4.19.134-87-ge11702667f84
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/=
build/v4.19.134-87-ge11702667f84
>
> > Muchun Song <songmuchun@bytedance.com>
> >     mm: memcg/slab: fix memory leak at non-root kmem_cache destroy
>
> [    2.510884] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    2.510884] WARNING: possible recursive locking detected
> [    2.510884] 4.19.135-rc1 #1 Not tainted
> [    2.510884] --------------------------------------------
> [    2.510884] swapper/0/1 is trying to acquire lock:
> [    2.510884] 0000000088703397 (slab_mutex){+.+.}, at:
> kmem_cache_destroy+0x9a/0x2b0
> [    2.510884]
> [    2.510884] but task is already holding lock:
> [    2.510884] 0000000088703397 (slab_mutex){+.+.}, at:
> kmem_cache_destroy+0x45/0x2b0
> [    2.510884]
> [    2.510884] other info that might help us debug this:
> [    2.510884]  Possible unsafe locking scenario:
> [    2.510884]
> [    2.510884]        CPU0
> [    2.510884]        ----
> [    2.510884]   lock(slab_mutex);
> [    2.510884]   lock(slab_mutex);
> [    2.510884]
> [    2.510884]  *** DEADLOCK ***
> [    2.510884]
> [    2.510884]  May be due to missing lock nesting notation
> [    2.510884]
> [    2.510884] 3 locks held by swapper/0/1:
> [    2.510884]  #0: 000000008702dddc (cpu_hotplug_lock.rw_sem){++++},
> at: kmem_cache_destroy+0x32/0x2b0
> [    2.510884]  #1: 0000000050103e4d (mem_hotplug_lock.rw_sem){++++},
> at: kmem_cache_destroy+0x37/0x2b0
> [    2.510884]  #2: 0000000088703397 (slab_mutex){+.+.}, at:
> kmem_cache_destroy+0x45/0x2b0
> [    2.510884]
> [    2.510884] stack backtrace:
> [    2.510884] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.135-rc1 #1
> [    2.510884] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [    2.510884] Call Trace:
> [    2.510884]  dump_stack+0x7a/0xa5
> [    2.510884]  __lock_acquire+0x6f1/0x1380
> [    2.510884]  ? ret_from_fork+0x3a/0x50
> [    2.510884]  lock_acquire+0x95/0x190
> [    2.510884]  ? lock_acquire+0x95/0x190
> [    2.510884]  ? kmem_cache_destroy+0x9a/0x2b0
> [    2.510884]  ? kmem_cache_destroy+0x9a/0x2b0
> [    2.510884]  __mutex_lock+0x83/0x990
> [    2.510884]  ? kmem_cache_destroy+0x9a/0x2b0
> [    2.510884]  ? kmem_cache_destroy+0x60/0x2b0
> [    2.510884]  ? set_debug_rodata+0x17/0x17
> [    2.510884]  ? set_debug_rodata+0x17/0x17
> [    2.510884]  mutex_lock_nested+0x1b/0x20
> [    2.510884]  ? get_online_mems+0x5f/0x90
> [    2.510884]  ? mutex_lock_nested+0x1b/0x20
> [    2.510884]  kmem_cache_destroy+0x9a/0x2b0
> [    2.510884]  ? set_debug_rodata+0x17/0x17
> [    2.510884]  intel_iommu_init+0x11c6/0x1326
> [    2.510884]  ? kfree+0xc4/0x240
> [    2.510884]  ? lockdep_hardirqs_on+0xef/0x180
> [    2.510884]  ? kfree+0xc4/0x240
> [    2.510884]  ? trace_hardirqs_on+0x4c/0x100
> [    2.510884]  ? unpack_to_rootfs+0x272/0x29a
> [    2.510884]  ? e820__memblock_setup+0x64/0x64
> [    2.510884]  ? set_debug_rodata+0x17/0x17
> [    2.510884]  pci_iommu_init+0x1a/0x44
> [    2.510884]  ? e820__memblock_setup+0x64/0x64
> [    2.510884]  ? pci_iommu_init+0x1a/0x44
> [    2.510884]  do_one_initcall+0x61/0x2b4
> [    2.510884]  ? set_debug_rodata+0xa/0x17
> [    2.510884]  ? rcu_read_lock_sched_held+0x81/0x90
> [    2.510884]  kernel_init_freeable+0x1d8/0x270
> [    2.510884]  ? rest_init+0x190/0x190
> [    2.510884]  kernel_init+0xe/0x110
> [    2.510884]  ret_from_fork+0x3a/0x50
>
>
> Full test log:
> https://pastebin.com/PWkk0YaF
>
> --
> Linaro LKFT
> https://lkft.linaro.org



--
Yours,
Muchun
