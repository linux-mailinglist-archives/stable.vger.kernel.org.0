Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2610D2DA9F5
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgLOJV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:21:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12015 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgLOJV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 04:21:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd87fe00000>; Tue, 15 Dec 2020 01:20:32 -0800
Received: from [10.26.73.104] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Dec
 2020 09:20:29 +0000
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>
References: <20201214170452.563016590@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a1bff7f4-f6e9-506c-2c9f-5e7feba90acb@nvidia.com>
Date:   Tue, 15 Dec 2020 09:20:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214170452.563016590@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608024032; bh=aVeWOMFVKMfDrIRqqkjUGH1g+Dw9sqCv0sGD4tQrR9U=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=rvZRDtB7GTnO+SOPrWKQGlthOz500rPzBDKxs1pPVme/fCaISY8mbYnZgMcouorZx
         sru4yTloSsAYCnyOe96cdarR2lPXRLuuVEFLUSk4tz+rclGtWkb6rYt192iNCGnc9g
         AT3+RZNagRGywdS3/TG15BU1EmAXwX7d8I8T7Yp6O8Pc2biH6GD0exmUmR/OC2Rbru
         8sylbzsXqtpjJYvyhzYvFrpBfIodJNy0gWJxsNA/hlacaVHvxkhRVAWGnJgLL8B+YC
         iXAi9h2OllyQgk33+8kdO2Z5OYru0VJlSEpfyjOhDmVdBHpjWQysaXbCOqsCvIA/n2
         BRPKHteb3lIlg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 14/12/2020 17:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Test results for stable-v5.10:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	63 pass, 1 fail

Linux version:	5.10.1-g841fca5a32cc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Some changes in v5.10 exposed a minor issue in the kernel that can cause
a blank line warning to be seen. The above test is failing due to this
blank warning. Thierry has posted a fix for this [0] and should be
merged for v5.11. It was not tagged for stable, but if you OK to pull
this in once in the mainline I can send a request. Otherwise all looks
good, so ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

[0] https://lore.kernel.org/patchwork/patch/1336079/

-- 
nvpublic
