Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B20396E8B
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhFAIIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbhFAIIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:08:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAEBC061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 01:07:01 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb17so20263173ejc.8
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 01:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sn8Wsn0kqUHnR7hQdztqsD5eObcV1rNSOGmXRuptPcs=;
        b=VJE7w46USRh3V7Fy0zLL0nZDiOxjJNiIUKAMMzxGvAHyucPGoppgSkUe4dDiYRezBU
         7nECuKEJoEoShnRCuiUBGePvH0acKL4l899C7O4UqEAF4vZYWme/+PUlSOWVW0s6YCR+
         eBdDkhTYng0hAzBpU1tjtWkLdrX2Cp1ijxdbmP9cAT8ESeH24gfwYbxs6akxo+PM/feP
         yU6h8mZcXoVbyue1/UG2cEk21YVHw48iW9KxPs/seuzz6hOF/3KHofqBRVab/hfSh5um
         x6bo4FeT7ei5kTT1NVpickmZ2MstRlymB9IQZUNClt8n66sV4yhOo0SQhSn+4wfySKtC
         nhKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sn8Wsn0kqUHnR7hQdztqsD5eObcV1rNSOGmXRuptPcs=;
        b=q2Wt0fQrlignrlLDryoAakp/xXZUz4ReO3GKX4LpV6KNQMW4GTfQ1OXnXZ3rTACPv+
         JyAfOzlGyaundOzSx31OhML8bDybV+Q0Xjbi0LjaN+V0EX8s0+gXDLFlhJyFyqTo1Ll7
         K8OASffBrAr8MkJCeMCXV2jDAt9bQI70YhnysduQiOjFlw0ve5/KevPwXXerv20k75mb
         21opWYAb4qt4ACxYclN6pGIB5uuV91L5ZvS4ka/b23e4Jdh+pqZdh3Qof945iTJuFrHr
         Cax1AUgHILWz5VqMfriQJEyKzWhl/fGgW9Ce4RzHLHdGsGyhiDFvlgyz3HUMUrp0JrAn
         nC0g==
X-Gm-Message-State: AOAM532A5UQCEnIKKElaRh1yjzBm8ZENop+1yXhS/h9+k8JXLHwPECn/
        xhngQk1XtkOb0h+nCfvJfM9Uc47sKDbOwbc/S+aH7w==
X-Google-Smtp-Source: ABdhPJxuF9bu9K0CFIJ4Uq7J+vjQDSju9f67WkNPw387/UTrs8ns6K3eivT6x9zzI/A2XYT1eN0tg9JZBqmilPKXIZo=
X-Received: by 2002:a17:906:8318:: with SMTP id j24mr9173199ejx.375.1622534820140;
 Tue, 01 Jun 2021 01:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130647.887605866@linuxfoundation.org>
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 13:36:48 +0530
Message-ID: <CA+G9fYsnf3Np8Za4fq-4ENEq=Zt+rxT65=WRrAJ0YVC4PGLjoQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/177] 5.4.124-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 May 2021 at 19:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.124 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.124-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.124-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 4142e74be32ee4ca40200301fcabfca32800f9c5
* git describe: v5.4.122-186-g4142e74be32e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
22-186-g4142e74be32e

## No regressions (compared to v5.4.122-8-g69500752c057)

## No fixes (compared to v5.4.122-8-g69500752c057)

## Test result summary
 total: 70304, pass: 58035, fail: 849, skip: 10732, xfail: 688,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance

--
Naresh Kamboju
https://lkft.linaro.org
