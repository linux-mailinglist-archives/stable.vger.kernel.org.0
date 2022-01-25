Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B894249AA18
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324082AbiAYDaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:25 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30299 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1319348AbiAYDIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:08:36 -0500
Received: from kwepemi100026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JjWxY0FZMzbk5W;
        Tue, 25 Jan 2022 11:07:45 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 kwepemi100026.china.huawei.com (7.221.188.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 11:08:34 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 11:08:33 +0800
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>
References: <20220124184024.407936072@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <7d899479-ed31-2459-e2b4-311fa012f299@huawei.com>
Date:   Tue, 25 Jan 2022 11:08:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/1/25 2:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.10.94-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.94-rc1
Commit: 8688457e4545b8f49cf44e8bce83aff31db395f7
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 9018
passed: 9018
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 9018
passed: 9018
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
