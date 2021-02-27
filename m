Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721D9326B12
	for <lists+stable@lfdr.de>; Sat, 27 Feb 2021 02:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhB0Bsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 20:48:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13005 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0Bsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 20:48:39 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DnTrp5pHpzjQtp;
        Sat, 27 Feb 2021 09:46:18 +0800 (CST)
Received: from [10.174.178.147] (10.174.178.147) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 09:47:46 +0800
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210225092516.531932232@linuxfoundation.org>
 <8ec51c24-4c48-076e-2294-e27da7e7a2c4@huawei.com>
Message-ID: <afd3980f-bf3a-7860-052c-cbea502e3c35@huawei.com>
Date:   Sat, 27 Feb 2021 09:47:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8ec51c24-4c48-076e-2294-e27da7e7a2c4@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.147]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/2/26 14:44, Hanjun Guo wrote:
> Hi Greg,
> 
> On 2021/2/25 17:53, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.19 release.
>> There are 23 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
>> Anything received after that time might be too late.
> 
> It takes longer time to set up our test farm than I expected,
> for now we can run test on x86 for stable 5.10, test for
> ARM64 server and other stable kernels (4.19 and 5.4) is
> in progress (needs more machines and a rack in the data
> center), please give us a bit more time to get things ready.
> 
> Here is the test results for x86, compiled and booted OK,
> also no regressions for the functional test [1] (the failed
> ones are the mismatch of the testcase and the test environment,
> not the kernel failures),

Although 5.10.19 is released, it's better to report the ARM64
test results as well:

Testcase Result Summary:

total_num: 4732

succeed_num: 4732

failed_num: 0

timeout_num: 0

Thanks
Hanjun
