Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAC336A30
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 03:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCKCjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 21:39:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12707 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhCKCjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 21:39:06 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DwtPR3YfczmVr3;
        Thu, 11 Mar 2021 10:36:43 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 10:38:59 +0800
Subject: Re: [PATCH 5.10 00/49] 5.10.23-rc1 review
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210310132321.948258062@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <ed5203a3-0fb8-fc0a-5cff-c76583c5116d@huawei.com>
Date:   Thu, 11 Mar 2021 10:38:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/10 21:23, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.10.23-rc2,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.23-rc2+
Commit: 93276f11b3afe08c3f213a3648483b1a8789673b
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

