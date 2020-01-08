Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FF013486B
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgAHQtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:49:17 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43054 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgAHQtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 11:49:16 -0500
Received: by mail-lf1-f67.google.com with SMTP id 9so2943402lfq.10
        for <stable@vger.kernel.org>; Wed, 08 Jan 2020 08:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j/omBmD/YZUdw7F0DSQMqWOu1GRjaqDS/yf0QTPgslA=;
        b=nbD435UYGyzatilzIS+UTN+GH4p9UU5NHMRVELHgVzkM0d3SwrNa4OPoH2FutaXayT
         h78Jv9mEd66s493Fh7Rqp6GTNKLsKQA17VCG9mQh7OZSsf5aN0J+mzRShzFJAOwsygc9
         lc8qT2P+myU7zEd69e7KbAh7BPXmZuvyaHnl7aps08DLFwI6M/mZLOrvw88/oRYehMiZ
         nClF96wph3Sn+okyXezUJ67TIgJleoX/T83dqvs8jbrric3B3VFDze21U83Xfg17Hj0k
         r5vAOTNjDgd6dnN5Z2fAzrSbB0Xkdkf1P3gN9Q6R2VnZi8bfKi80OVYpcDLmFW2rGOxp
         NcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j/omBmD/YZUdw7F0DSQMqWOu1GRjaqDS/yf0QTPgslA=;
        b=XTLF+6xby9Jits6W0r0SAXorfF7CyMOtF2aU9ud2lS5Jn0ZiVnAGYigcpMJjLNRw/w
         tzL0qUPoryRmSezZm5JQ909U0oghwkKaqFxe3GQi+rJMf3WaoKhmO2EqMudh/Xxqg006
         F57OQ/q4gskIXTvF4DhbZ2vsPnU+Omu/q+K986XtIa5mPPUFcHRgmzV1aUG1ODOY6NqB
         Ej3hPA1AlTalI8pE0dKNESiMz9XOuhn+/M+sbyzq51As+kSI5U1JDGVn/QdJxb5LoFMN
         IRW+HGPc+vfaI19QKOI5vIfw1vngg57ZE4pOk4lSWJ6OK0kTgXSqYXhq20xJY4jbxqgO
         8awA==
X-Gm-Message-State: APjAAAVBag+Mqg1fuNOwrvPRG0qNkOx0MHakwK8g9btHOu3MHdoj55w0
        XibDPUh6vLvYP/DsI8LzDuVpW35J8oQDQGfZEHUJzQ==
X-Google-Smtp-Source: APXvYqzn1T42iOOiHyS4+8PMkEdX9st0Ln5btvKPlmJL0LNUwwmUjCGM0zS4biRPKdM95azxzdTRgBFftD6CqukZZwg=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr3267563lfh.192.1578502154340;
 Wed, 08 Jan 2020 08:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20200107205240.283674026@linuxfoundation.org>
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jan 2020 22:19:03 +0530
Message-ID: <CA+G9fYtN4jZV-qLZ=SAfcZQfVJj3WgOvjtMUUc2kaawRB11GFA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/115] 4.19.94-stable review
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

On Wed, 8 Jan 2020 at 02:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.94 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.94-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.94-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 53089eea25ff49cc78f5f988ab91d98ccc80463c
git describe: v4.19.92-227-g53089eea25ff
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.92-227-g53089eea25ff


No regressions (compared to build v4.19.92)

No fixes (compared to build v4.19.92)

Ran 22357 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-sched-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
