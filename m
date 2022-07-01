Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9DD562CDC
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 09:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiGAHmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 03:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiGAHmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 03:42:33 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF52C140DF
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 00:42:30 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z191so1494211iof.6
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 00:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VHNl+PZ15hXDGB2ictbDX6H4eECr3QC9CGV4nYMXvss=;
        b=DNDy6VZO9FBy9n2XaCR7GqQSUO5Dhk9zh8/MiZ2KQxJoMk0b3QnBG+2LDcqIzJMkK8
         J6B5PejygK0WOWhpzy9EY8dwsPIfb2wZ0VN7B0AEUuiA6W3S7SvNDX6IE9UwSTfl7W/d
         A9HsgZ15WGN1Jc4nNa1NammXOYRUWcpzTyWg4LtgCz+pRZI/o07RU1wtlAZ/H7zaACqU
         e8TNSeGk2PgTqwnQ1+segODTJrCwTUCEwKlQATTogpaBFknf3R++7vRi+ArAbMhw90Xm
         D+aj6fwjGtDkwwkbqZbYxCXOkxuWNNW1E9tBRwA2xlWG6+HO2SkP3qQtrWKZ9tna6HkL
         OYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VHNl+PZ15hXDGB2ictbDX6H4eECr3QC9CGV4nYMXvss=;
        b=YcqqwEhgH7yqEAT4xbwi8R7uWiV9OT3WlIFCSu91ukTQbnLKWAp9HQ1ex7rYuxjf18
         ueDDh5zU8kbMWBKdHNWANgf2zG7NYrdjgCzUDh5GAY2SJqD2ud2pato0lu3hpRwQ+j67
         EIiDOHPcjREArZ9hCCeekdp1bA8yjfJZeNB1YeWP7FmlCi/fxDqUO/lVRssnPeYV/95F
         TCWQ3ZZTO4Yk21JWuq0oTAdW1ubhDa/txhBwSAUyVB/NsC7HmMqpw5LGe026DJJdamsI
         ZmATo2GAO3w8RcltFPie5a6cijx+q+qMQF0J29ijaHEvk49R4uVFh3vkMww7d6qVJBfd
         Y2lg==
X-Gm-Message-State: AJIora85ArNOqQKV0/5nyPz6/89xGKVSTbRszQJH7V0k63+7e+c/1Zqx
        ZJ3G4Iadhp2tGrwMNE9P04+TtMlvMh4ckueJNFdwtg==
X-Google-Smtp-Source: AGRyM1urPH/AhufQySXwOo9mX8h9zcZcGHRy9DEvNKeqwYH9jmKbZVU5vt9XhPubbSSl8zGzfM2uEcbt9K7Hl0utVJw=
X-Received: by 2002:a05:6638:14d1:b0:339:e8ea:a7c4 with SMTP id
 l17-20020a05663814d100b00339e8eaa7c4mr8210018jak.309.1656661350048; Fri, 01
 Jul 2022 00:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220630133233.910803744@linuxfoundation.org>
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 1 Jul 2022 13:12:18 +0530
Message-ID: <CA+G9fYt6uzUW7mAfTs6RJVsJuhXg45LWLvp0XbE_j3bq_5L9Eg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.250-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 at 19:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.250 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.250-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.250-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: fb9bc205ce087ccd6bebfcd08dfc99f2f920c788
* git describe: v4.19.249-50-gfb9bc205ce08
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.249-50-gfb9bc205ce08

## Test Regressions (compared to v4.19.249)
No test regressions found.

## Metric Regressions (compared to v4.19.249)
No metric regressions found.

## Test Fixes (compared to v4.19.249)
No test fixes found.

## Metric Fixes (compared to v4.19.249)
No metric fixes found.

## Test result summary
total: 106489, pass: 94293, fail: 269, skip: 11037, xfail: 890

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 292 total, 286 passed, 6 failed
* arm64: 59 total, 57 passed, 2 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 38 total, 38 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 51 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
