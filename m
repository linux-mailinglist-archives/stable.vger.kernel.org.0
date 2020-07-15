Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8573C220A82
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 12:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgGOKuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 06:50:18 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8298 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgGOKuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 06:50:18 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0edf5c0002>; Wed, 15 Jul 2020 03:50:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 15 Jul 2020 03:50:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 15 Jul 2020 03:50:17 -0700
Received: from [10.26.73.219] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 15 Jul
 2020 10:50:13 +0000
Subject: Re: [PATCH 5.4 000/109] 5.4.52-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200714184105.507384017@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <84ad3c06-4d64-f0bf-da8c-d445e3f3ffe1@nvidia.com>
Date:   Wed, 15 Jul 2020 11:50:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594810204; bh=UTR7pZ+NSqR31LZGhFuSYd/bbIZrbDL+PLrVHYoHWRE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=QJb05o/Xe2CIU5edT04zQ7ny8fD+woDt0oNXbwoGtrpfKt6BpzXwhwaP7xRoVI1+A
         gmJ5vqSffy77Xo+0K/plK1nOVm9o7f7t1dU/ldtISZ3RD8cElxtY4iPv8qNBmNYotn
         wvCXXmis1daXets1QbX1JaZp3hfoXNnOAjAZz2uGlGRtZeicXQwiI3UAQziIDSBc+s
         wei5Fk7vlHtw7maqhwDxRdqyR1Pg8a3ZEnZ8g7wKkuIjrXP5b+vOTQN0xRBP/CkvNI
         jEOVn0XayUvuCHwRIvMNVCqsy9hym9PF0LTLOY36CmWgpy6fMCKYDZwrbbwFvAV4t6
         2QsnLojeZuR1Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/07/2020 19:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.52 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.52-rc1-ge41ac96492ed
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
