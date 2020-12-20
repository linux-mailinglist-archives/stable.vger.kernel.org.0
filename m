Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71652DF592
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 14:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgLTNmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 08:42:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8693 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLTNmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 08:42:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdf54800000>; Sun, 20 Dec 2020 05:41:20 -0800
Received: from [10.26.72.208] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 20 Dec
 2020 13:41:18 +0000
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20201219125339.066340030@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cf66826d-0de4-da22-da2b-809856d3cfb2@nvidia.com>
Date:   Sun, 20 Dec 2020 13:41:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608471680; bh=Rzq0MSxiBeaq0bD5VHmLUntdsrEBy7AI/RlrYnWe4QA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=ccPplzCdDaNvsGNxU21Sdn6ONCxIkPw14U4aMYBlV1S2YoMmKdu5GuNpYDOUtK1q4
         9QPf+t0aOAMv1Cjv3o4HGrQ9Y/U24v6ripjMZxBUdYKunubf9mH3R65ehllMzaw59h
         IR4ZiySjS+BwJO6mC75UOoRZbA+kgDPvCfJMtTRPBhdLRhePKnP+vJZA/agXTL5uAs
         R0Wh0Tj+CNIWH/95fllZcO1cpLOEcd5JHMMsN9vlP/EQpH35nhVytY42rH3rl0azoj
         ltqzLmOKm/sEc5mQQWfHU1z/fkXvKpKaEx4CuOsLgjoWujWcNcHPIdJsgzpiIOiLbS
         SHecb9jpCFyBg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/12/2020 12:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	63 pass, 1 fail

Linux version:	5.10.2-rc1-gc96cfd687a3f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Same warning failure as before. The fix for this is now in the mainline
if you would like to pick it up ...

commit c9f64d1fc101c64ea2be1b2e562b4395127befc9
Author: Thierry Reding <treding@nvidia.com>
Date:   Tue Nov 10 08:37:57 2020 +0100

    net: ipconfig: Avoid spurious blank lines in boot log


Otherwise ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
