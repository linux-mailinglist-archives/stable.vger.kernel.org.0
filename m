Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7525E5EDA
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIVJqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIVJqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:46:44 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B57D4A83
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:46:43 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id sd10so11379702ejc.2
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=hRCYYiumHAcy2FWq/eEk3hZ9Y8DhnwA96ZLwPN5poIw=;
        b=UhGC0K24D+JVH9cAnZJSXjoL45ev1hjyRmMKYjNgy0sc2jKka0MvBA41oMpIPHjz2l
         XT1LRUAfA8mTujnSNwMlu09Mj2WsGN0HBAe87Ui7otCVpbbQUaaDFTqt40u9HdNAp1u9
         gf13B57mfGHbI2dU3VMI7dclaKBQxfmxljubSdLR430DqpWfHNwrgi4dVOGfLBtBVwTS
         vL5QY8QmLW+kmF9gBXGN+BwwU2WCl9U9R6PQI2e0C3oT/33SAkbaBV4864DsvfS5IcZ0
         r4wCDALVqBW7QM/g2dJMkPTdvq0Y5XiweNEaxhMN3ArofRZeaspWNvnB6BSuknzBYM/P
         T/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hRCYYiumHAcy2FWq/eEk3hZ9Y8DhnwA96ZLwPN5poIw=;
        b=7gGxNwZym30ecu+DxPmgaG5MuhDSxgrDXozXcjKXhf2AePW5m8jlZrMdN/7hHPEO+6
         d7JI5b+ndtSC9QRxAr58NxswAMOqksvHGR8GeQwOkI4ptx+/c5/FKUnAC1vQFSE2mhqX
         7hQPThfeW8eLBEJQrDUai5JIFDa4umZ43+7MJawj/BePE6TWokiNIu/KZ0gsdlJxs2Co
         D8vFfrCGDZqqKi8nmRSoxsnTRh/pOilLeP/5W8r7LLe8Y8ofO2P5oIu/nXp8V8kIT16J
         K5F2PIUsrH/7Iafwewe2w1gYM9/rcSgM62+Zz+6jYSst6vU2NYk7oNp6WUw4qQeJ3ZJU
         jkSg==
X-Gm-Message-State: ACrzQf1680SahxYlmC/ua2o7fDMallkpyBuaG5eZBDaga4jO3R1bEh1m
        6b4VzOuMksFqTadm/XXeiumKFRcO00ZtLDNUpLqH0w==
X-Google-Smtp-Source: AMsMyM58IsyFu6NnF5lyhXrKJpDPlbxi9jxWGVJGhWUlhbtnDf/HM/nzbCdBHuF8TxFmPkiwsIchAn3qB3Ir602YR1E=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr2039353ejb.169.1663840001362; Thu, 22
 Sep 2022 02:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220921153645.663680057@linuxfoundation.org>
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 22 Sep 2022 15:16:29 +0530
Message-ID: <CA+G9fYtS97fKxEP1ZSUDOBsa8c0ktC8nGKPSxWjDNbBHwpE7Hw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/39] 5.10.145-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sept 2022 at 21:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.145 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.145-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
As we have already reported from the previous stable rc review
about the gpiod test runs causing kernel crash on 5.19. 5.15 and 5.10

This is caused by commit 303e6da99429 ("gpio: mockup: remove gpio
debugfs when remove device")

Crash log:
---------

+ cd ./automated/linux/gpiod
+ ./gpiod.sh /opt/libgpiod/bin/
[INFO]  libgpiod test suite
[INFO]  117 tests registered
[INFO]  checking the linux kernel version
[INFO]  kernel release is v5.10.145 - ok to run tests
[INFO]  using gpio-tools from '/usr/bin'
[   12.960531] Unable to handle kernel NULL pointer dereference at
virtual address 00000000000000a0
[   12.961269] Mem abort info:
[   12.961490]   ESR =3D 0x96000006
[   12.961749]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   12.962164]   SET =3D 0, FnV =3D 0
[   12.962389]   EA =3D 0, S1PTW =3D 0
[   12.962652] Data abort info:
[   12.962881]   ISV =3D 0, ISS =3D 0x00000006
[   12.963163]   CM =3D 0, WnR =3D 0
[   12.963749] user pgtable: 4k pages, 48-bit VAs, pgdp=3D000000010460c000
[   12.964233] [00000000000000a0] pgd=3D0000000104421003,
p4d=3D0000000104421003, pud=3D00000001045cf003, pmd=3D0000000000000000
[   12.965008] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[   12.965413] Modules linked in: gpio_mockup(-) cfg80211 bluetooth
rfkill crct10dif_ce drm fuse
[   12.966052] CPU: 3 PID: 369 Comm: gpiod-test Not tainted 5.10.145-rc1 #1
[   12.966533] Hardware name: linux,dummy-virt (DT)
[   12.966868] pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=3D--)
[   12.967317] pc : down_write+0x24/0x70
[   12.967603] lr : simple_recursive_removal+0x58/0x274

https://lore.kernel.org/lkml/CAMRc=3DMc_DkKN0qM9dBj_Pz2LeEhmT29GwmVf0tbunGk=
aOaYUqA@mail.gmail.com/

## Build
* kernel: 5.10.145-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: ca8291e3d06f6d6be2c539455efd2c40cb2bfbab
* git describe: v5.10.144-40-gca8291e3d06f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.144-40-gca8291e3d06f

## No Test Regressions (compared to v5.10.144)

## No Metric Regressions (compared to v5.10.144)

## No Test Fixes (compared to v5.10.144)

## No Metric Fixes (compared to v5.10.144)

## Test result summary
total: 101642, pass: 89442, fail: 765, skip: 11240, xfail: 195

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 55 passed, 5 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
