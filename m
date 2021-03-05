Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E33132DFF9
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 04:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhCEDMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 22:12:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12695 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEDMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 22:12:46 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DsCRG2hV7zlT14;
        Fri,  5 Mar 2021 11:10:34 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Mar 2021 11:12:39 +0800
Subject: Re: [PATCH 5.4 000/337] 5.4.102-rc5 review
From:   Samuel Zou <zou_wei@huawei.com>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>,
        <lkft-triage@lists.linaro.org>, <patches@kernelci.org>,
        <pavel@denx.de>, <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <649b42ecf955499db9e2853227a0de83@HQMAIL101.nvidia.com>
X-Forwarded-Message-Id: <649b42ecf955499db9e2853227a0de83@HQMAIL101.nvidia.com>
Message-ID: <04cb583e-b830-ae95-ec8a-ffd3a6f87c8f@huawei.com>
Date:   Fri, 5 Mar 2021 11:12:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <649b42ecf955499db9e2853227a0de83@HQMAIL101.nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Tue, 02 Mar 2021 20:28:34 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc5.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on arm64 and x86 for 5.4.102,

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.102
Commit: 7f324ea75baa059ea126cddd4141198895880a69
Compiler: gcc version 7.3.0 (GCC)


arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4716
succeed_num: 4716
failed_num: 0
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4716
succeed_num: 4715
failed_num: 1
timeout_num: 0

Tested-by: Hulk Robot <hulkci@huawei.com>

