Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8411139524
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 16:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgAMPsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 10:48:01 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1428 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 10:48:01 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1c911d0000>; Mon, 13 Jan 2020 07:47:41 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 13 Jan 2020 07:48:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 13 Jan 2020 07:48:00 -0800
Received: from [10.26.11.97] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jan
 2020 15:47:57 +0000
Subject: Re: [PATCH 4.14 00/62] 4.14.164-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200111094837.425430968@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <17085aef-4a87-5d56-3b36-1051559292fc@nvidia.com>
Date:   Mon, 13 Jan 2020 15:47:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578930461; bh=YlEAkKaz04Q1ui63iZV6FoMN+8nVud8YmO8YlXI6B6Y=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=VuTGKnJgTXZw1rWF63/d0DxI3B7TImLE0GIIPn/WwSBj6ifNkmo0sOQ8vQMmEtCAt
         kAWB4PqZq3qypy+IRaNOh4pdbiql30zkLh1ljijsRiaykXAk5cSQHXeMpbZFJuY5l5
         FxrCc5gBDUQEQZksdnZO80/vY9irYSwoSsLsrnxOinvCnV2phlq+OQFhlKobwcyd5o
         T3yXchWWrsW3t/nCyd45bHjAKW9JHfb3PbWhz1lY4YILpNiF9dp09rCbK03xAjSS5R
         sxBRcdcKR/snrCTytcsb5K9T6hPt1+pQavki/BCaeI2cQmO8ups4lqMyO677TRiour
         qM2PExW9GAIbQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/01/2020 09:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.164 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    21 tests:	21 pass, 0 fail

Linux version:	4.14.164-rc1-gf19c9ce58066
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
