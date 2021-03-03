Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A89532BC29
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhCCNlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:41:39 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13423 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842746AbhCCIMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 03:12:03 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dr69W31TmzjT5V;
        Wed,  3 Mar 2021 16:09:51 +0800 (CST)
Received: from [10.174.178.147] (10.174.178.147) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Mar 2021 16:11:09 +0800
Subject: Re: [PATCH 5.4 000/340] 5.4.102-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>
References: <20210301161048.294656001@linuxfoundation.org>
From:   Hanjun Guo <guohanjun@huawei.com>
Message-ID: <c689884d-6418-98ff-f535-da022ba527f7@huawei.com>
Date:   Wed, 3 Mar 2021 16:11:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.147]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/3/2 0:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> Anything received after that time might be too late.

Tested on arm64 and x86 for 5.4.102-rc4+,

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4716
succeed_num: 4716
failed_num: 0
timeout_num: 0

x86 (No kernel failures)
--------------------------------------------------------------------
Testcase Result Summary:
total_num: 4716
succeed_num: 4715
failed_num: 1
timeout_num: 0

Tested-by: Hulk Robot <hulkci@huawei.com>
