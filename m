Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0715734DD57
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 03:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhC3BLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 21:11:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15386 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhC3BK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 21:10:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8WYl6xC3zmV7p;
        Tue, 30 Mar 2021 09:09:15 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 09:10:51 +0800
Subject: Re: [PATCH 5.4 000/111] 5.4.109-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210329075615.186199980@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <8c6f993e-d994-857f-db42-19b114d5eae4@huawei.com>
Date:   Tue, 30 Mar 2021 09:10:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/29 15:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.109 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.4.109-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.109-rc1
Commit: 7b78fa4bf15f02997c4dba22fe2bf2ca8aa9906f
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4720
passed: 4720
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4720
passed: 4720
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>


