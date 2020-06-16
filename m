Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D031FACF9
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 11:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgFPJog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 05:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPJof (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 05:44:35 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E86C05BD43
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 02:44:35 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id t74so3765091lff.2
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 02:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=LQ0yBbYwwauQrAG+/oGQAWZ5fXMYw/+iTakg/gFmQ7s=;
        b=yRox+36jmsoa16OBvwhPnvoclTk9FHf8Yj2HS/WNvFf28TmAZNJ41VNG/fQHA+zFwd
         KeXv6C4vONLOefaChAGNdP2gZgLqTmroFK7htua+1haCtJFXeG6QoZ7g5i2bNXLs8CpM
         Uw+CffbxgjOgO3Blx5vH7SEtA30y69chIDuCCFm9QLM1XYYbOe4ptWjbvZVLqxNeKL4l
         IMwPXxkqdAP4qHIyXSeOp2oLK68xV3khes/ayLvduFtMpdh3WKX8jsYX2THD+RrpJ4PE
         GKMgNtYuOyUmd/9auuplLmwxt0fubjDbv1SwLCLY734TdwTOoUCQ9HgQ+2Yd8A++o/qM
         8Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=LQ0yBbYwwauQrAG+/oGQAWZ5fXMYw/+iTakg/gFmQ7s=;
        b=H0VOdm33vuaRyBKXLJ7OypceDoEedjGX0vALs671ZvV5B+H/X7eVJcFPtlA/iuRhmt
         AvLh8hOAXIg9UP8Zn4KShvfWjgmJRwZKOptYY89LLk6AtDdbXrfdCiJm+O8YmbXZl+yC
         q+6MvMZIu54YXNam8r9+nbOjr7xBWQY7nWjL57l1z3LFnXBdnGb2FuykyFUsGzHslxKH
         4+5OsRzeqt48ex6tf82rF0xUrNya52UeuqqlA19ttmUvSho8jyR2x5ISkiCpH/PNzaSL
         muCqGFicSvciFB9v5L1RHvGGjntklOxuRH9nUeft3EmEJ4Ne7wMPKUsU3CF7gJR7TAm4
         4a0Q==
X-Gm-Message-State: AOAM533gX2WciZNCOIpmqJMg7pvfTgBug0sLK/XTB1RGDtbeZuRHQ3Li
        XOSUX2Q0nwDbCyiZ8AbiQz5ERdubyMqO/ku6bzsWlBJCgp9b8g==
X-Google-Smtp-Source: ABdhPJzWvmfZ456npHJ76NhUW38MRHPHpRS6GkZEbP+2lHrPe4CCmSr/9H1F37APZ/v4SwaaJGKNzJVNf1UlTGXv9Bs=
X-Received: by 2002:ac2:55b2:: with SMTP id y18mr1284361lfg.55.1592300672831;
 Tue, 16 Jun 2020 02:44:32 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Jun 2020 15:14:21 +0530
Message-ID: <CA+G9fYs-7GaDsBQPjhNHcZbTp-qm3fcpaiK8_df3Wpaei8Oikg@mail.gmail.com>
Subject: stable-rc 5.4.47-rc1/cbc29a7953ca: no regressions found in project
 stable v5.4.y
To:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Will Deacon <will@kernel.org>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

While running kselftest on arm64 Juno the following kernel warning was
reported. FYI, we are running kselftest 5.7.
We have been noticing this warning on 5.4 and 5.6 branches.

[  486.146777] kselftest: Running tests in gpio
[  486.498350] ------------[ cut here ]------------
[  486.503045] refcount_t: underflow; use-after-free.
[  486.508067] WARNING: CPU: 1 PID: 7242 at
/usr/src/kernel/lib/refcount.c:190
refcount_sub_and_test_checked+0xac/0xc8
[  486.518525] Modules linked in: gpio_mockup(-) cls_bpf sch_fq 8021q
garp stp mrp llc sch_ingress veth algif_hash rfkill tda998x
drm_kms_helper drm crct10dif_ce fuse [last unloaded: test_bpf]
[  486.535459] CPU: 1 PID: 7242 Comm: modprobe Not tainted 5.4.47-rc1 #1
[  486.541913] Hardware name: ARM Juno development board (r2) (DT)
[  486.547847] pstate: 40000005 (nZcv daif -PAN -UAO)
[  486.552650] pc : refcount_sub_and_test_checked+0xac/0xc8
[  486.557974] lr : refcount_sub_and_test_checked+0xac/0xc8
[  486.563296] sp : ffff80001aee3bb0
[  486.566617] x29: ffff80001aee3bb0 x28: ffff000953b20000
[  486.571943] x27: 0000000000000000 x26: 0000000000000000
[  486.577269] x25: 0000000000000045 x24: ffff00096ee6d478
[  486.582594] x23: ffff8000123e4800 x22: ffff8000123e4000
[  486.587920] x21: ffff00096ee6b008 x20: ffff00096ee6b000
[  486.593245] x19: ffff00096ee6b008 x18: ffffffffffffffff
[  486.598569] x17: 0000000000000000 x16: 0000000000000000
[  486.603895] x15: ffff8000122bfa48 x14: ffff80009aee3897
[  486.609219] x13: ffff80001aee38a5 x12: ffff8000122ec000
[  486.614544] x11: 0000000005f5e0ff x10: ffff80001aee3830
[  486.619869] x9 : ffff8000125f1c98 x8 : 0000000000000028
[  486.625195] x7 : ffff800010193e3c x6 : ffff00097ef303e8
[  486.630520] x5 : ffff00097ef303e8 x4 : ffff000953b20000
[  486.635844] x3 : ffff8000122c0000 x2 : 0000000000000000
[  486.641169] x1 : 677d96118732a100 x0 : 0000000000000000
[  486.646495] Call trace:
[  486.648948]  refcount_sub_and_test_checked+0xac/0xc8
[  486.653924]  refcount_dec_and_test_checked+0x14/0x20
[  486.658901]  kobject_put+0x24/0x210
[  486.662400]  put_device+0x24/0x30
[  486.665723]  gpiochip_remove+0xe0/0x120
[  486.669567]  devm_gpio_chip_release+0x20/0x30
[  486.673934]  release_nodes+0x150/0x248
[  486.677690]  devres_release_all+0x3c/0x60
[  486.681710]  device_release_driver_internal+0x110/0x1d8
[  486.686947]  driver_detach+0x5c/0xe8
[  486.690529]  bus_remove_driver+0x64/0x118
[  486.694548]  driver_unregister+0x34/0x60
[  486.698482]  platform_driver_unregister+0x20/0x30
[  486.703201]  gpio_mockup_exit+0x30/0x490 [gpio_mockup]
[  486.708355]  __arm64_sys_delete_module+0x190/0x2c0
[  486.713160]  el0_svc_common.constprop.2+0x7c/0x180
[  486.717962]  el0_svc_handler+0x34/0xa0
[  486.721720]  el0_svc+0x8/0xc
[  486.724606] irq event stamp: 2790
[  486.727930] hardirqs last  enabled at (2789): [<ffff800010193fdc>]
console_unlock+0x52c/0x5f8
[  486.736476] hardirqs last disabled at (2790): [<ffff8000100a8f0c>]
debug_exception_enter+0xac/0xe8
[  486.745455] softirqs last  enabled at (2786): [<ffff8000100821ec>]
__do_softirq+0x4c4/0x578
[  486.753827] softirqs last disabled at (2687): [<ffff80001010a8b4>]
irq_exit+0x144/0x150
[  486.761846] ---[ end trace 2c86a1fe4de2724b ]---
[  487.328176] gpio gpiochip2: (gpio-mockup-B): line cnt 1024 is
greater than fast path cnt 512
[  487.336696] gpiochip_find_base: cannot find free range
[  487.342013] gpiochip_add_data_with_key: GPIOs 0..1023
(gpio-mockup-B) failed to register, -28
[  487.426615] gpio-mockup: probe of gpio-mockup.1 failed with error -28


Ref:
stable rc-5.4 warning on arm64 Juno-r2 while running kselftest
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.46-83-=
gcbc29a7953ca/testrun/2825770/suite/linux-log-parser/test/check-kernel-warn=
ing-1496069/log

stable rc-5.6 warning on arm64 Juno-r2 while running kselftest
https://lkft.validation.linaro.org/scheduler/job/1496847#L9357

Summary
------------------------------------------------------------------------

kernel: 5.4.47-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: cbc29a7953ca53d5db824b78b27ea50936747544
git describe: v5.4.46-83-gcbc29a7953ca
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.46-83-gcbc29a7953ca

No regressions (compared to build v5.4.45-35-g12a5ce113626)

No fixes (compared to build v5.4.45-35-g12a5ce113626)

Ran 34599 total tests in the following environments and test suites.

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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* libhugetlbfs
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
