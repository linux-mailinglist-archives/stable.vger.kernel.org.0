Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA392909E7
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410570AbgJPQqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:46:01 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16106 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410569AbgJPQqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:46:01 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f89cdef0002>; Fri, 16 Oct 2020 09:44:31 -0700
Received: from [10.26.45.122] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 16:45:59 +0000
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20201016090437.170032996@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <49d8a1d6-ca91-bc8f-2fe5-7189a9ad8ca7@nvidia.com>
Date:   Fri, 16 Oct 2020 17:45:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602866671; bh=+xvcxOhPyG5ELR2Ghp2UOyUyJTNNQxoBKvGco6Iymx0=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=Z+1IeAQF3WCgPLPd3bRCTHD0GO59XohpyohGi7fFfs3j52AzWjNWjv8sL3Ei9DzR8
         80U6X0iPKSExotUlBkrzua+C9FapAZUE2iZte1Dz0+zgcJTPJO/oxD404SzaWMK86G
         Pgv8tX1terBnITdWbMTBF7ETpiyvjqbJWWzzqtTKb80KNjowyvOor5CqawbGNDm/W9
         B7ubakbYKwxK0nrC7j2F+OSO1Uo2SxiCqJQLXlRZWP0AyoJ9FwXcXJjKOo5oKVntoR
         G1XQHbiDO9JfnAAVISvzBkBdAn/168baCwvhXPa4l53kAxhA7PqVZF/2pTynIfT2x9
         1kMelwastkcoA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/10/2020 10:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


There is one test failure (new warning) for Tegra194 but this is a known
issue for v5.9 and is fixed by Viresh's change [0]. Maybe we can pull
into stable once it is merged to the mainline?	

That said everything else looks good ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    61 tests:	60 pass, 1 fail

Linux version:	5.9.1-rc1-g1cbc5f2d0eac
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

[0]
https://lore.kernel.org/linux-pm/37c3f1f76c055b305d1bba2c2001ac5b1d7a9b5f.1602565964.git.viresh.kumar@linaro.org/

-- 
nvpublic
