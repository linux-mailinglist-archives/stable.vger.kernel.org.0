Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E7964BD44
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 20:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbiLMT3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 14:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiLMT24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 14:28:56 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 11:28:54 PST
Received: from smtpcmd04132.aruba.it (smtpcmd04132.aruba.it [62.149.158.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07E3240A1
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 11:28:54 -0800 (PST)
Received: from [192.168.50.220] ([146.241.66.6])
        by Aruba Outgoing Smtp  with ESMTPSA
        id 5AwQpZebgOQIK5AwQp2V9W; Tue, 13 Dec 2022 20:27:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1670959672; bh=vCJR0fv0Y4cA0XHWHmWTrSv9MCEY6oAqwuXODGipCCA=;
        h=Date:MIME-Version:Subject:To:From:Content-Type;
        b=KwUy/Yx3sNGjwmLKuSGOG+DcdxImzsd9CdLUyDljcHsOqaCNDtvFTlVjf5g6la9is
         XlI/KPugntjjQ88hvqEeJ6z9fy7IIF5tSqBWj2tQDo5C+WgOmnAXDXaEALPK8YxCon
         WeKT5AoG1l9EvYYCPaM4QPwpiXn9MCk99dpC/zapCYuNcDqwEBTWjClx4qEcYtmX3u
         kPoFxoH6y3BYjgG2M8cWmMwblLoGahI0ER/doNNujuYeP85hM4po6eDVOiF9t+NkxU
         N0pUTexTShHSYSFazXrrxIYO7dKIozHn2+0VJJRCpWcpDX564unM7H67hu0zGHuStK
         2TNyNpRtyc+GA==
Message-ID: <0f674e79-5832-d296-4db2-ec9b0c40a298@benettiengineering.com>
Date:   Tue, 13 Dec 2022 20:27:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Arnd Bergmann <arnd@arndb.de>
References: <20221212130913.666185567@linuxfoundation.org>
 <CA+G9fYtCTQHiW_pr+M8AVrLn-93Gf2gyP+ccx7Vr9FtUMungdg@mail.gmail.com>
From:   Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <CA+G9fYtCTQHiW_pr+M8AVrLn-93Gf2gyP+ccx7Vr9FtUMungdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfFg16l+Q2iqEwOe8ddndBzOfoTn+OOqsa1+DoiNDgZRMov9Usd4i9GRUdSbCx6vtuq00eGI2vyquZeBlD+OmugINV++Rg7KvPaFBowi57ZtiK3gDaFYZ
 Y+ixzhnVTlmhWi6WC7OVoOg6sVANleeW3Z5yXmWakmygWwfd6jfzdHN5ng70XEymkBCpuLexb5bKbTWZj/IEDCQ97Se2yarHhVdWUH/SrMSvMEJhkOZKqhU4
 ztxiZy93jd1geZboVYkyZihSpZrIMEJYyfVMzHZhAqzrFgC1J4lE1OxM/CpQRrtHskleB/0dTFonj8Py11uPcI2AdI4ctvtyOQQx33AcqFRfQKSm8r9TpcG/
 lDJp0lTPLkSSimNPfU5F7vc/S9hKY/ggNoZgVVKyjb9uUWDFkXj8Tc9ldUft498O2UUHhwrchgw8xH6xGKulq34kK8fkiu+pl7J6reeugkjnLRss0JCVGz2R
 TCGkY2NsRht6GvZVRmYml4NgMBw3QfpcWJc0Y5syKgu5nf5SqOSCqJ4+wD+eeFP5YuugHL4DQXLOX8AJ9JT1OaZEeFGB41Qq/dTmBUgY7UJP8ZjcU4+Vev9t
 udxBWsoY2ZS9okbxs3/P5U7kzwaomWB2HbLUt1VLhagqQf77H5nuKOmzHoN+dagMnqfANwoGxEnADMdJfo4vL6N2Zk2siMeoXwEOO49f8SAQt2+DeSXuOrPS
 EEj8rtMki5n8Y0X8cvbCw8Dys8Wr25wTWU2GJGPHm6vokX6Duh8IPe2lFs+GxxMpAfEkjjCkeh2DnJpUoZtugRwMXVrajVQE
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Naresh and Everybody,

On 13/12/22 12:53, Naresh Kamboju wrote:
> On Mon, 12 Dec 2022 at 19:19, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.269 release.
>> There are 49 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.269-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> arm clang-nightly allnoconfig builds failed due to these warnings / errors.
> for clang-nightly warning showing as error and for gcc-12 it is just a warning.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=0
> ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=clang CC=clang
> arch/arm/mm/nommu.c:163:12: error: incompatible integer to pointer
> conversion assigning to 'void *' from 'phys_addr_t' (aka 'unsigned
> int') [-Wint-conversion]
>          zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
>                    ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
> make[2]: *** [/builds/linux/scripts/Makefile.build:303:
> arch/arm/mm/nommu.o] Error 1
> 
> commit causing this build failures,
>    ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation
>    [ Upstream commit 340a982825f76f1cff0daa605970fe47321b5ee7 ]

I've just submitted a patch to fix this:
https://patchwork.kernel.org/project/linux-arm-kernel/patch/20221213191813.4054267-1-giulio.benetti@benettiengineering.com/
and I've also submitted it to Russell King Patch system:
https://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=9280/1

Hope everything is correct.

Best regards
-- 
Giulio Benetti
CEO/CTO@Benetti Engineering sas

> 
> ## Build
> * kernel: 4.19.269-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-4.19.y
> * git commit: bf741d1d7e6db2cb2fb6ba4634aaabad00089b40
> * git describe: v4.19.268-50-gbf741d1d7e6d
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.268-50-gbf741d1d7e6d
> 
> ## Test Regressions (compared to v4.19.268)
> 
> ## Metric Regressions (compared to v4.19.268)
> 
> ## Test Fixes (compared to v4.19.268)
> 
> ## Metric Fixes (compared to v4.19.268)
> 
> ## Test result summary
> total: 95070, pass: 81469, fail: 1691, skip: 10892, xfail: 1018
> 
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 323 total, 316 passed, 7 failed
> * arm64: 59 total, 58 passed, 1 failed
> * i386: 29 total, 28 passed, 1 failed
> * mips: 46 total, 46 passed, 0 failed
> * parisc: 12 total, 12 passed, 0 failed
> * powerpc: 63 total, 63 passed, 0 failed
> * s390: 15 total, 15 passed, 0 failed
> * sh: 24 total, 24 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x86_64: 53 total, 52 passed, 1 failed
> 
> ## Test suites summary
> * boot
> * fwts
> * igt-gpu-tools
> * kselftest-android
> * kselftest-arm64
> * kselftest-arm64/arm64.btitest.bti_c_func
> * kselftest-arm64/arm64.btitest.bti_j_func
> * kselftest-arm64/arm64.btitest.bti_jc_func
> * kselftest-arm64/arm64.btitest.bti_none_func
> * kselftest-arm64/arm64.btitest.nohint_func
> * kselftest-arm64/arm64.btitest.paciasp_func
> * kselftest-arm64/arm64.nobtitest.bti_c_func
> * kselftest-arm64/arm64.nobtitest.bti_j_func
> * kselftest-arm64/arm64.nobtitest.bti_jc_func
> * kselftest-arm64/arm64.nobtitest.bti_none_func
> * kselftest-arm64/arm64.nobtitest.nohint_func
> * kselftest-arm64/arm64.nobtitest.paciasp_func
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-drivers-dma-buf
> * kselftest-efivarfs
> * kselftest-filesystems
> * kselftest-filesystems-binderfs
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-ir
> * kselftest-kcmp
> * kselftest-kexec
> * kselftest-kvm
> * kselftest-lib
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-memory-hotplug
> * kselftest-mincore
> * kselftest-mount
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-forwarding
> * kselftest-netfilter
> * kselftest-nsfs
> * kselftest-openat2
> * kselftest-pid_namespace
> * kselftest-pidfd
> * kselftest-proc
> * kselftest-pstore
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-splice
> * kselftest-static_keys
> * kselftest-sync
> * kselftest-sysctl
> * kselftest-tc-testing
> * kselftest-timens
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user
> * kselftest-vm
> * kselftest-x86
> * kselftest-zram
> * kunit
> * kvm-unit-tests
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-cap_bounds
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-filecaps
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-fsx
> * ltp-hugetlb
> * ltp-io
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-open-posix-tests
> * ltp-pty
> * ltp-sched
> * ltp-securebits
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * network-basic-tests
> * packetdrill
> * rcutorture
> * v4l2-compliance
> * vdso
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

