Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3692314A0F8
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 10:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgA0JiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 04:38:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17391 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbgA0JiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 04:38:23 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2eaf7f0000>; Mon, 27 Jan 2020 01:38:07 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 27 Jan 2020 01:38:22 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 27 Jan 2020 01:38:22 -0800
Received: from [10.26.11.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Jan
 2020 09:38:19 +0000
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>, <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
 <20200124173659.GD3166016@kroah.com>
 <8a782263-aca3-3846-12a0-4eb21f015894@nvidia.com>
 <87fcb1f0-b1b8-a6e2-b8f6-b95a07f67919@nvidia.com>
 <eadee1dd-fb6d-855d-935a-4bf93a9ad505@roeck-us.net>
 <20200126091319.GA3549630@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <61b59750-b08f-c4e9-b472-44b1d096f4cf@nvidia.com>
Date:   Mon, 27 Jan 2020 09:38:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126091319.GA3549630@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580117888; bh=lX0KzGb96QcvTe8C9CbJhl9q6tsbAsq2aPO+eI+amPw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ICv0V0Ewajl5ISmpiv40LEi8u1lzrhLXvZ3RwaGBhOgXi1oix5Gw4wElHv3mGokU9
         cA8oCEvfCoXoriD0v+zjzZbUsWj0zcypE0nUYY/1eacaqd3ShbEwzlI44FixSbX8vT
         yw5wL+bkG6oV1/l+iewnUyfBVvd77Qlezm3Mx/5JPIHRbstnBBmlsTPU4AnyOosvD1
         AHM/m4VBETk4gDcRxZVAcs/h3kKP6aVwnNPPlAs2FJvJ0YVskGr/MROTB52Sc181gB
         A/6K62G26ZQXO7d4b0unbb/uZ57RaIH7pcxGB5xojEjC77yEr4VRepRhOnSnZtaPkG
         ObdkNhY1A9iCQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/01/2020 09:13, Greg Kroah-Hartman wrote:
> On Sat, Jan 25, 2020 at 07:46:47AM -0800, Guenter Roeck wrote:
>> On 1/25/20 3:32 AM, Jon Hunter wrote:
>>>
>>> On 24/01/2020 18:07, Jon Hunter wrote:
>>>>
>>>> On 24/01/2020 17:36, Greg Kroah-Hartman wrote:
>>>>> On Fri, Jan 24, 2020 at 02:50:05PM +0000, Jon Hunter wrote:
>>>>>> Hi Greg,
>>>>>>
>>>>>> On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
>>>>>>> This is the start of the stable review cycle for the 4.19.99 release.
>>>>>>> There are 639 patches in this series, all will be posted as a response
>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>> let me know.
>>>>>>>
>>>>>>> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
>>>>>>> Anything received after that time might be too late.
>>>>>>>
>>>>>>> The whole patch series can be found in one patch at:
>>>>>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
>>>>>>> or in the git tree and branch at:
>>>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>>>>> and the diffstat can be found below.
>>>>>>>
>>>>>>> thanks,
>>>>>>>
>>>>>>> greg k-h
>>>>>>>
>>>>>>> -------------
>>>>>>> Pseudo-Shortlog of commits:
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>>>>      PCI: PM: Skip devices in D0 for suspend-to-idle
>>>>>>
>>>>>> The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
>>>>>> Reverting this on top of v4.19.99-rc1 fixes the issue.
>>>>>
>>>>> This is also in the 4.14 queue, so should I drop it there too?
>>>>
>>>> I did not see any failures with the same board on that branch, so I
>>>> would say no, but odd that it only fails here. It was failing for me
>>>> 100% so I would have expected to see if there too if it was a problem.
>>>
>>> Hmmm, rc2 still not working for me ...
>>>
>>> Test results for stable-v4.19:
>>>      11 builds:	11 pass, 0 fail
>>>      22 boots:	22 pass, 0 fail
>>>      32 tests:	30 pass, 2 fail
>>>
>>> Linux version:	4.19.99-rc2-g24832ad2c623
>>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                  tegra194-p2972-0000, tegra20-ventana,
>>>                  tegra210-p2371-2180, tegra30-cardhu-a04
>>>
>>> I still see the following commit in rc2 ...
>>>
>>> commit bb52152abe85f971278a7a4f033b29483f64bfdb
>>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Date:   Thu Jun 13 23:59:45 2019 +0200
>>>
>>>      PCI: PM: Skip devices in D0 for suspend-to-idle
> 
> Yes, I did not change anything in -rc2 for you, sorry.
> 
>>> BTW, I checked the 4.14. queue and I do not see the above change in
>>> there, however, there is similar change ...
>>>
>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>      PCI: PM: Avoid possible suspend-to-idle issue
>>>
>> bb52152abe85 fixes this one, which in turn fixes 33e4f80ee69b.
>> The above in 4.14 but not its fixes is spelling a bit of trouble.
>>
>> Maybe commit 471a739a47aa7 ("PCI: PM: Avoid skipping bus-level
>> PM on platforms without ACPI") was added to -rc2, since it is
>> supposed to fix bb52152abe85.
> 
> I have added that fix to 4.14 now, and will go push out a -rc3 for both
> 4.19.y and 4.14.y to try to sync up on this and figure it out.
> 
> Jon, if you could retest 4.14.y, that would be great, to see if it has
> the same issue that 4.19.y has.  And if so, that means I should probably
> just drop both patches from both trees, right?


So v4.19 is still failing for me ...

Test results for stable-v4.19:
    11 builds:  11 pass, 0 fail
    22 boots:   22 pass, 0 fail
    32 tests:   30 pass, 2 fail

Linux version:  4.19.99-rc3-g041f280e6a1a
Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

However, I am not seeing any issues with v4.14, so still not clear what
is going on here.

Cheers
Jon

-- 
nvpublic
