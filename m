Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16C12FBC4
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgACRuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:50:14 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1619 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgACRuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:50:14 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e0f7ea90000>; Fri, 03 Jan 2020 09:49:29 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 03 Jan 2020 09:50:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 03 Jan 2020 09:50:13 -0800
Received: from [10.26.11.112] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 Jan
 2020 17:50:11 +0000
Subject: Re: [PATCH 4.4 000/137] 4.4.208-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200102220546.618583146@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8ec1de48-0ff3-43b1-21d7-d92b4bc6dcc1@nvidia.com>
Date:   Fri, 3 Jan 2020 17:50:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578073769; bh=Cp7XPek7Wl9pjXUyNXbtwIG0rR+D3LeU3GEP9AzNfeU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=H7e8GurwzlDDuCCEMcbV7v1N4+iS5YgdsrjUPwgnsG0Yvtc2moppcRIg7lf7AC5B5
         mFoMUBhg5KG50gYeoSm2p1mVr5yozLtW9OiR7260xnazTFTuqAmjvKI59+FnEyQM57
         APK83cTHw9SSeWi4uU4eSH4/EXMeRaK3dO3lEVzQ9hjGGADTHv7t9fcs3wETwn8La/
         HL3eK/M8fBb5pl7vI1HayEIHAiRQu8sy1Yvkr1tcJqaZ2He8PkWi8tr85D1cbzvueH
         iBpAcYP6tNjGsQ/+n6HKAylI1DOb1eDbNBeIXYGtIkncysmBk4kot9aotfEneJK93E
         /nE2yrgZ45HoA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/01/2020 22:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.208 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 22:02:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.208-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.208-rc1-g8eb04883f217
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
