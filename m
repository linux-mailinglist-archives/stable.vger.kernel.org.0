Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764601384C0
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 05:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbgALE53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 23:57:29 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43983 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732197AbgALE53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 23:57:29 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so6364142ljm.10
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 20:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RpbMUvEoD7rQhI5wqSaluIrZBJVgV5aMH+ued4FXIwc=;
        b=qGr/xuKt7RmWk486q/nJCno3HIGnGsmY8aHhjMLt5oPsa016AEFIjqc34UH+Tt3Nj8
         ulk5XBbVAMFuct9rAT5NPOsUzr+884hCuZe/vwzHFGhhAJjifPEP48jMn5r47YVzukHw
         g38hKCFpt/FKAjphejl6Hrgs48htSnmbeB/gw288afgPkXqflSKxSOsjQXhTVvuYxqOI
         uuT39PE2v/kdfnspOlWRfcPzrsV08mvIl3oiisGU9XbOJn+fyWQmlJ67mpKRvYgpqmHq
         3hX4PfmXOEmxuZBBgfbUrbrsIS/u9TkENLmlioOd8UPoIWT5m7j7akneH3sB1pJE2QJu
         3I2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RpbMUvEoD7rQhI5wqSaluIrZBJVgV5aMH+ued4FXIwc=;
        b=o6n/rI4hM4U5xtdc6HkrZLCdCQDpdeML2hQbAYcqlfq8Lq5SqJUW2U2IoNawuDI8iP
         w3oL4kZUf6IQ78Qudksd8KQT4d7lUAbidXC+LTlWrh3+7iktINcINks/+6dvGRRUQFJS
         V2E3vUb4pZaYsByGuwsCU3SWsLRNb8WfDimurWCPaxY/dygyRkiDdI7tGXVQDHkdm6k4
         73T3HVM4JoRoUvW1FpZMjnBCpRt70u/VWzVuGRNkgdX4iOQNEcGGsWqF8lLH/VTCaP5Y
         dysserGpgClXRtUDiTw7Fq9+RcCR5PSAjxPxw/5BW4ms9ybQy23334Yd4aaLYPpLRKHr
         qjDA==
X-Gm-Message-State: APjAAAW5RWK2kwsE1BFIFapCXIG5bbQXVcS/ENhcfG/d5eBZpNlUxkc5
        65ZM/Pni9n6AM7WSi80p1GgOBns/W693WirsvwOsEg==
X-Google-Smtp-Source: APXvYqxnsNwgcC7A2Vo9nM8Exa56fgDRoeU5huRv7TTkqVL4vMVmahj2i6Bl9tL/WXf4bGjGUIugwWnt1DuRSMORS10=
X-Received: by 2002:a2e:9999:: with SMTP id w25mr7376493lji.142.1578805047259;
 Sat, 11 Jan 2020 20:57:27 -0800 (PST)
MIME-Version: 1.0
References: <20200111094845.328046411@linuxfoundation.org> <23c3a0d1-1655-8cc2-7c96-743a47953795@roeck-us.net>
 <20200111174715.GB394778@kroah.com>
In-Reply-To: <20200111174715.GB394778@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Jan 2020 10:27:16 +0530
Message-ID: <CA+G9fYtPeGWPGmd-R55VWwfx6QXSH=NmofVR3vPVtMZomov7qg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/84] 4.19.95-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Jan 2020 at 23:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> > arch/arm64/kvm/hyp/switch.c: In function 'handle_tx2_tvm':
> > arch/arm64/kvm/hyp/switch.c:438:2: error: implicit declaration of funct=
ion '__kvm_skip_instr'; did you mean 'kvm_skip_instr'?
>
> Thanks for this, I'll go push out a -rc2 with the offending patch
> removed.


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.95-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 4f77fc728c7082f1c925966660d42fcd34780e6c
git describe: v4.19.94-84-g4f77fc728c70
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.94-84-g4f77fc728c70

No regressions (compared to build v4.19.94)

No fixes (compared to build v4.19.94)

Ran 22756 total tests in the following environments and test suites.

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
* linux-log-parser
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
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
