Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE261C5AE2
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgEEPT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729508AbgEEPT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:19:29 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2DC061A10
        for <stable@vger.kernel.org>; Tue,  5 May 2020 08:19:28 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so2017317ljn.7
        for <stable@vger.kernel.org>; Tue, 05 May 2020 08:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yH/ECA02LXyTaetCrqh3e2KjVg4AA0WCGXhItcdl/C0=;
        b=EYOJnboUafsMGWXN49Qp8eC9x251LB0E6YrGKz9sREThccE303zigT4sZsnoA35uRD
         dZvaJskV5FFe+bayKLxn7RopscNBfodpqXaDZ9EJB6gbDQGxXc2XUqNEgUVwX7fifbAI
         fOoa2YuQouLT6GZ08zODczhrb9v8RMgVGt9KQNZhrovOhd/vA2SZQK6qHfwfdBxlTMdt
         zADWMyBIyxN9aE4UKlw/V3S7IT2AKmZRsVJTv8eQfqJU25iO71EnbTMILqc5lFiuJwvf
         7Ch5XshSQR/Bew3fxOdQL/beDelUqz7nRbaHz+nQepPn+Ielf58sprJAuzc3hYOmWlUf
         hVLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yH/ECA02LXyTaetCrqh3e2KjVg4AA0WCGXhItcdl/C0=;
        b=WzR2GB9+qWqyMTHErixw8JclxkB2gcWlEqFJyr1C9HIF7nJdI939/sbaf5y4kym/hL
         WWHU7ggGe0Oqp4YN4f1aIAKDh1uHgphL1xESbC5HGe190k3HPGGELOucxkuSgf5ipRnQ
         srFmNq6t1YFfxJq50QLkpFRTz4UtqLcmS5PiK4sggX79C7Cw1xw4X3wk+AA9a/hdQGZy
         5hZZhM7GWrtz9PQirvYmhwcVmcMZE304X7b8h5he5qkw2njfl2IxLv4aKciGHstqSjg9
         3AZnLShBRRIa8vYWXWPECkviDYCscZeinyF7CvmassrNVd7QBnMLJo1Sxd0VR+Z+VJcv
         suNg==
X-Gm-Message-State: AGi0PubxjPmjxolKX9Z6dguc/wutzrnma7CK+PsVQK6OCBK1Vn15XKq5
        Z6PQ9cfpL7f6tJu30twats8N4Ry3Kfv7VRb8dcjSHw==
X-Google-Smtp-Source: APiQypLS6Lcx/F/VWdTDD0YhI6qcKAfSCvMt/mQsBff7XdceGqA8F9Z9krFF6HyfMXw+OU9Ezm2luImKXqxor79wptc=
X-Received: by 2002:a2e:2e16:: with SMTP id u22mr2245114lju.243.1588691966733;
 Tue, 05 May 2020 08:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165456.783676004@linuxfoundation.org>
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 20:49:14 +0530
Message-ID: <CA+G9fYvegpetZe1o-5e7p5b=mCu=-+ErtCcm5RvadZEdrLwizA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/57] 5.4.39-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 May 2020 at 23:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.39 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.39-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
While running LTP mm tests on hikey device kernel panic has been noticed.
But this is hard to reproduce.
We are investigating this problem.

[   75.934817] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[   75.943910] Mem abort info:
[   75.946768]   ESR =3D 0x86000006
[   75.949899]   EC =3D 0x21: IABT (current EL), IL =3D 32 bits
[   75.955330]   SET =3D 0, FnV =3D 0
[   75.958454]   EA =3D 0, S1PTW =3D 0
[   75.961674] user pgtable: 4k pages, 48-bit VAs, pgdp=3D000000007296d000
[   75.968260] [0000000000000000] pgd=3D0000000072962003,
pud=3D0000000072935003, pmd=3D0000000000000000
[   75.977159] Internal error: Oops: 86000006 [#1] PREEMPT SMP
[   75.982851] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart snd_soc_audio_graph_card btbcm crct10dif_ce adv7511
snd_soc_simple_card_utils wlcore_sdio cec kirin_drm dw_drm_dsi
bluetooth drm_kms_helper rfkill drm fuse
[   75.998113] dwmmc_k3 f723d000.dwmmc0: Unexpected interrupt latency
[   76.003485] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.4.39-rc1-00058-g29ca49e0243b #1
[   76.017981] Hardware name: HiKey Development Board (DT)
[   76.024656] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   76.029554] pc : 0x0
[   76.031796] lr : cpuidle_enter_state+0x68/0x360
<>
[   76.121215] Call trace:
[   76.123718]  0x0
[   76.125604]  cpuidle_enter+0x34/0x48
[   76.129262]  call_cpuidle+0x18/0x38
[   76.132830]  do_idle+0x1e0/0x280
[   76.136129]  cpu_startup_entry+0x20/0x40
[   76.140139]  rest_init+0xd4/0xe0
[   76.143442]  arch_call_rest_init+0xc/0x14
[   76.147540]  start_kernel+0x41c/0x448
[   76.151293] Code: bad PC value
[   76.154426] ---[ end trace 01a359b3eb02445a ]---
[   76.159146] Kernel panic - not syncing: Attempted to kill the idle task!
[   76.165995] SMP: stopping secondary CPUs
[   76.170441] Kernel Offset: disabled
[   76.174005] CPU features: 0x0002,24002004
[   76.178103] Memory Limit: none
[   76.181240] ---[ end Kernel panic - not syncing: Attempted to kill
the idle task! ]---
[   75.977159] Internal error: Oops: 86000006 [#1] PREEMPT SMP


Summary
------------------------------------------------------------------------

kernel: 5.4.39-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 29ca49e0243b0d2bb55a2ee418f3cdc1fae69627
git describe: v5.4.38-58-g29ca49e0243b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.38-58-g29ca49e0243b

No regressions (compared to build v5.4.38)

No fixes (compared to build v5.4.38)

Ran 25955 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* libgpiod
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-sched-tests
* perf
* kselftest
* kselftest/drivers
* kselftest/filesystems
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* v4l2-compliance
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
