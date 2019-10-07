Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317BACE98A
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfJGQnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:43:55 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38433 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbfJGQnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 12:43:53 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so14431488ljj.5
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7Zqyp+EzMxcNslBkEtpTkjVzHDniuE8hee0J+iYqh3k=;
        b=aBQB7O1P30QBMIkkPZhqXSR1LSNwIFJunCsW0X06VXb6Bvn7XGsj+dfsdmKJd3CiyH
         q4YvufUqrT1Hl2obL2UFRAJ0wxp6agBulsApTGbnil8AS4Np7O9esp+A5jY5NwIg0JSd
         RpBHTMJRN/H+4aVNuNC5hqI0Qu/sjY/LPbTozg6YRYLbF782F+gyGqNIMOoKNJpwoVpy
         ta5VuMWLvsa9ZciN2uga5H197TX2KmRWtRzJicu9jUjZ+Bokh7Xx7sl09aUOAtPXJcMz
         +aOwcQygCF0lmSh5PDuNNQekjaI73UMxFU81oRTqcD+8ihU/wRPI7ju9ANoRCRE717vY
         BYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7Zqyp+EzMxcNslBkEtpTkjVzHDniuE8hee0J+iYqh3k=;
        b=fu+iX2vPckeKqzfwK3BYwgjlobkfVJREKHOyzDBfgZ71s0F+dfN4brJb07syzh/U/t
         MKzi9Xu2Bj/ZR5gBnS3jxOJj8woRbjq3CVHojPeZKQBVrw3UmZi/yRDJEZZi9YFPCF4G
         a+tdIK/D3mhXoa1r731GOlbRaHKY0lXTNNYNJ5LGtz7Sqtot1HxNuTCsrgT3xMNw6QOZ
         muKC7X+cnC+rHmJUVQR057jcQF7887IEo8e+a/QoD/0kRCnplSL0GCZVqsSOhL8zawnn
         c9UZtb11VY+tGWVYUzhrn0iXY5th70py0GHefUUglDAR2y9C8hj9siTQ80LlmIRvwXbR
         RcEA==
X-Gm-Message-State: APjAAAUW9hECzzFTINB0I0uut+GmLYBbaklLmPjXXq8biJZNtW6050nY
        0rAP5Vm+g3Ilb/7mmOkadF+xHOb3nDPR2ljDZGTuTg==
X-Google-Smtp-Source: APXvYqwPaGHjD2F43p7X3DF5o0DsdFVhMZoHPQhp/6xiPe8/10mLuBDcg6DzDAbtohD03hpCeRgCA2gh2dbsFQ2DPJA=
X-Received: by 2002:a2e:9a4e:: with SMTP id k14mr15666974ljj.129.1570466631777;
 Mon, 07 Oct 2019 09:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191006171212.850660298@linuxfoundation.org> <7148ff93-bac0-f78a-df3a-b9dbbee3db1a@linaro.org>
In-Reply-To: <7148ff93-bac0-f78a-df3a-b9dbbee3db1a@linaro.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 7 Oct 2019 11:43:39 -0500
Message-ID: <CAEUSe79aYVt1=MUqsWefBWQsucskuG6NpP5KRxQsjouJw+yXJQ@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Mon, 7 Oct 2019 at 11:25, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wrot=
e:
> Results from Linaro=E2=80=99s test farm.
> Regressions detected.

My bad. Should read: "No regressions detected" here, in line with the
other reports.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org


> As mentioned, we found a problem with the mismatch of kselftests 5.3.1 an=
d net/udpgso.sh, but everything is fine.
>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 5.3.5-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
> git branch: linux-5.3.y
> git commit: a2703e78c28a6166f8796b4733620c6d0b8f479a
> git describe: v5.3.4-167-ga2703e78c28a
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/b=
uild/v5.3.4-167-ga2703e78c28a
>
> No regressions (compared to build v5.3.4)
>
> No fixes (compared to build v5.3.4)
>
> Ran 25519 total tests in the following environments and test suites.
>
> Environments
> --------------
> - dragonboard-410c
> - hi6220-hikey
> - i386
> - juno-r2
> - qemu_arm
> - qemu_arm64
> - qemu_i386
> - qemu_x86_64
> - x15
> - x86
>
> Test Suites
> -----------
> * build
> * install-android-platform-tools-r2600
> * kselftest
> * libgpiod
> * libhugetlbfs
> * ltp-cap_bounds-tests
> * ltp-commands-tests
> * ltp-containers-tests
> * ltp-cpuhotplug-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-mm-tests
> * ltp-nptl-tests
> * ltp-pty-tests
> * ltp-sched-tests
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * ltp-timers-tests
> * perf
> * spectre-meltdown-checker-test
> * v4l2-compliance
> * ltp-fs-tests
> * network-basic-tests
> * ltp-open-posix-tests
> * kvm-unit-tests
> * kselftest-vsyscall-mode-native
> * kselftest-vsyscall-mode-none
> * ssuite
>
>
> Greetings!
>
> Daniel D=C3=ADaz
> daniel.diaz@linaro.org
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
