Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2298724CC9
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 12:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfEUKeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 06:34:50 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39498 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfEUKet (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 06:34:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id f1so12687538lfl.6
        for <stable@vger.kernel.org>; Tue, 21 May 2019 03:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fCy/VGpOq743DayHQQsEozNjpRnyCKmSgWu0EqLS7qg=;
        b=zP89vje+56kWqEkujYv48d0KS4alfTieGHI7YzDNtsS4JuwFk1Dh8MNxXHZoJPbAxQ
         CH3lOVrIsd6nqpUPTVZulS1/3Z+tnWTCxbnoLBkwiBZw+zOPGMUncf2qftUjFiql35Lk
         CdPFd1b7QYx+1e/JzV/e485h65Z1WwH5rdGpe6KrVTAKDG3TOsSMvRfpR9bNtzjaJDh7
         EwUC03mrqTHncJzjWFsziAhLwIJ5pSDPgI02aDo6COvLOEYrIBe+ClTUuVLXmE58NrqW
         sJSwMImQdNKURKsZVdP/6VfWR/gfbYg2GXdAyMQ/SzZNCKDKyLzIG6NxyCxBFsvuENeO
         2nxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fCy/VGpOq743DayHQQsEozNjpRnyCKmSgWu0EqLS7qg=;
        b=iQrMKiYpt4M525v/N0IJSTFQoNWA4rVJXdbUfVll7XsLjTED+ihnvruM/4mXsAuvzC
         KmeCcW2czIkvl0tywRiCLfwDfXwq7ynMOAOzv5NL2aGhM23q6U9XXblD1lz15It/qwbz
         xdP6f7vu1AHLlVUfsLraU9lYuEE5IzAAjjPegQSMmRX9+NhlRkuRUdFO/3PwOdHTnojz
         7t7BW7VkTIeA1w0IGFz9gyoOu3VbrZtblu2FUAfc48CVqm8OLg0CW6eeMyY1QQLfe6vi
         xANYZoVJGyJdyDCwr22eRavVRKX8QNHMEMX7yc3ch/uuF2avKKg61o4u7c1v/hLOVNN1
         A/nw==
X-Gm-Message-State: APjAAAW4PSDeqmYRLhMxcEuNj1fu6XzmxLI+y7FalW+ruLbq7QCqp5CJ
        mR58TD3+KwQDJ7iW8wV1f6zXw9JVBKvfrltY8i7rVA==
X-Google-Smtp-Source: APXvYqyQFz1GGstt7zS1hAVbudRpaHbP9enaU8FISyREPvFreiVL7X+mhabTLNetdmWxR+2SPWWHYx8+tn/RG6YHtcE=
X-Received: by 2002:a19:6703:: with SMTP id b3mr5248194lfc.153.1558434887837;
 Tue, 21 May 2019 03:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115230.720347034@linuxfoundation.org>
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 May 2019 16:04:35 +0530
Message-ID: <CA+G9fYs+Ft2v_Xr0KJ3AOdbTTJJ8YB6vgLc-ps6TiVM4nyftLw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/44] 4.9.178-stable review
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

On Mon, 20 May 2019 at 17:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 22 May 2019 11:50:58 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.178-rc1.gz
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

kernel: 4.9.178-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 1a569b62b013b75248598605647b0c077a399c5c
git describe: v4.9.177-45-g1a569b62b013
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.177-45-g1a569b62b013

No regressions (compared to build v4.9.177)

No fixes (compared to build v4.9.177)

Ran 23360 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- i386
- juno-r2 - arm64
- qemu_arm
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
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
