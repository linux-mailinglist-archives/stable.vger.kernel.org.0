Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FFA12FBD1
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgACRvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:51:18 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9077 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbgACRvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:51:17 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e0f7f050001>; Fri, 03 Jan 2020 09:51:01 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 03 Jan 2020 09:51:17 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 03 Jan 2020 09:51:17 -0800
Received: from [10.26.11.112] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 Jan
 2020 17:51:14 +0000
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200102220029.183913184@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cdd15d65-d387-a98a-10e0-061d511ca157@nvidia.com>
Date:   Fri, 3 Jan 2020 17:51:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578073861; bh=c69MMTz7d9shlIgO2zi1fiYx+EDfZK8tewvOAedqSRw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=VciMxoA0dFdVibazTRgxlXCW/E1nEBO5Z4YzluenieuzddVRw988wbt+TBEzDe9Q+
         QoBs/k6CqsfwXFQpxBFHxdCFwvMHDFhrgWQ+VRpLL8q3DO3nGg7N2NBEwfReu2O2rc
         D4VApCmKkg9jo+Oe9KfcvEUbKDExXnwXWY7UF7m+Ptm3EyLNywz8JmWRq6EU3n6mpb
         QgmyYBmTk8W3mgaCEgFtu5+HexsybSU7UB6JtK30K/G/meQcm6vJ7koEs6hJYerNvu
         e/zDZ4WB4bCUj6Lmuf1NnXWyEgQDoQ5SR2s5IAyPw9YLccpd3yjfVr62bSq7kH4q3f
         JAu6SOdDZFe8g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/01/2020 22:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.93 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.93-rc2-g6a2e2a4c865f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
