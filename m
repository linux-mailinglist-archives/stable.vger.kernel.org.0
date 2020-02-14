Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D159215D54A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBNKN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:13:57 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45955 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbgBNKN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 05:13:57 -0500
Received: by mail-lj1-f196.google.com with SMTP id e18so10039629ljn.12
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 02:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q/PRLLLbZNApV1FTobRRQX4PjY/FxmqgOssNyFIuRGA=;
        b=CR4lo8YJvnok/HExDeZSFUuc6ollkEusCBzQli4K46QkpYVwhka7RNJdaD/sYalqYc
         06uwHNFDVB4foEWxeBtdjS40p9NeRbnfw4Iz5X1+m+HvMKvz7vRqyecrl2dtZHjYoDfz
         NvRNEsTPslEzkOix/Hhkq24JdA73ExmL8XNDUt+SQAU7tx+ytS+0Tt/TTrOId+5EJ+Ci
         0QTclkOkbt+EgDV/o2EWIFc0/w9+RAt4dTTxusZpmqlnNpTxnUchPXhAC7DqgJkLPiWv
         c4WHJ3QdhQwCS0hta/7dLKBA54yp7YgGj2UFr6driEzbOakMqSIQlZE1cN7tg21KijK9
         gXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q/PRLLLbZNApV1FTobRRQX4PjY/FxmqgOssNyFIuRGA=;
        b=Dw1mBJslP7NOmur2yo/LMB4byeYmrXSSJoJ9ZdIVZwRE3QzZfnjPDtcZTuGRRuSeMh
         +X1xOfMLsA+1r4/N6WjItxHs5++KqfvIgr3QVtYtr5GIJR9/w2zi/0EaGdI9MJ0LpsN7
         3mxlIvgKijsVm2Axl+cqGeYx/lBOag2nV6/8qA1tSfz9Tyc7gYMA0gKi+own9pGzCz5f
         IaZYWNePwb/7l8VkbAUXBDV474jyC/4vH43V9u3zCliJnU9yM5eIThHVgCQ0KFFf8OIt
         y5uofeXt8R+n+HBxRVMyTUDlbRVAZdvWLOvyAABDTtAaMNkJL1Hxf0mUl8mGSZ13DRS/
         qFIQ==
X-Gm-Message-State: APjAAAVdk7ILSTWUEtRSHzjdgcfZu8nTTmZan9daDkzhKwClVAZn97E2
        xyRoQNpgQH92evQqQqHf1Ppt0gtxkDcp/z3cDlqbvA==
X-Google-Smtp-Source: APXvYqxFs8/6R6Bb54n9WZMZG2GlDZcOGmxNsqjsmVmjuMoTQ50ZDkJ7B203kUIWpdjwxIZFBAGzVtHYGsICl7mquEU=
X-Received: by 2002:a2e:8e70:: with SMTP id t16mr1641690ljk.73.1581675235089;
 Fri, 14 Feb 2020 02:13:55 -0800 (PST)
MIME-Version: 1.0
References: <20200213151842.259660170@linuxfoundation.org>
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Feb 2020 15:43:43 +0530
Message-ID: <CA+G9fYt8_fzpBo0LZq4pU6f1MOP1T9qkP0dD=sZiyZFZDXpp9A@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/116] 4.9.214-stable review
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

On Thu, 13 Feb 2020 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.214 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.214-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.214-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 41f2460abb3e46bd15371fb219a2145f02251b08
git describe: v4.9.213-117-g41f2460abb3e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.213-117-g41f2460abb3e

No regressions (compared to build v4.9.213)

No fixes (compared to build v4.9.213)

Ran 23521 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
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
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
