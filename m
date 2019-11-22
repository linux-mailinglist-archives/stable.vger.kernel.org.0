Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D46610734F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 14:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKVNgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 08:36:01 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4311 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfKVNgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 08:36:01 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd7e43c0000>; Fri, 22 Nov 2019 05:35:56 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 22 Nov 2019 05:36:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 22 Nov 2019 05:36:00 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Nov
 2019 13:35:58 +0000
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
Message-ID: <9e2a0022-f01d-2db4-8ea2-cffb0b038df1@nvidia.com>
Date:   Fri, 22 Nov 2019 13:35:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574429756; bh=5S7fgW2SwsVDbF2iFWilv7AEr4njY1lCaViplEfn3QE=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ALwikzKhQv06gc5qHkjMiHaRP2VWZhZzquT/9wgc70hGcEZb9vWiCpsx0vNDT9Hwd
         Th9TSITSOpYjNHnxzYdxbt59W0dgPjJCXw8kljX0I6XdSJI/SXDTdXj63dJ022Yh30
         pzQ0n0HlK69bC2u8tGo+yj2Fux0PtLNLE/+ASxR2McHTQMiQci3xc49FeFIqoaHDwR
         OdlDIbjohOyYmvFCQAUySkZurtrIcEPhFLukL+SUHAMSzp1sSnkZKeaFVm0Nq+MWG9
         s0+e0nBGU8/zkS+prSMxaqnKwwbr4+kP0fLGEKOAKX537NAqTP8M5deIAKCbdL9qbf
         z6dWYcBTZpzyg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/11/2019 13:14, Jon Hunter wrote:
> 
> On 22/11/2019 10:26, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.4.203 release.
>> There are 159 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.203-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
> 
> ...
> 
>> Marek Szyprowski <m.szyprowski@samsung.com>
>>     ARM: dts: exynos: Disable pull control for S5M8767 PMIC
> 
> The above commit is causing the following build error for ARM ...
> 
> Error: /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/exynos5250-arndale.dts:560.22-23 syntax error
> FATAL ERROR: Unable to parse input tree
> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/exynos5250-arndale.dtb' failed
> make[2]: *** [arch/arm/boot/dts/exynos5250-arndale.dtb] Error 1

FYI ... after reverting the above all the tests are passing for Tegra.

Jon

-- 
nvpublic
