Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5750E27D27E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgI2PPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:15:38 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2794 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgI2PPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 11:15:38 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f734f670007>; Tue, 29 Sep 2020 08:14:47 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 15:15:37 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Sep 2020 15:15:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/245] 4.19.149-rc1 review
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ca74542567404778a86cf9eb973a3fbf@HQMAIL101.nvidia.com>
Date:   Tue, 29 Sep 2020 15:15:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601392487; bh=SM3myhNjOKq9bZsG9ra6H+4s2X6p7yJwTdBbW/wJIqM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=VGJvxeNi8EYuWAzgCmV2Vx1wzUgD/nNKiRRHyFqA8RVUZxddnICcXwLmRM1dq30sb
         fM79szufaHJAB9taCyPsKHsuvWUlNG8dP7/oBlxGNX6khTHePhQW8O6JIL8OME+Wop
         beHPPRFyDTFy/AFhYuHjIqxiyppKahnECgEydDiR7xOA9NjIbQRkjeDuQea8MONrSo
         Q3UBLNKceJ+8tg9+eW/o2MMAA1c4v3Y8LXJWimDptnukM9xAfoSOQvmRafE4pj8Wbw
         4LyJx4JSRyq+vcxcs75UkmX/Om4B3oci4aJC/yZQrF6cy5V5d5ImI51PyJoZOeKdgG
         RH/D9HIdu87PQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 12:57:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.149 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    14 builds:	14 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.149-rc1-gf0a043791d0e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
