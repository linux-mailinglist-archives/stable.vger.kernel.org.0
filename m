Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5143D1027A9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfKSPHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:07:36 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9905 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfKSPHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 10:07:36 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd4053a0000>; Tue, 19 Nov 2019 07:07:38 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 07:07:35 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 Nov 2019 07:07:35 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 15:07:32 +0000
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191119051400.261610025@linuxfoundation.org>
 <20468dbc-5b88-f86e-9d5d-5edca4e4be2b@nvidia.com>
 <20191119122417.GA1913916@kroah.com> <20191119123003.GA1948960@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5598bd6b-c08e-d6e2-c5c3-70b53c95298e@nvidia.com>
Date:   Tue, 19 Nov 2019 15:07:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119123003.GA1948960@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574176058; bh=rRWNynZ6z7GavQMzPJly6gpgkhMWxCTP1LtIS/xcWLs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SGjxRW0+aoi3KbvSp+rymn+vVqIU00qiKQHnV/WmvGtxuLDv9Dmvxa1eixPhGbKRt
         tlZf0moILlRvfd3BbvDi6dQ8otwDUvToFhsgysnK93gRAI+ftC0CrWXowuVRlUW9JR
         mN9KJ/TDMmhVy2zc5ar105bzqrzEhQme7LjHMyMg4ymfVztUlf6qW3xklMc0EVYLr4
         xL1vqnADefnf2eXaUgoBFKV+tLFYIw6XHjFaF/sAUsGbW9P3lJPugK9onosFB22Fu2
         H5iNWmNN0Bn3nj2XziJZ3qXdLvR+3cvV/i9i3LHZH8S/kSpShIb2qvbscLDR+Vqx4A
         kFvKSGbH2s6wA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/11/2019 12:30, Greg Kroah-Hartman wrote:
> On Tue, Nov 19, 2019 at 01:24:17PM +0100, Greg Kroah-Hartman wrote:
>> On Tue, Nov 19, 2019 at 09:18:03AM +0000, Jon Hunter wrote:
>>>
>>> On 19/11/2019 05:13, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.19.85 release.
>>>> There are 422 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.85-rc1.gz
>>>> or in the git tree and branch at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> -------------
>>>
>>> ...
>>>
>>>> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>>>>     ARM: dts: meson8b: odroidc1: enable the SAR ADC
>>>
>>> This commit is generating the following compilation error for ARM ...
>>>
>>> arch/arm/boot/dts/meson8b-odroidc1.dtb: ERROR (phandle_references): /soc/cbus@c1100000/adc@8680: Reference to non-existent node or label "vcc_1v8"
>>>
>>> ERROR: Input tree has errors, aborting (use -f to force output)
>>> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/meson8b-odroidc1.dtb' failed
>>> make[1]: *** [arch/arm/boot/dts/meson8b-odroidc1.dtb] Error 2
>>> arch/arm/Makefile:348: recipe for target 'dtbs' failed
>>> make: *** [dtbs] Error 2
>>
>> Thanks, will go remove that patch.
> 
> -rc2 is out with that patch removed.

All tests for Tegra are passing ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.85-rc2-gaf1bb7db3102
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers!
Jon

-- 
nvpublic
