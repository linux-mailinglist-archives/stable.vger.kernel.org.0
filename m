Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86B3430A7
	for <lists+stable@lfdr.de>; Sun, 21 Mar 2021 03:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCUCZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 22:25:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14113 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhCUCYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 22:24:45 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F31ck6jwkz19G1W;
        Sun, 21 Mar 2021 10:22:46 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sun, 21 Mar 2021 10:24:39 +0800
Subject: Re: [PATCH 4.19 0/8] 4.19.182-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210319121744.114946147@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <750c457f-2a59-1e80-193e-fbdd00d5efb0@huawei.com>
Date:   Sun, 21 Mar 2021 10:24:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/19 20:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.182 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 4.19.182-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.182-rc1
Commit: 7281e11121f6fb47ea1e757b7781c5c15e3781fe
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4688
passed: 4688
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4688
passed: 4688
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>

