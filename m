Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5992C2D0B74
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 09:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgLGIEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 03:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgLGIEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 03:04:39 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528A3C0613D1
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 00:03:53 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ga15so18168084ejb.4
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 00:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ubdvv4RcYFwcs44+1Q+bf4oDunFVL2/v2wPXLvUfjgY=;
        b=OBEqyLFPDo3mO1YltDeQnpsjlH1rQDnQXXhXeGegH/CA1JbHmETM1xQ4wvWMD4pO49
         JgE+LDJrlWPKOop2xgKIJ8aIC+ED1zr1u3QjmpC1t+a1VaOOD03BSudqI4P9W6kb6Iwy
         ytc/V7vHqlgbmQvidcYSj+VoHcIfJ2bVXEXx2bXUbuU/4kG8eOco/BgtJ0ZbxaAXGNgV
         WQR+XteLAdi9cy7WM5UOFZrlJCC1aEtlHZO4Frr18xXT80bJXwyKxsdvIBGWYQiVyB2f
         XjNn/OoKpetYwQKGESHnkAOlNjCWyFpeyv0Azp4GmleE+PG4Ivjm0y3Co9Yn7k2fSbqT
         SQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ubdvv4RcYFwcs44+1Q+bf4oDunFVL2/v2wPXLvUfjgY=;
        b=BU6WLJJJtxtbU9S/5y5a3zFNCpjQqu735Iit1s038riPk5JTiIF0znDmJW0zjBiEQA
         JYtWXquBR3pc0ziOCSIalUJXeMGLEpVV67W6YB0l9LbC5rG6OBP9NtoymwCqtZPWfwqs
         c2IdqrBaKbuqzHDJWE9Qp4ktilkQow039UjZ2c/I3YQU6s5eBYOlN9npoOzxkaZsa0qu
         bCg6RMsb539p9MBrFPbWyYlD3b666hsSv93wg/8mA46kSmbjsoA+uzv2rZYeinhMlSuQ
         XIyv2T1nL5q9sBxXYzhv7NQr3sqSLJ7lH0Id9HmiCxlBXIZUHDzFKHUvIGHcqjgv/hZN
         u46A==
X-Gm-Message-State: AOAM533N0USM3R2lVDJKvXRRBiusOX2rMWuXhQJeMjwCT3Z6/0cIjYFy
        S7RVXLddsaxwA4QwpfJlJ0T/6ZV64Qc2d42tDT6Odg==
X-Google-Smtp-Source: ABdhPJzdE/OoTpeXoZkbhKIzXJyGacWn43/7YmGVU+I1AkK4/RbfwK5b3bKhHOmdfgd6+nKaaU1/+twqAj/6fgfrH7Q=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr17600514eju.375.1607328231815;
 Mon, 07 Dec 2020 00:03:51 -0800 (PST)
MIME-Version: 1.0
References: <20201206111554.677764505@linuxfoundation.org>
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Dec 2020 13:33:40 +0530
Message-ID: <CA+G9fYt_KqsrGQM4=+hToOs+Uihw07228NSP2mMxSh669mCO-A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/39] 5.4.82-rc1 review
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

On Sun, 6 Dec 2020 at 17:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.82 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.82-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.82-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 08a1fd1f5653a704bab8d0da9940b59073a56d04
git describe: v5.4.81-40-g08a1fd1f5653
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.81-40-g08a1fd1f5653

No regressions (compared to build v5.4.81)

No fixes (compared to build v5.4.81)


Ran 51117 total tests in the following environments and test suites.

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
- nxp-ls2088
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
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
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* kvm-unit-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-sched-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-io-test[
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
