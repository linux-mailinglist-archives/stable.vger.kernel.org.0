Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29586778F
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 03:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfGMBuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 21:50:50 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36866 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfGMBuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 21:50:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id c9so7616639lfh.4
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 18:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cwnrf/9byyflIo6YMGxfrqoYzi06WQZC+mSq1JMXN7U=;
        b=EEbPmXsva9SynhXoxLOdGglpkM0S2fpSA/VKwy7pPmpfSD/eWTKeMfqKdouV0yKk28
         1Muvy+e3ZkqaX66fXU+08yWT7jQ9O79DRJjNGVvdlUIbisQthtE0fn88mUE6M0DHXFcL
         i37Qrl5EMIQy+P7Wwti5bLfncvna/LHStbN5hhi8JICY9fpzhnBtBXtDFN/npPFSnhlR
         7KP9+XOTfJgi7jYZFS//Asz/Gr0/xN8riEv51CUTztnlN4X/9mbvpInQwEbs3A9qvLsf
         39pUwLOjBWlgcfyPJEX+cqyKeLG0UOWgiFDF2Z1lzfihWsa2I4xg8FSaibgWVHa/UX0D
         9e7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cwnrf/9byyflIo6YMGxfrqoYzi06WQZC+mSq1JMXN7U=;
        b=VNDHMamsESP6sqWS4TzEjKAQi+UKHDf3QDDk4zTFGlBi1tnJF7OtxyzCIPOZBus82Z
         AGlNMzbY/FZ0p51Kuhw3hXl9TTQMaPt094BMg9RSgf6SzixXMjDnhXgC4TTba3nHN2Cz
         9d1NTaSy5nfgTEl154DVj2EwZ3XY5QSy/vSkrLWa6ysf3lAm5pJijQ4JWtvp1+9etiv+
         y5Ro97FxtiDgLPQx2mEursRZb0GkgcZefKMbAqR4ef5eYWT91OMX288XaDFhyXVoxewh
         CxJTfwYWInd/ErRiLn2mmaervhFieTxmWmw4cU8E9aR4BKV4CP4Cl9g2Bj1T4JHKru7Q
         vdDg==
X-Gm-Message-State: APjAAAWKpAJQY+/p8dBAWykBCaRKO9UQN3bwCtUbFLWvkG2fSthSmQo+
        cn+34zIKm4cjINiAXsw+iRbukVTHrI/X32h5fvUEXw==
X-Google-Smtp-Source: APXvYqy/sldFP0VPKayiwbjPgTv09+NhoWb/JNuDib//V9JJ9SXm5o3dnvWrsKkV29xTsBc0TVBnuImfn2wzEseGt4M=
X-Received: by 2002:a19:8c57:: with SMTP id i23mr6036401lfj.192.1562982648223;
 Fri, 12 Jul 2019 18:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190712121621.422224300@linuxfoundation.org>
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 13 Jul 2019 07:20:36 +0530
Message-ID: <CA+G9fYtTVpCcnH6Hrz9ZpLUYdzP+Q9A+h86HLbn+Re5JqD=H7Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/91] 4.19.59-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Jul 2019 at 17:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.59 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.59-rc1.gz
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

kernel: 4.19.59-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d66f8e7f112fefe0c1d2a0f77da022a56ccde6dc
git describe: v4.19.58-92-gd66f8e7f112f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.58-92-gd66f8e7f112f

No regressions (compared to build v4.19.58)

No fixes (compared to build v4.19.58)

Ran 25278 total tests in the following environments and test suites.

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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
