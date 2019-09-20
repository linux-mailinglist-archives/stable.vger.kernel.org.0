Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E562CB94CB
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfITQBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:01:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11671 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfITQBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 12:01:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d84f7e90000>; Fri, 20 Sep 2019 09:01:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Sep 2019 09:01:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Sep 2019 09:01:39 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Sep
 2019 16:01:39 +0000
Received: from [10.21.132.148] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Sep
 2019 16:01:37 +0000
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190919214657.842130855@linuxfoundation.org>
 <572eca6e-47a9-c554-c6b2-bafd4c5df18b@nvidia.com>
 <20190920142432.GA601228@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <773b556a-acc2-c3e0-14e6-956a6d0b3bed@nvidia.com>
Date:   Fri, 20 Sep 2019 17:01:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920142432.GA601228@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568995305; bh=EPR13tILB3K8Yx+WgxSj+hc46Ns/lHPYAWSp7VVIJJI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=CCA7MsxHdNMhwXukhCp4TyXgwfOTT/a9Miro5qHbLhq2Nf8Uz3EXaKHNt/ItQULwy
         1LFJqJdei6sM5d4zidDc3lQuFuoxeLN8z3AAnsLR3Rdl7XZycFLdZ6nUQS2OnlwrMt
         kCoFTxvhjy3lsn1IDXexckeTADH8HZFqpuhwv29Q3bBPEV6YVLAvZVKaTBHbme/0Gb
         Rcaje/gXs5YssoOUteszu8MKBR9rDZlERZV2tdAdW6LsP8tD+KMmXazL4Gzzto6a6H
         q7k+1Z3L4D3ANzswapSTLsm4hS5gS0sJKj3V4OQXcne/XHXh2xLMxnmilViGQdGf4+
         zoyXAHQpAVSDQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/09/2019 15:24, Greg Kroah-Hartman wrote:
> On Fri, Sep 20, 2019 at 02:54:26PM +0100, Jon Hunter wrote:
>>
>> On 19/09/2019 23:03, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.3.1 release.
>>> There are 21 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> No new regressions* for Tegra ...
>>
>> Test results for stable-v5.3:
>>     12 builds:	12 pass, 0 fail
>>     22 boots:	22 pass, 0 fail
>>     38 tests:	37 pass, 1 fail
>>
>> Linux version:	5.3.1-rc1-g0aa7f3d6baae
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                 tegra194-p2972-0000, tegra20-ventana,
>>                 tegra210-p2371-2180, tegra30-cardhu-a04
>>
>> * Note we had one regression in v5.3 for a warnings test for Tegra194
>>   causing the above test failure. This has since been fixed by the
>>   following commits [0] but given it is just a warning, I have not
>>   bothered CC'ing for stable.
>>
>> Cheers
>> Jon
>>
>> [0] https://lkml.org/lkml/2019/8/21/602
> 
> I'll be glad to take this in stable for 5.3.y, what is the git commit
> id?

OK, that would be great. The IDs are ...

commit 763719771e84b8c8c2f53af668cdc905faa608de
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Wed Aug 21 16:02:40 2019 +0100

    clocksource/drivers/timer-of: Do not warn on deferred probe


commit 14e019df1e64c8b19ce8e0b3da25b6f40c8716be
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Wed Aug 21 16:02:41 2019 +0100

    clocksource/drivers: Do not warn on probe defer


> Also, thanks for testing all of these and letting me know.

No problem!

Cheers
Jon

-- 
nvpublic
