Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4DF283DBD
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 19:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgJERuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 13:50:44 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19199 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgJERuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 13:50:44 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7b5cbc0004>; Mon, 05 Oct 2020 10:49:49 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 5 Oct
 2020 17:50:42 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 5 Oct 2020 17:50:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/38] 4.19.150-rc1 review
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
References: <20201005142108.650363140@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e9f40ba74330420da5c98d23028a637f@HQMAIL101.nvidia.com>
Date:   Mon, 5 Oct 2020 17:50:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601920190; bh=4ivQjfu379rfIHjGypK103vz+32DsQW6CBwO3N7zP5w=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=sDxiKn07I70CW9H5IoI3f5zDjU37DkQtwnI8cNL/Dc4X9DQJpc875/SggEWBFJVy/
         K9H4rDWGg2oV6II3OUPxq3uRw5w+BRXdS8nVxrK34JifN0AIHy0+1XJp7/EppFbavI
         RgqR2asnTSdsnbbmj0r8hfzF0LSgFv4+lv56LtgoAT2UGHxZR3eePROaOzM1tr6Hrf
         SLRWyVfbl6585Og1IJWk4EQo9fRoKoDS5NCrnEf8m7VqQPa+SbUduwX5IFDLDqYqW6
         qabWk6vr08BrU6E2BYOi+YuNaZJ/r8CRKtefGTaIrsGw5rkejOxQzyt/zDSoNosK6q
         TADtSbBO/atMg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Oct 2020 17:26:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.150 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    15 builds:	15 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.150-rc1-g204463e611dc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
