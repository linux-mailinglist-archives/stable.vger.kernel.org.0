Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4CFE20B
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 16:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfKOPwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 10:52:22 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38177 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfKOPwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 10:52:21 -0500
Received: by mail-lf1-f65.google.com with SMTP id q28so8379797lfa.5
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 07:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N5trgeVD3EORLjGO+xA4b3sDYv5TwYpSjVCXBJ/A2b4=;
        b=AGZ+i9Z/ANAdqhQDWmYJyNWnrUSkK00vBhoI5umuPoEVVrOLx7ThqiRnxpKrVNr8vn
         vDNOsPAwv4Q3EfzZdqu3RCjFDz08ePAIRk+ebM6Lhry2zQcFQUKGUFI/IK3O2QnwnBWB
         tsMv30MNEsAOnIKuZkYLb+xnTUkhG7sttw2zo9zsG1YzMXzy1bmEMNxl/JtG7Uvs9/AX
         r5kQ1Bj5yOXt1wgkF/CZGuWo3OHHjMqMQOKgy8IoGfGltquaO3V/CdvYYvEbClixKu6M
         xP5pDemcxadu5Rt0FygluglS72XuyRgYnFkpXtugDdFg8RivUEoEY4aJY6YJXt9mkURA
         xq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N5trgeVD3EORLjGO+xA4b3sDYv5TwYpSjVCXBJ/A2b4=;
        b=fB9ce1xTBne8YF7SBlAzMz6OaEKRDePwo5JglJ0xKsqPF4WUjZTx1ppjPVpmOP16Nz
         KhHQGrf1qAuJioJOnNb6PxFl+G4sLC+pQIgFsXFHPD6PLuYhncms5lYHKW2Y6MxL0KUk
         MzDuDus9reStY1GKocrYlqOk997AIB3CAheS/dUOT/1qk8vVxPxlLUCyP4FOQM+ONFLc
         nf4RbzCat5ns2b6DsMrG6Wk3s8OFPxlXewmMuy7h/1/3T1gGnh/sN3hW/++s6r4jf1cl
         Je4B3qdRLIZU1yy1SA6Ftvbw76WFkjlvNbdRGj/RReNPBBBGBAXmOgqQdNkddJ0ubuKW
         arhg==
X-Gm-Message-State: APjAAAVLnnTj8rynBga5CFdG37d2qbGeir1D/03vNqAlQyIzeXbhSuls
        LgCxD06uAj2vhxdYgv/W5esC/FBBORdwyEv9XPlQqw==
X-Google-Smtp-Source: APXvYqzSzUr1x6b0VTnz7N/sjujRkdhPKmenqMTT9HLOsTJ53Vw7JoA2OGmtdseEAGLl+Iw/x6f4Rr8Li+VfM1A6Lfg=
X-Received: by 2002:a19:f811:: with SMTP id a17mr11581671lff.132.1573833136685;
 Fri, 15 Nov 2019 07:52:16 -0800 (PST)
MIME-Version: 1.0
References: <20191115062009.813108457@linuxfoundation.org>
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 15 Nov 2019 21:22:05 +0530
Message-ID: <CA+G9fYt-y23nfB1gU_e8JoTU+n973QgJCtMcqGrugRQ7sVHUMg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.202-stable review
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

On Fri, 15 Nov 2019 at 11:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.202 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2019 06:18:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.202-rc1.gz
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

kernel: 4.9.202-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: d7f83e4f45e886d919bc985bd225b8355ddd9284
git describe: v4.9.201-32-gd7f83e4f45e8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.201-32-gd7f83e4f45e8

No regressions (compared to build v4.9.201)

No fixes (compared to build v4.9.201)

Ran 23552 total tests in the following environments and test suites.

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
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
