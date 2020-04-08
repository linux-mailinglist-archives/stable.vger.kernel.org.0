Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3E1A1E3C
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 11:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgDHJq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 05:46:59 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41721 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgDHJq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 05:46:59 -0400
Received: by mail-lf1-f66.google.com with SMTP id z23so4642067lfh.8
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 02:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5ZEqYs9/2BfZyzfJ6sBTN+E+rXFiv8U9jrRvKOm4ilk=;
        b=sBWm3XQ4Lss/pwUc7B8y9xIWqsKxJE6a/T7kIzCSI9LSlVn7zrOu13ALFPcJ6JP/vu
         fALqinhST1iGWyM5is18o0fxiU4P2On+X3Eo/R5LuMkFwe+4/eS0i1Xjhq1xjpAYdQ5g
         NSkyT2Wu0j5bbd9gBzNFmwCfefLpFUkz01uQ5g6N4f5GGjO9jbowTxK+WU3KRuWopbiI
         4zEFj2AYJjyuT8QraYEvA0fdCr74IbHnmHqATwt486RdHH0WHZlhpRSOGQzBjZNdjVpJ
         Ei9sATQkcA1I/0RUK6wnw8gMs0zhsRc7hpS5yNMl5SNy0zlmx/CM40v6zlVQX8l6+rs0
         fdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ZEqYs9/2BfZyzfJ6sBTN+E+rXFiv8U9jrRvKOm4ilk=;
        b=Ly2sGhojOybYc5lX4YdVUlF4xVRarfkYbvK9ya3xxzlrsJHrJUd/WoVQvovMFJS+Yf
         XVGcTegj5HyUztrZuNyjBLBlzSEilKqO+XBFUmT+g9/nI2bfiAI4URznKUP6N6im+kXy
         NugP948krHtYcXa8KsR6Puh30aujcwgRvQjcbGBoiTPyyHEAZmRl684UooQlb+THpj3s
         jTC0d2XFYcXIIi1cdr/S6B8ZGfkYyEpuVNlgalIsSkiJBx9+4WXCvZ+xcJb/a2MXUEJI
         ClBX6cJCNsY4nf5/ZuFRwHI4Y9UApKTFc6qfWSnUQbhyV2Z/SrbVX1matJkdHDE/rqTC
         hDbA==
X-Gm-Message-State: AGi0Pub2BCQCbYabnuqVGFo80E0jIGeZTgblGl5ka2u4CwxuLmbeQ6qd
        9KYkQMMCBL9kxAoaQCHG/jNtSpR5DxA8aOePmiT6sA==
X-Google-Smtp-Source: APiQypIOVx2GfdURM7yySr9VeO0nMTl+MBnuRLvhggtPUXEF/5iNmJZ7ogoUv6bICo+ytpbRpSOsPs65z50Usuhmh70=
X-Received: by 2002:a19:c64b:: with SMTP id w72mr4031364lff.82.1586339217230;
 Wed, 08 Apr 2020 02:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200407154752.006506420@linuxfoundation.org>
In-Reply-To: <20200407154752.006506420@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Apr 2020 15:16:45 +0530
Message-ID: <CA+G9fYsyETNoV58oyrBtb2o_vyFi1MPUNkZ9uUZK6uRCg5OK5w@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/30] 5.6.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Apr 2020 at 22:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.3 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

There are three kernel warnings on stable-rc 5.6 two of them are also
present in Linus's tree.
So these reported issues are not the release blockers.
The Source of these warnings are reported while running kselftests.

1) This warning reported on the mailing list and discussion is active.
Warning reported on x86_64, i386, arm and arm64.

[  346.741358] kselftest: Running tests in lib
[  346.872415] test_printf: loaded.
[  346.876442] BUG: kernel NULL pointer dereference, address: 00000000
[  346.882703] #PF: supervisor read access in kernel mode
[  346.887844] #PF: error_code(0x0000) - not-present page
[  346.892990] *pde =3D 00000000
[  346.895877] Oops: 0000 [#1] SMP
[  346.899025] CPU: 1 PID: 6060 Comm: modprobe Tainted: G        W
    5.6.3-rc2 #1
[  346.906772] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  346.914261] EIP: ida_free+0x61/0x130

ref:
https://lore.kernel.org/linux-kselftest/CAFd5g46Bwd8HS9-xjHLh_rB59Nfw8iAnM6=
aFe0QPcveewDUT6g@mail.gmail.com/T/#me600a8093338a485291361aaf9439e8b2f08a20=
f

2) This warning is reported on the mailing list and waiting for response,
warning reported on i386 kernel image running x86_64 device.

[  166.488084] ------------[ cut here ]------------
[  166.492749] WARNING: CPU: 2 PID: 1456 at
/usr/src/kernel/kernel/locking/lockdep.c:1119
lockdep_register_key+0xb0/0xf0
[  166.503357] Modules linked in: algif_hash af_alg
x86_pkg_temp_thermal fuse [last unloaded: test_bpf]
[  166.512481] CPU: 2 PID: 1456 Comm: ip Not tainted 5.6.3-rc2 #1
[  166.518306] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  166.525776] EIP: lockdep_register_key+0xb0/0xf0

ref:
https://lore.kernel.org/netdev/CA+G9fYt7-R-_fVDeiwj=3DsVvBQ-456Pm1oFFtM5Hm_=
94nN-tA+w@mail.gmail.com/T/#u

3) This warning is only noticed on stable rc 5.6 and 5.5 seen only on arm64=
.
This needs to be investigated.

[  386.349099] kselftest: Running tests in ftrace
[  393.984018]
[  393.984290] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  393.984781] WARNING: suspicious RCU usage
[  393.988690] 5.6.3-rc2 #1 Not tainted
[  393.992679] -----------------------------
[  393.996327] /usr/src/kernel/include/trace/events/ipi.h:36
suspicious rcu_dereference_check() usage!
[  394.000241]
[  394.000241] other info that might help us debug this:
[  394.000241]
[  394.009094]
[  394.009094] RCU used illegally from idle CPU!
[  394.009094] rcu_scheduler_active =3D 2, debug_locks =3D 1
[  394.017084] RCU used illegally from extended quiescent state!
[  394.028187] 1 lock held by swapper/3/0:
[  394.033826]  #0: ffff80001237b6a8 (max_trace_lock){....}, at:
check_critical_timing+0x7c/0x1a8

ref:
https://lore.kernel.org/linux-kselftest/CA+G9fYtYRc_mKPDN-Gryw7fhjPNGBUP=3D=
KemTXaXR6UBU94M3hw@mail.gmail.com/T/#u


Summary
------------------------------------------------------------------------

kernel: 5.6.3-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: f106acd0db7c11e0208a2ecbeb0f7c52fc6c455a
git describe: v5.6.2-31-gf106acd0db7c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.2-31-gf106acd0db7c


No regressions (compared to build v5.6.2)

No fixes (compared to build v5.6.2)

Ran 22476 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
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
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-containers-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test

--=20
Linaro LKFT
https://lkft.linaro.org
