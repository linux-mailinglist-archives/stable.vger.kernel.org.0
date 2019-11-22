Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6EC107368
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 14:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfKVNis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 08:38:48 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4392 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfKVNis (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 08:38:48 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd7e4e30000>; Fri, 22 Nov 2019 05:38:43 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 22 Nov 2019 05:38:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 22 Nov 2019 05:38:47 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Nov
 2019 13:38:45 +0000
Subject: Re: [PATCH 4.19 000/220] 4.19.86-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100912.732983531@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <e9c7ae84-9780-fb68-c9aa-d6568f12fca8@nvidia.com>
Date:   Fri, 22 Nov 2019 13:38:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574429923; bh=tA7WAgBVwtMJrkfWkmbMdQ7ed2BUtMQNBW9BEHKpMDQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=fnJKdJRbhbWWmbsGOnrZqKUl5Uz/xvxNOfWc6Ks6+wSvv060pOIlgfHaa3DxbDju6
         LoWIEfM8PF2y1lzjnNJv4QkdYY1vjaG2k+WZQ4AfvrKVz6I/fXZQ8wyY5aSaSaz0Fh
         2jS+EJYY5sjMI++t4BkJyYWtS0d/W3cISzkiiybOdOsKUlX2w63ZVtloJT7OE/iZ5l
         IJGId0gMY99EX04ghoSrsXy03cbJEjMHHYw50zhl60CywUIcrJUMG0KAnKl+dhQEFY
         pC8dzX8E4INT8GCgFuOSGDiqo/ZycOKvjgU2rIe27xl5YN4qvAJlJCKg3RQP1wdGxh
         ffvMVJYElXM/g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/11/2019 10:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.86 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.86-rc1-g2582c18680a8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
