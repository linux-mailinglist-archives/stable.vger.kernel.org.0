Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B004B9F5
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfFSNa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 09:30:56 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9995 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFSNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 09:30:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d0a390e0000>; Wed, 19 Jun 2019 06:30:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 19 Jun 2019 06:30:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 19 Jun 2019 06:30:55 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Jun
 2019 13:30:52 +0000
Subject: Re: [PATCH 4.14 00/53] 4.14.128-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190617210745.104187490@linuxfoundation.org>
 <c4c6c3f5-2117-2db2-58a8-1a84143dc034@nvidia.com>
 <20190619104600.GC3150@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <af010d53-ae9e-6550-326c-8ad9e705d8fa@nvidia.com>
Date:   Wed, 19 Jun 2019 14:30:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190619104600.GC3150@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560951055; bh=rFp82irGjb0gaWL1wPP4SC4eXNA2T1JuN30K/GQBJso=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UkCId7pBG7OObHFbd0HZAMffQxtgtJDSvXB/CbntoAm2e6Wl1txq3Z4Av3TKX9aZY
         ouReBTULRkgvf/8ziuruvCJd7f0ihexSukjCP/LOKp3YvOOoGluRjxbx7ov25mS08+
         AT9yUD3bzwODmPC1uEfl7Yjp7crd292tp5wGZaAmHnYXolepmAL6Re105af9mNUktF
         5xJQbdOARUg97rduwiArOFEpDevRcEdkHpJje3UvrGreN3qoSN46fgOnal1O0yYbxQ
         BCLsFe6NgbqllSs1YeZGsJNk6uUMJFz1Qyr4ouHztomyrKfaq3tiTqdAPqBhQ462CD
         JMZ6RhCdZjWfA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/06/2019 11:46, Greg Kroah-Hartman wrote:
> On Wed, Jun 19, 2019 at 09:49:00AM +0100, Jon Hunter wrote:
>>
>> On 17/06/2019 22:09, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.14.128 release.
>>> There are 53 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.128-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> I am still waiting on the test results for 4.14-128-rc1. The builds are
>> all passing, but waiting for the tests to complete. We have been having
>> some issues with our test farm this week and so the results are delayed,
>> but should be available later today, I hope.
> 
> No worries, thanks for testing all of these and letting me know.

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.128-rc1-g16102d7ed840
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
