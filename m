Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D8333E5C1
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCQBMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:12:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13177 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhCQBLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 21:11:49 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F0X9w1n6CzmYQD;
        Wed, 17 Mar 2021 09:09:24 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 17 Mar 2021 09:11:47 +0800
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210315135720.002213995@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <5077a4b6-77ae-b36b-1632-f551e78a604f@huawei.com>
Date:   Wed, 17 Mar 2021 09:11:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/15 21:55, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.181 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:57:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.181-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 4.19.181-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.181-rc1
Commit: a636947af93f0a20fdba2c08ae38b7825ebf9c56
Compiler: gcc version 7.3.0 (GCC)


arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4740
succeed_num: 4740
failed_num: 0
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4740
succeed_num: 4739
failed_num: 1
timeout_num: 0

Tested-by: Hulk Robot <hulkrobot@huawei.com>
