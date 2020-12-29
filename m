Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE22E6F0F
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 09:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgL2ImC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 03:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgL2ImB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 03:42:01 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044AC0613D6
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:41:20 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qw4so17199443ejb.12
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tn21V+pCRMg2easgZyrnpT+BudBtPuEemdCDqgnAeq0=;
        b=k6mMnyGjWRW0LWx+WWYDpZtjaci5zL2iRFpP4bJ/C8b/Yrq6T2Hios2uSQWDOAryVm
         e4cC31AxgDAxIkBTeyonOKNSurtb/pqm2bpnWGfMQCEBM6aOX9K1xUTZJ9q9+wzCId9/
         VOprhaJCRCgfiv+9DbS+OOFm43QQPyfByD+BhbUcVeK5SG4pvw40+yXyr5cBPY+XAQfc
         7pEVYXwPDsOqdrZNv7afa5jJp1PTM0hDVrkGHJ6l1+uO7vKWx5r6wBwymlDaqx96j8mE
         PRMDvr0RttPWmGfu3zY6y3PP0Nhj0MjYevXDHROWHjOTIii+biUzHefNXv0zagoU2AMw
         WhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tn21V+pCRMg2easgZyrnpT+BudBtPuEemdCDqgnAeq0=;
        b=RFrCGC8QY53d6C80TtzRsXsjYtr1e2jf247IvOznYadRr3WtuoSa9ihLmDlDnqJYpH
         HZ/Qrks6n4CvxIRMkLE+N6czQewey0WPuHSsXZD9WE8jwHRphb48XmDoK3rAvDgqtmAu
         XvWFbVLjOqIROr46hoPhm9JsRZK3a9JPd9qaInJ60AP1jPikonC0rdt8wC38LzAT8het
         HRfvXFCcbVmeZETMW3WB7iIgMEbwEJ8ucL+jiFXmlSw11JoraKrPqaKZtRKcEWnGf6oy
         h6b9vXvbSDvmWSPFgof13S2u4VOYX7OFVp58sLNCmDthwChoYGK8OkDp6E/E9Tge8CO+
         /C3w==
X-Gm-Message-State: AOAM532gN2xSZtDFYgHnh3GqlNfAfLpvCNOUyOMTBSzRxOPLBVeK8S49
        H/UfzdwmgFxX3vUpen3kP0t16yAPu+QHEVasp0/PEY7clIYs1tNq
X-Google-Smtp-Source: ABdhPJwteaHaGE8Vak5ItpDw14mQxo6AeonSQK3gs4+dgOji9mM1NEFSQH5ztI+7u/huXG5MZntUfVwyxd+NvDQrvms=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr44551331eju.375.1609231279592;
 Tue, 29 Dec 2020 00:41:19 -0800 (PST)
MIME-Version: 1.0
References: <20201228125020.963311703@linuxfoundation.org>
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Dec 2020 14:11:08 +0530
Message-ID: <CA+G9fYsPkLkdp8Bk553Ws+ch5PoCcDDa_dmCaUvTYL=S-OtQiw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/717] 5.10.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 at 19:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.4 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.10.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 404b2e8f23fd9530a213b3eb2b10868346c18c1f
git describe: v5.10.3-718-g404b2e8f23fd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.3-718-g404b2e8f23fd

No regressions (compared to build v5.10.3)

No fixes (compared to build v5.10.3)

Ran 52627 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* ltp-commands-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* fwts
* kselftest
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* perf
* v4l2-compliance
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
