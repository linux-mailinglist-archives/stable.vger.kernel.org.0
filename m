Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0395BDDC4
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 09:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiITHG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 03:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiITHGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 03:06:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503B951A28
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 00:06:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id sb3so3844643ejb.9
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 00:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=v2dG6/P5BSWS7u4tQfy+uH29sBLSe4H65/8CiipYbDU=;
        b=wCLiLA2LyGdy6T+8YdBc1ntPQp5TcBGCxX/SR94TFL7LGtgzvQrYTkArMXd/cnMDUV
         YutVur06MO8JUDQh50pUSnGmYcmx37z5ORf4KSb0qhZrLWNfG+lQ7K2ZlnLHUmrE9GzC
         iDy4aRzZm7UB6dlSYA6ohv3AxyPLcrXixyjcbpNhtRq2NUlz+a7N2ktkncE/r7vu+w5/
         +McNy8ie1CECptxb9dUvMynUY7p9ldDGrRREfVIMjJWAbw5q3f9pWttZ4p/H2VUqZcE3
         xtwkmOTMQ9s9GvkbVu4d/JSodEtA9ZNo1Bb14gnWGLgadwWn0ASIU+YHl1VYhT+OXkqB
         twUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=v2dG6/P5BSWS7u4tQfy+uH29sBLSe4H65/8CiipYbDU=;
        b=Z7UDTVJshHx/z1RO77bJo5G4YdkxtqzuWBZ+Qh+gRTNbvamzSjXwnWSsTsItVXn4tZ
         h0P1L0nN6EMLIZlxXSXqOPxkgTKoPkqWpDDTfGFiwPXG6XHGclHFZl/ym6DgYM194CaN
         7AxJghO/wSUUxH4xy5HV7hhWubvNrRvlFdKnqeWE4hMAOZw+0xvYiFX2vr+oy4mX0U3D
         qNUQJgNGIlOmeFUUwcrkbOeAwBelRzlDojLz10LmndCQE9qY6C4yNj9h0LXqhXHbJCX+
         rLKjy8Er7aiOMJNETd/jVCi2Q8FjKx4n0+m904NoyR0MPweG8KnDHiSyItTYWiTHxPMs
         jKhQ==
X-Gm-Message-State: ACrzQf0qdSjejYs8X0SgOugzaC816kxXs9X6FkfsjL/U59afJESbpA41
        RlA1BeKLJk/oNrZ1Uy9HS8HWzqiTJkJSu5DUE3jXAw==
X-Google-Smtp-Source: AMsMyM6L2lUQL75sbBSApfMEt2Ob79NEGl+tLjiQvLT+RrbIusLX2g9oZOb/ensDZQBGhtmEvgKvEoCtbRM/bjAVmBw=
X-Received: by 2002:a17:907:3e07:b0:774:53ba:6b27 with SMTP id
 hp7-20020a1709073e0700b0077453ba6b27mr14975526ejc.286.1663657582823; Tue, 20
 Sep 2022 00:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220916100445.354452396@linuxfoundation.org> <CA+G9fYty3xhJMSuDY1EwcWf9O7dyeFvJ4Y2TAaeC8jc0ZY8Y2g@mail.gmail.com>
In-Reply-To: <CA+G9fYty3xhJMSuDY1EwcWf9O7dyeFvJ4Y2TAaeC8jc0ZY8Y2g@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 20 Sep 2022 09:06:11 +0200
Message-ID: <CAMRc=Mc_DkKN0qM9dBj_Pz2LeEhmT29GwmVf0tbunGkaOaYUqA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/24] 5.10.144-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        William Breathitt Gray <william.gray@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 17, 2022 at 6:09 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Fri, 16 Sept 2022 at 15:41, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.144 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.144-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro's test farm.
> Regressions on x86_64 while running libgpiod tests.
>
> Regressions on x86_64 while running libgpiod tests.
> This reported regression also noticed on mainline, stable-rc 5.19,
> stable-rc 5.15 and stable-rc 5.10 branches
>
> I have not bisected this reported crash yet.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> + cd ./automated/linux/gpiod
> + ./gpiod.sh /opt/libgpiod/bin/
> [INFO]  libgpiod test suite
> [INFO]  117 tests registered
> [INFO]  checking the linux kernel version
> [INFO]  kernel release is v5.10.144 - ok to run tests
> [INFO]  using gpio-tools from '/usr/bin'
> [   10.900672] BUG: kernel NULL pointer dereference, address: 00000000000000a0
> [   10.901452] #PF: supervisor write access in kernel mode
> [   10.901452] #PF: error_code(0x0002) - not-present page
> [   10.901452] PGD 108545067 P4D 108545067 PUD 108544067 PMD 0
> [   10.901452] Oops: 0002 [#1] SMP NOPTI
> [   10.901452] CPU: 1 PID: 479 Comm: gpiod-test Not tainted 5.10.144-rc1 #1
> [   10.901452] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [   10.901452] RIP: 0010:down_write+0x1a/0x60
> [   10.901452] Code: 00 31 c0 eb dd e8 76 9e ff ff cc cc cc cc cc cc
> 0f 1f 44 00 00 55 48 89 e5 41 54 49 89 fc e8 4d d9 ff ff 31 c0 ba 01
> 00 00 00 <f0> 49 0f b1 14 24 75 18 65 48 8b 04 25 80 ad 01 00 49 89 44
> 24 08
> [   10.901452] RSP: 0018:ffffaf1f005abd08 EFLAGS: 00010246
> [   10.901452] RAX: 0000000000000000 RBX: ffffa38c448f6a80 RCX: ffffff8100000000
> [   10.901452] RDX: 0000000000000001 RSI: ffffff8100000000 RDI: 00000000000000a0
> [   10.901452] RBP: ffffaf1f005abd10 R08: 0000000000000286 R09: ffffa38c448f6ad8
> [   10.901452] R10: 000000000000003e R11: ffffa38c44a4dea8 R12: 00000000000000a0
> [   10.901452] R13: ffffaf1f005abdb0 R14: 00000000000000a0 R15: ffffa38c44530c40
> [   10.901452] FS:  00007fbd204f7740(0000) GS:ffffa38c7bc80000(0000)
> knlGS:0000000000000000
> [   10.901452] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   10.901452] CR2: 00000000000000a0 CR3: 0000000108490000 CR4: 00000000003506e0
> [   10.901452] Call Trace:
> [   10.901452]  simple_recursive_removal+0x55/0x2b0
> [   10.901452]  ? debugfs_rename+0x2e0/0x2e0
> [   10.901452]  debugfs_remove+0x45/0x70
> [   10.901452]  gpio_mockup_debugfs_cleanup+0x15/0x20 [gpio_mockup]
> [   10.901452]  devm_action_release+0x15/0x20
> [   10.901452]  release_nodes+0x1bd/0x210
> [   10.901452]  devres_release_all+0x3f/0x60
> [   10.901452]  __device_release_driver+0x195/0x260
> [   10.901452]  driver_detach+0xce/0x110
> [   10.901452]  bus_remove_driver+0x5c/0xe0
> [   10.901452]  driver_unregister+0x31/0x60
> [   10.901452]  platform_driver_unregister+0x12/0x20
> [   10.901452]  gpio_mockup_exit+0x1c/0x4c4 [gpio_mockup]
> [   10.901452]  __do_sys_delete_module+0x1b2/0x290
> [   10.901452]  ? syscall_trace_enter.constprop.0+0x13c/0x1b0
> [   10.901452]  __x64_sys_delete_module+0x18/0x20
> [   10.901452]  do_syscall_64+0x38/0x50
> [   10.901452]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [   10.901452] RIP: 0033:0x7fbd2069c95b
> [   10.901452] Code: 73 01 c3 48 8b 0d c5 34 0e 00 f7 d8 64 89 01 48
> 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 34 0e 00 f7 d8 64 89
> 01 48
> [   10.901452] RSP: 002b:00007ffdfa2d9348 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000b0
> [   10.901452] RAX: ffffffffffffffda RBX: 00000000022af370 RCX: 00007fbd2069c95b
> [   10.939140] RDX: 00000000022ad8b7 RSI: 0000000000000800 RDI: 00000000022af938
> [   10.939140] RBP: 00000000022af370 R08: 0000000000000007 R09: 00000000022b75c0
> [   10.939140] R10: 00007fbd205a6b88 R11: 0000000000000206 R12: 00000000022af420
> [   10.939140] R13: 00007fbd20743b00 R14: 0000000000418df8 R15: 00007fbd207dc000
> [   10.939140] Modules linked in: gpio_mockup(-)
> [   10.939140] CR2: 00000000000000a0
> [   10.939140] ---[ end trace e891f796dd2f311d ]---
> [   10.939140] RIP: 0010:down_write+0x1a/0x60
> [   10.939140] Code: 00 31 c0 eb dd e8 76 9e ff ff cc cc cc cc cc cc
> 0f 1f 44 00 00 55 48 89 e5 41 54 49 89 fc e8 4d d9 ff ff 31 c0 ba 01
> 00 00 00 <f0> 49 0f b1 14 24 75 18 65 48 8b 04 25 80 ad 01 00 49 89 44
> 24 08
> [   10.939140] RSP: 0018:ffffaf1f005abd08 EFLAGS: 00010246
> [   10.939140] RAX: 0000000000000000 RBX: ffffa38c448f6a80 RCX: ffffff8100000000
> [   10.939140] RDX: 0000000000000001 RSI: ffffff8100000000 RDI: 00000000000000a0
> [   10.939140] RBP: ffffaf1f005abd10 R08: 0000000000000286 R09: ffffa38c448f6ad8
> [   10.939140] R10: 000000000000003e R11: ffffa38c44a4dea8 R12: 00000000000000a0
> [   10.939140] R13: ffffaf1f005abdb0 R14: 00000000000000a0 R15: ffffa38c44530c40
> [   10.939140] FS:  00007fbd204f7740(0000) GS:ffffa38c7bc80000(0000)
> knlGS:0000000000000000
> [   10.939140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   10.939140] CR2: 00000000000000a0 CR3: 0000000108490000 CR4: 00000000003506e0
> + ../../utils/send-to-lava.sh result.txt

This is caused by commit 303e6da99429 ("gpio: mockup: remove gpio
debugfs when remove device"). I'm looking into it.

Bart

>
> https://lkft.validation.linaro.org/scheduler/job/5547188#L992
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.143-25-g02c4837d98bf/testrun/11952159/suite/log-parser-test/tests/
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.143-25-g02c4837d98bf/testrun/11954093/suite/log-parser-test/tests/
>
>
> ## Build
> * kernel: 5.10.144-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-5.10.y
> * git commit: 02c4837d98bf509b70afb8368175c489a5ba7b4a
> * git describe: v5.10.143-25-g02c4837d98bf
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.143-25-g02c4837d98bf
>
> ## Test Regressions (compared to v5.10.143)
>   - Kernel BUG while running libgpiod on x86_64.
>
> ## No metric Regressions (compared to v5.10.143)
>
> ## No test Fixes (compared to v5.10.143)
>
> ## No metric Fixes (compared to v5.10.143)
>
>
> ## Test result summary
> total: 102380, pass: 89955, fail: 750, skip: 11365, xfail: 310
>
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 333 total, 333 passed, 0 failed
> * arm64: 65 total, 63 passed, 2 failed
> * i386: 56 total, 53 passed, 3 failed
> * mips: 56 total, 56 passed, 0 failed
> * parisc: 12 total, 12 passed, 0 failed
> * powerpc: 60 total, 55 passed, 5 failed
> * riscv: 27 total, 27 passed, 0 failed
> * s390: 24 total, 24 passed, 0 failed
> * sh: 24 total, 24 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x86_64: 59 total, 56 passed, 3 failed
>
> ## Test suites summary
> * fwts
> * igt-gpu-tools
> * kunit
> * kvm-unit-tests
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-cap_bounds
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-filecaps
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-fsx
> * ltp-hugetlb
> * ltp-io
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-open-posix-tests
> * ltp-pty
> * ltp-sched
> * ltp-securebits
> * ltp-syscalls
> * ltp-tracing
> * network-basic-tests
> * packetdrill
> * rcutorture
> * v4l2-compliance
> * vdso
>
> --
> Linaro LKFT
> https://lkft.linaro.org
