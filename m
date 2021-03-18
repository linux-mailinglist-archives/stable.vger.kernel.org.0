Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114AF34050A
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhCRMAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 08:00:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13195 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhCRMAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 08:00:23 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1QWn1C5wzmYLc;
        Thu, 18 Mar 2021 19:57:57 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Mar 2021 20:00:20 +0800
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210315135740.245494252@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <39278f2a-ef03-fc33-e81b-c8063d0d64ef@huawei.com>
Date:   Thu, 18 Mar 2021 20:00:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/15 21:56, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.14.226 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on x86 for 4.14.226,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.226
Commit: cb83ddcd5332fcc3efd52ba994976efc4dd6061e
Compiler: gcc version 7.3.0 (GCC)

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4714
passed: 4710
failed: 4
--------------------------------------------------------------------
Failed cases:
ltp test_robind07
ltp test_robind13
ltp test_robind14
ltp test_robind15

The 4 failed cases are caused by insufficient disk space in the test 
environment, no kernel failures
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
