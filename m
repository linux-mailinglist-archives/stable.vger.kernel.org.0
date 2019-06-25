Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BFB52013
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 02:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfFYAoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 20:44:04 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33073 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbfFYAoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 20:44:04 -0400
Received: by mail-lf1-f65.google.com with SMTP id y17so11359684lfe.0
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 17:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CqsSVwEbnPYR+CbblI/s5YoLiQL9z41UI6Zu+9qXwWs=;
        b=OUeMHhIm9MlrApudaCrTYD9zzrqDiS9ycnwcJlloFn/q2MLeodWmMItZXDp4Vg4Gyh
         v8MezQ0whTrozGzNjjxhqvsbl3ZCOFQ2O2aT0vmXRFBO75XiazhaETouEjuCuONqc1S/
         2WaE+Ic0oAothA6zinx7PtO/apd1i6c4Y2XVFEQqENkYXeOxqv5c3jB7OEWcqg9YnTvT
         tH8NEz6ijfLClwj/pF2k01xXMyw6/zdf1wHAEjKYjt53eiQll7PfzhW7Xx9EaF2WoSKP
         QxILUfPaeSk7UWL6JrkNgLx2aUz+BqNSqR4G68KIXeapdbwG1KZ1O3cU39WswOZgsqZ2
         DAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CqsSVwEbnPYR+CbblI/s5YoLiQL9z41UI6Zu+9qXwWs=;
        b=BsAZb5XeC2/1aCOUHdhVMHE44fsY3jG7fOD9ZNV7aa48tM6dB0uXbTT2Zq77lUhD4w
         hz9LmOPSs8sAtPPv2N4kZZesh5cJg0655ek833W8TY861F2+Sk/YJ2e1D0v8+gO4Ftil
         7I4fmpbsc2XIwHbmM6bfUCjjOTmE+vn7nTOZhPti5X6rsxorkhpEFLeXixyEuaR9H0gR
         oNDyWM2CNXFW8sJX++v5ciBZ1XzLXBxmnOIsBTGTR0l2H6RorVnEqoPuTIpCeJBeDLcB
         Ie7IEgAgwjiknbQB592B00Sy8AG8acvZrQApYOiZSRBzNk0si3HnpXK7NKnOniq7cSaT
         PfdQ==
X-Gm-Message-State: APjAAAVC4zslv6HuDwyRL6gD3lBPDalsJAL+PS2Kz5Iyu9HfTYF9CrQ5
        mvr6nze8WlqH1SPYfaf7h6NWUsx8HZLzhfVzMmhsYw==
X-Google-Smtp-Source: APXvYqzzem/0Ye5O7fzYnTekrmrIgKpQ2UbojNG5AXpf/0bao9mx7yxd442XtUHharIhnZ53stYUrmPodJW+QoA81/M=
X-Received: by 2002:a19:488e:: with SMTP id v136mr8494494lfa.192.1561423442252;
 Mon, 24 Jun 2019 17:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190624092313.788773607@linuxfoundation.org>
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jun 2019 06:13:50 +0530
Message-ID: <CA+G9fYuD6Enko_srw4NFPC_FsUPaLauLN4pp=AgxH6r-kaZ9Aw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/90] 4.19.56-stable review
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

On Mon, 24 Jun 2019 at 15:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.56 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.56-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.56-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d8e5ade617e917a499d5d59b24e19e71f80886a8
git describe: v4.19.55-92-gd8e5ade617e9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.55-92-gd8e5ade617e9


No regressions (compared to build v4.19.55)

No fixes (compared to build v4.19.55)

Ran 25252 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

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
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
