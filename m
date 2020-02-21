Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8104B167CFA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 12:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBUL6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 06:58:08 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41750 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgBUL6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 06:58:08 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01LBvPlh111162;
        Fri, 21 Feb 2020 05:57:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582286245;
        bh=Ca1Ao9NtXuhmJPeqJptGJBStA1MND4WCzKzNh1qZtpg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Oh4yKSqGkFTzIqFMzqY9N/dImJirRcjrlWjGYeJV2FP2ENhKbHcnC76WYzeLaORft
         xarnHFZd1UCzwbOgBwrHHzCW5GlfZR70ed2krU9TFdirYwAO/tDno457gPvQxLn1lU
         ugZ0V9Pme09X4wFs2Q8jd+yJeEDT8QwxIY/xHFZU=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01LBvPb3119241
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Feb 2020 05:57:25 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 21
 Feb 2020 05:57:24 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 21 Feb 2020 05:57:25 -0600
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01LBvLDj075165;
        Fri, 21 Feb 2020 05:57:21 -0600
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "tony@atomide.com" <tony@atomide.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, <patches@kernelci.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jon Hunter <jonathanh@nvidia.com>
References: <20200221072349.335551332@linuxfoundation.org>
 <529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com>
 <CA+G9fYv-KC0v++YsyXR-rhC2JBGUfhNGD+XYaZjN3fJSX1x_mg@mail.gmail.com>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <f671fbf6-1cd5-ae8a-82e7-d3aba63e9840@ti.com>
Date:   Fri, 21 Feb 2020 13:57:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYv-KC0v++YsyXR-rhC2JBGUfhNGD+XYaZjN3fJSX1x_mg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/02/2020 13:17, Naresh Kamboju wrote:
> On Fri, 21 Feb 2020 at 15:34, Jon Hunter <jonathanh@nvidia.com> wrote:
>>
>>
>> On 21/02/2020 07:36, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.4.22 release.
>>> There are 344 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>        https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc1.gz
>>> or in the git tree and branch at:
>>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>
>> ...
>>
>>> Tero Kristo <t-kristo@ti.com>
>>>      ARM: OMAP2+: pdata-quirks: add PRM data for reset support
>>
>>
>> The above commit is generating the following build error on ARM systems ...
>>
>> dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error: linux/platform_data/ti-prm.h: No such file or directory
>>   #include <linux/platform_data/ti-prm.h>
>>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> build error:
> 
> ../arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error:
> linux/platform_data/ti-prm.h: No such file or directory
>     27 | #include <linux/platform_data/ti-prm.h>
>        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make[2]: *** [../scripts/Makefile.build:265:
> arch/arm/mach-omap2/pdata-quirks.o] Error 1
> 
> With these below three patches, it applies cleanly and builds.
> But I'm not sure these are not expected to get into stable rc 5.4 branch.

Yeah, without PRM driver the pdata-quirk patch should not have been 
picked up. I wonder why it ended up in stable. Tony, any ideas?

-Tero

> 
> 3e99cb214f03 ("soc: ti: add initial PRM driver with reset control support")
> c5117a78dd88 ("soc: ti: omap-prm: poll for reset complete during de-assert")
> d30cd83f6853 ("soc: ti: omap-prm: add support for denying idle for
> reset clockdomain")
> 
> However, it's only patch
> d30cd83f6853 ("soc: ti: omap-prm: add support for denying idle for
> reset clockdomain")
> that introduces file linux/platform_data/ti-prm.h
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
