Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29346325DAB
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 07:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBZGpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 01:45:09 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12209 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBZGpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 01:45:05 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dn0Sp6LZDzlNsy;
        Fri, 26 Feb 2021 14:42:18 +0800 (CST)
Received: from [10.174.178.147] (10.174.178.147) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Feb 2021 14:44:12 +0800
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210225092516.531932232@linuxfoundation.org>
From:   Hanjun Guo <guohanjun@huawei.com>
Message-ID: <8ec51c24-4c48-076e-2294-e27da7e7a2c4@huawei.com>
Date:   Fri, 26 Feb 2021 14:44:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.147]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2021/2/25 17:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.

It takes longer time to set up our test farm than I expected,
for now we can run test on x86 for stable 5.10, test for
ARM64 server and other stable kernels (4.19 and 5.4) is
in progress (needs more machines and a rack in the data
center), please give us a bit more time to get things ready.

Here is the test results for x86, compiled and booted OK,
also no regressions for the functional test [1] (the failed
ones are the mismatch of the testcase and the test environment,
not the kernel failures),

Tested-by: Hulk Robot <hulkci@huawei.com>

Thanks
Hanjun

[1]:
Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git

Branch: linux-5.10.y

Arch: x86

Version: 5.10.19-rc1+

Commit: 6ffb943c0e01d843a06842f9a7bcfc008e10a6d2

Compiler: gcc version 8.3.1 (GCC)

--------------------------------------------------------------------

Testcase Result Summary:

total_num: 4739

succeed_num: 4732

failed_num: 7

timeout_num: 0

--------------------------------------------------------------------

Testsuites List:

autotest

crackerjack

kernel_selftests

ltp-aiodio

ltp-aio-stress

ltp-controllers

ltp-openposix

ltp-can

ltp-cap_bounds

ltp-commands

ltp-connectors

ltp-containers

ltp-cpuhotplug

ltp-crashme

ltp-crypto

ltp-cve

ltp-dio

ltp-dma_thread_diotest

ltp-fcntl-locktests

ltp-filecaps

ltp-fs

ltp-fs_bind

ltp-fs_perms_simple

ltp-fs_readonly

ltp-fsx

ltp-hugetlb

ltp-hyperthreading

ltp-ima

ltp-input

ltp-io

ltp-io_cd

ltp-io_floppy

ltp-ipc

ltp-kernel_misc

ltp-fsstress

ltp-fsx-linux

ltp-math

ltp-mm

ltp-nptl

ltp-numa

ltp-power_management_tests

ltp-power_management_tests_exclusive

ltp-pty

ltp-sched

ltp-scsi_debug

ltp-securebits

ltp-smack

ltp-smoketest

ltp-syscalls

ltp-tracing

ltp-uevent

ltp-realtime

memory_ksm

security_audit
