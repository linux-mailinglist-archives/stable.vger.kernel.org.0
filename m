Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87264312566
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBGPey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:34:54 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11643 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBGPex (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 10:34:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602008750000>; Sun, 07 Feb 2021 07:34:13 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 15:34:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 7 Feb 2021 15:34:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/32] 5.4.96-rc1 review
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2699e9cd68374fb7bc22ab96aaf26d89@HQMAIL109.nvidia.com>
Date:   Sun, 7 Feb 2021 15:34:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612712053; bh=npWIfBbKzewW0MVjvW38z3rsrVwXbPEf2Sxl8P8y1mI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=J9JK+HtiN2fjlQYFzxQqm+IcVfI15wdr0mtD5J8BO2vH9vYDhLYJzgLQBVLBu9xUG
         JamFr2LbVxtNrr2MBeEvAAaWTEklnorLiQi0h3zzMd0q/cwh3PbaNt28Uep/YuL5yA
         3W61yF+efatARznW8eV6NWQPTmiyWARSKB2LQPb8K3QrgvasbannoIH4EHhkb/aeIW
         dvLOI51oynCryw8b627VkPTFIyEBoHqUNOXFMbBvAga9V9+mJXJp2NEloTozQJm35r
         iMvNogqHFgqrHEOdJ8jTzl5ynZSNuokknopg8yJ+L8VYxfj2pLZXIXxU2kAw9VoooY
         yzQzPoS5XR8vQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Feb 2021 15:07:15 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.96 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.96-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    57 tests:	57 pass, 0 fail

Linux version:	5.4.96-rc1-gda7c9d56bab5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
