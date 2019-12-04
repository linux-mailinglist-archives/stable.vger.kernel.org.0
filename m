Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E77112DCB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 15:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfLDOxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 09:53:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10230 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfLDOx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 09:53:29 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de7c8640000>; Wed, 04 Dec 2019 06:53:25 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 04 Dec 2019 06:53:28 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 04 Dec 2019 06:53:28 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 14:53:26 +0000
Subject: Re: [PATCH 4.19 000/321] 4.19.88-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191203223427.103571230@linuxfoundation.org>
 <79c636e7-145b-3062-04a3-f03c78d51318@nvidia.com>
 <20191204112936.GA3565947@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4f1552b1-ff6b-7342-b66e-04685aacf6ea@nvidia.com>
Date:   Wed, 4 Dec 2019 14:53:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204112936.GA3565947@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575471205; bh=pKQ4dcP1Vhq7519pIbBUF5wIUt54ljjOZI1JZjZzBpA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=kqxgzo71shZdTNaZbvnM0+x+fnWmZn5TbLgZO1InYj3brllXzFQSUnuPIRZDrYrQb
         Ir4YqZ+lriKcvLrmTHS5r0HvlE1stBlo+zJ6n/85rvO4BFmXYKPEZWycKM8AO4JBFm
         hJq63SlU0MYQXNYYSr4IFuh6yUnrStunXbGmfh9es7tvJ68tyJETKU4iH2Ok0qi1hm
         rHKiLghwuPoK9OWyOzAMsu8DNdsAfpIX7q+Bi9MJf/ZcK91h931nq+2ktvQQtsbmjY
         a19FJaax48W4TxHmzx8k14t7H+4iZXSc+u/x3ozuEt95dgOosw9siqXFMyNhscpXQE
         VXlbfU2wD1YYw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/12/2019 11:29, Greg Kroah-Hartman wrote:
> On Wed, Dec 04, 2019 at 09:45:31AM +0000, Jon Hunter wrote:
>>
>> On 03/12/2019 22:31, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.88 release.
>>> There are 321 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 05 Dec 2019 22:30:32 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.88-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
>>> Ding Tao <miyatsu@qq.com>
>>>     arm64: dts: marvell: armada-37xx: Enable emmc on espressobin
>>
>> The above commit is causing the following build failure for ARM64 ...
>>
>>   DTC     arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb
>> arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb: ERROR
>> (phandle_references): /soc/internal-regs@d0000000/sdhci@d0000: Reference
>> to non-existent node or label "sdio_pins"
>>
>> arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb: ERROR
>> (phandle_references): /soc/internal-regs@d0000000/sdhci@d8000: Reference
>> to non-existent node or label "mmc_pins"
> 
> Thanks for letting me know, I'll go drop this one and push out a -rc2
> with that removed.


Great! All tests now passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.88-rc2-gba731ec12c66
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
