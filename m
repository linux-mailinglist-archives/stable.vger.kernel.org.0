Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F985107438
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKVOtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 09:49:01 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4432 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVOtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 09:49:01 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd7f55c0001>; Fri, 22 Nov 2019 06:49:00 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 22 Nov 2019 06:48:59 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 22 Nov 2019 06:48:59 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Nov
 2019 14:48:56 +0000
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
 <20191122133931.GA2033651@kroah.com> <20191122134131.GA2050590@kroah.com>
 <20191122134627.GB2050590@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
Date:   Fri, 22 Nov 2019 14:48:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122134627.GB2050590@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574434140; bh=5zJwPgzKYpwKJ1aj1MAeZ2Z01KtX4Frh3wO3f5hM4pA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Avm9ZTQOf7Zw8l7u6iU7h5QGTqTPeBQw2xuyvwmxwxdFjmqNtU+ijiZEZDfv3lMVc
         m0ML1R65r0t8xGHV88XqH+gxYEcBGzTXwxxW9ytpdsXXFy1RoIVdaWCBtf03WCjiUt
         kE8jhVBzb6akvYu1GpXCvsgvUVG6OBkJ4CqL27lf/0HXglTC35s1nmQzo/ZDapTqjL
         r/uiwFWbEFgpDYSUVMmdGZK0rMdDOJSFkQUXlnbNohriVSgraAC0r3/1ZjELxMK0iP
         tAHklBMboUAAmBa4YS6fHBv3C8FIVbLQ+f2WYut+tSI8VpNhTIOGtc301sBFlVGxmp
         zpfXn7mIq2hLg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/11/2019 13:46, Greg Kroah-Hartman wrote:
> On Fri, Nov 22, 2019 at 02:41:31PM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Nov 22, 2019 at 02:39:31PM +0100, Greg Kroah-Hartman wrote:
>>> On Fri, Nov 22, 2019 at 01:14:28PM +0000, Jon Hunter wrote:
>>>>
>>>> On 22/11/2019 10:26, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 4.4.203 release.
>>>>> There are 159 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.203-rc1.gz
>>>>> or in the git tree and branch at:
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>> -------------
>>>>> Pseudo-Shortlog of commits:
>>>>
>>>> ...
>>>>
>>>>> Marek Szyprowski <m.szyprowski@samsung.com>
>>>>>     ARM: dts: exynos: Disable pull control for S5M8767 PMIC
>>>>
>>>> The above commit is causing the following build error for ARM ...
>>>>
>>>> Error: /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/exynos5250-arndale.dts:560.22-23 syntax error
>>>> FATAL ERROR: Unable to parse input tree
>>>> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/exynos5250-arndale.dtb' failed
>>>> make[2]: *** [arch/arm/boot/dts/exynos5250-arndale.dtb] Error 1
>>>
>>> Ugh. I'll go drop this from 4.4.y, is it also an issue in the 4.9.y
>>> tree?
>>
>> Ah, I see your other email now, so I'll leave it in 4.9.y and push out a
>> new 4.4.y tree now.
> 
> -rc2 is out now, with that patch removed, thanks.

Thanks. Well this is odd, now I see ...

Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or path dwc3 not found
FATAL ERROR: Syntax error parsing input tree
scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/omap5-igep0050.dtb' failed
make[1]: *** [arch/arm/boot/dts/omap5-igep0050.dtb] Error 1
arch/arm/Makefile:338: recipe for target 'dtbs' failed
make: *** [dtbs] Error 2


This is caused by the following commit ...

commit d0abc07b3d752cbe2a8d315f662c53c772caed0f
Author: H. Nikolaus Schaller <hns@goldelico.com>
Date:   Fri Sep 28 17:54:00 2018 +0200

    ARM: dts: omap5: enable OTG role for DWC3 controller


I was wondering why I did not see this before as it was listed
in the original email but looking back at the git log of what I
tested before, I don't see it ...

$ git log --oneline bc69c961f595..7bbe76363f8f arch/arm/boot
b883613d6f68 ARM: tegra: apalis_t30: fix mmc1 cmd pull-up
a1496418067c ARM: dts: tegra30: fix xcvr-setup-use-fuses
e3c8a2e4d6b6 ARM: dts: ste: Fix SPI controller node names
1c9e00b657ad ARM: dts: ux500: Fix LCDA clock line muxing
ec144e236880 ARM: dts: ux500: Correct SCU unit address
98c94b7bce20 ARM: dts: am335x-evm: fix number of cpsw
13b662ab1602 libfdt: Ensure INT_MAX is defined in libfdt_env.h
2b6e4587d0f5 ARM: dts: socfpga: Fix I2C bus unit-address error
1c4b78b0c003 ARM: dts: omap3-gta04: keep vpll2 always on
0c7dc0f3b2c3 ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-Boot
3ecbffc9b6e4 ARM: dts: omap3-gta04: tvout: enable as display1 alias
a787cf8ff717 ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overwrite in other DTS files
83264404b9c9 ARM: dts: exynos: Disable pull control for S5M8767 PMIC
dbe192b499b7 ARM: dts: pxa: fix power i2c base address
f1a2904901ad ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook
9742b4c1d281 ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Anyway, not sure what happen there, but looks like the above
omap5 commit also needs to be dropped. I think you also need
to drop the following as there is a dependency between the two
...

commit 56bfbfd3fd46d250749fa4d5974147eb1e456a5b
Author: Roger Quadros <rogerq@ti.com>
Date:   Wed Dec 5 19:27:44 2018 +0200

    ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Cheers
Jon

-- 
nvpublic
