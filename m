Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908A232B00A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhCCAav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:30:51 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13108 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350866AbhCBM7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 07:59:02 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqcXT29wSz16FHX;
        Tue,  2 Mar 2021 20:54:33 +0800 (CST)
Received: from [10.174.178.147] (10.174.178.147) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 20:56:04 +0800
Subject: Re: [PATCH 5.4 000/340] 5.4.102-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <zou_wei@huawei.com>,
        Yanjin <yanjin.yan@huawei.com>
References: <20210301161048.294656001@linuxfoundation.org>
 <8271eb39-c44d-37ed-7501-e9d05d7fee17@huawei.com>
 <YD4wBtYjl8N0MaXR@kroah.com>
From:   Hanjun Guo <guohanjun@huawei.com>
Message-ID: <c7353c6f-c7d2-efa7-cb52-757325ec927f@huawei.com>
Date:   Tue, 2 Mar 2021 20:56:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <YD4wBtYjl8N0MaXR@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.147]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/3/2 20:31, Greg Kroah-Hartman wrote:
> On Tue, Mar 02, 2021 at 02:42:15PM +0800, Hanjun Guo wrote:
>> Hi Greg,
>>
>> On 2021/3/2 0:09, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.4.102 release.
>>> There are 340 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
>>> Anything received after that time might be too late.
>> Our test CI monitored the 5.4.102-rc2, and compile failure:
>>
>> kernel/rcu/tree.c:617:2: error: implicit declaration of function
>> ‘IRQ_WORK_INIT’; did you mean ‘IRQ_WORK_BUSY’?
>> [-Werror=implicit-function-declaration]
>>    IRQ_WORK_INIT(late_wakeup_func);
>>    ^~~~~~~~~~~~~
>>    IRQ_WORK_BUSY
>> kernel/rcu/tree.c:617:2: error: invalid initializer
>>
>> Should be commit e1e41aa31ed1 (rcu/nocb: Trigger self-IPI on late
>> deferred wake up before user resume) fails the build.
> Ah, thank you, I'll go fix that up.  Looks like 5.10.y also fails with
> that issue...

It is, same compile error for 5.10. I just confirmed both arm64 and
x86 have the same compile error.

Thanks
Hanjun
