Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774FA336F10
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 10:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhCKJnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 04:43:17 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13521 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhCKJmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 04:42:52 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dx3pN4GJ7zNl0L;
        Thu, 11 Mar 2021 17:40:28 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 17:42:42 +0800
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210310132320.550932445@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <1e283f99-ef4c-9f80-0d72-03ad0b9a1cd0@huawei.com>
Date:   Thu, 11 Mar 2021 17:42:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/10 21:24, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.105 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.4.105-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.105-rc1+
Commit: 62f8f08c9d2fbc6c5692d90f64dd70e3a8edd986
Compiler: gcc version 7.3.0 (GCC)


arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4703
succeed_num: 4703
failed_num: 0
timeout_num: 0

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4703
succeed_num: 4703
failed_num: 0
timeout_num: 0

Tested-by: Hulk Robot <hulkrobot@huawei.com>
