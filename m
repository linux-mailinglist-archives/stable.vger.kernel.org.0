Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9D9331C10
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 02:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCIBIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 20:08:52 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13869 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhCIBI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 20:08:28 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DvcVN48DRz8vMR;
        Tue,  9 Mar 2021 09:06:36 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 09:08:20 +0800
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210308122718.120213856@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <286bc1de-04cf-d60a-e928-8f94b2979b6d@huawei.com>
Date:   Tue, 9 Mar 2021 09:08:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/8 20:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.22 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on arm64 and x86 for 5.10.22-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.22-rc1+
Commit: 9226165b6cc7667b147e1de52090d1b6a17af336
Compiler: gcc version 7.3.0 (GCC)


arm64 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4710
succeed_num: 4709
failed_num: 1
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4710
succeed_num: 4709
failed_num: 1
timeout_num: 0

Tested-by: Hulk Robot <hulkci@huawei.com>
