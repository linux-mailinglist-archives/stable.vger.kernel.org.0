Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DDA32F762
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 01:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCFA5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 19:57:16 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13864 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhCFA5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 19:57:10 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DsmNm2mcLz7dmt;
        Sat,  6 Mar 2021 08:55:20 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sat, 6 Mar 2021 08:57:00 +0800
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210305120857.341630346@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <2604d5be-cf84-01d3-76cd-8b5983445d35@huawei.com>
Date:   Sat, 6 Mar 2021 08:57:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/5 20:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.103 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.103-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Our test CI monitored the 5.4.103-rc1, and compile failure on arm64 and x86:

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Arch: arm64/x86
Version:
Commit: 2e10dba9fe0e67740146f3b3be42ed9403a7636e
Compiler: gcc version 7.3.0 (GCC)

--------------------------------------------------------------------

Kernel build failed, error log:
kernel/rcu/tree.c:617:2: error: implicit declaration of function 
‘IRQ_WORK_INIT’; did you mean ‘IRQ_WORK_BUSY’? 
[-Werror=implicit-function-declaration]
   IRQ_WORK_INIT(late_wakeup_func);
   ^~~~~~~~~~~~~
   IRQ_WORK_BUSY
kernel/rcu/tree.c:617:2: error: invalid initializer

--------------------------------------------------------------------
Tested-by: Hulk Robot <hulkci@huawei.com>
