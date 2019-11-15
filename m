Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DC0FDF4F
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 14:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKONua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 08:50:30 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12419 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfKONu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 08:50:29 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcead250000>; Fri, 15 Nov 2019 05:50:29 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 15 Nov 2019 05:50:29 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 15 Nov 2019 05:50:29 -0800
Received: from [10.26.11.193] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Nov
 2019 13:50:26 +0000
Subject: Re: [PATCH 4.4 00/20] 4.4.202-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191115062006.854443935@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <33b9e58a-34ce-a98d-8f42-bc575cec7b07@nvidia.com>
Date:   Fri, 15 Nov 2019 13:50:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573825829; bh=Jr4Mq44E8PIMI+EiKrnMcOOAV+D0NRPVOg3AjfBBehg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZqGvb7rBnrasVsaFoyddrxGJofm73G6q5mmu5+GCVmrKv+xSfPJbLWOg03n4skOFJ
         g0CuvNve1zDKHmhd/J8GZLsppARLd05T42MgJC2EvL3WwKdSYJVWHwJz4tSo1r8kI9
         /QQEDmzqZFfWANREf5q2+5Xcjfj5ph/w3j4Tu9C6ud29oXp2I6XrxqbBgr2kXUsOcl
         W+ULWROqRpd7nQ9OKcIc8igAsW/pCfHuZbe3ORx9bSNC0Ljnh6EbaQxs3dCU1s1hlL
         L/jl4JoRzgHr9pJlt8DJT42xuRFobd6AUShhueK6Pr3jwhvLzZ5qIPTRPhkqf29YRC
         61DzFGamdZeow==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/11/2019 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.202 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2019 06:18:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.202-rc1-gb0074e36d782
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
