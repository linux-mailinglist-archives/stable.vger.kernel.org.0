Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3263A2A77
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFJLmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 07:42:14 -0400
Received: from phobos.denx.de ([85.214.62.61]:32794 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229895AbhFJLmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 07:42:14 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1F80780377;
        Thu, 10 Jun 2021 13:40:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1623325216;
        bh=QgKx5oO4Z591gMrIQUt06NCiI0Sey0sQtM2qsJJpE4M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SAoi4tuZUOrddSNcUQzcjpGa/Q4M6VUpwfnCbzhgdShoqS5XfvxWPAQcAsPGFL8BN
         Nt5t2q+fl28qku1qv8wGf/uop3ISEaYFj6+UbT01OmeR3/q/J/5E784/hGSujhZiAS
         WwUwwvuX1RV/oTC5fLh0+WmhPpNG0jHKeCXcpmxVcRDDU0VpkmTjqyOdI7/y8PdWKS
         mFEvC3cWgaDklysROBAeEIMmBIJUFAE09axUCtAB7llF0jpuY3uDNQBp46D7I28Y3B
         hri0BT8FM4gxcFn6Zqucbtj/ssuyaFJhE/4lb6GaGKw5pJ8TkUqMBc+WIr4Hl4a+2G
         JMFwIdQBPQi+Q==
Subject: Re: [PATCH 4.19 00/58] 4.19.194-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Fabio Estevam <festevam@gmail.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
References: <20210608175932.263480586@linuxfoundation.org>
 <CA+G9fYu3URCR6_ZL+KPYFEOVL4f=8TjjyFncmvoLuYrR_YR3=A@mail.gmail.com>
 <20210608224155.GA31308@amd> <YMBe9/7mJ+dGiGJA@kroah.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <439102f7-e05f-cb25-72ed-2de64a9a2560@denx.de>
Date:   Thu, 10 Jun 2021 13:40:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMBe9/7mJ+dGiGJA@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/21 8:25 AM, Greg Kroah-Hartman wrote:
> On Wed, Jun 09, 2021 at 12:41:55AM +0200, Pavel Machek wrote:
>> Hi!
>>
>>>> This is the start of the stable review cycle for the 4.19.194 release.
>>>> There are 58 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>> ...
>>>> Marek Vasut <marex@denx.de>
>>>>      ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
>>>
>>> make --silent --keep-going --jobs=8
>>> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
>>> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
>>> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
>>> Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12
>>> Label or path reg_vdd1p1 not found
>>> Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12
>>> Label or path reg_vdd2p5 not found
>>> FATAL ERROR: Syntax error parsing input tree
>>> make[2]: *** [scripts/Makefile.lib:294:
>>> arch/arm/boot/dts/imx6q-dhcom-pdk2.dtb] Error 1
>>
>> For the record, we see same build error in our testing:
>>
>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/1328869295
> 
> Will fix this and push out a -rc2.

I suspect for 4.19.y , you will need to pick the following as 
dependency. It looks like board DT patch, but it also adds the missing 
labels to imx6qdl.dtsi

93385546ba36 ("ARM: dts: imx6qdl-sabresd: Assign corresponding power 
supply for LDOs")
