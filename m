Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3419A213
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgCaWs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 18:48:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35098 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731259AbgCaWs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 18:48:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id k21so23802463ljh.2
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 15:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7EgE3rQUBwKB+OsNaorPCoGcvdaSTA93aqDrB6D4TEc=;
        b=gkLrXlWeXFOSVICast5Vdl5R5P3IOcA/C6dTpriALza9D4E6Y6Qd652tVMYoj2pY3P
         DN47bRyHES/yPSQOm7K3SMnISIFaCOSoghFeabV7lMExqinTjNSHkz7tKMQ+H19tgYzl
         A9372xTpCD9MIMVGWYWT+F5jGZWz+Fs2zGfe2w+2SUu/Il1cptPCYi0tM/+XZRpAIR3D
         xJ4G3wavpa1cE53/NVAoTG99j8pRrrnlsWvC0aUIASE8vWsF6GaozXk/FWJKf698GgGJ
         kffciFjXKMUs3pCMAGQDP4ubtD5jtjSITiT14urXLT87awxyqjDtvVLgtoSMrntQJLEB
         9oKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7EgE3rQUBwKB+OsNaorPCoGcvdaSTA93aqDrB6D4TEc=;
        b=syeIXVFOd17DK0qt537kYPD9mBTS0ohSv4M2Vdzv6quJe05/RMi5G/CldgBBUJ+87j
         BvwyTxz+i9w5ZcWsXNqeRybcZ+vYYFYDSJTc4DbZk8fQRzEDIf2iimnU0zdKph9viV/+
         3LPbTb2SEeC1a62oRoEy8pvNDNvtk1Cm0eDFTdrRpc/B8xpRA5pQMrr705n60TrcGWSa
         cXLIgkwYGBwQhJZaVIvpiZFo7zdU+j1Ra3rAuKfmqVIaHtt+8eXtfLz49Itgu7SYlDxA
         RB8o8pZ/9O+ZhfKMoV3cSus0bm2gAyxFza+s/INQ4SaEd7Tf2gBmPRq3q+vQQuSZigJI
         VH5w==
X-Gm-Message-State: AGi0Pub/RmlInCej4YzD5O5qozyCRPQM83ot2dXQrRjaFIzV0fCCSx9f
        X7SPiv1qtOTh1ZiahmoWbcnYvA/NLcMwP9k6vzf9Iw==
X-Google-Smtp-Source: APiQypJ+B+qhItODgJVwcNmLxHZLIAdDTta58U7ToLrZU85bMoPFj8kp5unGdwCGxs81XDXJ/rJlN0fJg9AFRYY2PLs=
X-Received: by 2002:a2e:8015:: with SMTP id j21mr10850819ljg.165.1585694933444;
 Tue, 31 Mar 2020 15:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200331141450.035873853@linuxfoundation.org>
In-Reply-To: <20200331141450.035873853@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 1 Apr 2020 04:18:41 +0530
Message-ID: <CA+G9fYuU-5o5DG1VSQuCPx=TSs61-1jBekdGb5yvMRz4ur3BQg@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/171] 5.5.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john.fastabend@gmail.com, komachi.yoshiki@gmail.com,
        Andrii Nakryiko <andriin@fb.com>, lukenels@cs.washington.edu,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 31 Mar 2020 at 21:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.14 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2020 14:12:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.14-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on x86_64 and i386.

selftests bpf test_verifier reports as failed.
This test PASSED on v5.5.13

#554/p jgt32: range bound deduction, reg op imm FAIL
Failed to load prog 'Success'!
R8 unbounded memory access, make sure to bounds check any array access
into a map
verification time 141 usec
stack depth 8
processed 16 insns (limit 1000000) max_states_per_insn 0 total_states
1 peak_states 1 mark_read 1
#555/p jgt32: range bound deduction, reg1 op reg2, reg1 unknown FAIL
Failed to load prog 'Success'!
R8 unbounded memory access, make sure to bounds check any array access
into a map
verification time 94 usec
stack depth 8
processed 17 insns (limit 1000000) max_states_per_insn 0 total_states
1 peak_states 1 mark_read 1
#556/p jle32: range bound deduction, reg1 op reg2, reg2 unknown FAIL
Failed to load prog 'Success'!
R8 unbounded memory access, make sure to bounds check any array access
into a map
verification time 68 usec
stack depth 8
processed 17 insns (limit 1000000) max_states_per_insn 0 total_states
1 peak_states 1 mark_read 1


Summary
------------------------------------------------------------------------

kernel: 5.5.14-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: b487728d5e18490b0e551a6518d0647ae641ca3a
git describe: v5.5.13-172-gb487728d5e18
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.13-172-gb487728d5e18

Regressions (compared to build v5.5.13)
  x86_64:
  qemu_x86_64:
     kselftest: bpf_test_verifier - FAILED
    # Summary 1577 PASSED, 0 SKIPPED, 3 FAILED

No fixes (compared to build v5.5.13)

Ran 27293 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
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
* v4l2-compliance
* ltp-syscalls-tests
* kvm-unit-tests
* ltp-cve-tests
* ltp-open-posix-tests
* network-basic-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

ref:
https://lkft.validation.linaro.org/scheduler/job/1327830#L3067
https://lkft.validation.linaro.org/scheduler/job/1327830#L3067
https://lkft.validation.linaro.org/scheduler/job/1328415#L1656

--=20
Linaro LKFT
https://lkft.linaro.org
