Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7360032F768
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 02:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCFBAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 20:00:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13476 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhCFBAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 20:00:16 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DsmSJ1WxczjTkx;
        Sat,  6 Mar 2021 08:58:24 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Sat, 6 Mar 2021 09:00:04 +0800
Subject: Re: [PATCH 4.19 00/52] 4.19.179-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210305120853.659441428@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <b802c1eb-a0ca-3778-4c6d-af7b9e890639@huawei.com>
Date:   Sat, 6 Mar 2021 09:00:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/5 20:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.179 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on arm64 and x86 for 4.19.179-rc1,

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.179-rc1+
Commit: 1112456421caf2562801d760aef4da53915246c0
Compiler: gcc version 7.3.0 (GCC)


arm64 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4674
succeed_num: 4715
failed_num: 1
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4674
succeed_num: 4670
failed_num: 4
timeout_num: 0

Tested-by: Hulk Robot <hulkci@huawei.com>
