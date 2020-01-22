Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3ACC145844
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAVO5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:57:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10896 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVO5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:57:51 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2862e00000>; Wed, 22 Jan 2020 06:57:36 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 22 Jan 2020 06:57:51 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 22 Jan 2020 06:57:51 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 22 Jan
 2020 14:57:48 +0000
Subject: Re: [PATCH 4.4 00/76] 4.4.211-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200122092751.587775548@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7bae5fcc-95ae-3a4b-1a00-8b055e63abe1@nvidia.com>
Date:   Wed, 22 Jan 2020 14:57:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579705056; bh=VAhuBwoTTvdOhDx/lfQB1bjfymxwZYEuPe9wC/lOXrY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=QxEg2CrABLy9GdwFKB4K/n4Bw4+GmdBJVT89DlSlaZPwgMnWdpg9x1R4ssBlJ392S
         mEn1RfgwTc9l6hnAYr/gvbPHT6KEEKiEFNZWFEPK7sITvRcZ64yK860tGebmY/hSLP
         lyQmEdnqqUQ97iTzSuxzsrFdMbMyKHVo65ddQjwZbEPXcBmcWYV7/aYfUTkisdS8K2
         b/yvupoX7wSffk4JT9spSGW3q4c6uSN7CExooiy0gLVko64KgKpwv09r8ZJe9lXghW
         3WJwlGAU5YJro+QwQhTXVTCD0zWdA+hDLC5k++9Gccq4PM51+0Xxa+jSSULtDiUieQ
         o5C4Fz7oKye9Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/01/2020 09:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.211 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.211-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.211-rc1-g14fe1f1189f5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
