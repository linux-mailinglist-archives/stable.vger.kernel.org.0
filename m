Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3535E1F5
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 12:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfGCKVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 06:21:42 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11472 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfGCKVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 06:21:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d1c81b20000>; Wed, 03 Jul 2019 03:21:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 03 Jul 2019 03:21:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 03 Jul 2019 03:21:41 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Jul
 2019 10:21:37 +0000
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20190702080124.103022729@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <50efc32b-04f7-0c5b-832b-47ed08aedef5@nvidia.com>
Date:   Wed, 3 Jul 2019 11:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562149298; bh=hr/ZhWtT84oqUQwViiyP/aJXLeXExn7wqcLYVFdp5WI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qzTEmwAHHEvHdnoTZ7oCRA2DC0HXKCK9EBvf0JKV28KggV8/R1cG3kIuqP6yno0nG
         PAwJLozskFGrk+F5Xeqs29sxiMhJZK94StYxc4ZUCYC1anbyr4jOu97ZbpJmwJ6VJ7
         1H0+IcTJ3MPx4hOcI3GrAP2dcWhydgwXgwKrijWNRT1cCWclEnpVTkx+apy0b5vufb
         0H0tPe5xkhWfWR+GVjS1bkyFPDZxdssh+RLSOo+yT23uC2U+QunxAxhXBF9wXRL60X
         qoazZwrka2kcLB/WwzUoUq6y4eqk+FW/dhADcZ+3UPk298SDtICb3uQfkqDiJiLU7F
         ebLoiCSgSdMZw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/07/2019 09:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.16 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.1:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.1.16-rc1-gbe6a5acaf4fb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
