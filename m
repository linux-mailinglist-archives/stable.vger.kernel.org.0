Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB6945A67
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 12:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfFNK24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 06:28:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8437 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFNK24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 06:28:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d0376e70000>; Fri, 14 Jun 2019 03:28:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 14 Jun 2019 03:28:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 14 Jun 2019 03:28:55 -0700
Received: from [10.26.11.12] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Jun
 2019 10:28:51 +0000
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190613075649.074682929@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <60b641fc-7bea-d381-beff-7d12276170e8@nvidia.com>
Date:   Fri, 14 Jun 2019 11:28:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560508136; bh=E9+UbLxj1D9d2tY2BmdXqrvNA9w3PmpGHJgAhdtD4Bw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=U4ZsmCYH6vsenaFyEAX9nr62JUyMfg/zx+LQ1s7kM6fERYfr+LsBYpiMVdx4SdaMI
         SHCnkTT3EA4UgPc7iPHKmhHT6G+i0usU6TI4Lx90yx6Dy1zKRZfnYQhTg/TozT2MFP
         6c0Sawb0ttpLE4bDz505CsOHNXyUlWZXU7h/qOUSjRKdR5iimYzHOZoGysJoQ5EN8p
         85pyErmBptZOac13AAOGBotdDx7sN/70qoIfXGsujQdSywwWHx8TuDSyh3OQ//1tPz
         LinODK5Z9gqtYsnYwwIYJw9Rfw2wDmKpLSsMS7SoKkykYhTuw+c9rAEHWS43M7ssa5
         S/veKg3Q8B0gQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/06/2019 09:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.126 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.126-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.126-rc2-g743300ca6410
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
