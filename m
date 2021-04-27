Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1531E36C1B0
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 11:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhD0J1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 05:27:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16161 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhD0J1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 05:27:38 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FTxCQ4Gh6zpbrF;
        Tue, 27 Apr 2021 17:23:46 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 27 Apr 2021 17:26:50 +0800
Subject: Re: [PATCH 4.14 00/49] 4.14.232-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210426072819.721586742@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <7dd80877-3a9e-2435-ae85-9eb0747797f9@huawei.com>
Date:   Tue, 27 Apr 2021 17:26:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/4/26 15:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.232 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.232-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on x86 for 4.14.232-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.232-rc1
Commit: 3ac46322bf509c3f3735c8287d28702ee6172b6e
Compiler: gcc version 7.3.0 (GCC)

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 6251
passed: 6251
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
