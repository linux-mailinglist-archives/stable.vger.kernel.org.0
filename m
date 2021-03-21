Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F68E3430A5
	for <lists+stable@lfdr.de>; Sun, 21 Mar 2021 03:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhCUCYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 22:24:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13649 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCUCXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 22:23:43 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F31Zx08ftzmb3n;
        Sun, 21 Mar 2021 10:21:13 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sun, 21 Mar 2021 10:23:35 +0800
Subject: Re: [PATCH 5.10 00/13] 5.10.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210319121745.112612545@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <5c223d25-208d-ce63-1e4f-629998665bf2@huawei.com>
Date:   Sun, 21 Mar 2021 10:23:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/19 20:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.25 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.10.25,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.25
Commit: 3ba56f490c7ab26974806f8c2f14fc49652efe10
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4721
passed: 4721
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4721
passed: 4721
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>

