Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C2474CB0
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391699AbfGYLQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:16:33 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38994 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390411AbfGYLQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:16:33 -0400
Received: by mail-lf1-f65.google.com with SMTP id v85so34210292lfa.6
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0U3JNBmNGYy0aqS1fsdwYku9ZRDxCCZwgG78ptzr3/s=;
        b=sPTFxew2HVdu5JYRV5YO/NUgdrasvKQ+2+/g+OQiWM2wL6nRSGlCQdjNlv1qdjFNwI
         nVadL2bFBk8wbP2jGGsefYXpmS8Xw2647+VU+WAklkXrHqbX3KjgeISof/YsyX8QRRFk
         wqTB+ipAZ0PL6X20wB2XEuyKPU3oDVcmZDYFu1qPNIuFCAq5JahdkrYK2ct3wVY6FlA3
         ffAVw9/DVvSNcO1RJv7qlBl4cBle25tgkCZaR1k9379tRO4UqLbk5Lv5FDq65yaPRE9z
         PuI4h7yCkEBODiN8cnW468URr2Jl/l8/zcHo3tGkx5Kmab4NT6kafF1zLKRA6wJBQZXz
         s+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0U3JNBmNGYy0aqS1fsdwYku9ZRDxCCZwgG78ptzr3/s=;
        b=eL/sCibzy/qQ5p8f8fcmoQgIoOaVM5qy04FDbrMGzul/cr1W+J7TyEC8Q51clJx3ad
         IyTryrg8uAcwNwA0h2w4ZamiIwUzS21FAOR0pulxHs6xBAgESpdNY14tPqbAJoXhAIPd
         RHo92KcFThiwtpFXzDeAUGqNsroXOPkDS21md13x96aaUX8vnSDXRQX2rg3QMuitt5yw
         /p1V4FeWWXWm0LpsESFDINVOcpimmnDYKwwPulxzS1wCta2To4qJ4Snv1hE7uMOSNkC9
         /qveWq1C7jQPa7u1FdOcJrKGntMYN6IINRD+pQOEXtTVJu2i1N6ZEtlkcafy6Z70L5cF
         EWsA==
X-Gm-Message-State: APjAAAULW3is0DO/R2sPl0GAHq6wVSkAHxKl4bOaPqMmZOtI28TGOQJd
        3qGBpQpybuCPMSiesOahu/vm1T+XtqwtLSvXLLFfTw==
X-Google-Smtp-Source: APXvYqz5PSnz2vtWF1fvHXLKMELKN6t99rqUeay6/XuKtapo4XVBKVhmMFaoEsJ4IbsO3WUWJ9kwszBYIGRHqcGtcL4=
X-Received: by 2002:a19:c514:: with SMTP id w20mr41342873lfe.182.1564053390533;
 Thu, 25 Jul 2019 04:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191735.096702571@linuxfoundation.org>
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 25 Jul 2019 13:16:19 +0200
Message-ID: <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Jul 2019 at 21:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.3 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected.

Summary
------------------------------------------------------------------------

kernel: 5.2.3-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: db628fe0e67ff8c66e8c6ba76e5e4becfa75fe21
git describe: v5.2.2-414-gdb628fe0e67f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.2-414-gdb628fe0e67f

Regressions (compared to build v5.2.2)
------------------------------------------------------------------------

x86:
  kvm-unit-tests:
    * vmx


TESTNAME=3Dvmx TIMEOUT=3D90s ACCEL=3D ./x86/run x86/vmx.flat -smp 1 -cpu
host,+vmx -append \"-exit_monitor_from_l2_test -ept_access* -vmx_smp*
-vmx_vmcs_shadow_test\"
[  155.670748] kvm [6062]: vcpu0, guest rIP: 0x4050cb
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x1, nop
[  155.681027] kvm [6062]: vcpu0, guest rIP: 0x408911
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[  155.690749] kvm [6062]: vcpu0, guest rIP: 0x40bb39
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x1, nop
[  155.700595] kvm [6062]: vcpu0, guest rIP: 0x4089b2
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[  158.349308] nested_vmx_exit_reflected failed vm entry 7
[  158.363737] nested_vmx_exit_reflected failed vm entry 7
[  158.378010] nested_vmx_exit_reflected failed vm entry 7
[  158.392480] nested_vmx_exit_reflected failed vm entry 7
[  158.406920] nested_vmx_exit_reflected failed vm entry 7
[  158.421390] nested_vmx_exit_reflected failed vm entry 7
[  158.435795] nested_vmx_exit_reflected failed vm entry 7
[  158.450276] nested_vmx_exit_reflected failed vm entry 7
[  158.464674] nested_vmx_exit_reflected failed vm entry 7
[  158.479030] nested_vmx_exit_reflected failed vm entry 7
[  161.044379] set kvm_intel.dump_invalid_vmcs=3D1 to dump internal KVM sta=
te.
FAIL vmx (timeout; duration=3D90s)

kernel-config: http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/inte=
l-corei7-64/lkft/linux-stable-rc-5.2/14/config
Full log: https://lkft.validation.linaro.org/scheduler/job/836289#L1597

No fixes (compared to build v5.2.2)

Ran 22506 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
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
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
