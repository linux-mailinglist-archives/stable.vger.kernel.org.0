Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF048056B
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 01:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhL1A4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 19:56:19 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15983 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbhL1A4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 19:56:19 -0500
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JNGH03PHwzZdv0;
        Tue, 28 Dec 2021 08:53:00 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 28 Dec 2021 08:56:16 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 28 Dec 2021 08:56:15 +0800
Subject: Re: [PATCH 5.4 00/47] 5.4.169-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20211227151320.801714429@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <4a2b40be-06c3-becb-b969-0e39323b1470@huawei.com>
Date:   Tue, 28 Dec 2021 08:56:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
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



On 2021/12/27 23:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.169 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.4.169-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.169-rc1
Commit: 28a051401761545dabbf4fa3ceb65cc3116ac499
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 9014
passed: 9014
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 9014
passed: 9014
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
