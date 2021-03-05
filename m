Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594C832E45A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 10:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhCEJIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 04:08:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12696 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhCEJIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 04:08:07 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DsMKG36MJzlSgT;
        Fri,  5 Mar 2021 17:05:54 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Mar 2021 17:08:01 +0800
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc4 review
References: <1d172bcc33f44475b8c6737e9b58c439@HQMAIL107.nvidia.com>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>,
        <lkft-triage@lists.linaro.org>, <patches@kernelci.org>,
        <pavel@denx.de>, <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
From:   Samuel Zou <zou_wei@huawei.com>
X-Forwarded-Message-Id: <1d172bcc33f44475b8c6737e9b58c439@HQMAIL107.nvidia.com>
Message-ID: <6f292dad-0a40-01be-ec5a-cee263ac080a@huawei.com>
Date:   Fri, 5 Mar 2021 17:08:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1d172bcc33f44475b8c6737e9b58c439@HQMAIL107.nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:28:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.178 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.178-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on arm64 and x86 for 4.19.178,

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.178
Commit: dfb571610ba392179348c8472bfb131d4173d585
Compiler: gcc version 7.3.0 (GCC)


arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4674
succeed_num: 4674
failed_num: 0
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4674
succeed_num: 4769
failed_num: 5
timeout_num: 0

Tested-by: Hulk Robot <hulkci@huawei.com>
