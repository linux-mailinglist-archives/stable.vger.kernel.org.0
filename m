Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8513B7B28
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 03:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhF3BDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 21:03:01 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9428 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhF3BDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 21:03:01 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GF2xc4BzGzZkC1;
        Wed, 30 Jun 2021 08:57:24 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 09:00:30 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 30 Jun 2021 09:00:30 +0800
Subject: Re: [PATCH 4.19 000/109] 4.19.196-rc1 review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>
References: <20210628143305.32978-1-sashal@kernel.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <fbb5f71a-0b2c-52c8-1c4b-7e0acb9e33ef@huawei.com>
Date:   Wed, 30 Jun 2021 09:00:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/6/28 22:31, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.196 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:32:48 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.19.y&id2=v4.19.195
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Tested on arm64 and x86 for 4.19.196-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.196-rc1
Commit: 7064c50476914a248e42de8f0d3fa614be5f1b8f
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8858
passed: 8858
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8858
passed: 8858
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
