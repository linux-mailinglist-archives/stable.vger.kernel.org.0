Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11A39A98E
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731700AbfHWICo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 04:02:44 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36152 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbfHWICn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:02:43 -0400
Received: by mail-lj1-f193.google.com with SMTP id u15so8031534ljl.3
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 01:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rL4KTmANqkNL+vqRdcGR+JlDxVov3q/FihV0pTPq55I=;
        b=cUOH+YhTQ1B3AbSjszPSM6uIzUwdE72M6buSuNva38RPEITpkIxXx3yOyDD4FhIhxo
         82NcQT46kaj31sQkj1DGHefJ1jL7aa2bV65of/4mQ5SQaEfsVf8N3sEsW53Bjg6vTWux
         m5d/SaKZxcEZR/S8Zdzh+Src0Zc8fRqg7tHEzt53ta2J84sCTb+dTp47kmee4f7nESjA
         XxJzZlipTEi3CgD2Z+oVXJieTUk8Ap0785ntqXwtSbzzw/EdykG1hYxBI0a2BvF4tCBm
         /PniiCCLjAL5t0RmCt9qJTm7ul/9YxhRhjqNBvi91Alz19dkzYHrXTKPYWJVk2qpPQEy
         8i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rL4KTmANqkNL+vqRdcGR+JlDxVov3q/FihV0pTPq55I=;
        b=fnH78zVdZgvfYSObP8EWZbmkUfB6Np19eQkDqdxcXJ1uAeF0BPrAb/yCii8tDG/vGd
         tJlxAsu+iGv9uYlaTfbTlfo+wLJPYGzISFoP1MRQ9K7Z9ULXMZvtR3TL9dg+fln0K735
         acK/lsANdwAMhnlpe/uuSPRmrJDKONj4cRjUJFLwuDTh/GEMshH7hkFwlLXx5URJSWxp
         AJ2a3l/epWMoWNEX+bT55Gkcn40FFOPgcRwprp/iJnIIs44mWE0rbw4cNsNhSxIr2928
         7dSDs61HDJOsS+fhmUKgE9+uU+Li9Mf+kLaGdJZ5RSMAwJ6U4JQ6Ixwkl+xJ90wlzsk2
         htCA==
X-Gm-Message-State: APjAAAUgWAuz955FldRflS3jrm+1r6VWjYv6V6LXH1B3hmuNDPUhmHSY
        NS4Tswqan5xonK1eyVSDESDZ87Mbvq40moixZp2Cxw==
X-Google-Smtp-Source: APXvYqxUcMiVaMm7wZ/mZoeHT4PGedcrXbkbTYajtt3LM0QrRqqHkenjrWPFoaPogeBoFH6/U9dyQ3W1tVW5HWDlUFo=
X-Received: by 2002:a2e:800a:: with SMTP id j10mr2084390ljg.137.1566547361926;
 Fri, 23 Aug 2019 01:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190822171728.445189830@linuxfoundation.org>
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Aug 2019 13:32:30 +0530
Message-ID: <CA+G9fYtbzzKzrVW=yBFsOGQVUTviny4Dnv1bYZSp2bn4hd--MQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/103] 4.9.190-stable review
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

On Thu, 22 Aug 2019 at 22:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.190 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 24 Aug 2019 05:15:44 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.190-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.190-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 7a35fdc061cdc806d06bb3a34ed5c9c0d08ffc0d
git describe: v4.9.189-104-g7a35fdc061cd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.189-104-g7a35fdc061cd


No regressions (compared to build v4.9.189)


No fixes (compared to build v4.9.189)

Ran 22554 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
