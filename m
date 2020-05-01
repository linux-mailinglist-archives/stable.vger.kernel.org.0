Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB221C1938
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 17:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgEAPQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 11:16:49 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4437 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbgEAPQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 11:16:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eac3d540000>; Fri, 01 May 2020 08:16:36 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 01 May 2020 08:16:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 01 May 2020 08:16:48 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May
 2020 15:16:48 +0000
Received: from [10.26.73.180] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May 2020
 15:16:45 +0000
Subject: Re: [PATCH 4.19 00/46] 4.19.120-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200501131457.023036302@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <dc068c9e-92d2-c5d7-f0cd-7dec2fac374c@nvidia.com>
Date:   Fri, 1 May 2020 16:16:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588346196; bh=GjajJol/vI77Qr+RKPAviwTj5TST7txTuAVFngc2eqw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aosk1TVrOjsvs6HtMRFYpnuMTCZUIwtSfON6pjBWEamQ/c/9y62KJHhN12eshT8yC
         YmIeuSE09KLQEKAkqC+htJJYl5dK0MYpq95aqL5xUI+wBi18Kvmmx5YkIO1JLLOSyx
         VaPINZUimPp3JwWZP41nFHwla8EdlPufPlO4aU11p/ctNfGJiX8XqpxZnkMjdYU/tg
         O4JRx4w/Y/o/lX06Cw7KTE75cs+yX10YcRqkK21z/5+O0ArXDEfVVbk9UOrUq5FcR2
         7BPrFjyYO/GUA5xliATkBzCAkL+o2MjU6y6/NH6YCRyNPzvgQI9xtg0onFrQ7uy2qy
         5c35HlGYhY3/w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/05/2020 14:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.120 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.120-rc1-g81d4e31e1418
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
