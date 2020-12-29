Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104372E6F60
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 10:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgL2J3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 04:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgL2J3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 04:29:21 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4E6C0613D6
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 01:28:40 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b2so12051415edm.3
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 01:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HepAVDKvZJWRYV8tscH7GI9jO51F7D0aIWXHAergF2M=;
        b=NjHUedr/HdYpwuFAEEa/ndjMId424eoBZz8EXlEoB5f6fc92TuEc7+PMAzdwvA6fMu
         2JxrcWjurNvWRrTQgy6H/mFGeuHTJrNHiHWrFqimidkZUuzT6M6JD2IwQgwT92lf0Vg5
         Dle0MnwNLHy96net+zTPdVXtU2EZt7fJV40GvX55+n0TH6JcWgdB6CW7+KfyhWaj+GLN
         OOds0pgOlucswOswXf2jpF/MxVltfATx+d2ikebZRNg7E/mbzZCktdmhsTSTiVvR3+SW
         b/oVMnZaC74/geDgVDeDF6yKIRsVfoaZsk9caIw6qRzCgjDNiGeuzdacH9yA+0Q4DVdR
         zMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HepAVDKvZJWRYV8tscH7GI9jO51F7D0aIWXHAergF2M=;
        b=FMFXDAHiWavlHcRw6g+V3MuODOHMvif/7nxJnJqALeBGEfOak9pYPc1Hzm1R/S/OmK
         UUGshZSbKYOnV+YHTUrhEYGV/Rkx8OTYoO0WjePHzSq8hC04qAon1z73oy/E/ZV848BM
         SDp1xE+nQUh71hMf7fg05MeBTfIv94xdBtw+83eQkVnsxaYL9yVYi3YewC8pAfMZ9qGv
         5nGjpEjDC+5dI75ahoA5AUEnB7EVjlT2y05VODBn9IJ9pNtv0kk9ZV5S9gK/u2P6/mFQ
         +ZJSIVTeOhqzJVMVppwNhmTlR0EksGFMOW0NvS5n8ZyQLgR3olPLlOpNst77XPwBN0Z7
         azYg==
X-Gm-Message-State: AOAM530XSUzGkjpXrjPeYL42ejChlVMi81EpZT+7URKrTDcD1k+BkIv0
        s1eMxSFmNiY7kqr4fpK+4dhHb2g7IPfgpqaox9ukgg==
X-Google-Smtp-Source: ABdhPJyy2UZPrlaVuwxKSwpyQBUYDAqppA2beL/7simyxJUF6Ncydj1hLXJDWvOslR7EW7O8AMx7sJYAedaTEVEmMLY=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr45208651edb.365.1609234119050;
 Tue, 29 Dec 2020 01:28:39 -0800 (PST)
MIME-Version: 1.0
References: <20201228124853.216621466@linuxfoundation.org>
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Dec 2020 14:58:05 +0530
Message-ID: <CA+G9fYsgQk4kFXm8uaj-DaPHEyT2knO6q1cRr7=CkiFP+WUQxQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/175] 4.9.249-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.249 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.249-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.249-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: cde5fe0304e36dea08f5ad6651d19a906da97d71
git describe: v4.9.248-176-gcde5fe0304e3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.248-176-gcde5fe0304e3


No regressions (compared to build v4.9.248)

No fixes (compared to build v4.9.248)

Ran 32769 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* ltp-commands-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
