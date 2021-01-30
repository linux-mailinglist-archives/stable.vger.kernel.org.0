Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA05D309588
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhA3NvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:51:19 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4003 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3NvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:51:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6015642e0000>; Sat, 30 Jan 2021 05:50:38 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 13:50:35 +0000
Subject: Re: [PATCH 5.10 00/32] 5.10.12-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>,
        linux-stable <stable@vger.kernel.org>, <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
References: <20210129105912.628174874@linuxfoundation.org>
 <CA+G9fYsEseDKySENMfSiRMgh-CTefpCtsQsBFbJ6tfmRoBPxwA@mail.gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <980a1226-4ebb-cd29-c020-1fcbe8517ca8@nvidia.com>
Date:   Sat, 30 Jan 2021 13:50:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsEseDKySENMfSiRMgh-CTefpCtsQsBFbJ6tfmRoBPxwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612014638; bh=t6G/4xPI7UXTD0NC8smXnkhAJsH3X+Ll/cLQi3AMeu8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=HaU1hH+fLYl5REdkMS+TwokkIMUxAjXPgu7zX2VzfZMqZLdS9lbd6z94p7hysxDHB
         Shbm+CYikjVmZkDxP2Q8bSdkIDiiCZGqSrAlmZG94kb5Knm9RMIaSNJLdg+a/fSS+I
         vB3Fr+mjmjLDdCCXUA2kL9XGVKku9plaVG7ufPH0/xjMrS1/G3kI0uTw+RZceBJqWn
         +KbAHMzlFh4TmrTuDiEfszaP/EDMN/6B+EOHrnFHnxeyJGgYvVqmrmyqarmW1Lz3yR
         Qz7o9n6MoDI/lkmCxQ/ta/JyCrZtzFeraYf4BIGdhW1rPDQuyNykxyT7VB6ExCQ5/k
         QgbsryBlKFdng==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/01/2021 18:22, Naresh Kamboju wrote:
> On Fri, 29 Jan 2021 at 16:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.10.12 release.
>> There are 32 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
Replying here because I don't have the original.

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.12-rc1-g324e71045b28
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon


-- 
nvpublic
