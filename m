Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A3233FF1B
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 06:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCRFzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 01:55:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13188 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhCRFym (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 01:54:42 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1GPp4K3CzmZH9;
        Thu, 18 Mar 2021 13:52:14 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Mar 2021 13:54:34 +0800
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210315135740.245494252@linuxfoundation.org>
 <c0902934-ea11-ba1e-fa2d-b05897aab4b3@huawei.com>
 <YFIh6ZyWb2JtCu6H@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <f2328179-00d9-41e0-6bd8-7bd39b025563@huawei.com>
Date:   Thu, 18 Mar 2021 13:54:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YFIh6ZyWb2JtCu6H@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/17 23:36, Greg KH wrote:
> On Tue, Mar 16, 2021 at 02:35:36PM +0800, Samuel Zou wrote:
>>
>>
>> On 2021/3/15 21:56, gregkh@linuxfoundation.org wrote:
>>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> This is the start of the stable review cycle for the 4.14.226 release.
>>> There are 95 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.226-rc1.gz
>>> or in the git tree and branch at:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Tested on x86 for 4.14.226-rc1,
>>
>> Kernel repo:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> Branch: linux-4.14.y
>> Version: 4.14.226-rc1
>> Commit: 57cc62fb2d2b8e81c02cb9197e303c7782dee4cd
>> Compiler: gcc version 7.3.0 (GCC)
>>
>> x86 (No kernel failures)
>> --------------------------------------------------------------------
>> Testcase Result Summary:
>> total_num: 4728
>> succeed_num: 4727
>> failed_num: 1
> 
> What does this "failed_num" mean?
> 
> thanks,
> 
> greg k-h

total_num: The number of total testcases
succeed_num: The number of succeed testcases
failed_num: The number of failed testcases

Maybe I can revise the description in the next email.
