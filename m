Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A59227BBA
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 11:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUJ3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 05:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgGUJ3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 05:29:35 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BDEC0619D8
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 02:29:34 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id m6so10002985vsl.12
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 02:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dcLKqBDVB4TITh/htTSVClvSxCBV4FHIL6bhw115i/Y=;
        b=aOdKaTxJhPkxy9HduNNL10Gid2WB1dybzCqK24ieWVRZdUoHT02WnpOZW4JbLGsIeu
         RnwejU9DiZnQLS8p238txeXKxZ0h0sUEhd2DUmKzT+jl/33G2DMNTjzQ9UXWkHvbAOGD
         0V80RRtrN3tMF+V7TlhLuiKVXQkqjzlWZOHjuP4LavkEr+MSfZg++sZSl9aBteD/jDV9
         q9J6jUSWLW/vaLsHT6zL8FtC3seA2lmscFe+ajILtkLj3Ey/Y73XV0fUzuyct6ejrwkM
         D99T2jEbsdr6Myk7TQ4qiEsSjriFDPLThstdeMI50QCpZMArQvNdHix0rCtRXvUylUmh
         Nj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dcLKqBDVB4TITh/htTSVClvSxCBV4FHIL6bhw115i/Y=;
        b=WLTm2jN2P7fr7cz7lUP28QGD/IlTx0k5siRB6NcIZkQh8vLHeq//kKjQtj92wG2xqO
         1legWG6o7AlxQvRV+jEMjTIlWKdEXwZ8MUKpu8Xqs/Rs6pHFEhFcb/BJAgC5UusrwGrz
         gCh5BdY8F0roVegmwSyQaRashfbc77xHHI/5dGQsx/hRAuW0HzOn71OzvaBBRsC3zltt
         UWZtUuVbTrCMqgSedvXjK7NqABFOITp1psui4EqTmkH8YYrDak1AzBoXsToz5Juhz0WI
         Qf4TX9q+N4oDpcqpK4drqwCpC1fO9UB76N0zpGkgQRUkKqwwGgcBf8nLXE0Vg5OOY2PB
         TKeQ==
X-Gm-Message-State: AOAM530H7tsQObO0tKpLaFJ6y1/5c64paM+6UUX1nLyLp82a/RPONDuz
        WNxKLItRNmrvSLl+N2iJQbzYair8I67XTkv2OKCDsQ==
X-Google-Smtp-Source: ABdhPJzlrp/LBJbeM/yVLHE+x5tiFx6mhUJs0SFlvF3zM77XofpxcyIE9uJayTPh8hP0MvCmGcWUF3jqTl+FyStW190=
X-Received: by 2002:a05:6102:14d:: with SMTP id a13mr19263015vsr.142.1595323773795;
 Tue, 21 Jul 2020 02:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200720191523.845282610@linuxfoundation.org>
In-Reply-To: <20200720191523.845282610@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jul 2020 14:59:22 +0530
Message-ID: <CA+G9fYuVJAHyXqPhhqtcdDstKrjb-TLu=d7DZTuQX3YuCsypHA@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jolsa@redhat.com, Namhyung Kim <namhyung@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Jul 2020 at 00:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.10 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected on arm and arm64 (Juno-r2)
We are bisecting this problem and get back to you soon.

perf test cases failed
  perf:
    * Track-with-sched_switch
    * perf_record_test
    * perf_report_test

Bad case:
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf-lava-test.data ]

when it was pass it prints number of samples like below,
Good case:
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.004 MB perf-lava-test.data (46 samples)=
 ]

steps to reproduce:
# perf record -e cycles -o perf-lava-test.data ls -a  2>&1 | tee perf-recor=
d.log

Link to full test:
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/build/v5.7.9-244-=
g7d2e5723ce4a/testrun/2969482/suite/perf/test/perf_record_test/log

test case:
https://github.com/Linaro/test-definitions/blob/master/automated/linux/perf=
/perf.sh

Summary
------------------------------------------------------------------------

kernel: 5.7.10-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 7d2e5723ce4ac92e4ad9337075863b004ceb7083
git describe: v5.7.9-244-g7d2e5723ce4a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.9-244-g7d2e5723ce4a

Regressions (compared to build v5.7.9)
------------------------------------------------------------------------
  perf:
    * perf_record_test
    * perf_report_test

No fixes (compared to build v5.7.9)

Ran 37534 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net


--
Linaro LKFT
https://lkft.linaro.org


--
Linaro LKFT
https://lkft.linaro.org
