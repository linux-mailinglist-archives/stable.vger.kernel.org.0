Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85B776BE
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 07:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfG0Feg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 01:34:36 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44087 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfG0Fef (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 01:34:35 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so21539098lfm.11
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 22:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8ZlpG1RycHrLNXBWwG+B73zSqptir9sCoAeiMtSDrbk=;
        b=Yr5W0JlC2BM8vS38natdzRIcaHrKp4/emzfzTrUHTk2HdW2fmfOzVV7pp4aSGSdNTL
         A6wZbTDts/SYMsS0JGWtWxFz0Zqx/XRa4aaJIwaBfh7NcoOASAP9CytjrSRSp44haEG2
         V7VQSeyRheA3QHPY3LTjfr39ecMnO3Lg/xmeC74jfEiqWnBJMs+McW6NmBWSIH80Rn1s
         ToOSij5UMEmDpUA2c0m2QW7qm5b+umoFI2umDvZb3P/BbiEWCHdF1F2BVHKOXoO6uRMK
         4mEX6svrzp5rmY6wh5iWLp8/PR11wxn9DZSmLh/JMNcoIMlQz8G+XYQPJqzZter3x6vg
         AT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8ZlpG1RycHrLNXBWwG+B73zSqptir9sCoAeiMtSDrbk=;
        b=Z1p3Vzahog1qz6cnO4IhAewB2Vp+kE9Em5aM96+Xj0KdPmLX656knBXIGAy+yBSJ2Y
         3AwCxKBnKAqaY/AAsg6aYLNDJ5f2nr4Waf2MFCZAiellyX2WTpt+z9d0FONyfBBSSHhU
         AJGwDULTMo3wknA3xctm3uFHSJO8N2L30Md+YevGfOSp8Ei3G3DqUkvWgm1+jyWfaGx4
         KVHXMa95xxszgIYAiATzzYe4yH/tf8/+ORhSnP+HcVf9ZaGc63pKLHhvht8qvEyN7pyG
         qmuP+ZTo0MTAUesNZjAEDlq+f5zEIyiYHCZ2bAc0N8Fol2C7i6mPkGMs/KjchTmQ5QTO
         YG9A==
X-Gm-Message-State: APjAAAUzGbXSflC1Hitfa8qgRuc3CEEwgQs0VThXjlESf5ja0ay2pebH
        2a6ARlUDOZS12do/D3Qkq+Z5VjL40JfkwOfX3SItyg==
X-Google-Smtp-Source: APXvYqx1P8IViFSbKD/fdJc59AokS+vmW8EkSn2rrw8Z41xTZfMiH2r33+Iv/EuTdsKpcngFU/DaQj/TEZMZLHNLUgo=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr34652695lft.132.1564205673316;
 Fri, 26 Jul 2019 22:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190726152301.720139286@linuxfoundation.org>
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 27 Jul 2019 11:04:22 +0530
Message-ID: <CA+G9fYvO38S6mS8LuK6pWJbQGnE76ynXBWvEF-8WoYODT=zPHA@mail.gmail.com>
Subject: Re: [PATCH 5.1 00/62] 5.1.21-stable review
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

On Fri, 26 Jul 2019 at 20:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Note, this will be the LAST 5.1.y kernel release.  Everyone should move
> to the 5.2.y series at this point in time.
>
> This is the start of the stable review cycle for the 5.1.21 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.21-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: f878628d8f1efc883e9bd6f9f81173194b4a01dd
git describe: v5.1.20-63-gf878628d8f1e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.20-63-gf878628d8f1e

No regressions (compared to build v5.1.20)

No fixes (compared to build v5.1.20)

Ran 21561 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
