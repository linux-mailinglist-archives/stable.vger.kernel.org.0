Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBDF67979
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 11:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfGMJRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 05:17:04 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11587 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfGMJRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 05:17:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d29a1890000>; Sat, 13 Jul 2019 02:16:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 13 Jul 2019 02:17:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 13 Jul 2019 02:17:03 -0700
Received: from [10.26.11.249] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 13 Jul
 2019 09:17:00 +0000
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>, <j-keerthy@ti.com>
References: <20190712121628.731888964@linuxfoundation.org>
 <4dae64c8-046e-3647-52d6-43362e986d21@nvidia.com>
 <20190712153035.GC13940@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5f897de4-b423-c8a2-6823-d0227eb7bd38@nvidia.com>
Date:   Sat, 13 Jul 2019 10:16:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712153035.GC13940@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563009418; bh=E5LNyDwLy+cln6E5INJM7vD79nJvpSCMoFYj77OnrsE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FVt01OIRAHI79SzO9LxYqk5ylxPRql5OfT/L2SQ6msTkbQU4hri/R1h20bDWqNrH0
         I+PMJVWybz2HsHCx5AjlJUqWWgf8PGCpZLT5Ytk4mTPlL/IOeZyyOsGD18FTOWe908
         HGjHJtTr0cVFtLa5TqCl9RDxA5aj/gFuPB8WZBvOOhP108DqPK6lSr5x3F+CoB5U4g
         vcfRJ+ngjlb9NIPr/OyhHiSiFa5+W5qVqK1pCHS98AE6TAOip2IdSojlUObc4oS8pt
         ZN6woOYuvhUn74iMOvmgEkABsdPu/yvzGDjhTthk3Zw+WodXEfDlntvaMCmgcJr0Fv
         5YWsYdINIOgDA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/07/2019 16:30, Greg Kroah-Hartman wrote:
> On Fri, Jul 12, 2019 at 02:26:57PM +0100, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 12/07/2019 13:17, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.1.18 release.
>>> There are 138 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
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
>>> Keerthy <j-keerthy@ti.com>
>>>     ARM: dts: dra71x: Disable usb4_tm target module
>>
>> ...
>>
>>> Keerthy <j-keerthy@ti.com>
>>>     ARM: dts: dra76x: Disable usb4_tm target module
>>
>> The above commits are generating the following compilation errors for
>> ARM ...
>>
>> Error:
>> /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:15.1-9
>> Label or path usb4_tm not found
>>
>> Error:
>> /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra76x.dtsi:89.1-9
>> Label or path usb4_tm not found
>>
>> After reverting these two, I no longer see these errors.
> 
> Both are now dropped, thanks.  I'll push out a -rc2 with that changed.

Hmmm ... -rc2 still not building ...

Error:
/dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:11.1-11
Label or path rtctarget not found
Error:
/dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:15.1-9
Label or path usb4_tm not found

I still see the following commit in -rc2 ...

commit 0caa574b3244cd863dd74bde680a6309cb8803ad
Author: Keerthy <j-keerthy@ti.com>
Date:   Fri May 17 06:44:09 2019 +0530

    ARM: dts: dra71x: Disable usb4_tm target module

In -rc1 I see there were 4 changes from Keerthy, any chance you reverted
one of the rtc patches and not the above? Looks like the following is
missing from -rc2 ...

Keerthy <j-keerthy@ti.com>
    ARM: dts: dra76x: Disable rtc target module

Cheers
Jon

-- 
nvpublic
