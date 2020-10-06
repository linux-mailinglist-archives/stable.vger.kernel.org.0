Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CEE2848D1
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 10:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFIwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 04:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFIwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 04:52:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D8FC061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 01:52:23 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d20so7244722iop.10
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 01:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Brzzy/lJvjDAn9lxHDHd9GexxUXru88OTcAFkc5XEuU=;
        b=DWnWTbOigoMfmhnFA7UJeJ6l2/fabMWAldKehMvkg5+rh2OMubY6q1XkDo34SdHQIp
         J9u32QqzcHNVzpHDFZs8wT3tjH6QMAUe49zOsOLjzz8GEZ63+Ac259VOUp/gegQLKmK7
         ZdRXGNKP0/+lNZvf7w2JHzOrk3FVbR3VBIUjg/cTAlUTV7Gw9K8ikI7+iW/F9yVMwouD
         LMJxf/qTBz2tr1iVzV74asV+7MHwnY0mczQMcpjml70APHyy+sFAt9DNDWucRSgeGWv7
         8oLqCEuU6wcjK9x+bd/0VyNJO3Sv2Ue8h0fI61HBuSCdxAlekyO7M8+daqxcQ4dr9SMC
         bEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Brzzy/lJvjDAn9lxHDHd9GexxUXru88OTcAFkc5XEuU=;
        b=hJ6a4ULyd6cotlU7Xzp8SE6hV0Gc9PKOoidFzv9A1dA3ItzneIbEojqMx5RXJ9sW+y
         XP5CfybmEpELJ0XYlRIyEsMXNmZ5IMChU14MxxlPi9mbQgazw8KRzDQ3CT/ylzuB/g8i
         Bx8hD/hdjti8tUf2DGz/7yZ+IQk7nBmKtUd69obP1Kcx+B/dhWLOJOsZpF69JwjuUMHj
         43Zne8EYytztfEjtiSmX46qyDxoIJVVsfnxwH9KTdChXoUNnrM7hix+D1vBcIlYbn3u1
         g+ca2oi//AFotWFPJ1dids4620We1BYnAkDareg0+YK0De2q4vBOFzFDyqIE454Tixq0
         U69w==
X-Gm-Message-State: AOAM53242mHFm9kyHdvQInuVIzVW/LzkfBIibVHc9lEPHDBCitPqxAuc
        Ug74/e11PP70Ih56JjNY8GraxEeo3/Ugekl37y9m4AGSyHRamzZM
X-Google-Smtp-Source: ABdhPJz2/PE4LbeZIl8o54KJGuiFMSWG/3hBxAnIoHIJKdA4gp6zNsWEWSlk6ojLqKNTgyljf+gEvdX0BbrnIvQYMmc=
X-Received: by 2002:a02:a317:: with SMTP id q23mr260126jai.35.1601974343179;
 Tue, 06 Oct 2020 01:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201005142108.650363140@linuxfoundation.org>
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Oct 2020 14:22:12 +0530
Message-ID: <CA+G9fYvt-eKaj7ymbMg-Q4OnFSc5cFxBUF8c4+d9wC1HLo05sA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/38] 4.19.150-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Oct 2020 at 20:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.150 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.150-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
While running LTP mm test suite on qemu_arm64 kernel panic noticed.

mem.c:147: PASS: victim signalled: (9) SIGKILL
mem.c:232: INFO: start OOM testing for KSM pages.
mem.c:140: INFO: expected victim is 22880.
mem.c:39: INFO: thread (ffff815e21f0), allocating 3221225472 bytes.
mem.c:39: INFO: thread (ffff80de11f0), allocating 3221225472 bytes.
mem.c:39: INFO: thread (ffff805e01f0), allocating 3221225472 bytes.
[  466.027773] BUG: Bad page state in process oom01  pfn:76283
[  466.030488] page:ffff7e0000d8a0c0 count:0 mapcount:0
mapping:0000000000000000 index:0x1
[  466.034501] flags: 0xfffc00000000100(slab)
[  466.036606] raw: 0fffc00000000100 dead000000000100 dead000000000200
0000000000000000
[  466.040243] raw: 0000000000000001 0000000000000000 00000000ffffffff
0000000000000000
[  466.043931] page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag set
[  466.046974] bad because of flags: 0x100(slab)
[  466.049078] Modules linked in: crc32_ce crct10dif_ce fuse
[  466.051636] CPU: 3 PID: 22882 Comm: oom01 Not tainted 4.19.150-rc1 #1
[  466.054711] Hardware name: linux,dummy-virt (DT)
[  466.056906] Call trace:
[  466.058159]  dump_backtrace+0x0/0x190
[  466.059980]  show_stack+0x24/0x30
[  466.061560]  dump_stack+0xb8/0x100
[  466.063272]  bad_page+0x104/0x130
[  466.064761]  check_new_page_bad+0x80/0xb0
[  466.066500]  get_page_from_freelist+0xeb0/0x14e8
[  466.068508]  __alloc_pages_nodemask+0x12c/0xdf0
[  466.070466]  alloc_pages_vma+0x90/0x1f8
[  466.072164]  __handle_mm_fault+0x59c/0x10d0
[  466.074014]  handle_mm_fault+0x128/0x210
[  466.076069]  do_page_fault+0x150/0x4d8
[  466.077861]  do_translation_fault+0xa4/0xb8
[  466.079890]  do_mem_abort+0x68/0x110
[  466.081479]  el0_da+0x20/0x24
[  466.083041] Disabling lock debugging due to kernel taint


Full test log link,
-------------------
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.149-39-g204463e611dc/testrun/3273175/suite/linux-log-parser/test/check-ker=
nel-bug-1817703/log

Summary
------------------------------------------------------------------------

kernel: 4.19.150-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 204463e611dc07092b63dd18658ad7efc3dd1252
git describe: v4.19.149-39-g204463e611dc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.149-39-g204463e611dc


No regressions (compared to build v4.19.149)

No fixes (compared to build v4.19.149)

Ran 34073 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-dio-tests
* ltp-io-tests
* kselftest
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* network-basic-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
