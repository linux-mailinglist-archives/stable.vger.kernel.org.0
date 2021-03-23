Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32D934541B
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 01:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhCWAsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 20:48:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14841 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhCWArz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 20:47:55 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F4CN13hlmz92XF;
        Tue, 23 Mar 2021 08:45:53 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 08:47:50 +0800
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210322151845.637893645@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <d379f1e4-8f24-c90e-6fb9-331d33de4dbe@huawei.com>
Date:   Tue, 23 Mar 2021 08:47:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210322151845.637893645@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/22 23:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 15:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Arch: arm64
Version: 5.10.26-rc2
Commit: deabac90f919203307e6eee2606366bdb19bbe93
Compiler: gcc version 7.3.0 (GCC)
--------------------------------------------------------------------
Kernel build failed, error log:
kernel/rcu/tree.c:683:2: error: implicit declaration of function 
‘IRQ_WORK_INIT’; did you mean ‘QSTR_INIT’? 
[-Werror=implicit-function-declaration]
   IRQ_WORK_INIT(late_wakeup_func);
   ^~~~~~~~~~~~~
   QSTR_INIT
kernel/rcu/tree.c:683:2: error: invalid initializer
--------------------------------------------------------------------
Tested-by: Hulk Robot <hulkrobot@huawei.com>
