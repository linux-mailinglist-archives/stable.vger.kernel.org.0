Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EAE14954A
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 12:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAYLdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 06:33:08 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12075 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAYLdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 06:33:08 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2c27440000>; Sat, 25 Jan 2020 03:32:20 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sat, 25 Jan 2020 03:33:07 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sat, 25 Jan 2020 03:33:07 -0800
Received: from [10.26.11.150] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 25 Jan
 2020 11:33:04 +0000
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
 <20200124173659.GD3166016@kroah.com>
 <8a782263-aca3-3846-12a0-4eb21f015894@nvidia.com>
Message-ID: <87fcb1f0-b1b8-a6e2-b8f6-b95a07f67919@nvidia.com>
Date:   Sat, 25 Jan 2020 11:32:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8a782263-aca3-3846-12a0-4eb21f015894@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579951940; bh=5uX1s/9t9VDPUmWZvxsiTCjNWLCYbyyF6/dJ+3YHqBI=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=g9yNRH+f4Go/OS/kwHzJ5irvQQwk67ixAiuDb9zKPOFQNyZo1aZGaF3sjliL/1Qrh
         BNIaElWaUNjy6XcRbk8p9RxwmfpffhrhORFxf1ex6z4t9UN7dqTgW5s/vi9qoBaG5H
         UtpZYiwksKGkef/SORAFH8lXYzjCm3vmTfBMabcn8BenTTi0ju9Hc4YQVg3uGc06B8
         xiJMmAFKhWO6ovKFHRNqHuS4fZu+dxZhZV2sxaI0NdisM7I5+mOvgmPQ3qhG/xqCce
         Z43BTsU0hzEys8xKvYLAltrdrOO1uUJ0SEQKJbd3rEn+GfC8edCjP3iE5MzSz9dvgp
         Nh113M9PapWNQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/01/2020 18:07, Jon Hunter wrote:
> 
> On 24/01/2020 17:36, Greg Kroah-Hartman wrote:
>> On Fri, Jan 24, 2020 at 02:50:05PM +0000, Jon Hunter wrote:
>>> Hi Greg,
>>>
>>> On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.19.99 release.
>>>> There are 639 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
>>>> or in the git tree and branch at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> -------------
>>>> Pseudo-Shortlog of commits:
>>>
>>> ...
>>>
>>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>     PCI: PM: Skip devices in D0 for suspend-to-idle
>>>
>>> The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
>>> Reverting this on top of v4.19.99-rc1 fixes the issue.
>>
>> This is also in the 4.14 queue, so should I drop it there too?
> 
> I did not see any failures with the same board on that branch, so I
> would say no, but odd that it only fails here. It was failing for me
> 100% so I would have expected to see if there too if it was a problem.

Hmmm, rc2 still not working for me ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	30 pass, 2 fail

Linux version:	4.19.99-rc2-g24832ad2c623
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

I still see the following commit in rc2 ...

commit bb52152abe85f971278a7a4f033b29483f64bfdb
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Jun 13 23:59:45 2019 +0200

    PCI: PM: Skip devices in D0 for suspend-to-idle

BTW, I checked the 4.14. queue and I do not see the above change in
there, however, there is similar change ...

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Avoid possible suspend-to-idle issue

Cheers
Jon

-- 
nvpublic
