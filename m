Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E691230579
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 10:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgG1IeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 04:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727996AbgG1IeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 04:34:14 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CFAC061794
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 01:34:13 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id p27so2012880uaa.12
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 01:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B0b9UMK24v6NX2X8zYI+BkJ3zJnFD1PM99BHGur3P6E=;
        b=g7VomaSMeefY7/kItCPm86++8jaIvAKsbmzzeKLH9gUiL1cOCi8q9AktmxuMa4R8pS
         fV/LB/UayxZFKvDj9HBPDngzrlsQyOwQ7fvrdn+eOeeYySIW7jwC8cFbSKqjkUuXHHji
         URGlGXhA3soNhC2uDDZAmeM8po9DgP5DMwBv9Wnp4KIMZGLFimi8Snhin8/+KSc8XEbi
         tdr3f+Ofif2/O5lr2yvnswjVywZd4LiYaKYZZrViWXvKUmtQl85VjCxP7UURlzqfr7pg
         DTE4mAxqKelkZdSPHM3+PAp4+mBoIUQ1hBZqPbQTgDHoF49TjBwYfnGP+e/DbNL55LCT
         CSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B0b9UMK24v6NX2X8zYI+BkJ3zJnFD1PM99BHGur3P6E=;
        b=tq3x8F5eCjGtteJ9IXkX3Ii6sz5PxjzQetXgK+3EZenxozGg8gPbVr0p8yG8KQ+BoH
         LcYcRfwO/8WTGcJNAZSCm81zExGJUgRcp8HydXmin6/fqeQbVXFMtc4MCYBgA2MCRXdv
         ShufxdO+0xUfWdbWC8izcKGD3gGX6KU6yqN1EfvU96jw+tbqY9zRX3ST6kOopZWd8QZd
         oJgD3Ri0yjZmhL4uEI3sR53uCUoxIDG5i5p5AE00todp1l3KjeWgBRpss6htbFNW8sgM
         3WaPdjHalHivBU7HX4+W1VVEBm0VU3SLpVhXvvpgJDud3ar88YbUop6keqy4jj8sU7bW
         PApA==
X-Gm-Message-State: AOAM530NR1Qgemyg7KnnE2S0ZZQ/LXGZRkNYS6vD9c5kbnnfVYCluc0/
        8ln/Za6MQqjRdqP9ZQGdmqVuh84/2wmyuxwFO0rZwg==
X-Google-Smtp-Source: ABdhPJw9Kem7X/V6X+O7xfXZA3c3hpHwIItrswtiz2UQ+rk3CTaZObtbDgJMp5+mMd1VPa3PZcIbNSoqLrCV/vM3weM=
X-Received: by 2002:ab0:5963:: with SMTP id o32mr19079185uad.142.1595925252099;
 Tue, 28 Jul 2020 01:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134914.312934924@linuxfoundation.org>
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Jul 2020 14:04:00 +0530
Message-ID: <CA+G9fYvBRONMYwX36Hcju4JA5TwstkT2Afyuy2DB1zQcBcc1CA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/86] 4.19.135-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        songmuchun@bytedance.com
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        iamjoonsoo.kim@lge.com, linux-mm <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, Shakeel Butt <shakeelb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, lkft-triage@lists.linaro.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jul 2020 at 19:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.135 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.135-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
<trim>

Results from Linaro=E2=80=99s test farm.
Regressions detected on x86_64.

Boot failures on x86_64 devices running 4.19.135-rc1 kernel.

Summary
------------------------------------------------------------------------

kernel: 4.19.135-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: e11702667f84474535b156dbb194deffa0a6cdb4
git describe: v4.19.134-87-ge11702667f84
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.134-87-ge11702667f84

> Muchun Song <songmuchun@bytedance.com>
>     mm: memcg/slab: fix memory leak at non-root kmem_cache destroy

[    2.510884] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    2.510884] WARNING: possible recursive locking detected
[    2.510884] 4.19.135-rc1 #1 Not tainted
[    2.510884] --------------------------------------------
[    2.510884] swapper/0/1 is trying to acquire lock:
[    2.510884] 0000000088703397 (slab_mutex){+.+.}, at:
kmem_cache_destroy+0x9a/0x2b0
[    2.510884]
[    2.510884] but task is already holding lock:
[    2.510884] 0000000088703397 (slab_mutex){+.+.}, at:
kmem_cache_destroy+0x45/0x2b0
[    2.510884]
[    2.510884] other info that might help us debug this:
[    2.510884]  Possible unsafe locking scenario:
[    2.510884]
[    2.510884]        CPU0
[    2.510884]        ----
[    2.510884]   lock(slab_mutex);
[    2.510884]   lock(slab_mutex);
[    2.510884]
[    2.510884]  *** DEADLOCK ***
[    2.510884]
[    2.510884]  May be due to missing lock nesting notation
[    2.510884]
[    2.510884] 3 locks held by swapper/0/1:
[    2.510884]  #0: 000000008702dddc (cpu_hotplug_lock.rw_sem){++++},
at: kmem_cache_destroy+0x32/0x2b0
[    2.510884]  #1: 0000000050103e4d (mem_hotplug_lock.rw_sem){++++},
at: kmem_cache_destroy+0x37/0x2b0
[    2.510884]  #2: 0000000088703397 (slab_mutex){+.+.}, at:
kmem_cache_destroy+0x45/0x2b0
[    2.510884]
[    2.510884] stack backtrace:
[    2.510884] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.135-rc1 #1
[    2.510884] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[    2.510884] Call Trace:
[    2.510884]  dump_stack+0x7a/0xa5
[    2.510884]  __lock_acquire+0x6f1/0x1380
[    2.510884]  ? ret_from_fork+0x3a/0x50
[    2.510884]  lock_acquire+0x95/0x190
[    2.510884]  ? lock_acquire+0x95/0x190
[    2.510884]  ? kmem_cache_destroy+0x9a/0x2b0
[    2.510884]  ? kmem_cache_destroy+0x9a/0x2b0
[    2.510884]  __mutex_lock+0x83/0x990
[    2.510884]  ? kmem_cache_destroy+0x9a/0x2b0
[    2.510884]  ? kmem_cache_destroy+0x60/0x2b0
[    2.510884]  ? set_debug_rodata+0x17/0x17
[    2.510884]  ? set_debug_rodata+0x17/0x17
[    2.510884]  mutex_lock_nested+0x1b/0x20
[    2.510884]  ? get_online_mems+0x5f/0x90
[    2.510884]  ? mutex_lock_nested+0x1b/0x20
[    2.510884]  kmem_cache_destroy+0x9a/0x2b0
[    2.510884]  ? set_debug_rodata+0x17/0x17
[    2.510884]  intel_iommu_init+0x11c6/0x1326
[    2.510884]  ? kfree+0xc4/0x240
[    2.510884]  ? lockdep_hardirqs_on+0xef/0x180
[    2.510884]  ? kfree+0xc4/0x240
[    2.510884]  ? trace_hardirqs_on+0x4c/0x100
[    2.510884]  ? unpack_to_rootfs+0x272/0x29a
[    2.510884]  ? e820__memblock_setup+0x64/0x64
[    2.510884]  ? set_debug_rodata+0x17/0x17
[    2.510884]  pci_iommu_init+0x1a/0x44
[    2.510884]  ? e820__memblock_setup+0x64/0x64
[    2.510884]  ? pci_iommu_init+0x1a/0x44
[    2.510884]  do_one_initcall+0x61/0x2b4
[    2.510884]  ? set_debug_rodata+0xa/0x17
[    2.510884]  ? rcu_read_lock_sched_held+0x81/0x90
[    2.510884]  kernel_init_freeable+0x1d8/0x270
[    2.510884]  ? rest_init+0x190/0x190
[    2.510884]  kernel_init+0xe/0x110
[    2.510884]  ret_from_fork+0x3a/0x50


Full test log:
https://pastebin.com/PWkk0YaF

--=20
Linaro LKFT
https://lkft.linaro.org
