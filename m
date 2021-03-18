Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7661034050B
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCRMAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 08:00:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13573 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhCRMAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 08:00:06 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F1QWM6jbfzQjL1;
        Thu, 18 Mar 2021 19:57:35 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Mar 2021 19:59:59 +0800
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210315135720.002213995@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <872e57d3-0651-1350-7e66-3f9f4c89964e@huawei.com>
Date:   Thu, 18 Mar 2021 19:59:59 +0800
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

Tested on arm64 for 4.19.181,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.181
Commit: ac3af4beac439ebccd17746c9f2fd227e88107aa
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4726
passed: 4721
failed: 5
--------------------------------------------------------------------
Failed cases:
ltp test_robind24
ltp test_robind25
ltp test_robind26
ltp test_robind27
ltp test_robind28

The 5 failed cases are caused by insufficient disk space in the test 
environment, no kernel failures
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>

