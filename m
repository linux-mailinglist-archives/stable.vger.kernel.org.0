Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C160B32E45B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 10:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhCEJIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 04:08:20 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13863 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEJHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 04:07:52 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DsMKP5nscz8t1v;
        Fri,  5 Mar 2021 17:06:01 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Mar 2021 17:07:43 +0800
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
References: <1eca83a8a33c44f99ed11d3b423505df@HQMAIL107.nvidia.com>
From:   Samuel Zou <zou_wei@huawei.com>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>,
        <lkft-triage@lists.linaro.org>, <patches@kernelci.org>,
        <pavel@denx.de>, <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
X-Forwarded-Message-Id: <1eca83a8a33c44f99ed11d3b423505df@HQMAIL107.nvidia.com>
Message-ID: <da58faaa-e0f4-c0f4-d68c-7c1c09415b58@huawei.com>
Date:   Fri, 5 Mar 2021 17:07:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1eca83a8a33c44f99ed11d3b423505df@HQMAIL107.nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:28:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 657 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on arm64 and x86 for 5.10.20,

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.20
Commit: 83be32b6c9e55d5b04181fc9788591d5611d4a96
Compiler: gcc version 7.3.0 (GCC)


arm64 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4716
succeed_num: 4713
failed_num: 3
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4716
succeed_num: 4713
failed_num: 3
timeout_num: 0

Tested-by: Hulk Robot <hulkci@huawei.com>
