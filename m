Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA472178B24
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 08:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgCDHN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 02:13:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37708 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgCDHN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 02:13:56 -0500
Received: by mail-lf1-f68.google.com with SMTP id j11so600834lfg.4
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 23:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UXIPANIIzS72BLZ6PwQZTF4f2nVTT+4EeBrm+Bhq4LA=;
        b=WQOJLzMDZ7KAS8DRBxiAjaOw0NsOs2r6OKYoiRbi5e/ev5ttmnHsIpiP+r4XXIUPNN
         4mkyITqOpUxLvIW+FWrmezRasiaO+5pgJXSJVwCV6T5juEiyfPckNsrHTNJ+qswJCLCz
         Uj0ARyblY6s5PBDsBBlAaXmtSGa5aVHxQk9cLqiQ9pAkC22n7VQjk1BFfy8GoS8LUyt1
         p92/j6tV+z76u99YoVCi9uY3bVx2lEXb7FOJgXsjChYzIcJPNz0esahIidWVYqvA4MCQ
         5JJiJGCeeBajJaa3sjjgRp25y9XB2QmZuAMHjMhRn7fLoBbnEiEwe/Z4LXNjPm8dJL+t
         8XhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UXIPANIIzS72BLZ6PwQZTF4f2nVTT+4EeBrm+Bhq4LA=;
        b=F8dsk7KxVW1i3fJkrjQlpAJ0Rcfnuz6oWdHP+ZVOC7FBytD5a9AVYtCgecHDLM0NpH
         OMrvIeWgcweCwRZPv5vlo2354h8m3gviDSHqYamFNOr/DJ4oGaDzeyn24yOX3sTe+KBf
         kIxLxg+ln++jkRqA736a1zZI1xgMndCpqjsi1HZrYQKBgVhWhrrCq/TRNHfSw+Ys9rcJ
         cJ1U2kfpuJxgRDAUAXHyjQN88KbozBNKEgWKhbqyMNPERgINn8I87QdAzcZEyiOCWNqT
         NTnsoMuYYp3sUOAmNieEd/Y+kXZ7QCs7uAZhRI31N1Htdn1L6t89QYIM/B7VheIx6uvK
         B6Mg==
X-Gm-Message-State: ANhLgQ3WjQcYHfT7OY1YzlZFrjtHqLXu2eBhFUsu/gMK6JwmOkCgHTPy
        daSiFf8u/G9H149ueJBG43M4DeuIx2az7/qKWvz5uQ==
X-Google-Smtp-Source: ADFU+vtrS5lpAcD9SCSNGEAeOESpVpWFFgXLz6V2QndSOryvlZIeUTyAUVmb/0wLWR5iXrNz+V+yY8NMpAovfnROZuo=
X-Received: by 2002:a19:c215:: with SMTP id l21mr1130654lfc.95.1583306033384;
 Tue, 03 Mar 2020 23:13:53 -0800 (PST)
MIME-Version: 1.0
References: <20200303174304.593872177@linuxfoundation.org>
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Mar 2020 12:43:42 +0530
Message-ID: <CA+G9fYtNKXBOQKE_AD6qLoRo4TeaBYOc9Ce3kBxdLap1av4v=Q@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Mar 2020 at 23:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.8 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
Regressions detected on x86_64 and i386.

Test failure output:
CVE-2017-5715: VULN (IBRS+IBPB or retpoline+IBPB+RSB filling, is
needed to mitigate the vulnerability)

Test description:
CVE-2017-5715 branch target injection (Spectre Variant 2)

Impact: Kernel
Mitigation 1: new opcode via microcode update that should be used by
up to date compilers to protect the BTB (by flushing indirect branch
predictors)
Mitigation 2: introducing "retpoline" into compilers, and recompile
software/OS with it
Performance impact of the mitigation: high for mitigation 1, medium
for mitigation 2, depending on your CPU

ref:
https://github.com/speed47/spectre-meltdown-checker
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/tests/spectre-mel=
tdown-checker-test/CVE-2017-5715
https://lkft.validation.linaro.org/scheduler/job/1264643#L21206

Summary
------------------------------------------------------------------------

kernel: 5.5.8-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 3517b32c0774341d492140b2be08c4bf6d1a833e
git describe: v5.5.7-177-g3517b32c0774
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.7-177-g3517b32c0774

Regressions (compared to build v5.5.7)
------------------------------------------------------------------------

i386:
  spectre-meltdown-checker-test:
    * CVE-2017-5715

x86:
  spectre-meltdown-checker-test:
    * CVE-2017-5715

No fixes (compared to build v5.5.7)

Ran 25662 total tests in the following environments and test suites.

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

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* linux-log-parser
* perf
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-sched-tests
* network-basic-tests
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-m[
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-commands-kasan-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-crypto-64k-page_size-tests
* ltp-crypto-kasan-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-math-tests
* ltp-mm-64k-page_size-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
